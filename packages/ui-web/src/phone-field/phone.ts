// The phone number rules of the customer app (CU §5.2), the same as Flutter's
// `foxPhoneE164`. The web's rules, exactly:
// 1. Countries: Syria +963 (9 national digits, starts with 9; `09…` and `9…`)
//    and Turkey +90 (10 digits, starts with 5; `05…` and `5…`); stored as E.164.
// 2. Digits: Arabic-Indic and Persian digits become 0-9; other characters go.
// 3. A number with its own calling code (`+`, `00`, or exactly code + full
//    national number such as `963912345678`) belongs to that country whichever
//    is picked; it must be complete for it, else it is refused.
// 4. Otherwise one leading 0 is dropped; digits are never cut: more than the
//    picked country's length is refused, not reshaped.
// 5. A number that is not complete reports E.164 `''`.

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

/** Whether the national digits are a complete mobile number of the country. */
export function isComplete(country: CountryCode, national: string): boolean {
  const { length, prefix } = COUNTRIES[country];
  return national.length === length && national.startsWith(prefix);
}

export interface ParsedPhone {
  /** The country the number belongs to: the one picked, or the one its own calling code names. */
  country: CountryCode;
  /** What the digits box shows: the digits as typed, or the national digits of a number pasted with its calling code. */
  display: string;
  /** The E.164 number, or `''` while it is not a complete mobile number. */
  e164: string;
  /** The text cannot be a number of either country (too long, or a calling code with a wrong rest). */
  refused: boolean;
}

const international = (country: CountryCode, national: string): ParsedPhone =>
  isComplete(country, national)
    ? { country, display: national, e164: `+${COUNTRIES[country].dial}${national}`, refused: false }
    : { country, display: national, e164: '', refused: true };

/**
 * Reads what was typed or pasted under the picked country. A number with its
 * own calling code (`+90…`, `0090…`, or exactly that code and a full national
 * number such as `963912345678`) belongs to that country, whichever is picked,
 * and must be complete for it. Otherwise the leading `0` is dropped and nothing
 * is cut: more digits than the country has make the text refused.
 */
export function parsePhone(selected: CountryCode, text: string): ParsedPhone {
  const trimmed = text.trim();
  const digits = digitsOf(trimmed);
  const refused: ParsedPhone = { country: selected, display: digits, e164: '', refused: true };

  if (trimmed.startsWith('+') || digits.startsWith('00')) {
    const rest = trimmed.startsWith('+') ? digits : digits.slice(2);
    const code = COUNTRY_CODES.find((country) => rest.startsWith(COUNTRIES[country].dial));
    if (!code) return refused;
    const result = international(code, rest.slice(COUNTRIES[code].dial.length));
    return result.refused ? refused : result;
  }

  const full = COUNTRY_CODES.find((country) => {
    const { dial, length } = COUNTRIES[country];
    return digits.length === dial.length + length && digits.startsWith(dial);
  });
  if (full) {
    const result = international(full, digits.slice(COUNTRIES[full].dial.length));
    if (!result.refused) return result;
  }

  const national = digits.startsWith('0') ? digits.slice(1) : digits;
  if (national.length > COUNTRIES[selected].length) return refused;
  return {
    country: selected,
    display: digits,
    e164: isComplete(selected, national) ? `+${COUNTRIES[selected].dial}${national}` : '',
    refused: false,
  };
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
