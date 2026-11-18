// CU §8.3 (owner decision 2026-11-18): the search ignores the Arabic
// diacritics and the tatweel, and treats «ة» as «ه», «ى» as «ي» and every
// alef («أ», «إ», «آ», «ٱ») as «ا». Latin letters match in any case.
const MARKS = /[ؐ-ًؚ-ٰٟۖ-ۭـ]/g;
const ALEFS = /[أإآٱ]/g;

// The form a search and the text searched are compared in.
export function searchText(text: string): string {
  return text
    .normalize('NFC')
    .replace(MARKS, '')
    .replace(ALEFS, 'ا')
    .replace(/ة/g, 'ه')
    .replace(/ى/g, 'ي')
    .toLowerCase()
    .replace(/\s+/g, ' ')
    .trim();
}

// Whether every word of the search is part of one of the fields; an empty
// search matches nothing.
export function matchesSearch(search: string, fields: (string | null)[]): boolean {
  const words = searchText(search)
    .split(' ')
    .filter((word) => word !== '');
  if (words.length === 0) return false;
  const text = fields
    .filter((field): field is string => field !== null)
    .map(searchText)
    .join(' ');
  return words.every((word) => text.includes(word));
}
