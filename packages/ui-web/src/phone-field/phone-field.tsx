import { Field as SdkField } from '@ui-sdk/react/field';
import { Input } from '@ui-sdk/react/input';
import { Select as SdkSelect, SelectTrigger, SelectValue } from '@ui-sdk/react/select';
import { useState } from 'react';
import { Field } from '../field/field';
import { InputBox } from '../field/input-box';
import { formTv, inputClass, keyboardRing, type Density } from '../field/styles';
import { Icon } from '../icon/icon';
import { Menu } from '../select/menu';
import {
  COUNTRIES,
  COUNTRY_CODES,
  digitsOf,
  fromE164,
  nationalDigits,
  toE164,
  type CountryCode,
} from './phone';

/** The states the stories show (R3). Hover and focus are driven in the browser by the gate. */
export const STATES = [
  'default',
  'hover',
  'focus',
  'filled',
  'invalid',
  'disabled',
  'turkey',
] as const;

export type { CountryCode as PhoneCountry };

const chip = formTv({
  base: [
    'flex shrink-0 cursor-pointer items-center gap-(--fd-space-2xs) rounded-full font-medium',
    'text-(color:--fd-input-color-text) data-disabled:cursor-not-allowed data-disabled:text-(color:--fd-input-color-on-disabled)',
    keyboardRing,
  ],
});

const chevron = formTv({
  base: 'flex transition-transform duration-(--fd-duration-base) ease-(--fd-easing-standard) group-data-open:rotate-180',
});

export interface PhoneFieldProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  /** The names in the country menu, shown before the calling code: «سوريا», «تركيا». */
  countryLabels: Record<CountryCode, string>;
  /** The accessible name of the country chip: «الدولة». */
  countryLabel: string;
  placeholder?: string;
  /** The number in E.164 (`+963912345678`), or `''` while it is not a complete mobile number. */
  value?: string;
  defaultValue?: string;
  /** Called with the E.164 number when a complete mobile number is typed, pasted or the country changes; otherwise with `''`. */
  onValueChange?: (value: string, details: { country: CountryCode }) => void;
  country?: CountryCode;
  /** The country the picker starts on (`customer.phone_default_country`); Syria by default. */
  defaultCountry?: CountryCode;
  onCountryChange?: (country: CountryCode) => void;
  name?: string;
  required?: boolean;
  disabled?: boolean;
  density?: Density;
}

/** What the digits box shows for what was typed or pasted: Western digits, no `+963` prefix. */
function clean(country: CountryCode, next: string): string {
  const text = next.trim();
  if (/^(\+|00)/.test(text)) return nationalDigits(country, text);
  const digits = digitsOf(text);
  return digits.slice(0, COUNTRIES[country].length + (digits.startsWith('0') ? 1 : 0));
}

/**
 * The phone number of the customer app (CU §5.2): one pill with a left-to-right
 * island, the country chip with its chevron and then the digits, under a label
 * and an error that stay right to left. Accepts `09…`/`9…` for Syria and
 * `05…`/`5…` for Turkey, and reports E.164.
 */
export function PhoneField(props: PhoneFieldProps) {
  const { label, optionalLabel, hint, error, countryLabels, countryLabel, placeholder } = props;
  const { value, defaultValue, onValueChange, onCountryChange } = props;
  const { name, required, disabled, density } = props;
  const start = fromE164(value ?? defaultValue ?? '');
  const [ownCountry, setOwnCountry] = useState<CountryCode>(
    start?.country ?? props.defaultCountry ?? 'sy',
  );
  const [text, setText] = useState(start?.national ?? '');
  const country = props.country ?? ownCountry;

  // A controlled number that the typed digits do not make: take it over.
  if (value !== undefined && value !== toE164(country, text)) {
    const parsed = fromE164(value);
    if (parsed) {
      setOwnCountry(parsed.country);
      setText(parsed.national);
    } else if (value === '' && text !== '') {
      setText('');
    }
  }

  const dialCode = `+${COUNTRIES[country].dial}`;
  const items = COUNTRY_CODES.map((code) => ({
    value: code,
    label: `${countryLabels[code]} +${COUNTRIES[code].dial}`,
  }));

  return (
    <Field
      label={label}
      {...(optionalLabel && { optionalLabel })}
      {...(hint && { hint })}
      {...(error && { error })}
      {...(disabled && { disabled })}
      {...(name && { name })}
      {...(density && { density })}
    >
      <InputBox
        dir="ltr"
        {...(density && { density })}
        {...(disabled && { disabled })}
        {...(error && { invalid: true })}
        start={
          // Its own Field: the chip is a second control, named by `countryLabel`
          // and not by the number's label.
          <SdkField className="contents" {...(disabled && { disabled })}>
            <SdkSelect
              items={items}
              value={country}
              onValueChange={(next: string | null) => {
                if (next === null || !(next in COUNTRIES)) return;
                const code = next as CountryCode;
                setOwnCountry(code);
                onCountryChange?.(code);
                onValueChange?.(toE164(code, text), { country: code });
              }}
            >
              <SelectTrigger aria-label={countryLabel} className={chip({ class: 'group' })}>
                <SelectValue>{dialCode}</SelectValue>
                <span className={chevron()}>
                  <Icon name="chevron-down" size={density === 'compact' ? 'sm' : 'md'} />
                </span>
              </SelectTrigger>
              <Menu items={items} dir="rtl" />
            </SdkSelect>
          </SdkField>
        }
      >
        <Input
          type="tel"
          inputMode="tel"
          autoComplete="tel-national"
          className={inputClass()}
          value={text}
          onValueChange={(next: string) => {
            const display = clean(country, next);
            setText(display);
            onValueChange?.(toE164(country, display), { country });
          }}
          {...(placeholder && { placeholder })}
          {...(required && { required })}
        />
      </InputBox>
    </Field>
  );
}
