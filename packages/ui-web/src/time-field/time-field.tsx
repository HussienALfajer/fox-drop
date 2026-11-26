import { TimeInput, TimeInputSegment } from '@ui-sdk/react/time-input';
import { box, boxState, formTv } from '../field/styles';
import { Field } from '../field/field';
import { Icon } from '../icon/icon';
import { LOCALE } from '../date-field/date-field';

/** The states the stories show (R3), as the Flutter twin's. */
export const STATES = ['default', 'hover', 'focus', 'filled', 'invalid', 'disabled'] as const;

const segment = formTv({
  base: [
    // As wide as its text, so the run reads `03:05 م` as the Flutter twin's.
    'field-sizing-content rounded-xs bg-transparent text-center outline-hidden',
    'focus:bg-(--fd-date-field-color-segment) data-empty:text-(color:--fd-input-color-placeholder)',
    'disabled:cursor-not-allowed disabled:text-(color:--fd-input-color-on-disabled)',
  ],
});

export interface TimeFieldProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  /** The time as `HH:mm` (24-hour), or null, controlled. */
  value?: string | null;
  defaultValue?: string | null;
  onValueChange?: (value: string | null) => void;
  name?: string;
  required?: boolean;
  disabled?: boolean;
}

type Segment = { key: string; type: string };

/**
 * A time of day (D.8), on the UI SDK's TimeInput: the pill with a clock icon
 * at the start, then the hour, the minute and «ص» or «م», each typed in its
 * own box (the Flutter twin's typed-in mode, AP §4.7), 12-hour with Western
 * digits. The digits read left to right as one run and «ص»/«م» follows
 * them, to their left. The arrows step a box; digits fill it.
 */
export function TimeField(props: TimeFieldProps) {
  const { label, optionalLabel, hint, error, value, defaultValue, onValueChange } = props;
  const { name, required, disabled } = props;
  return (
    <Field
      label={label}
      {...(optionalLabel && { optionalLabel })}
      {...(hint && { hint })}
      {...(error && { error })}
      {...(disabled && { disabled })}
      {...(name && { name })}
    >
      <div className={box({ state: boxState(disabled, !!error) })}>
        <Icon name="clock" />
        <TimeInput
          locale={LOCALE}
          hourCycle={12}
          {...(value !== undefined && { value })}
          {...(defaultValue !== undefined && { defaultValue })}
          {...(onValueChange && {
            onValueChange: (next: string | null) => onValueChange(next),
          })}
          {...(required && { required })}
          {...(disabled && { disabled })}
          className="flex min-w-none flex-1 items-center gap-2xs"
        >
          {(state: { segments: Segment[] }) => {
            const digits = state.segments.filter((part) => part.type !== 'dayPeriod');
            const period = state.segments.filter((part) => part.type === 'dayPeriod');
            const shown = (part: Segment) => (
              <TimeInputSegment key={part.key} segment={part as never} className={segment()} />
            );
            return (
              <>
                <span dir="ltr" className="flex items-center">
                  {digits.map(shown)}
                </span>
                {period.map(shown)}
              </>
            );
          }}
        </TimeInput>
      </div>
    </Field>
  );
}
