import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { FxService } from '../fx/index.js';
import type { AccountPurpose, JournalType } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import {
  app,
  sql,
  db,
  azaz,
  restaurant,
  change,
  bySystem,
  home,
  phoneNumber,
  admin,
  onlineCaptain,
  assignedOrder,
  SECOND,
  TRY,
  eventTypes,
  atCustomer,
  farFromCustomer,
  pickedUpOrder,
  arrivalRow,
  ledgerOf,
  owned,
  platformNow,
  delta,
  orderAtDoor,
  collectionRow,
} from './delivery.fixture.js';

describe('the captain on the way to the customer (CA §9.5)', () => {
  it('shows the customer block from assignment, with the number to call', async () => {
    const assigned = await assignedOrder();
    const { order } = (await assigned.captain.active()).json();
    expect(order.customer).toMatchObject({
      name: null,
      location: home,
      address: {
        neighbourhood: 'المركز',
        street: 'شارع السوق',
        floor: null,
        landmark: 'قرب الجامع',
        directions: null,
      },
      payIn: null,
      collectEquivalents: [],
      arrival: null,
    });
    expect(order.customer.phone).toMatch(/^\+9639\d{8}$/);
    expect(new Date(order.customer.promisedAt).getTime()).toBeGreaterThan(Date.now());
  });

  it("gives the recipient's name and number for an order for someone else (CU Q5)", async () => {
    const contactPhone = phoneNumber();
    const assigned = await assignedOrder({ recipientName: 'أبو أحمد', contactPhone });
    const { order } = (await assigned.captain.active()).json();
    expect(order.customer).toMatchObject({ name: 'أبو أحمد', phone: contactPhone });
  });
});

