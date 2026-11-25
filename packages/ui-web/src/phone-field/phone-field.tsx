import {
  Combobox,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxGroup,
  ComboboxGroupLabel,
  ComboboxInput,
  ComboboxItem,
  ComboboxList,
  ComboboxTrigger,
} from '@ui-sdk/react/combobox';
import { Field as SdkField } from '@ui-sdk/react/field';
import { Input } from '@ui-sdk/react/input';
import { useState, type KeyboardEvent } from 'react';
import { Field } from '../field/field';
import { InputBox } from '../field/input-box';
import { formTv, inputClass, keyboardRing, type Density } from '../field/styles';
import { Icon } from '../icon/icon';
import { SIDE_OFFSET } from '../select/menu';
import type { CountryName } from './countries.generated';
import { countryName, countrySections } from './country-list';
import { callingCode, readPhone, type PhoneReading } from './phone';

/** The states the stories show (R3). Hover and focus are driven in the browser by the gate. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'open',
  'filled',
  'valid',
  'invalid',
  'switched',
  'busy',
  'disabled',
] as const;

const chip = formTv({
  base: [
    'flex shrink-0 cursor-pointer items-center gap-2xs rounded-full px-2xs min-h-(--fd-size-touch-target)',
    'text-(color:--fd-input-color-text) data-disabled:cursor-not-allowed data-disabled:text-(color:--fd-input-color-on-disabled)',
    keyboardRing,
  ],
});

const chevron = formTv({
  base: 'flex transition-transform duration-(--fd-duration-base) ease-(--fd-easing-standard) group-data-open:rotate-180',
});

const icon = formTv({
  base: 'flex shrink-0 items-center justify-center rounded-full',
  variants: {
    kind: {
      // Not a control: as wide as its icon, so a narrow field keeps its digits.
      valid: 'px-2xs text-success',
      clear: [
        'size-(--fd-size-touch-target)',
        'cursor-pointer text-(color:--fd-input-color-hint)',
        'transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
        'hover:bg-surface-raised-hover active:bg-surface-raised-pressed',
        keyboardRing,
      ],
    },
  },
});

// The country list: the listbox of the select (`select/menu.tsx`) with a
// search field on top and named sections (D.11 item 5).
const listTv = formTv({
  slots: {
    content: [
      'z-10 w-(--fd-size-dialog) max-w-(--available-width) max-h-(--available-height) overflow-y-auto p-2xs outline-hidden',
      'rounded-(--fd-input-area-radius) bg-(--fd-input-color-background) text-(color:--fd-input-color-text)',
      'shadow-(--fd-elevation-medium)',
    ],
    search: [
      'mb-2xs flex min-h-(--fd-input-compact-height) items-center gap-(--fd-input-gap) rounded-full px-sm',
      'inset-ring-1 inset-ring-(--fd-input-color-border) focus-within:inset-ring-2 focus-within:inset-ring-(--fd-input-color-border-focus)',
    ],
    group: 'flex flex-col',
    label: 'px-sm pt-xs pb-2xs text-phone-caption font-medium text-(color:--fd-input-color-hint)',
    item: [
      'flex min-h-(--fd-input-check-target) cursor-pointer items-center justify-between gap-(--fd-input-gap)',
      'rounded-md px-sm text-phone-body outline-hidden',
      'data-highlighted:bg-surface-hover active:bg-surface-pressed data-selected:font-medium',
    ],
    code: 'text-(color:--fd-input-color-hint) tabular-nums',
    empty: 'px-sm py-sm text-phone-secondary text-(color:--fd-input-color-hint)',
  },
});
const list = listTv();

/** The words of each problem, from the app's strings (D.11 item 6). */
export interface PhoneMessages {
  empty: string;
  missingDigits: (count: number) => string;
  tooLong: string;
  landline: string;
  notMobilePrefix: (prefix: string) => string;
  unknownCode: string;
  /** A country that changed by itself: «عرفنا الدولة من رمزها: {الدولة}.» */
  switched: (country: string) => string;
}

