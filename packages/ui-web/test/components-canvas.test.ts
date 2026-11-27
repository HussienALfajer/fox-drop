// The "Fox Drop Components" canvas (slices D.C1 to D.C4): every board of the
// slice is written from the code, every hole of its template resolves, every
// state of the stories has its cell and its Arabic caption, a board's
// forced-states sheet holds only its own rules, and the index has the canvas's
// title and pages. The Playwright check (`components-canvas:check`) renders
// them; this test needs no browser.
import { beforeAll, describe, expect, it } from 'vitest';
import { buildBundle, COMPONENTS } from '../scripts/bundle.ts';
import { caption } from '../scripts/components-canvas/board.ts';
import {
  BOARDS,
  buildCanvas,
  type Built,
  groupOf,
  RETIRED,
} from '../scripts/components-canvas/canvas.ts';
import {
  COMPONENTS as COPY,
  GROUPS,
  PROPOSALS_NOTE,
  TEXT,
} from '../scripts/components-canvas/copy-ar.ts';
import { classesOf, forcedStates } from '../scripts/components-canvas/states.ts';
import {
  readStories,
  storyServer,
  type ComponentStories,
} from '../scripts/components-canvas/stories.ts';

// The six hand-drawn boards of the old "Component proposals" canvas, as
// published on its proposals page, and one proposal drawn there since.
const OLD = Object.fromEntries(
  RETIRED.map((file, at) => [
    file,
    { x: at * 1760, y: 0, w: 1680, h: 3000, title: file, page: 'proposals' },
  ]),
);
const PROPOSAL = { x: 0, y: 0, w: 1440, h: 2000, title: 'A proposal', page: 'proposals' };

let built: Built;
let bundleCss: string;
let stories: ComponentStories[];

beforeAll(async () => {
  bundleCss = (await buildBundle()).css;
  built = await buildCanvas({
    names: BOARDS,
    current: {
      title: 'Component proposals',
      boards: { ...OLD, 'Proposal.dc.html': PROPOSAL },
      order: [...RETIRED, 'Proposal.dc.html'],
    },
    config: { system: 'https://example.test/system', created: '2026-11-26T00:00:00Z' },
    bundleCss,
    now: '2026-11-26T00:00:00Z',
  });
  const server = await storyServer();
  stories = await readStories(server, BOARDS);
  await server.close();
}, 180_000);

const board = (name: string) => built.files.get(`${name}.dc.html`) ?? '';

/** The board's template values, as the canvas runtime computes them, with a stub React. */
function renderVals(html: string, state: Record<string, unknown> = {}): Record<string, unknown> {
  const src = /<script type="text\/x-dc"[^>]*>([\s\S]*?)<\/script>/.exec(html)?.[1] ?? '';
  const window = {
    React: { createElement: (type: unknown, props: unknown) => ({ type, props }), Fragment: 'F' },
    FoxDrop: new Proxy({}, { get: (_, name) => ({ name }) }),
  };
  class DCLogic {
    props = {};
    state = state;
    setState() {}
  }
  // The board's own logic class, as the canvas runs it.
  const make = new Function(
    'DCLogic',
    'window',
    `return (${src.replace('class Component extends DCLogic', 'class extends DCLogic')})`,
  ) as (
    base: typeof DCLogic,
    w: typeof window,
  ) => new () => { renderVals: () => Record<string, unknown> };
  return new (make(DCLogic, window))().renderVals();
}

function holes(html: string): string[] {
  const body = /<x-dc>([\s\S]*)<\/x-dc>/.exec(html)?.[1] ?? '';
  return [...body.matchAll(/\{\{\s*([\w.$]+)\s*\}\}/g)].map((m) => m[1] ?? '');
}

function resolves(vals: Record<string, unknown>, path: string): boolean {
  let at: unknown = vals;
  for (const part of path.split('.')) {
    if (at === null || typeof at !== 'object' || !(part in at)) return false;
    at = (at as Record<string, unknown>)[part];
  }
  return true;
}

