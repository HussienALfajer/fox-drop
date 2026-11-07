import 'reflect-metadata';
import { randomBytes } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { NotificationTexts } from './notification-texts.service.js';

// The content routes (AP §9.13) served by the API app as in production:
// the answers parse by their schemas, and refusals map to their statuses.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let accounts = 0;

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
    [`Editor ${accounts}`, `editor${accounts}@example.test`],
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
  return (method: 'GET' | 'POST' | 'PUT', url: string, payload?: object) =>
    app.inject({ method, url, cookies, ...(payload ? { payload } : {}) });
}

describe("the apps' read", () => {
  it('answers each app its lists and FAQ, without a session', async () => {
    const captain = await app.inject({ method: 'GET', url: '/v1/captain/content' });
    expect(captain.statusCode).toBe(200);
    expect(captain.json().reasons.shortfall).toContainEqual({
      code: 'other',
      label: 'أخرى',
      note: 'required',
    });
    expect(captain.json().workRules).toContain('الخوذة');
    const customer = await app.inject({ method: 'GET', url: '/v1/customer/content' });
    expect(customer.json().reasons.customer_cancel.at(-1)).toEqual({
      code: 'other',
      label: 'سبب آخر',
      note: 'optional',
    });
    const merchant = await app.inject({ method: 'GET', url: '/v1/merchant/content' });
    expect(Object.keys(merchant.json().reasons)).toContain('merchant_rejection');
  });
});

