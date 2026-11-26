import {
  CalendarDay,
  CalendarGrid,
  CalendarHeading,
  CalendarNext,
  CalendarPrevious,
  CalendarWeekday,
  CalendarWeekdays,
  CalendarWeeks,
  DatePicker,
  DatePickerContent,
  DatePickerTrigger,
} from '@ui-sdk/react/date-picker';
import { useFieldControl } from '@ui-sdk/react/field';
import { useId } from 'react';
import { Field } from '../field/field';
import { box, boxState, formTv } from '../field/styles';
import { Icon } from '../icon/icon';
import { SIDE_OFFSET } from '../select/menu';

/** The states the stories show (R3), the Flutter twin's and the open calendar. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'open',
  'filled',
  'invalid',
  'disabled',
] as const;

/**
 * Arabic with Western digits (AP §4.7): the region's Syriac month names
 * (كانون الثاني…كانون الأول) come with `ar-SY`.
 */
export const LOCALE = 'ar-SY-u-nu-latn';

/** Saturday, from Sunday (0): the week starts on it (AP §4.7). */
export const SATURDAY = 6;

/** `2027-03-05` as the field shows it, `05/03/2027`. */
export const shownDate = (iso: string) => iso.split('-').reverse().join('/');

const trigger = formTv({
  extend: box,
  base: [
    'w-full cursor-pointer text-start outline-hidden',
    'data-open:inset-ring-(length:--fd-input-focus-width) data-open:inset-ring-(color:--fd-input-color-border-focus)',
  ],
});

const calendar = formTv({
  slots: {
    content: [
      'z-10 flex flex-col gap-(--fd-date-field-popup-gap) p-(--fd-date-field-popup-padding) outline-hidden',
      'rounded-(--fd-date-field-popup-radius) bg-(--fd-date-field-color-popup-background) text-(color:--fd-input-color-text)',
      'shadow-(--fd-elevation-medium)',
    ],
    header: 'flex items-center justify-between gap-(--fd-input-gap)',
    heading: 'text-phone-subtitle font-bold',
    step: [
      'flex size-(--fd-date-field-day-size) cursor-pointer items-center justify-center rounded-full',
      'not-data-disabled:hover:bg-(--fd-date-field-color-day-hover) data-disabled:cursor-not-allowed data-disabled:text-(color:--fd-input-color-on-disabled)',
      'outline-hidden focus-visible:ring-2 focus-visible:ring-(color:--fd-input-color-focus-ring)',
    ],
    grid: 'border-collapse',
    weekday: [
      'size-(--fd-date-field-day-size) text-center text-phone-caption font-medium',
      'text-(color:--fd-date-field-color-day-outside)',
    ],
    day: [
      'size-(--fd-date-field-day-size) cursor-pointer rounded-full text-center text-phone-body tabular-nums outline-hidden',
      // Only a day that can be picked lights up (R10).
      'not-data-disabled:not-data-unavailable:hover:bg-(--fd-date-field-color-day-hover)',
      'data-outside:text-(color:--fd-date-field-color-day-outside)',
      'data-today:font-bold data-today:text-(color:--fd-date-field-color-today)',
      'data-today:inset-ring-(length:--fd-input-border-width) data-today:inset-ring-(color:--fd-date-field-color-today)',
      'data-selected:bg-(--fd-date-field-color-day-selected) data-selected:text-(color:--fd-date-field-color-on-day-selected)',
      'data-disabled:cursor-not-allowed data-disabled:text-(color:--fd-input-color-on-disabled)',
      'data-unavailable:cursor-not-allowed data-unavailable:text-(color:--fd-input-color-on-disabled)',
      'focus-visible:ring-2 focus-visible:ring-(color:--fd-input-color-focus-ring)',
    ],
  },
});
const parts = calendar();

export interface DateFieldProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  /** What the field shows while no date is chosen. */
  placeholder?: string;
  /** The date as ISO `YYYY-MM-DD`, or null, controlled. */
  value?: string | null;
  defaultValue?: string | null;
  onValueChange?: (value: string | null) => void;
  /** The earliest and latest dates that can be picked, ISO. */
  min?: string;
  max?: string;
  /** The calendar's buttons: «الشهر السابق», «الشهر التالي». */
  previousLabel: string;
  nextLabel: string;
  /** Today, ISO; the browser's by default (the stories fix it). */
  today?: string;
  name?: string;
  required?: boolean;
  disabled?: boolean;
}