export interface PhoneFieldProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  /** An error of the screen's own (the server's answer); the field's own problems come from `messages`. */
  error?: string;
  messages: PhoneMessages;
  /** The chip's accessible name: «الدولة: {الاسم}، {الرمز}. اضغط لتغييرها». */
  chipLabel: (name: string, code: string) => string;
  /** The country list's search field: «ابحث باسم الدولة أو رمزها». */
  searchLabel: string;
  /** The list's sections: «الأكثر استعمالاً», «آخر ما استعملته», «كل الدول». */
  pinnedLabel: string;
  lastUsedLabel: string;
  allLabel: string;
  /** The list's search found nothing. */
  emptyLabel: string;
  /** The check mark's name: «الرقم صحيح». */
  validLabel: string;
  /** The clear button's name: «مسح الرقم». */
  clearLabel: string;
  placeholder?: string;
  /** The number in E.164, or `''` while it is not a complete mobile. */
  value?: string;
  defaultValue?: string;
  /** Called with the E.164 of a complete mobile, otherwise `''`, and the reading. */
  onValueChange?: (value: string, details: { country: string; reading: PhoneReading }) => void;
  /** The key that sends, with a complete mobile; otherwise the problem shows. */
  onSubmit?: (value: string) => void;
  /** The picked country (ISO), controlled. */
  country?: string;
  /** The country the field starts on (`customer.phone_default_country`); Syria by default. */
  defaultCountry?: string;
  onCountryChange?: (country: string) => void;
  /** The last country used, listed after Syria and Turkey (the app stores it). */
  lastUsedCountry?: string;
  /** Locked while the number is being sent (R14). */
  busy?: boolean;
  name?: string;
  required?: boolean;
  disabled?: boolean;
  density?: Density;
}

function problemText(reading: PhoneReading, messages: PhoneMessages): string | undefined {
  switch (reading.problem) {
    case 'empty':
      return messages.empty;
    case 'missingDigits':
      return messages.missingDigits(reading.missing ?? 1);
    case 'tooLong':
      return messages.tooLong;
    case 'landline':
      return messages.landline;
    case 'notMobilePrefix':
      return messages.notMobilePrefix(reading.prefix ?? '');
    case 'unknownCode':
      return messages.unknownCode;
    default:
      return undefined;
  }
}

/** What the box shows for a stored E.164 number. */
function fromE164(value: string): { country: string; text: string } | undefined {
  if (!value) return undefined;
  const read = readPhone(value, 'SY');
  return read.e164 ? { country: read.country, text: read.grouped } : undefined;
}

/**
 * The phone number of every app (D.11 item 5): one pill with a left-to-right
 * island, the country chip (ISO letters and calling code) that opens a
 * searchable list of every region, then the digits, a check mark once the
 * number is a complete mobile, and a clear button. A number typed with `+`,
 * `00` or its calling code, or pasted with text around it, is read by the
 * shared rules (`phone.ts`) and switches the chip by itself. A problem shows
 * on leaving the field or on the send key, then live until fixed.
 */
