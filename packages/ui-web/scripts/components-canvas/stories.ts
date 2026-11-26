// What each board of the "Fox Drop Components" canvas shows, read from the
// code: a component's `STATES` (and `VARIANTS`) in src/<folder>/<folder>.tsx and
// the args of the story that covers each state (test/stories.test.ts keeps one
// per state). The stories load in Node through Vite's SSR module loader; their
// `play` functions are never run, only noticed (a story that opens its popup).
import path from 'node:path';
import { createElement, type ReactElement } from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { createServer, type ViteDevServer } from 'vite';
import { PACKAGE_DIR } from '../bundle.ts';

/** A prop value as the canvas can carry it: JSON, with elements and functions marked. */
export type Value =
  | string
  | number
  | boolean
  | null
  | Value[]
  | { [key: string]: Value }
  | { $el: string; props: Record<string, Value> }
  | { $fn: true }
  | { $date: string }
  | { $set: Value[] }
  | { $html: string }
  | { $memo: [string, Value][] };

/** Turns an element of a component outside the library into its static markup. */
type Markup = (element: unknown) => string;

/** The inputs a function prop is called with, by prop name: its results cross as a table. */
type Samples = Record<string, unknown[]>;

/**
 * The props that are functions giving content, and what they are called
 * with, by component (read from their types in docs.ts): a DataTable's cells,
 * row keys and names over its rows; a BannerStack's counter over the hidden counts.
 */
const CALLS: Record<string, (args: Record<string, unknown>) => Samples> = {
  DataTable: (args) => {
    const rows = (args['rows'] as unknown[] | undefined) ?? [];
    return { cell: rows, rowKey: rows, rowLabel: rows };
  },
  BannerStack: (args) => {
    const banners = (args['banners'] as unknown[] | undefined) ?? [];
    return { moreLabel: banners.map((_, i) => i + 1) };
  },
};

export type Args = Record<string, Value>;

export interface StoryInfo {
  args: Args;
  /** It opens or drives its component in the browser (`play`). */
  play: boolean;
  /** It draws through a `render` of its own whose component could not be read: its args are an approximation. */
  render: boolean;
  /** What it mounts when not its board's component (`BlockingHeads.ShopSign`). */
  component?: string;
  /** The story's `parameters.canvas`: how its board draws a `play` it cannot run. */
  canvas?: CanvasParameters;
}

/**
 * A story's `parameters.canvas`. By default a `play` opens its popup, drawn open
 * in place (`inline`) when the component can be. `open: false` says the play
 * opens nothing (it types into a field); `gesture: true` that the play does
 * more than the drawing shows (types a reason after opening), said in its caption.
 */
export interface CanvasParameters {
  open?: boolean;
  gesture?: boolean;
}

/** The story opens its popup (`play`), unless its parameters say otherwise. */
export const opens = (info: StoryInfo | undefined) =>
  info?.play === true && info.canvas?.open !== false;

export interface ComponentStories {
  name: string;
  folder: string;
  states: string[];
  variants: string[] | null;
  /** The story of each `<Variant><State>` (with variants) or `<State>` (without). */
  cells: Record<string, string>;
  stories: Record<string, StoryInfo>;
}

/** The blocking heads share one folder, as their Flutter file (test/stories.test.ts). */
const FOLDERS: Record<string, string> = {
  BlockingHeads: 'blocking-heads',
  VersionTicket: 'blocking-heads',
  ShopSign: 'blocking-heads',
};
export const folderOf = (name: string) =>
  FOLDERS[name] ?? name.replace(/(?!^)([A-Z])/g, '-$1').toLowerCase();
export const pascal = (state: string) => state.charAt(0).toUpperCase() + state.slice(1);

const REACT_ELEMENT = Symbol.for('react.transitional.element');
const REACT_ELEMENT_18 = Symbol.for('react.element');
const REACT_FRAGMENT = Symbol.for('react.fragment');

/** Components the bundle exposes only as parts of another (scripts/bundle-entry.ts). */
const PARTS: Record<string, string> = {
  VersionTicket: 'BlockingHeads.VersionTicket',
  ShopSign: 'BlockingHeads.ShopSign',
};

/** Names of the library's components, as the bundle calls them, by identity (parts too). */
function namesOf(library: Record<string, unknown>): Map<unknown, string> {
  const names = new Map<unknown, string>();
  for (const [name, value] of Object.entries(library)) {
    if (!/^[A-Z]/.test(name) || typeof value !== 'function') continue;
    names.set(value, PARTS[name] ?? name);
    for (const [part, inner] of Object.entries(value)) {
      if (/^[A-Z]/.test(part) && (typeof inner === 'function' || typeof inner === 'object')) {
        names.set(inner, `${name}.${part}`);
      }
    }
  }
  return names;
}

