import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import {
  CaptainAccountsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';
import { CaptainsService } from '../captains/index.js';
import { foxDropId } from './captain-profile.controller.js';

// CA §12.1, §12.5 (slice 2.36c): «ملفي»'s data and vehicle, the pay table
// for the captain's vehicle, the one in force and the one announced, and
// «احسب أجري».
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

const rate = (basePay: bigint) => ({
  basePay,
  includedMetres: 3_000,
  perExtraKm: 500n,
  waitingPerMinute: 100n,
  minimumPay: 2_000n,
});
// Each vehicle its own row, so the routes prove they answer the captain's.
const rates = (basePay: bigint) => ({
  motorbike: rate(basePay),
  car: rate(basePay + 100n),
  bicycle: rate(basePay + 200n),
  walking: rate(basePay + 300n),
});

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
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function captain() {
  const captainId = await app.get(CaptainsService).createCaptain(
    azaz,
    {
      name: 'كابتن الملف',
      vehicle: 'motorbike',
      plateNumber: '12345',
      custodyLimit: { amount: 300_000n, currency: 'TRY' },
    },
    change,
  );
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  await app.get(CaptainAccountsService).addAccount(captainId, phone, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/captain/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/captain/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  const headers = { authorization: `Bearer ${answer.json().accessToken}` };
  return {
    captainId,
    phone,
    get: (url: string) => app.inject({ method: 'GET', url, headers }),
  };
}

const try_ = (amount: string) => ({ amount, currency: 'TRY' });

describe('foxDropId', () => {
  it('shows the last 8 hex digits, which differ between captains made together', () => {
    expect(foxDropId('019a7b2c-1d2e-7f00-8abc-0123456789ab')).toBe('C-456789AB');
  });
});

describe('«ملفي» (CA §12.1, §12.5)', () => {
  it('answers the data and vehicle read-only', async () => {
    const { captainId, phone, get } = await captain();
    const answer = await get('/v1/captain/profile');
    expect(answer.statusCode).toBe(200);
    expect(answer.json()).toEqual({
      foxDropId: foxDropId(captainId),
      name: 'كابتن الملف',
      phone,
      neighbourhood: null,
      vehicle: 'motorbike',
      plateNumber: '12345',
    });
  });

  it('answers the table for the vehicle, the one announced, and «احسب أجري» by both', async () => {
    const { get } = await captain();
    const empty = await get('/v1/captain/pay-table');
    expect(empty.statusCode).toBe(200);
    expect(empty.json()).toMatchObject({ vehicle: 'motorbike', current: null, announced: [] });
    expect((await get('/v1/captain/pay-table/calculate?metres=1000')).json()).toEqual({
      current: null,
      announced: [],
    });

    const captains = app.get(CaptainsService);
    await captains.setPayTable(azaz, { currency: 'TRY', rates: rates(1_000n) }, change);
    const starts = new Date(Date.now() + 8 * 24 * 3_600_000);
    // Two versions with the same start: the later one is the one announced.
    await captains.setPayTable(
      azaz,
      { currency: 'TRY', rates: rates(9_000n), effectiveFrom: starts },
      change,
    );
    await captains.setPayTable(
      azaz,
      { currency: 'TRY', rates: rates(2_500n), effectiveFrom: starts },
      change,
    );

    const table = (await get('/v1/captain/pay-table')).json();
    expect(table).toMatchObject({
      vehicle: 'motorbike',
      waitingThresholdMin: 10,
      current: {
        basePay: try_('1000'),
        includedMetres: 3_000,
        perExtraKm: try_('500'),
        waitingPerMinute: try_('100'),
        minimumPay: try_('2000'),
      },
      announced: [{ effectiveFrom: starts.toISOString(), basePay: try_('2500') }],
    });
    expect(table.announced).toHaveLength(1);

    // 6.401 km and 25 minutes waited: 1000 + 1700 by the current table, 15
    // minutes of waiting paid; the announced one's base 2500 + 1700.
    const answer = await get('/v1/captain/pay-table/calculate?metres=6401&waitedMinutes=25');
    expect(answer.statusCode).toBe(200);
    expect(answer.json()).toEqual({
      current: {
        base: try_('1000'),
        distance: try_('1700'),
        topUp: try_('0'),
        orderPay: try_('2700'),
        waiting: try_('1500'),
        total: try_('4200'),
      },
      announced: [
        {
          effectiveFrom: starts.toISOString(),
          base: try_('2500'),
          distance: try_('1700'),
          topUp: try_('0'),
          orderPay: try_('4200'),
          waiting: try_('1500'),
          total: try_('5700'),
        },
      ],
    });
    // A short trip is raised to the minimum.
    expect((await get('/v1/captain/pay-table/calculate?metres=500')).json().current).toMatchObject({
      topUp: try_('1000'),
      orderPay: try_('2000'),
      waiting: try_('0'),
    });
    expect((await get('/v1/captain/pay-table/calculate?metres=-1')).statusCode).toBe(400);
    expect((await get('/v1/captain/pay-table/calculate?metres=1.5')).statusCode).toBe(400);
    expect((await get('/v1/captain/pay-table/calculate?metres=100001')).statusCode).toBe(400);
    expect((await get('/v1/captain/pay-table/calculate?metres=')).statusCode).toBe(400);
  });
});
