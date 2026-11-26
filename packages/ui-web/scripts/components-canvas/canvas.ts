// Writes the "Fox Drop Components" canvas from the code (architecture §9.8,
// slices D.C1 to D.C4) into the ignored .components-canvas/:
//   pnpm --filter @fox-drop/ui-web components-canvas --config <file> --current <canvas.json>
// The config (kept outside the repository) holds the Design System's link and
// version, the canvas's creation time and the CoFo urls uploaded to the canvas:
//   {"system": "<url>", "version": "<id>", "created": "<RFC 3339>", "fonts": {"400": "/_blob/<id>"}}
// `--current` is the published canvas.json (read it with the Artifact tool):
// boards on other pages are kept. One board per component (board.ts), each with
// its own forced-states sheet; heights and class names come from the check
// (`components-canvas:check --measure`), so the canvas is written, measured and
// written again. Claude publishes the folder with the Artifact tool
// (packages/design-tokens/CLAUDE.md «Sync»).
import { existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { buildBundle, COMPONENTS, PACKAGE_DIR } from '../bundle.ts';
import { anatomy, lightValues } from './anatomy.ts';
import { makeBoard } from './board.ts';
import { GROUPS, PAGES, PROPOSALS_NOTE } from './copy-ar.ts';
import { makeIndex } from './index.ts';
import { type Fonts, WIDTH } from './page.ts';
import { membersOf, parseTypes, playgroundOf } from './playground.ts';
import { forcedStates } from './states.ts';
import { readStories, storyServer } from './stories.ts';

export const OUT = path.join(PACKAGE_DIR, '.components-canvas');
export const PROJECT = path.join(OUT, 'project');
const GAP = 80;
const ROW = 4 * WIDTH + 3 * GAP;
/** A board's height before the check has measured it. */
const UNMEASURED = 3000;

/** The popups D.C3 draws open in their boards once each takes `inline`; none has a board yet. */
export const LATER: ReadonlySet<string> = new Set([
  'BlockingBanner',
  'ConfirmDialog',
  'Drawer',
  'Menu',
  'Select',
  'Tooltip',
  'Toaster',
  'CountrySheet',
  'DateField',
  'TimeField',
  'PhoneField',
  'Sidebar',
]);

/**
 * The hand-drawn boards of the old "Component proposals" canvas, approved in
 * D.6 to D.10 and replaced by the generated boards (decision T15): left out of
 * the index, and the publish sends each as `"project/<file>": null`.
 */
export const RETIRED: readonly string[] = [
  'Main.dc.html',
  'Buttons.dc.html',
  'States.dc.html',
  'Forms.dc.html',
  'Data.dc.html',
  'Overlays.dc.html',
];

/** Every component of the bundle but those D.C3 adds. */
export const BOARDS: readonly string[] = COMPONENTS.filter((name) => !LATER.has(name));

export interface CanvasConfig {
  system: string;
  version?: string | null;
  created: string;
  fonts?: Fonts;
}

export interface Measured {
  heights: Record<string, number>;
  classes: Record<string, string[]>;
}

interface BoardEntry {
  x: number;
  y: number;
  w: number;
  h: number;
  title: string;
  page?: string;
  is_interactive?: boolean;
}

export interface CanvasIndex {
  title?: string;
  boards?: Record<string, BoardEntry>;
  order?: string[];
  pages?: { id: string; name: string }[];
  notes?: Record<string, { page?: string }>;
  [key: string]: unknown;
}

/** A component's Design System group (`@dsCard group=` of its preview). */
export function groupOf(name: string): string {
  const preview = readFileSync(
    path.join(PACKAGE_DIR, 'design-system', name, 'preview.html'),
    'utf8',
  );
  const group = /@dsCard group="([^"]+)"/.exec(preview)?.[1];
  if (!group) throw new Error(`${name}: its preview names no group`);
  return group;
}

export interface Built {
  /** Paths under project/ and their text. */
  files: Map<string, string>;
  index: CanvasIndex;
}

