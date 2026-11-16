import { describe, expect, it, vi } from 'vitest';
import ar from './locales/ar.json';
import { cashLines, figureLines } from './daily-report.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.10.1: every figure the screen and the Excel file show has its words,
// and every word is shown (the server's export reads the same `line` map).
describe('the daily report lines', () => {
  it('names each figure once, and names nothing it does not show', () => {
    const shown = [
      ...figureLines.map(([key]) => key),
      ...cashLines,
      'captainsBlocked',
      'overdueRestaurants',
    ];
    expect(new Set(shown).size).toBe(shown.length);
    expect(shown.toSorted()).toEqual(Object.keys(ar.dailyReport.line).toSorted());
  });

  it('reads each earned figure from the day', () => {
    const day = {
      orders: { count: 3, gmv: '123000', itemsValue: '100000' },
      margin: '4500',
    } as unknown as Parameters<(typeof figureLines)[number][1]>[0];
    const read = Object.fromEntries(
      figureLines
        .filter(([key]) => key === 'orders' || key === 'gmv' || key === 'margin')
        .map(([key, value]) => [key, value(day)]),
    );
    expect(read).toEqual({
      orders: { count: 3 },
      gmv: { amount: '123000' },
      margin: { amount: '4500' },
    });
  });
});
