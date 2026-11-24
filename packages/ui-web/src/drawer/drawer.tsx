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
import { backdrop, closeButton, title as titleClass } from '../overlay/styles';

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
    'fixed inset-y-none z-(--fd-layer-overlay) flex w-full max-w-(--fd-size-drawer) flex-col bg-surface-raised text-on-surface shadow-high outline-hidden',
    'transition duration-(--fd-duration-slow) ease-(--fd-easing-standard) data-starting-style:opacity-0 data-ending-style:opacity-0 motion-reduce:transition-opacity motion-reduce:data-starting-style:translate-x-none motion-reduce:data-ending-style:translate-x-none',
  ],
  variants: {
    side: {
      start:
        'start-none data-starting-style:-translate-x-full data-ending-style:-translate-x-full rtl:data-starting-style:translate-x-full rtl:data-ending-style:translate-x-full',
      end: 'end-none data-starting-style:translate-x-full data-ending-style:translate-x-full rtl:data-starting-style:-translate-x-full rtl:data-ending-style:-translate-x-full',
    },
  },
});

const head = formTv({
  base: 'flex min-h-(--fd-size-bar) shrink-0 items-center gap-sm border-b border-border px-md',
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
  return (
    <Dialog
      {...(open !== undefined && { open })}
      {...(onOpenChange && { onOpenChange: (next: boolean) => onOpenChange(next) })}
    >
      {trigger && <DialogTrigger render={trigger} />}
      <DialogBackdrop className={backdrop()} />
      <DialogContent className={panel({ side })} data-side={side}>
        <div className={head()}>
          <DialogTitle className={titleClass()}>{title}</DialogTitle>
          {headerAction}
          <DialogClose className={closeButton()} aria-label={closeLabel}>
            <Icon name="close" />
          </DialogClose>
        </div>
        <div className="flex min-h-none flex-1 flex-col overflow-y-auto">{children}</div>
      </DialogContent>
    </Dialog>
  );
}
