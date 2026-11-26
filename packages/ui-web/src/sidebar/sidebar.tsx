import type { ReactNode } from 'react';
import { CountBadge } from '../count-badge/count-badge';
import { Drawer } from '../drawer/drawer';
import { formTv, keyboardRing } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';
import { Tooltip } from '../tooltip/tooltip';

/** The states the stories show (R3): expanded, collapsed, the portal's list, the phone drawer. */
export const STATES = ['default', 'collapsed', 'portal', 'drawer'] as const;

export interface SidebarItem {
  href: string;
  label: string;
  /** Batch 1 has no icon for some panel modules yet: they show a dot (owner, 2026-11-24). */
  icon?: IconName;
  count?: number;
  /** The count in words, read with the link: «3 تنبيهات». */
  countLabel?: string;
}

interface SidebarBase {
  /** The navigation's name. */
  label: string;
  /** The modules this user may open (AP §7.1: each sees only theirs). */
  items: readonly SidebarItem[];
  /** The current page's href: its link gets `aria-current="page"`. */
  current: string;
  /** What sits above the links: the logo. */
  brand?: ReactNode;
  collapsed?: boolean;
  onCollapsedChange?: (collapsed: boolean) => void;
  collapseLabel: string;
  expandLabel: string;
}

/** `rail` beside the page; `drawer` below the tablet width (AP §7.5), whose × needs its name. */
export type SidebarProps = SidebarBase &
  (
    | { form?: 'rail'; open?: never; onOpenChange?: never; closeLabel?: never; inline?: never }
    | {
        form: 'drawer';
        open?: boolean;
        onOpenChange?: (open: boolean) => void;
        closeLabel: string;
        /** The open drawer in its frame, beside the page (the components canvas). */
        inline?: boolean;
      }
  );

// The approved sheet: the raised surface on the start side (right in RTL)
// with a hairline at its end; links 40 high, the current one tinted with an
// orange start edge; counts at the end; collapsed to 72, icons only, each
// name in a tooltip.
// The ground, the end hairline and the item colours are `navigation-rail.json`'s,
// shared with the Flutter rail (slice D.W4d).
const nav = formTv({
  base: 'flex h-full shrink-0 flex-col gap-(--fd-navigation-rail-gap) bg-(--fd-navigation-rail-color-background) py-(--fd-navigation-rail-padding-block) text-on-surface',
  variants: {
    collapsed: {
      false: 'w-(--fd-navigation-rail-width)',
      true: 'w-(--fd-navigation-rail-width-collapsed) items-center',
    },
    form: {
      rail: 'border-e-(length:--fd-navigation-rail-border-width) border-(--fd-navigation-rail-color-border)',
      drawer: 'w-full',
    },
  },
});

const link = formTv({
  base: `relative flex min-h-(--fd-navigation-rail-link-height) items-center gap-sm rounded-md text-panel-body font-medium no-underline hover:bg-(--fd-navigation-rail-color-item-hover) active:bg-(--fd-navigation-rail-color-item-pressed) ${keyboardRing}`,
  variants: {
    current: {
      true: 'bg-(--fd-navigation-rail-color-item-selected) font-bold text-(color:--fd-navigation-rail-color-on-item-selected) border-s-(length:--fd-navigation-rail-current-edge) border-(--fd-navigation-rail-color-current-edge) hover:bg-(--fd-navigation-rail-color-item-selected)',
      false: 'text-on-surface',
    },
    collapsed: {
      false: 'mx-xs px-sm',
      true: 'w-(--fd-size-touch-target) justify-center',
    },
  },
});

const toggle = formTv({
  base: `mt-auto flex min-h-(--fd-size-touch-target) cursor-pointer items-center gap-xs rounded-md px-md text-panel-secondary text-on-surface-muted hover:bg-surface-raised-hover ${keyboardRing}`,
});

function Links(props: SidebarProps & { collapsed: boolean }) {
  const { items, current, collapsed } = props;
  return (
    <ul className="m-none flex list-none flex-col gap-(--fd-navigation-rail-gap) p-none">
      {items.map((item) => {
        const isCurrent = item.href === current;
        const mark = item.icon ? (
          <Icon name={item.icon} size="sm" />
        ) : (
          <span className="flex size-(--fd-size-icon-sm) items-center justify-center">
            <span className="size-2xs rounded-full bg-current" />
          </span>
        );
        const name = item.countLabel ? `${item.label}، ${item.countLabel}` : item.label;
        const anchor = (
          <a
            href={item.href}
            className={link({ current: isCurrent, collapsed })}
            {...(isCurrent && { 'aria-current': 'page' as const })}
            {...(collapsed && { 'aria-label': name })}
          >
            {mark}
            {/* Collapsed, the count sits on the link's corner, beside the icon, not over it. */}
            {item.count !== undefined && collapsed && (
              <span className="absolute -top-2xs -end-2xs flex">
                <CountBadge count={item.count} label={name} />
              </span>
            )}
            {!collapsed && <span className="min-w-none flex-1 truncate">{item.label}</span>}
            {!collapsed && item.count !== undefined && (
              <CountBadge count={item.count} label={item.countLabel ?? String(item.count)} />
            )}
          </a>
        );
        return (
          <li key={item.href}>
            {collapsed ? (
              <Tooltip content={item.label} side="start">
                {anchor}
              </Tooltip>
            ) : (
              anchor
            )}
          </li>
        );
      })}
    </ul>
  );
}

/**
 * The navigation of the panel (AP §7.1) and the owner portal (RA §17): one
 * component on the start side, with a collapsed form that keeps the names
 * and, below the tablet width, a drawer from the start side.
 */
export function Sidebar(props: SidebarProps) {
  const { label, brand, collapseLabel, expandLabel, onCollapsedChange } = props;
  const form = props.form ?? 'rail';
  if (props.form === 'drawer')
    return (
      <Drawer
        title={label}
        closeLabel={props.closeLabel}
        side="start"
        {...(props.open !== undefined && { open: props.open })}
        {...(props.onOpenChange && { onOpenChange: props.onOpenChange })}
        {...(props.inline && { inline: true })}
      >
        <nav aria-label={label} className={nav({ collapsed: false, form })}>
          <Links {...props} collapsed={false} />
        </nav>
      </Drawer>
    );
  const collapsed = props.collapsed ?? false;
  return (
    <nav
      aria-label={label}
      className={nav({ collapsed, form })}
      {...(collapsed && { 'data-collapsed': '' })}
    >
      {brand}
      <Links {...props} collapsed={collapsed} />
      {onCollapsedChange && (
        <button type="button" className={toggle()} onClick={() => onCollapsedChange(!collapsed)}>
          <span className={collapsed ? 'flex rotate-180' : 'flex'}>
            <Icon name="back" size="sm" />
          </span>
          {collapsed ? <span className="sr-only">{expandLabel}</span> : collapseLabel}
        </button>
      )}
    </nav>
  );
}
