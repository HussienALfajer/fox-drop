import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';

// Placing the order (CU §10.7; AP §8.1, §8.4, §8.6, §4.8; RA §7.4; D23),
// served by the API app on a fresh database. TRY is the base with a 5 TRY
// rounding unit; USD is accepted at 40 TRY. The delivery fee is a flat 40 TRY.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let azaz: string;
let fx: FxService;
let merchants: MerchantsService;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const fin = {
  actor: { type: 'admin', id: randomUUID(), role: 'FIN' },
  context: change.context,
} as const;
const tryAmount = (amount: bigint) => ({ amount, currency: 'TRY' });
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;

function square({ latitude, longitude }: Point, half = 0.02): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

const centre = { latitude: 36.587, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

let shawarma: string;
let meals: string;

async function restaurantWith(name: string): Promise<{ id: string; item: string }> {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: name,
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: tryAmount(10_000n),
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  await merchants.setWeeklySchedule(id, allWeek, change);
  const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
  const item = await merchants.addItem(
    id,
    { categoryId: category, name: 'شاورما', price: tryAmount(12_000n) },
    change,
  );
  return { id, item };
}

let restaurant: string;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  const settings = app.get(SettingsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: false }, change);
  await fx.setRate(azaz, 'USD', { value: '40', direction: 'base_per_unit' }, fin);
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: true }, change);
  for (const [code, amountMinor] of [
    ['TRY', 500],
    ['USD', 50],
  ] as const) {
    await settings.update(
      'currency.<code>.rounding_unit',
      { cityId: azaz, parameter: code },
      { amountMinor },
      bySystem,
    );
  }
  const geo = app.get(GeoService);
  await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.setDeliveryFeeRule(
    azaz,
    { kind: 'flat', currency: 'TRY', flatFee: 4000n, minimumFee: null, freeDeliveryFrom: null },
    change,
  );
  merchants = app.get(MerchantsService);
  ({ id: restaurant, item: shawarma } = await restaurantWith('مطعم الاختبار'));
  meals = (await sql.query('SELECT category_id FROM merchants.items WHERE id = $1', [shawarma]))
    .rows[0].category_id;
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

// A new customer, signed in: the headers of its calls.
async function signedIn(): Promise<Record<string, string>> {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/customer/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

const unsaved = {
  location: centre,
  street: 'شارع السوق، بناء 4',
  floor: null,
  landmark: 'قرب جامع النور',
  contactPhone: null,
  recipientName: null,
  directions: null,
};

const cart = (itemId = shawarma, quantity = 2) => [
  { itemId, optionIds: [], quantity, note: null, knownUnitPrice: '12000' },
];

async function quoteOf(restaurantId = restaurant, lines = cart(), headers = {}) {
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    headers,
    payload: { restaurantId, location: centre, lines, payIn: 'USD', appVersion: '1.0.0' },
  });
  return answer.json();
}

async function place(
  headers: Record<string, string>,
  extra: Record<string, unknown> = {},
  key: string = randomUUID(),
) {
  const restaurantId = (extra.restaurantId as string | undefined) ?? restaurant;
  const lines = (extra.lines as ReturnType<typeof cart> | undefined) ?? cart();
  const { version } = await quoteOf(restaurantId, lines);
  return app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...headers, 'idempotency-key': key },
    payload: {
      restaurantId,
      lines,
      payIn: 'USD',
      appVersion: '1.0.0',
      quoteVersion: version,
      addressId: null,
      unsavedAddress: unsaved,
      note: 'الرجاء الاتصال عند الوصول',
      ...extra,
    },
  });
}

// An order leaves the restaurant's and the customer's active orders.
const end = (orderId: string) =>
  sql.query("UPDATE ordering.orders SET status = 'cancelled', version = 2 WHERE id = $1", [
    orderId,
  ]);

