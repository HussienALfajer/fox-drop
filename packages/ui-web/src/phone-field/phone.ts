// The phone field's reading of what was typed or pasted (slice D.11b; D.11's
// normalisation table, owner 2026-11-24), the same as core_ui's
// `foxReadPhone`: both pass every row of `phone-cases.json`. The rules come
// from `libphonenumber-js` with the `max` metadata (the number types tell a
// mobile from a landline), the library the server validates with (D.11a).
import {
  getCountries,
  getCountryCallingCode,
  Metadata,
  type CountryCode,
  type MetadataJson,
} from 'libphonenumber-js/core';
import examples from 'libphonenumber-js/mobile/examples';
import max from 'libphonenumber-js/metadata.max.json';

const metadata = max as unknown as MetadataJson;

export type PhoneProblem =
  'empty' | 'missingDigits' | 'tooLong' | 'landline' | 'notMobilePrefix' | 'unknownCode';

export interface PhoneReading {
  /** The country the field ends on (ISO code). */
  country: string;
  /** The national significant digits, without the national prefix. */
  national: string;
  /** The national digits in groups of three, the last up to four: `944 123 456`. */
  grouped: string;
  /** The E.164 number when `national` is a complete mobile of `country`. */
  e164?: string;
  problem?: PhoneProblem;
  /** With `missingDigits`: how many digits are missing. */
  missing?: number;
  /** With `notMobilePrefix`: the digit a mobile starts with. */
  prefix?: string;
  /** The country that was picked, when the number named another one. */
  switchedFrom?: string;
}

const REGIONS = new Set<string>(getCountries(metadata));

/** The calling code of `iso` without the plus, or undefined for an unknown region. */
export function callingCode(iso: string): string | undefined {
  return REGIONS.has(iso) ? getCountryCallingCode(iso as CountryCode, metadata) : undefined;
}

/** `digits` in groups of three, the rest as one group once four or fewer remain. */
export function groupDigits(digits: string): string {
  const groups: string[] = [];
  let rest = digits;
  while (rest.length > 4) {
    groups.push(rest.slice(0, 3));
    rest = rest.slice(3);
  }
  if (rest) groups.push(rest);
  return groups.join(' ');
}

// Spaces, dashes, brackets and dots a number is written with, and the hidden
// marks a contact or a paste carries: LRM, RLM, the embeddings and overrides
// U+202A–U+202E, the isolates U+2066–U+2069, and no-break spaces.
// Built from code points: the marks themselves never sit in the source.
const hex = (point: number) => point.toString(16).padStart(4, '0');
const range = (from: number, to = from) =>
  from === to ? `\\u${hex(from)}` : `\\u${hex(from)}-\\u${hex(to)}`;
const SEPARATORS = [
  '\\s\\-().',
  range(0x2010, 0x2015), // hyphens and dashes
  range(0x2212), // minus
  range(0x00a0), // no-break space
  range(0x2007), // figure space
  range(0x202f), // narrow no-break space
  range(0x200e, 0x200f), // LRM, RLM
  range(0x202a, 0x202e), // embeddings and overrides
  range(0x2066, 0x2069), // isolates
].join('');
const SEPARATOR = new RegExp(`[${SEPARATORS}]`, 'g');
const NUMBERISH = new RegExp(`^[+\\d${SEPARATORS}]*$`);
const IN_TEXT = new RegExp(`\\+?\\d[\\d${SEPARATORS}]*`);

const ARABIC_INDIC = 0x0660;
const PERSIAN = 0x06f0;

/** Arabic-Indic and Persian digits made Western (AP §4.7). */
function western(text: string): string {
  let out = '';
  for (const char of text) {
    const point = char.codePointAt(0)!;
    if (point >= ARABIC_INDIC && point <= ARABIC_INDIC + 9) out += String(point - ARABIC_INDIC);
    else if (point >= PERSIAN && point <= PERSIAN + 9) out += String(point - PERSIAN);
    else out += char;
  }
  return out;
}

/** Western digits only: Arabic-Indic and Persian digits become 0-9, everything else goes (the code field). */
export function digitsOf(text: string): string {
  return western(text).replace(/\D/g, '');
}

/** The number in `input`: `+` and Western digits only; text around a number (a paste) is dropped. */
export function cleanPhone(input: string): string {
  let text = western(input);
  if (!NUMBERISH.test(text)) text = IN_TEXT.exec(text)?.[0] ?? '';
  const bare = text.replace(SEPARATOR, '');
  const digits = bare.replace(/\D/g, '');
  return bare.startsWith('+') ? `+${digits}` : digits;
}

