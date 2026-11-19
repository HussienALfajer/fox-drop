import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
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
import { CaptainsService } from './captains.service.js';

// AP §9.7.1, CA §5.3–5.4, §14 #29 (slice 2.34b): the panel's pipeline of
// captain applications, from «إرسال الطلب» to «بانتظار العدة», with the
// documents in a real Garage's private-docs.
let database: TestDatabase;
let cache: TestValkey;
let storage: TestStorage;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let sender: DevelopmentCodeSender;
let azaz: string;
let zoneId: string;
let accounts = 0;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

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

const jpeg = Buffer.concat([Buffer.from([0xff, 0xd8, 0xff, 0xe0]), randomBytes(60)]);

async function put(url: string): Promise<void> {
  const answer = await fetch(url, {
    method: 'PUT',
    body: jpeg,
    headers: { 'content-type': 'image/jpeg' },
  });
  expect(answer.status).toBe(200);
}

// A new number's «انضم ككابتن», signed in: the applicant's calls.
async function applicant() {
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

type Applicant = Awaited<ReturnType<typeof applicant>>;

const today = () => new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Damascus' }).format();

// An applicant whose application is sent: a car with its plate and every
// required document.
async function sent(options: { idNumber?: string; plate?: string } = {}): Promise<Applicant> {
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

async function admin(role: string) {
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

async function applicationOf(who: Applicant): Promise<string> {
  return (await who.call('GET', '/application')).json().application.id;
}

async function pushes(who: Applicant): Promise<{ template_key: string; body: string }[]> {
  const { rows } = await sql.query(
    `SELECT template_key, body FROM notifications.push_messages
     WHERE party = 'captain' AND account_id = $1 AND captain_id IS NULL ORDER BY created_at, id`,
    [who.accountId],
  );
  return rows;
}

async function alertOf(applicationId: string) {
  const { rows } = await sql.query(
    `SELECT resolved_at IS NULL AS open, details FROM notifications.alerts
     WHERE code = 'captain_application' AND subject_id = $1`,
    [applicationId],
  );
  return rows;
}

describe('the board and the review page (AP §9.7.1)', () => {
  it('raises «طلب انضمام كابتن» and lists the application under «جديد»', async () => {
    const who = await sent();
    const id = await applicationOf(who);
    expect(await alertOf(id)).toEqual([
      { open: true, details: { captainName: expect.stringMatching(/^محمد أحمد/) } },
    ]);
    const ops = await admin('OPS');
    const board = await ops('GET', `captain-applications?cityId=${azaz}&stage=new`);
    expect(board.statusCode).toBe(200);
    expect(board.json().counts.new).toBeGreaterThanOrEqual(1);
    expect(board.json().applications.map((each: { id: string }) => each.id)).toContain(id);

    const page = await ops('GET', `captain-applications/${id}`);
    expect(page.statusCode).toBe(200);
    expect(page.json()).toMatchObject({
      stage: 'new',
      zoneName: 'الحي الشمالي',
      vehicle: 'car',
      phone: who.phone,
      requiredDocuments: [
        'national_id',
        'personal_photo',
        'civil_registry',
        'criminal_record',
        'vehicle_papers',
      ],
      events: [expect.objectContaining({ kind: 'submitted', stage: 'new', actor: null })],
    });
    const nationalId = page
      .json()
      .documents.find((each: { kind: string }) => each.kind === 'national_id');
    expect(nationalId).toMatchObject({ status: 'pending', inForce: true, uploadedByOffice: false });
    expect(nationalId.fileUrls).toHaveLength(2);
    // Signed for the panel's origin, under captains/ (nginx's GET path).
    expect(new URL(nationalId.fileUrls[0]).pathname).toMatch(
      /^\/private-docs\/captains\/documents\//,
    );
    expect((await fetch(nationalId.fileUrls[0])).status).toBe(200);

    // SUP reads the pipeline with the number masked, and acts on nothing.
    const sup = await admin('SUP');
    const masked = await sup('GET', `captain-applications/${id}`);
    expect(masked.json().phone).toBe(`+963 ••• ${who.phone.slice(-3)}`);
    const refused = await sup('POST', `captain-applications/${id}/waitlist`);
    expect(refused.statusCode).toBe(403);
    // A draft is the applicant's.
    const draft = await applicant();
    await draft.call('PUT', '/application/personal', {
      fullName: 'خالد محمد العمر',
      birthDate: '2000-01-01',
      zoneId,
    });
    expect(
      (await ops('GET', `captain-applications/${await applicationOf(draft)}`)).statusCode,
    ).toBe(404);
  });

  it('shows another applicant or captain with the same ID number, phone or plate', async () => {
    const idNumber = `${randomInt(1e9)}77`;
    const first = await sent({ idNumber, plate: 'حلب 5555' });
    const second = await sent({ idNumber, plate: 'حلب5555' });
    await app.get(CaptainsService).createCaptain(
      azaz,
      {
        name: 'كابتن قديم',
        vehicle: 'car',
        plateNumber: 'حلب  5555',
        custodyLimit: { amount: 1_000n, currency: 'TRY' },
      },
      change,
    );
    const ops = await admin('OPS');
    const page = (await ops('GET', `captain-applications/${await applicationOf(second)}`)).json();
    const firstId = await applicationOf(first);
    expect(page.duplicates).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ field: 'id_number', applicationId: firstId }),
        expect.objectContaining({ field: 'plate', applicationId: firstId }),
        expect.objectContaining({
          field: 'plate',
          captainId: expect.any(String),
          fullName: 'كابتن قديم',
        }),
      ]),
    );
  });
});

