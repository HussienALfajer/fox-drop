import { Radio, RadioGroup as SdkRadioGroup, RadioIndicator } from '@ui-sdk/react/radio';
import { Field } from '../field/field';
import { formTv, keyboardRing } from '../field/styles';

/** The states the stories show (R3). Hover, focus and pressed are driven in the browser by the gate. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'pressed',
  'selected',
  'invalid',
  'disabled',
] as const;

const row = formTv({
  base: 'group/row -ms-sm inline-flex min-h-(--fd-input-check-target) items-center gap-2xs text-phone-body',
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

const circle = formTv({
  base: [
    'flex size-(--fd-input-check-size) items-center justify-center rounded-full',
    'inset-ring-(length:--fd-input-check-border-width) transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    keyboardRing,
    'data-unchecked:bg-(--fd-input-check-color-background)',
    'data-checked:inset-ring-(color:--fd-input-check-color-checked)',
    'data-disabled:bg-(--fd-input-color-disabled) data-disabled:inset-ring-(color:--fd-input-color-on-disabled)',
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
        'group-hover/row:data-checked:inset-ring-(color:--fd-input-check-color-checked-hover)',
        'group-active/row:data-checked:inset-ring-(color:--fd-input-check-color-checked-pressed)',
      ],
    },
  },
});

const dot = formTv({
  base: [
    'size-sm rounded-full bg-(--fd-input-check-color-checked)',
    'group-hover/row:bg-(--fd-input-check-color-checked-hover) group-active/row:bg-(--fd-input-check-color-checked-pressed)',
    'in-data-disabled:bg-(--fd-input-color-on-disabled)',
  ],
});

export interface RadioOption {
  value: string;
  label: string;
  disabled?: boolean;
}

export interface RadioGroupProps {
  /** The visible name of the question, above the options. */
  label: string;
  optionalLabel?: string;
  hint?: string;
  /** An error under the group turns every unselected outline red. */
  error?: string;
  options: readonly RadioOption[];
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  required?: boolean;
  disabled?: boolean;
}

/**
 * One choice from a short list, on the UI SDK's RadioGroup (one tab stop, arrow
 * keys between the options). Each option is a circle 24 in a 48 target and the
 * whole row with its label is the target.
 */
export function RadioGroup(props: RadioGroupProps) {
  const { label, optionalLabel, hint, error, options, value, defaultValue, onValueChange } = props;
  const { name, required, disabled = false } = props;
  return (
    <Field
      label={label}
      {...(optionalLabel && { optionalLabel })}
      {...(hint && { hint })}
      {...(error && { error })}
      {...(disabled && { disabled })}
      {...(name && { name })}
    >
      <SdkRadioGroup
        className="flex flex-col"
        {...(value !== undefined && { value })}
        {...(defaultValue !== undefined && { defaultValue })}
        {...(onValueChange && {
          onValueChange: (next: string | null) => {
            if (next !== null) onValueChange(next);
          },
        })}
        {...(required && { required })}
        {...(disabled && { disabled })}
      >
        {options.map((option) => {
          const off = disabled || option.disabled === true;
          return (
            <label key={option.value} className={row({ disabled: off })}>
              <span className={target()}>
                <Radio
                  value={option.value}
                  className={circle({ invalid: !!error, interactive: !off })}
                  {...(option.disabled && { disabled: true })}
                >
                  <RadioIndicator className="flex">
                    <span className={dot()} />
                  </RadioIndicator>
                </Radio>
              </span>
              {option.label}
            </label>
          );
        })}
      </SdkRadioGroup>
    </Field>
  );
}
