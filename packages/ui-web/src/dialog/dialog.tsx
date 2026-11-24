import {
  AlertDialog,
  AlertDialogBackdrop,
  AlertDialogClose,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@ui-sdk/react/alert-dialog';
import type { ReactElement, ReactNode } from 'react';
import { buttonClasses } from '../button/button';
import { formTv } from '../field/styles';
import { Icon } from '../icon/icon';
import { backdrop, closeButton, dialogPanel, header, title as titleClass } from '../overlay/styles';

/** The states the stories show (R3). Open is the dialog itself; focus starts on the safe action. */
export const STATES = ['default', 'open', 'danger', 'primary', 'compact'] as const;

const actions = formTv({ base: 'flex flex-wrap gap-sm *:flex-1' });
const description = formTv({ base: 'm-none text-phone-body text-on-surface-muted' });

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
}

/**
 * A question that blocks the page until it is answered (an alert dialog):
 * a title, a description and two actions over the scrim. Escape, Android's
 * back and the × close it; focus is trapped inside, starts on the safe action
 * and returns to the trigger.
 */
export function Dialog(props: DialogProps) {
  const { trigger, open, onOpenChange, title, children, confirmLabel, cancelLabel } = props;
  const { closeLabel, tone = 'primary', onConfirm, density = 'comfortable' } = props;
  return (
    <AlertDialog
      {...(open !== undefined && { open })}
      {...(onOpenChange && { onOpenChange: (next: boolean) => onOpenChange(next) })}
    >
      {trigger && <AlertDialogTrigger render={trigger} />}
      <AlertDialogBackdrop className={backdrop()} />
      <AlertDialogContent className={dialogPanel()} initialFocus="[data-cancel]">
        <div className={header()}>
          <AlertDialogTitle className={titleClass()}>{title}</AlertDialogTitle>
          <AlertDialogClose className={closeButton()} aria-label={closeLabel}>
            <Icon name="close" />
          </AlertDialogClose>
        </div>
        {props.description && (
          <AlertDialogDescription className={description()}>
            {props.description}
          </AlertDialogDescription>
        )}
        {children}
        <div className={actions()}>
          <AlertDialogClose
            value="confirm"
            className={buttonClasses(tone, density)}
            {...(onConfirm && { action: () => onConfirm() })}
          >
            {confirmLabel}
          </AlertDialogClose>
          <AlertDialogClose data-cancel="" className={buttonClasses('secondary', density)}>
            {cancelLabel}
          </AlertDialogClose>
        </div>
      </AlertDialogContent>
    </AlertDialog>
  );
}
