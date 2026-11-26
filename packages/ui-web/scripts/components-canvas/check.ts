// Opens every board of the written "Fox Drop Components" canvas in Chromium as
// the canvas does: React 18 on the page (the canvas's own) with the system's
// bundle and the board's forced-states sheet, CoFo from .fonts/, for every
// combination its Tweaks and scenarios reach: the playground at its Tweaks, its
// props changed (each boolean flipped, each choice its last option), and each
// scenario (story) loaded. Reports a missing component or value, a page error, a
// console error or warning, content wider than its panel and content taller
// than its board. With --measure it writes each board's natural height (its
// tallest combination) to heights.json and the class names on it to
// classes.json, which canvas.ts reads. Usage:
//   pnpm --filter @fox-drop/ui-web components-canvas:check [--measure] [Name…]
import { execFileSync } from 'node:child_process';
import { createReadStream, existsSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { createServer } from 'node:http';
import path from 'node:path';
import { chromium } from '@playwright/test';
import { PACKAGE_DIR } from '../bundle.ts';
import { OUT, PROJECT } from './canvas.ts';
import { renderBoard } from './render-board.ts';

const flags = process.argv.slice(2);
const measure = flags.includes('--measure');
// --shots <dir>: a picture of each board at its Tweaks, for the owner (outside the repository).
const shotsAt = flags.indexOf('--shots');
const shots = shotsAt === -1 ? undefined : flags[shotsAt + 1];
const only = flags.filter((f, i) => !f.startsWith('--') && (shotsAt === -1 || i !== shotsAt + 1));

/** .fonts/ of this checkout, or of the main one from a worktree (never committed). */
function fontsDir(): string {
  const here = path.resolve(PACKAGE_DIR, '../../.fonts');
  if (existsSync(here)) return here;
  const common = execFileSync('git', ['rev-parse', '--path-format=absolute', '--git-common-dir'], {
    cwd: PACKAGE_DIR,
    encoding: 'utf8',
  }).trim();
  return path.join(path.dirname(common), '.fonts');
}
const COFO = path.join(fontsDir(), 'cofo-sans-pro-arabic');
const WEIGHTS: Record<string, string> = {
  '400': 'CoFoSansProArabic-Regular.ttf',
  '500': 'CoFoSansProArabic-Medium.ttf',
  '700': 'CoFoSansProArabic-Bold.ttf',
};
if (!existsSync(COFO))
  throw new Error('CoFo is missing from .fonts/: run `pnpm fonts:fetch` first');

const TYPES: Record<string, string> = {
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.ttf': 'font/ttf',
  '.html': 'text/html',
};
const UMD = path.join(PACKAGE_DIR, 'node_modules');
const server = createServer((req, res) => {
  const url = decodeURIComponent((req.url ?? '/').split('?')[0] ?? '/');
  const file = url.startsWith('/_fonts/')
    ? path.join(COFO, url.slice('/_fonts/'.length))
    : url.startsWith('/_umd/')
      ? path.join(UMD, url.slice('/_umd/'.length))
      : path.join(PROJECT, url);
  if (!existsSync(file)) {
    res.writeHead(404).end();
    return;
  }
  res.writeHead(200, {
    'content-type': `${TYPES[path.extname(file)] ?? 'text/plain'}; charset=utf-8`,
  });
  createReadStream(file).pipe(res);
});
await new Promise<void>((done) => server.listen(0, '127.0.0.1', done));
const address = server.address();
const base = `http://127.0.0.1:${String(typeof address === 'object' && address ? address.port : 0)}/`;

interface Declared {
  editor?: string;
  default?: unknown;
  options?: unknown[];
  section?: string;
}
interface Combination {
  name: string;
  props: Record<string, unknown>;
  state: Record<string, unknown>;
}

/** The playground at its Tweaks, its props changed, then each scenario. */
function combinations(tweaks: Record<string, Declared>, scenarios: string[]): Combination[] {
  const out: Combination[] = [{ name: 'tweaks', props: {}, state: {} }];
  const changed: Record<string, unknown> = {};
  for (const [name, t] of Object.entries(tweaks)) {
    if (t.editor === 'boolean') changed[name] = t.default !== true;
    else if (t.editor === 'enum' && t.options?.length) changed[name] = t.options.at(-1);
  }
  if (Object.keys(changed).length > 0)
    out.push({ name: 'props changed', props: changed, state: {} });
  for (const s of scenarios) out.push({ name: s, props: {}, state: { story: s } });
  return out;
}

const faces = Object.entries(WEIGHTS)
  .map(
    ([weight, file]) =>
      `@font-face{font-family:"CoFo Sans Pro Arabic";src:url("_fonts/${file}");font-weight:${weight};font-style:normal}`,
  )
  .join('');

const heights: Record<string, number> = {};
const classes: Record<string, Set<string>> = {};
let problems = 0;
let runs = 0;
const browser = await chromium.launch();
const files = readdirSync(PROJECT).filter(
  (f) => f.endsWith('.dc.html') && (only.length === 0 || only.some((o) => f.startsWith(o))),
);
for (const f of files) {
  const html = readFileSync(path.join(PROJECT, f), 'utf8');
  const key = f.replace('.dc.html', '');
  const helmet = (/<helmet>([\s\S]*?)<\/helmet>/.exec(html)?.[1] ?? '').replace(
    /@font-face\{[^}]*\}/g,
    '',
  );
  const body = (/<x-dc>([\s\S]*)<\/x-dc>/.exec(html)?.[1] ?? '').replace(
    /<helmet>[\s\S]*?<\/helmet>/,
    '',
  );
  const script = /<script type="text\/x-dc"[^>]*>([\s\S]*?)<\/script>/.exec(html)?.[1] ?? '';
  const states = /<link rel="stylesheet" href="(support\/states\/[^"]+)">/.exec(html)?.[1];
  const attr = /data-props='([^']*)'/.exec(html)?.[1] ?? '{}';
  const declared = JSON.parse(attr.replaceAll('&#39;', "'").replaceAll('&amp;', '&')) as Record<
    string,
    Declared
  > & { $preview: { width: number; height: number } };
  const { $preview: preview, ...tweaks } = declared;
  const scenarios = [...script.matchAll(/for \(const s of (\[[^\]]*\])\) sc\[s\]/g)].flatMap(
    (m) => JSON.parse(m[1] ?? '[]') as string[],
  );
  for (const combo of combinations(tweaks, scenarios)) {
    runs += 1;
    const page = await browser.newPage({
      viewport: { width: preview.width, height: preview.height },
    });
    const errors: string[] = [];
    page.on('pageerror', (e) => errors.push(e.message));
    page.on('console', (m) => {
      if (m.type() === 'error' || m.type() === 'warning') {
        errors.push(`${m.type()}: ${m.text().slice(0, 200)}`);
      }
    });
    await page.goto(`${base}canvas.json`);
    await page.setContent(
      `<!doctype html><html lang="ar" dir="rtl"><head><meta charset="utf-8"><base href="${base}">` +
        `<style>${faces}</style>` +
        `<script src="_umd/react-18/umd/react.production.min.js"></script>` +
        `<script src="_umd/react-dom-18/umd/react-dom.production.min.js"></script>` +
        `<link rel="stylesheet" href="ds/fox-drop/components/bundle.css">` +
        (states ? `<link rel="stylesheet" href="${states}">` : '') +
        `<script src="ds/fox-drop/components/bundle.js"></script>${helmet}</head>` +
        `<body><template id="t">${body}</template><div id="root"></div></body></html>`,
    );
    await page.waitForLoadState('load');
    await page.evaluate(async () => {
      await Promise.all([...document.fonts].map((x) => x.load()));
    });
    const result = await page.evaluate(renderBoard, {
      src: script,
      props: combo.props,
      state: combo.state,
      measureHeight: measure,
    });
    if (result.natural !== null) heights[key] = Math.max(heights[key] ?? 0, result.natural);
    const seen = (classes[key] ??= new Set());
    for (const c of result.classes) seen.add(c);
    const taller = !measure && result.content > result.frame + 1;
    const found = [
      ...result.missing.map((m) => `missing ${m}`),
      ...result.over.map((o) => `over ${o}`),
      ...errors,
      ...(taller
        ? [`taller than its board (${String(result.content)} > ${String(result.frame)})`]
        : []),
    ];
    if (found.length > 0) {
      problems += 1;
      process.stdout.write(`${key} [${combo.name}]: ${found.join(' | ')}\n`);
    }
    if (shots && combo.name === 'tweaks') {
      await page.screenshot({ path: path.join(shots, `${key}.png`), fullPage: true });
    }
    await page.close();
  }
}
await browser.close();
server.close();
if (measure) {
  const read = <T>(file: string): T =>
    (existsSync(file) ? JSON.parse(readFileSync(file, 'utf8')) : {}) as T;
  const heightsFile = path.join(OUT, 'heights.json');
  const classesFile = path.join(OUT, 'classes.json');
  writeFileSync(
    heightsFile,
    `${JSON.stringify({ ...read<Record<string, number>>(heightsFile), ...heights }, null, 1)}\n`,
  );
  const sorted = Object.fromEntries(Object.entries(classes).map(([k, v]) => [k, [...v].sort()]));
  writeFileSync(
    classesFile,
    `${JSON.stringify({ ...read<Record<string, string[]>>(classesFile), ...sorted }, null, 1)}\n`,
  );
}
process.stdout.write(
  `${String(files.length)} boards, ${String(runs)} combinations, ${String(problems)} with problems\n`,
);
if (problems > 0) process.exitCode = 1;
