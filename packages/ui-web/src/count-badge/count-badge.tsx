import type { ReactNode } from 'react';
import { formTv } from '../field/styles';

/** The states the stories show (R3). */
export const STATES = ['default', 'dot', 'capped', 'primary', 'inline'] as const;

/** The count as the badge shows it: at most `max`, then «max+». */
export function badgeText(count: number, max = 99): string {
  return count > max ? `${max}+` : String(count);
}

// Red by default, orange for the cart (the R4 exception), blue in a tab. A
// ring of the raised surface separates it from the icon it sits on; it is a
// border inside the badge's size, as the D.9 sheet measures it (D.W3b).
const badge = formTv({
  base: 'inline-flex items-center justify-center rounded-full border-(length:--fd-count-badge-ring-width) border-(--fd-count-badge-ring) font-bold tabular-nums text-phone-caption',
  variants: {
    tone: {
      danger: 'bg-(--fd-count-badge-danger-background) text-(color:--fd-count-badge-danger-label)',
      primary:
        'bg-(--fd-count-badge-primary-background) text-(color:--fd-count-badge-primary-label)',
      accent: 'bg-(--fd-count-badge-accent-background) text-(color:--fd-count-badge-accent-label)',
    },
    dot: {
      true: 'size-(--fd-count-badge-dot-size)',
      false:
        'min-h-(--fd-count-badge-size) min-w-(--fd-count-badge-size) px-(--fd-count-badge-padding-inline)',
    },
    corner: { true: 'absolute', false: '' },
  },
  // A number is centred on the icon's corner so the icon still reads; the dot
  // stays tucked on the corner.
  compoundVariants: [
    {
      corner: true,
      dot: false,
      class: '-top-(--fd-count-badge-offset) -end-(--fd-count-badge-offset)',
    },
    {
      corner: true,
      dot: true,
      class: '-top-(--fd-count-badge-dot-offset) -end-(--fd-count-badge-dot-offset)',
    },
  ],
  defaultVariants: { tone: 'danger' },
});

export interface CountBadgeProps {
  /** How many; without it the badge is a dot («something new»). Zero shows nothing. */
  count?: number | undefined;
  /** Default 99: 120 shows «99+». */
  max?: number;
  /** The full count in words for screen readers: «3 إشعارات». */
  label: string;
  tone?: 'danger' | 'primary' | 'accent';
  /** What the badge sits on the corner of (an icon); without it the badge is inline (a tab). */
  children?: ReactNode;
}

/** A count or a dot on an icon or in a tab. */
export function CountBadge({ count, max, label, tone, children }: CountBadgeProps) {
  // Zero shows no badge, but what it sits on stays.
  if (count === 0) return children ?? null;
  const dot = count === undefined;
  const corner = children !== undefined;
  const mark = (
    <>
      <span
        dir="ltr"
        aria-hidden="true"
        {...(dot ? { 'data-dot': '' } : {})}
        className={badge({ tone, dot, corner })}
      >
        {dot ? null : badgeText(count, max)}
      </span>
      <span className="sr-only">{label}</span>
    </>
  );
  if (!corner) return <span className="inline-flex">{mark}</span>;
  return (
    <span className="relative inline-flex">
      {children}
      {mark}
    </span>
  );
}
