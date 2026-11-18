import { describe, expect, it } from 'vitest';
import { matchesSearch, searchText } from './search-text.js';

// CU §8.3, owner decision 2026-11-18: the search ignores diacritics and the
// spelling variants «ة/ه», «ى/ي» and «أ/إ/آ/ا».
describe('searchText', () => {
  it('treats ة as ه, ى as ي and every alef as ا', () => {
    expect(searchText('شاورمة')).toBe(searchText('شاورمه'));
    expect(searchText('حلوى')).toBe(searchText('حلوي'));
    for (const alef of ['أ', 'إ', 'آ', 'ٱ']) expect(searchText(`${alef}كل`)).toBe('اكل');
  });

  it('drops diacritics and the tatweel', () => {
    expect(searchText('شَاوِرْمَا')).toBe('شاورما');
    expect(searchText('بـــرغر')).toBe('برغر');
    expect(searchText('مُحَمَّد')).toBe('محمد');
  });

  it('lowers Latin letters and folds spaces', () => {
    expect(searchText('  Pizza   HUT ')).toBe('pizza hut');
  });
});

describe('matchesSearch', () => {
  it('matches when every word of the search is in the fields', () => {
    expect(matchesSearch('شاورمة', ['مطعم الشاورما'])).toBe(false);
    expect(matchesSearch('شاورمه', ['شاورمة دجاج'])).toBe(true);
    expect(matchesSearch('دجاج شاورمة', ['شاورمة دجاج'])).toBe(true);
    expect(matchesSearch('دجاج لحم', ['شاورمة دجاج'])).toBe(false);
  });

  it('matches part of a word and across the fields', () => {
    expect(matchesSearch('برغ', ['برغر لحم'])).toBe(true);
    expect(matchesSearch('pizza مشروبات', ['Pizza Home', 'مشروبات'])).toBe(true);
  });

  it('skips missing fields and never matches an empty search', () => {
    expect(matchesSearch('فلافل', [null, 'فلافل'])).toBe(true);
    expect(matchesSearch('   ', ['فلافل'])).toBe(false);
  });
});
