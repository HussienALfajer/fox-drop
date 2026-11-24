import {
  AlertDialog,
  AlertDialogBackdrop,
  AlertDialogClose,
  AlertDialogContent,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@ui-sdk/react/alert-dialog';
import { useId, useState, type ReactElement, type ReactNode } from 'react';
import { buttonClasses } from '../button/button';
import { formTv } from '../field/styles';
import { Icon } from '../icon/icon';
import { backdrop, closeButton, dialogPanel, header, title as titleClass } from '../overlay/styles';
import { TextField } from '../text-field/text-field';

/** The states the stories show (R3): empty, refused without a reason, filled. */
export const STATES = ['default', 'empty', 'invalid', 'filled'] as const;

const section = formTv({ base: 'flex flex-col gap-xs' });
const sectionTitle = formTv({ base: 'm-none text-panel-secondary font-bold' });
const effect = formTv({ base: 'flex flex-col gap-xs rounded-md bg-surface p-sm' });
const chip = formTv({
  base: 'inline-flex min-h-lg items-center gap-2xs rounded-full bg-info-subtle px-xs text-panel-secondary font-medium text-info',
});
const actions = formTv({ base: 'flex flex-wrap gap-sm' });

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
}

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
  const ready = reason.trim() !== '' && !pending;
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
  return (
    <AlertDialog
      open={open}
      // While the command runs nothing closes it, so it cannot settle twice.
      dismissible={!pending}
      onOpenChange={(next: boolean, details) => {
        if (pending && !next) details.cancel();
        else setOpen(next);
      }}
    >
      {trigger && <AlertDialogTrigger render={trigger} />}
      <AlertDialogBackdrop className={backdrop()} />
      <AlertDialogContent className={dialogPanel()} initialFocus="[data-reason] input">
        <div className={header()}>
          <AlertDialogTitle className={titleClass()}>{title}</AlertDialogTitle>
          <AlertDialogClose className={closeButton()} aria-label={closeLabel}>
            <Icon name="close" />
          </AlertDialogClose>
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
          <ul aria-labelledby={notifyId} className="m-none flex list-none flex-wrap gap-xs p-none">
            {notified.map((who) => (
              <li key={who} className={chip()}>
                <Icon name="bell" size="sm" />
                {who}
              </li>
            ))}
          </ul>
        </div>
        <div className={actions()}>
          <button
            type="button"
            aria-disabled={!ready}
            {...(pending && { 'aria-busy': true })}
            className={buttonClasses('danger', 'compact', !ready)}
            onClick={() => void confirm()}
          >
            {confirmLabel}
          </button>
          <AlertDialogClose className={buttonClasses('secondary', 'compact')}>
            {cancelLabel}
          </AlertDialogClose>
        </div>
      </AlertDialogContent>
    </AlertDialog>
  );
}
