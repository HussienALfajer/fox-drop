import {
  Dialog,
  DialogBackdrop,
  DialogClose,
  DialogContent,
  DialogTitle,
  DialogTrigger,
} from '@ui-sdk/react/dialog';
import { useLayoutEffect, useRef, useState, type ReactElement, type ReactNode } from 'react';
import { formTv } from '../field/styles';
import { Icon } from '../icon/icon';
import { backdrop, closeButton } from '../overlay/styles';

/** The states the stories show (R3): closed with its trigger, the plain top open, the S-curve top, a long content. */
export const STATES = ['default', 'open', 'sCurve', 'long'] as const;

// On the SDK's Dialog (§9.10: focus trap, Escape, focus back to the trigger),
// as the side drawer. The approved D.10 sheet, as the Flutter twin draws it:
// from the bottom edge over the scrim, centred at the dialog width on a wide
// page; the content scrolls past its height. The dialog is a clear frame from
// below the top bar's height to the bottom edge that lets presses through to
// the scrim; the sheet sits at its bottom. It slides up over duration.slow;
// under reduced motion it only fades.
const frame = formTv({
  base: 'flex flex-col outline-hidden',
  variants: {
    inline: {
      false: [
        'pointer-events-none fixed inset-x-none top-(--fd-size-bar) bottom-none z-(--fd-layer-overlay) justify-end',
        'transition duration-(--fd-duration-slow) ease-(--fd-easing-standard) data-starting-style:translate-y-full data-ending-style:translate-y-full',
        'motion-reduce:transition-opacity motion-reduce:data-starting-style:translate-y-none motion-reduce:data-starting-style:opacity-0 motion-reduce:data-ending-style:translate-y-none motion-reduce:data-ending-style:opacity-0',
      ],
      // In a frame of a set height (a story, a preview) the sheet fits it and its content scrolls.
      true: 'relative max-h-full',
    },
  },
});

const panel = formTv({
  base: 'pointer-events-auto mx-auto flex max-h-full min-h-none w-full max-w-(--fd-bottom-sheet-max-width) flex-col text-on-surface',
  variants: {
    sCurve: {
      false: 'overflow-hidden rounded-t-(--fd-bottom-sheet-radius)',
      true: '',
    },
  },
});

const body = formTv({
  base: 'flex min-h-none flex-1 flex-col overflow-y-auto px-(--fd-bottom-sheet-padding-inline) pb-(--fd-bottom-sheet-padding-bottom) outline-hidden focus-visible:inset-ring-2 focus-visible:inset-ring-(color:--fd-input-color-focus-ring)',
  variants: {
    sCurve: {
      false: 'bg-(--fd-bottom-sheet-color-background)',
      true: 'bg-(--fd-bottom-sheet-color-background-s-curve)',
    },
  },
});

const title = formTv({
  base: 'm-none min-w-none font-bold',
  variants: {
    sCurve: {
      false: 'flex-1 text-phone-title text-(color:--fd-bottom-sheet-color-title)',
      true: 'text-phone-subtitle text-(color:--fd-bottom-sheet-color-title-s-curve)',
    },
  },
});

const handle =
  'block h-(--fd-bottom-sheet-handle-height) w-(--fd-bottom-sheet-handle-width) rounded-full bg-(--fd-bottom-sheet-color-handle)';
const plainHandle = `${handle} mx-auto`;
const curveHandle = `${handle} absolute inset-x-none bottom-xs mx-auto`;

// The S-curve tab (brand expression §2), as Flutter's painter draws it: the
// start 60% stands `curve.height` above the lower edge, joined to it by a curve
// `curve.width` wide (from 16 before the 60% line to 32 after it). Three
// pieces in a row: the tab, the curve (drawn with the tab at the left,
// mirrored in RTL) and the lower edge, whose box gives back 32 at the end so
// the tab takes them.
const sCurveTop = 'relative isolate flex items-end overflow-hidden';
const tabPiece =
  'min-w-none flex-1 self-stretch rounded-ss-(--fd-bottom-sheet-radius) bg-(--fd-bottom-sheet-color-background-s-curve) ps-(--fd-bottom-sheet-padding-inline) pt-xs pb-(--fd-bottom-sheet-curve-height)';
const curvePiece =
  'h-(--fd-bottom-sheet-curve-height) w-(--fd-bottom-sheet-curve-width) shrink-0 fill-(--fd-bottom-sheet-color-background-s-curve) rtl:-scale-x-100';
