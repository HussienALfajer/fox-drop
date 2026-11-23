import { Button as SdkButton } from '@ui-sdk/react/button';
import { useState } from 'react';
import { formTv } from '../field/styles';
import { Icon } from '../icon/icon';

/** The states the stories show (R3). Hover, focus and pressed are driven in the browser by the gate. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'pressed',
  'minimum',
  'maximum',
  'disabled',
] as const;

// Two circles 32 in 48 targets bridged by a concave strip, as the cart in the
// Figma file draws it (`stepper()` in design-tokens `src/forms-sheet.ts`). The
// strip is drawn behind the three cells (48, 48, 48); «+» comes first, so it is
// at the start of the line (right in RTL).
const root = formTv({ base: 'relative inline-flex items-center' });

const pressable = formTv({
  base: 'group relative flex size-(--fd-input-stepper-target) shrink-0 cursor-pointer items-center justify-center rounded-full outline-hidden data-disabled:cursor-not-allowed',
});

const circle = formTv({
  base: [
    'flex size-(--fd-input-stepper-size) items-center justify-center rounded-full',
    'bg-(--fd-input-stepper-color-background) text-(color:--fd-input-stepper-color-border)',
    'inset-ring-(length:--fd-input-focus-width) inset-ring-(color:--fd-input-stepper-color-border)',
    'transition-colors duration-(--fd-duration-fast) ease-(--fd-easing-standard)',
    'group-active:bg-(--fd-input-stepper-color-background-pressed)',
    'group-focus-visible:ring-2 group-focus-visible:ring-(color:--fd-input-color-focus-ring) group-focus-visible:ring-offset-2 group-focus-visible:ring-offset-surface',
    'group-data-disabled:bg-(--fd-input-stepper-color-background) group-data-disabled:text-(color:--fd-input-color-on-disabled) group-data-disabled:inset-ring-(color:--fd-input-color-on-disabled)',
  ],
});

const value = formTv({
  base: 'relative w-(--fd-space-2xl) text-center text-phone-subtitle font-bold tabular-nums text-(color:--fd-input-stepper-color-value)',
  variants: { disabled: { true: 'text-(color:--fd-input-color-on-disabled)' } },
});

export interface QuantityStepperProps {
  /** The accessible name of the group, with the count: «الكمية 2». The app writes and translates it. */
  label: string;
  /** The names of the two buttons: «زيادة», «تقليل». */
  increaseLabel: string;
  decreaseLabel: string;
  /** The name of the «−» button when it removes the line: «حذف». */
  removeLabel?: string;
  value?: number;
  defaultValue?: number;
  onValueChange?: (value: number) => void;
  /** Pressing «−» at the minimum: the button then shows the delete icon. Without it, «−» is off at the minimum. */
  onRemove?: () => void;
  /** Default 1. */
  min?: number;
  max?: number;
  disabled?: boolean;
}

/** The count of a cart line: «+», the number, «−»; at the minimum «−» becomes delete. */
export function QuantityStepper(props: QuantityStepperProps) {
  const { label, increaseLabel, decreaseLabel, removeLabel, onValueChange, onRemove } = props;
  const { min = 1, max, disabled = false } = props;
  const [own, setOwn] = useState(props.defaultValue ?? min);
  const count = props.value ?? own;
  const atMin = count <= min;
  const atMax = max !== undefined && count >= max;
  const removes = atMin && onRemove !== undefined && removeLabel !== undefined;
  const set = (next: number) => {
    setOwn(next);
    onValueChange?.(next);
  };
  return (
    <div
      role="group"
      aria-label={label}
      className={root()}
    >
      <svg
        viewBox="0 0 144 48"
        width="144"
        height="48"
        aria-hidden="true"
        className="absolute inset-none size-full fill-(--fd-input-stepper-color-background)"
      >
        <path d="M34.25 8H109.75A19 19 0 0 0 109.75 40H34.25A19 19 0 0 0 34.25 8Z" />
      </svg>
      <SdkButton
        aria-label={increaseLabel}
        disabled={disabled || atMax}
        focusableWhenDisabled
        onClick={() => set(count + 1)}
        className={pressable()}
      >
        <span className={circle()}>
          <Icon name="add" size="sm" />
        </span>
      </SdkButton>
      <output aria-live="polite" className={value({ disabled })}>
        {count}
      </output>
      <SdkButton
        aria-label={removes ? removeLabel : decreaseLabel}
        disabled={disabled || (atMin && !removes)}
        focusableWhenDisabled
        onClick={() => (atMin ? onRemove?.() : set(count - 1))}
        className={pressable()}
      >
        <span className={circle()}>
          <Icon name={removes ? 'delete' : 'remove'} size="sm" />
        </span>
      </SdkButton>
    </div>
  );
}
