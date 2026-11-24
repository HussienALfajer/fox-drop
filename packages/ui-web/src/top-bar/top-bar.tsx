import type { ReactNode } from 'react';
import { CountBadge } from '../count-badge/count-badge';
import { formTv, keyboardRing } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** The states the stories show (R3): the panel's full bar, the phone bar, the emergency stop. */
export const STATES = ['default', 'phone', 'emergency'] as const;

export interface TopBarAction {
  icon: IconName;
  /** Its name: «التنبيهات». */
  label: string;
  count?: number;
  /** The count in words, read with the name: «4 مفتوحة». */
  countLabel?: string;
  onAction: () => void;
}

export interface TopBarProps {
  /** The bar's name as a landmark. */
  label: string;
  /** The page's title, for the phone form. */
  title?: string;
  /** The button that opens the sidebar drawer below the tablet width (AP §7.5). */
  menu?: { label: string; onMenu: () => void };
  /** The start slot: the city selector, the platform status, the dispatch mode. */
  start?: ReactNode;
  /** The middle: the global search. */
  children?: ReactNode;
  /** Icon actions with counts: the alerts bell, the approvals (AP §7.2). */
  actions?: readonly TopBarAction[];
  /** The end slot: the user menu. */
  end?: ReactNode;
}

// The approved sheet: 64 high on the raised surface with a hairline under it,
// sticky above the page (layer.sticky); the banners sit under it.
const bar = formTv({
  base: 'sticky top-none z-(--fd-layer-sticky) flex min-h-(--fd-size-bar) items-center gap-md border-b border-border bg-surface-raised px-md text-on-surface',
});

const iconButton = formTv({
  base: `relative inline-flex size-(--fd-size-control-compact) shrink-0 cursor-pointer items-center justify-center rounded-full inset-ring-1 inset-ring-border hover:bg-surface-raised-hover active:bg-surface-raised-pressed ${keyboardRing}`,
});

/**
 * The bar at the top of the panel and the portal (AP §7.2): slots the app
 * fills, icon actions read with their counts, and on a phone the menu button
 * and the page's title.
 */
export function TopBar({ label, title, menu, start, children, actions, end }: TopBarProps) {
  return (
    <header aria-label={label} className={bar()}>
      {menu && (
        <button type="button" className={iconButton()} onClick={menu.onMenu}>
          <Icon name="menu" />
          <span className="sr-only">{menu.label}</span>
        </button>
      )}
      {title && (
        <h1 className="m-none min-w-none truncate text-panel-subtitle font-bold">{title}</h1>
      )}
      {start && <div className="flex shrink-0 items-center gap-xs">{start}</div>}
      <div className="flex min-w-none flex-1 items-center">{children}</div>
      {actions?.map((action) => (
        <button key={action.label} type="button" className={iconButton()} onClick={action.onAction}>
          <span className="sr-only">{action.label}</span>
          {action.count === undefined ? (
            <Icon name={action.icon} />
          ) : (
            <CountBadge count={action.count} label={action.countLabel ?? String(action.count)}>
              <Icon name={action.icon} />
            </CountBadge>
          )}
        </button>
      ))}
      {end}
    </header>
  );
}
