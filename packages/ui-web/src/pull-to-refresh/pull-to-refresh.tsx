import { useEffect, useId, useRef, useState, type PointerEvent, type ReactNode } from 'react';
import { buttonClasses } from '../button/button';
import { DropLoader } from '../drop-loader/drop-loader';
import { DROP, PIECES, VIEW_BOX } from '../drop-loader/mark';
import { formTv, keyboardRing } from '../field/styles';

/** The states the stories show (R3): at rest, pulling (the mark half full), refreshing. */
export const STATES = ['default', 'pulling', 'refreshing'] as const;

/** How far a pull goes before it refreshes: space.3xl + space.md, as the Flutter twin. */
const THRESHOLD = 80;

// The mark in a square box, in the brand file's coordinates (as DropLoader).
const SIDE = VIEW_BOX.height;
const LEFT = VIEW_BOX.x - (SIDE - VIEW_BOX.width) / 2;
const TOP = VIEW_BOX.y;
const VIEW = [LEFT, TOP, SIDE, SIDE].join(' ');

const drop = formTv({
  base: 'inline-flex size-(--fd-pull-to-refresh-drop-size) items-center justify-center rounded-full bg-(--fd-pull-to-refresh-color-drop) shadow-medium',
});

const scroller = formTv({
  base: `size-full overflow-y-auto overscroll-y-contain ${keyboardRing}`,
  variants: {
    // At the top a finger moving down is the pull, not the browser's scroll.
    atTop: { true: 'touch-pan-x touch-pan-down', false: 'touch-pan-x touch-pan-y' },
  },
});

/** The refresh button's wrapper: out of sight until the keyboard reaches it. */
const keyboardOnly =
  'sr-only focus-within:not-sr-only focus-within:absolute focus-within:start-(--fd-pull-to-refresh-inset) focus-within:top-(--fd-pull-to-refresh-inset) focus-within:z-(--fd-layer-sticky)';

/** The mark filled from the bottom to `level` (0 to 1), still: Flutter's `FoxDropLoader(level:)`. */
function FillingMark({ level }: { level: number }) {
  const clip = `pull-${useId().replace(/[^a-zA-Z0-9_-]/g, '')}`;
  const clipUrl = ['url(#', clip, ')'].join('');
  const mark = (
    <>
      <path d={DROP} className="fill-(--fd-drop-loader-color-drop)" />
      {PIECES.map((piece) => (
        <path key={piece} d={piece} className="fill-(--fd-drop-loader-color-pieces)" />
      ))}
    </>
  );
  return (
    <svg
      viewBox={VIEW}
      aria-hidden="true"
      focusable="false"
      className="size-(--fd-pull-to-refresh-mark-size)"
    >
      <defs>
        <clipPath id={clip}>
          <rect x={LEFT} y={TOP + SIDE * (1 - level)} width={SIDE} height={SIDE * level} />
        </clipPath>
      </defs>
      <g className="opacity-(--fd-motion-mark-fill-faint-opacity)">{mark}</g>
      <g clipPath={clipUrl}>{mark}</g>
    </svg>
  );
}

export interface PullToRefreshProps {
  /** The list. The component is its scroll container and fills its parent. */
  children: ReactNode;
  /** Runs once per pull; a Promise keeps the loader until it settles. A rejection only stops the loader: show the error yourself. */
  onRefresh: () => unknown;
  /** The refresh button for screen readers and keyboards: «تحديث». */
  refreshLabel: string;
}

/**
 * Pull to refresh (D.10; D.11b: the mark). On a touch screen, pulling the list
 * down from its top fills the mark; past the threshold, letting go runs
 * `onRefresh` once and the mark becomes the drop loader until it settles
 * (still under reduced motion). A mouse drag does nothing; a button, shown on
 * keyboard focus, refreshes without a gesture.
 */
export function PullToRefresh({ children, onRefresh, refreshLabel }: PullToRefreshProps) {
  const [pulled, setPulled] = useState(0);
  const [refreshing, setRefreshing] = useState(false);
  const [atTop, setAtTop] = useState(true);
  const start = useRef<{ id: number; y: number } | null>(null);
  const busy = useRef(false);
  const list = useRef<HTMLDivElement>(null);

  // WebKit has no `pan-down`, so its `touch-action` falls back to auto and the
  // page would take the pull as its own scroll (and cancel the pointer). A
  // downward move during a pull is held back here instead; it must be a
  // listener that is not passive, which React's `onTouchMove` is not.
  useEffect(() => {
    const element = list.current;
    if (!element) return;
    const hold = (event: TouchEvent) => {
      const from = start.current;
      const touch = event.touches[0];
      if (from && touch && touch.clientY > from.y && event.cancelable) event.preventDefault();
    };
    element.addEventListener('touchmove', hold, { passive: false });
    return () => element.removeEventListener('touchmove', hold);
  }, []);

  const refresh = async () => {
    if (busy.current) return;
    busy.current = true;
    setRefreshing(true);
    try {
      await onRefresh();
    } catch {
      // The caller shows its own error (a toast, a banner); the loader stops.
    } finally {
      busy.current = false;
      setRefreshing(false);
    }
  };

  const down = (event: PointerEvent<HTMLDivElement>) => {
    if (event.pointerType !== 'touch' || !event.isPrimary) return;
    if (event.currentTarget.scrollTop > 0 || busy.current) return;
    start.current = { id: event.pointerId, y: event.clientY };
  };
  const move = (event: PointerEvent<HTMLDivElement>) => {
    const from = start.current;
    if (!from || from.id !== event.pointerId) return;
    setPulled(Math.max(0, event.clientY - from.y));
  };
  const up = (event: PointerEvent<HTMLDivElement>) => {
    const from = start.current;
    if (!from || from.id !== event.pointerId) return;
    start.current = null;
    setPulled(0);
    if (event.clientY - from.y >= THRESHOLD) void refresh();
  };
  const cancel = () => {
    start.current = null;
    setPulled(0);
  };

  const level = Math.min(1, pulled / THRESHOLD);
  const showing = refreshing || pulled > 0;
  return (
    <div className="relative size-full">
      {/* Hidden by its wrapper: the button's own position and height would beat sr-only. */}
      <span className={keyboardOnly}>
        <button
          type="button"
          onClick={() => void refresh()}
          className={buttonClasses('secondary', 'compact')}
        >
          {refreshLabel}
        </button>
      </span>
      <div
        ref={list}
        // A list that scrolls is reachable by the keyboard (axe: scrollable-region-focusable).
        tabIndex={0}
        data-pull-scroller=""
        onScroll={(event) => setAtTop(event.currentTarget.scrollTop <= 0)}
        onPointerDown={down}
        onPointerMove={move}
        onPointerUp={up}
        onPointerCancel={cancel}
        className={scroller({ atTop })}
      >
        {children}
      </div>
      {showing && (
        <div className="pointer-events-none absolute inset-x-none top-(--fd-pull-to-refresh-inset) flex justify-center">
          <span data-pull-drop="" className={drop()}>
            {refreshing ? (
              <span className="inline-flex size-(--fd-pull-to-refresh-mark-size) *:size-(--fd-pull-to-refresh-mark-size)">
                <DropLoader size="lg" />
              </span>
            ) : (
              <FillingMark level={level} />
            )}
          </span>
        </div>
      )}
    </div>
  );
}
