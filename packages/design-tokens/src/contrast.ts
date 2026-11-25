// The colour pairs every surface must pass (architecture §9.5 R4, brand
// expression §6), and the report generate.ts writes from them.
import { contrast } from './color.ts';
import { colour, type Theme, type Token } from './resolve.ts';

export type Surface = 'phone' | 'panel' | 'captain';

export interface Pair {
  foreground: string;
  background: string;
  target: number;
  use: string;
  /** Why the owner accepts this pair below its target; only brand-orange pairs. */
  exception?: string;
  /** With an exception: the ratio the pair must still reach, today's value rounded down. */
  floor?: number;
}

/**
 * The owner's decision of 2026-11-23: the brand orange `#FF6E31` carries
 * filled controls and bars in every app, as the Figma file draws it,
 * although it misses 4.5:1 (architecture §9.5 R4). Headings left it for the
 * brand blue on 2026-11-25 (identity package V1.1). The report lists these
 * pairs with their ratios; a test keeps the exception to them.
 */
export const ORANGE = new Set(['brand', 'primary', 'primary-hover', 'primary-pressed']);
const EXCEPTION = 'owner, 2026-11-23: the brand orange as in the Figma file';

export const BACKGROUNDS = ['surface', 'surface-raised'];
// The grounds of a control under the pointer or pressed (R10): transient, so
// only its own label (on-surface) and the focus ring must read on them.
export const STATE_BACKGROUNDS = [
  'surface-hover',
  'surface-pressed',
  'surface-raised-hover',
  'surface-raised-pressed',
];
const on = (names: string[], target: number, use: string, backgrounds = BACKGROUNDS): Pair[] =>
  names.flatMap((foreground) =>
    backgrounds.map((background) => ({ foreground, background, target, use })),
  );
const excepted = (pairs: Pair[], floor: number): Pair[] =>
  pairs.map((p) => ({ ...p, exception: EXCEPTION, floor }));

// The owner allows orange anywhere, text and numbers included (2026-11-23):
// any orange text or number uses `primary`.
const orangeText = excepted(on(['primary'], 4.5, 'orange text'), 2.4);
const orangeFills = excepted(
  ['primary', 'primary-hover', 'primary-pressed'].map((background) => ({
    foreground: 'on-primary',
    background,
    target: 4.5,
    use: 'filled control label',
  })),
  2.6,
);

const FILLS: [string, string][] = [
  ['on-accent', 'accent'],
  ['on-success', 'success'],
  ['on-warning', 'warning'],
  ['on-danger', 'danger'],
  ['on-info', 'info'],
];
const fills: Pair[] = FILLS.map(([foreground, background]) => ({
  foreground,
  background,
  target: 4.5,
  use: 'filled control label',
}));
// The danger fill under the pointer and pressed (R10).
const dangerStates = (target: number): Pair[] =>
  ['danger-hover', 'danger-pressed'].map((background) => ({
    foreground: 'on-danger',
    background,
    target,
    use: 'filled control label',
  }));
const dangerButton = dangerStates(4.5);
// The captain's danger is red.800, so its Button label reads at 7:1 on the fill too.
const captainDangerButton: Pair[] = [
  ...dangerStates(7),
  { foreground: 'on-danger', background: 'danger', target: 7, use: 'filled control label' },
];
const states = (target: number): Pair[] => [
  ...on(['on-surface'], target, 'control label, hovered or pressed', STATE_BACKGROUNDS),
  ...on(['focus-ring'], 3, 'focus ring, hovered or pressed', STATE_BACKGROUNDS),
];
const nonText = on(
  ['border-strong', 'border-hover', 'border-pressed', 'focus-ring'],
  3,
  'control boundary, focus ring, icon',
);
// Forms (D.8, owner 2026-11-23): a focused field's outline, a checked box, the
// switch's track, the stepper's circles and the orange icons inside controls
// (the search lens, the stepper's signs, the select's tick) are the brand
// orange, under the same exception extended to 3:1 non-text elements.
const orangeBoundary = excepted(
  on(['primary'], 3, 'control boundary, checked control, icon in a control'),
  2.5,
);
// Icon set v4 Madar (D.5b, owner 2026-11-24): Brand Duo strokes an icon's
// accent in `brand`, on the grounds and in the empty state's drop.
const brandAccent = excepted(
  [
    ...on(['brand'], 3, 'icon accent (Brand Duo)'),
    {
      foreground: 'brand',
      background: 'primary-subtle',
      target: 3,
      use: 'icon accent in the empty state (Brand Duo)',
    },
  ],
  2.4,
);
// The sign-in and frame components (D.11b, owner 2026-11-24): a text link's
// hover and pressed ink, and the tracking steps' current label, in the
// deeper oranges, under the same exception.
const orangeStateText = excepted(
  on(
    ['primary-hover', 'primary-pressed'],
    4.5,
    'orange text, hovered or pressed; the current step',
  ),
  3.6,
);
// The masked code of the WhatsApp preview on its blue bubble (D.11b). The
// hero's art (badges, dish circles) is decoration, read as words, so it has
// no pair.
const codeMask: Pair[] = [
  {
    foreground: 'primary-pressed',
    background: 'info-subtle',
    target: 4.5,
    use: 'the masked code in the code preview',
  },
];
// Alerts are read from across a room: the restaurant tablet, the panel (§6).
const alerts: Pair[] = [
  { foreground: 'on-alert', background: 'alert', target: 7, use: 'alert' },
  ...on(['alert'], 7, 'alert'),
];
const statusText = ['success', 'warning', 'danger', 'info'];
// Data display (D.9, owner 2026-11-24): a status chip, a timer and a state
// badge put their tone's text on its own tint; running timers and a selected
// table row put on-surface on the info and primary tints.
const TINTS: [string, string][] = [
  ['success', 'success-subtle'],
  ['warning', 'warning-subtle'],
  ['danger', 'danger-subtle'],
  ['info', 'info-subtle'],
  ['neutral', 'neutral-subtle'],
  ['caution', 'caution-subtle'],
  ['on-primary-subtle', 'primary-subtle'],
  ['on-surface', 'info-subtle'],
  ['on-surface', 'primary-subtle'],
];
const tints = (target: number): Pair[] =>
  TINTS.map(([foreground, background]) => ({
    foreground,
    background,
    target,
    use: 'status text on its tint',
  }));

