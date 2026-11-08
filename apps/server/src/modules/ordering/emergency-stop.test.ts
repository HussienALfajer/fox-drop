import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { DATABASE } from '../../database/database.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { EmergencyStops } from './emergency-stop.js';

// AP §9.1.6 «الإيقاف الطارئ» (D7; CU §4.7, §10.6, §14 #18 and #19): the
// stop, the quote's refusal and attempts, the pushes, the broadcast rows and
// the automatic resume, served by the API app on a fresh database.

// A test signs in two customers and a cashier, places an order and quotes
// several times: a few seconds alone, so the default 5 s is too short for a
// full parallel run.
vi.setConfig({ testTimeout: 30_000 });
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
  // AP §9.12.5: a pay table in force, which placing needs (captain_pay_unset).
  const payRate = {
    basePay: 2500n,
    includedMetres: 3000,
    perExtraKm: 500n,
    waitingPerMinute: 0n,
    minimumPay: 2500n,
  };
  await app.get(CaptainsService).setPayTable(
    azaz,
    {
      currency: 'TRY',
      rates: { walking: payRate, bicycle: payRate, motorbike: payRate, car: payRate },
    },
    change,
  );
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
  // Every customer and restaurant user here signs in from one address.
  await settings.update('otp.ip_hourly_max', {}, 1000, bySystem);
  // The capacity check has its own tests (capacity-check.test.ts).
  await settings.update('dispatch.capacity_check', { cityId: azaz }, false, bySystem);
  const geo = app.get(GeoService);
  await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.setDeliveryFeeRule(
    azaz,
    { kind: 'flat', currency: 'TRY', flatFee: 4000n, minimumFee: null, freeDeliveryFrom: null },
    change,
  );
  merchants = app.get(MerchantsService);
  ({ id: restaurant, item: shawarma } = await restaurantWith('مطعم الاختبار'));
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

// A new customer, signed in: the headers of its calls.
async function signedIn({ acceptTerms = true } = {}): Promise<Record<string, string>> {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/customer/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  const headers = { authorization: `Bearer ${answer.json().accessToken}` };
  // CU §4.7: a customer orders once the terms in force (the seeded version 1)
  // are accepted.
  if (acceptTerms) {
    await app.inject({
      method: 'POST',
      url: '/v1/customer/terms/accept',
      headers,
      payload: { version: 1 },
    });
  }
  return headers;
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

async function quoteOf(restaurantId = restaurant, lines = cart(), headers = {}, extra = {}) {
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    headers,
    payload: { restaurantId, location: centre, lines, payIn: 'USD', appVersion: '1.0.0', ...extra },
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
  sql.query(
    "UPDATE ordering.orders SET status = 'cancelled', version = 2, cancelled_at = now(), cancel_reason = 'customer', food_prepared = false WHERE id = $1",
    [orderId],
  );

// A signed-in restaurant user of the restaurant: the headers of its calls.
async function merchantSignedIn(
  restaurantId: string,
  role: 'owner' | 'cashier' = 'cashier',
): Promise<Record<string, string>> {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role, name: role, phone }, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

// An active admin account with these roles, signed in.
async function admin(roles: string[]) {
  const { rows } = await sql.query(
    "INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted) VALUES ('مدير', $1, 'active', 'x', 'x') RETURNING id",
    [`${randomUUID()}@example.test`],
  );
  const accountId: string = rows[0].id;
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [accountId, role],
    );
  }
  const { token } = await app
    .get(AdminSessionsService)
    .start(
      app.get<{ db: never }>(DATABASE).db,
      accountId,
      { ipAddress: null, device: null },
      new Date(),
    );
  return { accountId, cookies: { [ADMIN_SESSION_COOKIE]: token } };
}

const dialog = () => ({
  cityId: azaz,
  internalReason: 'عاصفة',
  browseMessage: 'توقفنا مؤقتاً بسبب العاصفة',
  delayNotice: 'قد يتأخر طلبك قليلاً بسبب {السبب}.',
  customerReason: 'سوء الأحوال الجوية',
  resumeAt: null as string | null,
});

async function start(cookies: Record<string, string>, payload = dialog()) {
  return app.inject({ method: 'POST', url: '/v1/admin/emergency-stop', cookies, payload });
}

async function state(cookies: Record<string, string>) {
  return (
    await app.inject({ method: 'GET', url: `/v1/admin/emergency-stop?cityId=${azaz}`, cookies })
  ).json();
}

async function resume(
  cookies: Record<string, string>,
  stopId: string,
  serviceBack: string | null = null,
) {
  return app.inject({
    method: 'POST',
    url: '/v1/admin/emergency-stop/resume',
    cookies,
    payload: { cityId: azaz, stopId, serviceBack },
  });
}

const pushesOf = async (source: string) =>
  (
    await sql.query(
      'SELECT account_id, template_key, body, data FROM notifications.push_messages WHERE source LIKE $1 ORDER BY account_id',
      [source],
    )
  ).rows;

