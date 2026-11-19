import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestStorage, type TestStorage } from '../../storage/test-storage.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from '../identity/index.js';
import { CaptainsService } from './captains.service.js';

// CA §5.1–5.3, §15 (slice 2.34a): the application form, from «انضم ككابتن»
// to «إرسال الطلب», with the documents' photos in a real Garage's
// private-docs.
let database: TestDatabase;
let cache: TestValkey;
let storage: TestStorage;
let app: NestFastifyApplication;
let sql: pg.Pool;
let sender: DevelopmentCodeSender;
let azaz: string;
let zoneId: string;

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
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  sender = app.get(CODE_SENDER);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  const geo = app.get(GeoService);
  const square = (x: number) => [
    { latitude: 36.58, longitude: x },
    { latitude: 36.58, longitude: x + 0.01 },
    { latitude: 36.59, longitude: x + 0.01 },
    { latitude: 36.59, longitude: x },
  ];
  zoneId = await geo.createZone(
    azaz,
    { name: 'الحي الشمالي', area: square(37.04), active: true },
    change,
  );
  await geo.createZone(azaz, { name: 'حي مغلق', area: square(37.06), active: false }, change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop(), storage?.stop()]);
});

function newPhone(): string {
  return `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
}

// A new number's «انضم ككابتن», signed in: the applicant's calls.
async function applicant() {
  const phone = newPhone();
  const deviceId = randomUUID();
  const code = await app.inject({
    method: 'POST',
    url: '/v1/captain/auth/code',
    payload: { phone, deviceId, join: true },
  });
  expect(code.statusCode).toBe(200);
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
  return { accountId: accountId as string, headers, call };
}

type Applicant = Awaited<ReturnType<typeof applicant>>;

const jpeg = Buffer.concat([Buffer.from([0xff, 0xd8, 0xff, 0xe0]), randomBytes(60)]);

async function photo(who: Applicant): Promise<string> {
  const asked = await who.call('POST', '/application/documents/upload', {
    contentType: 'image/jpeg',
    sizeBytes: jpeg.length,
  });
  expect(asked.statusCode).toBe(201);
  const { uploadId, url } = asked.json();
  expect(new URL(url).pathname).toMatch(/^\/private-docs\/incoming\//);
  const put = await fetch(url, {
    method: 'PUT',
    body: jpeg,
    headers: { 'content-type': 'image/jpeg' },
  });
  expect(put.status).toBe(200);
  return uploadId as string;
}

const personal = { fullName: 'محمد أحمد العلي', birthDate: '2000-05-01' };

async function document(who: Applicant, kind: string, extra: object = {}, files = 1) {
  const uploadIds = [];
  for (let i = 0; i < files; i += 1) uploadIds.push(await photo(who));
  return who.call('PUT', `/application/documents/${kind}`, { uploadIds, ...extra });
}

async function acceptTerms(who: Applicant) {
  const terms = await who.call('GET', '/terms');
  expect(
    (await who.call('POST', '/terms/accept', { version: terms.json().version })).statusCode,
  ).toBe(200);
}

describe('the application form (CA §5.1–5.2)', () => {
  it('lists the active zones of the active cities as the neighbourhoods', async () => {
    const who = await applicant();
    const zones = (await who.call('GET', '/application/zones')).json().zones;
    expect(zones).toContainEqual({
      id: zoneId,
      name: 'الحي الشمالي',
      cityId: azaz,
      cityName: expect.any(String),
    });
    expect(zones.map((zone: { name: string }) => zone.name)).not.toContain('حي مغلق');
  });

  it('saves the draft after every step, and refuses what the steps refuse', async () => {
    const who = await applicant();
    expect((await who.call('GET', '/application')).json()).toEqual({ application: null });
    // Step 2 before step 1.
    const early = await who.call('PUT', '/application/vehicle', { vehicle: 'walking' });
    expect([early.statusCode, early.json().error]).toEqual([409, 'no_application']);

    for (const [body, error] of [
      [{ ...personal, fullName: 'محمد العلي', zoneId }, 'invalid_name'],
      [{ ...personal, birthDate: '2015-01-01', zoneId }, 'too_young'],
      [{ ...personal, zoneId: randomUUID() }, 'unknown_zone'],
    ] as const) {
      const refused = await who.call('PUT', '/application/personal', body);
      expect([refused.statusCode, refused.json().error]).toEqual([400, error]);
    }
    const saved = await who.call('PUT', '/application/personal', {
      ...personal,
      fullName: ' محمد  أحمد العلي ',
      zoneId,
    });
    expect(saved.statusCode).toBe(200);
    expect(saved.json().application).toMatchObject({
      stage: 'draft',
      fullName: 'محمد أحمد العلي',
      birthDate: '2000-05-01',
      zoneId,
      vehicle: null,
      missing: [
        'vehicle',
        'document:national_id',
        'document:personal_photo',
        'document:civil_registry',
        'document:criminal_record',
        'terms',
      ],
    });
    // Saving step 1 again keeps one application.
    await who.call('PUT', '/application/personal', { ...personal, zoneId });
    const { rows } = await sql.query(
      'SELECT city_id FROM captains.applications WHERE account_id = $1',
      [who.accountId],
    );
    expect(rows).toEqual([{ city_id: azaz }]);

    const noPlate = await who.call('PUT', '/application/vehicle', { vehicle: 'motorbike' });
    expect([noPlate.statusCode, noPlate.json().error]).toEqual([400, 'plate_required']);
    const motorbike = await who.call('PUT', '/application/vehicle', {
      vehicle: 'motorbike',
      plate: ' 12345 ',
    });
    expect(motorbike.json().application).toMatchObject({ vehicle: 'motorbike', plate: '12345' });
    expect(motorbike.json().application.missing).toContain('document:vehicle_papers');
    const walking = await who.call('PUT', '/application/vehicle', {
      vehicle: 'walking',
      plate: '12345',
    });
    expect(walking.json().application).toMatchObject({ vehicle: 'walking', plate: null });
    expect(walking.json().application.missing).not.toContain('document:vehicle_papers');
  });

  it('keeps an applicant from the captain routes and a captain from the form', async () => {
    const who = await applicant();
    expect((await who.call('GET', '/availability')).statusCode).toBe(403);
    const captainId = await app
      .get(CaptainsService)
      .createCaptain(
        azaz,
        { name: 'كابتن', vehicle: 'walking', custodyLimit: { amount: 1_000n, currency: 'TRY' } },
        change,
      );
    // Activation (2.35) gives the account its captain.
    await sql.query(
      'UPDATE identity.captain_accounts SET captain_id = $1, city_id = $2 WHERE id = $3',
      [captainId, azaz, who.accountId],
    );
    const refused = await who.call('PUT', '/application/personal', { ...personal, zoneId });
    expect([refused.statusCode, refused.json().error]).toEqual([409, 'already_captain']);
  });
});

describe('the documents and «إرسال الطلب» (CA §5.3, §5.4)', () => {
  it('takes the documents, replaces one sent again, then sends the application', async () => {
    const who = await applicant();
    await who.call('PUT', '/application/personal', { ...personal, zoneId });
    await who.call('PUT', '/application/vehicle', { vehicle: 'car', plate: 'حلب 123' });

    const one = await document(who, 'national_id', { number: '01234567890' });
    expect([one.statusCode, one.json().error]).toEqual([400, 'invalid_files']);
    const noNumber = await document(who, 'national_id', {}, 2);
    expect([noNumber.statusCode, noNumber.json().error]).toEqual([400, 'number_required']);
    const id = await document(who, 'national_id', { number: '0123 4567 890' }, 2);
    expect(id.statusCode).toBe(200);
    expect(id.json().application.documents).toEqual([
      expect.objectContaining({
        kind: 'national_id',
        status: 'pending',
        fileCount: 2,
        number: '01234567890',
      }),
    ]);
    expect((await document(who, 'personal_photo')).statusCode).toBe(200);
    expect((await document(who, 'civil_registry', {}, 2)).statusCode).toBe(200);

    const noDate = await document(who, 'criminal_record');
    expect([noDate.statusCode, noDate.json().error]).toEqual([400, 'issue_date_required']);
    const old = await document(who, 'criminal_record', { issueDate: '2020-01-01' });
    expect([old.statusCode, old.json().error]).toEqual([400, 'document_expired']);
    const future = await document(who, 'criminal_record', { issueDate: '2999-01-01' });
    expect([future.statusCode, future.json().error]).toEqual([400, 'issue_date_in_future']);
    const today = new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Damascus' }).format(
      new Date(),
    );
    const record = await document(who, 'criminal_record', { issueDate: today });
    expect(record.statusCode).toBe(200);
    const [year, month, day] = today.split('-').map(Number) as [number, number, number];
    expect(
      record
        .json()
        .application.documents.find((each: { kind: string }) => each.kind === 'criminal_record'),
    ).toMatchObject({
      issueDate: today,
      expiresOn: expect.stringMatching(
        new RegExp(`^${year + 1}-${String(month).padStart(2, '0')}-`),
      ),
    });
    expect(day).toBeGreaterThan(0);

    // A photo is used once.
    const used = await photo(who);
    expect(
      (await who.call('PUT', '/application/documents/driving_licence', { uploadIds: [used] }))
        .statusCode,
    ).toBe(200);
    const again = await who.call('PUT', '/application/documents/vehicle_papers', {
      uploadIds: [used],
    });
    expect([again.statusCode, again.json().error]).toEqual([400, 'invalid_files']);

    const early = await who.call('POST', '/application/submit');
    expect(early.statusCode).toBe(409);
    expect(early.json()).toMatchObject({
      error: 'incomplete',
      missing: ['document:vehicle_papers', 'terms'],
    });
    expect((await document(who, 'vehicle_papers')).statusCode).toBe(200);
    // Sent again, the personal photo replaces the one in force.
    expect((await document(who, 'personal_photo')).statusCode).toBe(200);
    const { rows: photos } = await sql.query(
      `SELECT replaced_at IS NULL AS in_force FROM captains.application_documents d
       JOIN captains.applications a ON a.id = d.application_id
       WHERE a.account_id = $1 AND d.kind = 'personal_photo' ORDER BY d.created_at`,
      [who.accountId],
    );
    expect(photos).toEqual([{ in_force: false }, { in_force: true }]);
    await acceptTerms(who);

    const sent = await who.call('POST', '/application/submit');
    expect(sent.statusCode).toBe(200);
    expect(sent.json().application).toMatchObject({
      stage: 'new',
      missing: [],
      submittedAt: expect.any(String),
    });
    // A repeat answers the application sent; the form is closed now.
    expect((await who.call('POST', '/application/submit')).json().application.stage).toBe('new');
    const late = await who.call('PUT', '/application/vehicle', { vehicle: 'walking' });
    expect([late.statusCode, late.json().error]).toEqual([409, 'application_submitted']);
    const lateDocument = await document(who, 'personal_photo');
    expect([lateDocument.statusCode, lateDocument.json().error]).toEqual([
      409,
      'application_submitted',
    ]);
  });

  it('refuses vehicle papers without a motor vehicle, and another account’s photo', async () => {
    const who = await applicant();
    await who.call('PUT', '/application/personal', { ...personal, zoneId });
    await who.call('PUT', '/application/vehicle', { vehicle: 'bicycle' });
    const papers = await document(who, 'vehicle_papers');
    expect([papers.statusCode, papers.json().error]).toEqual([409, 'document_not_needed']);
    const other = await applicant();
    const theirs = await photo(other);
    const stolen = await who.call('PUT', '/application/documents/personal_photo', {
      uploadIds: [theirs],
    });
    expect([stolen.statusCode, stolen.json().error]).toEqual([400, 'upload_not_found']);
  });
});
