import {
  AlertDialog,
  AlertDialogBackdrop,
  AlertDialogClose,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@ui-sdk/react/alert-dialog';
import {
  Dialog as SdkDialog,
  DialogBackdrop,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogTitle,
  DialogTrigger,
} from '@ui-sdk/react/dialog';
import { useState, type ReactElement, type ReactNode } from 'react';
import { Button } from '../button/button';
import { formTv } from '../field/styles';
import { Icon } from '../icon/icon';
import {
  backdrop,
  closeButton,
  dialogPanel,
  header,
  inlineFrame,
  title as titleClass,
} from '../overlay/styles';

/** The states the stories show (R3). Open is the dialog itself; focus starts on the safe action. */
export const STATES = ['default', 'open', 'danger', 'primary', 'compact', 'pending'] as const;

const actions = formTv({ base: 'flex flex-wrap gap-(--fd-dialog-actions-gap) *:flex-1' });
const description = formTv({
  base: 'm-none text-phone-body text-(color:--fd-dialog-color-body)',
});

export interface DialogProps {
  /** The element that opens it, usually a Button. Focus returns to it on close. */
  trigger?: ReactElement;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  title: string;
  description?: string;
  /** More content between the description and the actions. */
  children?: ReactNode;
  confirmLabel: string;
  cancelLabel: string;
  /** The ×'s name for screen readers: «إغلاق». */
  closeLabel: string;
  /** `danger` for a destructive action; the safe action still takes focus first. */
  tone?: 'primary' | 'danger';
  /** Runs before it closes; a Promise keeps it open, pending, until it settles. */
  onConfirm?: () => unknown;
  density?: 'comfortable' | 'compact';
  /**
   * Draws the open dialog and its scrim in a frame where it is written, beside
   * the page instead of over it (the components canvas shows it open beside its
   * trigger): it neither blocks the page nor traps focus; drawn open (`open`)
   * it takes no focus, opened by its trigger it does.
   */
  inline?: boolean;
  /** Drawn as if its command runs: the confirm button's loader (the components canvas). */
  pending?: boolean;
}

/**
 * The SDK parts: the alert dialog, or, inline, the plain non-modal dialog
 * beside the page (role `dialog`: an alert dialog is modal by definition).
 */
const ALERT = {
  Root: AlertDialog,
  Backdrop: AlertDialogBackdrop,
  Content: AlertDialogContent,
  Title: AlertDialogTitle,
  Close: AlertDialogClose,
  Description: AlertDialogDescription,
  Trigger: AlertDialogTrigger,
};
const BESIDE = {
  Root: SdkDialog,
  Backdrop: DialogBackdrop,
  Content: DialogContent,
  Title: DialogTitle,
  Close: DialogClose,
  Description: DialogDescription,
  Trigger: DialogTrigger,
};

/**
 * A question that blocks the page until it is answered (an alert dialog):
 * a title, a description and two actions over the scrim. Escape, Android's
 * back and the × close it; focus is trapped inside, starts on the safe action
 * and returns to the trigger.
 */
export function Dialog(props: DialogProps) {
  const { trigger, open, onOpenChange, title, children, confirmLabel, cancelLabel } = props;
  const { closeLabel, tone = 'primary', onConfirm, density = 'comfortable' } = props;
  const inline = props.inline ?? false;
  const [running, setRunning] = useState(false);
  const pending = running || (props.pending ?? false);
  // The SDK keeps the dialog open while the Promise runs; the button shows Button's loader.
  const run = async () => {
    setRunning(true);
    try {
      return await onConfirm?.();
    } finally {
      setRunning(false);
    }
  };
  const P = inline ? BESIDE : ALERT;
  const popup = (
    <>
      <P.Backdrop data-scrim="" className={backdrop({ inline })} />
      <P.Content
        inline={inline}
        className={dialogPanel({ inline })}
        initialFocus={inline && open !== undefined ? 'none' : '[data-cancel]'}
      >
        <div className={header()}>
          <P.Title className={titleClass()}>{title}</P.Title>
          <P.Close className={closeButton()} aria-label={closeLabel}>
            <Icon name="close" />
          </P.Close>
        </div>
        {props.description && (
          <P.Description className={description()}>{props.description}</P.Description>
        )}
        {children}
        <div className={actions()}>
          <P.Close
            value="confirm"
            render={
              <Button variant={tone} density={density} loading={pending}>
                {confirmLabel}
              </Button>
            }
            {...(onConfirm && { action: run })}
          />
          <P.Close
            data-cancel=""
            render={
              <Button variant="secondary" density={density}>
                {cancelLabel}
              </Button>
            }
          />
        </div>
      </P.Content>
    </>
  );
  return (
    <P.Root
      {...(open !== undefined && { open })}
      {...(onOpenChange && { onOpenChange: (next: boolean) => onOpenChange(next) })}
      {...(inline && { modal: false, closeOnOutsidePress: false })}
    >
      {trigger && <P.Trigger render={trigger} />}
      {inline ? <div className={inlineFrame()}>{popup}</div> : popup}
    </P.Root>
  );
}
