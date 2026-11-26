// One board of the "Fox Drop Components" canvas per component, all from the
// code: (1) the header (what it is, when to use it and when not, its code name,
// the token files it reads and who else reads them), (2) the playground, (3) the
// surfaces side by side (phone, captain, panel), (4) every state of the stories,
// by variant, hover, pressed and keyboard focus forced with the component's own
// CSS rules, and a popup open inside its cell, (5) its anatomy from the component
// tokens. Every copy is the real component of the bundle (`FoxDrop.<Name>`).
import type { TokenFile } from './anatomy.ts';
import { COMPONENTS as COPY, GROUPS, TEXT, WORDS } from './copy-ar.ts';
import { esc, Mounts, page, type Fonts, WIDTH } from './page.ts';
import {
  mountOf,
  type Playground,
  playgroundLogic,
  playgroundSection,
  playgroundTweaks,
} from './playground.ts';
import { PSEUDO } from './states.ts';
import { type Args, type ComponentStories, opens, pascal } from './stories.ts';

const MUTED = 'font-size: 13px; line-height: 1.6; color: var(--fd-color-on-surface-muted);';
const PANEL =
  'display: flex; flex-direction: column; gap: var(--fd-space-lg); min-width: 0; padding: var(--fd-space-lg); border-radius: var(--fd-radius-lg); background: var(--fd-color-surface); color: var(--fd-color-on-surface); border: 1px solid var(--fd-color-border);';
const HEAD =
  'display: flex; align-items: baseline; justify-content: space-between; gap: var(--fd-space-md); padding-bottom: var(--fd-space-sm); border-bottom: 1px solid var(--fd-color-border); font-size: 16px;';
const ASIDE =
  'display: flex; flex-direction: column; gap: var(--fd-space-md); min-width: 0; padding: var(--fd-space-md); border-radius: var(--fd-radius-md); background: var(--fd-color-surface-raised); border: 1px solid var(--fd-color-border);';
const BOX =
  'display: flex; flex-direction: column; gap: var(--fd-space-2xs); padding: var(--fd-space-md); border-radius: var(--fd-radius-md); background: var(--fd-color-surface-raised); border: 1px solid var(--fd-color-border); font-size: 14px; line-height: 1.6;';

/** The interaction states a copy shows forced, by state name. */
const FORCED: Record<string, keyof typeof PSEUDO> = {
  hover: 'hover',
  pressed: 'pressed',
  focus: 'focus',
};

/** Groups whose copies take their cell's width (fields, bars, tabs that scroll, cards). */
const FILL = new Set(['Forms', 'Navigation', 'Data']);

/** Bars and tables as wide as a panel page: their surfaces and states one a row. */
const WIDE = new Set(['TopBar', 'DataTable']);

/** The narrowest a state's copy is drawn, by Design System group. */
const CELL_WIDTH: Record<string, number> = {
  Forms: 340,
  Data: 320,
  Navigation: 400,
  Overlays: 400,
};

/** `PrimaryHover`, `readOnly`, `WithIconStart` in Arabic, from WORDS; throws on a missing word. */
export function caption(name: string): string {
  // `SCurve` is «s curve», `picked_up` «picked up».
  const words = name
    .replaceAll('_', ' ')
    .replace(/([a-z0-9])([A-Z])/g, '$1 $2')
    .replace(/([A-Z])([A-Z][a-z])/g, '$1 $2')
    .toLowerCase()
    .split(/\s+/)
    .filter(Boolean);
  const out: string[] = [];
  for (let i = 0; i < words.length;) {
    let taken = 0;
    for (let n = words.length - i; n > 0; n -= 1) {
      const phrase = words.slice(i, i + n).join(' ');
      if (WORDS[phrase] !== undefined) {
        out.push(WORDS[phrase]);
        taken = n;
        break;
      }
    }
    if (taken === 0)
      throw new Error(`copy-ar.ts: no Arabic word for «${words[i] ?? ''}» (${name})`);
    i += taken;
  }
  return out.join(' ');
}

