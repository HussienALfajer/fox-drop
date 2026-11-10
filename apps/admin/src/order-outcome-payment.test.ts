import { describe, expect, it, vi } from 'vitest';
import {
  canRecordOutcomePayment,
  emptyOutcomePayment,
  outcomePaymentBody,
} from './order-outcome-payment.js';

vi.mock('./api.js', () => ({ api: {} }));

const due = { amount: '5000', currency: 'TRY' };

// AP §9.3.2, CA §9.10 (K9): operations enter the payment of an amount to
// collect while the outcome waits for it.
describe('canRecordOutcomePayment', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs operations.manage and an outcome waiting for its collection', () => {
    const waiting = { outcome: { awaitingCollection: true } } as never;
    expect(canRecordOutcomePayment(session(['operations.manage']), waiting)).toBe(true);
    expect(canRecordOutcomePayment(session(['operations.read']), waiting)).toBe(false);
    expect(
      canRecordOutcomePayment(session(['operations.manage']), {
        outcome: { awaitingCollection: false },
      } as never),
    ).toBe(false);
    expect(canRecordOutcomePayment(session(['operations.manage']), { outcome: null })).toBe(false);
  });
});

describe('outcomePaymentBody', () => {
  it('waits for an amount received and the reason', () => {
    expect(outcomePaymentBody(emptyOutcomePayment, due)).toBeNull();
    expect(outcomePaymentBody({ ...emptyOutcomePayment, received: '50' }, due)).toBeNull();
    expect(
      outcomePaymentBody({ ...emptyOutcomePayment, received: '5x', reason: 'بلا هاتف' }, due),
    ).toBeNull();
  });

  it('sends the lines in the base currency, the change and the shortfall reason', () => {
    expect(
      outcomePaymentBody(
        { ...emptyOutcomePayment, received: '60', change: '10', reason: ' بلا هاتف ' },
        due,
      ),
    ).toEqual({
      received: [{ currency: 'TRY', amount: '6000' }],
      change: [{ currency: 'TRY', amount: '1000' }],
      amountDue: due,
      shortfall: null,
      reason: 'بلا هاتف',
    });
    expect(
      outcomePaymentBody(
        {
          ...emptyOutcomePayment,
          received: '40',
          shortfall: 'customer_short',
          reason: 'بلا هاتف',
        },
        due,
      ),
    ).toMatchObject({ change: [], shortfall: { reason: 'customer_short', note: null } });
  });
});
