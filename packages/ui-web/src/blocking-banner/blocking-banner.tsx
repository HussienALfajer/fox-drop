import {
  AlertDialog,
  AlertDialogBackdrop,
  AlertDialogContent,
  AlertDialogTitle,
} from '@ui-sdk/react/alert-dialog';
import { Dialog, DialogBackdrop, DialogContent, DialogTitle } from '@ui-sdk/react/dialog';
import { formTv, keyboardRing } from '../field/styles';
import { Icon } from '../icon/icon';

/** The states the stories show (R3). */
export const STATES = ['default'] as const;

// The approved sheet: a scrim over the page and a bar on `color.alert` at the
// top, above everything (`layer.blocking`); white on alert reads at 9.3:1.
const bar = formTv({
  base: [
    'flex items-center gap-(--fd-blocking-banner-gap) outline-hidden',
    'bg-(--fd-blocking-banner-color-background) px-(--fd-blocking-banner-padding-inline) py-(--fd-blocking-banner-padding-block) text-(color:--fd-blocking-banner-color-text)',
    'transition-opacity duration-(--fd-duration-base) ease-(--fd-easing-standard) data-starting-style:opacity-0 data-ending-style:opacity-0',
  ],
  variants: {
    // At the top of the page; inside a frame (`inline`), at the top of the frame above its scrim.
    inline: {
      false: 'fixed inset-x-none top-none z-(--fd-layer-blocking)',
      true: 'relative w-full',
    },
  },
  defaultVariants: { inline: false },
});

const scrim = formTv({
  base: 'inset-none bg-scrim',
  variants: { inline: { false: 'fixed z-(--fd-layer-blocking)', true: 'absolute' } },
  defaultVariants: { inline: false },
});

/** The frame an inline banner sits in: its scrim fills it, the bar at its top over the page's room. */
const frame = formTv({ base: 'relative isolate flex items-start pb-3xl' });

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
  /**
   * Draws it in a frame where it is written, beside the page (the components
   * canvas): a plain dialog that neither blocks the page, traps focus nor takes
   * focus on opening.
   */
  inline?: boolean;
}

/** The SDK parts: the alert dialog, or, inline, the plain non-modal dialog (as Dialog's). */
const ALERT = {
  Root: AlertDialog,
  Backdrop: AlertDialogBackdrop,
  Content: AlertDialogContent,
  Title: AlertDialogTitle,
};
const BESIDE = {
  Root: Dialog,
  Backdrop: DialogBackdrop,
  Content: DialogContent,
  Title: DialogTitle,
};

/**
 * The panel's blocking sound banner (AP §7.3): browsers block audio until the
 * user interacts, so after sign-in it covers the page until sound is enabled.
 * Escape and outside presses cannot dismiss it; focus starts on its button.
 */
export function BlockingBanner(props: BlockingBannerProps) {
  const { open, text, actionLabel, onEnable, inline = false } = props;
  const P = inline ? BESIDE : ALERT;
  const popup = (
    <>
      <P.Backdrop data-scrim="" className={scrim({ inline })} />
      <P.Content
        inline={inline}
        className={bar({ inline })}
        initialFocus={inline ? 'none' : '[data-enable]'}
      >
        <Icon name="bell" />
        <P.Title className="m-none min-w-none flex-1 text-panel-body font-bold">{text}</P.Title>
        <button type="button" data-enable="" className={action()} onClick={onEnable}>
          {actionLabel}
        </button>
      </P.Content>
    </>
  );
  return (
    <P.Root
      open={open}
      dismissible={false}
      {...(inline && { modal: false, closeOnOutsidePress: false })}
    >
      {inline ? <div className={frame()}>{popup}</div> : popup}
    </P.Root>
  );
}
