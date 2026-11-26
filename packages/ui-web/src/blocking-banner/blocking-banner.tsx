import {
  AlertDialog,
  AlertDialogBackdrop,
  AlertDialogContent,
  AlertDialogTitle,
} from '@ui-sdk/react/alert-dialog';
import { formTv, keyboardRing } from '../field/styles';
import { Icon } from '../icon/icon';

/** The states the stories show (R3). */
export const STATES = ['default'] as const;

// The approved sheet: a scrim over the page and a bar on `color.alert` at the
// top, above everything (`layer.blocking`); white on alert reads at 9.3:1.
const bar = formTv({
  base: [
    'fixed inset-x-none top-none z-(--fd-layer-blocking) flex items-center gap-(--fd-blocking-banner-gap) outline-hidden',
    'bg-(--fd-blocking-banner-color-background) px-(--fd-blocking-banner-padding-inline) py-(--fd-blocking-banner-padding-block) text-(color:--fd-blocking-banner-color-text)',
    'transition-opacity duration-(--fd-duration-base) ease-(--fd-easing-standard) data-starting-style:opacity-0 data-ending-style:opacity-0',
  ],
});

const scrim = formTv({
  base: 'fixed inset-none z-(--fd-layer-blocking) bg-scrim',
});

const action = formTv({
  base: `inline-flex min-h-(--fd-blocking-banner-action-height) shrink-0 cursor-pointer items-center rounded-full bg-(--fd-blocking-banner-color-text) px-(--fd-blocking-banner-action-padding-inline) text-panel-body font-bold text-(color:--fd-blocking-banner-color-background) ${keyboardRing}`,
});

export interface BlockingBannerProps {
  /** Shown until the sound plays; the app closes it then. */
  open: boolean;
  /** «اضغط لتفعيل صوت التنبيهات» (AP §7.3). */
  text: string;
  /** The button's words: «تفعيل الصوت». */
  actionLabel: string;
  /** Runs inside the press, so the browser lets audio start. */
  onEnable: () => void;
}

/**
 * The panel's blocking sound banner (AP §7.3): browsers block audio until the
 * user interacts, so after sign-in it covers the page until sound is enabled.
 * Escape and outside presses cannot dismiss it; focus starts on its button.
 */
export function BlockingBanner({ open, text, actionLabel, onEnable }: BlockingBannerProps) {
  return (
    <AlertDialog open={open} dismissible={false}>
      <AlertDialogBackdrop className={scrim()} />
      <AlertDialogContent className={bar()} initialFocus="[data-enable]">
        <Icon name="bell" />
        <AlertDialogTitle className="m-none min-w-none flex-1 text-panel-body font-bold">
          {text}
        </AlertDialogTitle>
        <button type="button" data-enable="" className={action()} onClick={onEnable}>
          {actionLabel}
        </button>
      </AlertDialogContent>
    </AlertDialog>
  );
}
