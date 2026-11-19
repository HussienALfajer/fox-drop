import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';

// AP §9.12.1–9.12.2 (slice 2.37c): «المدن», the zones on the map and the
// vote map, through the whole API.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;

const context = { ipAddress: '203.0.113.9', device: 'Firefox 140 on Windows' };

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = Buffer.alloc(32, 7).toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  app = await createApiApp(ApiModule);
  await app.init();
  const fx = app.get(FxService);
  const system = { actor: { type: 'system', id: null, role: null }, context } as const;
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, system);
  await fx.setBaseCurrency(azaz, 'TRY', system);
  await app.getHttpAdapter().getInstance().ready();
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

let accounts = 0;

// A signed-in admin holding these roles.
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Zones ${accounts}`, `zones${accounts}@example.test`],
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
    .start(db.db, accountId, context, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return {
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    put: (url: string, payload: object) => app.inject({ method: 'PUT', url, cookies, payload }),
  };
}

// A square of about 1 km around a centre, corner after corner.
function square(latitude: number, longitude: number, half = 0.005) {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

describe('«مناطق الخدمة» (AP §9.12.2)', () => {
  it('lets the owner draw a neighbourhood, rename and move it, then activate it', async () => {
    const owner = await admin(['OWN']);
    const id = randomUUID();
    const url = `/v1/admin/cities/${azaz}/zones/${id}`;
    const drawn = await owner.put(url, {
      name: 'الحي الشمالي',
      area: square(36.7, 37.1),
      active: false,
    });
    expect(drawn.statusCode).toBe(200);
    expect(drawn.json().zones).toContainEqual({
      id,
      name: 'الحي الشمالي',
      active: false,
      area: square(36.7, 37.1),
    });
    // The same request again changes nothing.
    expect(
      (await owner.put(url, { name: 'الحي الشمالي', area: square(36.7, 37.1), active: false }))
        .statusCode,
    ).toBe(200);

    const moved = await owner.put(url, {
      name: 'حي الشمال',
      area: square(36.7, 37.1, 0.004),
      active: true,
      reason: 'حدود أدق',
    });
    expect(moved.statusCode).toBe(200);
    expect(moved.json().zones).toContainEqual({
      id,
      name: 'حي الشمال',
      active: true,
      area: square(36.7, 37.1, 0.004),
    });
    const { rows } = await sql.query(
      'SELECT action, reason FROM audit.events WHERE target_id = $1 ORDER BY id',
      [id],
    );
    expect(rows).toEqual([
      { action: 'zone.create', reason: null },
      { action: 'zone.update', reason: 'حدود أدق' },
    ]);
  });

  it('refuses an overlap, a taken name, a bad outline and an unknown city', async () => {
    const owner = await admin(['OWN']);
    const first = randomUUID();
    await owner.put(`/v1/admin/cities/${azaz}/zones/${first}`, {
      name: 'الأول',
      area: square(36.8, 37.2),
      active: true,
    });
    const overlap = await owner.put(`/v1/admin/cities/${azaz}/zones/${randomUUID()}`, {
      name: 'الثاني',
      area: square(36.8, 37.202),
      active: true,
    });
    expect(overlap.statusCode).toBe(409);
    expect(overlap.json()).toMatchObject({ error: 'zones_overlap' });
    const taken = await owner.put(`/v1/admin/cities/${azaz}/zones/${randomUUID()}`, {
      name: 'الأول',
      area: square(36.9, 37.3),
      active: false,
    });
    expect(taken.statusCode).toBe(409);
    expect(taken.json()).toMatchObject({ error: 'zone_name_taken' });
    const [a, b, c, d] = square(36.9, 37.3);
    const crossing = await owner.put(`/v1/admin/cities/${azaz}/zones/${randomUUID()}`, {
      name: 'متقاطع',
      area: [a, c, b, d],
      active: false,
    });
    expect(crossing.statusCode).toBe(400);
    expect(crossing.json()).toMatchObject({ error: 'invalid_area' });
    const unknown = await owner.get(`/v1/admin/cities/${randomUUID()}/zones`);
    expect(unknown.statusCode).toBe(404);
  });

  it('shows the votes from outside the zones on the map', async () => {
    const reader = await admin(['FIN']);
    await sql.query(
      `INSERT INTO geo.zone_votes (city_id, device_id, location)
       VALUES ($1, $2, ST_SetSRID(ST_MakePoint(37.30011, 36.95021), 4326)),
              ($1, $3, ST_SetSRID(ST_MakePoint(37.30014, 36.95024), 4326))`,
      [azaz, randomUUID(), randomUUID()],
    );
    const map = await reader.get(`/v1/admin/cities/${azaz}/zones`);
    expect(map.statusCode).toBe(200);
    expect(map.json().votes).toContainEqual({ latitude: 36.95, longitude: 37.3, votes: 2 });
  });
});

describe('«المدن» (AP §9.12.1)', () => {
  it('shows the city with its currencies, and lets the owner change its fields', async () => {
    const owner = await admin(['OWN']);
    const read = await owner.get(`/v1/admin/cities/${azaz}`);
    expect(read.statusCode).toBe(200);
    expect(read.json()).toMatchObject({
      city: { id: azaz, code: 'AZ', timeZone: 'Asia/Damascus', status: 'active' },
      currencies: [{ code: 'TRY', enabled: true, isBase: true }],
      otherCurrencies: expect.arrayContaining([expect.objectContaining({ code: 'USD' })]),
      baseLocked: false,
    });
    const { name } = read.json().city;

    const changed = await owner.put(`/v1/admin/cities/${azaz}`, {
      name,
      code: 'AZ',
      timeZone: 'Europe/Istanbul',
      status: 'active',
      reason: 'تجربة',
    });
    expect(changed.statusCode).toBe(200);
    expect(changed.json().city.timeZone).toBe('Europe/Istanbul');
    const bad = await owner.put(`/v1/admin/cities/${azaz}`, {
      name,
      code: 'AZ',
      timeZone: 'Mars/Olympus',
      status: 'active',
    });
    expect(bad.statusCode).toBe(400);
    expect(bad.json()).toMatchObject({ error: 'invalid_city' });
    await owner.put(`/v1/admin/cities/${azaz}`, {
      name,
      code: 'AZ',
      timeZone: 'Asia/Damascus',
      status: 'active',
    });

    const all = await owner.get('/v1/admin/cities/all');
    expect(all.json().cities).toContainEqual(
      expect.objectContaining({ id: azaz, status: 'active' }),
    );
  });

  it('adds an accepted currency, which needs its rate before it is enabled, and keeps the base', async () => {
    const owner = await admin(['OWN']);
    const added = await owner.put(`/v1/admin/cities/${azaz}/currencies/USD`, {
      displayOrder: 2,
      enabled: false,
    });
    expect(added.statusCode).toBe(200);
    expect(added.json().currencies).toContainEqual(
      expect.objectContaining({ code: 'USD', enabled: false, isBase: false }),
    );
    const noRate = await owner.put(`/v1/admin/cities/${azaz}/currencies/USD`, {
      displayOrder: 2,
      enabled: true,
    });
    expect(noRate.statusCode).toBe(409);
    expect(noRate.json()).toMatchObject({ error: 'rate_missing' });
    const notCity = await owner.put(`/v1/admin/cities/${azaz}/base-currency`, { currency: 'SYP' });
    expect(notCity.statusCode).toBe(400);
    expect(notCity.json()).toMatchObject({ error: 'not_city_currency' });
    const same = await owner.put(`/v1/admin/cities/${azaz}/base-currency`, { currency: 'TRY' });
    expect(same.statusCode).toBe(200);
  });

  it('lets OPS and FIN read but not change', async () => {
    for (const role of ['OPS', 'FIN']) {
      const reader = await admin([role]);
      expect((await reader.get(`/v1/admin/cities/${azaz}`)).statusCode).toBe(200);
      const put = await reader.put(`/v1/admin/cities/${azaz}/zones/${randomUUID()}`, {
        name: 'x',
        area: square(36.1, 37.1),
        active: false,
      });
      expect(put.statusCode).toBe(403);
    }
  });
});
