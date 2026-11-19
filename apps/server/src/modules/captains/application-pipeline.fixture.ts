import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, expect } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestStorage, type TestStorage } from '../../storage/test-storage.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';

// The setup and helpers of application-pipeline.test.ts and
// captain-activation.test.ts: each test file that imports this one gets its
// own app, database, Valkey and Garage (its private-docs).
export let database: TestDatabase;
export let cache: TestValkey;
export let storage: TestStorage;
export let app: NestFastifyApplication;
export let sql: pg.Pool;
export let db: Database;
export let sender: DevelopmentCodeSender;
export let azaz: string;
export let zoneId: string;
let accounts = 0;

export const system = { type: 'system', id: null, role: null } as const;
export const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

beforeAll(async () => {
  [database, cache, storage] = await Promise.all([
    startTestDatabase(),
    startTestValkey(),
    startTestStorage(),
  ]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  process.env.STORAGE_URL = storage.url;
  process.env.STORAGE_KEY_ID = storage.key.id;
  process.env.STORAGE_SECRET = storage.key.secret;
  process.env.ADMIN_PANEL_URL = storage.url;
  process.env.APP_UPLOAD_URL = storage.url;
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  sender = app.get(CODE_SENDER);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  zoneId = await app.get(GeoService).createZone(
    azaz,
    {
      name: 'الحي الشمالي',
      area: [
        { latitude: 36.58, longitude: 37.04 },
        { latitude: 36.58, longitude: 37.05 },
        { latitude: 36.59, longitude: 37.05 },
        { latitude: 36.59, longitude: 37.04 },
      ],
      active: true,
    },
    change,
  );
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop(), storage?.stop()]);
});

export const jpeg = Buffer.concat([Buffer.from([0xff, 0xd8, 0xff, 0xe0]), randomBytes(60)]);

export async function put(url: string): Promise<void> {
  const answer = await fetch(url, {
    method: 'PUT',
    body: jpeg,
    headers: { 'content-type': 'image/jpeg' },
  });
  expect(answer.status).toBe(200);
}

// A new number's «انضم ككابتن», signed in: the applicant's calls.
export async function applicant() {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const deviceId = randomUUID();
  await app.inject({
    method: 'POST',
    url: '/v1/captain/auth/code',
    payload: { phone, deviceId, join: true },
  });
  const signedIn = await app.inject({
    method: 'POST',
    url: '/v1/captain/auth/sign-in',
    payload: { phone, deviceId, code: sender.lastCode(phone) },
  });
  expect(signedIn.statusCode).toBe(200);
  const { accessToken, accountId } = signedIn.json();
  const headers = { authorization: `Bearer ${accessToken}` };
  const call = (method: 'GET' | 'PUT' | 'POST', path: string, payload?: object) =>
    app.inject({ method, url: `/v1/captain${path}`, headers, ...(payload ? { payload } : {}) });
  const document = async (kind: string, extra: object = {}, files = 1) => {
    const uploadIds = [];
    for (let i = 0; i < files; i += 1) {
      const asked = await call('POST', '/application/documents/upload', {
        contentType: 'image/jpeg',
        sizeBytes: jpeg.length,
      });
      await put(asked.json().url);
      uploadIds.push(asked.json().uploadId);
    }
    return call('PUT', `/application/documents/${kind}`, { uploadIds, ...extra });
  };
  return { phone, accountId: accountId as string, call, document };
}

export type Applicant = Awaited<ReturnType<typeof applicant>>;

export const today = () => new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Damascus' }).format();

// An applicant whose application is sent: a car with its plate and every
// required document.
export async function sent(
  options: { idNumber?: string; plate?: string } = {},
): Promise<Applicant> {
  const who = await applicant();
  await who.call('PUT', '/application/personal', {
    fullName: `محمد أحمد ${randomUUID().slice(0, 6)}`,
    birthDate: '2000-05-01',
    zoneId,
  });
  await who.call('PUT', '/application/vehicle', {
    vehicle: 'car',
    plate: options.plate ?? `حلب ${randomInt(100_000)}`,
  });
  await who.document('national_id', { number: options.idNumber ?? `${randomInt(1e9)}00` }, 2);
  await who.document('personal_photo');
  await who.document('civil_registry');
  await who.document('criminal_record', { issueDate: today() });
  await who.document('vehicle_papers');
  const terms = await who.call('GET', '/terms');
  await who.call('POST', '/terms/accept', { version: terms.json().version });
  const submitted = await who.call('POST', '/application/submit');
  expect(submitted.json().application.stage).toBe('new');
  return who;
}

export async function admin(role: string) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Operator ${accounts}`, `pipeline${accounts}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return (
    method: 'GET' | 'POST' | 'PUT',
    url: string,
    payload?: object,
    headers: Record<string, string> = {},
  ) =>
    app.inject({
      method,
      url: `/v1/admin/${url}`,
      cookies,
      headers,
      ...(payload ? { payload } : {}),
    });
}

export async function applicationOf(who: Applicant): Promise<string> {
  return (await who.call('GET', '/application')).json().application.id;
}

export async function pushes(who: Applicant): Promise<{ template_key: string; body: string }[]> {
  const { rows } = await sql.query(
    `SELECT template_key, body FROM notifications.push_messages
     WHERE party = 'captain' AND account_id = $1 AND captain_id IS NULL ORDER BY created_at, id`,
    [who.accountId],
  );
  return rows;
}

export async function alertOf(applicationId: string) {
  const { rows } = await sql.query(
    `SELECT resolved_at IS NULL AS open, details FROM notifications.alerts
     WHERE code = 'captain_application' AND subject_id = $1`,
    [applicationId],
  );
  return rows;
}
