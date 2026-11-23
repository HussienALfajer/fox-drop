import { Select as SdkSelect, SelectTrigger, SelectValue } from '@ui-sdk/react/select';
import { Field } from '../field/field';
import { box, boxState, formTv, type Density } from '../field/styles';
import { Icon } from '../icon/icon';
import { Menu, type MenuItem } from './menu';

/** The states the stories show (R3). Hover and focus are driven in the browser by the gate. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'open',
  'filled',
  'invalid',
  'disabled',
  'compact',
] as const;

const trigger = formTv({
  extend: box,
  base: 'w-full cursor-pointer text-start outline-hidden data-open:inset-ring-(length:--fd-input-focus-width) data-open:inset-ring-(color:--fd-input-color-border-focus)',
});

const value = formTv({
  base: 'min-w-none flex-1 truncate data-placeholder:text-(color:--fd-input-color-placeholder)',
});

const chevron = formTv({
  base: 'flex shrink-0 transition-transform duration-(--fd-duration-base) ease-(--fd-easing-standard) group-data-open:rotate-180',
});

export interface SelectProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  /** What the trigger shows while nothing is chosen. */
  placeholder?: string;
  /** The options; the label is what the trigger shows and what typing finds. */
  items: readonly { value: string; label: string; disabled?: boolean }[];
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  required?: boolean;
  disabled?: boolean;
  density?: Density;
}

/**
 * A single choice from a list, on the UI SDK's Select: a pill trigger with a
 * chevron, a popup listbox, arrow keys, and type-ahead on the trigger.
 */
export function Select(props: SelectProps) {
  const { label, optionalLabel, hint, error, placeholder, items, density } = props;
  const { value: selected, defaultValue, onValueChange, name, required, disabled } = props;
  const list: MenuItem[] = items.map(({ value: itemValue, label: itemLabel, disabled: off }) => ({
    value: itemValue,
    label: itemLabel,
    ...(off && { disabled: true }),
  }));
  return (
    <Field
      label={label}
      {...(optionalLabel && { optionalLabel })}
      {...(hint && { hint })}
      {...(error && { error })}
      {...(disabled && { disabled })}
      {...(name && { name })}
      {...(density && { density })}
    >
      <SdkSelect
        items={items.map((entry) => ({ ...entry }))}
        {...(placeholder && { placeholder })}
        {...(selected !== undefined && { value: selected })}
        {...(defaultValue !== undefined && { defaultValue })}
        {...(onValueChange && {
          onValueChange: (next: string | null) => {
            if (next !== null) onValueChange(next);
          },
        })}
        {...(required && { required })}
      >
        <SelectTrigger
          className={trigger({
            density,
            state: boxState(disabled, !!error),
            class: 'group',
          })}
        >
          <SelectValue className={value()} />
          <span className={chevron()}>
            <Icon name="chevron-down" size={density === 'compact' ? 'sm' : 'md'} />
          </span>
        </SelectTrigger>
        <Menu items={list} />
      </SdkSelect>
    </Field>
  );
}
