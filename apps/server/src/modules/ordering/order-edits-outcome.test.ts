import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { SettingsService } from '../settings/index.js';
import { ActiveOrders } from './active-orders.js';
import {
  app,
  azaz,
  bySystem,
  admin,
  quoteFor,
  acceptedOrder,
  onlineCaptain,
  outboxReason,
  customerOrder,
  pickedUpOrder,
  balances,
  duesOf,
  moneyMoved,
  oneShawarma,
  outcomeRow,
  orderRow,
  previewLines,
  outcomePayment,
} from './order-edits.fixture.js';

// The order of pickedUpOrder: items 24000, fee 4000, commission 15 % 3600,
// merchant net 20400; the captain's pay 2500.
describe('POST /v1/admin/orders/{orderId}/outcome (AP §9.3.2, §8.9)', () => {
  const fake = {
    outcome: 'fake',
    responsible: 'customer',
    delivered: false,
    food: 'kept_by_captain',
  };

  it('fails a fake order: the entries match the preview, and the customer owes and is blocked', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    const preview = await order.ops.outcomePreview(order.order.id, fake);
    expect(preview.statusCode).toBe(200);
    const expected = [
      ['merchant.commission', 'merchant.account', '3600'],
      ['merchant.commission', 'platform.order_clearing', '-3600'],
      ['dues.charge', 'customer.dues', '24400'],
      ['dues.charge', 'platform.order_clearing', '-20400'],
      ['dues.charge', 'platform.revenue_delivery', '-4000'],
      ['earn.order_pay', 'captain.earnings', '-2500'],
      ['earn.order_pay', 'platform.captain_pay', '2500'],
    ];
    expect(previewLines(preview.json().entries)).toEqual(expected);
    expect(preview.json()).toMatchObject({
      status: 'failed',
      loss: { amount: '20400' },
      dues: { amount: '24400' },
      captainPay: { amount: '2500' },
    });
    const key = randomUUID();
    const shownVersion = (await order.ops.detail(order.order.id)).version;
    const answer = await order.ops.outcome(order.order.id, { ...fake, version: shownVersion }, key);
    expect(answer.statusCode).toBe(200);
    const row = await orderRow(order.order.id);
    expect(row).toMatchObject({ status: 'failed', outcome: 'fake', captain_track: 'done' });
    expect(await outcomeRow(order.order.id)).toMatchObject({
      outcome: 'fake',
      responsible: 'customer',
      status: 'failed',
      food: 'kept_by_captain',
      loss: '20400',
      dues: '24400',
      merchant_debit: null,
      captain_pay: '2500',
      customer_text: 'لم يُستلم الطلب',
      note: 'اتصلنا بالزبون',
    });
    // AP §8.4's check: the platform recovers its costs, without its margin.
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      restaurant: -3_600n,
      commission: 0n,
      delivery: 4_000n,
      captainPay: 2_500n,
      earnings: 2_500n,
    });
    expect(await duesOf(row.customer_account_id)).toBe(24_400n);
    expect(await outboxReason(order.order.id, 'order.outcome_set')).toBe('fake');
    // The customer: «تعذّر التسليم» with the reason, then blocked at checkout.
    expect((await customerOrder(order.order.customer, order.order.id)).outcome).toMatchObject({
      outcome: 'fake',
      status: 'failed',
      text: 'لم يُستلم الطلب',
      amountToCollect: { amount: '0', currency: 'TRY' },
    });
    const quote = (await quoteFor(order.order.customer)).json();
    expect(quote.problems).toContainEqual({
      code: 'dues_unpaid',
      line: null,
      opensAt: null,
      message: null,
      amount: { amount: '24400', currency: 'TRY' },
      refusal: null,
    });
    // The captain is free, with the card until «حسناً».
    const active = (await order.captain.active()).json();
    expect(active.order).toBeNull();
    expect(active.ended).toMatchObject({
      orderId: order.order.id,
      outcome: 'fake',
      status: 'failed',
      food: 'kept_by_captain',
      pay: { amount: '2500', currency: 'TRY' },
      charge: null,
    });
    const seen = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.order.id}/acknowledge-outcome`,
      headers: order.captain.headers,
    });
    expect(seen.statusCode).toBe(200);
    expect(seen.json().ended).toBeNull();
    // The panel's detail.
    const detail = await order.ops.detail(order.order.id);
    expect(detail.outcome).toMatchObject({
      outcome: 'fake',
      responsible: 'customer',
      dues: { amount: '24400' },
      customerText: 'لم يُستلم الطلب',
    });
    expect(detail.outcomeChoices).toBeNull();
    // A repeat of the key answers the same; another outcome is refused.
    const repeat = await order.ops.outcome(order.order.id, { ...fake, version: shownVersion }, key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order.status).toBe('failed');
    expect((await order.ops.outcome(order.order.id, fake)).statusCode).toBe(409);
    // «حسناً» on another captain's order, or one without an outcome.
    const other = await onlineCaptain();
    const foreign = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.order.id}/acknowledge-outcome`,
      headers: other.headers,
    });
    expect(foreign.statusCode).toBe(404);
  });

  it('refuses «حسناً» on an order without an outcome', async () => {
    const order = await pickedUpOrder();
    const early = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.order.id}/acknowledge-outcome`,
      headers: order.captain.headers,
    });
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');
  });

  it('refuses an outcome previewed on an older version of the order', async () => {
    const order = await pickedUpOrder();
    const stale = (await order.ops.detail(order.order.id)).version;
    expect(
      (await order.ops.edit(order.order.id, { ...oneShawarma, responsible: 'platform' }))
        .statusCode,
    ).toBe(200);
    const answer = await order.ops.outcome(order.order.id, { ...fake, version: stale });
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('order_state_changed');
    expect(await outcomeRow(order.order.id)).toBeUndefined();
  });

  // docs/domain/08: a fake outcome removes the trust and starts the count
  // again (D23).
  it('removes the trust of a customer with a fake order', async () => {
    const settings = app.get(SettingsService);
    await settings.update('customer.trusted_after_delivered_orders', { cityId: azaz }, 1, bySystem);
    try {
      const first = await pickedUpOrder();
      expect((await first.arriveAtCustomer()).statusCode).toBe(200);
      expect((await first.deliver('28000')).statusCode).toBe(200);
      const customerId = (await orderRow(first.order.id)).customer_account_id;
      const limit = async () =>
        app.get(ActiveOrders).customer(customerId, await app.get(ActiveOrders).rules(azaz));
      expect((await limit()).trusted).toBe(true);
      const second = await pickedUpOrder(first.order.customer);
      expect((await second.ops.outcome(second.order.id, fake)).statusCode).toBe(200);
      expect((await limit()).trusted).toBe(false);
    } finally {
      await settings.update(
        'customer.trusted_after_delivered_orders',
        { cityId: azaz },
        3,
        bySystem,
      );
    }
  });

  it('has the restaurant return the pickup payment, and the food go back to it', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    const choices = {
      outcome: 'wrong_refused',
      responsible: 'restaurant',
      delivered: false,
      food: 'returned_to_restaurant',
    };
    const preview = await order.ops.outcomePreview(order.order.id, choices);
    expect(previewLines(preview.json().entries)).toEqual([
      ['merchant.debit', 'merchant.account', '24000'],
      ['merchant.debit', 'platform.order_clearing', '-24000'],
      ['earn.order_pay', 'captain.earnings', '-2500'],
      ['earn.order_pay', 'platform.operating_cost', '2500'],
    ]);
    expect(preview.json().entries[0].reason).toBe('استرداد مبلغ الاستلام');
    expect((await order.ops.outcome(order.order.id, choices)).statusCode).toBe(200);
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      restaurant: -24_000n,
      commission: 0n,
      operatingCost: 2_500n,
    });
    expect(await outcomeRow(order.order.id)).toMatchObject({ merchant_debit: '24000', loss: '0' });
  });

  it('counts an edit after the pickup: nobody pays twice (owner decision 2026-11-10)', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    expect(
      (await order.ops.edit(order.order.id, { ...oneShawarma, responsible: 'restaurant' }))
        .statusCode,
    ).toBe(200);
    const choices = {
      outcome: 'failed_other',
      responsible: 'restaurant',
      delivered: false,
      food: 'destroyed',
    };
    expect((await order.ops.outcome(order.order.id, choices)).statusCode).toBe(200);
    // The edit debited 12000 and reversed 1800; the outcome returns the
    // other 12000 and restores the 1800: the restaurant ends with nothing.
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      restaurant: -24_000n,
      commission: 0n,
    });
  });

  it('delivers a free order with the platform bearing the loss and the pay', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    const choices = { outcome: 'free', responsible: 'platform', delivered: true, food: null };
    expect((await order.ops.outcome(order.order.id, choices)).statusCode).toBe(200);
    const row = await orderRow(order.order.id);
    expect(row).toMatchObject({ status: 'delivered', outcome: 'free' });
    expect(row.delivered_at).not.toBeNull();
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      restaurant: -3_600n,
      operatingCost: 20_400n + 2_500n,
    });
    const seen = await customerOrder(order.order.customer, order.order.id);
    expect(seen.status).toBe('delivered');
    expect(seen.outcome).toMatchObject({ outcome: 'free', status: 'delivered', text: null });
  });

  it('charges the captain the loss without pay when the captain is responsible', async () => {
    // A new captain's earnings start at 0.
    const before = await balances();
    const order = await pickedUpOrder();
    const choices = {
      outcome: 'damaged',
      responsible: 'captain',
      delivered: false,
      food: 'destroyed',
    };
    expect((await order.ops.outcome(order.order.id, choices)).statusCode).toBe(200);
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      earnings: -20_400n,
      restaurant: -3_600n,
    });
    expect((await order.captain.active()).json().ended).toMatchObject({
      pay: null,
      charge: { amount: '20400', currency: 'TRY' },
    });
  });

  it('refuses choices that do not fit, and an order not picked up', async () => {
    const order = await pickedUpOrder();
    const refused = async (body: object) => {
      const answer = await order.ops.outcome(order.order.id, body);
      expect(answer.statusCode).toBe(400);
      return answer.json().error;
    };
    expect(await refused({ ...fake, responsible: 'platform' })).toBe('invalid_outcome');
    expect(await refused({ ...fake, outcome: 'failed_other' })).toBe('invalid_outcome');
    expect(
      await refused({
        ...fake,
        outcome: 'failed_other',
        responsible: 'captain',
        food: 'returned_to_restaurant',
      }),
    ).toBe('invalid_outcome');
    expect(await outcomeRow(order.order.id)).toBeUndefined();
    expect((await order.ops.detail(order.order.id)).outcomeChoices.foods).toEqual([
      { code: 'kept_by_captain', label: 'يبقى مع الكابتن' },
      { code: 'returned_to_restaurant', label: 'أُعيد إلى المطعم' },
      { code: 'destroyed', label: 'أُتلف' },
    ]);
    const accepted = await acceptedOrder();
    const early = await order.ops.outcome(accepted.id, fake);
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');
    // SUP cannot set an outcome.
    const sup = await admin(['SUP']);
    expect((await sup.outcome(order.order.id, fake)).statusCode).toBe(403);
  });
});

// Slice 2.11b (K9). The order of pickedUpOrder: items 24000, fee 4000, total
// 28000, commission 3600, merchant net 20400; the captain's pay 2500.
describe('«تحديد النتيجة» with an amount to collect (AP §9.3.2, CA §9.10, K9)', () => {
  const free = {
    outcome: 'free',
    responsible: 'platform',
    delivered: true,
    food: null,
    amountToCollect: '5000',
  };

  it('waits for the captain to record 50, then posts the outcome from it', async () => {
    const order = await pickedUpOrder();
    const before = await balances(order.captain.captainId);
    const preview = await order.ops.outcomePreview(order.order.id, free);
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({
      status: 'delivered',
      provisional: true,
      loss: { amount: '15400' },
      captainPay: { amount: '2500' },
    });
    expect(previewLines(preview.json().entries)).toEqual([
      ['custody.collect', 'captain.custody', '5000'],
      ['custody.collect', 'platform.order_clearing', '-5000'],
      ['merchant.commission', 'merchant.account', '3600'],
      ['merchant.commission', 'platform.order_clearing', '-3600'],
      ['platform.operating_cost', 'platform.operating_cost', '15400'],
      ['platform.operating_cost', 'platform.order_clearing', '-15400'],
      ['earn.order_pay', 'captain.earnings', '-2500'],
      ['earn.order_pay', 'platform.operating_cost', '2500'],
    ]);
    const set = await order.ops.outcome(order.order.id, free);
    expect(set.statusCode).toBe(200);
    expect(set.json().order).toMatchObject({ status: 'picked_up' });
    expect(set.json().order.badges.awaitingCollection).toBe(true);
    // Nothing is posted yet: the order waits «بانتظار تسجيل التحصيل».
    expect(await orderRow(order.order.id)).toMatchObject({
      status: 'picked_up',
      outcome: null,
      captain_track: 'picked_up',
      delivered_at: null,
    });
    expect(await outcomeRow(order.order.id)).toMatchObject({
      amount_to_collect: '5000',
      collected_at: null,
      status: 'delivered',
    });
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      restaurant: 0n,
      operatingCost: 0n,
      earnings: 0n,
    });
    expect(await outboxReason(order.order.id, 'order.outcome_set')).toBeNull();
    // The captain: still busy, with the payment screen for 50.
    const waiting = (await order.captain.active()).json();
    expect(waiting.ended).toBeNull();
    expect(waiting.order.outcomeToCollect).toEqual({
      outcome: 'free',
      amount: { amount: '5000', currency: 'TRY' },
      equivalents: [],
    });
    // The customer: «المبلغ المطلوب الآن: 50».
    const seen = await customerOrder(order.order.customer, order.order.id);
    expect(seen.status).toBe('picked_up');
    expect(seen.outcome).toMatchObject({
      outcome: 'free',
      amountToCollect: { amount: '5000', currency: 'TRY' },
      awaitingCollection: true,
    });
    const detail = await order.ops.detail(order.order.id);
    expect(detail.outcome).toMatchObject({ awaitingCollection: true, collectedAt: null });
    expect(detail.outcomeChoices).toBeNull();
    expect(detail.editChoices).toBeNull();
    // While it waits: no other outcome, edit or delivery.
    expect((await order.ops.outcome(order.order.id, free)).json().error).toBe(
      'order_state_changed',
    );
    expect(
      (await order.ops.edit(order.order.id, { ...oneShawarma, responsible: 'platform' })).json()
        .error,
    ).toBe('order_state_changed');
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    const deliver = await order.deliver('28000');
    expect(deliver.statusCode).toBe(409);
    expect(deliver.json().error).toBe('order_state_changed');
    // The amount the screen showed, then the payment.
    const stale = await outcomePayment(order, 'captain', { received: '4000', due: '4000' });
    expect(stale.statusCode).toBe(409);
    expect(stale.json().error).toBe('amount_due_changed');
    const paid = await outcomePayment(order, 'captain', { received: '5000' });
    expect(paid.statusCode).toBe(200);
    expect(paid.json().summary).toMatchObject({
      pay: { total: '2500' },
      custodyChange: { amount: '-19000', currency: 'TRY' },
    });
    expect(await orderRow(order.order.id)).toMatchObject({
      status: 'delivered',
      outcome: 'free',
      captain_track: 'done',
    });
    const row = await outcomeRow(order.order.id);
    expect(row).toMatchObject({ loss: '15400', captain_pay: '2500' });
    expect(row.collected_at).not.toBeNull();
    expect(row.captain_seen_at).not.toBeNull();
    // The pickup's 24000 comes back to zero on the clearing account.
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: -24_000n,
      restaurant: -3_600n,
      operatingCost: 15_400n + 2_500n,
      earnings: 2_500n,
    });
    expect(await outboxReason(order.order.id, 'order.outcome_collected')).toBe('free');
    const after = await customerOrder(order.order.customer, order.order.id);
    expect(after.status).toBe('delivered');
    expect(after.outcome.awaitingCollection).toBe(false);
    const done = (await order.captain.active()).json();
    expect(done.order).toBeNull();
    expect(done.ended).toBeNull();
    // A second payment finds nothing waiting.
    expect((await outcomePayment(order, 'captain', { received: '5000' })).statusCode).toBe(409);
  });

  it('lets operations record a short payment: the shortfall stays open, the pay offset', async () => {
    const order = await pickedUpOrder();
    const before = await balances(order.captain.captainId);
    const damaged = { ...free, outcome: 'damaged', responsible: 'restaurant' };
    expect((await order.ops.outcome(order.order.id, damaged)).statusCode).toBe(200);
    const missing = await outcomePayment(order, 'ops', { received: '4000', due: '5000' });
    expect(missing.statusCode).toBe(409);
    expect(missing.json()).toMatchObject({
      error: 'shortfall_reason_required',
      shortfall: { amount: '1000', currency: 'TRY' },
    });
    const paid = await outcomePayment(order, 'ops', {
      received: '4000',
      due: '5000',
      shortfall: { reason: 'customer_short', note: null },
    });
    expect(paid.statusCode).toBe(200);
    expect(paid.json().order.status).toBe('delivered');
    // The restaurant returns the 24000; the 50 counted as collected pays
    // the captain's 25 and books 25 as delivery revenue; the missing 10 waits
    // on the clearing account for operations (AP §8.6).
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: -24_000n + 1_000n,
      restaurant: -24_000n,
      delivery: 2_500n,
      operatingCost: 0n,
      earnings: 2_500n,
    });
    expect((await outcomeRow(order.order.id)).merchant_debit).toBe('24000');
    const detail = await order.ops.detail(order.order.id);
    expect(detail.delivery).toMatchObject({
      outcome: 'damaged',
      netReceived: { amount: '4000', currency: 'TRY' },
      shortfall: { amount: { amount: '1000', currency: 'TRY' }, reason: 'customer_short' },
      recordedBy: { type: 'admin', reason: 'الكابتن بلا هاتف' },
    });
    expect(detail.outcome).toMatchObject({ awaitingCollection: false });
    // Operations recorded it: the captain gets the outcome card.
    expect((await order.captain.active()).json().ended).toMatchObject({
      orderId: order.order.id,
      outcome: 'damaged',
      pay: { amount: '2500', currency: 'TRY' },
    });
  });

  it('refuses an amount on a failed order, the whole total, and a payment with nothing waiting', async () => {
    const order = await pickedUpOrder();
    const refused = async (body: object) => {
      const answer = await order.ops.outcome(order.order.id, body);
      expect(answer.statusCode).toBe(400);
      return answer.json().error;
    };
    expect(
      await refused({
        outcome: 'failed_other',
        responsible: 'platform',
        delivered: false,
        food: 'kept_by_captain',
        amountToCollect: '5000',
      }),
    ).toBe('invalid_outcome');
    expect(await refused({ ...free, amountToCollect: '28000' })).toBe('invalid_outcome');
    const none = await outcomePayment(order, 'captain', { received: '5000' });
    expect(none.statusCode).toBe(409);
    expect(none.json().error).toBe('order_state_changed');
    // Another captain's order is unknown to them.
    expect((await order.ops.outcome(order.order.id, free)).statusCode).toBe(200);
    const other = await onlineCaptain();
    const foreign = await outcomePayment(
      { ...order, captain: { ...order.captain, ...other } },
      'captain',
      {
        received: '5000',
      },
    );
    expect(foreign.statusCode).toBe(404);
    expect(foreign.json().error).toBe('unknown_order');
  });
});
