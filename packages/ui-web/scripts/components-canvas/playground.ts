// The playground at the top of each board: one live copy of the component and,
// beside it, a panel of its props built from the system's own components
// (Select, Switch, TextField), so a viewer in Play changes a prop at once.
// Nothing here is written per component: the controls come from the props
// types the Design System documents (docs.ts `typesDoc()`), the starting values
// from the component's Default story, the scenarios from its other stories.
// The panel starts from the board's Tweaks (the saved, shared values) and keeps
// its changes in the board's state: «إعادة الضبط» goes back to Tweaks.
import { typesDoc } from '../docs.ts';
import { esc, js, type Mounts, type TweakDef } from './page.ts';
import type { ComponentStories, Value } from './stories.ts';

export interface Control {
  prop: string;
  editor: 'text' | 'boolean' | 'enum' | 'int';
  options?: string[];
  default: Value;
}

export interface Playground {
  /** The story the copy starts from. */
  base: string;
  controls: Control[];
  /** Stories a press loads into the copy. */
  scenarios: string[];
  /** Every prop any story gives, so each is a hole of the copy. */
  keys: string[];
}

const NONE = '__none__';
/** Props the board owns, or React gives a meaning to. */
const RESERVED = new Set(['key', 'ref', 'className', 'style', 'open', 'inline']);

interface Member {
  name: string;
  type: string;
}

