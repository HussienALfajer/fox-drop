import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
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
} from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';

// AP §9.5 «سجل الطلبات» (slice 2.40): every order of the city by the filters,
// newest first; a finished order read-only but for OWN's and FIN's financial
// correction, an adjustment linked to it (owner decision 2026-11-20); the
// Excel export.

vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let db: Database;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let azaz: string;
let zone: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const centre = { latitude: 36.587, longitude: 37.046 };
const home = { latitude: 36.59, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

function square({ latitude, longitude }: Point, half = 0.05): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
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
  const settings = app.get(SettingsService);
  await settings.update('dispatch.capacity_check', { cityId: azaz }, false, bySystem);
  await settings.update('otp.ip_hourly_max', {}, 1000, bySystem);
  await settings.update(
    'currency.<code>.rounding_unit',
    { cityId: azaz, parameter: 'TRY' },
    { amountMinor: 500 },
    bySystem,
  );
  const geo = app.get(GeoService);
  zone = await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.setDeliveryFeeRule(
    azaz,
    { kind: 'flat', currency: 'TRY', flatFee: 4000n, minimumFee: null, freeDeliveryFrom: null },
    change,
  );
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const phoneNumber = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Admin ${accounts}`, `order-history${accounts}@example.test`],
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
    .start(db.db, accountId, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return {
    accountId,
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    post: (url: string, payload: object, key: string | null = randomUUID()) =>
      app.inject({
        method: 'POST',
        url,
        cookies,
        headers: key === null ? {} : { 'idempotency-key': key },
        payload,
      }),
  };
}

async function signIn(party: 'customer' | 'merchant', phone: string) {
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: `/v1/${party}/auth/code`, payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/${party}/auth/sign-in`,
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  const headers = { authorization: `Bearer ${answer.json().accessToken}` };
  if (party === 'customer') {
    await app.inject({
      method: 'POST',
      url: '/v1/customer/terms/accept',
      headers,
      payload: { version: 1 },
    });
  } else {
    await app.inject({
      method: 'PUT',
      url: '/v1/merchant/auth/device',
      headers,
      payload: { name: 'كاشير', platform: 'android', appVersion: '1.0.0' },
    });
  }
  return headers;
}

async function restaurant(nameAr: string) {
  const merchants = app.get(MerchantsService);
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr,
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
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
    { categoryId: category, name: 'شاورما', price: { amount: 12_000n, currency: 'TRY' } },
    change,
  );
  return { id, item };
}

async function place(restaurantId: string, itemId: string, customer: Record<string, string>) {
  const lines = [{ itemId, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' }];
  const quote = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: { restaurantId, location: home, lines, payIn: null, appVersion: '1.0.0' },
  });
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...customer, 'idempotency-key': randomUUID() },
    payload: {
      restaurantId,
      lines,
      payIn: null,
      appVersion: '1.0.0',
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
  expect(answer.statusCode).toBe(201);
  return answer.json().order as { id: string; number: string };
}

async function cancel(orderId: string, customer: Record<string, string>) {
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/customer/orders/${orderId}/cancel`,
    headers: { ...customer, 'idempotency-key': randomUUID() },
    payload: { reason: 'changed_mind', note: null },
  });
  expect(answer.statusCode).toBe(200);
}

// The business days around today on the city's clock, wide enough for any
// cutoff.
function period() {
  const dayOf = (ms: number) =>
    new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Damascus' }).format(new Date(ms));
  return { from: dayOf(Date.now() - 2 * 86_400_000), to: dayOf(Date.now() + 86_400_000) };
}

const noFilters = {
  number: null,
  customerPhone: null,
  restaurantId: null,
  captainId: null,
  from: null,
  to: null,
  status: null,
  outcome: null,
  responsible: null,
  code: null,
  zoneId: null,
  kind: 'all',
};

type HistoryRow = {
  id: string;
  number: string;
  restaurantName: string;
  neighbourhood: string;
  status: string;
  total: { amount: string; currency: string };
  deliveryMinutes: number | null;
  testOrder: boolean;
};

describe('POST /v1/admin/order-history (AP §9.5)', () => {
  it('lists the orders by the filters, newest first, the phone for OWN, OPS and SUP only', async () => {
    const owner = await admin(['OWN']);
    const finance = await admin(['FIN']);
    const first = await restaurant('مطعم السجل الأول');
    const second = await restaurant('مطعم السجل الثاني');
    const phone = phoneNumber();
    const customer = await signIn('customer', phone);
    const a = await place(first.id, first.item, customer);
    await cancel(a.id, customer);
    const b = await place(second.id, second.item, customer);
    const list = async (who: typeof owner, filters: object) => {
      const answer = await who.post(
        '/v1/admin/order-history',
        { cityId: azaz, cursor: null, ...noFilters, ...filters },
        null,
      );
      return answer;
    };
    const ids = async (filters: object) =>
      ((await list(owner, filters)).json().orders as HistoryRow[]).map((row) => row.id);

    const all = await list(owner, { customerPhone: phone });
    expect(all.statusCode).toBe(200);
    expect(all.json().next).toBeNull();
    const rows = all.json().orders as HistoryRow[];
    expect(rows.map((row) => row.id)).toEqual([b.id, a.id]);
    expect(rows[1]).toMatchObject({
      number: a.number,
      restaurantName: 'مطعم السجل الأول',
      neighbourhood: 'المركز',
      status: 'cancelled',
      total: { amount: '16000', currency: 'TRY' },
      deliveryMinutes: null,
      testOrder: false,
    });
    expect(await ids({ customerPhone: phone, restaurantId: second.id })).toEqual([b.id]);
    expect(await ids({ customerPhone: phone, status: 'cancelled' })).toEqual([a.id]);
    expect(await ids({ number: `#${a.number}` })).toEqual([a.id]);
    expect(await ids({ customerPhone: phone, zoneId: zone, ...period() })).toEqual([b.id, a.id]);
    expect(await ids({ customerPhone: phone, kind: 'test' })).toEqual([]);
    expect(await ids({ customerPhone: phone, code: 'NONE' })).toEqual([]);
    // A number of no account matches nothing.
    expect(await ids({ customerPhone: phoneNumber() })).toEqual([]);

    // FIN reads the history but not by a phone (customers.reveal_phone).
    expect((await list(finance, { number: a.number })).json().orders).toHaveLength(1);
    const refused = await list(finance, { customerPhone: phone });
    expect(refused.statusCode).toBe(403);
    expect(refused.json().error).toBe('phone_not_allowed');
    expect((await list(owner, { customerPhone: 'abc' })).json().error).toBe('invalid_phone');
    const backwards = await list(owner, { from: '2026-02-02', to: '2026-02-01' });
    expect(backwards.json().error).toBe('invalid_period');
    // DATA has no history.
    expect((await list(await admin(['DATA']), {})).statusCode).toBe(403);
  });
});

