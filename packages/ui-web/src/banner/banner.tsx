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
const banner = formTv({
  base: 'flex w-full items-center gap-sm px-md',
  variants: {
    tone: {
      danger: 'bg-danger text-on-danger',
      caution: 'bg-caution-subtle text-caution border-b border-border',
      warning: 'bg-warning-subtle text-warning border-b border-border',
      info: 'bg-info-subtle text-info border-b border-border',
      neutral: 'bg-neutral-subtle text-neutral border-b border-border',
    },
    density: {
      comfortable: 'min-h-(--fd-size-touch-target) py-xs text-phone-secondary font-medium',
      compact: 'min-h-(--fd-size-control-compact) py-2xs text-panel-secondary font-medium',
    },
  },
  defaultVariants: { density: 'comfortable' },
});

const action = formTv({
  base: `shrink-0 cursor-pointer rounded-sm font-bold underline underline-offset-4 ${keyboardRing}`,
});

export interface BannerProps {
  tone: BannerTone;
  /** What happened, in words: the tone is never the only signal. */
  children: ReactNode;
  /** Another icon than the tone's, such as `offline`. */
  icon?: IconName;
  action?: { label: string; onAction: () => void };
  density?: 'comfortable' | 'compact';
}

/**
 * A full-width bar under the top bar: no connection, emergency stop, test
 * mode, an update. Red is an alert; the rest are a status.
 */
export function Banner({ tone, children, icon, action: act, density }: BannerProps) {
  return (
    <div
      role={tone === 'danger' ? 'alert' : 'status'}
      data-tone={tone}
      className={banner({ tone, density })}
    >
      <Icon name={icon ?? ICON[tone]} />
      <span data-banner-text="" className="min-w-none flex-1">
        {children}
      </span>
      {act && (
        <button type="button" className={action()} onClick={act.onAction}>
          {act.label}
        </button>
      )}
    </div>
  );
}
