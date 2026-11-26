import {
  AlertDialog,
  AlertDialogBackdrop,
  AlertDialogClose,
  AlertDialogContent,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@ui-sdk/react/alert-dialog';
import {
  Dialog,
  DialogBackdrop,
  DialogClose,
  DialogContent,
  DialogTitle,
  DialogTrigger,
} from '@ui-sdk/react/dialog';
import { useId, useState, type ReactElement, type ReactNode } from 'react';
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
import { TextField } from '../text-field/text-field';

/** The states the stories show (R3): empty, refused without a reason, filled. */
export const STATES = ['default', 'empty', 'invalid', 'filled', 'pending'] as const;

const section = formTv({ base: 'flex flex-col gap-(--fd-dialog-confirm-section-gap)' });
const sectionTitle = formTv({ base: 'm-none text-panel-secondary font-bold' });
const effect = formTv({
  base: [
    'flex flex-col gap-(--fd-dialog-confirm-section-gap) rounded-(--fd-dialog-confirm-effect-radius)',
    'bg-(--fd-dialog-confirm-color-effect-background) p-(--fd-dialog-confirm-effect-padding)',
  ],
});
const chip = formTv({
  base: [
    'inline-flex min-h-(--fd-dialog-confirm-chip-height) items-center gap-(--fd-dialog-confirm-chip-gap) rounded-full',
    'bg-(--fd-dialog-confirm-color-chip-background) px-(--fd-dialog-confirm-chip-padding-inline)',
    'text-panel-secondary font-medium text-(color:--fd-dialog-confirm-color-chip-text)',
  ],
});
const actions = formTv({ base: 'flex flex-wrap gap-(--fd-dialog-actions-gap)' });
const notifiedList = formTv({
  base: 'm-none flex list-none flex-wrap gap-(--fd-dialog-confirm-section-gap) p-none',
});

export interface ConfirmDialogProps {
  trigger?: ReactElement;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  title: string;
  reasonLabel: string;
  reasonPlaceholder?: string;
  /** Shown next to the field after a try without a reason: «السبب مطلوب». */
  reasonError: string;
  /** The money-effect preview, when ledgers move (an AmountsSummary). */
  effect?: ReactNode;
  effectTitle?: string;
  notifyTitle: string;
  /** Who will be notified, in words. */
  notified: readonly string[];
  confirmLabel: string;
  cancelLabel: string;
  closeLabel: string;
  /** Runs with the reason, trimmed; a Promise keeps the dialog open until it settles. */
  onConfirm: (reason: string) => unknown;
  /**
   * Draws the open dialog and its scrim in a frame where it is written, beside
   * the page (the components canvas): a plain dialog that neither blocks the
   * page nor traps focus; drawn open (`open`) it takes no focus, opened by
   * its trigger it does.
   */
  inline?: boolean;
  /** Drawn as if its command runs: the confirm button's loader (the components canvas). */
  pending?: boolean;
}

/** The SDK parts: the alert dialog, or, inline, the plain non-modal dialog (as Dialog's). */
const ALERT = {
  Root: AlertDialog,
  Backdrop: AlertDialogBackdrop,
  Content: AlertDialogContent,
  Title: AlertDialogTitle,
  Close: AlertDialogClose,
  Trigger: AlertDialogTrigger,
};
const BESIDE = {
  Root: Dialog,
  Backdrop: DialogBackdrop,
  Content: DialogContent,
  Title: DialogTitle,
  Close: DialogClose,
  Trigger: DialogTrigger,
};

/**
 * The confirmation of every destructive or financial action in the panel
 * (AP §7.4): the reason field, the money effect when ledgers move, and who is
 * notified. It will not confirm without a reason; focus starts on the field.
 */
export function ConfirmDialog(props: ConfirmDialogProps) {
  const { trigger, title, reasonLabel, reasonPlaceholder, reasonError, notifyTitle } = props;
  const { notified, confirmLabel, cancelLabel, closeLabel, onConfirm, onOpenChange } = props;
  const [inner, setInner] = useState(false);
  const [reason, setReason] = useState('');
  const [tried, setTried] = useState(false);
  const [pending, setPending] = useState(false);
  const notifyId = useId();
  const open = props.open ?? inner;
  const setOpen = (next: boolean) => {
    setInner(next);
    if (!next) {
      setReason('');
      setTried(false);
    }
    onOpenChange?.(next);
  };
  const busy = pending || (props.pending ?? false);
  const ready = reason.trim() !== '' && !busy;
  const confirm = async () => {
    setTried(true);
    if (!ready) return;
    setPending(true);
    try {
      await onConfirm(reason.trim());
      setPending(false);
      setOpen(false);
    } catch {
      // The command failed: the dialog stays open with the reason kept, and
      // the app says why (a toast or a banner).
      setPending(false);
    }
  };
  const showError = tried && reason.trim() === '';
  const inline = props.inline ?? false;
  const P = inline ? BESIDE : ALERT;
  const popup = (
    <>
      <P.Backdrop data-scrim="" className={backdrop({ inline })} />
      <P.Content
        inline={inline}
        className={dialogPanel({ inline })}
        initialFocus={inline && props.open !== undefined ? 'none' : '[data-reason] input'}
      >
        <div className={header()}>
          <P.Title className={titleClass()}>{title}</P.Title>
          <P.Close className={closeButton()} aria-label={closeLabel}>
            <Icon name="close" />
          </P.Close>
        </div>
        <div data-reason="">
          <TextField
            label={reasonLabel}
            required
            density="compact"
            value={reason}
            onValueChange={setReason}
            {...(reasonPlaceholder && { placeholder: reasonPlaceholder })}
            {...(showError && { error: reasonError })}
          />
        </div>
        {props.effect && (
          <div className={effect()}>
            {props.effectTitle && <p className={sectionTitle()}>{props.effectTitle}</p>}
            {props.effect}
          </div>
        )}
        <div className={section()}>
          <p id={notifyId} className={sectionTitle()}>
            {notifyTitle}
          </p>
          <ul aria-labelledby={notifyId} className={notifiedList()}>
            {notified.map((who) => (
              <li key={who} className={chip()}>
                <Icon name="bell" size="sm" />
                {who}
              </li>
            ))}
          </ul>
        </div>
        <div className={actions()}>
          <Button
            variant="danger"
            density="compact"
            softDisabled={!ready && !busy}
            loading={busy}
            onClick={() => void confirm()}
          >
            {confirmLabel}
          </Button>
          <P.Close
            render={
              <Button variant="secondary" density="compact">
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
      open={open}
      // While the command runs nothing closes it, so it cannot settle twice.
      dismissible={!pending}
      onOpenChange={(next: boolean, details: { cancel: () => void }) => {
        if (pending && !next) details.cancel();
        else setOpen(next);
      }}
      {...(inline && { modal: false, closeOnOutsidePress: false })}
    >
      {trigger && <P.Trigger render={trigger} />}
      {inline ? <div className={inlineFrame()}>{popup}</div> : popup}
    </P.Root>
  );
}
