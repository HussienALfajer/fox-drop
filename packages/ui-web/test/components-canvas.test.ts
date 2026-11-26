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
  LATER,
} from '../scripts/components-canvas/canvas.ts';
import { COMPONENTS as COPY, GROUPS, TEXT } from '../scripts/components-canvas/copy-ar.ts';
import { classesOf, forcedStates } from '../scripts/components-canvas/states.ts';
import {
  readStories,
  storyServer,
  type ComponentStories,
} from '../scripts/components-canvas/stories.ts';

const OLD = { 'Main.dc.html': { x: 0, y: 0, w: 1280, h: 3910, title: 'Icons — batch 1' } };

let built: Built;
let bundleCss: string;
let stories: ComponentStories[];

beforeAll(async () => {
  bundleCss = (await buildBundle()).css;
  built = await buildCanvas({
    names: BOARDS,
    current: { title: 'Component proposals', boards: OLD, order: ['Main.dc.html'] },
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
    // Open, Danger, Primary and Compact open their dialog in Storybook (`play`).
    expect(open).toHaveLength(4);
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

  it('has a board for every component but the popups D.C3 opens', () => {
    expect([...BOARDS, ...LATER].sort()).toEqual([...COMPONENTS].sort());
    expect(BOARDS.filter((name) => LATER.has(name))).toEqual([]);
  });

  it('links every board from the index, and every link reaches a board', () => {
    const html = built.files.get('Index.dc.html') ?? '';
    const links = [...html.matchAll(/href="([\w.]+)\.dc\.html"/g)].map((m) => m[1]);
    expect([...links].sort()).toEqual([...BOARDS].sort());
    expect(built.index.boards?.['Index.dc.html']?.page).toBe('components');
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

  it('says so when a state only a gesture reaches is drawn at rest', () => {
    for (const name of ['PullToRefresh', 'BannerStack']) {
      expect(board(name), name).toContain(TEXT.inPlay);
    }
    expect(board('Dialog')).not.toContain(TEXT.inPlay);
  });

  it('names the canvas, its two pages and the page of every board', () => {
    const { index } = built;
    expect(index.title).toBe('Fox Drop Components');
    expect(index.pages?.map((p) => p.id)).toEqual(['components', 'proposals']);
    for (const name of BOARDS) expect(index.boards?.[`${name}.dc.html`]?.page).toBe('components');
    expect(index.boards?.['Main.dc.html']?.page).toBe('proposals');
    expect(new Set(index.order)).toEqual(new Set(Object.keys(index.boards ?? {})));
  });
});
