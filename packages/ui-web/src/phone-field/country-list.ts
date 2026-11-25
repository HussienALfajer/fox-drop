import { COUNTRY_NAMES, type CountryName } from './countries.generated';
import { cleanPhone } from './phone';

/** Pinned first in the country list (owner, 2026-11-24). */
export const PINNED = ['SY', 'TR'] as const;

const BY_ISO = new Map(COUNTRY_NAMES.map((country) => [country.iso, country]));

export const countryName = (iso: string): CountryName | undefined => BY_ISO.get(iso);

/**
 * Whether `country` matches what was typed in the list's search: its Arabic
 * name, its English name (any case) or its calling code (`+49`, `0049`, `49`,
 * in any digits).
 */
export function matches(country: CountryName, query: string): boolean {
  const text = query.trim();
  if (!text) return true;
  if (country.ar.includes(text)) return true;
  if (country.en.toLowerCase().includes(text.toLowerCase())) return true;
  if (!/^[+\s\d٠-٩۰-۹]+$/.test(text)) return false;
  const digits = cleanPhone(text).replace('+', '').replace(/^00/, '');
  return digits !== '' && country.code.startsWith(digits);
}

export interface CountrySections {
  pinned: CountryName[];
  lastUsed: CountryName[];
  all: CountryName[];
}

/**
 * The list's sections for `query`: Syria and Turkey, then the last used
 * country (when it is neither), then every other region in Arabic order.
 */
export function countrySections(query: string, lastUsed?: string): CountrySections {
  const pinned = PINNED.map((iso) => BY_ISO.get(iso)!);
  const last =
    lastUsed && !(PINNED as readonly string[]).includes(lastUsed)
      ? BY_ISO.get(lastUsed)
      : undefined;
  const shown = new Set<string>([...PINNED, ...(last ? [last.iso] : [])]);
  // The generated list is in Arabic order already (scripts/countries.mjs).
  const all = COUNTRY_NAMES.filter((country) => !shown.has(country.iso));
  const keep = (list: CountryName[]) => list.filter((country) => matches(country, query));
  return { pinned: keep(pinned), lastUsed: keep(last ? [last] : []), all: keep(all) };
}