describe('POST /v1/captain/orders/{orderId}/arrive-at-customer (CA §9.6, K4)', () => {
  it('sets arrived and at_customer within the radius, with no reason kept', async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.arriveAtCustomer(atCustomer, {
      away: { reason: 'pin_inaccurate', note: null },
    });
    expect(answer.statusCode).toBe(200);
    const { order } = answer.json();
    expect(order.status).toBe('arrived');
    expect(order.captainTrack).toBe('at_customer');
    expect(order.customer.arrival).toMatchObject({ awayReason: null });
    expect(await arrivalRow(picked.order.id)).toMatchObject({
      status: 'arrived',
      captain_track: 'at_customer',
      away_reason: null,
      away_note: null,
    });
    expect((await eventTypes(picked.order.id)).at(-1)).toEqual({
      type: 'order.arrived_at_customer',
      reason: null,
    });
    // The customer sees the status, «الكابتن عند الباب».
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.arrived_at_customer'",
      [picked.order.id],
    );
    expect(outbox.rows[0].payload).toMatchObject({ status: 'arrived', reason: null });
  });

  it('refuses beyond the radius without a reason, with the distance', async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.arriveAtCustomer(farFromCustomer);
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('too_far_from_customer');
    expect(answer.json().distanceMetres).toBeGreaterThan(500);
    expect((await arrivalRow(picked.order.id)).status).toBe('picked_up');
  });

  it('accepts beyond the radius with a reason, which operations see', async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'other', note: 'الزبون نزل إلى الشارع' },
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.customer.arrival.awayReason).toBe('other');
    expect(await arrivalRow(picked.order.id)).toMatchObject({
      away_reason: 'other',
      away_note: 'الزبون نزل إلى الشارع',
    });
    expect((await eventTypes(picked.order.id)).at(-1)).toEqual({
      type: 'order.arrived_at_customer',
      reason: 'other',
    });
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.arrived_at_customer'",
      [picked.order.id],
    );
    expect(outbox.rows[0].payload.reason).toBeNull();
    const card = (await picked.ops.get(`/v1/admin/orders?cityId=${azaz}`))
      .json()
      .orders.find((entry: { id: string }) => entry.id === picked.order.id);
    expect(card.alerts).toContain('away_from_address');
    // AP §9.2.1: the time in «الكابتن وصل» counts from the arrival.
    expect(card.statusSince).toBe(answer.json().order.customer.arrival.at);
    const detail = (await picked.ops.get(`/v1/admin/orders/${picked.order.id}`)).json().order;
    expect(detail.customer.arrival.away).toEqual({
      reason: 'other',
      label: 'أخرى',
      note: 'الزبون نزل إلى الشارع',
    });
  });

  it('refuses a note without «أخرى», «أخرى» without a note, and a code outside the list', async () => {
    const picked = await pickedUpOrder();
    const noted = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'pin_inaccurate', note: 'نص' },
    });
    expect(noted.statusCode).toBe(400);
    expect(noted.json().error).toBe('reason_note_not_allowed');
    const bare = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'other', note: null },
    });
    expect(bare.statusCode).toBe(400);
    expect(bare.json().error).toBe('reason_note_required');
    const unknown = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'counting_error', note: null },
    });
    expect(unknown.statusCode).toBe(400);
    expect(unknown.json().error).toBe('unknown_reason');
  });

  it('replays a repeated arrival after its reason left the list', async () => {
    const picked = await pickedUpOrder();
    const key = randomUUID();
    const away = { reason: 'customer_requested_other_place', note: null };
    const first = await picked.arriveAtCustomer(farFromCustomer, { away, key });
    expect(first.statusCode).toBe(200);
    await sql.query(
      "UPDATE content.reasons SET active = false WHERE list = 'captain_away' AND code = 'customer_requested_other_place'",
    );
    try {
      // The key's answer is kept; the reason is not checked again.
      const again = await picked.arriveAtCustomer(farFromCustomer, { away, key });
      expect(again.statusCode).toBe(200);
      expect(again.json().order.version).toBe(first.json().order.version);
    } finally {
      await sql.query(
        "UPDATE content.reasons SET active = true WHERE list = 'captain_away' AND code = 'customer_requested_other_place'",
      );
    }
  });

  it("keeps the reason's label as chosen when Content renames it", async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'pin_inaccurate', note: null },
    });
    expect(answer.statusCode).toBe(200);
    await sql.query(
      "UPDATE content.reasons SET label = 'الدبوس بعيد' WHERE list = 'captain_away' AND code = 'pin_inaccurate'",
    );
    try {
      const detail = (await picked.ops.get(`/v1/admin/orders/${picked.order.id}`)).json().order;
      expect(detail.customer.arrival.away).toEqual({
        reason: 'pin_inaccurate',
        label: 'موقع الزبون على الخريطة غير دقيق',
        note: null,
      });
    } finally {
      await sql.query(
        "UPDATE content.reasons SET label = 'موقع الزبون على الخريطة غير دقيق' WHERE list = 'captain_away' AND code = 'pin_inaccurate'",
      );
    }
  });

  it('refuses a simulated, stale or weak fix', async () => {
    const picked = await pickedUpOrder();
    const simulated = await picked.arriveAtCustomer(atCustomer, { simulated: true });
    expect(simulated.json().error).toBe('simulated_location');
    const stale = await picked.arriveAtCustomer(atCustomer, {
      recordedAt: new Date(Date.now() - 2 * 60 * SECOND),
    });
    expect(stale.json().error).toBe('stale_location');
    const weak = await picked.arriveAtCustomer(atCustomer, { accuracyMetres: 150 });
    expect(weak.json().error).toBe('weak_location');
    expect((await arrivalRow(picked.order.id)).status).toBe('picked_up');
  });

  it('refuses before the pickup, and answers a repeat of the key with the order', async () => {
    const assigned = await assignedOrder();
    const early = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${assigned.order.id}/arrive-at-customer`,
      headers: { ...assigned.captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...home,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
        away: null,
      },
    });
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');

    const picked = await pickedUpOrder();
    const key = randomUUID();
    expect((await picked.arriveAtCustomer(atCustomer, { key })).statusCode).toBe(200);
    const again = await picked.arriveAtCustomer(atCustomer, { key });
    expect(again.statusCode).toBe(200);
    expect(again.json().order.status).toBe('arrived');
    const events = await eventTypes(picked.order.id);
    expect(events.filter((event) => event.type === 'order.arrived_at_customer')).toHaveLength(1);
  });

  it('answers no number to a command replayed once the order ended (C10)', async () => {
    const picked = await pickedUpOrder();
    const key = randomUUID();
    const first = await picked.arriveAtCustomer(atCustomer, { key });
    expect(first.json().order.customer.phone).toMatch(/^\+9639\d{8}$/);
    // The order ends (its delivery comes with the next pull request).
    await sql.query(
      "UPDATE ordering.orders SET status = 'cancelled', cancelled_at = now(), cancel_reason = 'test', food_prepared = false WHERE id = $1",
      [picked.order.id],
    );
    const replayed = await picked.arriveAtCustomer(atCustomer, { key });
    expect(replayed.statusCode).toBe(200);
    expect(replayed.json().order.customer.phone).toBeNull();
  });

  it('refuses a key reused with another reason', async () => {
    const picked = await pickedUpOrder();
    const key = randomUUID();
    const away = { reason: 'pin_inaccurate', note: null };
    expect((await picked.arriveAtCustomer(farFromCustomer, { key, away })).statusCode).toBe(200);
    const other = await picked.arriveAtCustomer(farFromCustomer, {
      key,
      away: { reason: 'customer_requested_other_place', note: null },
    });
    expect(other.statusCode).toBe(422);
  });

  it('keeps the arrival and its reason consistent in the database', async () => {
    const picked = await pickedUpOrder();
    const update = (set: string) =>
      sql.query(`UPDATE ordering.orders SET ${set} WHERE id = $1`, [picked.order.id]);
    await expect(update("status = 'arrived'")).rejects.toThrow(/orders_customer_arrival/);
    // Content checks the reason itself (AP §9.13); the row keeps a label and
    // a note only with a reason, and a note of 1 to 200 characters.
    await expect(update("away_reason_label = 'أخرى'")).rejects.toThrow(/orders_away_reason/);
    await expect(update("away_note = 'x'")).rejects.toThrow(/orders_away_reason/);
    await expect(update("away_reason = 'other', away_note = ''")).rejects.toThrow(
      /orders_away_reason/,
    );
  });

  it('refuses another captain with unknown_order', async () => {
    const picked = await pickedUpOrder();
    const other = await onlineCaptain();
    const answer = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${picked.order.id}/arrive-at-customer`,
      headers: { ...other.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...atCustomer,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
        away: null,
      },
    });
    expect(answer.statusCode).toBe(404);
  });
});