const customerRead = async () =>
  (
    await app.inject({
      method: 'GET',
      url: `/v1/customer/emergency-stop?latitude=${centre.latitude}&longitude=${centre.longitude}`,
    })
  ).json();

describe('the emergency stop (AP §9.1.6)', () => {
  it('lets only OWN and OPS start or resume it, and shows every panel user the bar', async () => {
    const sup = await admin(['SUP']);
    expect((await start(sup.cookies)).statusCode).toBe(403);
    expect((await resume(sup.cookies, randomUUID())).statusCode).toBe(403);
    expect(
      (await app.inject({ method: 'POST', url: '/v1/admin/emergency-stop', payload: dialog() }))
        .statusCode,
    ).toBe(401);
    // The dialog's prefills are for those who start it (AP §9.1.6).
    expect(await state(sup.cookies)).toEqual({ stop: null, defaults: null });
    const ops = await admin(['OPS']);
    expect(await state(ops.cookies)).toEqual({
      stop: null,
      defaults: {
        browseMessage: 'نعتذر، توقفنا مؤقتاً عن استقبال الطلبات. نعود قريباً.',
        delayNotice: 'قد يتأخر طلبك قليلاً بسبب {السبب}. نعتذر عن الانتظار.',
      },
    });
    const unknown = await start(ops.cookies, { ...dialog(), cityId: randomUUID() });
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json().error).toBe('unknown_city');
  });

  it('refuses new orders, counts each customer once, pushes the delay notice and resumes with «الخدمة عادت»', async () => {
    const ops = await admin(['OPS']);
    const active = await signedIn();
    const first = (await place(active)).json().order;
    const activeAccount = (
      await sql.query('SELECT customer_account_id FROM ordering.orders WHERE id = $1', [first.id])
    ).rows[0].customer_account_id;
    const trying = await signedIn();

    const started = await start(ops.cookies);
    expect(started.statusCode).toBe(201);
    const { stop } = started.json();
    expect(stop).toMatchObject({ startedBy: ops.accountId, resumeAt: null, attempts: 0 });
    const again = await start(ops.cookies);
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('already_stopped');

    // CU §14 #18: the customer with an active order, its reason filled in.
    expect(await pushesOf(`emergency-delay:${stop.id}:%`)).toEqual([
      {
        account_id: activeAccount,
        template_key: 'customer.emergency_delay',
        body: 'قد يتأخر طلبك قليلاً بسبب سوء الأحوال الجوية.',
        data: { target: 'order', orderId: first.id },
      },
    ]);

    // CU §10.6: the quote refuses with the browsing message; each signed-in
    // customer once, on opening checkout (not the cart's quote), a guest
    // not at all.
    const quote = await quoteOf(restaurant, cart(), trying);
    expect(quote.problems).toContainEqual({
      code: 'emergency_stop',
      line: null,
      opensAt: null,
      message: 'توقفنا مؤقتاً بسبب العاصفة',
    });
    expect((await state(ops.cookies)).stop).toMatchObject({ attempts: 0 });
    const checkout = { openedCheckout: true };
    await quoteOf(restaurant, cart(), trying, checkout);
    await quoteOf(restaurant, cart(), trying, checkout);
    await quoteOf(restaurant, cart(), {}, checkout);
    expect((await state(ops.cookies)).stop).toMatchObject({ id: stop.id, attempts: 1 });
    // The bar for every panel user: the time and the attempts only.
    const sup = await admin(['SUP']);
    expect(await state(sup.cookies)).toMatchObject({
      stop: { id: stop.id, attempts: 1, startedBy: null, internalReason: null },
      defaults: null,
    });
    const tryingAccount = (
      await sql.query(
        'SELECT customer_account_id FROM ordering.emergency_stop_attempts WHERE stop_id = $1',
        [stop.id],
      )
    ).rows[0].customer_account_id;
    expect(tryingAccount).not.toBe(activeAccount);
    const blocked = await place(trying);
    expect(blocked.statusCode).toBe(409);
    expect(blocked.json().error).toBe('order_blocked');

    expect(await customerRead()).toEqual({
      active: true,
      startedAt: stop.startedAt,
      browseMessage: 'توقفنا مؤقتاً بسبب العاصفة',
      delayNotice: 'قد يتأخر طلبك قليلاً بسبب سوء الأحوال الجوية.',
    });
    const cashier = await merchantSignedIn(restaurant);
    const merchantRead = await app.inject({
      method: 'GET',
      url: '/v1/merchant/emergency-stop',
      headers: cashier,
    });
    expect(merchantRead.json()).toEqual({ active: true, startedAt: stop.startedAt });

    // RA §18, CA §15, AP §7: the broadcast to the two apps and the panel.
    const broadcasts = await sql.query(
      "SELECT apps, ops, order_ids, payload FROM notifications.platform_outbox WHERE type = 'platform.emergency_stop' AND city_id = $1 ORDER BY id",
      [azaz],
    );
    expect(broadcasts.rows.at(-1)).toMatchObject({
      apps: ['merchant', 'captain'],
      ops: true,
      order_ids: [first.id],
      payload: { schema: 1, active: true },
    });

    expect((await resume(ops.cookies, randomUUID())).statusCode).toBe(404);
    const resumed = await resume(ops.cookies, stop.id, 'عادت الخدمة، اطلب الآن');
    expect(resumed.statusCode).toBe(200);
    const repeated = await resume(ops.cookies, stop.id);
    expect(repeated.statusCode).toBe(409);
    expect(repeated.json().error).toBe('stop_ended');
    // CU §14 #19: only the customer who tried.
    expect(await pushesOf(`emergency-back:${stop.id}:%`)).toEqual([
      {
        account_id: tryingAccount,
        template_key: 'customer.service_back',
        body: 'عادت الخدمة، اطلب الآن',
        data: { target: 'home' },
      },
    ]);
    expect((await state(ops.cookies)).stop).toBeNull();
    expect((await customerRead()).active).toBe(false);
    const after = await quoteOf(restaurant, cart(), trying);
    expect(after.problems.map((entry: { code: string }) => entry.code)).not.toContain(
      'emergency_stop',
    );

    const audit = await sql.query(
      'SELECT action, actor_id, reason FROM audit.events WHERE target_id = $1 ORDER BY occurred_at',
      [stop.id],
    );
    expect(audit.rows).toEqual([
      { action: 'emergency_stop.start', actor_id: ops.accountId, reason: 'عاصفة' },
      { action: 'emergency_stop.resume', actor_id: ops.accountId, reason: null },
    ]);
    await end(first.id);
  });

  it('resumes automatically at its time, with its timer written with it and no push', async () => {
    const own = await admin(['OWN']);
    const past = await start(own.cookies, {
      ...dialog(),
      resumeAt: new Date(Date.now() - 1000).toISOString(),
    });
    expect(past.statusCode).toBe(400);
    expect(past.json().error).toBe('resume_at_past');

    const resumeAt = new Date(Date.now() + 3_600_000).toISOString();
    const { stop } = (await start(own.cookies, { ...dialog(), resumeAt })).json();
    expect(stop.resumeAt).toBe(resumeAt);
    const job = await sql.query(
      "SELECT start_after FROM pgboss.job WHERE name = 'ordering-emergency-resume' AND data->>'stopId' = $1",
      [stop.id],
    );
    expect(job.rows[0].start_after.toISOString()).toBe(resumeAt);

    const stops = app.get(EmergencyStops);
    expect(await stops.autoResume({ stopId: stop.id }, new Date())).toBe(true);
    expect(await stops.autoResume({ stopId: stop.id }, new Date())).toBe(false);
    const ended = await sql.query(
      'SELECT end_kind, ended_by, service_back_message FROM ordering.emergency_stops WHERE id = $1',
      [stop.id],
    );
    expect(ended.rows[0]).toEqual({
      end_kind: 'automatic',
      ended_by: null,
      service_back_message: null,
    });
    const audit = await sql.query(
      "SELECT actor_type FROM audit.events WHERE target_id = $1 AND action = 'emergency_stop.resume'",
      [stop.id],
    );
    expect(audit.rows).toEqual([{ actor_type: 'system' }]);
    expect((await state(own.cookies)).stop).toBeNull();
  });
});

