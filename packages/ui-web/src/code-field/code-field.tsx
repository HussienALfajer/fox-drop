import { OTPInput, OTPInputGroup, OTPInputSlot } from '@ui-sdk/react/otp-input';
import { useEffect, useRef, useState } from 'react';
import { Field } from '../field/field';
import { formTv } from '../field/styles';
import { digitsOf } from '../phone-field/phone';

/** Arabic-Indic (٠-٩) and Persian (۰-۹) digits. */
const NON_WESTERN = /[٠-٩۰-۹]/;

/** The states the stories show (R3). Focus is driven in the browser by the gate. */
export const STATES = ['default', 'focus', 'typing', 'invalid', 'done', 'disabled'] as const;

/** The sign-in code has six digits in every app (CU §5.2, Q4). */
export const CODE_LENGTH = 6;

const group = formTv({
  base: 'flex gap-(--fd-input-gap) transition-all duration-(--fd-duration-moment) ease-(--fd-easing-standard)',
  // Success: the circles fuse for `duration.moment`, still under reduced motion.
  variants: { done: { true: 'gap-none' } },
});

const slot = formTv({
  base: [
    'relative flex size-(--fd-input-code-size) items-center justify-center rounded-full tabular-nums',
    'text-phone-title transition-colors duration-(--fd-duration-moment) ease-(--fd-easing-standard)',
  ],
  variants: {
    state: {
      rest: [
        'bg-(--fd-input-color-background) text-(color:--fd-input-color-text)',
        'inset-ring-(length:--fd-input-border-width) inset-ring-(color:--fd-input-color-border)',
        'data-active:inset-ring-(length:--fd-input-focus-width) data-active:inset-ring-(color:--fd-input-color-border-focus)',
      ],
      invalid: [
        'bg-(--fd-input-color-background) text-(color:--fd-input-color-text)',
        'inset-ring-(length:--fd-input-focus-width) inset-ring-(color:--fd-input-color-border-invalid)',
        // The cell the next digit goes into keeps the focus colour.
        'data-active:inset-ring-(color:--fd-input-color-border-focus)',
      ],
      done: 'bg-(--fd-input-code-color-done) text-(color:--fd-input-code-color-on-done)',
      disabled:
        'cursor-not-allowed bg-(--fd-input-color-disabled) text-(color:--fd-input-color-on-disabled)',
    },
  },
});

export interface CodeFieldProps {
  /** The visible label, above the cells: «رمز التحقق». */
  label: string;
  hint?: string;
  /** An error turns every cell's outline red. */
  error?: string;
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  /** Called once with the whole code when the last cell is filled. */
  onComplete?: (value: string) => void;
  /** The code was accepted: the cells fill with the brand orange and fuse. */
  done?: boolean;
  name?: string;
  autoFocus?: boolean;
  disabled?: boolean;
}

/**
 * The sign-in code (architecture §8.3.4): six 48 circles, always left to right,
 * over one real input, so paste and the phone's one-time-code autofill work.
 */
export function CodeField(props: CodeFieldProps) {
  const { label, hint, error, value, defaultValue, onValueChange, onComplete } = props;
  const { done, name, autoFocus, disabled } = props;
  const state = disabled ? 'disabled' : done ? 'done' : error ? 'invalid' : 'rest';
  const [own, setOwn] = useState(defaultValue ?? '');
  const current = value ?? own;
  const wrapper = useRef<HTMLSpanElement>(null);
  const latest = useRef({ current, onValueChange, onComplete });
  useEffect(() => {
    latest.current = { current, onValueChange, onComplete };
  });

  // The SDK keeps only 0-9. Arabic-Indic and Persian digits (the phone's Arabic
  // keyboard, a pasted code) are turned into Western digits first (AP §4.7).
  const insert = (text: string, target: EventTarget | null) => {
    const typed = digitsOf(text);
    if (typed === '') return;
    const old = latest.current.current;
    const input = target instanceof HTMLInputElement ? target : null;
    const start = input?.selectionStart ?? old.length;
    const end = input?.selectionEnd ?? old.length;
    // A full code is replaced (the SDK keeps the last cell selected, so the
    // caret cannot tell); a shorter one takes the digits at the caret or over the selection.
    const replaces = old.length >= CODE_LENGTH;
    const next = replaces
      ? typed.slice(0, CODE_LENGTH)
      : (old.slice(0, start) + typed + old.slice(end)).slice(0, CODE_LENGTH);
    setOwn(next);
    latest.current.onValueChange?.(next);
    if (next.length === CODE_LENGTH && next !== latest.current.current) {
      latest.current.onComplete?.(next);
    }
  };
  useEffect(() => {
    const node = wrapper.current;
    if (!node) return;
    const beforeInput = (event: Event) => {
      const data = (event as InputEvent).data;
      if (data && NON_WESTERN.test(data)) {
        event.preventDefault();
        insert(data, event.target);
      }
    };
    node.addEventListener('beforeinput', beforeInput);
    return () => node.removeEventListener('beforeinput', beforeInput);
  }, []);

  return (
    <Field
      label={label}
      {...(hint && { hint })}
      {...(error && { error })}
      {...(disabled && { disabled })}
      {...(name && { name })}
    >
      <span
        ref={wrapper}
        className="contents"
        onPasteCapture={(event) => {
          const text = event.clipboardData.getData('text');
          if (NON_WESTERN.test(text)) {
            event.preventDefault();
            insert(text, event.target);
          }
        }}
      >
        <OTPInput
          maxLength={CODE_LENGTH}
          pattern="digits"
          inputMode="numeric"
          autoComplete="one-time-code"
          textAlign="start"
          value={current}
          onValueChange={(next: string) => {
            setOwn(next);
            onValueChange?.(next);
          }}
          {...(onComplete && { onValueCommit: (next: string) => onComplete(next) })}
          {...(autoFocus && { autoFocus })}
          {...(disabled && { disabled })}
          {...(error && { 'aria-invalid': true })}
          dir="ltr"
          className="relative inline-flex self-start"
        >
          <OTPInputGroup className={group({ done: done && !disabled })}>
            {Array.from({ length: CODE_LENGTH }, (_, index) => (
              <OTPInputSlot key={index} index={index} className={slot({ state })}>
                {(slotState) => (
                  <>
                    {slotState.char}
                    {slotState.hasFakeCaret && (
                      <span className="absolute h-(--fd-size-icon-md) w-(--fd-input-focus-width) animate-pulse bg-(--fd-input-color-accent) motion-reduce:animate-none" />
                    )}
                  </>
                )}
              </OTPInputSlot>
            ))}
          </OTPInputGroup>
        </OTPInput>
      </span>
    </Field>
  );
}
