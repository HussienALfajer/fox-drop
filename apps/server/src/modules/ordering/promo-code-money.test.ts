import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { type AccountPurpose, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  acceptedOrder,
  admin,
  app,
  appSignIn,
  azaz,
  change,
  delta,
  home,
  item,
  orderAtDoor,
  owned,
  phoneNumber,
  pickedUpOrder,
  platform,
  promoCode,
  restaurant,
  sql,
  TRY,
} from './delivery.fixture.js';

// A code's money on the delivery and its use given back (AP §8.4, §9.11.1,
// docs/domain/04, 07, 11; slice 2.21b).
const ACCOUNTS: AccountPurpose[] = [
  'platform.order_clearing',
  'platform.revenue_delivery',
  'platform.revenue_commission',
  'platform.captain_pay',
  'platform.discount_cost',
  'platform.fx_rounding',
];

async function platformNow() {
  const result: Record<string, bigint> = {};
  for (const purpose of ACCOUNTS) result[purpose] = await platform(purpose);
  return result;
}

const useOf = async (orderId: string) =>
  (await sql.query('SELECT status FROM marketing.promo_code_uses WHERE order_id = $1', [orderId]))
    .rows[0]?.status;

// The example's dish: 2 × 200.00 = 400.00.
async function exampleDish() {
  const merchants = app.get(MerchantsService);
  const category = await merchants.addCategory(restaurant, { name: 'مثال' }, change);
  const dish = await merchants.addItem(
    restaurant,
    { categoryId: category, name: 'وجبة المثال', price: { amount: 20_000n, currency: 'TRY' } },
    change,
  );
  return { itemId: dish, unitPrice: '20000' };
}

