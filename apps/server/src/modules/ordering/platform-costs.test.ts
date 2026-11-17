import { describe, expect, it } from 'vitest';
import { FEE_LOWERED_AFTER_PICKUP_REASON, REMOVED_AFTER_PICKUP_REASON } from './order-edits.js';
import { CHARGE_RETURNED_REASON, FEE_CUT_RETURNED_REASON, PAY_OFFSET_REASON } from './outcome.js';
import { type CostOrder, operatingCostCause } from './platform-costs.js';
import { SHORTFALL_REASON } from './shortfall.js';

// AP §9.10.6 (slice 2.22d): what an entry on platform.operating_cost was
// for, and the party operations named responsible for it.

const order = (overrides: Partial<CostOrder> = {}): CostOrder => ({
  restaurantId: '0190f3a0-0000-7000-8000-00000000b001',
  status: 'delivered',
  cancelResponsible: null,
  outcome: 'normal',
  outcomeResponsible: null,
  promoCodeId: null,
  promoCode: null,
  ...overrides,
});

describe('operatingCostCause', () => {
  it('names a shortfall the platform bears, whatever the order became', () => {
    expect(operatingCostCause('platform.operating_cost', SHORTFALL_REASON, order())).toEqual({
      cause: 'shortfall',
      responsible: 'platform',
    });
  });

  it('names an edit after the pickup the platform bears, and what an outcome gave back of it', () => {
    const failed = order({
      status: 'failed',
      outcome: 'damaged',
      outcomeResponsible: 'restaurant',
    });
    for (const reason of [
      REMOVED_AFTER_PICKUP_REASON,
      FEE_LOWERED_AFTER_PICKUP_REASON,
      CHARGE_RETURNED_REASON,
      FEE_CUT_RETURNED_REASON,
    ]) {
      expect(operatingCostCause('platform.operating_cost', reason, failed)).toEqual({
        cause: 'edit_after_pickup',
        responsible: 'platform',
      });
    }
  });

  it('splits a cancelled order into the food prepared and the captain’s compensation, by the cancellation’s party', () => {
    const cancelled = order({ status: 'cancelled', outcome: null, cancelResponsible: 'customer' });
    expect(operatingCostCause('platform.operating_cost', null, cancelled)).toEqual({
      cause: 'cancelled_prepared',
      responsible: 'customer',
    });
    expect(operatingCostCause('earn.order_pay', null, cancelled)).toEqual({
      cause: 'captain_compensation',
      responsible: 'customer',
    });
  });

  it('names an outcome’s loss and pay by the outcome and its party', () => {
    const failed = order({
      status: 'failed',
      outcome: 'wrong_refused',
      outcomeResponsible: 'restaurant',
    });
    for (const [type, reason] of [
      ['platform.operating_cost', null],
      ['earn.order_pay', null],
      ['earn.waiting_pay', null],
      ['platform.operating_cost', PAY_OFFSET_REASON],
    ] as const) {
      expect(operatingCostCause(type, reason, failed)).toEqual({
        cause: 'wrong_refused',
        responsible: 'restaurant',
      });
    }
  });

  it('answers other for an order it cannot place', () => {
    expect(operatingCostCause('platform.operating_cost', null, undefined)).toEqual({
      cause: 'other',
      responsible: null,
    });
    expect(operatingCostCause('platform.operating_cost', null, order())).toEqual({
      cause: 'other',
      responsible: null,
    });
  });
});
