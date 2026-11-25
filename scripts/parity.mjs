// The parity sheet (architecture §9.1, §9.7): `pnpm parity Button` (or
// `--all`) shoots every state of a web component's stories and of its Flutter
// twin's parity cases on the phone and captain surfaces, at 360 logical pixels
// and pixel ratio 2, and writes `.parity/<Component>.html`: one row per state
// and surface, web at the start, Flutter at the end, both at their natural
// size. A human review on the host, never a baseline: nothing in CI runs it.
//
// The Flutter cases are `parityCase('<story id>', …)` calls under
// packages/core_ui/test/parity/ (tagged `parity`, skipped unless
// --run-skipped); the web side is the `parity` Playwright project of ui-web,
// which exists only when FD_PARITY names the stories.
import { spawnSync } from 'node:child_process';
import {
  existsSync,
  mkdirSync,
  readdirSync,
  readFileSync,
  rmSync,
  statSync,
  writeFileSync,
} from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

import { pinnedFlutterBin } from './verify-support.mjs';

const ROOT = path.resolve(import.meta.dirname, '..');
const UI_WEB = path.join(ROOT, 'packages/ui-web');
const CORE_UI = path.join(ROOT, 'packages/core_ui');
const CASES = path.join(CORE_UI, 'test/parity');
const SURFACES = ['phone', 'captain'];
const RATIO = 2;

/** Where a side's shot of a story on a surface lands, relative to the repository. */
export const shotPath = (side, id, surface) => `.parity/${side}/${id}-${surface}.png`;

/** Where a component's sheet lands, relative to the repository. */
export const sheetPath = (component) => `.parity/${component}.html`;

