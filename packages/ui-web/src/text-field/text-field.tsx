import { Input } from '@ui-sdk/react/input';
import { Field } from '../field/field';
import { InputBox } from '../field/input-box';
import { inputClass, type Density } from '../field/styles';

/** The states the stories show (R3). Hover and focus are driven in the browser by the gate. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'filled',
  'invalid',
  'disabled',
  'comfortable',
  'compact',
] as const;

export interface TextFieldProps {
  /** The visible label, above the field. */
  label: string;
  /** «(اختياري)» for an optional field; there is no required star. */
  optionalLabel?: string;
  hint?: string;
  /** An error replaces the hint and turns the outline red. */
  error?: string;
  placeholder?: string;
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  type?: 'text' | 'email' | 'url' | 'password';
  inputMode?: 'text' | 'email' | 'url' | 'numeric' | 'decimal' | 'search';
  autoComplete?: string;
  maxLength?: number;
  required?: boolean;
  disabled?: boolean;
  /** `comfortable` is 50 high (phones); `compact` is 40, for the admin panel and the restaurant portal. */
  density?: Density;
}

/** A single-line text field: a pill with its label, hint and error (architecture §9.5). */
export function TextField(props: TextFieldProps) {
  const { label, optionalLabel, hint, error, density, disabled, name, onValueChange } = props;
  const { placeholder, value, defaultValue, type, inputMode, autoComplete, maxLength, required } =
    props;
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
      <InputBox
        {...(density && { density })}
        {...(disabled && { disabled })}
        {...(error && { invalid: true })}
      >
        <Input
          className={inputClass()}
          {...(placeholder && { placeholder })}
          {...(value !== undefined && { value })}
          {...(defaultValue !== undefined && { defaultValue })}
          {...(onValueChange && { onValueChange: (next: string) => onValueChange(next) })}
          {...(type && { type })}
          {...(inputMode && { inputMode })}
          {...(autoComplete && { autoComplete })}
          {...(maxLength !== undefined && { maxLength })}
          {...(required && { required })}
        />
      </InputBox>
    </Field>
  );
}
