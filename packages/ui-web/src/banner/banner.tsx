import type { ReactNode } from 'react';
import { formTv, keyboardRing } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** The states the stories show (R3): each tone, an action, compact. */
export const STATES = [
  'danger',
  'caution',
  'warning',
  'info',
  'neutral',
  'action',
  'compact',
  'dismissible',
  'paired',
] as const;

/** The tones the specs name (RA §6.3, CA §6.3): red, yellow, amber, blue, grey. */
export const BANNER_TONES = ['danger', 'caution', 'warning', 'info', 'neutral'] as const;
export type BannerTone = (typeof BANNER_TONES)[number];

const ICON: Record<BannerTone, IconName> = {
  danger: 'error',
  caution: 'warning',
  warning: 'warning',
  info: 'info',
  neutral: 'info',
};

// The approved sheet (owner, 2026-11-24, question 4 «A»): red is solid, the
// work stops; every other tone is its text on its tint, with a hairline under
// it. The text and the icon say the tone, never the colour alone.
const hairline =
  'border-b-(length:--fd-banner-border-width) border-(color:--fd-banner-color-border)';
const banner = formTv({
  base: 'flex w-full items-center gap-(--fd-banner-gap) px-(--fd-banner-padding-inline)',
  variants: {
    tone: {
      danger: 'bg-(--fd-banner-color-danger-background) text-(color:--fd-banner-color-danger-text)',
      caution: `bg-(--fd-banner-color-caution-background) text-(color:--fd-banner-color-caution-text) ${hairline}`,
      warning: `bg-(--fd-banner-color-warning-background) text-(color:--fd-banner-color-warning-text) ${hairline}`,
      info: `bg-(--fd-banner-color-info-background) text-(color:--fd-banner-color-info-text) ${hairline}`,
      neutral: `bg-(--fd-banner-color-neutral-background) text-(color:--fd-banner-color-neutral-text) ${hairline}`,
    },
    density: {
      comfortable:
        'min-h-(--fd-banner-min-height) py-(--fd-banner-padding-block) text-phone-secondary font-medium',
      compact:
        'min-h-(--fd-banner-compact-min-height) py-(--fd-banner-compact-padding-block) text-panel-secondary font-medium',
    },
  },
  defaultVariants: { density: 'comfortable' },
});

const action = formTv({
  base: `inline-flex shrink-0 cursor-pointer items-center gap-2xs rounded-sm font-bold underline underline-offset-4 ${keyboardRing}`,
});

// The close control fills the bar's height and stays a 48 target (R13); it
// has no fill of its own, so it reads as part of the bar in every tone.
const dismissButton = formTv({
  base: `-my-xs -me-xs flex size-(--fd-size-touch-target) shrink-0 cursor-pointer items-center justify-center rounded-full ${keyboardRing}`,
});

/** One of the banner's actions: words first, an icon when it names a channel. */
export interface BannerAction {
  label: string;
  onAction: () => void;
  icon?: IconName;
}

export interface BannerProps {
  tone: BannerTone;
  /** What happened, in words: the tone is never the only signal. */
  children: ReactNode;
  /** Another icon than the tone's, such as `offline`. */
  icon?: IconName;
  action?: BannerAction;
  /** A second way out, such as a call beside WhatsApp; both move under the words. */
  secondaryAction?: BannerAction;
  /** A banner the user may put away for now (an update on offer): its close control's name. */
  dismiss?: { label: string; onDismiss: () => void };
  density?: 'comfortable' | 'compact';
}

function ActionButton({ act }: { act: BannerAction }) {
  return (
    <button type="button" className={action()} onClick={act.onAction}>
      {act.icon && <Icon name={act.icon} size="sm" />}
      {act.label}
    </button>
  );
}

/**
 * A full-width bar under the top bar: no connection, emergency stop, test
 * mode, an update. Red is an alert; the rest are a status. With two actions,
 * the actions take their own line under the words so neither is squeezed.
 */
export function Banner({
  tone,
  children,
  icon,
  action: act,
  secondaryAction: second,
  dismiss,
  density,
}: BannerProps) {
  const stacked = Boolean(act && second);
  return (
    <div
      role={tone === 'danger' ? 'alert' : 'status'}
      data-tone={tone}
      // Stacked, the words and actions start at the top; the block padding
      // stays the density's (the D.10 sheet's 8: a `py-sm` here lost to it in
      // the CSS order anyway, D.W3c).
      className={banner({ tone, density, class: stacked ? 'items-start' : '' })}
    >
      <Icon name={icon ?? ICON[tone]} />
      {stacked ? (
        <div className="flex min-w-none flex-1 flex-col gap-xs">
          <span data-banner-text="">{children}</span>
          <div className="flex flex-wrap gap-x-(--fd-banner-actions-gap) gap-y-xs">
            {act && <ActionButton act={act} />}
            {second && <ActionButton act={second} />}
          </div>
        </div>
      ) : (
        <>
          <span data-banner-text="" className="min-w-none flex-1">
            {children}
          </span>
          {(act ?? second) && <ActionButton act={(act ?? second)!} />}
        </>
      )}
      {dismiss && (
        <button
          type="button"
          aria-label={dismiss.label}
          className={dismissButton({ class: stacked ? 'my-none' : '' })}
          onClick={dismiss.onDismiss}
        >
          <Icon name="close" />
        </button>
      )}
    </div>
  );
}
