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
import { type CodeCart, PromoCodeUsesService } from './promo-code-uses.service.js';
import { suggestedCode } from './promo-codes.js';

// «الأكواد المتاحة لك» and the suggestion (CU §10.4, U11, Q19; slice 2.21d):
// the visible codes running in the city that apply to the cart, or that its
// minimum keeps out, never a secret, paused, ended or used-up one.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let uses: PromoCodeUsesService;
let azaz: string;
const restaurantId = randomUUID();
const otherRestaurant = randomUUID();
// Thursday 10 December 2026, 15:00 in Azaz (UTC+3).
const now = new Date('2026-12-10T12:00:00Z');

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  uses = app.get(PromoCodeUsesService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function code(typed: string, fields: Record<string, unknown> = {}): Promise<string> {
  const row = {
    kind: 'percentage',
    percent_bp: 1000,
    amount: null,
    max_discount: null,
    min_order: null,
    valid_to: '2027-01-01',
    per_customer_limit: null,
    audience: 'everyone',
    restaurant_ids: [],
    visibility: 'visible',
    status: 'active',
    ...fields,
  };
  await sql.query(
    `INSERT INTO marketing.promo_codes (city_id, code, kind, percent_bp, amount, max_discount,
       min_order, currency, valid_from, valid_to, per_customer_limit, audience, restaurant_ids,
       zone_ids, funding, merchant_share_bp, visibility, status, created_by, updated_by)
     VALUES ($1, $2, $3, $4, $5, $6, $7, 'TRY', '2026-12-01', $8, $9, $10, $11, '{}',
       'platform', 0, $12, $13, $14, $14)`,
    [
      azaz,
      typed,
      row.kind,
      row.percent_bp,
      row.amount,
      row.max_discount,
      row.min_order,
      row.valid_to,
      row.per_customer_limit,
      row.audience,
      row.restaurant_ids,
      row.visibility,
      row.status,
      randomUUID(),
    ],
  );
  return typed;
}

const who = {
  accountId: randomUUID(),
  phoneHash: randomUUID(),
  deviceId: randomUUID(),
  newUser: false,
};

function cart(customer: CodeCart['customer'] = who): Omit<CodeCart, 'code'> {
  return {
    cityId: azaz,
    clock: { timeZone: 'Asia/Damascus', businessDay: new Date('2026-12-10T03:00:00Z') },
    baseCurrency: 'TRY',
    restaurantId,
    zoneId: null,
    itemsValue: 40_000n,
    deliveryFee: 4_000n,
    customer,
  };
}

describe('PromoCodeUsesService.available', () => {
  beforeAll(async () => {
    // Apply: 10% (40.00), a fixed 25.00, free delivery (40.00), a cap.
    await code('TEN');
    await code('FIXED', { kind: 'fixed_amount', percent_bp: null, amount: 2500 });
    await code('SHIP', { kind: 'free_delivery', percent_bp: null });
    await code('CAPPED', { percent_bp: 5000, max_discount: 6000, restaurant_ids: [restaurantId] });
    // The minimum keeps it out: 100.00 more.
    await code('BIG', { min_order: 50_000 });
    // Never listed.
    await code('HIDDEN', { visibility: 'secret', percent_bp: 9000 });
    await code('PAUSED', { status: 'paused' });
    await code('ENDED', { valid_to: '2026-12-05' });
    await code('ELSEWHERE', { restaurant_ids: [otherRestaurant] });
    await code('NEWONLY', { audience: 'new_users' });
    await code('ONCE', { per_customer_limit: 1 });
    await sql.query(
      `INSERT INTO marketing.promo_code_uses (code_id, city_id, order_id, order_placed_at,
         customer_account_id, phone_hash, device_id, business_day, currency, discount,
         merchant_share, held_at)
       SELECT id, city_id, $2, $3, $4, $5, $6, $3, 'TRY', 4000, 0, $3
       FROM marketing.promo_codes WHERE code = 'ONCE' AND city_id = $1`,
      [azaz, randomUUID(), now, who.accountId, who.phoneHash, who.deviceId],
    );
  });

  it('lists the codes that apply, largest discount first (then by code), then those below their minimum', async () => {
    const listed = await uses.available(cart(), now);
    expect(
      listed.map((entry) => [entry.code, entry.discount?.total ?? null, entry.missing]),
    ).toEqual([
      ['CAPPED', 6000n, null],
      ['SHIP', 4000n, null],
      ['TEN', 4000n, null],
      ['FIXED', 2500n, null],
      ['BIG', null, 10_000n],
    ]);
    expect(listed[0]).toMatchObject({
      kind: 'percentage',
      percentBp: 5000,
      maxDiscount: 6000n,
      minOrder: null,
      validTo: new Date('2027-01-01T00:00:00Z'),
    });
  });

  it('shows a guest the codes whose audience and limits wait for placing', async () => {
    const listed = await uses.available(cart(null), now);
    expect(listed.map((entry) => entry.code)).toEqual([
      'CAPPED',
      'NEWONLY',
      'ONCE',
      'SHIP',
      'TEN',
      'FIXED',
      'BIG',
    ]);
  });

  it('suggests the largest discount above the applied one, never the applied code', async () => {
    const listed = await uses.available(cart(), now);
    expect(suggestedCode(listed, null)).toEqual({ code: 'CAPPED', discount: 6000n });
    expect(suggestedCode(listed, { code: 'TEN', discount: 4000n })).toEqual({
      code: 'CAPPED',
      discount: 6000n,
    });
    expect(suggestedCode(listed, { code: 'CAPPED', discount: 6000n })).toBeNull();
    expect(suggestedCode(listed.slice(4), null)).toBeNull();
  });
});
