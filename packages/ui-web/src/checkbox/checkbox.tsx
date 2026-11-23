import { Checkbox as SdkCheckbox, CheckboxIndicator } from '@ui-sdk/react/checkbox';
import { formTv, keyboardRing } from '../field/styles';
import { Icon } from '../icon/icon';

/** The states the stories show (R3). Hover, focus and pressed are driven in the browser by the gate. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'pressed',
  'checked',
  'mixed',
  'invalid',
  'disabled',
] as const;

// The row is the target: the 24 box inside a 48 square, and the label beside
// it, all one `<label>` (architecture §9.5). `-ms-sm` lines the box up with
// the edge of the column, as on the sheet.
const row = formTv({
  base: 'group/row -ms-sm inline-flex min-h-(--fd-input-check-target) items-center gap-(--fd-space-2xs) text-phone-body',
  variants: {
    disabled: {
      true: 'cursor-not-allowed text-(color:--fd-input-color-on-disabled)',
      false: 'cursor-pointer text-(color:--fd-input-color-text)',
    },
  },
});

const target = formTv({
  base: 'flex size-(--fd-input-check-target) shrink-0 items-center justify-center',
});

const control = formTv({
  base: [
    'flex size-(--fd-input-check-size) items-center justify-center rounded-(--fd-input-check-radius)',
    'inset-ring-(length:--fd-input-check-border-width) transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    'text-(color:--fd-input-check-color-mark)',
    keyboardRing,
    // checked and mixed: the brand orange and the mark
    'data-checked:bg-(--fd-input-check-color-checked) data-checked:inset-ring-(color:--fd-input-check-color-checked)',
    'data-indeterminate:bg-(--fd-input-check-color-checked) data-indeterminate:inset-ring-(color:--fd-input-check-color-checked)',
    // unchecked
    'data-unchecked:bg-(--fd-input-check-color-background)',
    // disabled beats everything
    'data-disabled:bg-(--fd-input-color-disabled) data-disabled:inset-ring-(color:--fd-input-color-on-disabled) data-disabled:text-(color:--fd-input-color-on-disabled)',
  ],
  variants: {
    invalid: {
      true: 'data-unchecked:inset-ring-(color:--fd-input-color-border-invalid)',
      false: 'data-unchecked:inset-ring-(color:--fd-input-check-color-border)',
    },
    interactive: {
      true: [
        'group-hover/row:data-unchecked:bg-(--fd-input-check-color-background-hover) group-hover/row:data-unchecked:inset-ring-(color:--fd-input-check-color-border-hover)',
        'group-active/row:data-unchecked:bg-(--fd-input-check-color-background-pressed)',
        'group-hover/row:data-checked:bg-(--fd-input-check-color-checked-hover) group-hover/row:data-checked:inset-ring-(color:--fd-input-check-color-checked-hover)',
        'group-active/row:data-checked:bg-(--fd-input-check-color-checked-pressed) group-active/row:data-checked:inset-ring-(color:--fd-input-check-color-checked-pressed)',
        'group-hover/row:data-indeterminate:bg-(--fd-input-check-color-checked-hover) group-hover/row:data-indeterminate:inset-ring-(color:--fd-input-check-color-checked-hover)',
        'group-active/row:data-indeterminate:bg-(--fd-input-check-color-checked-pressed) group-active/row:data-indeterminate:inset-ring-(color:--fd-input-check-color-checked-pressed)',
      ],
    },
  },
});

export interface CheckboxProps {
  /** The text beside the box; the whole row is the target. */
  label: string;
  /** `'indeterminate'` is the mixed state of a parent whose children are partly checked. */
  checked?: boolean | 'indeterminate';
  defaultChecked?: boolean | 'indeterminate';
  /** A press on a mixed box reports `true`. */
  onCheckedChange?: (checked: boolean) => void;
  name?: string;
  value?: string;
  required?: boolean;
  disabled?: boolean;
  /** The box outline turns red: something is wrong with this answer. */
  invalid?: boolean;
}

/** A checkbox with its label: a soft square (radius 8) 24 in a 48 target, on the UI SDK's Checkbox. */
export function Checkbox(props: CheckboxProps) {
  const { label, checked, defaultChecked, onCheckedChange, name, value, required } = props;
  const { disabled = false, invalid = false } = props;
  return (
    <label className={row({ disabled })}>
      <span className={target()}>
        <SdkCheckbox
          className={control({ invalid, interactive: !disabled })}
          {...(checked !== undefined && { checked })}
          {...(defaultChecked !== undefined && { defaultChecked })}
          {...(onCheckedChange && {
            onCheckedChange: (next: boolean | 'indeterminate') => onCheckedChange(next === true),
          })}
          {...(name && { name })}
          {...(value && { value })}
          {...(required && { required })}
          {...(disabled && { disabled })}
          {...(invalid && { 'aria-invalid': true })}
        >
          <CheckboxIndicator className="flex">
            {(state) => <Icon name={state.indeterminate ? 'remove' : 'confirm'} size="sm" />}
          </CheckboxIndicator>
        </SdkCheckbox>
      </span>
      {label}
    </label>
  );
}