describe('POST /v1/customer/orders (CU §10.7)', () => {
  it('places the order as the quote priced it, numbered from 10001, with its snapshots', async () => {
    const headers = await signedIn();
    const quote = await quoteOf();
    const answer = await place(headers);
    expect(answer.statusCode).toBe(201);
    const { order } = answer.json();
    expect(order).toMatchObject({
      status: 'placed',
      number: '10001',
      restaurantId: restaurant,
      currency: 'TRY',
      money: quote.money,
      payIn: 'USD',
      note: 'الرجاء الاتصال عند الوصول',
      estimate: quote.estimate,
      lines: [
        { itemId: shawarma, name: 'شاورما', quantity: 2, unitPrice: '12000', lineTotal: '24000' },
      ],
      address: { neighbourhood: 'المركز', street: unsaved.street, landmark: unsaved.landmark },
    });
    // AP §8.4: 24 000 + 4 000 = 28 000, already on the 5 TRY unit.
    expect(order.money).toMatchObject({ itemsValue: '24000', deliveryFee: '4000', total: '28000' });
    const { rows } = await sql.query(
      'SELECT o.commission_bp, o.fee_rule_id, o.rate_snapshot, e.to_status, e.actor_type, e.version FROM ordering.orders o JOIN ordering.order_events e ON e.order_id = o.id WHERE o.id = $1',
      [order.id],
    );
    expect(rows).toHaveLength(1);
    expect(rows[0]).toMatchObject({
      commission_bp: 1500,
      fee_rule_id: (await sql.query('SELECT id FROM geo.fee_rules ORDER BY id DESC LIMIT 1'))
        .rows[0].id,
      to_status: 'placed',
      actor_type: 'customer',
      version: 1,
    });
    // AP §8.6: the rates it was placed with, the bigints as strings.
    expect(rows[0].rate_snapshot).toMatchObject({
      baseCurrency: 'TRY',
      currencies: expect.arrayContaining([
        expect.objectContaining({
          code: 'USD',
          rate: { numerator: expect.any(String), denominator: expect.any(String) },
        }),
      ]),
    });
    // D25: the first order locks the city's base currency.
    expect(await fx.baseLocked(azaz)).toBe(true);
    await end(order.id);
    const next = await place(headers);
    expect(next.json().order.number).toBe('10002');
    await end(next.json().order.id);
  });

  it('keeps a copy of a saved address, so editing it changes no order (Q6)', async () => {
    const headers = await signedIn();
    const saved = await app.inject({
      method: 'POST',
      url: '/v1/customer/addresses',
      headers,
      payload: { ...unsaved, label: 'home', customLabel: null, isDefault: true },
    });
    const addressId = saved.json().id;
    const answer = await place(headers, { addressId, unsavedAddress: null });
    expect(answer.statusCode).toBe(201);
    await app.inject({
      method: 'PUT',
      url: `/v1/customer/addresses/${addressId}`,
      headers,
      payload: { ...unsaved, street: 'شارع آخر', label: 'work', customLabel: null },
    });
    const { rows } = await sql.query(
      'SELECT address_id, label, street FROM ordering.orders WHERE id = $1',
      [answer.json().order.id],
    );
    expect(rows[0]).toEqual({ address_id: addressId, label: 'home', street: unsaved.street });
    await end(answer.json().order.id);
  });

  it('refuses an unknown address with 404 unknown_address', async () => {
    const answer = await place(await signedIn(), { addressId: randomUUID(), unsavedAddress: null });
    expect(answer.statusCode).toBe(404);
    expect(answer.json().error).toBe('unknown_address');
  });

  it('refuses a stale quote version with 409 quote_changed and the new quote (Q10)', async () => {
    const headers = await signedIn();
    const answer = await place(headers, { quoteVersion: 'stale' });
    expect(answer.statusCode).toBe(409);
    expect(answer.json()).toMatchObject({ error: 'quote_changed', quote: await quoteOf() });
  });

  it('refuses once an exchange rate changed after the quote (AP §8.6)', async () => {
    const headers = await signedIn();
    const { version } = await quoteOf();
    await fx.setRate(azaz, 'USD', { value: '41', direction: 'base_per_unit' }, fin);
    const answer = await app.inject({
      method: 'POST',
      url: '/v1/customer/orders',
      headers: { ...headers, 'idempotency-key': randomUUID() },
      payload: {
        restaurantId: restaurant,
        lines: cart(),
        payIn: 'USD',
        appVersion: '1.0.0',
        quoteVersion: version,
        addressId: null,
        unsavedAddress: unsaved,
        note: null,
      },
    });
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('quote_changed');
    expect(answer.json().quote.version).not.toBe(version);
  });

  it('refuses a blocking problem with 409 order_blocked and keeps nothing', async () => {
    const headers = await signedIn();
    const before = (await sql.query('SELECT count(*)::int AS n FROM ordering.orders')).rows[0].n;
    const answer = await place(headers, { lines: cart(randomUUID()) });
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('order_blocked');
    expect(answer.json().quote.problems).toContainEqual(
      expect.objectContaining({ code: 'item_not_found', line: 0 }),
    );
    expect((await sql.query('SELECT count(*)::int AS n FROM ordering.orders')).rows[0].n).toBe(
      before,
    );
  });

  it('refuses a note with a phone number (Q25) and a command without its key', async () => {
    const headers = await signedIn();
    expect((await place(headers, { note: 'اتصل 0991234567' })).statusCode).toBe(400);
    const answer = await app.inject({
      method: 'POST',
      url: '/v1/customer/orders',
      headers,
      payload: {},
    });
    expect(answer.statusCode).toBe(400);
  });

  it('needs a signed-in customer', async () => {
    const answer = await app.inject({ method: 'POST', url: '/v1/customer/orders', payload: {} });
    expect(answer.statusCode).toBe(401);
  });
});

