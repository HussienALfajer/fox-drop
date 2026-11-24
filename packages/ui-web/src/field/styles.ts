import { createTV } from 'tailwind-variants/config';

// tailwind-merge does not know our `text-<surface>-<role>` font sizes and takes
// them for colours, so a size beside a colour dropped the colour (the Timer
// showed it on a dark Design System page): declare every size of every surface.
export const SIZES = ['phone', 'panel', 'captain'].flatMap((surface) =>
  ['caption', 'secondary', 'body', 'subtitle', 'title', 'large-title', 'number'].map(
    (role) => `${surface}-${role}`,
  ),
);

export const formTv = createTV({
  twMergeConfig: { extend: { classGroups: { 'font-size': [{ text: SIZES }] } } },
});

export type Density = 'comfortable' | 'compact';

/** The keyboard ring of a control that has no outline of its own: the Button's blue (R10). */
export const keyboardRing =
  'outline-hidden focus-visible:ring-2 focus-visible:ring-(color:--fd-input-color-focus-ring) focus-visible:ring-offset-2 focus-visible:ring-offset-surface';

/**
 * The box of a text field, drawn on the approved sheet (`control()` in
 * design-tokens `src/forms-sheet.ts`): `surface-raised`, a 1 `border-strong`
 * outline at rest, `border-hover` on hover, 2 `primary` on focus, 2 `danger`
 * when invalid. The outline is an inset ring, so nothing moves.
 */
export const box = formTv({
  base: [
    'flex items-center gap-(--fd-input-gap) transition-shadow duration-(--fd-duration-base) ease-(--fd-easing-standard)',
  ],
  variants: {
    density: {
      comfortable: 'min-h-(--fd-input-height) px-(--fd-input-padding-inline) text-phone-body',
      compact:
        'min-h-(--fd-input-compact-height) px-(--fd-input-compact-padding-inline) text-panel-body',
    },
    shape: {
      pill: 'rounded-(--fd-input-radius)',
      area: 'rounded-(--fd-input-area-radius)',
    },
    state: {
      rest: [
        'bg-(--fd-input-color-background) text-(color:--fd-input-color-text)',
        'inset-ring-(length:--fd-input-border-width) inset-ring-(color:--fd-input-color-border)',
        'not-focus-within:hover:inset-ring-(color:--fd-input-color-border-hover)',
        'focus-within:inset-ring-(length:--fd-input-focus-width) focus-within:inset-ring-(color:--fd-input-color-border-focus)',
      ],
      invalid: [
        'bg-(--fd-input-color-background) text-(color:--fd-input-color-text)',
        'inset-ring-(length:--fd-input-focus-width) inset-ring-(color:--fd-input-color-border-invalid)',
      ],
      disabled:
        'cursor-not-allowed bg-(--fd-input-color-disabled) text-(color:--fd-input-color-on-disabled)',
    },
  },
  defaultVariants: { density: 'comfortable', shape: 'pill', state: 'rest' },
});

/** The native input or textarea inside the box: it paints nothing. */
export const inputClass = formTv({
  base: [
    'min-w-none flex-1 self-stretch bg-transparent text-start outline-hidden',
    'placeholder:text-(color:--fd-input-color-placeholder)',
    'disabled:cursor-not-allowed disabled:placeholder:text-(color:--fd-input-color-on-disabled)',
  ],
});

/** The state a box shows: an error beats rest, disabled beats both. */
export function boxState(disabled?: boolean, invalid?: boolean): 'rest' | 'invalid' | 'disabled' {
  if (disabled) return 'disabled';
  return invalid ? 'invalid' : 'rest';
}