describe('the components canvas', () => {
  it('has a board and a forced-states sheet for every component of the slice', () => {
    for (const name of BOARDS) {
      expect(COMPONENTS, name).toContain(name);
      // Itself, or its parts (FoxDrop.BlockingHeads.ShopSign).
      expect(board(name), name).toMatch(
        new RegExp(`component-from-global-scope="FoxDrop\\.${name}[".]`),
      );
      expect(built.files.has(`support/states/${name}.css`), name).toBe(true);
    }
  });

  it('resolves every hole of every board, at its Tweaks and in every scenario', () => {
    for (const name of BOARDS) {
      const html = board(name);
      const scenarios = [...html.matchAll(/for \(const s of (\[[^\]]*\])\) sc\[s\]/g)].flatMap(
        (m) => JSON.parse(m[1] ?? '[]') as string[],
      );
      for (const story of [undefined, ...scenarios]) {
        const vals = renderVals(html, story ? { story } : {});
        const missing = holes(html).filter((path) => !resolves(vals, path));
        expect(missing, `${name} ${story ?? 'at its Tweaks'}`).toEqual([]);
      }
    }
  });

  it('mounts only components of the bundle, never text inside an x-import', () => {
    for (const name of BOARDS) {
      for (const m of board(name).matchAll(
        /<x-import component-from-global-scope="FoxDrop\.([\w.]+)"[^>]*>([^<]*)<\/x-import>/g,
      )) {
        expect(COMPONENTS, name).toContain((m[1] ?? '').split('.')[0]);
        expect(m[2], name).toBe('');
      }
    }
  });

  it('draws every state of the stories, by variant, with its Arabic caption', () => {
    for (const c of stories) {
      const html = board(c.name);
      for (const story of Object.values(c.cells)) {
        expect(html, `${c.name} ${story}`).toContain(`data-cell="${story}"`);
      }
      const expected = c.states.length * (c.variants?.length ?? 1);
      expect(Object.keys(c.cells), c.name).toHaveLength(expected);
      for (const word of [...c.states, ...(c.variants ?? []), ...Object.keys(c.stories)]) {
        expect(() => caption(word), `${c.name} ${word}`).not.toThrow();
      }
    }
  });

  it('says what each component is for, in Arabic', () => {
    for (const name of BOARDS) {
      const copy = COPY[name];
      expect(copy, name).toBeDefined();
      for (const text of [copy?.desc, copy?.use, copy?.avoid]) expect(text, name).toMatch(/[؀-ۿ]/);
    }
  });

  it('draws an overlay open inside its cell', () => {
    const html = board('Dialog');
    const vals = renderVals(html) as { v: Record<string, unknown> };
    const open = [...html.matchAll(/open="\{\{ v\.(p\d+) \}\}" inline="\{\{ v\.(p\d+) \}\}"/g)];
    // Open, Danger, Primary, Compact and Pending open their dialog in Storybook (`play`).
    expect(open).toHaveLength(5);
    for (const m of open) expect([vals.v[m[1] ?? ''], vals.v[m[2] ?? '']]).toEqual([true, true]);
  });

  it('colours the board chrome with tokens only', () => {
    for (const name of BOARDS) {
      const styles = [...board(name).matchAll(/style="([^"]*)"/g)].map((m) => m[1] ?? '');
      for (const style of styles) expect(style, name).not.toMatch(/#[0-9a-f]{3,8}\b|rgba?\(|hsl/i);
    }
  });

  it('keeps on a board only the forced rules of the classes on it', () => {
    const own = new Set([
      'bg-(--fd-button-primary-background)',
      'hover:bg-(--fd-button-primary-background-hover)',
    ]);
    const sheet = forcedStates(bundleCss, own, ['outer']);
    const selectors = [
      ...sheet.matchAll(/\[data-pseudo~="[a-z]+"\]\[data-pseudo-outer\] ([^{]+?):not\(:is\(/g),
    ];
    expect(selectors.length).toBeGreaterThan(0);
    for (const m of selectors) {
      for (const name of classesOf(m[1] ?? '')) expect(own, m[1]).toContain(name);
    }
    expect(Buffer.byteLength(forcedStates(bundleCss, undefined, ['outer']))).toBeLessThan(
      Buffer.byteLength(forcedStates(bundleCss)),
    );
    expect(Buffer.byteLength(sheet)).toBeLessThan(60 * 1024);
  });

  it('has a board for every component of the bundle', () => {
    expect([...BOARDS].sort()).toEqual([...COMPONENTS].sort());
  });

  /** The markup of one state's cell. */
  const cellOf = (html: string, story: string) => {
    const at = html.indexOf(`data-cell="${story}"`);
    const next = html.indexOf('data-cell="', at + 1);
    return html.slice(at, next === -1 ? undefined : next);
  };

  it('draws every popup open inside its cell, and a gesture at rest', () => {
    const popups = [
      'Dialog',
      'ConfirmDialog',
      'Drawer',
      'Menu',
      'Select',
      'Tooltip',
      'CountrySheet',
      'DateField',
      'PhoneField',
      'Sidebar',
    ];
    for (const name of popups) {
      const c = stories.find((s) => s.name === name);
      const html = board(name);
      const vals = renderVals(html) as { v: Record<string, unknown> };
      let open = 0;
      for (const story of new Set(Object.values(c?.cells ?? {}))) {
        const info = c?.stories[story];
        const cell = cellOf(html, story);
        const pair = /open="\{\{ v\.(p\d+) \}\}" inline="\{\{ v\.(p\d+) \}\}"/.exec(cell);
        if (info?.play && info.canvas?.open !== false) {
          open += 1;
          expect(pair, `${name} ${story}`).not.toBeNull();
          expect([vals.v[pair?.[1] ?? ''], vals.v[pair?.[2] ?? '']], `${name} ${story}`).toEqual([
            true,
            true,
          ]);
        } else {
          expect(pair, `${name} ${story}`).toBeNull();
        }
        if (info?.canvas?.gesture) expect(cell, `${name} ${story}`).toContain(TEXT.inPlay);
      }
      expect(open, name).toBeGreaterThan(0);
    }
    // Typing in the field is a gesture: the country list stays closed.
    expect(cellOf(board('PhoneField'), 'Invalid')).toContain(TEXT.inPlay);
  });

  it('draws the page-wide overlays in their cells', () => {
    for (const name of ['BlockingBanner', 'Toaster']) {
      const html = board(name);
      const vals = renderVals(html) as { v: Record<string, unknown> };
      const inline = [...html.matchAll(/inline="\{\{ v\.(p\d+) \}\}"/g)];
      expect(inline.length, name).toBeGreaterThan(0);
      for (const m of inline) expect(vals.v[m[1] ?? ''], name).toBe(true);
    }
    // The seeded toasts cross to the canvas.
    expect(board('Toaster')).toContain('تعذّر الحفظ');
  });

  it('links every board from the index, and every link reaches a board', () => {
    const html = built.files.get('Main.dc.html') ?? '';
    const links = [...html.matchAll(/href="([\w.]+)\.dc\.html"/g)].map((m) => m[1]);
    expect([...links].sort()).toEqual([...BOARDS].sort());
    expect(built.index.boards?.['Main.dc.html']?.page).toBe('components');
  });

  it('titles each group with its count, above its boards', () => {
    const notes = Object.values(
      built.index['notes'] as Record<string, { text: string; page?: string }>,
    )
      .filter((n) => n.page === 'components')
      .map((n) => n.text);
    const groups = new Map<string, number>();
    for (const name of BOARDS) {
      const group = groupOf(name);
      groups.set(group, (groups.get(group) ?? 0) + 1);
    }
    expect(notes.sort()).toEqual(
      [...groups].map(([group, count]) => `${GROUPS[group] ?? group} · ${String(count)}`).sort(),
    );
  });

  it('carries what a function prop gives (table cells, counter words), not an empty function', () => {
    for (const name of ['DataTable', 'BannerStack']) {
      expect(board(name), name).toContain('"$memo"');
    }
  });

  it('draws DataTable sorted and selected with what makes them so', () => {
    const table = stories.find((c) => c.name === 'DataTable');
    for (const story of ['Sorted', 'Selected']) {
      const args = table?.stories[story]?.args ?? {};
      expect(Object.keys(args), story).toEqual(
        expect.arrayContaining(['onSortChange', 'onSelectionChange']),
      );
    }
  });

  it('says so when a state only a gesture reaches is drawn at rest', () => {
    // ConfirmDialog's Invalid and Filled: drawn open, before what their play types.
    expect(board('ConfirmDialog')).toContain(TEXT.inPlay);
    expect(board('Dialog')).not.toContain(TEXT.inPlay);
  });

  it('lets the panel open a popup that has no trigger of its own (the audit)', () => {
    // Sidebar's drawer and BlockingBanner open from outside: the panel's switch stands in.
    for (const name of ['Sidebar', 'BlockingBanner']) {
      expect(board(name), name).toMatch(/data-props='[^']*"open":\{"editor":"boolean"/);
    }
    // Dialog opens from its trigger, Select and Tooltip from their own: no switch.
    for (const name of ['Dialog', 'Select', 'Tooltip']) {
      expect(board(name), name).not.toMatch(/data-props='[^']*"open":\{/);
    }
  });

  it('draws the states a gesture reaches from their props (the audit, 2026-11-27)', () => {
    for (const name of ['PullToRefresh', 'BannerStack']) {
      expect(board(name), name).not.toContain(TEXT.inPlay);
    }
  });

  it('names the canvas, its two pages and the page of every board', () => {
    const { index } = built;
    expect(index.title).toBe('Fox Drop Components');
    expect(index.pages?.map((p) => p.id)).toEqual(['components', 'proposals']);
    for (const name of BOARDS) expect(index.boards?.[`${name}.dc.html`]?.page).toBe('components');
    expect(index.boards?.['Main.dc.html']?.page).toBe('components');
    expect(new Set(index.order)).toEqual(new Set(Object.keys(index.boards ?? {})));
  });

  it('retires the six hand-drawn boards and keeps the proposals page to its note and live proposals', () => {
    const { index, files } = built;
    expect(RETIRED).toEqual([
      'Main.dc.html',
      'Buttons.dc.html',
      'States.dc.html',
      'Forms.dc.html',
      'Data.dc.html',
      'Overlays.dc.html',
    ]);
    const generated = new Set(['Main.dc.html', ...BOARDS.map((name) => `${name}.dc.html`)]);
    for (const [file, entry] of Object.entries(index.boards ?? {})) {
      if (generated.has(file)) expect(entry.page, file).toBe('components');
      else expect([file, entry]).toEqual(['Proposal.dc.html', PROPOSAL]);
    }
    for (const file of RETIRED.filter((f) => f !== 'Main.dc.html')) {
      expect(index.boards?.[file], file).toBeUndefined();
      expect(files.has(file), file).toBe(false);
    }
    expect(files.get('Main.dc.html')).not.toContain('Icons — batch 1');
    const proposals = Object.values(index.notes ?? {}).filter((n) => n.page === 'proposals');
    expect(proposals.map((n) => (n as { text?: string }).text)).toEqual([PROPOSALS_NOTE]);
    expect(PROPOSALS_NOTE).toMatch(/[؀-ۿ]/);
  });
});
