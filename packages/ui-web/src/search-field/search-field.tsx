import { Input, InputClear } from '@ui-sdk/react/input';
import { DropLoader } from '../drop-loader/drop-loader';
import { Icon } from '../icon/icon';
import { InputBox } from '../field/input-box';
import { formTv, inputClass, keyboardRing, type Density } from '../field/styles';

/** The states the stories show (R3). Hover and focus are driven in the browser by the gate. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'filled',
  'loading',
  'disabled',
  'compact',
] as const;

const lens = formTv({
  base: 'flex shrink-0 text-(color:--fd-input-color-accent)',
  variants: { disabled: { true: 'text-(color:--fd-input-color-on-disabled)' } },
});

// The D.8 sheet's clear button: a 32 circle on `surface` at rest.
const clear = formTv({
  base: [
    'flex shrink-0 cursor-pointer items-center justify-center rounded-full',
    'size-(--fd-input-clear-size) text-(color:--fd-input-clear-color-icon)',
    'bg-(--fd-input-clear-color-background) hover:bg-(--fd-input-clear-color-background-hover) active:bg-(--fd-input-clear-color-background-pressed)',
    'transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    keyboardRing,
  ],
});

export interface SearchFieldProps {
  /** The accessible name of the field (there is no visible label): «ابحث عن مطعم». */
  label: string;
  /** The accessible name of the clear button: «مسح». */
  clearLabel: string;
  placeholder?: string;
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  /** The drop loader replaces the clear button while results load; typing keeps working. */
  loading?: boolean;
  disabled?: boolean;
  density?: Density;
}

/**
 * A search pill with the brand-orange lens at the start and a clear button at
 * the end while there is text (the Figma search idea, architecture §9.5).
 */
export function SearchField(props: SearchFieldProps) {
  const { label, clearLabel, placeholder, value, defaultValue, name, loading, disabled } = props;
  const { density, onValueChange } = props;
  const iconSize = density === 'compact' ? 'sm' : 'md';
  return (
    <InputBox
      {...(density && { density })}
      {...(disabled && { disabled })}
      start={
        <span className={lens({ disabled })}>
          <Icon name="search" size={iconSize} />
        </span>
      }
      end={
        loading ? (
          <DropLoader size={iconSize} />
        ) : (
          <InputClear aria-label={clearLabel} className={clear()}>
            <Icon name="close" size="sm" />
          </InputClear>
        )
      }
    >
      <Input
        // Not `type="search"`: the browsers draw their own clear cross on it.
        role="searchbox"
        inputMode="search"
        enterKeyHint="search"
        aria-label={label}
        className={inputClass()}
        {...(loading && { 'aria-busy': true })}
        {...(placeholder && { placeholder })}
        {...(value !== undefined && { value })}
        {...(defaultValue !== undefined && { defaultValue })}
        {...(name && { name })}
        {...(disabled && { disabled })}
        {...(onValueChange && { onValueChange: (next: string) => onValueChange(next) })}
      />
    </InputBox>
  );
}