export interface BoardInput {
  stories: ComponentStories;
  group: string;
  playground: Playground;
  anatomy: TokenFile[];
  /** The props the component declares (docs.ts): `density`, `inline`. */
  members: Set<string>;
  height: number;
  fonts: Fonts;
}

/**
 * A story's props for a copy: a component that can be drawn in place
 * (`inline`) always is, so the popups it opens in Play stay in their cell, and
 * a story that opens its popup is drawn open.
 */
function propsOf(input: BoardInput, story: string, extra: Args = {}): Args {
  const info = input.stories.stories[story];
  const args = { ...(info?.args ?? {}), ...extra };
  if (!input.members.has('inline')) return args;
  return { ...args, ...(opens(info) && { open: true }), inline: true };
}

function header(input: BoardInput): string {
  const { name } = input.stories;
  const copy = COPY[name];
  if (!copy) throw new Error(`copy-ar.ts: no copy for ${name}`);
  const readers = input.anatomy.length
    ? input.anatomy
        .map((t) => {
          const flutter = t.readers.flutter.length
            ? ` · core_ui: ${t.readers.flutter.join('، ')}`
            : '';
          return `<li><code>${esc(t.file)}</code> ← ui-web: ${esc(t.readers.web.join('، '))}${esc(flutter)}</li>`;
        })
        .join('')
    : `<li>${esc(TEXT.readersNone)}</li>`;
  const twin = input.anatomy.some((t) => t.readers.flutter.length > 0)
    ? TEXT.flutter
    : TEXT.webOnly;
  return `    <header style="display: grid; grid-template-columns: minmax(0, 1fr) 420px; gap: var(--fd-space-2xl); align-items: start;">
      <div style="display: flex; flex-direction: column; gap: var(--fd-space-sm);">
        <p style="margin: 0; ${MUTED}">${esc(GROUPS[input.group] ?? input.group)} · ${esc(TEXT.component)}</p>
        <h1 style="margin: 0; font-size: 34px; line-height: 1.3; font-weight: 700; color: var(--fd-color-heading);" dir="ltr">${esc(name)}</h1>
        <p style="margin: 0; font-size: 17px; line-height: 1.7;">${esc(copy.desc)}</p>
        <div style="display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: var(--fd-space-md);">
          <div style="${BOX}"><strong>${esc(TEXT.use)}</strong><span>${esc(copy.use)}</span></div>
          <div style="${BOX}"><strong>${esc(TEXT.avoid)}</strong><span>${esc(copy.avoid)}</span></div>
        </div>
      </div>
      <div style="${BOX}">
        <strong>${esc(TEXT.code)}</strong>
        <code dir="ltr" style="font-size: 15px;">FoxDrop.${esc(name)}</code>
        <strong style="margin-top: var(--fd-space-xs);">${esc(TEXT.readers)}</strong>
        <ul dir="ltr" style="margin: 0; padding-inline-start: var(--fd-space-md); font-size: 13px;">${readers}</ul>
        <span style="${MUTED}">${esc(twin)}</span>
      </div>
    </header>`;
}

