// The artboard shell of the "Fox Drop Components" canvas: the head that loads
// the system's bundle (its CSS carries the --fd-* variables) and the board's
// own forced-states sheet, CoFo from the canvas's uploads, the
// logic class, the Tweaks it declares, and real components mounted with
// `<x-import component-from-global-scope="FoxDrop.X">`. Values that are not
// text travel through the logic class (`{{ v.pN }}`), where `hydrate` turns a
// story's marked elements and functions back into the page's own (stories.ts).
import type { Value } from './stories.ts';

/** Every board is this wide. */
export const WIDTH = 1440;

export const esc = (s: unknown) =>
  String(s)
    .replaceAll('&', '&amp;')
    .replaceAll('"', '&quot;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

export const kebab = (k: string) =>
  k.startsWith('aria-') || k.startsWith('data-')
    ? k
    : k.replace(/[A-Z]/g, (m) => `-${m.toLowerCase()}`);

/** Props as attributes: text inline, anything else through the logic class's values. */
export class Mounts {
  readonly vals: Record<string, Value> = {};
  #n = 0;

  /** `holes` maps a prop to a value path of `renderVals()` (the playground's state). */
  tag(component: string, props: Record<string, Value>, holes: Record<string, string> = {}) {
    const attrs: string[] = [];
    for (const [k, v] of Object.entries(props)) {
      if (k in holes) continue;
      if (typeof v === 'string') {
        attrs.push(`${kebab(k)}="${esc(v)}"`);
      } else {
        this.#n += 1;
        const key = `p${String(this.#n)}`;
        this.vals[key] = v;
        attrs.push(`${kebab(k)}="{{ v.${key} }}"`);
      }
    }
    for (const [k, path] of Object.entries(holes)) attrs.push(`${kebab(k)}="{{ ${path} }}"`);
    const list = attrs.length > 0 ? ` ${attrs.join(' ')}` : '';
    return `<x-import component-from-global-scope="FoxDrop.${component}"${list}></x-import>`;
  }
}

/** One tweak of the board (`data-props` entry). */
export interface TweakDef {
  editor: 'text' | 'boolean' | 'enum' | 'int';
  default: unknown;
  options?: unknown[];
  section: string;
}

/** CoFo's weights as uploaded to the Design System (the config's `fonts`). */
export type Fonts = Record<string, string>;

interface PageInput {
  title: string;
  /** The board's forced-states sheet, `support/states/<file>.css`; none for the index. */
  states?: string;
  w: number;
  h: number;
  fonts: Fonts;
  tweaks?: Record<string, TweakDef>;
  /** The body of `renderVals()` after `v` is hydrated: plain JS returning the values. */
  logic: string;
  vals: Record<string, Value>;
  body: string;
}

/**
 * The statements that rebuild the story values in the page: elements with the
 * page's React (the canvas's React 18; the bundle's bridge converts them) and
 * the bundle's components, a function that gives content as its table of
 * results, any other function as a 1.5 s wait (a request in flight).
 */
export const HYDRATE = `    const R = window.React;
    const FD = window.FoxDrop;
    const typeOf = (name) =>
      name === '$fragment' ? R.Fragment : /^[A-Z]/.test(name) ? name.split('.').reduce((at, part) => at[part], FD) : name;
    const hydrate = (x) => {
      if (Array.isArray(x)) return x.map(hydrate);
      if (x === null || typeof x !== 'object') return x;
      // A callback waits as a request would, so a press shows its pending state.
      if (x.$fn) return () => new Promise((done) => setTimeout(done, 1500));
      if (x.$memo) {
        const table = new Map(x.$memo.map(([input, out]) => [input, hydrate(out)]));
        // A call with more than one argument (a chip name and code) is keyed by their list.
        return (...input) => table.get(JSON.stringify(input.length > 1 ? input : input[0]));
      }
      if (x.$date) return new Date(x.$date);
      if (x.$set) return new Set(x.$set);
      if (x.$html !== undefined) return R.createElement('div', { style: { display: 'contents' }, dangerouslySetInnerHTML: { __html: x.$html } });
      if (x.$el) return R.createElement(typeOf(x.$el), hydrate(x.props));
      return Object.fromEntries(Object.entries(x).map(([k, y]) => [k, hydrate(y)]));
    };`;

/** A value as JavaScript inside the board's `<script>`: `<` escaped, so no `</script` ends it. */
export const js = (value: unknown) => JSON.stringify(value).replaceAll('<', '\\u003c');

/** `data-props` is an HTML attribute in single quotes: & and ' are escaped. */
const propsAttr = (value: unknown) =>
  JSON.stringify(value).replaceAll('&', '&amp;').replaceAll("'", '&#39;');

function faces(fonts: Fonts): string {
  return Object.entries(fonts)
    .map(
      ([weight, url]) =>
        `@font-face{font-family:"CoFo Sans Pro Arabic";src:url("${url}");font-weight:${weight};font-style:normal}`,
    )
    .join('\n');
}

export function page(input: PageInput): string {
  const { title, states, w, h, fonts, tweaks = {}, logic, vals, body } = input;
  const statesLink = states ? `\n<link rel="stylesheet" href="${states}">` : '';
  return `<!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<title>${esc(title)}</title>
<script src="./support.js"></script>
<link rel="stylesheet" href="ds/fox-drop/components/bundle.css">${statesLink}
<script src="ds/fox-drop/components/bundle.js"></script>
</head>
<body>
<x-dc>
<helmet>
<style>
${faces(fonts)}
body{margin:0}
*,*::before,*::after{box-sizing:border-box}
a{color:var(--fd-color-heading)}
</style>
</helmet>
${body}
</x-dc>
<script type="text/x-dc" data-dc-script data-props='${propsAttr({ ...tweaks, $preview: { width: w, height: h } })}'>
class Component extends DCLogic {
  renderVals() {
${HYDRATE}
    const v = hydrate(${js(vals)});
${logic}
  }
}
</script>
</body>
</html>
`;
}