describe('the delivery of an order with a code', () => {
  it("matches AP §8.4's worked example with its platform code", async () => {
    // Items 400, fee 40, a platform code of 10% capped at 30, commission 15%,
    // a 5 km trip paying 35: the customer pays 410, the custody gains 10 and
    // the margin is 60 + 40 − 30 − 35 = 35.
    const code = await promoCode({ percent_bp: 1000, max_discount: 3000 });
    const door = await orderAtDoor({ dish: await exampleDish(), tripMetres: 5_000, code });
    const before = await platformNow();
    const restaurantBefore = await owned(restaurant, 'merchant.account');
    const answer = await door.deliver({ received: TRY('41000'), amountDue: '41000' });
    expect(answer.statusCode).toBe(200);
    const moved = delta(before, await platformNow());
    expect({
      custody: await owned(door.captain.captainId, 'captain.custody'),
      earnings: await owned(door.captain.captainId, 'captain.earnings'),
      restaurantOwes: (await owned(restaurant, 'merchant.account')) - restaurantBefore,
    }).toEqual({ custody: 1_000n, earnings: 3_500n, restaurantOwes: -6_000n });
    expect(moved).toEqual({
      'platform.order_clearing': -40_000n,
      'platform.revenue_delivery': 4_000n,
      'platform.revenue_commission': 6_000n,
      'platform.captain_pay': 3_500n,
      'platform.discount_cost': 3_000n,
      'platform.fx_rounding': 0n,
    });
    const margin =
      moved['platform.revenue_commission']! +
      moved['platform.revenue_delivery']! -
      moved['platform.discount_cost']! -
      moved['platform.captain_pay']!;
    expect(margin).toBe(3_500n);
    expect(await useOf(door.order.id)).toBe('spent');
  });

  it('takes the commission after a restaurant-funded item discount, and its share on Saturday', async () => {
    // The restaurant funds 10% capped at 30 of 400: commission 15% of 370 =
    // 55.50, and it owes 55.50 + 30 on Saturday; the custody is 10 lower.
    const code = await promoCode({
      funding: 'restaurant',
      merchant_share_bp: 10_000,
      restaurant_ids: [restaurant],
    });
    const door = await orderAtDoor({ dish: await exampleDish(), tripMetres: 5_000, code });
    const before = await platformNow();
    const restaurantBefore = await owned(restaurant, 'merchant.account');
    expect((await door.deliver({ received: TRY('41000'), amountDue: '41000' })).statusCode).toBe(
      200,
    );
    expect((await owned(restaurant, 'merchant.account')) - restaurantBefore).toBe(-8_550n);
    expect(delta(before, await platformNow())).toMatchObject({
      'platform.order_clearing': -40_000n,
      'platform.revenue_commission': 5_550n,
      'platform.discount_cost': 0n,
    });
    const ledger = app.get(LedgerService);
    const accounts = await ledger.ownerAccounts(azaz, restaurant, 'merchant.account');
    const lines = (
      await ledger.accountEntries(
        accounts.map((each) => each.id),
        'merchant.account',
        50,
      )
    )
      .filter((entry) => entry.sourceId === door.order.id)
      .map(({ type, amount }) => ({ type, amount }))
      .sort((a, b) => a.type.localeCompare(b.type));
    // From the restaurant's view: what it owes is negative.
    expect(lines).toEqual([
      { type: 'merchant.commission', amount: -5_550n },
      { type: 'merchant.discount_share', amount: -3_000n },
    ]);
  });

  it("books a personal code's discount to the compensation cost (slice 2.22b)", async () => {
    // A compensation code of 25.00 (docs/domain/11: `platform.compensation_cost`
    // «كلفة التعويضات», compensation codes when used), not a discount cost.
    const code = await promoCode({
      kind: 'fixed_amount',
      percent_bp: null,
      max_discount: null,
      amount: 2_500,
    });
    const door = await orderAtDoor({ dish: await exampleDish(), tripMetres: 5_000, code });
    // The order keeps the code's terms as placing took them from a personal code.
    await sql.query(
      `UPDATE ordering.orders SET promo_terms = promo_terms || '{"compensation": true}'::jsonb
        WHERE id = $1`,
      [door.order.id],
    );
    const before = await platformNow();
    const compensationBefore = await platform('platform.compensation_cost');
    expect((await door.deliver({ received: TRY('41500'), amountDue: '41500' })).statusCode).toBe(
      200,
    );
    expect(delta(before, await platformNow())).toMatchObject({
      'platform.order_clearing': -40_000n,
      'platform.discount_cost': 0n,
    });
    expect((await platform('platform.compensation_cost')) - compensationBefore).toBe(2_500n);
    expect(await useOf(door.order.id)).toBe('spent');
  });

  it('keeps the commission base for a restaurant-funded free delivery, split by the ratio', async () => {
    // Shared half and half: the fee of 40 is 20 platform, 20 restaurant; the
    // commission stays 15% of 400.
    const code = await promoCode({
      kind: 'free_delivery',
      percent_bp: null,
      max_discount: null,
      funding: 'shared',
      merchant_share_bp: 5_000,
      restaurant_ids: [restaurant],
    });
    const door = await orderAtDoor({ dish: await exampleDish(), tripMetres: 5_000, code });
    const before = await platformNow();
    const restaurantBefore = await owned(restaurant, 'merchant.account');
    expect((await door.deliver({ received: TRY('40000'), amountDue: '40000' })).statusCode).toBe(
      200,
    );
    expect((await owned(restaurant, 'merchant.account')) - restaurantBefore).toBe(-8_000n);
    expect(delta(before, await platformNow())).toMatchObject({
      'platform.order_clearing': -40_000n,
      'platform.revenue_commission': 6_000n,
      'platform.discount_cost': 2_000n,
    });
  });
});

