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
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';
import { SettingsService } from '../settings/index.js';
import { CashDeskService, type DeskUser } from './cashdesk.service.js';

// AP §8.8, §9.8 «تسجيل دفع المستحق» (slice 2.25a; owner decisions
// 2026-11-17): FIN records the customer's payment at the desk, in part or in
// full, in any accepted currency, with a numbered receipt; the dues block
// lifts by itself once the dues reach zero.
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let desk: CashDeskService;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;

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
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: false }, change);
  await fx.setRate(
    azaz,
    'USD',
    { value: '40', direction: 'base_per_unit' },
    { ...change, actor: { type: 'admin', id: randomUUID(), role: 'FIN' } },
  );
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: true }, change);
  const settings = app.get(SettingsService);
  for (const [code, unit] of [
    ['TRY', 100],
    ['USD', 50],
  ] as const) {
    await settings.update(
      'currency.<code>.rounding_unit',
      { cityId: azaz, parameter: code },
      { amountMinor: unit },
      bySystem,
    );
  }
  // The app reads the dues at the selected point's city.
  const [latitude, longitude, half] = [36.587, 37.046, 0.05];
  await app.get(GeoService).createZone(
    azaz,
    {
      name: 'المركز',
      area: [
        { latitude: latitude - half, longitude: longitude - half },
        { latitude: latitude - half, longitude: longitude + half },
        { latitude: latitude + half, longitude: longitude + half },
        { latitude: latitude + half, longitude: longitude - half },
      ],
      active: true,
    },
    change,
  );
  desk = app.get(CashDeskService);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Dues desk ${accounts}`, `dues-desk${accounts}@example.test`],
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
  const user: DeskUser = {
    accountId,
    roles,
    actor: { type: 'admin', id: accountId, role: roles.join(',') },
    context: { ipAddress: '203.0.113.9', device: 'test' },
  };
  return {
    user,
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

// A signed-in customer with their details and dues of `amount` from a block
// «حتى دفع مستحق».
async function customerOwing(amount: string) {
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
  const id = JSON.parse(
    Buffer.from(answer.json().accessToken.split('.')[1], 'base64url').toString(),
  ).sub as string;
  await app.inject({
    method: 'PUT',
    url: '/v1/customer/profile',
    headers,
    payload: {
      firstName: 'رامي',
      lastName: null,
      gender: 'male',
      birthday: null,
      acceptTerms: true,
    },
  });
  const blocked = await (
    await admin(['OWN'])
  ).post(`/v1/admin/customers/${id}/block`, {
    cityId: azaz,
    kind: 'dues',
    until: null,
    amount,
    reason: 'fake_order',
    note: 'طلب لم يُستلم',
  });
  expect(blocked.statusCode).toBe(201);
  return { id, headers };
}

async function openDesk() {
  const cashier = await admin(['FIN']);
  await desk.openSession(cashier.user, azaz, [{ currency: 'TRY', amount: 0n }], new Date());
  return cashier;
}

const banner = async (headers: Record<string, string>) =>
  (
    await app.inject({
      method: 'GET',
      url: '/v1/customer/account-state?latitude=36.587&longitude=37.046',
      headers,
    })
  ).json();

describe('«تسجيل دفع المستحق» (AP §8.8, §9.8)', () => {
  it('takes part of the dues, then the rest in dollars, and the block lifts by itself at zero', async () => {
    const buyer = await customerOwing('10000');
    const cashier = await openDesk();
    const empty = await cashier.post(
      '/v1/admin/cash-desk/customer-dues/preview',
      { cityId: azaz, customerId: buyer.id, lines: [] },
      null,
    );
    expect(empty.json()).toMatchObject({ customerName: 'رامي', currency: 'TRY', due: '10000' });

    const part = await cashier.post('/v1/admin/cash-desk/customer-dues', {
      cityId: azaz,
      customerId: buyer.id,
      due: '10000',
      lines: [{ currency: 'TRY', amount: '6000', base: '6000', rates: [] }],
    });
    expect(part.statusCode).toBe(201);
    expect(part.json()).toMatchObject({
      number: expect.stringMatching(/^AZ-\d{4}-\d{6}$/),
      customerName: 'رامي',
      dueBefore: '10000',
      total: '6000',
      dueAfter: '4000',
      lines: [{ currency: 'TRY', amount: '6000', base: '6000' }],
    });
    expect((await banner(buyer.headers)).dues).toEqual({ amount: '4000', currency: 'TRY' });
    const pushes = (receiptId: string) =>
      sql.query(
        "SELECT template_key, body FROM notifications.push_messages WHERE source = 'cashdesk:receipt:' || $1",
        [receiptId],
      );
    // A part paid tells the customer nothing yet.
    expect((await pushes(part.json().id)).rows).toEqual([]);

    // The rest in dollars at 40 ₺: 1 $ is 40.00 ₺, 4000 minor units.
    const quoted = await cashier.post(
      '/v1/admin/cash-desk/customer-dues/preview',
      { cityId: azaz, customerId: buyer.id, lines: [{ currency: 'USD', amount: '100' }] },
      null,
    );
    expect(quoted.json()).toMatchObject({ due: '4000', total: '4000', remaining: '0' });
    const line = quoted.json().lines[0];
    const stale = await cashier.post('/v1/admin/cash-desk/customer-dues', {
      cityId: azaz,
      customerId: buyer.id,
      due: '10000',
      lines: [line],
    });
    expect(stale.json().error).toBe('balance_changed');
    const rest = await cashier.post('/v1/admin/cash-desk/customer-dues', {
      cityId: azaz,
      customerId: buyer.id,
      due: '4000',
      lines: [{ currency: line.currency, amount: line.amount, base: line.base, rates: line.rates }],
    });
    expect(rest.statusCode).toBe(201);
    expect(rest.json().dueAfter).toBe('0');
    // CU §14 #21: the block lifted.
    expect((await pushes(rest.json().id)).rows).toEqual([
      { template_key: 'customer.dues_paid', body: 'تم استلام 1 $. حسابك فعّال من جديد' },
    ]);
    expect(await banner(buyer.headers)).toMatchObject({ dues: null, office: null, block: null });

    const again = await cashier.post('/v1/admin/cash-desk/customer-dues', {
      cityId: azaz,
      customerId: buyer.id,
      due: '0',
      lines: [{ currency: 'TRY', amount: '100', base: '100', rates: [] }],
    });
    expect(again.json().error).toBe('nothing_due');

    const listed = await cashier.get(`/v1/admin/cash-desk/customers/${buyer.id}/receipts`);
    expect(listed.json().receipts.map((each: { id: string }) => each.id)).toEqual([
      rest.json().id,
      part.json().id,
    ]);
    expect(
      (await cashier.get(`/v1/admin/cash-desk/customer-receipts/${part.json().id}`)).json().number,
    ).toBe(part.json().number);
  });

  it('never takes more than is owed, needs an open drawer, and answers a repeat with its receipt', async () => {
    const buyer = await customerOwing('5000');
    const noDrawer = await (
      await admin(['FIN'])
    ).post('/v1/admin/cash-desk/customer-dues', {
      cityId: azaz,
      customerId: buyer.id,
      due: '5000',
      lines: [{ currency: 'TRY', amount: '5000', base: '5000', rates: [] }],
    });
    expect(noDrawer.json().error).toBe('no_open_session');
    const cashier = await openDesk();
    const above = await cashier.post('/v1/admin/cash-desk/customer-dues', {
      cityId: azaz,
      customerId: buyer.id,
      due: '5000',
      lines: [{ currency: 'TRY', amount: '6000', base: '6000', rates: [] }],
    });
    expect(above.json().error).toBe('above_balance');
    const key = randomUUID();
    const body = {
      cityId: azaz,
      customerId: buyer.id,
      due: '5000',
      lines: [{ currency: 'TRY', amount: '5000', base: '5000', rates: [] }],
    };
    const first = await cashier.post('/v1/admin/cash-desk/customer-dues', body, key);
    const second = await cashier.post('/v1/admin/cash-desk/customer-dues', body, key);
    expect(second.json().id).toBe(first.json().id);
    expect(
      (
        await cashier.post(
          '/v1/admin/cash-desk/customer-dues/preview',
          { ...body, lines: [] },
          null,
        )
      ).json().due,
    ).toBe('0');
    const unknown = await cashier.post(
      '/v1/admin/cash-desk/customer-dues/preview',
      { cityId: azaz, customerId: randomUUID(), lines: [] },
      null,
    );
    expect(unknown.statusCode).toBe(404);
  });
});
