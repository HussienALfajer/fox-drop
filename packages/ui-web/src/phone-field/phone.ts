// The phone number rules of the customer app (CU §5.2): a country picker with
// Syria +963 and Turkey +90; Syrian mobiles have 9 digits after +963 and start
// with 9 (`09xxxxxxxx` and `9xxxxxxxx` are accepted); Turkish mobiles have 10
// digits after +90 and start with 5 (`05xxxxxxxxx`, `5xxxxxxxxx`); the number
// is stored in E.164.

export type CountryCode = 'sy' | 'tr';

export interface Country {
  /** The calling code without the plus. */
  dial: string;
  /** The digits of the national number, without the leading 0. */
  length: number;
  /** The digit every mobile number starts with. */
  prefix: string;
}

export const COUNTRIES: Record<CountryCode, Country> = {
  sy: { dial: '963', length: 9, prefix: '9' },
  tr: { dial: '90', length: 10, prefix: '5' },
};

export const COUNTRY_CODES = Object.keys(COUNTRIES) as CountryCode[];

const ARABIC_INDIC = '٠١٢٣٤٥٦٧٨٩';
const EASTERN_ARABIC_INDIC = '۰۱۲۳۴۵۶۷۸۹';

/** Western digits only: Arabic-Indic and Persian digits become 0-9 (AP §4.7), everything else goes. */
export function digitsOf(text: string): string {
  let out = '';
  for (const char of text) {
    const arabic = ARABIC_INDIC.indexOf(char);
    const persian = EASTERN_ARABIC_INDIC.indexOf(char);
    if (arabic >= 0) out += String(arabic);
    else if (persian >= 0) out += String(persian);
    else if (char >= '0' && char <= '9') out += char;
  }
  return out;
}

/**
 * The national digits of what was typed or pasted: the leading `0` of `09…`
 * goes, and so does a pasted `+963` or `00963`; cut to the country's length.
 */
export function nationalDigits(country: CountryCode, text: string): string {
  const { dial, length } = COUNTRIES[country];
  const trimmed = text.trim();
  let digits = digitsOf(trimmed);
  if (/^\s*(\+|00)/.test(trimmed) && digits.replace(/^00/, '').startsWith(dial)) {
    digits = digits.replace(/^00/, '').slice(dial.length);
  }
  if (digits.startsWith('0')) digits = digits.slice(1);
  return digits.slice(0, length);
}

/** Whether the national digits are a complete mobile number of the country. */
export function isComplete(country: CountryCode, national: string): boolean {
  const { length, prefix } = COUNTRIES[country];
  return national.length === length && national.startsWith(prefix);
}

/** The E.164 number of what was typed, or `''` while it is not a complete mobile number. */
export function toE164(country: CountryCode, text: string): string {
  const national = nationalDigits(country, text);
  return isComplete(country, national) ? `+${COUNTRIES[country].dial}${national}` : '';
}

/** The country and the national digits of an E.164 number, or null when it is neither country's. */
export function fromE164(value: string): { country: CountryCode; national: string } | null {
  for (const country of COUNTRY_CODES) {
    const { dial } = COUNTRIES[country];
    if (value.startsWith(`+${dial}`)) {
      const national = value.slice(dial.length + 1);
      if (isComplete(country, national)) return { country, national };
    }
  }
  return null;
}