/** A story's value as the canvas carries it; `where` names it in an error. */
export function serialise(
  value: unknown,
  names: Map<unknown, string>,
  where: string,
  markup?: Markup,
  samples: Samples = {},
): Value | undefined {
  if (value === undefined) return undefined;
  if (value === null || ['string', 'number', 'boolean'].includes(typeof value)) {
    return value as Value;
  }
  if (typeof value === 'function') {
    // A function that gives content (a table cell, a counter's words): its
    // results for the inputs the story gives it, looked up on the canvas.
    const known = samples[where.split('.').at(-1) ?? ''];
    if (!known) return { $fn: true };
    const fn = value as (input: unknown) => unknown;
    return {
      $memo: known.map((input, i) => [
        JSON.stringify(input),
        serialise(fn(input), names, `${where}(${String(i)})`, markup, samples) ?? null,
      ]),
    };
  }
  if (value instanceof Date) return { $date: value.toISOString() };
  if (value instanceof Set) {
    return {
      $set: [...value].map(
        (item, i) => serialise(item, names, `${where}{${String(i)}}`, markup, samples) ?? null,
      ),
    };
  }
  if (Array.isArray(value)) {
    return value.map(
      (item, i) => serialise(item, names, `${where}[${String(i)}]`, markup, samples) ?? null,
    );
  }
  const node = value as { $$typeof?: symbol; type?: unknown; props?: Record<string, unknown> };
  if (node.$$typeof === REACT_ELEMENT || node.$$typeof === REACT_ELEMENT_18) {
    const type =
      typeof node.type === 'string'
        ? node.type
        : node.type === REACT_FRAGMENT
          ? '$fragment'
          : names.get(node.type);
    // A component outside the library (the SDK's input inside a story's Field)
    // cannot cross into the canvas: its markup does, static.
    if (type === undefined) {
      if (markup) return { $html: markup(node) };
      throw new Error(`${where}: an element of a component outside the library`);
    }
    return {
      $el: type,
      props: serialiseProps(node.props ?? {}, names, `${where}.props`, markup, samples),
    };
  }
  if (Object.getPrototypeOf(value) === Object.prototype) {
    return serialiseProps(value as Record<string, unknown>, names, where, markup, samples);
  }
  throw new Error(`${where}: a value the canvas cannot carry`);
}

function serialiseProps(
  props: Record<string, unknown>,
  names: Map<unknown, string>,
  where: string,
  markup?: Markup,
  samples: Samples = {},
): Record<string, Value> {
  const out: Record<string, Value> = {};
  for (const [key, inner] of Object.entries(props)) {
    const value = serialise(inner, names, `${where}.${key}`, markup, samples);
    if (value !== undefined) out[key] = value;
  }
  return out;
}

/** A server that loads the sources as Storybook does, without its runtime. */
export async function storyServer(): Promise<ViteDevServer> {
  return createServer({
    root: PACKAGE_DIR,
    configFile: false,
    logLevel: 'silent',
    appType: 'custom',
    server: { middlewareMode: true, hmr: false, ws: false },
    resolve: {
      alias: { 'storybook/test': path.join(import.meta.dirname, 'storybook-test-stub.ts') },
    },
    optimizeDeps: { noDiscovery: true, include: [] },
  });
}

interface StoryExport {
  args?: Record<string, unknown>;
  play?: unknown;
  render?: unknown;
  parameters?: { canvas?: CanvasParameters };
}

interface Element {
  $$typeof?: symbol;
  type?: unknown;
  props?: Record<string, unknown>;
}

/**
 * What a story's `render` draws: the first library component in the element
 * it returns, with its props, so a story that frames its component or draws one
 * part keeps its look. None when `render` only wraps state in a component of
 * the story's own (its args are then the story) or uses hooks outside React.
 * A wrapper of the story's own given the meta component's props (Sidebar's
 * phone drawer, which holds its open state) draws the meta component with them.
 */
