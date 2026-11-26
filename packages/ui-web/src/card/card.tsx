import type { ReactNode } from 'react';
import { formTv, keyboardRing } from '../field/styles';

/** The states the stories show (R3). */
export const STATES = ['default', 'offset', 'hover', 'focus', 'pressed', 'danger'] as const;

// The approved sheet (owner, 2026-11-24): the customer app's cards carry the
// Figma file's offset shadow, every other surface a thin outline. A card that
// opens something is one button and takes the raised surface's R10 states.
const card = formTv({
  base: 'flex flex-col gap-(--fd-card-gap) rounded-(--fd-card-radius) bg-(--fd-card-color-background) p-(--fd-card-padding) text-start text-(color:--fd-card-color-text) transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
  variants: {
    elevation: {
      outline: 'inset-ring-(length:--fd-card-border-width) inset-ring-(--fd-card-color-border)',
      offset: 'shadow-offset',
    },
    tone: {
      default: '',
      danger:
        'bg-(--fd-card-danger-background) inset-ring-(length:--fd-card-danger-border-width) inset-ring-(--fd-card-danger-border)',
    },
    pressable: {
      true: `w-full cursor-pointer hover:bg-(--fd-card-color-background-hover) active:bg-(--fd-card-color-background-pressed) ${keyboardRing}`,
    },
  },
  // A late card keeps its red tint under the pointer: the tint is its state.
  compoundVariants: [
    {
      pressable: true,
      tone: 'danger',
      class: 'hover:bg-(--fd-card-danger-background) active:bg-(--fd-card-danger-background)',
    },
  ],
  defaultVariants: { elevation: 'outline', tone: 'default' },
});

export interface CardProps {
  children: ReactNode;
  elevation?: 'outline' | 'offset';
  /** A late order (RA §8.2): a red outline and tint. */
  tone?: 'default' | 'danger';
  /** Opens what the card shows; the card is then one button. */
  onPress?: () => void;
  /** The button's name when it has `onPress`. */
  label?: string;
}

/** The container of a card: raised white on the ground, radius 15. */
export function Card({ children, elevation = 'outline', tone, onPress, label }: CardProps) {
  if (onPress)
    return (
      <button
        type="button"
        aria-label={label}
        onClick={onPress}
        data-elevation={elevation}
        className={card({ elevation, tone, pressable: true })}
      >
        {children}
      </button>
    );
  return (
    <div data-elevation={elevation} className={card({ elevation, tone })}>
      {children}
    </div>
  );
}
