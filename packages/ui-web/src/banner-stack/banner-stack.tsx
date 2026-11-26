import { useId, useState } from 'react';
import { formTv, keyboardRing } from '../field/styles';
import { Banner, type BannerProps, type BannerTone } from '../banner/banner';
import { Icon } from '../icon/icon';

/** The states the stories show (R3): one, two, more folded, more opened. */
export const STATES = ['one', 'two', 'folded', 'opened'] as const;

/** How many banners show before the counter (RA §6.3). */
export const SHOWN = 2;

export interface StackedBanner {
  /** Stable, so a banner that clears does not move focus or remount the others. */
  id: string;
  tone: BannerTone;
  text: string;
  icon?: BannerProps['icon'];
  action?: BannerProps['action'];
  secondaryAction?: BannerProps['secondaryAction'];
  dismiss?: BannerProps['dismiss'];
}

export interface BannerStackProps {
  /** In the app's priority order, highest first (RA §6.3, CA §6.3, CU §6.2). */
  banners: readonly StackedBanner[];
  /** The counter's words for the hidden count: «+3 تنبيهات أخرى». */
  moreLabel: (hidden: number) => string;
  /** The words that fold them again: «إخفاء». */
  lessLabel: string;
  density?: BannerProps['density'];
}

const toggle = formTv({
  base: `inline-flex min-h-(--fd-banner-stack-toggle-height) cursor-pointer items-center gap-2xs rounded-full px-(--fd-banner-stack-toggle-padding-inline) font-bold text-on-surface ${keyboardRing}`,
  variants: {
    open: {
      false: 'bg-surface-raised inset-ring-1 inset-ring-border hover:bg-surface-raised-hover',
      true: 'hover:bg-surface-hover',
    },
    density: {
      comfortable: 'text-phone-secondary',
      compact: 'text-panel-secondary',
    },
  },
  defaultVariants: { density: 'comfortable' },
});

/**
 * The banners under the top bar: the first two in the given order, the rest
 * behind a counter that opens them in place. A banner that clears leaves at
 * once and the next moves up.
 */
export function BannerStack({ banners, moreLabel, lessLabel, density }: BannerStackProps) {
  const [open, setOpen] = useState(false);
  const id = useId();
  if (banners.length === 0) return null;
  const hidden = banners.length - SHOWN;
  const shown = open ? banners : banners.slice(0, SHOWN);
  const label = open ? lessLabel : moreLabel(hidden);
  return (
    <div className="flex flex-col">
      <div id={id} className="flex flex-col">
        {shown.map((b) => (
          <Banner
            key={b.id}
            tone={b.tone}
            {...(b.icon && { icon: b.icon })}
            {...(b.action && { action: b.action })}
            {...(b.secondaryAction && { secondaryAction: b.secondaryAction })}
            {...(b.dismiss && { dismiss: b.dismiss })}
            {...(density && { density })}
          >
            {b.text}
          </Banner>
        ))}
      </div>
      {hidden > 0 && (
        <div className="flex justify-end bg-surface px-sm py-2xs">
          <button
            type="button"
            aria-expanded={open}
            aria-controls={id}
            className={toggle({ open, density })}
            onClick={() => setOpen(!open)}
          >
            {label}
            <span className={open ? 'flex rotate-180' : 'flex'}>
              <Icon name="chevron-down" size="sm" />
            </span>
          </button>
        </div>
      )}
    </div>
  );
}