/** The required pairs of each surface; the colour names are under `color.`. */
export const PAIRS: Record<Surface, Pair[]> = {
  phone: [
    ...on(['on-surface', 'on-surface-muted', 'heading', 'accent'], 4.5, 'text'),
    ...on(statusText, 4.5, 'status text'),
    ...tints(4.5),
    ...fills,
    ...dangerButton,
    ...states(4.5),
    ...nonText,
    ...alerts,
    ...orangeText,
    ...orangeFills,
    ...orangeBoundary,
    ...brandAccent,
    ...orangeStateText,
    ...codeMask,
  ],
  panel: [
    ...on(['on-surface', 'on-surface-muted', 'heading', 'accent'], 4.5, 'text'),
    ...on(statusText, 4.5, 'status text'),
    ...tints(4.5),
    ...fills,
    ...dangerButton,
    ...states(4.5),
    ...nonText,
    ...alerts,
    ...orangeText,
    ...orangeFills,
    ...orangeBoundary,
    ...brandAccent,
    ...orangeStateText,
    ...codeMask,
  ],
  // Text and numbers at 7:1 in near-black or blue; orange only on buttons and
  // headings, under the owner's exception (§6).
  captain: [
    ...on(['on-surface', 'on-surface-muted', 'heading', 'accent'], 7, 'text and numbers'),
    ...on(statusText, 7, 'status text'),
    ...tints(7),
    ...fills,
    ...captainDangerButton,
    ...states(7),
    ...nonText,
    ...orangeText,
    ...orangeFills,
    ...orangeBoundary,
    ...brandAccent,
    ...orangeStateText,
  ],
};

/**
 * Interaction states (architecture §9.5 R10, owner 2026-11-24): every
 * interactive component takes its hover and pressed colours from one of these
 * rest/hover/pressed triples, and each step is measured in CIEDE2000. With a
 * pointer, hover stands MIN_HOVER from rest and pressed MIN_PRESS beyond hover;
 * on touch, where there is no hover, pressed stands MIN_HOVER from rest.
 */
export const STATE_TRIPLES: [rest: string, hover: string, pressed: string][] = [
  ['primary', 'primary-hover', 'primary-pressed'],
  ['danger', 'danger-hover', 'danger-pressed'],
  ['surface', 'surface-hover', 'surface-pressed'],
  ['surface-raised', 'surface-raised-hover', 'surface-raised-pressed'],
  ['border-strong', 'border-hover', 'border-pressed'],
];
export const MIN_HOVER = 8;
export const MIN_PRESS = 5;
export const POINTER_THEMES: Theme[] = ['light', 'dark'];

/** The themes a surface is drawn in. */
export const SURFACE_THEMES: Record<Surface, Theme[]> = {
  phone: ['light', 'dark'],
  panel: ['light', 'dark'],
  captain: ['captainLight', 'captainDark'],
};

export interface Result extends Pair {
  surface: Surface;
  theme: Theme;
  fg: string;
  bg: string;
  ratio: number;
  pass: boolean;
}

export function check(themes: Record<Theme, Map<string, Token>>): Result[] {
  return (Object.keys(PAIRS) as Surface[]).flatMap((surface) =>
    SURFACE_THEMES[surface].flatMap((theme) =>
      PAIRS[surface].map((pair) => {
        const fg = colour(themes[theme], `color.${pair.foreground}`);
        const bg = colour(themes[theme], `color.${pair.background}`);
        const ratio = contrast(fg, bg);
        return { ...pair, surface, theme, fg, bg, ratio, pass: ratio >= pair.target };
      }),
    ),
  );
}

/** A pair below its target that no exception covers, or below its exception's floor. */
export const failing = (r: Result) => (r.exception ? r.ratio < (r.floor ?? r.target) : !r.pass);

export function report(results: Result[]): string {
  const failed = results.filter(failing).length;
  const excused = results.filter((r) => !r.pass && !failing(r)).length;
  const verdict = (r: Result) => (r.pass ? 'pass' : failing(r) ? '**FAIL**' : 'owner exception');
  const rows = results.map(
    (r) =>
      `| ${r.surface} | ${r.theme} | ${r.foreground} \`${r.fg}\` | ${r.background} \`${r.bg}\` | ${r.use} | ${r.ratio.toFixed(2)} | ${r.target} | ${verdict(r)} |`,
  );
  return [
    '# Contrast report',
    '',
    'Generated by `pnpm --filter @fox-drop/design-tokens generate` from the pairs in `src/contrast.ts` (architecture §9.5 R4, brand expression §6). Do not edit.',
    '',
    `${results.length} pairs, ${failed} failing, ${excused} below target under the owner's exception for the brand orange (${EXCEPTION}). The dark theme holds a copy of the light values until dark mode is designed.`,
    '',
    '| Surface | Theme | Foreground | Background | Use | Ratio | Target | Result |',
    '| --- | --- | --- | --- | --- | --- | --- | --- |',
    ...rows,
    '',
  ].join('\n');
}