describe('the active-order limits (D23, RA §7.4)', () => {
  it('lets a new account have one active order, shown in its quote (CU §5.5)', async () => {
    const headers = await signedIn();
    const first = await place(headers);
    expect(first.statusCode).toBe(201);
    const second = await place(headers);
    expect(second.statusCode).toBe(409);
    expect(second.json().error).toBe('order_blocked');
    expect(second.json().quote.problems).toContainEqual(
      expect.objectContaining({ code: 'one_order_at_a_time' }),
    );
    expect((await quoteOf(restaurant, cart(), headers)).problems).toContainEqual(
      expect.objectContaining({ code: 'one_order_at_a_time' }),
    );
    expect((await quoteOf()).problems).toEqual([]);
    await end(first.json().order.id);
    expect((await place(headers)).statusCode).toBe(201);
  });

  it('never places two orders at once for a new account', async () => {
    const headers = await signedIn();
    const answers = await Promise.all([place(headers), place(headers), place(headers)]);
    expect(answers.map((answer) => answer.statusCode).sort()).toEqual([201, 409, 409]);
    await end(answers.find((answer) => answer.statusCode === 201)!.json().order.id);
  });

  it('gives a trusted account three active orders after three delivered', async () => {
    const headers = await signedIn();
    const placed: string[] = [];
    for (let index = 0; index < 3; index += 1) {
      const answer = await place(headers);
      placed.push(answer.json().order.id);
      await sql.query("UPDATE ordering.orders SET status = 'delivered' WHERE id = $1", [
        answer.json().order.id,
      ]);
    }
    for (let index = 0; index < 3; index += 1) {
      expect((await place(headers)).statusCode).toBe(201);
    }
    const fourth = await place(headers);
    expect(fourth.json().quote.problems).toContainEqual(
      expect.objectContaining({ code: 'active_order_limit' }),
    );
    await sql.query(
      "UPDATE ordering.orders SET status = 'cancelled' WHERE status = 'placed' AND restaurant_id = $1",
      [restaurant],
    );
  });

  it("never lets two customers take a restaurant's last place, and shows it busy", async () => {
    const { id, item } = await restaurantWith('مطعم بحد أقصى');
    await sql.query('UPDATE merchants.restaurants SET max_active_orders = 1 WHERE id = $1', [id]);
    const lines = cart(item);
    const customers = await Promise.all([signedIn(), signedIn(), signedIn()]);
    const answers = await Promise.all(
      customers.map((headers) => place(headers, { restaurantId: id, lines })),
    );
    expect(answers.map((answer) => answer.statusCode).sort()).toEqual([201, 409, 409]);
    expect(
      answers.filter((answer) => answer.statusCode === 409).map((answer) => answer.json().error),
    ).toEqual(['order_blocked', 'order_blocked']);
    expect((await merchants.storefrontState(id)).state.state).toBe('busy');
    const quote = await quoteOf(id, lines);
    expect(quote.restaurant.state).toBe('busy');
    expect(quote.problems).toContainEqual(expect.objectContaining({ code: 'restaurant_closed' }));
    await end(answers.find((answer) => answer.statusCode === 201)!.json().order.id);
    expect((await merchants.storefrontState(id)).state.state).toBe('open');
  });
});

describe('the Idempotency-Key (architecture §5.3)', () => {
  it('answers a repeat with the order it placed, and places it once', async () => {
    const headers = await signedIn();
    const key = randomUUID();
    const first = await place(headers, {}, key);
    const again = await place(headers, {}, key);
    expect(again.statusCode).toBe(201);
    expect(again.json()).toEqual(first.json());
    const { rows } = await sql.query(
      'SELECT count(*)::int AS n FROM ordering.orders WHERE customer_account_id = (SELECT customer_account_id FROM ordering.orders WHERE id = $1)',
      [first.json().order.id],
    );
    expect(rows[0].n).toBe(1);
    await end(first.json().order.id);
  });

  it('places one order for repeats sent together', async () => {
    const headers = await signedIn();
    const key = randomUUID();
    const answers = await Promise.all([place(headers, {}, key), place(headers, {}, key)]);
    expect(answers.map((answer) => answer.statusCode)).toEqual([201, 201]);
    expect(answers[0]!.json().order.id).toBe(answers[1]!.json().order.id);
    await end(answers[0]!.json().order.id);
  });

  it('refuses the key sent again with another command with 422', async () => {
    const headers = await signedIn();
    const key = randomUUID();
    const first = await place(headers, {}, key);
    const other = await place(headers, { note: 'بدون بصل' }, key);
    expect(other.statusCode).toBe(422);
    expect(other.json().error).toBe('idempotency_key_reused');
    await end(first.json().order.id);
  });

  it('refuses an item switched off after the quote with order_blocked, whatever the key', async () => {
    const headers = await signedIn();
    const { version } = await quoteOf();
    await merchants.setAvailability(
      restaurant,
      { type: 'category', id: meals },
      { available: false, until: 'turned_back_on' },
      change,
    );
    const answer = await app.inject({
      method: 'POST',
      url: '/v1/customer/orders',
      headers: { ...headers, 'idempotency-key': randomUUID() },
      payload: {
        restaurantId: restaurant,
        lines: cart(),
        payIn: null,
        appVersion: '1.0.0',
        quoteVersion: version,
        addressId: null,
        unsavedAddress: unsaved,
        note: null,
      },
    });
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('order_blocked');
    await merchants.setAvailability(
      restaurant,
      { type: 'category', id: meals },
      { available: true },
      change,
    );
  });
});