function surfaces(input: BoardInput, mounts: Mounts): string {
  const base = propsOf(input, input.playground.base);
  const density = input.members.has('density');
  const cell = (label: string, attrs: string, props: Args) =>
    `        <div${attrs} style="display: flex; flex-direction: column; gap: var(--fd-space-sm); min-width: 0; padding: var(--fd-space-md); border-radius: var(--fd-radius-md); background: var(--fd-color-surface); color: var(--fd-color-on-surface); border: 1px solid var(--fd-color-border);">
          <span style="${MUTED}">${esc(label)}</span>
          <div style="display: flex; justify-content: center; min-width: 0;">${mounts.tag(mountOf(input.stories, input.playground.base), props)}</div>
        </div>`;
  return `    <section data-surfaces style="${PANEL}">
      <div style="${HEAD}"><strong>${esc(TEXT.surfaces)}</strong><span style="${MUTED}">${esc(TEXT.surfacesNote)}</span></div>
      <div style="display: grid; grid-template-columns: repeat(${WIDE.has(input.stories.name) ? '1' : '3'}, minmax(0, 1fr)); gap: var(--fd-space-md);">
${cell(TEXT.phone, '', base)}
${cell(TEXT.captain, ' data-surface="captain"', base)}
${cell(density ? TEXT.panelCompact : TEXT.panel, '', density ? { ...base, density: 'compact' } : base)}
      </div>
    </section>`;
}

/** One state's copy, `captioned` under it unless the matrix's heads name it. */
function copyCell(
  input: BoardInput,
  mounts: Mounts,
  story: string,
  state: string,
  fill: boolean,
  captioned: boolean,
) {
  if (!input.stories.stories[story])
    throw new Error(`${input.stories.name}: no story for ${state}`);
  const forced = FORCED[state];
  let slot = mounts.tag(mountOf(input.stories, story), propsOf(input, story));
  if (forced) {
    slot = `<div data-pseudo="${PSEUDO[forced]}" data-pseudo-outer style="display: block; min-width: 0;">${slot}</div>`;
  }
  // A state only a gesture reaches (pulling a list, typing) is drawn before it and says so.
  const info = input.stories.stories[story];
  const gesture = info?.canvas?.gesture ?? (info?.play === true && !input.members.has('inline'));
  const words = gesture ? `${caption(state)} · ${TEXT.inPlay}` : caption(state);
  const under = captioned ? `<span style="${MUTED}">${esc(words)}</span>` : '';
  return `<div data-cell="${esc(story)}" style="display: flex; flex-direction: column; gap: var(--fd-space-xs); align-items: ${fill ? 'stretch' : 'flex-start'}; min-width: 0;">${slot}${under}</div>`;
}

function matrix(input: BoardInput, mounts: Mounts): string {
  const { states, variants, cells } = input.stories;
  const fill = FILL.has(input.group);
  let grid: string;
  if (variants) {
    const head = [
      '<span></span>',
      ...states.map((s) => `<span style="${MUTED}">${esc(caption(s))}</span>`),
    ];
    const rows = variants.flatMap((variant) => [
      `<strong style="font-size: 14px;">${esc(caption(variant))}</strong>`,
      ...states.map((state) =>
        copyCell(
          input,
          mounts,
          cells[`${pascal(variant)}${pascal(state)}`] ?? '',
          state,
          fill,
          false,
        ),
      ),
    ]);
    grid = `<div style="display: grid; grid-template-columns: 96px repeat(${String(states.length)}, minmax(0, 1fr)); gap: var(--fd-space-md) var(--fd-space-sm); align-items: center;">
        ${[...head, ...rows].join('\n        ')}
      </div>`;
  } else {
    const width = WIDE.has(input.stories.name) ? 1200 : (CELL_WIDTH[input.group] ?? 200);
    const items = states.map((state) => {
      return copyCell(input, mounts, cells[pascal(state)] ?? '', state, fill, true);
    });
    grid = `<div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(${String(width)}px, 1fr)); gap: var(--fd-space-xl) var(--fd-space-lg); align-items: start;">
        ${items.join('\n        ')}
      </div>`;
  }
  return `    <section data-panel style="${PANEL}">
      <div style="${HEAD}"><strong>${esc(TEXT.states)}</strong><span style="${MUTED}">${esc(TEXT.statesNote)}</span></div>
      ${grid}
    </section>`;
}

const swatch = (value: string) =>
  `<span style="display: inline-block; flex: none; width: 20px; height: 20px; border-radius: var(--fd-radius-xs); border: 1px solid var(--fd-color-border); background: var(${value});"></span>`;

