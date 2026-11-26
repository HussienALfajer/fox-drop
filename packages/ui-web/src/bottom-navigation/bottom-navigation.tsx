import type { KeyboardEvent } from 'react';
import { CountBadge } from '../count-badge/count-badge';
import { formTv } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** The states the stories show (R3), as the Flutter twin's. */
export const STATES = ['default', 'badge', 'dot'] as const;

// The bar's outline in the owner's Figma shape (D.11 screen 6), as the
// Flutter twin's `FoxNavOutlinePainter` draws it: one smooth shape that
// swells round each tab and dips between them. Drawing geometry in the bar's
// own units (the SVG's viewBox), never a style: a 48 circle every 56 (the
// item size and the gap), the ends half circles of half the bar's 64, a dip
// of 8 (`space.xs`).
const STEP = 56;
const DIP = 8;
const HEIGHT = 64;
// The Figma curve between two tabs, as fractions of the step.
const CURVE_A = 14.4 / 56;
const CURVE_B = 15.4 / 56;

const outlineWidth = (count: number) => HEIGHT + (count - 1) * STEP;
const round = (value: number) => Number(value.toFixed(3));

/** The SVG path of the outline for `count` tabs, from its start (x = 0). */
function outline(count: number): string {
  const radius = HEIGHT / 2;
  const bottom = HEIGHT;
  const a = CURVE_A * STEP;
  const b = CURVE_B * STEP;
  const parts = [`M${radius} ${bottom}`, `A${radius} ${radius} 0 0 1 ${radius} 0`];
  for (let tab = 0; tab < count - 1; tab++) {
    const x = radius + tab * STEP;
    parts.push(
      `C${round(x + a)} 0 ${round(x + b)} ${DIP} ${x + STEP / 2} ${DIP}`,
      `C${round(x + STEP - b)} ${DIP} ${round(x + STEP - a)} 0 ${x + STEP} 0`,
    );
  }
  const last = radius + (count - 1) * STEP;
  parts.push(`A${radius} ${radius} 0 0 1 ${last} ${bottom}`);
  for (let tab = count - 1; tab > 0; tab--) {
    const x = radius + tab * STEP;
    const up = bottom - DIP;
    parts.push(
      `C${round(x - a)} ${bottom} ${round(x - b)} ${up} ${x - STEP / 2} ${up}`,
      `C${round(x - STEP + b)} ${up} ${round(x - STEP + a)} ${bottom} ${x - STEP} ${bottom}`,
    );
  }
  parts.push('Z');
  return parts.join(' ');
}

export interface BottomNavigationItem {
  icon: IconName;
  /** The name, read by screen readers: the bar shows icons only. */
  label: string;
  /** A count on the icon; `countLabel` says it («1 جديد») with the name. */
  count?: number;
  /** A dot instead of a count: something new, no number. */
  dot?: boolean;
  /** The badge in words, read with the name; needed with `count` or `dot`. */
  countLabel?: string;
}

export interface BottomNavigationProps {
  /** The navigation's name: «التنقل الرئيسي». */
  label: string;
  items: readonly BottomNavigationItem[];
  /** The current item's index. */
  selected: number;
  onSelect: (index: number) => void;
}