describe("the panel's routes", () => {
  it('lets the owner add, edit and reorder a reason', async () => {
    const owner = await admin(['OWN']);
    const added = await owner('POST', '/v1/admin/content/reasons/order_note', {
      label: 'اترك الطلب عند الباب',
      customerText: null,
      note: 'none',
    });
    expect(added.statusCode).toBe(201);
    const code: string = added.json().code;
    const edited = await owner('PUT', `/v1/admin/content/reasons/order_note/${code}`, {
      label: 'اترك الطلب عند الباب من فضلك',
      customerText: null,
      note: 'none',
      active: true,
    });
    expect(edited.json()).toMatchObject({ label: 'اترك الطلب عند الباب من فضلك', active: true });
    const lists = (await owner('GET', '/v1/admin/content/reasons')).json().lists;
    const notes = lists.find((each: { list: string }) => each.list === 'order_note');
    const codes = notes.reasons.map((reason: { code: string }) => reason.code);
    const reordered = await owner('POST', '/v1/admin/content/reasons/order_note/order', {
      codes: [code, ...codes.filter((each: string) => each !== code)],
    });
    expect(reordered.statusCode).toBe(200);
    expect(reordered.json().reasons[0].code).toBe(code);
  });

  it('answers 404 for an unknown list or reason, and 400 with the refusal', async () => {
    const owner = await admin(['OWN']);
    const fields = { label: 'جديد', customerText: null, note: 'none' };
    expect((await owner('POST', '/v1/admin/content/reasons/nope', fields)).statusCode).toBe(404);
    expect(
      (
        await owner('PUT', '/v1/admin/content/reasons/shortfall/nope', {
          ...fields,
          active: true,
        })
      ).statusCode,
    ).toBe(404);
    const closed = await owner('POST', '/v1/admin/content/reasons/merchant_rejection', fields);
    expect(closed.statusCode).toBe(400);
    expect(closed.json().error).toBe('list_closed');
  });

  it('lets support edit the FAQs and nothing else', async () => {
    const support = await admin(['SUP']);
    expect((await support('GET', '/v1/admin/content/faqs')).statusCode).toBe(200);
    const saved = await support('PUT', '/v1/admin/content/faqs/customer', {
      items: [{ question: 'كيف أتابع طلبي؟', answer: 'من صفحة الطلب.' }],
    });
    expect(saved.json()).toEqual({
      items: [{ question: 'كيف أتابع طلبي؟', answer: 'من صفحة الطلب.' }],
    });
    expect((await support('GET', '/v1/admin/content/reasons')).statusCode).toBe(403);
    expect((await support('GET', '/v1/admin/content/texts')).statusCode).toBe(403);
    const finance = await admin(['FIN']);
    expect((await finance('GET', '/v1/admin/content/faqs')).statusCode).toBe(403);
  });

  it('stores the work rules and the contact the apps then read', async () => {
    const owner = await admin(['OWN']);
    const rules = await owner('PUT', '/v1/admin/content/work-rules', {
      workRules: 'قاعدة أولى\nقاعدة ثانية',
    });
    expect(rules.json()).toEqual({ workRules: 'قاعدة أولى\nقاعدة ثانية' });
    const contact = await owner('PUT', '/v1/admin/content/contact', {
      phone: '+963944000000',
      whatsapp: null,
    });
    expect(contact.json()).toEqual({ phone: '+963944000000' });
    const bad = await owner('PUT', '/v1/admin/content/contact', { phone: '0944', whatsapp: null });
    expect(bad.statusCode).toBe(400);
    expect(bad.json().error).toBe('invalid_value');
    expect((await app.inject({ method: 'GET', url: '/v1/captain/contact' })).json()).toEqual({
      phone: '+963944000000',
    });
    const operations = await admin(['OPS']);
    const texts = await operations('GET', '/v1/admin/content/texts');
    expect(texts.json()).toEqual({
      workRules: 'قاعدة أولى\nقاعدة ثانية',
      contact: { phone: '+963944000000' },
    });
    expect(
      (await operations('PUT', '/v1/admin/content/work-rules', { workRules: 'x' })).statusCode,
    ).toBe(403);
  });

  it('edits a notification text within its variables, and renders it (AP §9.13)', async () => {
    const owner = await admin(['OWN']);
    const list = (await owner('GET', '/v1/admin/content/notifications')).json().templates;
    expect(list.find((template: { key: string }) => template.key === 'customer.accepted')).toEqual({
      key: 'customer.accepted',
      audience: 'customer',
      row: 'CU §14 #1',
      variables: ['الساعة'],
      level: 'default',
      priority: 'normal',
      text: 'المطعم يحضّر طلبك. يصل حوالي {الساعة}',
      current: 'المطعم يحضّر طلبك. يصل حوالي {الساعة}',
    });
    const texts = app.get(NotificationTexts);
    expect((await texts.render('customer.accepted', { الساعة: '9:45 م' })).body).toBe(
      'المطعم يحضّر طلبك. يصل حوالي 9:45 م',
    );

    const edited = await owner('PUT', '/v1/admin/content/notifications/customer.accepted', {
      text: 'قبل المطعم طلبك، يصل {الساعة}',
    });
    expect(edited.statusCode).toBe(200);
    expect(edited.json().current).toBe('قبل المطعم طلبك، يصل {الساعة}');
    expect(await texts.render('customer.accepted', { الساعة: '9:45 م' })).toEqual({
      key: 'customer.accepted',
      body: 'قبل المطعم طلبك، يصل 9:45 م',
      level: 'default',
      priority: 'normal',
    });

    const unknown = await owner('PUT', '/v1/admin/content/notifications/customer.accepted', {
      text: 'يصل {الساعة} مع {الاسم}',
    });
    expect(unknown.statusCode).toBe(400);
    expect(unknown.json().error).toBe('unknown_variable');
    const missing = await owner('PUT', '/v1/admin/content/notifications/customer.nothing', {
      text: 'نص',
    });
    expect(missing.statusCode).toBe(404);
    const operations = await admin(['OPS']);
    expect((await operations('GET', '/v1/admin/content/notifications')).statusCode).toBe(200);
    expect(
      (
        await operations('PUT', '/v1/admin/content/notifications/customer.accepted', {
          text: 'نص',
        })
      ).statusCode,
    ).toBe(403);
  });
});
