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

// A new number's «انضم ككابتن», signed in: the applicant's calls; or a
// number already known (a former captain's, slice 2.35b) signing in again.
export async function applicant(known?: string) {
  const phone = known ?? `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const deviceId = randomUUID();
  // A known number's last code is past its resend wait (otp.resend_after_sec).
  if (known) {
    await sql.query(
      "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '2 minutes' WHERE party = 'captain'",
    );
  }
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
  options: { idNumber?: string; plate?: string; phone?: string } = {},
): Promise<Applicant> {
  const who = await applicant(options.phone);
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

// The activation's helpers (captain-activation.test.ts, captain-offboarding.test.ts).

export type Admin = Awaited<ReturnType<typeof admin>>;

// An application at «بانتظار العدة»: every document accepted, the interview
// held, the training passed.
export async function awaitingKit(
  options: { phone?: string } = {},
): Promise<{ who: Applicant; id: string; ops: Admin }> {
  const who = await sent(options);
  const id = await applicationOf(who);
  const ops = await admin('OPS');
  const page = (await ops('GET', `captain-applications/${id}`)).json();
  for (const document of page.documents) {
    const reviewed = await ops(
      'POST',
      `captain-applications/${id}/documents/${document.id}/review`,
      { status: 'accepted' },
    );
    expect(reviewed.statusCode).toBe(200);
  }
  await ops('PUT', `captain-applications/${id}/interview`, {
    at: new Date(Date.now() + 86_400_000).toISOString(),
    place: 'مكتب أعزاز',
    latitude: 36.586,
    longitude: 37.046,
  });
  const passed = await ops('POST', `captain-applications/${id}/training-passed`);
  expect(passed.json().stage).toBe('awaiting_kit');
  return { who, id, ops };
}

// The office's scan of the contract's pages, uploaded as the panel does.
export async function scan(ops: Admin, pages = 2): Promise<string[]> {
  const uploadIds: string[] = [];
  for (let page = 0; page < pages; page += 1) {
    const asked = await ops('POST', 'uploads', {
      purpose: 'captain_document',
      contentType: 'image/jpeg',
      sizeBytes: jpeg.length,
    });
    expect(asked.statusCode).toBe(201);
    await put(asked.json().url);
    uploadIds.push(asked.json().uploadId);
  }
  return uploadIds;
}

export const day = (offsetDays: number) =>
  new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Damascus' }).format(
    new Date(Date.now() + offsetDays * 86_400_000),
  );

// The deposit as FIN records it at the desk (AP §9.7.1), with what is paid
// now from an open drawer.
export async function deposit(
  fin: Admin,
  id: string,
  body: { amount: string; instalment: string | null; paidNow: string },
) {
  return fin(
    'POST',
    'cash-desk/deposits',
    { cityId: azaz, applicationId: id, ...body },
    { 'idempotency-key': randomUUID() },
  );
}

// An activated captain: every record in, the deposit with instalments.
export async function activated(): Promise<{ who: Applicant; id: string; ops: Admin }> {
  const { who, id, ops } = await awaitingKit();
  const own = await admin('OWN');
  await ops('PUT', `captain-applications/${id}/kit`, {
    items: [
      { code: 'thermal_bag', quantity: 1 },
      { code: 'vest', size: 'L', quantity: 1 },
    ],
  });
  await ops('PUT', `captain-applications/${id}/contract`, {
    signedOn: day(0),
    startsOn: day(0),
    uploadIds: await scan(ops, 1),
  });
  await own('PUT', `cash-desk/deposits/${id}/cash-limit`, {
    cityId: azaz,
    cashLimit: { amount: '40000', currency: 'TRY' },
  });
  await deposit(own, id, { amount: '30000', instalment: '10000', paidNow: '0' });
  expect((await ops('POST', `captain-applications/${id}/activate`)).statusCode).toBe(200);
  return { who, id, ops };
}
