import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import {
  acceptedOrder,
  app,
  appSignIn,
  home,
  item,
  orderAtDoor,
  phoneNumber,
  promoCode,
  restaurant,
  sql,
} from './delivery.fixture.js';

// A code in the quote and the order (CU §10.4, §10.6–10.7; AP §8.4,
// §9.11.1; slice 2.21b). The fixture's cart: 2 × 120.00 TRY and a 40.00 fee,
// the total rounded to 5.00.
const lines = () => [
  { itemId: item, optionIds: [], quantity: 2, note: null, knownUnitPrice: '12000' },
];

async function quote(code: string | null, headers: Record<string, string> = {}) {
  const response = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    headers,
    payload: {
      restaurantId: restaurant,
      location: home,
      lines: lines(),
      payIn: null,
      appVersion: '1.0.0',
      code,
    },
  });
  expect(response.statusCode, response.body).toBe(200);
  return response.json();
}

function place(headers: Record<string, string>, code: string | null, quoteVersion: string) {
  return app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...headers, 'idempotency-key': randomUUID() },
    payload: {
      restaurantId: restaurant,
      lines: lines(),
      payIn: null,
      appVersion: '1.0.0',
      code,
      quoteVersion,
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
}

const refusalOf = (body: { problems: { code: string; refusal: string | null }[] }) =>
  body.problems.find((problem) => problem.code === 'promo_code')?.refusal ?? null;

describe('a code in the quote', () => {
  it('discounts the items within its cap and shows the code', async () => {
    const code = await promoCode();
    const body = await quote(code.toLowerCase());
    // 10% of 240.00 is 24.00, below the cap of 30.00: 280.00 − 24.00 = 256.00,
    // rounded to 255.00.
    expect(body.money).toMatchObject({
      itemsValue: '24000',
      deliveryFee: '4000',
      discount: '2400',
      total: '25500',
    });
    expect(body.promoCode).toEqual({
      code,
      kind: 'percentage',
      discount: '2400',
      fixedAmountAboveItems: false,
    });
    expect(body.problems).toEqual([]);
    expect(body.version).not.toBe((await quote(null)).version);
  });

  it('warns of a fixed amount above the items value and loses the rest', async () => {
    const code = await promoCode({
      kind: 'fixed_amount',
      percent_bp: null,
      max_discount: null,
      amount: 30_000,
    });
    const body = await quote(code);
    expect(body.money).toMatchObject({ discount: '24000', total: '4000' });
    expect(body.promoCode).toMatchObject({ fixedAmountAboveItems: true });
  });

  it('takes the fee for free delivery', async () => {
    const code = await promoCode({ kind: 'free_delivery', percent_bp: null, max_discount: null });
    expect((await quote(code)).money).toMatchObject({ discount: '4000', total: '24000' });
  });

  it('refuses with the reason of CU Appendix C, as a blocking problem', async () => {
    expect(refusalOf(await quote('NOSUCHCODE'))).toBe('unknown_code');
    const below = await quote(await promoCode({ min_order: 30_000 }));
    expect(below.problems).toEqual([
      {
        code: 'promo_code',
        line: null,
        opensAt: null,
        message: null,
        amount: { amount: '6000', currency: 'TRY' },
        refusal: 'below_minimum',
      },
    ]);
    expect(below.money.discount).toBe('0');
    expect(below.promoCode).toBeNull();
    expect(refusalOf(await quote(await promoCode({ restaurant_ids: [randomUUID()] })))).toBe(
      'not_for_restaurant',
    );
  });

  it('lists the visible codes and suggests the largest discount, never applying it', async () => {
    // The codes of the tests before, some giving the whole items value, rest.
    await sql.query("UPDATE marketing.promo_codes SET status = 'paused'");
    const other = await promoCode();
    const best = await promoCode({ percent_bp: 9900, max_discount: null });
    const secret = await promoCode({ percent_bp: 10000, max_discount: null });
    await sql.query("UPDATE marketing.promo_codes SET visibility = 'secret' WHERE code = $1", [
      secret,
    ]);
    const body = await quote(null);
    const codes = body.availableCodes.map((entry: { code: string }) => entry.code);
    expect(codes).toEqual([best, other]);
    expect(body.availableCodes[0]).toMatchObject({
      kind: 'percentage',
      percentBp: 9900,
      discount: '23760',
      missing: null,
    });
    // U11: suggested, not applied.
    expect(body.suggestedCode).toEqual({ code: best, discount: '23760' });
    expect(body.money.discount).toBe('0');
    expect(body.promoCode).toBeNull();
    // Applied, nothing gives more; the suggestion leaves the version alone.
    const applied = await quote(best);
    expect(applied.suggestedCode).toBeNull();
    expect(applied.money.discount).toBe('23760');

    // «أكوادي» (CU §12.4) at the point's city, signed in only.
    const url = `/v1/customer/promo-codes?latitude=${home.latitude}&longitude=${home.longitude}`;
    expect((await app.inject({ method: 'GET', url })).statusCode).toBe(401);
    const mine = await app.inject({
      method: 'GET',
      url,
      headers: await appSignIn('customer', phoneNumber()),
    });
    expect(mine.statusCode, mine.body).toBe(200);
    expect(mine.json().currency).toBe('TRY');
    expect(mine.json().codes.map((entry: { code: string }) => entry.code)).toEqual(
      expect.arrayContaining([best, other]),
    );
    expect(mine.json().codes.find((entry: { code: string }) => entry.code === best)).toMatchObject({
      kind: 'percentage',
      percentBp: 9900,
      restaurants: [],
      zones: [],
      hours: null,
      usesLeft: null,
      ended: null,
    });
  });
});