describe('POST /v1/admin/orders/{orderId}/record-delivery (AP §9.3.2)', () => {
  it('records the delivery for a picked-up order, with the same entries, audited', async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.ops.post(`/v1/admin/orders/${picked.order.id}/record-delivery`, {
      received: TRY('30000'),
      change: TRY('2000'),
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'هاتف الكابتن معطل',
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.status).toBe('delivered');
    expect(await owned(picked.captain.captainId, 'captain.custody')).toBe(4_000n);
    expect(await owned(picked.captain.captainId, 'captain.earnings')).toBe(2_500n);
    const [collection] = await collectionRow(picked.order.id);
    expect(collection).toMatchObject({
      recorded_by_type: 'admin',
      recorded_by_id: picked.ops.accountId,
      reason: 'هاتف الكابتن معطل',
    });
    const audit = await sql.query(
      "SELECT reason FROM audit.events WHERE action = 'order.record_delivery' AND target_id = $1",
      [picked.order.id],
    );
    expect(audit.rows).toEqual([{ reason: 'هاتف الكابتن معطل' }]);
    const again = await picked.ops.post(`/v1/admin/orders/${picked.order.id}/record-delivery`, {
      received: TRY('28000'),
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'مرة ثانية',
    });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('order_state_changed');
  });

  it('records it from arrived too, and needs a reason for a shortfall', async () => {
    const door = await orderAtDoor();
    const body = {
      received: TRY('25000'),
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      reason: 'الكابتن بلا هاتف',
    };
    const missing = await door.ops.post(`/v1/admin/orders/${door.order.id}/record-delivery`, {
      ...body,
      shortfall: null,
    });
    expect(missing.statusCode).toBe(409);
    expect(missing.json()).toMatchObject({
      error: 'shortfall_reason_required',
      shortfall: { amount: '3000', currency: 'TRY' },
    });
    const answer = await door.ops.post(`/v1/admin/orders/${door.order.id}/record-delivery`, {
      ...body,
      shortfall: { reason: 'counting_error', note: null },
    });
    expect(answer.statusCode).toBe(200);
    expect((await collectionRow(door.order.id))[0]).toMatchObject({
      shortfall: '3000',
      shortfall_reason: 'counting_error',
      recorded_by_type: 'admin',
    });
  });

  it('needs operations.manage', async () => {
    const picked = await pickedUpOrder();
    const support = await admin(['SUP']);
    const answer = await support.post(`/v1/admin/orders/${picked.order.id}/record-delivery`, {
      received: TRY('28000'),
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'x',
    });
    expect(answer.statusCode).toBe(403);
  });
});