function drawnBy(
  render: unknown,
  args: Record<string, unknown>,
  names: Map<unknown, string>,
  meta: { name: string | undefined; type: unknown },
): { name: string; type: unknown; props: Record<string, unknown> } | 'args' | undefined {
  if (typeof render !== 'function') return undefined;
  let root: unknown;
  try {
    root = (render as (a: unknown, c: unknown) => unknown)(args, { args });
  } catch {
    return undefined;
  }
  // A wrapper of the story's own that gets the args as they are (QuantityStepper's
  // counter): the args are the story.
  const top = root as Element | null;
  const props = top?.props ?? {};
  const own = typeof top?.type === 'function' && !names.get(top.type);
  if (own && Object.keys(args).length === 0 && Object.keys(props).length > 0 && meta.name) {
    return { name: meta.name, type: meta.type, props };
  }
  if (Object.entries(args).every(([key, value]) => props[key] === value)) {
    if (own) return 'args';
  }
  const queue: unknown[] = [root];
  while (queue.length > 0) {
    const node = queue.shift() as Element | null | undefined;
    if (Array.isArray(node)) {
      queue.push(...(node as unknown[]));
      continue;
    }
    if (!node || (node.$$typeof !== REACT_ELEMENT && node.$$typeof !== REACT_ELEMENT_18)) continue;
    const name = names.get(node.type);
    if (name) return { name, type: node.type, props: node.props ?? {} };
    queue.push(node.props?.['children']);
  }
  return undefined;
}

/** Every named component's states, variants and stories. */
export async function readStories(
  server: ViteDevServer,
  components: readonly string[],
): Promise<ComponentStories[]> {
  const library = (await server.ssrLoadModule('/src/index.ts')) as Record<string, unknown>;
  const names = namesOf(library);
  // A child from outside the library is drawn inside the component it came from
  // (a Field's input takes the field's disabled), then only the child's markup
  // is kept. Vite leaves React to Node, so this is the stories' own React.
  const markupIn =
    (type: unknown, props: Record<string, unknown>): Markup =>
    (element) => {
      const slot = createElement('fd-slot', null, element as ReactElement);
      const html = renderToStaticMarkup(
        createElement(type as string, { ...props, children: slot }),
      );
      const inner = /<fd-slot>([\s\S]*)<\/fd-slot>/.exec(html)?.[1];
      if (inner === undefined) throw new Error('a drawn component did not render its child');
      // The ids of a render on the server name nothing on the canvas, and repeat on each copy.
      return inner.replace(/\s(?:id|aria-labelledby|aria-describedby)="[^"]*"/g, '');
    };
  const out: ComponentStories[] = [];
  for (const name of components) {
    const folder = folderOf(name);
    const module = (await server.ssrLoadModule(`/src/${folder}/${folder}.tsx`)) as {
      STATES?: readonly string[];
      VARIANTS?: readonly string[];
    };
    const csf = (await server.ssrLoadModule(`/src/${folder}/${folder}.stories.tsx`)) as Record<
      string,
      StoryExport
    > & { default: StoryExport & { component?: unknown } };
    const meta = csf.default;
    const metaArgs = meta.args ?? {};
    // The story's component as the bundle names it, when not the board's own
    // (the blocking heads' two parts).
    const metaName = names.get(meta.component);
    const stories: Record<string, StoryInfo> = {};
    for (const [story, exported] of Object.entries(csf)) {
      if (story === 'default' || !/^[A-Z]/.test(story)) continue;
      const value = exported as StoryExport;
      const merged = { ...metaArgs, ...value.args };
      const where = `${name}.${story}`;
      const result = drawnBy(value.render ?? meta.render, merged, names, {
        name: metaName,
        type: meta.component,
      });
      const drawn = typeof result === 'object' ? result : undefined;
      const component = drawn?.name ?? metaName;
      const props = drawn?.props ?? merged;
      const samples = CALLS[name]?.(props) ?? {};
      stories[story] = {
        args: drawn
          ? serialiseProps(props, names, where, markupIn(drawn.type, props), samples)
          : serialiseProps(props, names, where, undefined, samples),
        play: typeof value.play === 'function',
        render: typeof value.render === 'function' && result === undefined,
        ...(component && component !== name && { component }),
        ...(value.parameters?.canvas && { canvas: value.parameters.canvas }),
      };
    }
    const states = [...(module.STATES ?? [])];
    const variants = module.VARIANTS ? [...module.VARIANTS] : null;
    const cells: Record<string, string> = {};
    const keys = Object.keys(stories);
    for (const state of states) {
      for (const variant of variants ?? [null]) {
        const key = variant ? `${pascal(variant)}${pascal(state)}` : pascal(state);
        const story = variant
          ? keys.find((k) => k === key)
          : (keys.find((k) => k === key) ?? keys.find((k) => k.endsWith(key)));
        if (!story) throw new Error(`${name}: no story for ${key}`);
        cells[key] = story;
      }
    }
    out.push({ name, folder, states, variants, cells, stories });
  }
  return out;
}
