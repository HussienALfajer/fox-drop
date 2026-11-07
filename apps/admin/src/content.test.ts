import { describe, expect, it, vi } from 'vitest';
import { contactBody, faqItems, moved } from './content.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.13 «المحتوى».
describe('moved', () => {
  it('swaps a reason with its neighbour, and stops at the ends', () => {
    expect(moved(['a', 'b', 'c'], 'b', -1)).toEqual(['b', 'a', 'c']);
    expect(moved(['a', 'b', 'c'], 'b', 1)).toEqual(['a', 'c', 'b']);
    expect(moved(['a', 'b', 'c'], 'a', -1)).toEqual(['a', 'b', 'c']);
    expect(moved(['a', 'b', 'c'], 'c', 1)).toEqual(['a', 'b', 'c']);
  });
});

describe('faqItems', () => {
  it('trims the pairs and drops an incomplete one', () => {
    expect(
      faqItems([
        { question: ' كيف أدفع؟ ', answer: ' نقداً ' },
        { question: 'سؤال بلا جواب', answer: '' },
        { question: '', answer: '' },
      ]),
    ).toEqual([{ question: 'كيف أدفع؟', answer: 'نقداً' }]);
  });
});

describe('contactBody', () => {
  it('sends a number without spaces, 00 as +, and an empty one as none', () => {
    expect(contactBody('00963 944 000-000', '  ')).toEqual({
      phone: '+963944000000',
      whatsapp: null,
    });
  });
});
