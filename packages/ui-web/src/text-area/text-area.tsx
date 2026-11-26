import { Textarea } from '@ui-sdk/react/textarea';
import { useLayoutEffect, useRef, useState } from 'react';
import { Field } from '../field/field';
import { InputBox } from '../field/input-box';
import { formTv, inputClass } from '../field/styles';

/** The states the stories show (R3). Hover and focus are driven in the browser by the gate. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'filled',
  'invalid',
  'disabled',
  'counter',
] as const;

/** The lines the area shows at rest and the most it grows to before it scrolls. */
export const MIN_LINES = 3;
export const MAX_LINES = 6;

const area = formTv({
  base: [inputClass(), 'resize-none py-(--fd-input-area-padding-block)'],
});

// At the end of the line below, with or without a hint (the D.8 sheet).
const counter = formTv({
  base: 'ms-auto shrink-0 text-phone-caption text-(color:--fd-input-color-hint) tabular-nums',
  variants: { full: { true: 'text-(color:--fd-input-color-error)' } },
});

export interface TextAreaProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  placeholder?: string;
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  /** Shows «n/max» below the field and stops typing at `max`. */
  maxLength?: number;
  required?: boolean;
  disabled?: boolean;
}

/**
 * Long text: a box with the radius `input.area-radius`, three lines at rest
 * that grow to six and then scroll; the characters count at the end of the
 * line below when there is a limit.
 */
export function TextArea(props: TextAreaProps) {
  const { label, optionalLabel, hint, error, disabled, name, onValueChange } = props;
  const { placeholder, value, defaultValue, maxLength, required } = props;
  const [typed, setTyped] = useState(defaultValue ?? '');
  const text = value ?? typed;
  const ref = useRef<HTMLTextAreaElement>(null);
  const [lines, setLines] = useState(MIN_LINES);

  // Grow by whole lines: measure with the minimum, add a line while the text
  // still overflows. Only the `rows` attribute changes (no inline style).
  useLayoutEffect(() => {
    const element = ref.current;
    if (!element) return;
    let rows = MIN_LINES;
    element.rows = rows;
    while (rows < MAX_LINES && element.scrollHeight > element.clientHeight) {
      rows += 1;
      element.rows = rows;
    }
    setLines(rows);
  }, [text]);

  const counterText = `${text.length}/${maxLength}`;
  return (
    <Field
      label={label}
      {...(optionalLabel && { optionalLabel })}
      {...(hint && { hint })}
      {...(error && { error })}
      {...(disabled && { disabled })}
      {...(name && { name })}
      {...(maxLength !== undefined && {
        aside: (
          <span dir="ltr" className={counter({ full: text.length >= maxLength })}>
            {counterText}
          </span>
        ),
      })}
    >
      <InputBox shape="area" {...(disabled && { disabled })} {...(error && { invalid: true })}>
        <Textarea
          ref={ref}
          rows={lines}
          className={area()}
          {...(placeholder && { placeholder })}
          {...(value !== undefined && { value })}
          {...(defaultValue !== undefined && { defaultValue })}
          onValueChange={(next: string) => {
            setTyped(next);
            onValueChange?.(next);
          }}
          {...(maxLength !== undefined && { maxLength })}
          {...(required && { required })}
        />
      </InputBox>
    </Field>
  );
}
