import { describe, expect, it, vi } from 'vitest';
import {
  cashLinesOf,
  type DeskCustody,
  directionOf,
  handInLinesOf,
  maximumOf,
  remainingOf,
} from './cash-desk.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.10.3: the desk's amounts, typed in major units, as the server takes
// them, and the custody's direction in each currency.
const custody: DeskCustody = {
  id: '01900000-0000-7000-8000-0000000000a1',
  name: 'كابتن',
  status: 'active',
  usage: { amount: '41000', currency: 'TRY' },
  limit: { amount: '300000', currency: 'TRY' },
  closedDue: { amount: '1000', currency: 'TRY' },
  lastCutoff: '2026-11-12T03:00:00.000Z',
  currencies: [
    { currency: 'TRY', balance: '41000', closedDue: '41000', today: '0', balanceInBase: '41000' },
    { currency: 'USD', balance: '-1000', closedDue: '-1000', today: '0', balanceInBase: '-40000' },
    { currency: 'SYP', balance: '0', closedDue: '0', today: '0', balanceInBase: '0' },
  ],
};
const [lira, dollar, pound] = custody.currencies as [
  DeskCustody['currencies'][number],
  DeskCustody['currencies'][number],
  DeskCustody['currencies'][number],
];

describe('the custody per currency', () => {
  it('hands in a positive balance, pays back a negative one, and has nothing at zero', () => {
    expect(directionOf(lira)).toBe('hand_in');
    expect(directionOf(dollar)).toBe('reimburse');
    expect(directionOf(pound)).toBe('none');
    expect(maximumOf(dollar)).toBe('1000');
  });

  it('says what stays open either way', () => {
    expect(remainingOf(lira, '40000')).toBe('1000');
    expect(remainingOf(dollar, '1000')).toBe('0');
    expect(remainingOf(dollar, '400')).toBe('-600');
  });
});

describe('the hand-in lines', () => {
  it('takes the typed currencies above zero', () => {
    expect(handInLinesOf({ TRY: '410', USD: '' }, custody)).toEqual({
      lines: [{ currency: 'TRY', amount: '41000' }],
    });
    expect(handInLinesOf({ TRY: '400', USD: '10' }, custody)).toEqual({
      lines: [
        { currency: 'TRY', amount: '40000' },
        { currency: 'USD', amount: '1000' },
      ],
    });
  });

  it('is nothing until an amount is typed, and names an amount typed wrongly or above the custody', () => {
    expect(handInLinesOf({}, custody)).toBeNull();
    expect(handInLinesOf({ TRY: '0' }, custody)).toBeNull();
    expect(handInLinesOf({ TRY: '410.5x' }, custody)).toEqual({
      currency: 'TRY',
      problem: 'invalid',
    });
    expect(handInLinesOf({ USD: '10.01' }, custody)).toEqual({ currency: 'USD', problem: 'above' });
    // A currency at zero takes nothing, whatever is typed.
    expect(handInLinesOf({ SYP: '5' }, custody)).toBeNull();
  });
});

describe('the float and the counted cash', () => {
  it('leaves an empty field out and names an amount typed wrongly', () => {
    expect(cashLinesOf({ TRY: '500' }, ['TRY', 'USD'])).toEqual({
      lines: [{ currency: 'TRY', amount: '50000' }],
    });
    expect(cashLinesOf({ USD: '1,5' }, ['TRY', 'USD'])).toEqual({ problem: 'USD' });
  });
});
