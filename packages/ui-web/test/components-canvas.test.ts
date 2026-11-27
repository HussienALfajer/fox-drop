// The "Fox Drop Components" canvas (slices D.C1 to D.C4, emptied in D.R1):
// every board is written from the code, every hole of its template resolves,
// and the index has the canvas's title and pages. Since D.R1 (2026-11-27) no
// component is approved: the canvas holds the index and the proposals page,
// and the boards of the deleted components leave it. The per-board tests of a
// component's cells, overlays and forced states come back with the first
// approved component (git history: this file before D.R1). The Playwright
// check (`components-canvas:check`) renders them; this test needs no browser.
import { beforeAll, describe, expect, it } from 'vitest';
import { buildBundle, COMPONENTS } from '../scripts/bundle.ts';
import { caption } from '../scripts/components-canvas/board.ts';
import {
  BOARDS,
  buildCanvas,
  type Built,
  groupOf,
  RETIRED,
  SCREEN_PREFIX,
} from '../scripts/components-canvas/canvas.ts';
import {
  COMPONENTS as COPY,
  GROUPS,
  INDEX,
  PAGES,
  PROPOSALS_NOTE,
} from '../scripts/components-canvas/copy-ar.ts';
import {
  readStories,
  storyServer,
  type ComponentStories,
} from '../scripts/components-canvas/stories.ts';

// What the live canvas held before D.R1: a generated board, its group note,
// and one proposal drawn on the proposals page.
const OLD_BOARD = { x: 0, y: 2000, w: 1680, h: 3000, title: 'Button', page: 'components' };
const PROPOSAL = { x: 0, y: 0, w: 1440, h: 2000, title: 'A proposal', page: 'proposals' };
// An approved screen moved to the approved page (T16).
const SCREEN = { x: 0, y: 9000, w: 1440, h: 2000, title: 'A screen', page: 'components' };
const SCREEN_FILE = `${SCREEN_PREFIX}Phone.dc.html`;

let built: Built;
let stories: ComponentStories[];

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

beforeAll(async () => {
  built = await buildCanvas({
    names: BOARDS,
    current: {
      title: 'Fox Drop Components',
      boards: {
        'Button.dc.html': OLD_BOARD,
        'Proposal.dc.html': PROPOSAL,
        [SCREEN_FILE]: SCREEN,
      },
      order: ['Button.dc.html', 'Proposal.dc.html', SCREEN_FILE],
      notes: { 'g-actions': { page: 'components' } },
    },
    config: { system: 'https://example.test/system', created: '2026-11-26T00:00:00Z' },
    bundleCss: (await buildBundle()).css,
    now: '2026-11-26T00:00:00Z',
  });
  const server = await storyServer();
  stories = await readStories(server, BOARDS);
  await server.close();
}, 180_000);

describe('the components canvas', () => {
  it('has a board and a forced-states sheet for every component of the bundle', () => {
    expect([...BOARDS].sort()).toEqual([...COMPONENTS].sort());
    for (const name of BOARDS) {
      // Itself, or its parts.
      expect(board(name), name).toMatch(
        new RegExp(`component-from-global-scope="FoxDrop\\.${name}[".]`),
      );
      expect(built.files.has(`support/states/${name}.css`), name).toBe(true);
    }
  });

  it('resolves every hole of every board and the index, at its Tweaks and in every scenario', () => {
    for (const name of [...BOARDS, 'Main']) {
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
    for (const name of [...BOARDS, 'Main']) {
      for (const m of board(name).matchAll(
        /<x-import component-from-global-scope="FoxDrop\.([\w.]+)"[^>]*>([^<]*)<\/x-import>/g,
      )) {
        expect(COMPONENTS, name).toContain((m[1] ?? '').split('.')[0]);
        expect(m[2], name).toBe('');
      }
    }
  });

  it('draws every state of the stories, by variant, with its Arabic caption', () => {
    expect(stories.map((c) => c.name).sort()).toEqual([...BOARDS].sort());
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

  it('colours the chrome of every board and the index with tokens only', () => {
    for (const name of [...BOARDS, 'Main']) {
      const styles = [...board(name).matchAll(/style="([^"]*)"/g)].map((m) => m[1] ?? '');
      expect(styles.length, name).toBeGreaterThan(0);
      for (const style of styles) expect(style, name).not.toMatch(/#[0-9a-f]{3,8}\b|rgba?\(|hsl/i);
    }
  });

  it('links every board from the index, and every link reaches a board', () => {
    const html = built.files.get('Main.dc.html') ?? '';
    const links = [...html.matchAll(/href="([\w.]+)\.dc\.html"/g)].map((m) => m[1]);
    expect([...links].sort()).toEqual([...BOARDS].sort());
    expect(built.index.boards?.['Main.dc.html']?.page).toBe('components');
  });

  it('says on the index when no component is approved yet', () => {
    const html = built.files.get('Main.dc.html') ?? '';
    if (BOARDS.length === 0) expect(html).toContain(INDEX.empty);
    else expect(html).not.toContain(INDEX.empty);
  });

  it('titles each group with its count, and drops the notes of groups that left', () => {
    const notes = Object.values(
      built.index['notes'] as Record<string, { text?: string; page?: string }>,
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

  it('names the canvas, its two pages and the page of every board', () => {
    const { index } = built;
    expect(index.title).toBe('Fox Drop Components');
    expect(index.pages).toEqual([
      { id: 'components', name: PAGES.components },
      { id: 'proposals', name: PAGES.proposals },
    ]);
    expect(PAGES.components).toBe('المكوّنات المعتمدة');
    for (const name of BOARDS) expect(index.boards?.[`${name}.dc.html`]?.page).toBe('components');
    expect(new Set(index.order)).toEqual(new Set(Object.keys(index.boards ?? {})));
  });

  it('drops the board of a component that left the bundle, keeps proposals and approved screens', () => {
    const { index, files } = built;
    if (!BOARDS.includes('Button')) {
      expect(index.boards?.['Button.dc.html']).toBeUndefined();
      expect(files.has('Button.dc.html')).toBe(false);
    }
    expect(index.boards?.['Proposal.dc.html']).toEqual(PROPOSAL);
    expect(index.boards?.[SCREEN_FILE]).toEqual(SCREEN);
    for (const file of RETIRED.filter((f) => f !== 'Main.dc.html')) {
      expect(index.boards?.[file], file).toBeUndefined();
    }
    const proposals = Object.values(index.notes ?? {}).filter((n) => n.page === 'proposals');
    expect(proposals.map((n) => (n as { text?: string }).text)).toEqual([PROPOSALS_NOTE]);
    expect(PROPOSALS_NOTE).toMatch(/[؀-ۿ]/);
  });
});