/** Every board and its sheet, and the index laid out by group, old pages kept. */
export async function buildCanvas(input: {
  names: readonly string[];
  current: CanvasIndex;
  config: CanvasConfig;
  bundleCss: string;
  measured?: Measured;
  now?: string;
}): Promise<Built> {
  const { names, current, config, bundleCss, measured } = input;
  const server = await storyServer();
  let all;
  try {
    all = await readStories(server, names);
  } finally {
    await server.close();
  }
  const types = parseTypes();
  const values = lightValues();
  const files = new Map<string, string>();
  const placed: { name: string; group: string; h: number }[] = [];
  for (const stories of all) {
    const { name } = stories;
    const group = groupOf(name);
    const h = measured?.heights[name] ?? UNMEASURED;
    const classes = measured?.classes[name];
    files.set(
      `${name}.dc.html`,
      makeBoard({
        stories,
        group,
        playground: playgroundOf(stories, types),
        anatomy: anatomy(stories.folder, values),
        members: new Set(membersOf(name, types).map((m) => m.name)),
        height: h,
        fonts: config.fonts ?? {},
      }),
    );
    // Every forced copy of a board sits in a `data-pseudo-outer` frame (board.ts).
    files.set(
      `support/states/${name}.css`,
      forcedStates(bundleCss, classes && new Set(classes), ['outer']),
    );
    placed.push({ name, group, h });
  }
  const boards: Record<string, BoardEntry> = {};
  const order: string[] = [];
  const groups = [...new Set(placed.map((p) => p.group))];
  // The index (Main.dc.html) first, then each group under its title note,
  // four boards a row.
  const indexH = measured?.heights['Main'] ?? 1600;
  files.set(
    'Main.dc.html',
    makeIndex(
      groups.map((group) => ({
        group,
        names: placed.filter((p) => p.group === group).map((p) => p.name),
      })),
      indexH,
      config.fonts ?? {},
    ),
  );
  boards['Main.dc.html'] = {
    x: 0,
    y: 0,
    w: WIDTH,
    h: indexH,
    title: 'Fox Drop Components',
    page: 'components',
    is_interactive: true,
  };
  order.push('Main.dc.html');
  const groupNotes: Record<string, { page?: string; [key: string]: unknown }> = {};
  let y = indexH + 520;
  for (const group of groups) {
    const count = placed.filter((p) => p.group === group).length;
    groupNotes[`g-${group.toLowerCase()}`] = {
      x: 0,
      y: y - 260,
      text: `${GROUPS[group] ?? group} · ${String(count)}`,
      kind: 'title1',
      maxW: ROW,
      page: 'components',
    };
    let x = 0;
    let rowH = 0;
    for (const p of placed.filter((q) => q.group === group)) {
      if (x > 0 && x + WIDTH > ROW) {
        y += rowH + 120;
        x = 0;
        rowH = 0;
      }
      const file = `${p.name}.dc.html`;
      boards[file] = {
        x,
        y,
        w: WIDTH,
        h: p.h,
        title: p.name,
        page: 'components',
        is_interactive: true,
      };
      order.push(file);
      x += WIDTH + GAP;
      rowH = Math.max(rowH, p.h);
    }
    y += rowH + 520;
  }
  // Proposals drawn on the proposals page stay until their board is built
  // from the bundle; the retired hand-drawn boards go.
  const kept = Object.entries(current.boards ?? {})
    .filter(([file, b]) => b.page !== 'components' && !RETIRED.includes(file) && !files.has(file))
    .map(([file, b]) => [file, { ...b, page: b.page ?? 'proposals' }] as const);
  const notes = {
    ...groupNotes,
    ...Object.fromEntries(
      Object.entries(current.notes ?? {})
        .filter(([, n]) => n.page !== 'components')
        .map(([id, n]) => [id, { ...n, page: n.page ?? 'proposals' }]),
    ),
    'proposals-life-cycle': {
      // A sticky (no `kind`), above where the proposals are drawn.
      x: 0,
      y: -720,
      w: 960,
      size: 'l',
      fill: 'orange',
      text: PROPOSALS_NOTE,
      page: 'proposals',
    },
  };
  const index: CanvasIndex = {
    ...current,
    v: 3,
    title: 'Fox Drop Components',
    launch: { view: 'canvas', page: 'components' },
    pages: [
      { id: 'components', name: PAGES.components },
      { id: 'proposals', name: PAGES.proposals },
    ],
    boards: { ...boards, ...Object.fromEntries(kept) },
    order: [...order, ...kept.map(([file]) => file)],
    notes,
    noteOrder: Object.keys(notes),
    designSystems: [
      {
        title: 'Fox Drop Design System',
        namespace: 'fox-drop',
        artifact: config.system,
        version: config.version ?? null,
        copiedAt: input.now ?? new Date().toISOString(),
      },
    ],
  };
  return { files, index };
}

const readJson = <T>(file: string, fallback: T): T =>
  existsSync(file) ? (JSON.parse(readFileSync(file, 'utf8')) as T) : fallback;

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const arg = (flag: string) => {
    const at = process.argv.indexOf(flag);
    return at === -1 ? undefined : process.argv[at + 1];
  };
  const configFile = arg('--config');
  if (!configFile)
    throw new Error('Usage: components-canvas --config <file> [--current <canvas.json>]');
  const config = JSON.parse(readFileSync(configFile, 'utf8')) as CanvasConfig;
  const currentFile = arg('--current');
  const current = currentFile
    ? readJson<CanvasIndex>(currentFile, {})
    : readJson<CanvasIndex>(path.join(PROJECT, 'canvas.json'), {});
  const measured: Measured = {
    heights: readJson(path.join(OUT, 'heights.json'), {}),
    classes: readJson(path.join(OUT, 'classes.json'), {}),
  };
  const { js, css } = await buildBundle();
  const { files, index } = await buildCanvas({
    names: BOARDS,
    current,
    config,
    bundleCss: css,
    measured,
  });
  rmSync(PROJECT, { recursive: true, force: true });
  files.set('canvas.json', `${JSON.stringify(index, null, 1)}\n`);
  // The system as the Design System publishes it, for the check; the publish
  // copies these from the Design System itself.
  files.set('ds/fox-drop/components/bundle.js', js);
  files.set('ds/fox-drop/components/bundle.css', css);
  for (const [file, text] of files) {
    const target = path.join(PROJECT, file);
    mkdirSync(path.dirname(target), { recursive: true });
    writeFileSync(target, text);
  }
  console.log(`wrote ${String(BOARDS.length)} boards into ${PROJECT}`);
}