describe("the restaurant's board after the delivery (RA §8.10 item 8)", () => {
  it('keeps a delivered order until the pickup dispute window ends', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const onBoard = await door.boardOrder();
    expect(onBoard).toMatchObject({ status: 'delivered' });
    expect(new Date(onBoard.pickup.disputeUntil).getTime()).toBeGreaterThan(Date.now());
    await sql.query(
      "UPDATE ordering.orders SET picked_up_at = picked_up_at - interval '11 minutes' WHERE id = $1",
      [door.order.id],
    );
    expect(await door.boardOrder()).toBeUndefined();
  });
});

describe('the whole cycle against the worked example of AP §8.4', () => {
  it('leaves every account as the example says, and the platform cash equals its margin', async () => {
    // Items 400 (2 × 200), fee 40, commission 15%, a 5 km trip: base 25 for
    // the first 3 km and 2 extra km × 5. There are no codes before Phase 2,
    // so the example's platform code of 30 is left out: the customer pays
    // 440, the custody gains 40 and the margin is 60 + 40 − 35 = 65.
    const merchants = app.get(MerchantsService);
    const category = await merchants.addCategory(restaurant, { name: 'مثال' }, change);
    const dish = await merchants.addItem(
      restaurant,
      { categoryId: category, name: 'وجبة المثال', price: { amount: 20_000n, currency: 'TRY' } },
      change,
    );
    const door = await orderAtDoor({
      dish: { itemId: dish, unitPrice: '20000' },
      tripMetres: 5_000,
    });
    const before = await platformNow();
    const restaurantBefore = await owned(restaurant, 'merchant.account');
    const answer = await door.deliver({ received: TRY('44000'), amountDue: '44000' });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().summary.pay).toMatchObject({
      base: '2500',
      distance: '1000',
      total: '3500',
    });

    const custody = await owned(door.captain.captainId, 'captain.custody');
    const earnings = await owned(door.captain.captainId, 'captain.earnings');
    const restaurantOwes = (await owned(restaurant, 'merchant.account')) - restaurantBefore;
    const moved = delta(before, await platformNow());
    expect({ custody, earnings, restaurantOwes }).toEqual({
      custody: 4_000n, // handed in the same business day
      earnings: 3_500n, // paid on Thursday
      restaurantOwes: -6_000n, // the commission, collected on Saturday
    });
    expect(moved).toEqual({
      'platform.order_clearing': -40_000n, // the pickup's +400: the order is settled
      'platform.revenue_delivery': 4_000n,
      'platform.revenue_commission': 6_000n,
      'platform.captain_pay': 3_500n,
      'platform.fx_rounding': 0n,
    });
    const margin =
      moved['platform.revenue_commission']! +
      moved['platform.revenue_delivery']! -
      moved['platform.captain_pay']!;
    expect(margin).toBe(6_500n);

    // When each amount reaches the platform: the desk's hand-in, Thursday's
    // payout and Saturday's settlement (their screens come with the finance
    // slices; posted here as the desk will).
    const drawer = await ledgerOf().openAccount({
      cityId: azaz,
      purpose: 'platform.cash',
      ownerId: randomUUID(),
      currency: 'TRY',
    });
    const desk = { type: 'admin', id: randomUUID() } as const;
    const account = async (purpose: AccountPurpose, ownerId: string) =>
      (await ledgerOf().ownerAccounts(azaz, ownerId, purpose)).find(
        (each) => each.currency === 'TRY',
      )!.id;
    const custodyAccount = await account('captain.custody', door.captain.captainId);
    const earningsAccount = await account('captain.earnings', door.captain.captainId);
    const restaurantAccount = await account('merchant.account', restaurant);
    const post = (type: JournalType, entries: [string, bigint][]) =>
      db.db.transaction((tx) =>
        ledgerOf().post(
          {
            cityId: azaz,
            type,
            source: null,
            actor: desk,
            entries: entries.map(([accountId, amount]) => ({ accountId, currency: 'TRY', amount })),
          },
          tx,
        ),
      );
    await post('custody.hand_in', [
      [custodyAccount, -4_000n],
      [drawer, 4_000n],
    ]);
    await post('earn.payout', [
      [earningsAccount, 3_500n],
      [drawer, -3_500n],
    ]);
    await post('merchant.settlement', [
      [restaurantAccount, -6_000n],
      [drawer, 6_000n],
    ]);
    expect((await ledgerOf().balance(drawer)).amount).toBe(margin);
    expect(await owned(door.captain.captainId, 'captain.custody')).toBe(0n);
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(0n);
  });
});

