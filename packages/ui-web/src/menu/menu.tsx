import {
  Menu as SdkMenu,
  MenuContent,
  MenuItem,
  MenuSeparator,
  MenuTrigger,
} from '@ui-sdk/react/menu';
import type { ReactNode } from 'react';
import { formTv, keyboardRing } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** The states the stories show (R3): closed, open, with a destructive item, compact. */
export const STATES = ['default', 'open', 'destructive', 'comfortable'] as const;

export interface MenuAction {
  label: string;
  icon?: IconName;
  /** Drawn in danger after a separator: «تسجيل الخروج», «حذف». */
  destructive?: boolean;
  disabled?: boolean;
  onSelect: () => void;
}

export interface MenuProps {
  /** The trigger's name and text: the user's name, or «المزيد» for an icon trigger. */
  triggerLabel: string;
  /** What the trigger shows before its text: an avatar or an icon. */
  triggerStart?: ReactNode;
  /** An icon-only trigger (the «⋯» of a row): `triggerLabel` is its name. */
  triggerIcon?: IconName;
  items: readonly (MenuAction | 'separator')[];
  /** `compact` rows are 40 (panel and portal), `comfortable` 48. */
  density?: 'comfortable' | 'compact';
}

// The approved sheet: a raised surface with the medium elevation, radius 15,
// padding 4; rows of 40 on the web (48 comfortable), the highlighted one on
// `surface-raised-hover`; a destructive row in danger. It opens under its
// trigger aligned to its start (right in RTL) and fades in duration.fast.
const content = formTv({
  base: [
    'z-(--fd-layer-menu) min-w-(--fd-menu-min-width) max-h-(--available-height) overflow-y-auto p-(--fd-menu-padding) outline-hidden',
    'rounded-(--fd-menu-radius) bg-(--fd-menu-color-background) text-(color:--fd-menu-color-text) shadow-medium',
    'inset-ring-(length:--fd-menu-border-width) inset-ring-(color:--fd-menu-color-border)',
    'transition-opacity duration-(--fd-duration-fast) ease-(--fd-easing-standard) data-starting-style:opacity-0 data-ending-style:opacity-0',
  ],
});

const item = formTv({
  base: [
    'flex cursor-pointer items-center gap-(--fd-menu-item-gap) rounded-(--fd-menu-item-radius) px-(--fd-menu-item-padding-inline) font-medium outline-hidden',
    'data-highlighted:bg-(--fd-menu-color-item-hover) active:bg-(--fd-menu-color-item-pressed)',
    'data-disabled:cursor-not-allowed data-disabled:text-on-disabled',
    'data-destructive:text-(color:--fd-menu-color-danger)',
  ],
  variants: {
    density: {
      comfortable: 'min-h-(--fd-menu-item-height) text-phone-body',
      compact: 'min-h-(--fd-menu-compact-item-height) text-panel-body',
    },
  },
});

const separator = formTv({
  base: 'mx-(--fd-menu-separator-margin-inline) my-(--fd-menu-separator-margin-block) h-(--fd-menu-border-width) bg-(--fd-menu-color-border)',
});

const trigger = formTv({
  base: `inline-flex cursor-pointer items-center gap-xs rounded-full text-on-surface font-medium hover:bg-surface-raised-hover data-open:bg-surface-raised-hover ${keyboardRing}`,
  variants: {
    iconOnly: {
      true: 'size-(--fd-size-control-compact) justify-center',
      false: 'min-h-(--fd-size-control-compact) ps-2xs pe-sm inset-ring-1 inset-ring-border',
    },
    density: { comfortable: 'text-phone-body', compact: 'text-panel-body' },
  },
});

/**
 * A list of actions under a trigger (AP §7.2's user menu): arrow keys, Home
 * and End, type-ahead; Escape closes it and returns focus to the trigger.
 */
export function Menu({
  triggerLabel,
  triggerStart,
  triggerIcon,
  items,
  density = 'compact',
}: MenuProps) {
  return (
    <SdkMenu>
      <MenuTrigger
        className={trigger({ iconOnly: triggerIcon !== undefined, density })}
        {...(triggerIcon && { 'aria-label': triggerLabel })}
      >
        {triggerIcon ? (
          <Icon name={triggerIcon} />
        ) : (
          <>
            {triggerStart}
            {triggerLabel}
            <Icon name="chevron-down" size="sm" />
          </>
        )}
      </MenuTrigger>
      <MenuContent className={content()} side="bottom" align="start">
        {items.map((entry, index) =>
          entry === 'separator' ? (
            <MenuSeparator key={index} className={separator()} />
          ) : (
            <MenuItem
              key={entry.label}
              label={entry.label}
              className={item({ density })}
              onSelect={() => entry.onSelect()}
              {...(entry.destructive && { destructive: true })}
              {...(entry.disabled && { disabled: true })}
            >
              {entry.icon ? (
                <Icon name={entry.icon} size="sm" />
              ) : (
                <span className="size-(--fd-size-icon-sm)" />
              )}
              {entry.label}
            </MenuItem>
          ),
        )}
      </MenuContent>
    </SdkMenu>
  );
}