describe('the use given back', () => {
  it("returns a code's use when the customer cancels", async () => {
    const code = await promoCode({ total_limit: 1 });
    const customer = await appSignIn('customer', phoneNumber());
    const lines = [
      { itemId: item, optionIds: [], quantity: 2, note: null, knownUnitPrice: '12000' },
    ];
    const payload = {
      restaurantId: restaurant,
      lines,
      payIn: null,
      appVersion: '1.0.0',
      code,
    };
    const quote = await app.inject({
      method: 'POST',
      url: '/v1/customer/quote',
      headers: customer,
      payload: { ...payload, location: home },
    });
    const placed = await app.inject({
      method: 'POST',
      url: '/v1/customer/orders',
      headers: { ...customer, 'idempotency-key': randomUUID() },
      payload: {
        ...payload,
        quoteVersion: quote.json().version,
        addressId: null,
        unsavedAddress: {
          location: home,
          street: 'شارع السوق',
          floor: null,
          landmark: 'قرب الجامع',
          contactPhone: null,
          recipientName: null,
          directions: null,
        },
        note: null,
      },
    });
    expect(placed.statusCode).toBe(201);
    const orderId = placed.json().order.id as string;
    expect(await useOf(orderId)).toBe('held');
    const cancelled = await app.inject({
      method: 'POST',
      url: `/v1/customer/orders/${orderId}/cancel`,
      headers: { ...customer, 'idempotency-key': randomUUID() },
      payload: { reason: 'changed_mind', note: null },
    });
    expect(cancelled.statusCode).toBe(200);
    expect(await useOf(orderId)).toBe('returned');
  });
});

describe('an edit of an order with a code', () => {
  it('works a percentage out again on the new items value, the code kept below its minimum', async () => {
    // 10% capped at 30 with a minimum of 200: 2 × 120 gives 24; one left
    // gives 12 though the items are now below the minimum.
    const code = await promoCode({ min_order: 20_000 });
    const order = await acceptedOrder(null, undefined, code);
    const ops = await admin(['OPS']);
    const shown = await ops.get(`/v1/admin/orders/${order.id}`);
    const edited = await app.inject({
      method: 'POST',
      url: `/v1/admin/orders/${order.id}/edit`,
      cookies: ops.cookies,
      headers: { 'idempotency-key': randomUUID() },
      payload: {
        keep: [{ position: 0, quantity: 1 }],
        add: [],
        deliveryFee: null,
        extraPrepMin: null,
        responsible: null,
        reason: 'اتفقنا مع الزبون',
        version: shown.json().order.version,
      },
    });
    expect(edited.statusCode, edited.body).toBe(200);
    const { rows } = await sql.query(
      'SELECT items_value, discount, total, promo_code FROM ordering.orders WHERE id = $1',
      [order.id],
    );
    // 120 + 40 − 12 = 148, rounded to 150.
    expect(rows[0]).toEqual({
      items_value: '12000',
      discount: '1200',
      total: '15000',
      promo_code: code,
    });
    const use = await sql.query(
      'SELECT discount FROM marketing.promo_code_uses WHERE order_id = $1',
      [order.id],
    );
    expect(use.rows[0].discount).toBe('1200');
  });
});

describe('an outcome of an order with a code', () => {
  async function outcome(orderId: string, body: object) {
    const ops = await admin(['OPS']);
    const shown = await ops.get(`/v1/admin/orders/${orderId}`);
    return app.inject({
      method: 'POST',
      url: `/v1/admin/orders/${orderId}/outcome`,
      cookies: ops.cookies,
      headers: { 'idempotency-key': randomUUID() },
      payload: { reason: 'اتصلنا بالزبون', version: shown.json().order.version, ...body },
    });
  }

  it('gives the use back when the order fails with the restaurant responsible', async () => {
    const code = await promoCode();
    const picked = await pickedUpOrder(undefined, code);
    const before = await platform('platform.order_clearing');
    const answer = await outcome(picked.order.id, {
      outcome: 'wrong_refused',
      responsible: 'restaurant',
      delivered: false,
      food: 'returned_to_restaurant',
    });
    expect(answer.statusCode, answer.body).toBe(200);
    expect(await useOf(picked.order.id)).toBe('returned');
    // The pickup's 240 returned: the order is settled.
    expect((await platform('platform.order_clearing')) - before).toBe(-24_000n);
  });

  it('spends it when the customer is responsible', async () => {
    const code = await promoCode();
    const picked = await pickedUpOrder(undefined, code);
    const answer = await outcome(picked.order.id, {
      outcome: 'fake',
      responsible: 'customer',
      delivered: false,
      food: 'kept_by_captain',
    });
    expect(answer.statusCode, answer.body).toBe(200);
    expect(await useOf(picked.order.id)).toBe('spent');
  });
});