describe('placing, at the edges (CU §10.7, architecture §5.3)', () => {
  it('refuses a saved address of another customer with 404 unknown_address', async () => {
    const owner = await signedIn();
    const saved = await app.inject({
      method: 'POST',
      url: '/v1/customer/addresses',
      headers: owner,
      payload: { ...unsaved, label: 'home', customLabel: null, isDefault: true },
    });
    const answer = await place(await signedIn(), {
      addressId: saved.json().id,
      unsavedAddress: null,
    });
    expect(answer.statusCode).toBe(404);
    expect(answer.json().error).toBe('unknown_address');
  });

  it('refuses rates that changed inside the transaction with quote_changed and keeps nothing', async () => {
    const headers = await signedIn();
    const original = fx.snapshotForOrder.bind(fx);
    const spy = vi.spyOn(fx, 'snapshotForOrder').mockImplementationOnce(async (cityId, tx) => {
      const snapshot = await original(cityId, tx);
      return {
        ...snapshot,
        currencies: snapshot.currencies.map((entry) =>
          entry.code === 'USD' ? { ...entry, rateVersionId: randomUUID() } : entry,
        ),
      };
    });
    const before = (await sql.query('SELECT count(*)::int AS n FROM ordering.orders')).rows[0].n;
    const answer = await place(headers);
    spy.mockRestore();
    expect(answer.statusCode).toBe(409);
    expect(answer.json()).toMatchObject({ error: 'quote_changed', quote: await quoteOf() });
    expect((await sql.query('SELECT count(*)::int AS n FROM ordering.orders')).rows[0].n).toBe(
      before,
    );
  });

  it('answers repeats sent together with one order when it fills the restaurant', async () => {
    const { id, item } = await restaurantWith('مطعم بمكان واحد');
    await sql.query('UPDATE merchants.restaurants SET max_active_orders = 1 WHERE id = $1', [id]);
    const headers = await signedIn();
    const key = randomUUID();
    const extra = { restaurantId: id, lines: cart(item) };
    const answers = await Promise.all([place(headers, extra, key), place(headers, extra, key)]);
    expect(answers.map((answer) => answer.statusCode)).toEqual([201, 201]);
    expect(answers[0]!.json().order.id).toBe(answers[1]!.json().order.id);
    await end(answers[0]!.json().order.id);
  });

  it('places a new order with a key older than 24 hours', async () => {
    const headers = await signedIn();
    const key = randomUUID();
    const first = await place(headers, {}, key);
    await end(first.json().order.id);
    await sql.query(
      "UPDATE ordering.idempotency_keys SET created_at = now() - interval '25 hours' WHERE key = $1",
      [key],
    );
    const again = await place(headers, {}, key);
    expect(again.statusCode).toBe(201);
    expect(again.json().order.id).not.toBe(first.json().order.id);
    await end(again.json().order.id);
  });

  it('keeps one key per account, so two customers may send the same', async () => {
    const key = randomUUID();
    const answers = [
      await place(await signedIn(), {}, key),
      await place(await signedIn(), {}, key),
    ];
    expect(answers.map((answer) => answer.statusCode)).toEqual([201, 201]);
    expect(answers[0]!.json().order.id).not.toBe(answers[1]!.json().order.id);
    for (const answer of answers) await end(answer.json().order.id);
  });

  it('answers a quote with a token that fails with 401, so the app refreshes it', async () => {
    const answer = await app.inject({
      method: 'POST',
      url: '/v1/customer/quote',
      headers: { authorization: 'Bearer nonsense' },
      payload: {
        restaurantId: restaurant,
        location: centre,
        lines: cart(),
        payIn: null,
        appVersion: '1.0.0',
      },
    });
    expect(answer.statusCode).toBe(401);
  });
});
