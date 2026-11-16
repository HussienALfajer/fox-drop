import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { SettingsService } from '../settings/index.js';
import { ActiveOrders } from './active-orders.js';
import {
  app,
  sql,
  azaz,
  bySystem,
  admin,
  quoteFor,
  outboxReason,
  customerOrder,
  pickedUpOrder,
  balances,
  duesOf,
  moneyMoved,
  oneShawarma,
  orderRow,
  previewLines,
  outcomePayment,
  outcomeRows,
} from './order-edits.fixture.js';

// AP §8.9 «Changing an outcome», AP §9.3.2 «تغيير النتيجة» (slice 2.11c;
// owner decisions 2026-11-10). The order of pickedUpOrder: items 24000, fee
// 4000, commission 3600, merchant net 20400; the captain's pay 2500.
describe('POST /v1/admin/orders/{orderId}/outcome-change (AP §8.9)', () => {
  const fake = {
    outcome: 'fake',
    responsible: 'customer',
    delivered: false,
    food: 'kept_by_captain',
  };
  const otherByPlatform = { ...fake, outcome: 'failed_other', responsible: 'platform' };

  it('changes a fake order to failed_other with the platform responsible: the customer is unblocked', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    expect((await order.ops.outcome(order.order.id, fake)).statusCode).toBe(200);
    const customerId = (await orderRow(order.order.id)).customer_account_id;
    expect(await duesOf(customerId)).toBe(24_400n);
    const own = await admin(['OWN']);
    expect((await own.detail(order.order.id)).outcomeChange).toMatchObject({
      foods: [
        { code: 'kept_by_captain' },
        { code: 'returned_to_restaurant' },
        { code: 'destroyed' },
      ],
    });
    // The same preview: the fake outcome's entries reversed, then the new ones.
    const preview = await own.outcomeChangePreview(order.order.id, otherByPlatform);
    expect(preview.statusCode).toBe(200);
    expect(previewLines(preview.json().reversed)).toEqual([
      ['merchant.commission', 'merchant.account', '-3600'],
      ['merchant.commission', 'platform.order_clearing', '3600'],
      ['dues.charge', 'customer.dues', '-24400'],
      ['dues.charge', 'platform.order_clearing', '20400'],
      ['dues.charge', 'platform.revenue_delivery', '4000'],
      ['earn.order_pay', 'captain.earnings', '2500'],
      ['earn.order_pay', 'platform.captain_pay', '-2500'],
    ]);
    expect(previewLines(preview.json().entries)).toEqual([
      ['merchant.commission', 'merchant.account', '3600'],
      ['merchant.commission', 'platform.order_clearing', '-3600'],
      ['platform.operating_cost', 'platform.operating_cost', '20400'],
      ['platform.operating_cost', 'platform.order_clearing', '-20400'],
      ['earn.order_pay', 'captain.earnings', '-2500'],
      ['earn.order_pay', 'platform.operating_cost', '2500'],
    ]);
    expect(preview.json()).toMatchObject({ status: 'failed', dues: null });
    expect(preview.json().reversed[2].party).toMatchObject({ kind: 'customer', id: customerId });
    const answer = await own.outcomeChange(order.order.id, otherByPlatform);
    expect(answer.statusCode).toBe(200);
    expect(await orderRow(order.order.id)).toMatchObject({
      status: 'failed',
      outcome: 'failed_other',
    });
    // Every entry of the fake outcome reversed: no dues, no block.
    expect(await duesOf(customerId)).toBe(0n);
    const quote = (await quoteFor(order.order.customer)).json();
    expect(quote.problems.map((problem: { code: string }) => problem.code)).not.toContain(
      'dues_unpaid',
    );
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      restaurant: -3_600n,
      commission: 0n,
      delivery: 0n,
      captainPay: 0n,
      operatingCost: 20_400n + 2_500n,
      earnings: 2_500n,
    });
    // The history: the fake outcome kept, replaced by the new one.
    const [old, current] = await outcomeRows(order.order.id);
    expect(old).toMatchObject({ outcome: 'fake', dues: '24400' });
    expect(old.replaced_at).not.toBeNull();
    expect(current).toMatchObject({
      outcome: 'failed_other',
      responsible: 'platform',
      replaced_at: null,
      replaces_id: old.id,
      dues: null,
      note: 'راجعنا التسجيلات',
      customer_text: 'تعذّر الوصول إليك أو إلى العنوان',
    });
    expect(await outboxReason(order.order.id, 'order.outcome_changed')).toBe('failed_other');
    const detail = await own.detail(order.order.id);
    expect(detail.outcome).toMatchObject({ outcome: 'failed_other', dues: null });
    expect(detail.outcome.history).toMatchObject([
      { outcome: 'fake', responsible: 'customer', note: 'اتصلنا بالزبون' },
    ]);
    expect((await customerOrder(order.order.customer, order.order.id)).outcome).toMatchObject({
      outcome: 'failed_other',
      text: 'تعذّر الوصول إليك أو إلى العنوان',
    });
    // The captain's pay did not move: the card the captain has not yet
    // acknowledged stays, now with the outcome in force.
    expect((await order.captain.active()).json().ended).toMatchObject({
      outcome: 'failed_other',
      pay: { amount: '2500', currency: 'TRY' },
    });
  });

  it('restores the trust a fake outcome removed (D23)', async () => {
    const settings = app.get(SettingsService);
    await settings.update('customer.trusted_after_delivered_orders', { cityId: azaz }, 1, bySystem);
    try {
      const first = await pickedUpOrder();
      expect((await first.arriveAtCustomer()).statusCode).toBe(200);
      expect((await first.deliver('28000')).statusCode).toBe(200);
      const customerId = (await orderRow(first.order.id)).customer_account_id;
      const limit = async () =>
        app.get(ActiveOrders).customer(customerId, await app.get(ActiveOrders).rules(azaz));
      const second = await pickedUpOrder(first.order.customer);
      expect((await second.ops.outcome(second.order.id, fake)).statusCode).toBe(200);
      expect((await limit()).trusted).toBe(false);
      const own = await admin(['OWN']);
      expect((await own.outcomeChange(second.order.id, otherByPlatform)).statusCode).toBe(200);
      expect((await limit()).trusted).toBe(true);
    } finally {
      await settings.update(
        'customer.trusted_after_delivered_orders',
        { cityId: azaz },
        3,
        bySystem,
      );
    }
  });

  it('turns a failed order delivered and back, as often as needed, the status following', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    const own = await admin(['OWN']);
    const refused = {
      outcome: 'wrong_refused',
      responsible: 'restaurant',
      delivered: false,
      food: 'returned_to_restaurant',
    };
    expect((await order.ops.outcome(order.order.id, refused)).statusCode).toBe(200);
    // Delivered for free after all, the platform bearing it.
    const free = { outcome: 'free', responsible: 'platform', delivered: true, food: null };
    expect((await own.outcomeChange(order.order.id, free)).statusCode).toBe(200);
    const delivered = await orderRow(order.order.id);
    expect(delivered).toMatchObject({ status: 'delivered', outcome: 'free' });
    expect(delivered.delivered_at).not.toBeNull();
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      restaurant: -3_600n,
      operatingCost: 20_400n + 2_500n,
      earnings: 2_500n,
    });
    // Then damaged on the way, the captain responsible: charged, no pay.
    const damaged = {
      outcome: 'damaged',
      responsible: 'captain',
      delivered: false,
      food: 'destroyed',
    };
    expect((await own.outcomeChange(order.order.id, damaged)).statusCode).toBe(200);
    expect(await orderRow(order.order.id)).toMatchObject({
      status: 'failed',
      outcome: 'damaged',
      delivered_at: null,
    });
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      restaurant: -3_600n,
      operatingCost: 0n,
      earnings: -20_400n,
    });
    expect((await outcomeRows(order.order.id)).map((row) => row.outcome)).toEqual([
      'wrong_refused',
      'free',
      'damaged',
    ]);
    // The captain's money moved: the card shows the charge.
    expect((await order.captain.active()).json().ended).toMatchObject({
      outcome: 'damaged',
      pay: null,
      charge: { amount: '20400', currency: 'TRY' },
    });
  });

  it('keeps an amount collected: only a delivered outcome may follow', async () => {
    const order = await pickedUpOrder();
    const before = await balances(order.captain.captainId);
    const free = {
      outcome: 'free',
      responsible: 'platform',
      delivered: true,
      food: null,
      amountToCollect: '5000',
    };
    expect((await order.ops.outcome(order.order.id, free)).statusCode).toBe(200);
    expect((await outcomePayment(order, 'captain', { received: '5000' })).statusCode).toBe(200);
    const own = await admin(['OWN']);
    // Failed is refused: the customer paid.
    const failed = await own.outcomeChange(order.order.id, otherByPlatform);
    expect(failed.statusCode).toBe(400);
    expect(failed.json().error).toBe('invalid_outcome');
    const damaged = { outcome: 'damaged', responsible: 'restaurant', delivered: true, food: null };
    expect((await own.outcomeChange(order.order.id, damaged)).statusCode).toBe(200);
    // As 2.11b's restaurant case with the whole 50 collected: the 50 pays the
    // captain's 25 and books 25 as delivery revenue; the collection stays.
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: -24_000n,
      restaurant: -24_000n,
      delivery: 2_500n,
      operatingCost: 0n,
      earnings: 2_500n,
    });
    const current = (await outcomeRows(order.order.id)).at(-1);
    expect(current).toMatchObject({ amount_to_collect: '5000', merchant_debit: '24000' });
    expect(current.collected_at).not.toBeNull();
    expect((await own.detail(order.order.id)).delivery).toMatchObject({
      netReceived: { amount: '5000', currency: 'TRY' },
    });
  });

  it('refuses OPS, the same outcome, a stale preview, an order without an outcome and after the days', async () => {
    const order = await pickedUpOrder();
    expect((await order.ops.outcome(order.order.id, fake)).statusCode).toBe(200);
    // OWN only (orders.change_outcome).
    expect((await order.ops.outcomeChange(order.order.id, otherByPlatform)).statusCode).toBe(403);
    expect((await order.ops.outcomeChangePreview(order.order.id, otherByPlatform)).statusCode).toBe(
      403,
    );
    expect((await order.ops.detail(order.order.id)).outcomeChange).not.toBeNull();
    const own = await admin(['OWN']);
    const same = await own.outcomeChange(order.order.id, fake);
    expect(same.statusCode).toBe(400);
    expect(same.json().error).toBe('invalid_outcome');
    const stale = await own.outcomeChange(order.order.id, { ...otherByPlatform, version: 1 });
    expect(stale.statusCode).toBe(409);
    expect(stale.json().error).toBe('order_state_changed');
    // A normal delivery has no outcome to change.
    const normal = await pickedUpOrder();
    expect((await normal.arriveAtCustomer()).statusCode).toBe(200);
    expect((await normal.deliver('28000')).statusCode).toBe(200);
    const none = await own.outcomeChange(normal.order.id, otherByPlatform);
    expect(none.statusCode).toBe(409);
    expect(none.json().error).toBe('outcome_change_closed');
    expect((await own.detail(normal.order.id)).outcomeChange).toBeNull();
    // An order still picked up is not finished.
    const active = await pickedUpOrder();
    expect((await own.outcomeChange(active.order.id, otherByPlatform)).json().error).toBe(
      'order_state_changed',
    );
    // Past order.outcome_change_days of the first outcome.
    const settings = app.get(SettingsService);
    await settings.update('order.outcome_change_days', { cityId: azaz }, 0, bySystem);
    try {
      const closed = await own.outcomeChange(order.order.id, otherByPlatform);
      expect(closed.statusCode).toBe(409);
      expect(closed.json().error).toBe('outcome_change_closed');
      expect((await own.detail(order.order.id)).outcomeChange).toBeNull();
    } finally {
      await settings.update('order.outcome_change_days', { cityId: azaz }, 7, bySystem);
    }
    expect((await outcomeRows(order.order.id)).length).toBe(1);
  });
});