/** The declarations of the types document: interfaces with their members, type aliases. */
export function parseTypes(doc = typesDoc()) {
  const interfaces = new Map<string, { extendsOf: string[]; members: Member[] }>();
  const aliases = new Map<string, string>();
  const clean = doc.replace(/\/\*\*[\s\S]*?\*\//g, '').replace(/\/\/[^\n]*/g, '');
  for (const m of clean.matchAll(/interface (\w+)(?: extends ([\w, ]+))? \{([\s\S]*?)\n\}/g)) {
    const members = [...(m[3] ?? '').matchAll(/^\s+(['\w-]+)\??: ([^;]+);/gm)].map((x) => ({
      name: (x[1] ?? '').replaceAll("'", ''),
      type: (x[2] ?? '').trim(),
    }));
    const extendsOf = (m[2] ?? '')
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);
    interfaces.set(m[1] ?? '', { extendsOf, members });
  }
  for (const m of clean.matchAll(/type (\w+) =\s*([\s\S]*?);/g)) {
    aliases.set(m[1] ?? '', (m[2] ?? '').replace(/\s+/g, ' ').trim());
  }
  return { interfaces, aliases };
}

/** The members of `<Name>Props`: an interface with what it extends, or a union of them. */
export function membersOf(name: string, types = parseTypes()): Member[] {
  const seen = new Map<string, Member>();
  const add = (type: string) => {
    const iface = types.interfaces.get(type);
    if (iface) {
      for (const parent of iface.extendsOf) add(parent);
      for (const m of iface.members) if (!seen.has(m.name)) seen.set(m.name, m);
      return;
    }
    const alias = types.aliases.get(type);
    if (alias) for (const part of alias.split('|')) add(part.trim());
  };
  add(`${name}Props`);
  return [...seen.values()];
}

/** A type's string-literal choices, through aliases (`ButtonVariant`, `IconName`), or none. */
function literals(type: string, aliases: Map<string, string>): string[] | null {
  const resolved = aliases.get(type.trim()) ?? type;
  const parts = resolved
    .split('|')
    .map((p) => p.trim())
    .filter(Boolean);
  if (parts.length === 0) return null;
  const out: string[] = [];
  for (const part of parts) {
    if (/^'[^']*'$/.test(part)) out.push(part.slice(1, -1));
    else if (aliases.has(part)) out.push(...(literals(part, aliases) ?? []));
    else return null;
  }
  return out;
}

/** What a story mounts: its own part (`BlockingHeads.ShopSign`) or the board's component. */
export const mountOf = (c: ComponentStories, story: string) =>
  c.stories[story]?.component ?? c.name;

export function playgroundOf(c: ComponentStories, types = parseTypes()): Playground {
  const names = Object.keys(c.stories);
  const base =
    names.find((s) => s === 'Default') ?? c.cells[Object.keys(c.cells)[0] ?? ''] ?? names[0] ?? '';
  const start = c.stories[base]?.args ?? {};
  const mounted = mountOf(c, base);
  const controls: Control[] = [];
  const members = membersOf(mounted.split('.').at(-1) ?? mounted, types);
  // A story that only a gesture reaches (`play`) loads nothing new, unless it opens a popup in place.
  const reachable = (s: string) => !c.stories[s]?.play || members.some((m) => m.name === 'inline');
  for (const m of members) {
    if (RESERVED.has(m.name) || m.type.includes('=>')) continue;
    const value = start[m.name];
    const choices = literals(m.type, types.aliases);
    if (choices) {
      controls.push({
        prop: m.name,
        editor: 'enum',
        options: [NONE, ...choices],
        default: value ?? NONE,
      });
    } else if (m.type === 'boolean') {
      controls.push({ prop: m.name, editor: 'boolean', default: value ?? false });
    } else if (m.type === 'string' || (m.type === 'ReactNode' && typeof value === 'string')) {
      controls.push({ prop: m.name, editor: 'text', default: value ?? '' });
    } else if (m.type === 'number') {
      controls.push({ prop: m.name, editor: 'int', default: value ?? 0 });
    }
  }
  const used = new Set(Object.values(c.cells));
  // A scenario loads into the same copy, so it draws the same component (one of the heads).
  const scenarios = names.filter(
    (s) =>
      s !== base &&
      !c.stories[s]?.render &&
      mountOf(c, s) === mounted &&
      reachable(s) &&
      (c.variants ? !used.has(s) : true),
  );
  const keys = new Set<string>(controls.map((k) => k.prop));
  for (const s of [base, ...scenarios]) {
    for (const key of Object.keys(c.stories[s]?.args ?? {})) if (!RESERVED.has(key)) keys.add(key);
  }
  return { base, controls, scenarios, keys: [...keys] };
}

/** The board's Tweaks: the playground's starting props, saved and shared. */
export function playgroundTweaks(pg: Playground): Record<string, TweakDef> {
  return Object.fromEntries(
    pg.controls.map((k) => [
      k.prop,
      {
        editor: k.editor,
        default: k.default,
        ...(k.options ? { options: k.options } : {}),
        section: 'Playground',
      },
    ]),
  );
}

/**
 * The statements of `renderVals()` for the playground: `live`, the copy's props
 * (the chosen story's, the panel's changes over Tweaks), `dk`, the panel's
 * values and setters, `sc`, the scenarios, `reset`, and `pgKey`, which mounts
 * the copy afresh when the story changes (props read only at mount).
 */
export function playgroundLogic(c: ComponentStories, pg: Playground): string {
  const stories = Object.fromEntries(
    [pg.base, ...pg.scenarios].map((s) => [s, c.stories[s]?.args ?? {}]),
  );
  const controls = pg.controls.map((k) => k.prop);
  return `    const p = this.props || {};
    const st = this.state || {};
    const stories = hydrate(${js(stories)});
    const story = st.story || ${js(pg.base)};
    const chosen = stories[story] || {};
    const pgv = st.pg || {};
    const put = (k, x) => this.setState({ story, pg: { ...pgv, [k]: x } });
    const none = (x) => (x === '${NONE}' || x === '' ? undefined : x);
    const cur = (k) => (k in pgv ? pgv[k] : st.story ? chosen[k] : p[k] !== undefined ? p[k] : chosen[k]);
    const controls = ${js(controls)};
    const live = {};
    for (const k of ${js(pg.keys)}) live[k] = controls.includes(k) ? none(cur(k)) : chosen[k];
    const enc = (x) => (x === undefined || x === null || x === '' ? '${NONE}' : String(x));
    const dk = {};
    for (const k of controls) {
      dk[k] = {
        on: cur(k) === true,
        value: enc(cur(k)),
        text: cur(k) === undefined || cur(k) === null ? '' : String(cur(k)),
        set: (x) => put(k, x),
        setNumber: (x) => put(k, x === '' ? 0 : Number(x)),
      };
    }
    const sc = {};
    for (const s of ${js(pg.scenarios)}) sc[s] = () => this.setState({ story: s, pg: {} });
    const reset = () => this.setState({ story: undefined, pg: {} });
    // A prop read only at mount (defaultValue, defaultChecked) takes effect on a fresh copy.
    const pgKey = story + ':' + JSON.stringify(controls.filter((k) => /^default[A-Z]/.test(k)).map((k) => cur(k)));`;
}

function control(k: Control, mounts: Mounts, words: (s: string) => string): string {
  const path = `dk.${k.prop}`;
  if (k.editor === 'boolean') {
    return mounts.tag(
      'Switch',
      { label: k.prop },
      { checked: `${path}.on`, onCheckedChange: `${path}.set` },
    );
  }
  if (k.editor === 'enum') {
    const items = (k.options ?? []).map((o) => ({
      value: o,
      label: o === NONE ? words('none') : o,
    }));
    return mounts.tag(
      'Select',
      { label: k.prop, items, density: 'compact' },
      { value: `${path}.value`, onValueChange: `${path}.set` },
    );
  }
  return mounts.tag(
    'TextField',
    { label: k.prop, density: 'compact', ...(k.editor === 'int' ? { inputMode: 'numeric' } : {}) },
    {
      value: `${path}.text`,
      onValueChange: k.editor === 'int' ? `${path}.setNumber` : `${path}.set`,
    },
  );
}

export interface PlaygroundText {
  title: string;
  note: string;
  props: string;
  reset: string;
  scenarios: string;
  caption: (story: string) => string;
  none: string;
}

/** The playground section: the copy, and the panel beside it (at the start, RTL). */
export function playgroundSection(
  c: ComponentStories,
  pg: Playground,
  mounts: Mounts,
  text: PlaygroundText,
  styles: { panel: string; head: string; muted: string; aside: string },
): string {
  const holes = Object.fromEntries(pg.keys.map((k) => [k, `live.${k}`]));
  const copy = mounts.tag(mountOf(c, pg.base), {}, { ...holes, key: 'pgKey' });
  const controls = pg.controls
    .map((k) => `          ${control(k, mounts, () => text.none)}`)
    .join('\n');
  const scenarios = pg.scenarios
    .map(
      (s) =>
        `            ${mounts.tag('Button', { children: text.caption(s), variant: 'secondary', density: 'compact' }, { onClick: `sc.${s}` })}`,
    )
    .join('\n');
  const scenarioBlock = scenarios
    ? `          <div style="display: flex; flex-direction: column; gap: var(--fd-space-xs);">
            <span style="${styles.muted}">${esc(text.scenarios)}</span>
            <div style="display: flex; flex-wrap: wrap; gap: var(--fd-space-xs);">
${scenarios}
            </div>
          </div>\n`
    : '';
  return `    <section data-playground style="${styles.panel}">
      <div style="${styles.head}"><strong>${esc(text.title)}</strong><span style="${styles.muted}">${esc(text.note)}</span></div>
      <div style="display: grid; grid-template-columns: minmax(0, 1fr) 360px; gap: var(--fd-space-lg); align-items: stretch;">
        <div data-stage style="display: flex; justify-content: center; align-items: center; min-height: 200px; padding: var(--fd-space-lg); min-width: 0;">
          <div style="display: flex; flex-direction: column; align-items: center; max-width: 100%;">${copy}</div>
        </div>
        <aside data-dock style="${styles.aside}">
          <div style="display: flex; align-items: center; justify-content: space-between; gap: var(--fd-space-xs);">
            <strong>${esc(text.props)}</strong>
            ${mounts.tag('Button', { children: text.reset, variant: 'ghost', density: 'compact' }, { onClick: 'reset' })}
          </div>
${scenarioBlock}${controls}
        </aside>
      </div>
    </section>`;
}