describe('the pipeline actions (AP §9.7.1, CA §5.4)', () => {
  it('moves the application to «بانتظار العدة», telling the applicant each step', async () => {
    const who = await sent();
    const id = await applicationOf(who);
    const ops = await admin('OPS');
    const page = (await ops('GET', `captain-applications/${id}`)).json();
    const photo = page.documents.find((each: { kind: string }) => each.kind === 'personal_photo');

    // The first action moves «جديد» to «قيد المراجعة» and closes the alert.
    const accepted = await ops('POST', `captain-applications/${id}/documents/${photo.id}/review`, {
      status: 'accepted',
    });
    expect(accepted.statusCode).toBe(200);
    expect(accepted.json().stage).toBe('under_review');
    expect(
      accepted.json().documents.find((each: { id: string }) => each.id === photo.id),
    ).toMatchObject({ status: 'accepted', reviewedBy: expect.stringMatching(/^Operator/) });
    expect(await alertOf(id)).toEqual([expect.objectContaining({ open: false })]);
    // The same review again changes nothing.
    await ops('POST', `captain-applications/${id}/documents/${photo.id}/review`, {
      status: 'accepted',
    });

    // A rejection takes a reason; the applicant uploads that document again.
    const civil = page.documents.find((each: { kind: string }) => each.kind === 'civil_registry');
    const noReason = await ops('POST', `captain-applications/${id}/documents/${civil.id}/review`, {
      status: 'rejected',
    });
    expect(noReason.statusCode).toBe(400);
    await ops('POST', `captain-applications/${id}/documents/${civil.id}/review`, {
      status: 'rejected',
      reason: 'الصورة غير واضحة',
    });
    const notAsked = await who.document('personal_photo');
    expect([notAsked.statusCode, notAsked.json().error]).toEqual([409, 'application_submitted']);
    const again = await who.document('civil_registry');
    expect(again.statusCode).toBe(200);
    expect(
      again
        .json()
        .application.documents.find((each: { kind: string }) => each.kind === 'civil_registry'),
    ).toMatchObject({ status: 'pending' });
    // The old upload is replaced: reviewing it now is refused.
    const stale = await ops('POST', `captain-applications/${id}/documents/${civil.id}/review`, {
      status: 'accepted',
    });
    expect([stale.statusCode, stale.json().error]).toEqual([409, 'document_replaced']);

    // «طلب مستند», answered by the applicant's upload.
    const asked = await ops('POST', `captain-applications/${id}/document-requests`, {
      kind: 'driving_licence',
      reason: 'نحتاج شهادة القيادة',
    });
    expect(asked.json().requests).toEqual([
      expect.objectContaining({ kind: 'driving_licence', reason: 'نحتاج شهادة القيادة' }),
    ]);
    const twice = await ops('POST', `captain-applications/${id}/document-requests`, {
      kind: 'driving_licence',
      reason: 'مرة أخرى',
    });
    expect([twice.statusCode, twice.json().error]).toEqual([409, 'already_requested']);
    expect((await who.call('GET', '/application')).json().application.requests).toEqual([
      expect.objectContaining({ kind: 'driving_licence', reason: 'نحتاج شهادة القيادة' }),
    ]);
    expect((await who.document('driving_licence')).json().application.requests).toEqual([]);

    // A note, once per Idempotency-Key.
    const key = { 'idempotency-key': randomUUID() };
    await ops('POST', `captain-applications/${id}/notes`, { note: 'اتصلت به' }, key);
    const noted = await ops('POST', `captain-applications/${id}/notes`, { note: 'اتصلت به' }, key);
    expect(noted.json().events.filter((each: { kind: string }) => each.kind === 'note')).toEqual([
      expect.objectContaining({ note: 'اتصلت به', actor: expect.stringMatching(/^Operator/) }),
    ]);

    // Training before the interview is refused; then «تحديد مقابلة».
    const early = await ops('POST', `captain-applications/${id}/training-passed`);
    expect(early.statusCode).toBe(409);
    expect(early.json()).toMatchObject({ error: 'wrong_stage', stage: 'under_review' });
    const interview = {
      at: '2099-01-05T07:00:00.000Z',
      place: 'مكتب أعزاز',
      latitude: 36.586,
      longitude: 37.046,
    };
    const past = await ops('PUT', `captain-applications/${id}/interview`, {
      ...interview,
      at: '2020-01-01T07:00:00.000Z',
    });
    expect([past.statusCode, past.json().error]).toEqual([400, 'interview_in_past']);
    const scheduled = await ops('PUT', `captain-applications/${id}/interview`, interview);
    expect(scheduled.json()).toMatchObject({ stage: 'interview', interview });
    expect((await who.call('GET', '/application')).json().application).toMatchObject({
      stage: 'interview',
      interview,
    });
    const passed = await ops('POST', `captain-applications/${id}/training-passed`);
    expect(passed.json().stage).toBe('awaiting_kit');
    const history = (await who.call('GET', '/application')).json().application.history;
    expect(history.map((each: { stage: string }) => each.stage)).toEqual([
      'new',
      'under_review',
      'interview',
      'awaiting_kit',
    ]);

    // Every change the applicant hears, silently, on their account's devices.
    expect(await pushes(who)).toEqual([
      { template_key: 'captain.application_under_review', body: 'طلبك قيد المراجعة.' },
      { template_key: 'captain.document_rejected', body: 'رُفض إخراج القيد: الصورة غير واضحة' },
      {
        template_key: 'captain.application_document_requested',
        body: 'يرجى رفع شهادة القيادة: نحتاج شهادة القيادة',
      },
      {
        template_key: 'captain.application_interview',
        body: 'موعد المقابلة والتدريب: الإثنين 05/01/2099 10:00 ص في مكتب أعزاز',
      },
      {
        template_key: 'captain.application_awaiting_kit',
        body: 'اجتزت التدريب. استلم العدة ووقّع العقد في المكتب.',
      },
    ]);
    const { rows: audited } = await sql.query(
      `SELECT action FROM audit.events WHERE target_id = $1 ORDER BY occurred_at, id`,
      [id],
    );
    expect(audited.map((row: { action: string }) => row.action)).toEqual([
      'captain_application.document_review',
      'captain_application.document_review',
      'captain_application.document_request',
      'captain_application.note',
      'captain_application.interview',
      'captain_application.training_passed',
    ]);
  });

  it('takes the office’s scan of a document', async () => {
    const who = await sent();
    const id = await applicationOf(who);
    const ops = await admin('OPS');
    const asked = await ops('POST', 'uploads', {
      purpose: 'captain_document',
      contentType: 'image/jpeg',
      sizeBytes: jpeg.length,
    });
    expect(asked.statusCode).toBe(201);
    await put(asked.json().url);
    const scanned = await ops('PUT', `captain-applications/${id}/documents/civil_registry`, {
      uploadIds: [asked.json().uploadId],
    });
    expect(scanned.statusCode).toBe(200);
    expect(scanned.json().stage).toBe('under_review');
    expect(
      scanned
        .json()
        .documents.filter((each: { kind: string }) => each.kind === 'civil_registry')
        .map((each: { inForce: boolean; uploadedByOffice: boolean }) => [
          each.inForce,
          each.uploadedByOffice,
        ]),
    ).toEqual([
      [true, true],
      [false, false],
    ]);
  });

  it('waitlists, brings back, rejects, and lets the applicant apply again after 30 days', async () => {
    const who = await sent();
    const id = await applicationOf(who);
    const ops = await admin('OPS');
    expect((await ops('POST', `captain-applications/${id}/waitlist`)).json().stage).toBe(
      'waitlist',
    );
    expect((await ops('POST', `captain-applications/${id}/back-from-waitlist`)).json().stage).toBe(
      'under_review',
    );
    const rejected = await ops('POST', `captain-applications/${id}/reject`, {
      reason: 'لا تتوفر الشروط',
    });
    expect(rejected.json()).toMatchObject({
      stage: 'rejected',
      rejection: { reason: 'لا تتوفر الشروط' },
    });
    const again = await ops('POST', `captain-applications/${id}/reject`, { reason: 'x' });
    expect([again.statusCode, again.json().error]).toEqual([409, 'wrong_stage']);
    const seen = (await who.call('GET', '/application')).json().application;
    expect(seen).toMatchObject({ stage: 'rejected', rejection: { reason: 'لا تتوفر الشروط' } });
    expect(
      new Date(seen.rejection.reapplyFrom).getTime() - new Date(seen.rejection.at).getTime(),
    ).toBe(30 * 24 * 60 * 60 * 1000);
    expect((await pushes(who)).map((each) => each.template_key)).toEqual([
      'captain.application_waitlist',
      'captain.application_under_review',
      'captain.application_rejected',
    ]);

    const personal = { fullName: 'محمد أحمد العلي', birthDate: '2000-05-01', zoneId };
    const early = await who.call('PUT', '/application/personal', personal);
    expect(early.statusCode).toBe(409);
    expect(early.json()).toMatchObject({
      error: 'reapply_wait',
      reapplyFrom: seen.rejection.reapplyFrom,
    });
    await sql.query(
      "UPDATE captains.applications SET rejected_at = rejected_at - interval '30 days' WHERE id = $1",
      [id],
    );
    const fresh = await who.call('PUT', '/application/personal', personal);
    expect(fresh.json().application).toMatchObject({ stage: 'draft', rejection: null });
    expect(fresh.json().application.id).not.toBe(id);
    // The phone finds the earlier application.
    await who.call('PUT', '/application/vehicle', { vehicle: 'walking' });
    const page = (await ops('GET', `captain-applications/${id}`)).json();
    expect(page.duplicates).toEqual([
      expect.objectContaining({ field: 'phone', applicationId: fresh.json().application.id }),
    ]);
  });
});