// The money paths a change crosses (slice 2.11c review): an edit after the
// pickup, a short collection, a repeated key, and the captain's card after
// an old collection.
describe('«تغيير النتيجة» across edits, collections and repeats (AP §8.9)', () => {
  const platform = {
    outcome: 'failed_other',
    responsible: 'platform',
    delivered: false,
    food: 'kept_by_captain',
  };
  const byRestaurant = { ...platform, responsible: 'restaurant', food: 'destroyed' };

  it('books after an edit after the pickup as if the new outcome had been set: nobody pays twice', async () => {
    const own = await admin(['OWN']);
    // Directly: the restaurant's edit, then the platform responsible.
    const before = await balances();
    const direct = await pickedUpOrder();
    expect(
      (await direct.ops.edit(direct.order.id, { ...oneShawarma, responsible: 'restaurant' }))
        .statusCode,
    ).toBe(200);
    expect((await direct.ops.outcome(direct.order.id, platform)).statusCode).toBe(200);
    const directMoved = moneyMoved(before, await balances());
    // Changed: the same edit, the restaurant responsible, then the platform.
    const middle = await balances();
    const changed = await pickedUpOrder();
    expect(
      (await changed.ops.edit(changed.order.id, { ...oneShawarma, responsible: 'restaurant' }))
        .statusCode,
    ).toBe(200);
    expect((await changed.ops.outcome(changed.order.id, byRestaurant)).statusCode).toBe(200);
    expect((await own.outcomeChange(changed.order.id, platform)).statusCode).toBe(200);
    expect(moneyMoved(middle, await balances())).toEqual(directMoved);
    expect(directMoved.clearing).toBe(0n);
  });

  it('keeps a collection shortfall on the clearing account once', async () => {
    const order = await pickedUpOrder();
    const before = await balances(order.captain.captainId);
    const free = {
      outcome: 'free',
      responsible: 'platform',
      delivered: true,
      food: null,
      amountToCollect: '5000',
    };
    expect((await order.ops.outcome(order.order.id, free)).statusCode).toBe(200);
    const paid = await outcomePayment(order, 'ops', {
      received: '4000',
      due: '5000',
      shortfall: { reason: 'customer_short', note: null },
    });
    expect(paid.statusCode).toBe(200);
    const own = await admin(['OWN']);
    const damaged = { outcome: 'damaged', responsible: 'restaurant', delivered: true, food: null };
    expect((await own.outcomeChange(order.order.id, damaged)).statusCode).toBe(200);
    // As «تحديد النتيجة» of the same outcome with the same short payment.
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: -24_000n + 1_000n,
      restaurant: -24_000n,
      delivery: 2_500n,
      operatingCost: 0n,
      earnings: 2_500n,
    });
  });

  it('answers a repeated key with the first change, posting nothing more', async () => {
    const order = await pickedUpOrder();
    const fake = { ...platform, outcome: 'fake', responsible: 'customer' };
    expect((await order.ops.outcome(order.order.id, fake)).statusCode).toBe(200);
    const own = await admin(['OWN']);
    const key = randomUUID();
    // The retry sends the body the dialog sent, with the version it previewed.
    const body = { ...platform, version: (await own.detail(order.order.id)).version };
    const first = await own.outcomeChange(order.order.id, body, key);
    expect(first.statusCode).toBe(200);
    const after = await balances(order.captain.captainId);
    const repeat = await own.outcomeChange(order.order.id, body, key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order.version).toBe(first.json().order.version);
    expect(moneyMoved(after, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      restaurant: 0n,
      operatingCost: 0n,
      earnings: 0n,
    });
    expect((await outcomeRows(order.order.id)).length).toBe(2);
  });

  it("shows the captain's card again for a change long after the collection", async () => {
    const order = await pickedUpOrder();
    const free = {
      outcome: 'free',
      responsible: 'platform',
      delivered: true,
      food: null,
      amountToCollect: '5000',
    };
    expect((await order.ops.outcome(order.order.id, free)).statusCode).toBe(200);
    expect((await outcomePayment(order, 'captain', { received: '5000' })).statusCode).toBe(200);
    await sql.query(
      "UPDATE ordering.order_outcomes SET collected_at = collected_at - interval '13 hours' WHERE order_id = $1",
      [order.order.id],
    );
    const own = await admin(['OWN']);
    // The captain is now responsible: charged, no pay.
    const byCaptain = { ...free, responsible: 'captain' };
    delete (byCaptain as { amountToCollect?: string }).amountToCollect;
    expect((await own.outcomeChange(order.order.id, byCaptain)).statusCode).toBe(200);
    expect((await order.captain.active()).json().ended).toMatchObject({
      orderId: order.order.id,
      outcome: 'free',
      pay: null,
      charge: { amount: '15400', currency: 'TRY' },
    });
  });
});
