import { Button as SdkButton } from '@ui-sdk/react/button';
import { useId, useState } from 'react';
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

// An SVG path cannot read a CSS variable, so the strip is derived from these
// two numbers, which a test keeps equal to `--fd-input-stepper-size` and
// `--fd-input-stepper-target`. The strip is the circle's height, three cells
// wide, and each end is an arc of the ring around the neighbouring circle
// (its radius is the circle's plus the 3 gap the drawing leaves).
export const STEPPER_SIZE = 32;
export const STEPPER_TARGET = 48;
const BRIDGE_GAP = 3;

/** The concave strip between the two circles, in a viewBox of three targets by one. */
export function bridgePath(size: number, target: number): string {
  const ring = size / 2 + BRIDGE_GAP;
  const top = (target - size) / 2;
  const bottom = top + size;
  const reach = Math.round(Math.sqrt(ring * ring - (size / 2) ** 2) * 4) / 4;
  const end = target * 2.5 - reach;
  const start = target / 2 + reach;
  return `M${start} ${top}H${end}A${ring} ${ring} 0 0 0 ${end} ${bottom}H${start}A${ring} ${ring} 0 0 0 ${start} ${top}Z`;
}

const pressable = formTv({
  base: 'group relative flex size-(--fd-input-stepper-target) shrink-0 cursor-pointer items-center justify-center rounded-full outline-hidden data-disabled:cursor-not-allowed',
});

const circle = formTv({
  base: [
    'flex size-(--fd-input-stepper-size) items-center justify-center rounded-full',
    'bg-(--fd-input-stepper-color-background) text-(color:--fd-input-stepper-color-border)',
    'inset-ring-(length:--fd-input-focus-width) inset-ring-(color:--fd-input-stepper-color-border)',
    'transition-colors duration-(--fd-duration-fast) ease-(--fd-easing-standard)',
    'group-hover:bg-(--fd-input-stepper-color-background-hover)',
    'group-active:bg-(--fd-input-stepper-color-background-pressed)',
    'group-focus-visible:ring-2 group-focus-visible:ring-(color:--fd-input-color-focus-ring) group-focus-visible:ring-offset-2 group-focus-visible:ring-offset-surface',
    'group-data-disabled:bg-(--fd-input-stepper-color-background) group-data-disabled:text-(color:--fd-input-color-on-disabled) group-data-disabled:inset-ring-(color:--fd-input-color-on-disabled)',
  ],
});

const value = formTv({
  base: 'relative w-2xl text-center text-phone-subtitle font-bold tabular-nums text-(color:--fd-input-stepper-color-value)',
  variants: { disabled: { true: 'text-(color:--fd-input-color-on-disabled)' } },
});

export interface QuantityStepperProps {
  /** The accessible name of the group, the noun only: «الكمية». The count is its description, so the app does not rebuild the label per count. */
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
  const countId = useId();
  const [own, setOwn] = useState(props.defaultValue ?? min);
  const count = props.value ?? own;
  const atMin = count <= min;
  const atMax = max !== undefined && count >= max;
  const removes = atMin && onRemove !== undefined && removeLabel !== undefined;
  const set = (next: number) => {
    setOwn(next);
    onValueChange?.(next);
  };
  const viewBox = `0 0 ${STEPPER_TARGET * 3} ${STEPPER_TARGET}`;
  return (
    <div role="group" aria-label={label} aria-describedby={countId} className={root()}>
      <svg
        viewBox={viewBox}
        width={STEPPER_TARGET * 3}
        height={STEPPER_TARGET}
        aria-hidden="true"
        className="absolute inset-none size-full fill-(--fd-input-stepper-color-background)"
      >
        <path d={bridgePath(STEPPER_SIZE, STEPPER_TARGET)} />
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
        <span id={countId}>{count}</span>
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