function anatomySection(input: BoardInput): string {
  if (input.anatomy.length === 0) return '';
  const tables = input.anatomy
    .map((t) => {
      const head = [TEXT.part, ...t.columns.map((c) => (c === 'rest' ? TEXT.rest : caption(c)))]
        .map(
          (h) =>
            `<th style="text-align: start; padding: var(--fd-space-xs); ${MUTED}">${esc(h)}</th>`,
        )
        .join('');
      const rows = t.parts
        .map((p) => {
          const cells = t.columns
            .map((col) => {
              const cell = p.cells[col];
              if (!cell) return '<td style="padding: var(--fd-space-xs);"></td>';
              const mark = cell.type === 'color' ? swatch(cell.variable) : '';
              return `<td style="padding: var(--fd-space-xs); vertical-align: top;"><div style="display: flex; gap: var(--fd-space-xs); align-items: flex-start;">${mark}<div dir="ltr" style="display: flex; flex-direction: column; min-width: 0; font-size: 12px; line-height: 1.5;"><code>${esc(cell.value)}</code><span style="color: var(--fd-color-on-surface-muted); overflow-wrap: anywhere;">${esc(cell.variable)}</span><span style="color: var(--fd-color-on-surface-muted);">${esc(cell.ref)}</span></div></div></td>`;
            })
            .join('');
          return `<tr style="border-top: 1px solid var(--fd-color-border);"><th dir="ltr" style="text-align: start; padding: var(--fd-space-xs); font-size: 13px; font-weight: 500; white-space: nowrap;">${esc(p.name)}</th>${cells}</tr>`;
        })
        .join('\n');
      return `      <div style="display: flex; flex-direction: column; gap: var(--fd-space-xs);">
        <code dir="ltr" style="${MUTED}">tokens/component/${esc(t.file)}</code>
        <table style="width: 100%; border-collapse: collapse; table-layout: fixed;"><thead><tr>${head}</tr></thead><tbody>
${rows}
        </tbody></table>
      </div>`;
    })
    .join('\n');
  return `    <section data-anatomy style="${PANEL}">
      <div style="${HEAD}"><strong>${esc(TEXT.anatomy)}</strong><span style="${MUTED}">${esc(TEXT.anatomyNote)}</span></div>
${tables}
    </section>`;
}

/** The whole board at height `h`. */
export function makeBoard(input: BoardInput): string {
  const { name } = input.stories;
  const mounts = new Mounts();
  const sections = [
    header(input),
    playgroundSection(
      input.stories,
      input.playground,
      mounts,
      {
        title: TEXT.playground,
        note: TEXT.playgroundNote,
        props: TEXT.props,
        reset: TEXT.reset,
        scenarios: TEXT.scenarios,
        caption,
        none: TEXT.none,
      },
      { panel: PANEL, head: HEAD, muted: MUTED, aside: ASIDE },
    ),
    surfaces(input, mounts),
    matrix(input, mounts),
    anatomySection(input),
  ];
  return page({
    title: name,
    states: `support/states/${name}.css`,
    w: WIDTH,
    h: input.height,
    fonts: input.fonts,
    tweaks: playgroundTweaks(input.playground),
    vals: mounts.vals,
    logic: `${playgroundLogic(input.stories, input.playground)}
    return { v, live, dk, sc, reset, pgKey };`,
    body: `<div dir="rtl" lang="ar" style="width: ${String(WIDTH)}px; height: ${String(input.height)}px; box-sizing: border-box; padding: var(--fd-space-2xl) var(--fd-space-3xl); display: flex; flex-direction: column; gap: var(--fd-space-xl); background: var(--fd-color-surface-raised); color: var(--fd-color-on-surface); font-family: var(--fd-font-family-sans);">
${sections.filter(Boolean).join('\n')}
</div>`,
  });
}