const lowPiece = 'shrink-0 basis-2/5 -me-xl pe-xl';
const lowEdge =
  'block h-(--fd-bottom-sheet-curve-height) rounded-se-(--fd-bottom-sheet-radius) bg-(--fd-bottom-sheet-color-background-s-curve)';
const CURVE = 'M0,0 C26.667,0 26.667,24 48,24 L0,24 Z';

const plainTop =
  'flex flex-col bg-(--fd-bottom-sheet-color-background) ps-(--fd-bottom-sheet-padding-inline) pe-sm pt-(--fd-bottom-sheet-padding-top)';

/**
 * The sheet's content. Only while it overflows is it a keyboard stop (axe:
 * scrollable-region-focusable): otherwise it would take the sheet's first
 * focus from the controls inside it.
 */
function ScrollBody({ className, children }: { className: string; children: ReactNode }) {
  const ref = useRef<HTMLDivElement>(null);
  const [scrolls, setScrolls] = useState(false);
  useLayoutEffect(() => {
    const element = ref.current;
    if (!element) return;
    const measure = () => setScrolls(element.scrollHeight > element.clientHeight);
    measure();
    if (typeof ResizeObserver === 'undefined') return;
    const observer = new ResizeObserver(measure);
    observer.observe(element);
    return () => observer.disconnect();
  }, []);
  return (
    <div ref={ref} {...(scrolls && { tabIndex: 0 })} className={className}>
      {children}
    </div>
  );
}

export interface BottomSheetProps {
  /** The element that opens it, usually a Button. Focus returns to it on close. */
  trigger?: ReactElement;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  /** Shown, and the sheet's accessible name. */
  title: string;
  /** The plain top's ×. */
  closeLabel: string;
  children: ReactNode;
  /** The brand's S-curve tab holding the title: the customer's item sheet. No ×. */
  sCurve?: boolean;
  /** False keeps it open on Escape and the scrim. */
  dismissible?: boolean;
  /**
   * Keeps the sheet in its frame instead of over the page: a preview, the
   * Design System card. It still keeps Tab inside while open (the SDK's
   * `trap-focus`); Escape or the × lets the keyboard out.
   */
  inline?: boolean;
}

/**
 * A sheet from the bottom edge (D.10): a handle, its title and its content.
 * Escape and the scrim close it (unless not `dismissible`), and the plain
 * top's ×; focus is trapped inside and returns to the trigger.
 */
export function BottomSheet(props: BottomSheetProps) {
  const { trigger, open, onOpenChange, title: name, closeLabel, children } = props;
  const { sCurve = false, dismissible = true, inline = false } = props;
  const top = sCurve ? (
    <div data-s-curve="" className={sCurveTop}>
      <div className={tabPiece}>
        <DialogTitle className={title({ sCurve })}>{name}</DialogTitle>
      </div>
      <svg
        aria-hidden="true"
        focusable="false"
        viewBox="0 0 48 24"
        preserveAspectRatio="none"
        className={curvePiece}
      >
        <path d={CURVE} />
      </svg>
      <span aria-hidden="true" className={lowPiece}>
        <span className={lowEdge} />
      </span>
      <span data-handle="" aria-hidden="true" className={curveHandle} />
    </div>
  ) : (
    <div className={plainTop}>
      <span data-handle="" aria-hidden="true" className={plainHandle} />
      <div className="flex items-center gap-sm">
        <DialogTitle className={title({ sCurve })}>{name}</DialogTitle>
        {/* In the row, as Flutter's 48 icon button: not pulled out by -m-xs. */}
        <DialogClose className={closeButton({ class: 'm-none' })} aria-label={closeLabel}>
          <Icon name="close" />
        </DialogClose>
      </div>
    </div>
  );
  return (
    <Dialog
      {...(open !== undefined && { open })}
      {...(onOpenChange && { onOpenChange: (next: boolean) => onOpenChange(next) })}
      dismissible={dismissible}
      {...(inline && { modal: 'trap-focus' as const, closeOnOutsidePress: false })}
    >
      {trigger && <DialogTrigger render={trigger} />}
      {!inline && <DialogBackdrop className={backdrop()} />}
      <DialogContent inline={inline} className={frame({ inline })}>
        <div className={panel({ sCurve })}>
          {top}
          <ScrollBody className={body({ sCurve })}>{children}</ScrollBody>
        </div>
      </DialogContent>
    </Dialog>
  );
}