/** The story ids of the `parityCase('<id>'` calls in Dart sources, optionally of one id prefix. */
export function flutterCases(sources, prefix) {
  const ids = sources.flatMap((source) =>
    [...source.matchAll(/parityCase\(\s*['"]([^'"$]+)['"]/g)].map((match) => match[1]),
  );
  return prefix === undefined ? ids : ids.filter((id) => id.startsWith(`${prefix}--`));
}

/**
 * One row per state and surface: the stories in their order, then the cases
 * no story has, each on the phone then the captain.
 */
export function pairRows(storyIds, caseIds) {
  const cases = new Set(caseIds);
  const stories = new Set(storyIds);
  const ids = [...storyIds, ...caseIds.filter((id) => !stories.has(id))];
  return [...new Set(ids)].flatMap((id) =>
    SURFACES.map((surface) => ({ id, surface, web: stories.has(id), flutter: cases.has(id) })),
  );
}

/** The width and height of a PNG, from its IHDR chunk. */
export function pngSize(bytes) {
  const signature = '89504e470d0a1a0a';
  if (bytes.length < 24 || bytes.subarray(0, 8).toString('hex') !== signature)
    throw new Error('Not a PNG');
  return { width: bytes.readUInt32BE(16), height: bytes.readUInt32BE(20) };
}

const escape = (text) =>
  text.replace(
    /[&<>"]/g,
    (char) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' })[char],
  );

function cell(present, missing, bytes) {
  if (!present) return `<td class="missing">${missing}</td>`;
  if (!bytes) return '<td class="missing">no image</td>';
  const { width, height } = pngSize(bytes);
  // Drawn at its CSS pixels, so both sides keep the same scale.
  return (
    `<td><img width="${width / RATIO}" height="${height / RATIO}" alt="" ` +
    `src="data:image/png;base64,${bytes.toString('base64')}">` +
    `<p>${width} × ${height}</p></td>`
  );
}

/** The sheet's page; `read(file)` returns a shot's bytes, or null when it was not written. */
export function renderSheet(component, rows, read) {
  const body = rows
    .map(
      (row) =>
        `<tr data-id="${escape(row.id)}" data-surface="${row.surface}">` +
        `<th>${escape(row.id)}<br><small>${row.surface}</small></th>` +
        cell(row.web, 'no story', row.web ? read(shotPath('web', row.id, row.surface)) : null) +
        cell(
          row.flutter,
          'no Flutter case',
          row.flutter ? read(shotPath('flutter', row.id, row.surface)) : null,
        ) +
        '</tr>',
    )
    .join('\n');
  return `<!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${escape(component)} parity</title>
<style>
  body { margin: 16px; font: 14px/1.4 system-ui, sans-serif; background: #f4f4f5; color: #18181b; }
  table { border-collapse: collapse; }
  th, td { border: 1px solid #d4d4d8; padding: 8px; vertical-align: top; text-align: start; }
  th { direction: ltr; font-weight: 600; white-space: nowrap; }
  td img { display: block; outline: 1px dashed #a1a1aa; }
  td p { margin: 4px 0 0; color: #52525b; direction: ltr; text-align: end; }
  td.missing { color: #b91c1c; font-weight: 600; }
</style>
</head>
<body>
<h1>${escape(component)}: web and Flutter</h1>
<p>Each state at 360 logical pixels, pixel ratio 2, RTL, on the surface's ground. Web at the start, Flutter at the end; sizes in device pixels.</p>
<table>
<thead><tr><th>State</th><th>Web (Storybook)</th><th>Flutter (core_ui)</th></tr></thead>
<tbody>
${body}
</tbody>
</table>
</body>
</html>
`;
}

// ---------------------------------------------------------------------------
// The run.

const idPrefix = (title) => title.toLowerCase().replace(/[^a-z0-9]+/g, '-');

function run(command, options = {}) {
  // One command line through the shell: pnpm and flutter are .cmd and .bat
  // files on Windows. Every part with a space or a regex is double-quoted, which
  // cmd.exe and sh both leave literal.
  const result = spawnSync(command, { stdio: 'inherit', shell: true, ...options });
  if (result.status !== 0) {
    console.error(`${command} failed`);
    process.exit(result.status ?? 1);
  }
}

function newest(dir) {
  let latest = 0;
  for (const entry of readdirSync(dir, { withFileTypes: true, recursive: true }))
    if (entry.isFile())
      latest = Math.max(latest, statSync(path.join(entry.parentPath, entry.name)).mtimeMs);
  return latest;
}

function buildStorybook() {
  const index = path.join(UI_WEB, 'dist/storybook/index.json');
  if (existsSync(index) && statSync(index).mtimeMs >= newest(path.join(UI_WEB, 'src'))) return;
  console.log('Building the Storybook (src/ is newer than dist/storybook)…');
  run('pnpm --filter @fox-drop/ui-web build');
}

function storiesOf(title) {
  const index = JSON.parse(readFileSync(path.join(UI_WEB, 'dist/storybook/index.json'), 'utf8'));
  return Object.values(index.entries).filter(
    (entry) => entry.type === 'story' && (title === undefined || entry.title === title),
  );
}

function main(argv) {
  const all = argv.includes('--all');
  const names = argv.filter((arg) => !arg.startsWith('--'));
  if (!all && names.length === 0) {
    console.error('Usage: pnpm parity <Component> [...] | --all');
    process.exit(1);
  }
  if (!existsSync(path.join(ROOT, '.fonts/cofo-sans-pro-arabic'))) {
    console.error('CoFo is missing: run `pnpm fonts:fetch` first.');
    process.exit(1);
  }

  buildStorybook();
  const titles = all ? [...new Set(storiesOf().map((story) => story.title))] : names;
  const sources = existsSync(CASES)
    ? readdirSync(CASES)
        .filter((file) => file.endsWith('.dart'))
        .map((file) => readFileSync(path.join(CASES, file), 'utf8'))
    : [];
  const sheets = titles.map((title) => {
    const prefix = idPrefix(title);
    // A case id may be built in a loop (`'button--${variant.name}-$state'`):
    // any quoted id of the prefix means the component has cases to run.
    const hasCases = sources.some((source) => new RegExp(`['"]${prefix}--`).test(source));
    const stories = storiesOf(title).map((story) => story.id);
    if (stories.length === 0 && !hasCases) {
      console.error(`${title}: no story and no Flutter case`);
      process.exit(1);
    }
    // A shot left from an earlier run would pass for this one's.
    for (const side of ['web', 'flutter'])
      for (const file of shotsOf(side, prefix)) rmSync(path.join(ROOT, '.parity', side, file));
    return { title, prefix, hasCases, stories };
  });

  const bin = pinnedFlutterBin(ROOT);
  const flutter = bin
    ? `"${path.join(bin, process.platform === 'win32' ? 'flutter.bat' : 'flutter')}"`
    : 'flutter';
  // One run per component: repeated --name flags must all match. A test's
  // name starts with its story id, so the anchored prefix keeps out a later
  // component whose id ends the same (`icon-button--`).
  for (const sheet of sheets.filter((each) => each.hasCases))
    run(`${flutter} test test/parity --tags parity --run-skipped --name "^${sheet.prefix}--"`, {
      cwd: CORE_UI,
    });

  const stories = sheets.flatMap((sheet) => sheet.stories);
  if (stories.length > 0)
    // The ids go through the environment: a list can be longer than a command line.
    run('pnpm --filter @fox-drop/ui-web exec playwright test --project=parity', {
      env: { ...process.env, FD_PARITY: stories.join(',') },
    });

  for (const sheet of sheets) {
    // The literal ids, then the ones a loop built, as the run wrote them.
    const written = shotsOf('flutter', sheet.prefix).map((file) =>
      file.replace(/-(phone|captain)\.png$/, ''),
    );
    const cases = [...new Set([...flutterCases(sources, sheet.prefix), ...written])];
    const file = sheetPath(sheet.title);
    mkdirSync(path.join(ROOT, '.parity'), { recursive: true });
    writeFileSync(
      path.join(ROOT, file),
      renderSheet(sheet.title, pairRows(sheet.stories, cases), (shot) => {
        const full = path.join(ROOT, shot);
        return existsSync(full) ? readFileSync(full) : null;
      }),
    );
    console.log(`${sheet.title}: ${file}`);
  }
}

/** The shots of one side whose story id has the prefix. */
function shotsOf(side, prefix) {
  const dir = path.join(ROOT, '.parity', side);
  if (!existsSync(dir)) return [];
  return readdirSync(dir).filter(
    (file) => file.startsWith(`${prefix}--`) && /-(phone|captain)\.png$/.test(file),
  );
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? '').href) main(process.argv.slice(2));