export function PhoneField(props: PhoneFieldProps) {
  const { label, optionalLabel, hint, error, messages, chipLabel, placeholder } = props;
  const { value, defaultValue, onValueChange, onSubmit, onCountryChange, lastUsedCountry } = props;
  const { name, required, disabled, busy, density } = props;
  const start = fromE164(value ?? defaultValue ?? '');
  const [ownCountry, setOwnCountry] = useState(start?.country ?? props.defaultCountry ?? 'SY');
  const [text, setText] = useState(start?.text ?? '');
  const [judged, setJudged] = useState(false);
  const [switchedFrom, setSwitchedFrom] = useState<string | undefined>(undefined);
  const [query, setQuery] = useState('');
  const [chipButton, setChipButton] = useState<HTMLButtonElement | null>(null);
  const country = props.country ?? ownCountry;
  const reading = readPhone(text, country);

  // A controlled number the box does not make: take it over.
  if (value !== undefined && value !== (reading.e164 ?? '')) {
    const parsed = fromE164(value);
    if (parsed) {
      setOwnCountry(parsed.country);
      setText(parsed.text);
    } else if (value === '' && text !== '') {
      setText('');
    }
  }

  const locked = disabled || busy;
  const code = `+${callingCode(country) ?? ''}`;
  const named = countryName(country);
  const switchedName = switchedFrom ? named?.ar : undefined;
  const problem = judged ? problemText(reading, messages) : undefined;
  const shownError = error ?? problem;

  const report = (next: string, read: PhoneReading) =>
    onValueChange?.(read.e164 ?? '', { country: read.country, reading: read });

  const pickCountry = (next: string) => {
    setOwnCountry(next);
    setSwitchedFrom(undefined);
    onCountryChange?.(next);
    report(text, readPhone(text, next));
  };

  const change = (next: string) => {
    const read = readPhone(next, country);
    let shown = next;
    if (read.country !== country) {
      // The number named another country: the chip takes it, the box its digits.
      setOwnCountry(read.country);
      setSwitchedFrom(country);
      onCountryChange?.(read.country);
      shown = read.grouped;
    } else if (
      next.length - text.length > 1 ||
      (read.switchedFrom === undefined && /[^\d\s]/.test(next.replace(/^\+/, '')) && read.e164)
    ) {
      // A paste: shown grouped at once.
      shown = read.e164 ? read.grouped : next;
    }
    setText(shown);
    report(shown, read);
  };

  const sections = countrySections(query, lastUsedCountry);
  const option = (entry: CountryName) => {
    const dial = ['+', entry.code].join('');
    return (
      <ComboboxItem
        key={entry.iso}
        value={entry.iso}
        label={entry.ar}
        data-value={entry.iso}
        className={list.item()}
      >
        <span>{entry.ar}</span>
        <bdi dir="ltr" className={list.code()}>
          {dial}
        </bdi>
      </ComboboxItem>
    );
  };
  const group = (title: string, entries: CountryName[]) =>
    entries.length > 0 && (
      <ComboboxGroup className={list.group()}>
        <ComboboxGroupLabel className={list.label()}>{title}</ComboboxGroupLabel>
        {entries.map(option)}
      </ComboboxGroup>
    );

  const onKeyDown = (event: KeyboardEvent<HTMLInputElement>) => {
    if (event.key !== 'Enter') return;
    event.preventDefault();
    setJudged(true);
    if (reading.e164) onSubmit?.(reading.e164);
  };

  return (
    <Field
      label={label}
      {...(optionalLabel && { optionalLabel })}
      {...(hint && { hint })}
      {...(shownError && { error: shownError })}
      {...(locked && { disabled: true })}
      {...(name && { name })}
      {...(density && { density })}
    >
      <InputBox
        dir="ltr"
        {...(density && { density })}
        {...(locked && { disabled: true })}
        {...(shownError && { invalid: true })}
        start={
          // Its own Field: the chip is a second control, named by `chipLabel`.
          <SdkField className="contents" {...(locked && { disabled: true })}>
            <Combobox
              value={country}
              filter={false}
              query={query}
              onQueryChange={setQuery}
              {...(locked && { disabled: true })}
              onOpenChange={(open: boolean) => open && setQuery('')}
              onOpenChangeComplete={(open: boolean) => !open && chipButton?.focus()}
              onValueChange={(next: string | null) => {
                if (next && next !== country) pickCountry(next);
              }}
            >
              <ComboboxTrigger ref={setChipButton} className={chip({ class: 'group' })}>
                {/* Named by its content, not aria-label: the full sentence
                    for screen readers, the letters and code for the eye
                    (axe's label-content-name-mismatch). */}
                <span className="sr-only">{chipLabel(named?.ar ?? country, code)}</span>
                <span aria-hidden="true" className="flex items-center gap-2xs">
                  <span className="text-phone-secondary font-bold">{country}</span>
                  <bdi dir="ltr" className="tabular-nums">
                    {code}
                  </bdi>
                  <span className={chevron()}>
                    <Icon name="chevron-down" size="sm" />
                  </span>
                </span>
              </ComboboxTrigger>
              <ComboboxContent
                anchor={chipButton}
                sideOffset={SIDE_OFFSET}
                align="start"
                dir="rtl"
                className={list.content()}
              >
                <div className={list.search()}>
                  <Icon name="search" size="sm" />
                  <ComboboxInput
                    autoFocus
                    aria-label={props.searchLabel}
                    placeholder={props.searchLabel}
                    className={inputClass()}
                  />
                </div>
                <ComboboxEmpty className={list.empty()}>{props.emptyLabel}</ComboboxEmpty>
                <ComboboxList>
                  {group(props.pinnedLabel, sections.pinned)}
                  {group(props.lastUsedLabel, sections.lastUsed)}
                  {group(props.allLabel, sections.all)}
                </ComboboxList>
              </ComboboxContent>
            </Combobox>
          </SdkField>
        }
        end={
          <>
            {reading.e164 && (
              <span role="img" aria-label={props.validLabel} className={icon({ kind: 'valid' })}>
                <Icon name="success" variant="bold" />
              </span>
            )}
            {text !== '' && !locked && (
              <button
                type="button"
                aria-label={props.clearLabel}
                className={icon({ kind: 'clear' })}
                onClick={() => {
                  setText('');
                  setSwitchedFrom(undefined);
                  report('', readPhone('', country));
                }}
              >
                <Icon name="close" size="sm" />
              </button>
            )}
          </>
        }
      >
        <Input
          type="tel"
          inputMode="tel"
          autoComplete="tel"
          enterKeyHint="send"
          className={inputClass()}
          value={text}
          onValueChange={change}
          onKeyDown={onKeyDown}
          onBlur={() => {
            if (text !== '') setJudged(true);
            if (reading.e164) setText(reading.grouped);
          }}
          {...(locked && { disabled: true })}
          {...(placeholder && { placeholder })}
          {...(required && { required })}
        />
      </InputBox>
      {switchedName && !shownError && (
        <span className="flex items-center gap-2xs text-phone-caption text-info">
          <Icon name="info" size="sm" />
          {messages.switched(switchedName)}
        </span>
      )}
    </Field>
  );
}