describe('the door payment in another currency (AP §8.6, CA §9.7)', () => {
  it('keeps the custody per currency and settles the clearing account in the base', async () => {
    const fx = app.get(FxService);
    const fin = { ...change, actor: { type: 'admin', id: randomUUID(), role: 'FIN' } } as const;
    await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: false }, change);
    await fx.setRate(azaz, 'USD', { value: '41.20', direction: 'base_per_unit' }, fin);
    await app
      .get(SettingsService)
      .update(
        'currency.<code>.rounding_unit',
        { cityId: azaz, parameter: 'USD' },
        { amountMinor: 50 },
        bySystem,
      );
    await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: true }, change);
    const door = await orderAtDoor();
    const beforeTry = await platformNow();
    const beforeUsd = await platformNow('USD');
    // 7 USD = 288.40 TRY; 8.40 TRY back.
    const answer = await door.deliver({
      received: [{ currency: 'USD', amount: '700' }],
      change: TRY('840'),
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().summary.custodyChange.amount).toBe('4000');
    // CA §10.2: every currency at its current rate, so 7 USD less 248.40 TRY.
    expect(answer.json().summary.handInToday).toEqual({ amount: '4000', currency: 'TRY' });
    // AP §8.6: the captain hands back exactly the currencies received.
    expect(await owned(door.captain.captainId, 'captain.custody', 'USD')).toBe(700n);
    expect(await owned(door.captain.captainId, 'captain.custody')).toBe(-24_840n);
    expect(delta(beforeTry, await platformNow())['platform.order_clearing']).toBe(-24_000n);
    const usd = delta(beforeUsd, await platformNow('USD'));
    expect(usd['platform.order_clearing']).toBe(0n);
    // The platform's USD position against its TRY value.
    expect(usd['platform.fx_rounding']).toBe(700n);
    expect(delta(beforeTry, await platformNow())['platform.fx_rounding']).toBe(-28_840n);
  });

  it('books a gap within rounding beside the conversion', async () => {
    const door = await orderAtDoor();
    const beforeTry = await platformNow();
    // 7 USD = 288.40 TRY; 8 TRY back leaves 280.40: 0.40 over, within half
    // of 0.50 USD (10.30 TRY).
    const answer = await door.deliver({
      received: [{ currency: 'USD', amount: '700' }],
      change: TRY('800'),
    });
    expect(answer.statusCode).toBe(200);
    const moved = delta(beforeTry, await platformNow());
    expect(moved['platform.order_clearing']).toBe(-24_000n);
    // −288.40 for the USD's value, +0.40 gained in rounding.
    expect(moved['platform.fx_rounding']).toBe(-28_800n);
  });
});