// What the metadata's numbering plan gives beyond its published types.
interface NumberType {
  pattern(): string;
  possibleLengths(): number[] | undefined;
}
interface Plan {
  type(name: 'MOBILE' | 'FIXED_LINE'): NumberType | undefined;
  nationalPrefix(): string | undefined;
  possibleLengths(): number[];
}
interface Rules {
  nationalPrefix: string | undefined;
  mobile: RegExp | undefined;
  fixed: RegExp | undefined;
  lengths: number[];
}

const meta = new Metadata(metadata) as Metadata & {
  getCountryCodesForCallingCode(code: string): string[] | undefined;
};
const cache = new Map<string, Rules>();

function rules(iso: string): Rules {
  const found = cache.get(iso);
  if (found) return found;
  meta.selectNumberingPlan(iso as CountryCode);
  const plan = meta.numberingPlan as unknown as Plan;
  const whole = (pattern: string | undefined) =>
    pattern ? new RegExp(`^(?:${pattern})$`) : undefined;
  const mobile = plan.type('MOBILE');
  const fixed = plan.type('FIXED_LINE');
  // A region whose mobiles and landlines look the same (Canada) keeps one
  // pattern for both, its mobile one empty: a number of it is a mobile.
  const same = !mobile?.pattern();
  const made: Rules = {
    nationalPrefix: plan.nationalPrefix() || undefined,
    mobile: whole(same ? fixed?.pattern() : mobile?.pattern()),
    fixed: same ? undefined : whole(fixed?.pattern()),
    lengths: [...(mobile?.possibleLengths() ?? plan.possibleLengths())].sort((a, b) => a - b),
  };
  cache.set(iso, made);
  return made;
}

const reading = (
  country: string,
  national: string,
  rest: Partial<PhoneReading> = {},
): PhoneReading => ({ country, national, grouped: groupDigits(national), ...rest });

/** Reads `input` under the `picked` country (ISO). */
export function readPhone(input: string, picked: string): PhoneReading {
  const clean = cleanPhone(input);
  const digits = clean.replace('+', '');
  if (!digits) return reading(picked, '', { problem: 'empty' });
  if (clean.startsWith('+')) return international(digits, picked);
  if (digits.startsWith('00')) return international(digits.slice(2), picked);

  const national = classify(picked, nationalOf(picked, digits));
  if (national.e164) return national;
  // A calling code without `+` or `00`, after a 0 or bare: the picked
  // country's, or another's whose mobile it then is.
  const code = callingCode(picked);
  if (code && digits.startsWith(`0${code}`)) {
    const read = international(digits.slice(1), picked);
    if (read.e164) return read;
  }
  const read = international(digits, picked);
  if (read.e164) return read;
  return national;
}

function international(digits: string, picked: string): PhoneReading {
  for (let length = 1; length <= 3 && length <= digits.length; length++) {
    const regions = meta.getCountryCodesForCallingCode(digits.slice(0, length)) ?? [];
    if (regions.length === 0) continue;
    const rest = digits.slice(length);
    // The picked country first, then the code's main region and the others.
    const ordered = [
      ...regions.filter((r) => r === picked),
      ...regions.filter((r) => r !== picked),
    ];
    for (const region of ordered) {
      const read = classify(region, nationalOf(region, rest));
      if (read.e164) return switched(read, picked);
    }
    const main = ordered[0]!;
    return switched(classify(main, nationalOf(main, rest)), picked);
  }
  return reading(picked, '', { problem: 'unknownCode' });
}

const switched = (read: PhoneReading, picked: string): PhoneReading =>
  read.country === picked ? read : { ...read, switchedFrom: picked };

/** `digits` without the national prefix, unless the prefix is part of a valid number. */
function nationalOf(iso: string, digits: string): string {
  const { nationalPrefix, mobile, fixed } = rules(iso);
  if (!nationalPrefix || !digits.startsWith(nationalPrefix)) return digits;
  if (mobile?.test(digits) || fixed?.test(digits)) return digits;
  return digits.slice(nationalPrefix.length);
}

function classify(iso: string, national: string): PhoneReading {
  if (!national) return reading(iso, national, { problem: 'empty' });
  const { mobile, fixed, lengths } = rules(iso);
  if (mobile?.test(national))
    return reading(iso, national, { e164: `+${callingCode(iso)!}${national}` });
  if (fixed?.test(national)) return reading(iso, national, { problem: 'landline' });
  const shortest = lengths[0];
  const longest = lengths.at(-1);
  if (shortest !== undefined && national.length < shortest)
    return reading(iso, national, {
      problem: 'missingDigits',
      missing: shortest - national.length,
    });
  if (longest !== undefined && national.length > longest)
    return reading(iso, national, { problem: 'tooLong' });
  const example = (examples as Record<string, string | undefined>)[iso];
  return reading(iso, national, {
    problem: 'notMobilePrefix',
    ...(example && { prefix: example.slice(0, 1) }),
  });
}
