import { formTv } from '../field/styles';

/** The states the stories show (R3), as the Flutter twin's. */
export const STATES = ['default', 'last'] as const;

/** The last seconds turn the ring red (brand expression §3). */
const LAST_SECONDS = 10;

const box = formTv({
  base: 'relative inline-flex size-(--fd-countdown-ring-size) shrink-0 items-center justify-center text-phone-number tabular-nums',
  variants: {
    last: {
      true: 'text-(color:--fd-countdown-ring-color-last)',
      false: 'text-(color:--fd-countdown-ring-color-progress)',
    },
  },
});

// The sweep between two ticks eases only when motion is allowed; under
// reduced motion the arc jumps and the number carries the time.
const arc = formTv({
  base: 'countdown-arc fill-none stroke-(length:--fd-countdown-ring-stroke-width) motion-safe:transition-all motion-safe:duration-(--fd-duration-base) motion-safe:ease-(--fd-easing-standard)',
  variants: {
    last: {
      true: 'stroke-(--fd-countdown-ring-color-last)',
      false: 'stroke-(--fd-countdown-ring-color-progress)',
    },
  },
});

export interface CountdownRingProps {
  /** Seconds left; the app ticks it. */
  seconds: number;
  /** The offer's whole time, 45 seconds. */
  total: number;
  /** The words after the number for screen readers: «ثانية متبقية». */
  label: string;
}

/**
 * The captain's offer countdown (brand expression §3): a ring that empties
 * over `total` seconds from the top along the reading direction, the seconds
 * left inside, red in the last ten. A `timer` role is not announced on every
 * tick.
 */
export function CountdownRing({ seconds, total, label }: CountdownRingProps) {
  const left = Math.max(0, Math.floor(seconds));
  const last = left <= LAST_SECONDS;
  const share = total <= 0 ? 0 : Math.min(1, left / total);
  // The circle's length is 100, so the dash is the share in hundredths.
  const dash = `${Math.round(share * 10000) / 100} 100`;
  const name = `${left} ${label}`;
  return (
    <span
      role="timer"
      aria-label={name}
      data-last={last ? '' : undefined}
      className={box({ last })}
    >
      {/* From the top (−90°), clockwise; in RTL flipped before the turn, so
          it runs anticlockwise, as the Flutter twin. */}
      <svg
        aria-hidden="true"
        focusable="false"
        className="absolute inset-none size-full -rotate-90 rtl:-scale-y-100"
      >
        <circle
          cx="50%"
          cy="50%"
          className="countdown-arc fill-none stroke-(--fd-countdown-ring-color-track) stroke-(length:--fd-countdown-ring-stroke-width)"
        />
        <circle
          data-part="arc"
          cx="50%"
          cy="50%"
          pathLength={100}
          strokeDasharray={dash}
          strokeLinecap="round"
          className={arc({ last })}
        />
      </svg>
      <span aria-hidden="true" dir="ltr" className="relative">
        {left}
      </span>
    </span>
  );
}
