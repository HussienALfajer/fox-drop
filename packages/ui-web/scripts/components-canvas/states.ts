// A board's `support/states/<Name>.css` from the system's `bundle.css`: every
// rule that depends on :hover, :active or :focus(-visible) is copied with that
// pseudo-class satisfied by an ancestor attribute, data-pseudo="hover" |
// "hover active" | "focus", so the board shows those states at rest. Same
// declarations, same layer, same order; only the trigger changes. After the
// Shifa project's canvas (states.ts), with one change: a board keeps only the
// rules whose classes occur on it (the check records them), where Shifa ships
// one sheet for every board.
//
// A frame forces the state on every element inside it, which is wrong for a
// control with an inner button. Narrower frames:
// - `data-pseudo-outer`: only the outermost elements with a rule for the state
//   (the field box, not its clear button); the canvas's default;
// - `data-pseudo-nth="N"` (1 to NTH): only the Nth of sibling elements with a
//   rule for it;
// - `data-pseudo-in="<role>"` with `data-pseudo-nth`: the Nth item of a
//   `[role]` container and what is inside it (the second tab).
import postcss, { type AtRule, type Rule } from 'postcss';

const STATES = {
  hover: /(?<!\\):hover(?![-\w])/g,
  active: /(?<!\\):active(?![-\w])/g,
  focus: /(?<!\\):focus(?:-visible)?(?![-\w])/g,
};
type State = keyof typeof STATES;

/** The highest sibling a `data-pseudo-nth` frame can pick. */
export const NTH = 4;

export const ROLES = ['tablist', 'radiogroup', 'group', 'toolbar'] as const;

/** The kinds of frame above; a board's sheet carries only those its copies use. */
export const FRAMES = ['all', 'outer', 'nth', 'role'] as const;
export type Frame = (typeof FRAMES)[number];

/** A copy's forced state as the frame's attribute value. */
export const PSEUDO = { hover: 'hover', pressed: 'hover active', focus: 'focus' } as const;

/** The layer a rule sits in, or undefined when it sits in a block left out. */
function layerOf(rule: Rule): string | null | undefined {
  let layer: string | null = null;
  for (let p = rule.parent; p && p.type !== 'root'; p = p.parent) {
    if (p.type !== 'atrule') continue;
    const at = p as AtRule;
    if (at.name === 'layer') layer = at.params;
    // Plain and (hover: hover) rules only; never keyframes.
    if ((at.name === 'media' && !at.params.includes('hover')) || at.name === 'keyframes') {
      return undefined;
    }
  }
  return layer;
}

/** The class names a selector needs, unescaped (`hover\:bg-x` is `hover:bg-x`). */
export function classesOf(selector: string): string[] {
  const out: string[] = [];
  for (const m of selector.matchAll(/\.((?:\\.|[\w-])+)/g)) {
    out.push((m[1] ?? '').replace(/\\(.)/g, '$1'));
  }
  return out;
}

interface Found {
  rule: Rule;
  layer: string | null;
  state: State;
  selectors: string[];
}

/**
 * The forced copies of every state rule of `bundleCss`. With `classes`, only
 * the selectors whose every class is among them (the board's own).
 */
export function forcedStates(
  bundleCss: string,
  classes?: ReadonlySet<string>,
  frames: readonly Frame[] = FRAMES,
): string {
  const root = postcss.parse(bundleCss);
  const found: Found[] = [];
  const kept = (selector: string) =>
    !classes || classesOf(selector).every((name) => classes.has(name));
  root.walkRules((rule) => {
    if (rule.parent?.type === 'rule') return;
    const layer = layerOf(rule);
    if (layer === undefined) return;
    for (const [state, re] of Object.entries(STATES) as [State, RegExp][]) {
      const selectors = rule.selectors
        .filter((s) => s.match(re) && kept(s))
        .map((s) => s.replace(re, ':is(*)'));
      if (selectors.length > 0) found.push({ rule, layer, state, selectors });
    }
  });
  const subjects = (state: State) =>
    found.filter((f) => f.state === state).flatMap((f) => f.selectors);
  const any: Record<State, string> = {
    hover: subjects('hover').join(','),
    active: subjects('active').join(','),
    focus: subjects('focus').join(','),
  };
  const byLayer = new Map<string | null, string[]>();
  for (const { rule, layer, state, selectors } of found) {
    const frame = `[data-pseudo~="${state}"]`;
    const nths = Array.from({ length: NTH }, (_, i) => String(i + 1));
    // One rule per frame: a selector the browser refuses drops only its own rule.
    const variants = [
      ...(frames.includes('all')
        ? [selectors.map((s) => `${frame}:not([data-pseudo-outer]):not([data-pseudo-nth]) ${s}`)]
        : []),
      ...(frames.includes('outer')
        ? [selectors.map((s) => `${frame}[data-pseudo-outer] ${s}:not(:is(${any[state]}) *)`)]
        : []),
      ...(frames.includes('nth')
        ? nths.map((n) =>
            selectors.map(
              (s) =>
                `${frame}[data-pseudo-nth="${n}"]:not([data-pseudo-in]) ${s}:nth-child(${n} of ${s})`,
            ),
          )
        : []),
      ...(frames.includes('role')
        ? ROLES.flatMap((role) =>
            nths.map((n) => {
              const item = `${frame}[data-pseudo-in="${role}"][data-pseudo-nth="${n}"] [role="${role}"] > :nth-child(${n})`;
              return selectors.flatMap((s) => [`${item}:is(${s})`, `${item} ${s}`]);
            }),
          )
        : []),
    ];
    const rules = byLayer.get(layer) ?? [];
    for (const list of variants) rules.push(rule.clone({ selector: list.join(',') }).toString());
    byLayer.set(layer, rules);
  }
  let css =
    '/* Generated from the Fox Drop Design System bundle.css (hover, pressed and focus shown at rest). Do not edit. */\n';
  for (const [layer, rules] of byLayer) {
    css += layer ? `@layer ${layer}{\n${rules.join('\n')}\n}\n` : `${rules.join('\n')}\n`;
  }
  return css;
}
