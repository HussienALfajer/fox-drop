import { Tabs as SdkTabs, TabsIndicator, TabsList, TabsPanel, TabsTab } from '@ui-sdk/react/tabs';
import { useEffect, useRef, type ReactNode } from 'react';
import { CountBadge } from '../count-badge/count-badge';
import { formTv, keyboardRing } from '../field/styles';

/** The states the stories show (R3). */
export const STATES = ['default', 'count', 'overflow', 'pill', 'compact'] as const;

export interface TabItem {
  value: string;
  label: string;
  /** A count beside the label (D.9's CountBadge): new orders, notes. */
  count?: number;
  /** The count in words, read with the tab: «ملاحظتان». */
  countLabel?: string;
  disabled?: boolean;
  content: ReactNode;
}

export interface TabsProps {
  /** The tab list's name. */
  label: string;
  items: readonly TabItem[];
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  /** `underline` for detail pages and boards; `pill` for the customer's sections. */
  variant?: 'underline' | 'pill';
  /** `compact` tabs are 40 high (panel and portal), `comfortable` 48. */
  density?: 'comfortable' | 'compact';
}

// The approved sheet: underline tabs with an orange 3 px line under the
// selected one, a hairline under the list; pill tabs with the selected one
// orange on the offset shadow. The line slides in duration.fast; it jumps
// under reduced motion. Overflow scrolls sideways and the SDK keeps the
// selected tab in view.
const list = formTv({
  base: 'relative flex overflow-x-auto',
  variants: {
    variant: {
      underline: 'gap-2xs border-b border-border',
      pill: 'gap-xs py-2xs',
    },
  },
});

const tab = formTv({
  base: `inline-flex shrink-0 cursor-pointer items-center gap-xs whitespace-nowrap font-medium outline-hidden ${keyboardRing} data-disabled:cursor-not-allowed data-disabled:text-on-disabled`,
  variants: {
    variant: {
      underline:
        'px-sm text-on-surface-muted hover:text-on-surface data-selected:font-bold data-selected:text-on-surface',
      pill: 'rounded-full bg-surface-raised px-md text-on-surface inset-ring-1 inset-ring-border hover:bg-surface-raised-hover data-selected:bg-primary data-selected:text-on-primary data-selected:shadow-offset data-selected:inset-ring-0',
    },
    density: {
      comfortable: 'min-h-(--fd-size-touch-target) text-phone-body',
      compact: 'min-h-(--fd-size-control-compact) text-panel-body',
    },
  },
  compoundVariants: [
    {
      variant: 'pill',
      density: 'comfortable',
      class: 'min-h-(--fd-size-control-compact) text-phone-secondary',
    },
  ],
});

const indicator = formTv({
  base: [
    'absolute bottom-none start-(--active-tab-left) h-(--fd-space-2xs) w-(--active-tab-width) rounded-full bg-primary',
    // The SDK measures from the physical edges: the right one is the start in RTL.
    'rtl:start-(--active-tab-right)',
    'transition-all duration-(--fd-duration-fast) ease-(--fd-easing-standard) motion-reduce:transition-none',
  ],
});

/**
 * Tabs for detail pages (AP §7.4) and boards: one tab stop, arrows follow the
 * reading order (left is the next tab in RTL), Home and End; the selected tab
 * is announced with its count.
 */
export function Tabs(props: TabsProps) {
  const { label, items, value, defaultValue, onValueChange } = props;
  const { variant = 'underline', density = 'compact' } = props;
  const listRef = useRef<HTMLDivElement>(null);
  // The SDK scrolls a tab into view when it is chosen; this does it for the
  // tab selected on the first render too (an overflowing list on a phone).
  useEffect(() => {
    listRef.current
      ?.querySelector('[data-selected]')
      ?.scrollIntoView({ block: 'nearest', inline: 'nearest' });
  }, []);
  return (
    <SdkTabs
      className="flex flex-col gap-md"
      {...(value !== undefined && { value })}
      {...(defaultValue !== undefined && { defaultValue })}
      {...(onValueChange && {
        onValueChange: (next: string | null) => {
          if (next !== null) onValueChange(next);
        },
      })}
    >
      <TabsList ref={listRef} aria-label={label} data-variant={variant} className={list({ variant })}>
        {items.map((item) => (
          <TabsTab
            key={item.value}
            value={item.value}
            className={tab({ variant, density })}
            {...(item.disabled && { disabled: true })}
          >
            {item.label}
            {item.count !== undefined && (
              <CountBadge
                count={item.count}
                label={item.countLabel ?? String(item.count)}
                tone="accent"
              />
            )}
          </TabsTab>
        ))}
        {variant === 'underline' && <TabsIndicator className={indicator()} />}
      </TabsList>
      {items.map((item) => (
        <TabsPanel key={item.value} value={item.value} className="outline-hidden">
          {item.content}
        </TabsPanel>
      ))}
    </SdkTabs>
  );
}
