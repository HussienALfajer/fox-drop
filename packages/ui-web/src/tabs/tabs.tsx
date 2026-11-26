import { Tabs as SdkTabs, TabsIndicator, TabsList, TabsPanel, TabsTab } from '@ui-sdk/react/tabs';
import { useEffect, useRef, useState, type ReactNode } from 'react';
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
// selected one (square, as the sheet draws it; it was 4 and rounded until
// D.W3c), its count in red and the others' in blue, a hairline under the list; pill tabs with the selected one
// orange on the offset shadow. The line slides in duration.fast; it jumps
// under reduced motion. Overflow scrolls sideways and the SDK keeps the
// selected tab in view.
// The wrapper scrolls, not the list: the SDK places the indicator from the
// list's edges as if it scrolled left to right, so a scrolled RTL list put
// the line outside itself, unseen, where it also widened the scroll range
// (found by a screenshot that moved with the fonts' timing, PR 300). The list
// is as wide as its tabs and never scrolls.
const scroller = formTv({
  base: 'overflow-x-auto',
  variants: {
    variant: {
      underline: 'border-b-(length:--fd-tabs-border-width) border-(color:--fd-tabs-color-border)',
      pill: '',
    },
  },
});

const list = formTv({
  base: 'relative flex w-max min-w-full',
  variants: {
    variant: {
      underline: 'gap-(--fd-tabs-gap)',
      pill: 'gap-(--fd-tabs-pill-gap) py-2xs',
    },
  },
});

const tab = formTv({
  base: `inline-flex shrink-0 cursor-pointer items-center gap-(--fd-tabs-label-gap) whitespace-nowrap font-medium outline-hidden ${keyboardRing} data-disabled:cursor-not-allowed data-disabled:text-on-disabled`,
  variants: {
    variant: {
      underline:
        'px-(--fd-tabs-padding-inline) text-(color:--fd-tabs-color-text) hover:text-(color:--fd-tabs-color-text-hover) data-selected:font-bold data-selected:text-(color:--fd-tabs-color-text-selected)',
      pill: [
        'rounded-full bg-(--fd-tabs-pill-color-background) px-(--fd-tabs-pill-padding-inline) text-(color:--fd-tabs-pill-color-text)',
        'inset-ring-(length:--fd-tabs-border-width) inset-ring-(color:--fd-tabs-color-border) hover:bg-(--fd-tabs-pill-color-background-hover)',
        'data-selected:bg-(--fd-tabs-pill-color-background-selected) data-selected:text-(color:--fd-tabs-pill-color-text-selected) data-selected:shadow-offset data-selected:inset-ring-0',
      ],
    },
    density: {
      comfortable: 'min-h-(--fd-tabs-height) text-phone-body',
      compact: 'min-h-(--fd-tabs-compact-height) text-panel-body',
    },
  },
  compoundVariants: [
    {
      variant: 'pill',
      density: 'comfortable',
      class: 'min-h-(--fd-tabs-pill-height) text-phone-secondary',
    },
  ],
});

const indicator = formTv({
  base: [
    'absolute bottom-none start-(--active-tab-left) h-(--fd-tabs-indicator) w-(--active-tab-width) bg-(--fd-tabs-color-indicator)',
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
  // The selected tab, followed here for its count's red (the sheet).
  // Without a default the SDK selects the first enabled tab.
  const [inner, setInner] = useState(defaultValue ?? items.find((item) => !item.disabled)?.value);
  const selected = value ?? inner;
  // The SDK scrolls a tab into view when it is chosen; this does it for the
  // tab selected on the first render too (an overflowing list on a phone),
  // and again each time the row's tabs change size until the person first
  // touches the row: the tabs widen when CoFo replaces the fallback font,
  // whenever that lands, which pushed the selected tab back out of view (a
  // screenshot differed with the fonts' timing, PR 300). Centred, as
  // Flutter's `ensureVisible`: where it lands depends only on the final
  // layout, not on where the row was before (as `nearest` does).
  useEffect(() => {
    const list = listRef.current;
    if (!list) return;
    const reveal = () =>
      list.querySelector('[data-selected]')?.scrollIntoView({ block: 'nearest', inline: 'center' });
    reveal();
    // jsdom has no ResizeObserver.
    if (typeof ResizeObserver === 'undefined') return;
    const observer = new ResizeObserver(reveal);
    for (const tab of list.querySelectorAll('[role="tab"]')) observer.observe(tab);
    const stop = () => observer.disconnect();
    const touched = ['pointerdown', 'keydown', 'wheel', 'touchstart'] as const;
    for (const type of touched) list.addEventListener(type, stop, { once: true });
    return () => {
      stop();
      for (const type of touched) list.removeEventListener(type, stop);
    };
  }, []);
  return (
    <SdkTabs
      className="flex flex-col gap-md"
      {...(value !== undefined && { value })}
      {...(defaultValue !== undefined && { defaultValue })}
      onValueChange={(next: string | null) => {
        if (next === null) return;
        setInner(next);
        onValueChange?.(next);
      }}
    >
      <div className={scroller({ variant })}>
        <TabsList
          ref={listRef}
          aria-label={label}
          data-variant={variant}
          className={list({ variant })}
        >
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
                  tone={item.value === selected ? 'danger' : 'accent'}
                />
              )}
            </TabsTab>
          ))}
          {variant === 'underline' && <TabsIndicator className={indicator()} />}
        </TabsList>
      </div>
      {items.map((item) => (
        <TabsPanel key={item.value} value={item.value} className="text-on-surface outline-hidden">
          {item.content}
        </TabsPanel>
      ))}
    </SdkTabs>
  );
}
