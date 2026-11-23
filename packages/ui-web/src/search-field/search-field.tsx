import { Input, InputClear } from '@ui-sdk/react/input';
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

const clear = formTv({
  base: [
    'flex shrink-0 cursor-pointer items-center justify-center rounded-full',
    'size-(--fd-size-icon-lg) text-(color:--fd-input-color-text)',
    'transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    'hover:bg-surface-raised-hover active:bg-surface-raised-pressed',
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
  /** A spinner replaces the clear button while results load; typing keeps working. */
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
          <svg
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth={2.5}
            strokeLinecap="round"
            aria-hidden="true"
            className="size-(--fd-size-icon-md) shrink-0 animate-spin text-(color:--fd-input-color-accent) motion-reduce:animate-none"
          >
            <path d="M12 3a9 9 0 1 0 9 9" />
          </svg>
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
