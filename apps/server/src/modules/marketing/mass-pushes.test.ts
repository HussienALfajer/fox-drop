import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CustomersService } from '../customers/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';

// AP §9.11.4 «الإشعارات الجماعية» (slice 2.27d, owner decisions
// 2026-11-18): OWN sends a push now or at its time to an audience whose
// size it confirmed, cancels a scheduled one, and reads the history with
// the sender, the audience, the sent and the delivered; OPS only reads.
// Ordering's latest deliveries are stubbed (its port); the pushes' sending
// is push-relay.test.ts's.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let centreZone: string;
let accounts = 0;

const DAY = 86_400_000;
const centre = { latitude: 36.5866, longitude: 37.0463 };
const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
// Each customer's latest delivered order, as ordering would answer.
const lastDelivered = new Map<string, Date>();

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const half = 0.01;
  const area = [
    { latitude: centre.latitude - half, longitude: centre.longitude - half },
    { latitude: centre.latitude - half, longitude: centre.longitude + half },
    { latitude: centre.latitude + half, longitude: centre.longitude + half },
    { latitude: centre.latitude + half, longitude: centre.longitude - half },
  ];
  centreZone = await app
    .get(GeoService)
    .createZone(azaz, { name: 'المركز', area, active: true }, change);
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  app.get(CustomersService).useLastDeliveries(async () => new Map(lastDelivered));
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Pushes ${accounts}`, `pushes${accounts}@example.test`],
  );
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [rows[0].id, role],
    );
  }
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  return (method: 'GET' | 'POST', url: string, payload?: object, key?: string) =>
    app.inject({
      method,
      url,
      cookies: { [ADMIN_SESSION_COOKIE]: token },
      ...(method === 'POST' && url === '/v1/admin/mass-pushes'
        ? { headers: { 'idempotency-key': key ?? randomUUID() } }
        : {}),
      ...(payload ? { payload } : {}),
    });
}

// A customer: an account, a profile unless a guest-like account that never
// finished its details, and an address at the point when given.
async function customer(
  options: {
    profile?: boolean;
    closed?: boolean;
    at?: { latitude: number; longitude: number };
  } = {},
): Promise<string> {
  const { rows } = await sql.query(
    "INSERT INTO identity.customer_accounts (phone_hash, phone_encrypted) VALUES ($1, 'x') RETURNING id",
    [randomUUID()],
  );
  const id: string = rows[0].id;
  if (options.closed) {
    await sql.query(
      "UPDATE identity.customer_accounts SET status = 'closed', closed_at = now() WHERE id = $1",
      [id],
    );
  }
  if (options.profile !== false) {
    await sql.query(
      "INSERT INTO customers.profiles (account_id, first_name, gender, terms_accepted_at) VALUES ($1, 'سامر', 'male', now())",
      [id],
    );
  }
  if (options.at) {
    await sql.query(
      `INSERT INTO customers.addresses (account_id, city_id, location, label, street, landmark, is_default)
       VALUES ($1, $2, ST_SetSRID(ST_MakePoint($3, $4), 4326), 'home', 'الشارع', 'الجامع', true)`,
      [id, azaz, options.at.longitude, options.at.latitude],
    );
  }
  return id;
}

const message = (over: object = {}) => ({
  cityId: azaz,
  title: 'عرض الشتاء',
  body: 'توصيل مجاني على طلبك الأول اليوم',
  audience: 'all',
  zoneId: null,
  inactiveDays: null,
  target: 'home',
  restaurantId: null,
  codeId: null,
  sendAt: null,
  ...over,
});

type Pushes = {
  pushes: {
    id: string;
    title: string;
    audience: string;
    zoneName: string | null;
    status: string;
    recipients: number;
    sent: number;
    delivered: number;
    sentBy: string;
    restaurantName: string | null;
    cancelledBy: string | null;
  }[];
  canManage: boolean;
};

const size = async (call: Awaited<ReturnType<typeof admin>>, query: string) => {
  const answer = await call('GET', `/v1/admin/mass-pushes/audience?cityId=${azaz}&${query}`);
  expect(answer.statusCode, answer.body).toBe(200);
  return answer.json<{ size: number }>().size;
};

describe('«الإشعارات الجماعية»', () => {
  it('counts each audience among the registered customers who are not closed', async () => {
    const own = await admin(['OWN']);
    const before = await size(own, 'audience=all');
    const inZone = await customer({ at: centre });
    const elsewhere = await customer({ at: { latitude: 36.7, longitude: 37.2 } });
    const regular = await customer();
    const lapsed = await customer();
    await customer({ profile: false });
    await customer({ closed: true, at: centre });
    lastDelivered.set(regular, new Date(Date.now() - 3 * DAY));
    lastDelivered.set(lapsed, new Date(Date.now() - 40 * DAY));

    expect(await size(own, 'audience=all')).toBe(before + 4);
    expect(await size(own, `audience=zone&zoneId=${centreZone}`)).toBe(1);
    expect(await size(own, 'audience=inactive&inactiveDays=30')).toBe(1);
    expect(await size(own, 'audience=inactive&inactiveDays=2')).toBe(2);
    // Never ordered: the delivered ones are out.
    const never = await size(own, 'audience=never_ordered');
    expect(never).toBe(before + 2);
    expect(inZone && elsewhere).toBeTruthy();

    const bad = await own('GET', `/v1/admin/mass-pushes/audience?cityId=${azaz}&audience=zone`);
    expect(bad.statusCode).toBe(400);
    expect(bad.json().error).toBe('invalid_mass_push');
    expect(
      (
        await own(
          'GET',
          `/v1/admin/mass-pushes/audience?cityId=${azaz}&audience=inactive&inactiveDays=0`,
        )
      ).statusCode,
    ).toBe(400);
  });

  it('sends now to the audience confirmed, once per key, and refuses another size', async () => {
    const own = await admin(['OWN']);
    const shop = await app.get(MerchantsService).createRestaurant(
      azaz,
      {
        nameAr: 'مطعم الشتاء',
        location: centre,
        coverage: { kind: 'radius', radiusMetres: 3000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    const target = { target: 'restaurant', restaurantId: shop };
    const confirmed = await size(own, `audience=zone&zoneId=${centreZone}`);

    const wrong = await own(
      'POST',
      '/v1/admin/mass-pushes',
      message({ ...target, audience: 'zone', zoneId: centreZone, audienceSize: confirmed + 1 }),
    );
    expect(wrong.statusCode).toBe(409);
    expect(wrong.json().error).toBe('audience_changed');

    const key = randomUUID();
    const body = message({
      ...target,
      audience: 'zone',
      zoneId: centreZone,
      audienceSize: confirmed,
    });
    const sent = await own('POST', '/v1/admin/mass-pushes', body, key);
    expect(sent.statusCode).toBe(201);
    const [push] = sent.json<Pushes>().pushes;
    expect(push).toMatchObject({
      title: 'عرض الشتاء',
      audience: 'zone',
      zoneName: 'المركز',
      status: 'sent',
      recipients: confirmed,
      sent: 0,
      delivered: 0,
      restaurantName: 'مطعم الشتاء',
    });
    expect(push!.sentBy).toMatch(/^Pushes /);
    const again = await own('POST', '/v1/admin/mass-pushes', body, key);
    expect(again.statusCode).toBe(201);
    expect(again.json<Pushes>().pushes.filter((each) => each.id === push!.id)).toHaveLength(1);

    const { rows } = await sql.query(
      'SELECT id, title, body, data, next_attempt_at, expires_at FROM notifications.push_messages WHERE campaign_id = $1',
      [push!.id],
    );
    expect(rows).toHaveLength(confirmed);
    expect(rows[0]).toMatchObject({
      title: 'عرض الشتاء',
      body: 'توصيل مجاني على طلبك الأول اليوم',
      data: { kind: 'mass_push', target: 'restaurant', restaurantId: shop },
    });

    // The app's receipt counts once, without a session.
    for (let i = 0; i < 2; i += 1) {
      const receipt = await app.inject({
        method: 'POST',
        url: '/v1/customer/push-receipts',
        payload: { messageId: rows[0].id },
      });
      expect(receipt.statusCode).toBe(200);
    }
    const read = await own('GET', `/v1/admin/mass-pushes?cityId=${azaz}`);
    expect(read.json<Pushes>().pushes.find((each) => each.id === push!.id)?.delivered).toBe(1);
  });

  it('schedules a push to those who never ordered, and cancels it before its time', async () => {
    const own = await admin(['OWN']);
    const ops = await admin(['OPS']);
    const confirmed = await size(own, 'audience=never_ordered');
    const sendAt = new Date(Date.now() + DAY).toISOString();
    const scheduled = await own(
      'POST',
      '/v1/admin/mass-pushes',
      message({ audience: 'never_ordered', sendAt, audienceSize: confirmed }),
    );
    expect(scheduled.statusCode).toBe(201);
    const [push] = scheduled.json<Pushes>().pushes;
    expect(push).toMatchObject({ audience: 'never_ordered', status: 'scheduled' });

    // OPS reads the history and sends nothing.
    const read = await ops('GET', `/v1/admin/mass-pushes?cityId=${azaz}`);
    expect(read.statusCode).toBe(200);
    expect(read.json<Pushes>().canManage).toBe(false);
    expect(
      (await ops('POST', '/v1/admin/mass-pushes', message({ audienceSize: 1 }))).statusCode,
    ).toBe(403);
    expect(
      (await ops('POST', `/v1/admin/mass-pushes/${push!.id}/cancel`, { cityId: azaz })).statusCode,
    ).toBe(403);

    const cancelled = await own('POST', `/v1/admin/mass-pushes/${push!.id}/cancel`, {
      cityId: azaz,
    });
    expect(cancelled.statusCode).toBe(200);
    expect(cancelled.json<Pushes>().pushes.find((each) => each.id === push!.id)).toMatchObject({
      status: 'cancelled',
    });
    const { rows } = await sql.query(
      'SELECT count(*)::int AS n FROM notifications.push_messages WHERE campaign_id = $1 AND gave_up_at IS NULL',
      [push!.id],
    );
    expect(rows[0].n).toBe(0);
    const twice = await own('POST', `/v1/admin/mass-pushes/${push!.id}/cancel`, { cityId: azaz });
    expect(twice.statusCode).toBe(409);
    expect(twice.json().error).toBe('not_cancellable');
  });

  it("counts a line's deliveries for the account that continues it (AP §8.8)", async () => {
    const own = await admin(['OWN']);
    const before = await size(own, 'audience=never_ordered');
    const closed = await customer({ closed: true });
    const next = await customer();
    await sql.query('UPDATE identity.customer_accounts SET lineage_id = $1 WHERE id = $2', [
      closed,
      next,
    ]);
    lastDelivered.set(closed, new Date(Date.now() - 40 * DAY));
    // The new account has ordered through its line, 40 days ago.
    expect(await size(own, 'audience=never_ordered')).toBe(before);
    const inactive = await size(own, 'audience=inactive&inactiveDays=30');
    lastDelivered.delete(closed);
    expect(await size(own, 'audience=inactive&inactiveDays=30')).toBe(inactive - 1);
  });

  it('lets the application change only the cancellation of a push', async () => {
    await expect(sql.query("UPDATE marketing.mass_pushes SET title = 'x'")).rejects.toThrow(
      /permission denied/,
    );
    await sql.query('UPDATE marketing.mass_pushes SET cancelled_at = cancelled_at');
  });

  it('refuses a push it could not send as written', async () => {
    const own = await admin(['OWN']);
    const confirmed = await size(own, 'audience=all');
    const refused = async (over: object) => {
      const answer = await own(
        'POST',
        '/v1/admin/mass-pushes',
        message({ audienceSize: confirmed, ...over }),
      );
      expect(answer.statusCode).toBe(400);
      expect(answer.json().error).toBe('invalid_mass_push');
    };
    await refused({ title: '  ' });
    await refused({ body: 'ن'.repeat(201) });
    await refused({ sendAt: new Date(Date.now() - 60_000).toISOString() });
    await refused({ sendAt: new Date(Date.now() + 31 * DAY).toISOString() });
    await refused({ target: 'code', codeId: randomUUID() });
    await refused({ target: 'restaurant', restaurantId: randomUUID() });
    await refused({ target: 'home', restaurantId: randomUUID() });
  });
});