describe('a code in the order', () => {
  it('keeps the discount and the code, and holds the use', async () => {
    const code = await promoCode({
      funding: 'shared',
      merchant_share_bp: 5000,
      restaurant_ids: [restaurant],
    });
    const { id } = await acceptedOrder(null, undefined, code);
    const { rows } = await sql.query(
      `SELECT discount, discount_merchant, promo_code, promo_terms, total FROM ordering.orders WHERE id = $1`,
      [id],
    );
    expect(rows[0]).toMatchObject({
      discount: '2400',
      discount_merchant: '1200',
      promo_code: code,
      promo_terms: {
        kind: 'percentage',
        percentBp: 1000,
        amount: null,
        maxDiscount: '3000',
        merchantShareBp: 5000,
      },
      total: '25500',
    });
    const uses = await sql.query(
      'SELECT status, discount, merchant_share FROM marketing.promo_code_uses WHERE order_id = $1',
      [id],
    );
    expect(uses.rows).toEqual([{ status: 'held', discount: '2400', merchant_share: '1200' }]);
  });

  it('refuses a code whose last use went since the quote, with the new quote', async () => {
    const code = await promoCode({ total_limit: 1 });
    const first = await appSignIn('customer', phoneNumber());
    const second = await appSignIn('customer', phoneNumber());
    const version = (await quote(code, second)).version;
    const placed = await place(first, code, (await quote(code, first)).version);
    expect(placed.statusCode).toBe(201);
    expect(placed.json().order).toMatchObject({
      money: { discount: '2400', total: '25500' },
      promoCode: code,
    });
    const refused = await place(second, code, version);
    expect(refused.statusCode).toBe(409);
    expect(refused.json()).toMatchObject({ error: 'order_blocked' });
    expect(refusalOf(refused.json().quote)).toBe('uses_ended');
    // Without it the order goes.
    expect((await place(second, null, (await quote(null, second)).version)).statusCode).toBe(201);
  });

  it('takes a new-user code for a first order only', async () => {
    const code = await promoCode({ audience: 'new_users' });
    const door = await orderAtDoor();
    const customer = door.order.customer;
    expect(refusalOf(await quote(code, customer))).toBeNull();
    // A delivered order makes the account no longer new (AP §9.11.1).
    expect((await door.deliver()).statusCode).toBe(200);
    expect(refusalOf(await quote(code, customer))).toBe('first_order_only');
  });
});
