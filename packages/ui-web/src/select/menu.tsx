import { SelectContent, SelectItem, SelectItemIndicator } from '@ui-sdk/react/select';
import { formTv } from '../field/styles';
import { Icon } from '../icon/icon';

// The listbox drawn on the sheet (`listbox()` in design-tokens
// `src/forms-sheet.ts`): the field's width, `surface-raised`, radius 15, padding
// 4, the medium elevation, items 48 high with a radius 10, the highlighted one
// on `surface-hover`, the chosen one medium weight with a brand-orange check.
const content = formTv({
  base: [
    'z-10 min-w-(--anchor-width) max-h-(--available-height) overflow-y-auto p-(--fd-space-2xs) outline-hidden',
    'rounded-(--fd-input-area-radius) bg-(--fd-input-color-background) text-(color:--fd-input-color-text)',
    'shadow-(--fd-elevation-medium)',
  ],
});

const item = formTv({
  base: [
    'flex min-h-(--fd-input-check-target) cursor-pointer items-center justify-between gap-(--fd-input-gap)',
    'rounded-md px-sm text-phone-body outline-hidden',
    'data-highlighted:bg-surface-hover active:bg-surface-pressed',
    'data-disabled:cursor-not-allowed data-disabled:text-(color:--fd-input-color-on-disabled)',
    'data-selected:font-medium',
  ],
});

export interface MenuItem {
  value: string;
  label: string;
}

/**
 * The popup list of a select and of the phone field's country chip. Internal.
 */
export function Menu({ items, dir }: { items: readonly MenuItem[]; dir?: 'rtl' | 'ltr' }) {
  return (
    <SelectContent className={content()} sideOffset={4} align="start" {...(dir && { dir })}>
      {items.map((entry) => (
        <SelectItem key={entry.value} value={entry.value} className={item()}>
          {entry.label}
          <SelectItemIndicator className="flex text-(color:--fd-input-color-accent)">
            <Icon name="confirm" size="sm" />
          </SelectItemIndicator>
        </SelectItem>
      ))}
    </SelectContent>
  );
}
