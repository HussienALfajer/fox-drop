import { useId } from 'react';
import { tv } from 'tailwind-variants';
import { DROP, PIECES, VIEW_BOX } from './mark';

/** The states the stories show (R3). */
export const STATES = ['default', 'onPrimary', 'small', 'large', 'labelled'] as const;

// The mark sits centred in a square box, in the brand file's coordinates.
const SIDE = VIEW_BOX.height;
const LEFT = VIEW_BOX.x - (SIDE - VIEW_BOX.width) / 2;
const TOP = VIEW_BOX.y;
const BOTTOM = TOP + SIDE;

// The liquid's surface at rest is half full (`motion.mark-fill.still-level`):
// with no animation (reduced motion) it stays there. The keyframes in
// theme.css move it from below the drop (`mark-rise` +SHIFT) to above it
// (−SHIFT) and slide the wave by one WAVELENGTH.
const STILL_LEVEL = 0.5;
const REST = TOP + SIDE * (1 - STILL_LEVEL);
const WAVELENGTH = 830;
const AMPLITUDE = 40;

function wave(flat: boolean): string {
  const start = LEFT - 2 * WAVELENGTH;
  const crests = Math.ceil((SIDE + 4 * WAVELENGTH) / WAVELENGTH);
  const surface = flat
    ? `H${start + crests * WAVELENGTH}`
    : `q${WAVELENGTH / 4},${-AMPLITUDE} ${WAVELENGTH / 2},0` +
      ` t${WAVELENGTH / 2},0`.repeat(crests * 2 - 1);
  return `M${start},${REST} ${surface} V${BOTTOM + SIDE} H${start} Z`;
}

const WAVE = wave(false);
const FLAT = wave(true);

const box = tv({
  base: 'inline-flex shrink-0',
  variants: {
    size: {
      sm: 'size-(--fd-drop-loader-size-sm)',
      md: 'size-(--fd-drop-loader-size-md)',
      lg: 'size-(--fd-drop-loader-size-lg)',
    },
  },
});

const fill = tv({
  slots: {
    drop: 'fill-(--fd-drop-loader-color-drop)',
    piece: 'fill-(--fd-drop-loader-color-pieces)',
  },
  variants: {
    onPrimary: {
      true: {
        drop: 'fill-(--fd-drop-loader-color-on-primary-drop)',
        piece: 'fill-(--fd-drop-loader-color-on-primary-pieces)',
      },
    },
    // The drop alone takes the mark's colour.
    small: { true: { drop: 'fill-(--fd-drop-loader-color-pieces)' } },
  },
  compoundVariants: [
    {
      onPrimary: true,
      small: true,
      class: { drop: 'fill-(--fd-drop-loader-color-on-primary-pieces)' },
    },
  ],
});

export interface DropLoaderProps {
  /** `sm` 16 (inside a field), `md` 24 (a button), `lg` 48 (a page part). */
  size?: 'sm' | 'md' | 'lg';
  /** On the orange ground: an ivory drop with an orange fox. */
  onPrimary?: boolean;
  /**
   * Read in a polite live region: «جارٍ التحميل», passed by the caller.
   * Without it the loader is decoration inside a control that is itself busy.
   */
  label?: string;
}

/**
 * The project's one loader (brand expression §2): the mark, faint, fills with
 * a liquid whose surface sways, then fades back; one cycle of
 * `motion.mark-fill.duration` without a pause. Under reduced motion it stands
 * still, half full.
 */
export function DropLoader({ size = 'md', onPrimary = false, label }: DropLoaderProps) {
  const clip = `drop-${useId().replace(/[^a-zA-Z0-9_-]/g, '')}`;
  const small = size === 'sm';
  const colours = fill({ onPrimary, small });
  const viewBox = [LEFT, TOP, SIDE, SIDE].join(' ');
  const clipUrl = ['url(#', clip, ')'].join('');
  const mark = (
    <>
      <path d={DROP} className={colours.drop()} />
      {!small &&
        PIECES.map((piece) => (
          <path key={piece} d={piece} data-part="piece" className={colours.piece()} />
        ))}
    </>
  );
  const svg = (
    <svg viewBox={viewBox} aria-hidden="true" focusable="false" className="size-full">
      <defs>
        {/* A mask, not a clipPath: a clipPath takes no group, and the
            surface needs two moves (the rise and the sway). */}
        {/* `mask-type="alpha"`: the surface's own (black) fill counts by its
            opacity, so the mask needs no colour outside the tokens. */}
        <mask id={clip} maskUnits="userSpaceOnUse" mask-type="alpha">
          <g
            data-part="level"
            data-still-level={STILL_LEVEL}
            className="motion-safe:animate-mark-rise"
          >
            {small ? (
              <path d={FLAT} data-part="flat" />
            ) : (
              <path d={WAVE} data-part="wave" className="motion-safe:animate-mark-wave" />
            )}
          </g>
        </mask>
      </defs>
      <g data-part="faint" className="opacity-(--fd-motion-mark-fill-faint-opacity)">
        {mark}
      </g>
      <g mask={clipUrl}>
        <g className="motion-safe:animate-mark-fade">{mark}</g>
      </g>
    </svg>
  );
  const own = { 'data-drop-loader': '', ...(onPrimary && { 'data-on-primary': '' }) };
  if (label === undefined)
    return (
      <span {...own} aria-hidden="true" className={box({ size })}>
        {svg}
      </span>
    );
  return (
    <span {...own} role="status" aria-live="polite" aria-label={label} className={box({ size })}>
      {svg}
      <span className="sr-only">{label}</span>
    </span>
  );
}