const bar = formTv({
  slots: {
    root: 'flex justify-center p-(--fd-bottom-navigation-margin)',
    pill: [
      'relative flex h-(--fd-bottom-navigation-height) items-center gap-(--fd-bottom-navigation-gap)',
      'px-(--fd-bottom-navigation-padding-inline)',
    ],
    shape: 'pointer-events-none absolute inset-none size-full overflow-visible',
    halo: 'fill-none stroke-(--fd-bottom-navigation-color-halo) stroke-(length:--fd-bottom-navigation-halo-width)',
    fill: 'fill-(--fd-bottom-navigation-color-fill)',
    slot: 'relative flex size-(--fd-bottom-navigation-item-size) shrink-0 items-center justify-center',
    item: [
      'flex shrink-0 cursor-pointer items-center justify-center rounded-full border-none p-none',
      'transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
      'outline-hidden focus-visible:inset-ring-(length:--fd-input-focus-width) focus-visible:inset-ring-(--fd-bottom-navigation-color-focus)',
    ],
  },
  variants: {
    selected: {
      true: {
        item: [
          'size-(--fd-bottom-navigation-item-size-selected) bg-(--fd-bottom-navigation-color-item-selected)',
          'text-(color:--fd-bottom-navigation-color-icon-selected) active:bg-(--fd-bottom-navigation-color-item-selected-pressed)',
        ],
      },
      false: {
        item: [
          'size-(--fd-bottom-navigation-item-size) bg-(--fd-bottom-navigation-color-item) text-(color:--fd-bottom-navigation-color-icon)',
          'hover:bg-(--fd-bottom-navigation-color-item-hover) active:bg-(--fd-bottom-navigation-color-item-pressed)',
        ],
      },
    },
  },
});

const KEYS = ['ArrowLeft', 'ArrowRight', 'Home', 'End'];

/** A badge's own words stay empty: the item's name already says them. */
const IN_THE_NAME = '';

/** Moves focus along the bar: the arrows by visual side (left is next in RTL), Home and End to the ends. */
function moveFocus(event: KeyboardEvent<HTMLElement>) {
  if (!KEYS.includes(event.key)) return;
  const buttons = [...event.currentTarget.querySelectorAll<HTMLButtonElement>('button')];
  const at = buttons.indexOf(document.activeElement as HTMLButtonElement);
  if (at < 0) return;
  const rtl = event.currentTarget.closest('[dir]')?.getAttribute('dir') === 'rtl';
  const forward = rtl ? 'ArrowLeft' : 'ArrowRight';
  const next =
    event.key === 'Home'
      ? 0
      : event.key === 'End'
        ? buttons.length - 1
        : Math.min(Math.max(at + (event.key === forward ? 1 : -1), 0), buttons.length - 1);
  event.preventDefault();
  buttons[next]?.focus();
}

/**
 * The bottom navigation of the three apps (D.10; the Figma shape, D.11b): an
 * accent outline that swells round each tab, in a `nav-halo` ring, an ivory
 * circle per item and the current one a larger orange circle. Every icon
 * Linear, the current one too: its larger circle alone marks it (owner,
 * 2026-11-25). Icons only: each item's name is read by screen readers, with
 * its badge.
 */
export function BottomNavigation({ label, items, selected, onSelect }: BottomNavigationProps) {
  const viewBox = ['0', '0', outlineWidth(items.length), HEIGHT].join(' ');
  const path = outline(items.length);
  return (
    <nav aria-label={label} className={bar().root()} onKeyDown={moveFocus}>
      <div className={bar().pill()}>
        <svg
          aria-hidden="true"
          focusable="false"
          viewBox={viewBox}
          preserveAspectRatio="none"
          className={bar().shape()}
        >
          <path d={path} strokeLinejoin="round" className={bar().halo()} />
          <path d={path} className={bar().fill()} />
        </svg>
        {items.map((item, index) => {
          const current = index === selected;
          const parts = bar({ selected: current });
          const name = item.countLabel ? `${item.label}، ${item.countLabel}` : item.label;
          const button = (
            <button
              type="button"
              aria-label={name}
              className={parts.item()}
              onClick={() => onSelect(index)}
              {...(current && { 'aria-current': 'page' as const })}
            >
              <Icon name={item.icon} size="lg" />
            </button>
          );
          // The count or dot sits on the circle's end corner; the button's
          // name already says it, so the badge's own words stay empty.
          return (
            <span key={item.label} className={parts.slot()}>
              {item.count !== undefined || item.dot ? (
                <CountBadge count={item.dot ? undefined : item.count} label={IN_THE_NAME}>
                  {button}
                </CountBadge>
              ) : (
                button
              )}
            </span>
          );
        })}
      </div>
    </nav>
  );
}