describe('the financial correction (AP §9.5, §9.10.7)', () => {
  it("adjusts a finished order's restaurant account, linked to the order, for OWN and FIN only", async () => {
    const owner = await admin(['OWN']);
    const support = await admin(['SUP']);
    const finance = await admin(['FIN']);
    const ordered = await restaurant('مطعم التصحيح');
    const other = await restaurant('مطعم آخر');
    const customer = await signIn('customer', phoneNumber());
    const order = await place(ordered.id, ordered.item, customer);
    const url = `/v1/admin/orders/${order.id}/financial-corrections`;
    const body = {
      party: 'restaurant',
      partyId: ordered.id,
      account: 'merchant.account',
      currency: 'TRY',
      amount: '-500',
      reason: 'تعويض المطعم عن خطأ',
    };

    // An active order is not corrected.
    const active = await owner.post(url, body);
    expect(active.statusCode).toBe(409);
    expect(active.json().error).toBe('order_not_finished');
    expect((await owner.get(url)).json()).toMatchObject({ finished: false, canCorrect: false });

    await cancel(order.id, customer);
    const choices = await owner.get(url);
    expect(choices.json()).toMatchObject({ finished: true, canCorrect: true, entries: [] });
    expect(choices.json().accounts).toEqual([
      {
        partyKind: 'restaurant',
        partyId: ordered.id,
        partyName: 'مطعم التصحيح',
        account: 'merchant.account',
        currencies: ['TRY'],
      },
    ]);

    const ledger = app.get(LedgerService);
    const balance = async () => {
      const [account] = await ledger.ownerAccounts(azaz, ordered.id, 'merchant.account');
      return account ? (await ledger.balance(account.id)).amount : 0n;
    };
    const before = await balance();
    const key = randomUUID();
    const posted = await finance.post(url, body, key);
    expect(posted.statusCode).toBe(201);
    expect(posted.json()).toMatchObject({
      kind: 'adjustment',
      partyKind: 'restaurant',
      partyId: ordered.id,
      reason: 'تعويض المطعم عن خطأ',
      orderId: order.id,
      orderNumber: order.number,
      journal: {
        type: 'merchant.adjustment',
        lines: [{ purpose: 'merchant.account', currency: 'TRY', amount: '-500' }],
      },
    });
    // The restaurant's account moved by −500: the restaurant owes 500 less.
    expect(await balance()).toBe(before - 500n);
    // A repeat of the key answers the same entry.
    expect((await finance.post(url, body, key)).json().id).toBe(posted.json().id);
    expect(await balance()).toBe(before - 500n);

    // Listed under the order, and in «القيود التصحيحية» with its order.
    const listed = await support.get(url);
    expect(listed.json()).toMatchObject({ canCorrect: false, accounts: [] });
    expect(listed.json().entries.map((each: { id: string }) => each.id)).toEqual([
      posted.json().id,
    ]);
    const all = (await owner.get(`/v1/admin/manual-entries?cityId=${azaz}`)).json().entries as {
      id: string;
      orderNumber: string | null;
    }[];
    expect(all.find((each) => each.id === posted.json().id)?.orderNumber).toBe(order.number);

    // Only the order's own parties, only OWN and FIN.
    const notParty = await owner.post(url, { ...body, partyId: other.id });
    expect(notParty.statusCode).toBe(400);
    expect(notParty.json().error).toBe('not_order_party');
    expect((await support.post(url, body)).statusCode).toBe(403);
    expect(
      (await owner.post(`/v1/admin/orders/${randomUUID()}/financial-corrections`, body)).json()
        .error,
    ).toBe('unknown_order');
    expect((await owner.post(url, { ...body, reason: ' ' })).statusCode).toBe(400);
  });
});

describe('POST /v1/admin/order-history/exports', () => {
  it('records the export of a period for any reader of the history', async () => {
    const support = await admin(['SUP']);
    const asked = await support.post('/v1/admin/order-history/exports', {
      cityId: azaz,
      ...noFilters,
      ...period(),
    });
    expect(asked.statusCode).toBe(202);
    expect(asked.json()).toMatchObject({ kind: 'order_history', status: 'pending' });
    expect(asked.json().fileName).toMatch(/^سجل الطلبات .+\.xlsx$/);
    const read = await support.get(`/v1/admin/exports/${asked.json().id}`);
    expect(read.statusCode).toBe(200);
    // An export needs a period.
    const without = await support.post('/v1/admin/order-history/exports', {
      cityId: azaz,
      ...noFilters,
    });
    expect(without.statusCode).toBe(400);
  });
});
