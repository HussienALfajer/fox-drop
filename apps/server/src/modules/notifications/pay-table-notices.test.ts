import { describe, expect, it } from 'vitest';
import { payTableStart } from './pay-table-notices.js';

// CA §14 #22 (owner decision 2026-11-19): the start with its weekday, date
// and time on the city's clock.
describe('payTableStart', () => {
  it('names the day, the date and the time in the city', () => {
    // 11:30 UTC is 14:30 in Damascus (UTC+3).
    expect(payTableStart(new Date('2026-11-26T11:30:00Z'), 'Asia/Damascus')).toBe(
      'الخميس 26/11/2026 الساعة 2:30 م',
    );
    // Past midnight in the city, the next day.
    expect(payTableStart(new Date('2026-11-26T21:05:00Z'), 'Asia/Damascus')).toBe(
      'الجمعة 27/11/2026 الساعة 12:05 ص',
    );
  });
});