describe("the broadcast of an app's platform settings (2.4a, RA §18, CA §15)", () => {
  it("writes one for the restaurant and captain apps' settings, in the change's transaction", async () => {
    const settings = app.get(SettingsService);
    const count = async () =>
      (
        await sql.query(
          "SELECT payload->>'app' AS app FROM notifications.platform_outbox WHERE type = 'platform.app_changed' ORDER BY id",
        )
      ).rows.map((row) => row.app);
    const before = await count();
    await settings.update(
      'app.<app>.maintenance',
      { parameter: 'merchant' },
      { enabled: true, message: null },
      bySystem,
    );
    await settings.update('app.<app>.min_version', { parameter: 'captain' }, '1.2.0', bySystem);
    // The customer app has no channel yet; another setting is no broadcast.
    await settings.update('app.<app>.min_version', { parameter: 'customer' }, '1.0.0', bySystem);
    await settings.update('order.eta_buffer_min', { cityId: azaz }, 7, bySystem);
    // A change that leaves the value as it was writes nothing.
    await settings.update('app.<app>.min_version', { parameter: 'captain' }, '1.2.0', bySystem);
    expect(await count()).toEqual([...before, 'merchant', 'captain']);
    await settings.reset('app.<app>.maintenance', { parameter: 'merchant' }, bySystem);
  });
});
