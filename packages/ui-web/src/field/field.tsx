import { Field as SdkField, FieldDescription, FieldError, FieldLabel } from '@ui-sdk/react/field';
import type { ReactNode } from 'react';
import { Icon } from '../icon/icon';
import { formTv, type Density } from './styles';

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

const field = formTv({
  slots: {
    root: 'flex flex-col gap-(--fd-input-label-gap)',
    label: 'font-medium text-(color:--fd-input-color-label)',
    optional: 'font-regular text-(color:--fd-input-color-hint)',
    below: 'flex items-start justify-between gap-(--fd-input-gap)',
    hint: 'text-(color:--fd-input-color-hint)',
    error: 'flex items-center gap-2xs text-(color:--fd-input-color-error)',
  },
  variants: {
    density: {
      comfortable: {
        label: 'text-phone-secondary',
        optional: 'text-phone-secondary',
        hint: 'text-phone-caption',
        error: 'text-phone-caption',
      },
      compact: {
        label: 'text-panel-secondary',
        optional: 'text-panel-secondary',
        hint: 'text-panel-caption',
        error: 'text-panel-caption',
      },
    },
    disabled: { true: { label: 'text-(color:--fd-input-color-on-disabled)' } },
  },
  defaultVariants: { density: 'comfortable' },
});

export interface FieldProps {
  /** The visible label, above the control; it names the control. */
  label: string;
  /** The text that marks an optional field, «(اختياري)» in Arabic; there is no required star. */
  optionalLabel?: string;
  /** Help below the control; the error replaces it. */
  hint?: string;
  /** The error below the control, with its icon; it describes the control (`aria-describedby`). */
  error?: string;
  /** Something at the end of the line below, like a character counter. */
  aside?: ReactNode;
  disabled?: boolean;
  name?: string;
  density?: Density;
  /** The control: a `TextField`'s input, a select, a code field. */
  children: ReactNode;
}

/**
 * The wrapper of a form control (architecture §9.5): a label above, a hint or
 * an error below, wired to the control by the UI SDK's Field (`for`, `id`,
 * `aria-describedby`, `aria-invalid`).
 */
export function Field(props: FieldProps) {
  const { label, optionalLabel, hint, error, aside, disabled, name, density, children } = props;
  const parts = field({ density, disabled });
  const message = error ? (
    <FieldError match className={parts.error()}>
      <Icon name="error" size="sm" />
      {error}
    </FieldError>
  ) : hint ? (
    <FieldDescription className={parts.hint()}>{hint}</FieldDescription>
  ) : null;
  return (
    <SdkField
      {...(name !== undefined && { name })}
      {...(disabled && { disabled })}
      {...(error && { invalid: true })}
      className={parts.root()}
    >
      <FieldLabel className={parts.label()}>
        {label}
        {optionalLabel && <span className={parts.optional()}> {optionalLabel}</span>}
      </FieldLabel>
      {children}
      {(message || aside) && (
        <div className={parts.below()}>
          {message}
          {aside}
        </div>
      )}
    </SdkField>
  );
}
