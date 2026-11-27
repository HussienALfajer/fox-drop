// Runs in the page (check.ts passes it to page.evaluate): renders an artboard as
// the canvas runtime does for the given Tweaks and board state: the logic
// class's `renderVals()`, `<sc-if>` branches, `{{ }}` holes in attributes and
// text, each x-import mounted as the bundle's component by the page's React 18
// (so the bundle's bridge runs as on the canvas); then measures it.
// Self-contained: it is serialised into the page. After the Shifa project's.

export interface BoardResult {
  missing: string[];
  over: string[];
  natural: number | null;
  content: number;
  frame: number;
  classes: string[];
}

export async function renderBoard({
  src,
  props,
  state,
  measureHeight,
  live = false,
}: {
  src: string;
  props: Record<string, unknown>;
  state: Record<string, unknown>;
  measureHeight: boolean;
  /** Play: `setState` merges the state and draws the board again, as the canvas does. */
  live?: boolean;
}): Promise<BoardResult> {
  let repaint = (): void => undefined;
  class DCLogic {
    props: Record<string, unknown> = props;
    state: Record<string, unknown> = state;
    setState(next: Record<string, unknown>): void {
      // Without `live` a check renders the board once, as its Tweaks and state set it.
      if (!live) return;
      this.state = { ...this.state, ...next };
      setTimeout(repaint, 0);
    }
  }
  (globalThis as unknown as { DCLogic: typeof DCLogic }).DCLogic = DCLogic;
  const Logic = (0, eval)(
    `(${src.replace('class Component extends DCLogic', 'class extends DCLogic')})`,
  ) as new () => { renderVals: () => Record<string, unknown> };
  const logic = new Logic();
  const missing: string[] = [];
  const root = document.getElementById('root');
  if (!root) throw new Error('no #root');
  type Host = { createElement: (type: unknown, props: unknown) => unknown };
  type Mounted = { render: (node: unknown) => void; unmount: () => void };
  type HostDom = { createRoot: (el: Element) => Mounted };
  const page = globalThis as unknown as {
    React: Host;
    ReactDOM: HostDom;
    FoxDrop: Record<string, unknown>;
  };
  let roots: Mounted[] = [];
  const paint = (): void => {
    for (const r of roots) r.unmount();
    roots = [];
    root.replaceChildren();
    const vals = logic.renderVals();
    const HOLE = /\{\{\s*([\w.$]+)\s*\}\}/g;
    const get = (path: string): unknown => {
      let at: unknown = vals;
      for (const part of path.split('.')) {
        if (at === null || typeof at !== 'object' || !(part in at)) {
          missing.push(path);
          return undefined;
        }
        at = (at as Record<string, unknown>)[part];
      }
      return at;
    };
    const whole = (value: string) => /^\{\{\s*([\w.$]+)\s*\}\}$/.exec(value)?.[1];
    const asText = (value: unknown): string =>
      typeof value === 'string' ? value : value === undefined ? '' : JSON.stringify(value);
    root.append((document.getElementById('t') as HTMLTemplateElement).content.cloneNode(true));
    for (const branch of [...root.querySelectorAll('sc-if')]) {
      if (!branch.isConnected) continue;
      const path = whole(branch.getAttribute('value') ?? '');
      if (path !== undefined && get(path)) branch.replaceWith(...branch.childNodes);
      else branch.remove();
    }
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT);
    for (let n = walker.nextNode(); n; n = walker.nextNode()) {
      if (n.nodeValue?.includes('{{')) {
        n.nodeValue = n.nodeValue.replace(HOLE, (_, p: string) => asText(get(p)));
      }
    }
    for (const el of root.querySelectorAll('*')) {
      if (el.tagName === 'X-IMPORT') continue;
      for (const a of [...el.attributes]) {
        if (a.value.includes('{{')) {
          el.setAttribute(
            a.name,
            a.value.replace(HOLE, (_, p: string) => asText(get(p))),
          );
        }
      }
    }
    const camel = (k: string) =>
      k.startsWith('aria-') || k.startsWith('data-')
        ? k
        : k.replace(/-([a-z])/g, (_, c: string) => c.toUpperCase());
    for (const el of [...root.querySelectorAll('x-import')]) {
      const name = (el.getAttribute('component-from-global-scope') ?? '').replace('FoxDrop.', '');
      const mounted: Record<string, unknown> = {};
      for (const a of el.attributes) {
        if (a.name === 'component-from-global-scope' || a.name === 'style') continue;
        const path = whole(a.value);
        mounted[camel(a.name)] = path === undefined ? a.value : get(path);
      }
      // As the canvas runtime: text written inside an x-import never reaches the component.
      if ((el.textContent ?? '').trim())
        missing.push(`text inside ${name} (use the children attribute)`);
      const span = document.createElement('span');
      span.style.display = 'contents';
      el.replaceWith(span);
      const type = name
        .split('.')
        .reduce<unknown>(
          (at, part) => (at as Record<string, unknown> | undefined)?.[part],
          page.FoxDrop,
        );
      if (!type) {
        missing.push(`component ${name}`);
        continue;
      }
      const mount = page.ReactDOM.createRoot(span);
      mount.render(page.React.createElement(type, mounted));
      roots.push(mount);
    }
  };
  repaint = paint;
  paint();
  await new Promise((r) => setTimeout(r, 1200));
  const frame = root.firstElementChild as HTMLElement;
  const top = frame.getBoundingClientRect().top;
  const over = new Set<string>();
  for (const el of frame.querySelectorAll('section *')) {
    const section = el.closest('section');
    if (!section) continue;
    // What a scrolling or clipping box inside the panel holds (tabs that scroll) is not over.
    let clipped = false;
    for (let up = el.parentElement; up && up !== section; up = up.parentElement) {
      if (getComputedStyle(up).overflowX !== 'visible') {
        clipped = true;
        break;
      }
    }
    if (clipped) continue;
    const panel = section.getBoundingClientRect();
    const r = el.getBoundingClientRect();
    if (r.width > 0 && (r.right > panel.right + 0.5 || r.left < panel.left - 0.5)) {
      over.add(`${el.tagName} «${(el.textContent ?? '').trim().slice(0, 24)}»`);
    }
  }
  let natural: number | null = null;
  if (measureHeight) {
    const keep = frame.style.height;
    frame.style.height = 'auto';
    natural = Math.ceil(frame.getBoundingClientRect().height);
    frame.style.height = keep;
  }
  const content =
    Math.max(
      ...[...frame.querySelectorAll(':scope > *')].map((e) => e.getBoundingClientRect().bottom),
      top,
    ) - top;
  const classes = new Set<string>();
  for (const el of frame.querySelectorAll('[class]')) for (const c of el.classList) classes.add(c);
  return {
    missing: [...new Set(missing)],
    over: [...over].slice(0, 6),
    natural,
    content: Math.round(content),
    frame: frame.getBoundingClientRect().height,
    classes: [...classes],
  };
}