/** The pill that opens the calendar, the field's control. */
function Trigger({
  shown,
  placeholder,
  invalid,
  disabled,
}: {
  shown: string | undefined;
  placeholder: string | undefined;
  invalid: boolean;
  disabled: boolean;
}) {
  const field = useFieldControl();
  const valueId = useId();
  const own: Record<string, unknown> = field ? field.props({}) : {};
  const labelledBy = [own['aria-labelledby'], valueId].filter(Boolean).join(' ');
  return (
    <DatePickerTrigger
      {...own}
      aria-labelledby={labelledBy}
      className={trigger({ state: boxState(disabled, invalid), class: 'group' })}
    >
      <Icon name="calendar" />
      {/* Digits and slashes keep their order in Arabic, from the left, as
          the Flutter twin shows them (no tabular figures: they space the slashes). */}
      <span
        id={valueId}
        dir={shown ? 'ltr' : undefined}
        className={formTv({
          base: 'min-w-none flex-1 truncate text-start',
          variants: {
            empty: { true: 'text-(color:--fd-input-color-placeholder)' },
          },
        })({ empty: !shown })}
      >
        {shown ?? placeholder}
      </span>
    </DatePickerTrigger>
  );
}

/**
 * A date (D.8), on the UI SDK's DatePicker: the pill shows the date as
 * `dd/mm/yyyy` in Western digits, or the placeholder, with a calendar icon
 * at the start; it opens a calendar of one month with the Syriac month
 * names and the week from Saturday (AP §4.7). The arrows move by day in the
 * reading direction, Page Up and Down by month, Enter picks, Escape closes.
 */
export function DateField(props: DateFieldProps) {
  const { label, optionalLabel, hint, error, placeholder, onValueChange } = props;
  const { value, defaultValue, min, max, today, name, required, disabled } = props;
  return (
    <Field
      label={label}
      {...(optionalLabel && { optionalLabel })}
      {...(hint && { hint })}
      {...(error && { error })}
      {...(disabled && { disabled })}
      {...(name && { name })}
    >
      <DatePicker
        locale={LOCALE}
        weekStartsOn={SATURDAY}
        weekdayFormat="narrow"
        {...(value !== undefined && { value })}
        {...(defaultValue !== undefined && { defaultValue })}
        {...(onValueChange && {
          onValueChange: (next: unknown) => onValueChange(typeof next === 'string' ? next : null),
        })}
        {...(min && { min })}
        {...(max && { max })}
        {...(today && { today })}
        {...(required && { required })}
        {...(disabled && { disabled })}
      >
        {(state: { value: unknown }) => (
          <>
            <Trigger
              shown={typeof state.value === 'string' ? shownDate(state.value) : undefined}
              placeholder={placeholder}
              invalid={!!error}
              disabled={!!disabled}
            />
            <DatePickerContent
              sideOffset={SIDE_OFFSET}
              align="start"
              dir="rtl"
              className={parts.content()}
            >
              <div className={parts.header()}>
                <CalendarPrevious aria-label={props.previousLabel} className={parts.step()}>
                  {/* Previous is at the start, pointing to it; RTL only, as the app. */}
                  <span className="flex -rotate-90">
                    <Icon name="chevron-down" size="sm" />
                  </span>
                </CalendarPrevious>
                <CalendarHeading className={parts.heading()} />
                <CalendarNext aria-label={props.nextLabel} className={parts.step()}>
                  <span className="flex rotate-90">
                    <Icon name="chevron-down" size="sm" />
                  </span>
                </CalendarNext>
              </div>
              <CalendarGrid className={parts.grid()}>
                <CalendarWeekdays>
                  {(index) => <CalendarWeekday index={index} className={parts.weekday()} />}
                </CalendarWeekdays>
                <CalendarWeeks>
                  {(cell) => <CalendarDay value={cell.date} className={parts.day()} />}
                </CalendarWeeks>
              </CalendarGrid>
            </DatePickerContent>
          </>
        )}
      </DatePicker>
    </Field>
  );
}
