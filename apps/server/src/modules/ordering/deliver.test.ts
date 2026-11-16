import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import pg from 'pg';
import { describe, expect, it } from 'vitest';
import { OrdersService } from './orders.service.js';
import {
  database,
  app,
  sql,
  azaz,
  restaurant,
  onlineCaptain,
  TRY,
  eventTypes,
  atCustomer,
  farFromCustomer,
  pickedUpOrder,
  platform,
  owned,
  platformNow,
  delta,
  orderAtDoor,
  deliveryRow,
  collectionRow,
  peakNow,
} from './delivery.fixture.js';

describe('POST /v1/captain/orders/{orderId}/deliver (CA §9.7–9.8)', () => {
  it('delivers with outcome normal, books the money and answers the summary', async () => {
    const door = await orderAtDoor();
    const before = await platformNow();
    const restaurantBefore = await owned(restaurant, 'merchant.account');
    const answer = await door.deliver();
    expect(answer.statusCode).toBe(200);
    // Items 2 × 120, fee 40, total 280 TRY; a trip within the 3 km.
    expect(answer.json().summary).toMatchObject({
      orderId: door.order.id,
      pay: {
        base: '2500',
        distance: '0',
        topUp: '0',
        waiting: '0',
        total: '2500',
        currency: 'TRY',
      },
      custodyChange: { amount: '4000', currency: 'TRY' },
      handInToday: { amount: '4000', currency: 'TRY' },
    });
    expect(await deliveryRow(door.order.id)).toMatchObject({
      status: 'delivered',
      captain_track: 'done',
      outcome: 'normal',
    });
    const [collection] = await collectionRow(door.order.id);
    expect(collection).toMatchObject({
      amount_due: '28000',
      net_received: '28000',
      shortfall: '0',
      shortfall_reason: null,
      recorded_by_type: 'captain',
      recorded_by_id: door.captain.captainId,
    });
    // AP §8.5: the captain's custody keeps the 40 gained, the pay is owed.
    expect(await owned(door.captain.captainId, 'captain.custody')).toBe(4_000n);
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(2_500n);
    // CA §10.6 «أرباحي» (slice 2.18b): the pay by part, as recorded.
    expect(await app.get(OrdersService).payParts([door.order.id, randomUUID()])).toEqual(
      new Map([
        [
          door.order.id,
          { basePay: 2_500n, distancePay: 0n, topUpPay: 0n, waitingPay: 0n, peakBonus: 0n },
        ],
      ]),
    );
    // AP §8.7: the restaurant owes its 15% commission on 240.
    expect((await owned(restaurant, 'merchant.account')) - restaurantBefore).toBe(-3_600n);
    // The order's clearing returns to zero; the fee, commission and pay land.
    expect(delta(before, await platformNow())).toEqual({
      'platform.order_clearing': -24_000n, // the pickup's +240 settled
      'platform.revenue_delivery': 4_000n,
      'platform.revenue_commission': 3_600n,
      'platform.captain_pay': 2_500n,
      'platform.fx_rounding': 0n,
    });
    // The captain is free: no active order, the customer sees «تم التسليم».
    expect((await door.captain.active()).json().order).toBeNull();
    const events = await eventTypes(door.order.id);
    expect(events.at(-1)).toEqual({ type: 'order.delivered', reason: null });
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.delivered'",
      [door.order.id],
    );
    expect(outbox.rows[0].payload).toMatchObject({ status: 'delivered', reason: null });
  });

  // CA §7.3, §7.5 (slice 2.13a): «لا أريد طلبات جديدة» ends with the
  // delivery; the state read after it is offline with the cash to hand in.
  it('takes a captain in last-order mode offline with the delivery', async () => {
    const door = await orderAtDoor();
    const on = await app.inject({
      method: 'POST',
      url: '/v1/captain/availability/last-order',
      headers: door.captain.headers,
      payload: { on: true },
    });
    expect(on.json().availability.state).toBe('last_order');
    expect((await door.deliver()).statusCode).toBe(200);
    const state = await app.inject({
      method: 'GET',
      url: '/v1/captain/availability',
      headers: door.captain.headers,
    });
    expect(state.json().availability.state).toBe('offline');
    expect(state.json().custody).toMatchObject({
      usage: { amount: '4000', currency: 'TRY' },
      remitTolerance: { amount: '0', currency: 'TRY' },
    });
  });

  it('shows the customer what was received and given back (CU §11.8, Q23)', async () => {
    const door = await orderAtDoor();
    const answer = await door.deliver({ received: TRY('30000'), change: TRY('2000') });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().summary.custodyChange.amount).toBe('4000');
    const customerId = (
      await sql.query('SELECT customer_account_id FROM ordering.orders WHERE id = $1', [
        door.order.id,
      ])
    ).rows[0].customer_account_id;
    const view = await app.get(OrdersService).customerOrder(customerId, door.order.id);
    expect(view?.delivery).toMatchObject({
      outcome: 'normal',
      received: [{ currency: 'TRY', amount: 30_000n }],
      change: [{ currency: 'TRY', amount: 2_000n }],
      netReceived: 28_000n,
      shortfall: null,
    });
    // The custody holds the 300 received less the 20 given back and the 240.
    expect(await owned(door.captain.captainId, 'captain.custody')).toBe(4_000n);
  });

  it('books a gap within rounding to platform.fx_rounding', async () => {
    const door = await orderAtDoor();
    const before = await platformNow();
    // 2.50 TRY short, within half the 5 TRY unit.
    expect((await door.deliver({ received: TRY('27750') })).statusCode).toBe(200);
    const moved = delta(before, await platformNow());
    expect(moved['platform.order_clearing']).toBe(-24_000n);
    expect(moved['platform.fx_rounding']).toBe(-250n); // a loss of 2.50 for the platform
  });

  it('needs a reason for a shortfall, which stays open in the clearing account', async () => {
    const door = await orderAtDoor();
    const missing = await door.deliver({ received: TRY('25000') });
    expect(missing.statusCode).toBe(409);
    expect(missing.json()).toMatchObject({
      error: 'shortfall_reason_required',
      shortfall: { amount: '3000', currency: 'TRY' },
    });
    const before = await platformNow();
    const answer = await door.deliver({
      received: TRY('25000'),
      shortfall: { reason: 'customer_short', note: null },
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().summary.custodyChange.amount).toBe('1000');
    // AP §8.6: the missing 30 waits in the clearing account for operations.
    expect(delta(before, await platformNow())['platform.order_clearing']).toBe(-21_000n);
    const detail = (await door.ops.get(`/v1/admin/orders/${door.order.id}`)).json().order;
    expect(detail.delivery).toMatchObject({
      outcome: 'normal',
      received: TRY('25000'),
      change: [],
      netReceived: { amount: '25000', currency: 'TRY' },
      shortfall: {
        amount: { amount: '3000', currency: 'TRY' },
        reason: 'customer_short',
        label: 'الزبون لا يملك المبلغ كاملاً',
        note: null,
      },
      recordedBy: { type: 'captain', id: door.captain.captainId, reason: null },
    });
    const list = (await door.ops.get(`/v1/admin/orders/shortfalls?cityId=${azaz}`)).json();
    expect(
      list.shortfalls.find((each: { orderId: string }) => each.orderId === door.order.id),
    ).toMatchObject({
      captainId: door.captain.captainId,
      amountDue: { amount: '28000', currency: 'TRY' },
      netReceived: { amount: '25000', currency: 'TRY' },
      shortfall: { amount: '3000', currency: 'TRY' },
      reason: 'customer_short',
      label: 'الزبون لا يملك المبلغ كاملاً',
    });
  });

  it("refuses another captain's delivery with unknown_order", async () => {
    const door = await orderAtDoor();
    const other = await onlineCaptain();
    const answer = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${door.order.id}/deliver`,
      headers: { ...other.headers, 'idempotency-key': randomUUID() },
      payload: {
        received: TRY('28000'),
        change: [],
        amountDue: { amount: '28000', currency: 'TRY' },
        shortfall: null,
        away: null,
        location: {
          ...atCustomer,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });
    expect(answer.statusCode).toBe(404);
  });

  it("books a test order's pay to platform.test_cost, with no commission (AP §9.6.3)", async () => {
    const door = await orderAtDoor();
    await sql.query('UPDATE ordering.orders SET test_order = true WHERE id = $1', [door.order.id]);
    const testCost = await platform('platform.test_cost');
    const before = await platformNow();
    const restaurantBefore = await owned(restaurant, 'merchant.account');
    expect((await door.deliver()).statusCode).toBe(200);
    expect((await platform('platform.test_cost')) - testCost).toBe(2_500n);
    const moved = delta(before, await platformNow());
    expect(moved['platform.revenue_commission']).toBe(0n);
    expect(moved['platform.captain_pay']).toBe(0n);
    expect(moved['platform.order_clearing']).toBe(-24_000n);
    expect((await owned(restaurant, 'merchant.account')) - restaurantBefore).toBe(0n);
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(2_500n);
  });

  it('refuses a net above the amount due, and a stale amount due', async () => {
    const door = await orderAtDoor();
    const over = await door.deliver({ received: TRY('30000') });
    expect(over.statusCode).toBe(409);
    expect(over.json().error).toBe('overpaid');
    const stale = await door.deliver({ amountDue: '27000', received: TRY('27000') });
    expect(stale.statusCode).toBe(409);
    expect(stale.json().error).toBe('amount_due_changed');
    expect(stale.json().order.collect).toEqual({ amount: '28000', currency: 'TRY' });
    const otherCurrency = await door.deliver({ amountDueCurrency: 'USD' });
    expect(otherCurrency.json().error).toBe('amount_due_changed');
    const huge = await door.deliver({ received: TRY('1234567890123456') });
    expect(huge.statusCode).toBe(400);
    const odd = await door.deliver({ received: [{ currency: 'EUR', amount: '1000' }] });
    expect(odd.json().error).toBe('currency_not_accepted');
    const repeated = await door.deliver({ received: [...TRY('14000'), ...TRY('14000')] });
    expect(repeated.statusCode).toBe(400);
    expect((await deliveryRow(door.order.id)).status).toBe('arrived');
    expect(await collectionRow(door.order.id)).toHaveLength(0);
  });

  it('needs a reason away from the pin, unless one was given at the arrival (K4)', async () => {
    const near = await orderAtDoor();
    const far = await near.deliver({}, farFromCustomer);
    expect(far.statusCode).toBe(409);
    expect(far.json().error).toBe('too_far_from_customer');
    const withReason = await near.deliver(
      { away: { reason: 'customer_requested_other_place', note: null } },
      farFromCustomer,
    );
    expect(withReason.statusCode).toBe(200);
    expect((await deliveryRow(near.order.id)).away_reason).toBe('customer_requested_other_place');

    const awayAtArrival = await orderAtDoor({ away: { reason: 'pin_inaccurate', note: null } });
    expect((await awayAtArrival.deliver({}, farFromCustomer)).statusCode).toBe(200);
    expect((await deliveryRow(awayAtArrival.order.id)).away_reason).toBe('pin_inaccurate');
  });

  it('refuses before the arrival at the door, and answers a repeat of the key once', async () => {
    const picked = await pickedUpOrder();
    const early = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${picked.order.id}/deliver`,
      headers: { ...picked.captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        received: TRY('28000'),
        change: [],
        amountDue: { amount: '28000', currency: 'TRY' },
        shortfall: null,
        away: null,
        location: {
          ...atCustomer,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');

    const door = await orderAtDoor();
    const key = randomUUID();
    const first = await door.deliver({}, atCustomer, key);
    const again = await door.deliver({}, atCustomer, key);
    expect(again.statusCode).toBe(200);
    expect(again.json().summary).toEqual(first.json().summary);
    expect(await collectionRow(door.order.id)).toHaveLength(1);
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(2_500n);
  });

  it('adds the peak bonus inside a window, matched on the restaurant zone (AP §9.12.5, D15)', async () => {
    const door = await orderAtDoor();
    const before = await platformNow();
    const end = await peakNow(500n);
    try {
      const answer = await door.deliver();
      expect(answer.statusCode).toBe(200);
      expect(answer.json().summary.pay).toMatchObject({
        base: '2500',
        peak: '500',
        total: '3000',
      });
      expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(3_000n);
      expect(delta(before, await platformNow())['platform.captain_pay']).toBe(3_000n);
      const [collection] = await collectionRow(door.order.id);
      expect(collection.peak_bonus).toBe('500');
      expect(collection.peak_bonus_version_id).not.toBeNull();
    } finally {
      await end();
    }
    // Outside a window: nothing more.
    const next = await orderAtDoor();
    expect((await next.deliver()).json().summary.pay).toMatchObject({ peak: '0', total: '2500' });
  });

  it('pays the waiting past the threshold apart from the order pay (docs/domain/04)', async () => {
    const door = await orderAtDoor();
    // The pay table pays 1 TRY a minute of waiting; the captain waited 30
    // minutes at the restaurant, arriving 10 minutes after the food was due.
    const migrator = new pg.Client({ connectionString: database.migratorUrl });
    await migrator.connect();
    try {
      await migrator.query(
        'UPDATE captains.pay_rates SET waiting_per_minute = 100 WHERE table_id = (SELECT pay_table_id FROM ordering.orders WHERE id = $1)',
        [door.order.id],
      );
    } finally {
      await migrator.end();
    }
    await sql.query(
      `UPDATE ordering.orders SET
         accepted_at = picked_up_at - interval '60 minutes',
         arrived_at_merchant_at = picked_up_at - interval '30 minutes',
         captain_waiting_alert_at = picked_up_at - interval '20 minutes'
       WHERE id = $1`,
      [door.order.id],
    );
    const answer = await door.deliver();
    expect(answer.statusCode).toBe(200);
    // Due 40 minutes before the pickup, arrived 30 before: paid from 20 before.
    expect(answer.json().summary.pay).toMatchObject({
      base: '2500',
      waiting: '2000',
      total: '4500',
    });
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(4_500n);
    expect((await collectionRow(door.order.id))[0].waiting_minutes).toBe(20);
  });
});