describe('the other ends of an order with a code', () => {
  async function adminPost(roles: string[], orderId: string, path: string, body: object) {
    const ops = await admin(roles);
    const shown = await ops.get(`/v1/admin/orders/${orderId}`);
    return app.inject({
      method: 'POST',
      url: `/v1/admin/orders/${orderId}/${path}`,
      cookies: ops.cookies,
      headers: { 'idempotency-key': randomUUID() },
      payload: { version: shown.json().order.version, ...body },
    });
  }

  it("gives the use back on operations' cancellation and credits the net after the code", async () => {
    // A restaurant-funded 24 off 240: the food credit is 240 − 15% of 216 − 24.
    const code = await promoCode({
      funding: 'restaurant',
      merchant_share_bp: 10_000,
      restaurant_ids: [restaurant],
    });
    const order = await acceptedOrder(null, undefined, code);
    const answer = await adminPost(['OPS'], order.id, 'cancel', {
      cancellation: 'emergency',
      responsible: 'platform',
      foodPrepared: true,
      compensateCaptain: false,
      cash: null,
      reason: 'ملاحظة العمليات',
    });
    expect(answer.statusCode, answer.body).toBe(200);
    expect(await useOf(order.id)).toBe('returned');
    const { rows } = await sql.query(
      'SELECT cancel_merchant_credit FROM ordering.orders WHERE id = $1',
      [order.id],
    );
    expect(rows[0].cancel_merchant_credit).toBe('18360');
  });

  it('settles the use again when the outcome changes, both ways', async () => {
    const code = await promoCode();
    const picked = await pickedUpOrder(undefined, code);
    const failed = await adminPost(['OPS'], picked.order.id, 'outcome', {
      outcome: 'wrong_refused',
      responsible: 'restaurant',
      delivered: false,
      food: 'returned_to_restaurant',
      reason: 'اتصلنا بالزبون',
    });
    expect(failed.statusCode, failed.body).toBe(200);
    expect(await useOf(picked.order.id)).toBe('returned');
    const fake = {
      outcome: 'fake',
      responsible: 'customer',
      delivered: false,
      food: 'kept_by_captain',
      reason: 'راجعنا المكالمات',
    };
    const changed = await adminPost(['OWN'], picked.order.id, 'outcome-change', fake);
    expect(changed.statusCode, changed.body).toBe(200);
    expect(await useOf(picked.order.id)).toBe('spent');
    const back = await adminPost(['OWN'], picked.order.id, 'outcome-change', {
      ...fake,
      outcome: 'failed_other',
      responsible: 'platform',
    });
    expect(back.statusCode, back.body).toBe(200);
    expect(await useOf(picked.order.id)).toBe('returned');
  });

  it('charges nobody for a lower fee after the pickup that a free-delivery code covered', async () => {
    const code = await promoCode({ kind: 'free_delivery', percent_bp: null, max_discount: null });
    const picked = await pickedUpOrder(undefined, code);
    const lowerFee = {
      keep: [{ position: 0, quantity: 2 }],
      add: [],
      deliveryFee: '3000',
      extraPrepMin: null,
      responsible: 'captain',
      reason: 'اتفقنا مع الزبون',
    };
    const preview = await adminPost(['OPS'], picked.order.id, 'edit-preview', lowerFee);
    expect(preview.statusCode, preview.body).toBe(200);
    expect(preview.json().entries).toEqual([]);
    const edited = await adminPost(['OPS'], picked.order.id, 'edit', lowerFee);
    expect(edited.statusCode, edited.body).toBe(200);
    const { rows } = await sql.query(
      'SELECT delivery_fee, discount, total FROM ordering.orders WHERE id = $1',
      [picked.order.id],
    );
    // The customer still pays the items only.
    expect(rows[0]).toEqual({ delivery_fee: '3000', discount: '3000', total: '24000' });
  });
});
