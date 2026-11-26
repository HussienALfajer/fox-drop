import {
  Dialog,
  DialogBackdrop,
  DialogClose,
  DialogContent,
  DialogTitle,
  DialogTrigger,
} from '@ui-sdk/react/dialog';
import type { ReactElement, ReactNode } from 'react';
import { formTv } from '../field/styles';
import { Icon } from '../icon/icon';
import { backdrop, closeButton, inlineFrame, title as titleClass } from '../overlay/styles';

/** The states the stories show (R3): the quick view at the end side, the start side, open. */
export const STATES = ['default', 'start', 'open'] as const;

// On the SDK's Dialog, not its Drawer: the Drawer is a touch sheet with drag
// physics that writes the physical side; this is a pointer panel whose side is
// logical. The approved sheet: full height, the drawer width (440) or the whole screen
// on a phone, raised surface and high elevation; a header with the title,
// an optional action and the ×. It slides from its edge in duration.slow;
// under reduced motion it only fades.
const panel = formTv({
  base: [
    'flex w-full max-w-(--fd-drawer-width) flex-col bg-(--fd-drawer-color-background) text-on-surface shadow-high outline-hidden',
    'transition duration-(--fd-duration-slow) ease-(--fd-easing-standard) data-starting-style:opacity-0 data-ending-style:opacity-0 motion-reduce:transition-opacity motion-reduce:data-starting-style:translate-x-none motion-reduce:data-ending-style:translate-x-none',
  ],
  variants: {
    // Over the page, full height; inside a frame (`inline`), in its flow above the frame's scrim.
    inline: { false: 'fixed inset-y-none z-(--fd-layer-overlay)', true: 'relative' },
    side: {
      start:
        'start-none data-starting-style:-translate-x-full data-ending-style:-translate-x-full rtl:data-starting-style:translate-x-full rtl:data-ending-style:translate-x-full',
      end: 'end-none data-starting-style:translate-x-full data-ending-style:translate-x-full rtl:data-starting-style:-translate-x-full rtl:data-ending-style:-translate-x-full',
    },
  },
});

const head = formTv({
  base: [
    'flex min-h-(--fd-drawer-header-height) shrink-0 items-center gap-(--fd-drawer-header-gap) px-(--fd-drawer-header-padding-inline)',
    'border-b-(length:--fd-drawer-border-width) border-(color:--fd-drawer-color-border)',
  ],
});

export interface DrawerProps {
  trigger?: ReactElement;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  title: string;
  closeLabel: string;
  /** `end` (left in RTL) for a quick view from a table; `start` for the sidebar on a phone. */
  side?: 'start' | 'end';
  /** Beside the title, before the ×: «فتح الصفحة». */
  headerAction?: ReactNode;
  children: ReactNode;
  /**
   * Draws the open drawer and its scrim in a frame where it is written, at its
   * side of the frame, beside the page (the components canvas): it neither
   * blocks the page nor traps focus; drawn open (`open`) it takes no focus,
   * opened by its trigger it does.
   */
  inline?: boolean;
}

/**
 * A full-height panel over the page (AP §7.4: quick views from tables; AP §7.5:
 * the sidebar on a phone). Escape, the × and the scrim close it; focus is
 * trapped inside and returns to the trigger.
 */
export function Drawer(props: DrawerProps) {
  const {
    trigger,
    open,
    onOpenChange,
    title,
    closeLabel,
    side = 'end',
    headerAction,
    children,
  } = props;
  const inline = props.inline ?? false;
  const popup = (
    <>
      <DialogBackdrop data-scrim="" className={backdrop({ inline })} />
      <DialogContent
        inline={inline}
        className={panel({ side, inline })}
        data-side={side}
        {...(inline && props.open !== undefined && { initialFocus: 'none' as const })}
      >
        <div className={head()}>
          <DialogTitle className={titleClass()}>{title}</DialogTitle>
          {headerAction}
          <DialogClose className={closeButton()} aria-label={closeLabel}>
            <Icon name="close" />
          </DialogClose>
        </div>
        <div className="flex min-h-none flex-1 flex-col overflow-y-auto">{children}</div>
      </DialogContent>
    </>
  );
  return (
    <Dialog
      {...(open !== undefined && { open })}
      {...(onOpenChange && { onOpenChange: (next: boolean) => onOpenChange(next) })}
      {...(inline && { modal: false, closeOnOutsidePress: false })}
    >
      {trigger && <DialogTrigger render={trigger} />}
      {inline ? (
        <div
          className={inlineFrame({
            class: ['w-full p-none', side === 'end' ? 'justify-end' : 'justify-start'],
          })}
        >
          {popup}
        </div>
      ) : (
        popup
      )}
    </Dialog>
  );
}
