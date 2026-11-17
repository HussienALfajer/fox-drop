import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SupportService, type TicketAdmin, type TicketOrder, TicketSync } from './index.js';

// AP §9.9.1–§9.9.3, §9.1.3 (slice 2.23a): «تذكرة يدوية» with its number,
// party and type, the list with its filters and SLA timers, the page with
// internal notes, the assignee and the status, and «تذكرة عاجلة».
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let support: SupportService;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

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
  support = app.get(SupportService);
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

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const name = `Support ${accounts}`;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [name, `tickets${accounts}@example.test`],
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
  const send =
    (method: 'POST' | 'PUT') =>
    (url: string, payload: object, key: string | null = randomUUID()) =>
      app.inject({
        method,
        url,
        cookies,
        headers: key === null ? {} : { 'idempotency-key': key },
        payload,
      });
  const ticketAdmin: TicketAdmin = {
    accountId,
    actor: { type: 'admin', id: accountId, role: roles.join(',') },
    context: { ipAddress: null, device: null },
    permissions: [],
  };
  return {
    accountId,
    name,
    ticketAdmin,
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    post: send('POST'),
    put: send('PUT'),
  };
}

async function restaurant() {
  const id = await app.get(MerchantsService).createRestaurant(
    azaz,
    {
      nameAr: `مطعم التذاكر ${randomUUID()}`,
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  return id;
}

async function captain() {
  return app.get(CaptainsService).createCaptain(
    azaz,
    {
      name: `كابتن التذاكر ${randomUUID().slice(0, 8)}`,
      vehicle: 'walking',
      custodyLimit: { amount: 1_000_000n, currency: 'TRY' },
    },
    change,
  );
}

let orders = 0;
function order(active: boolean, captainId: string | null = null): TicketOrder {
  orders += 1;
  return {
    id: randomUUID(),
    cityId: azaz,
    number: BigInt(30000 + orders),
    active,
    customerId: randomUUID(),
    restaurantId: randomUUID(),
    captainId,
  };
}

// A ticket opened on an order as ordering's route does, in a transaction.
async function openOnOrder(
  target: TicketOrder,
  party: 'customer' | 'restaurant' | 'captain',
  by: TicketAdmin,
  now = new Date(),
) {
  const prepared = await support.prepare({
    cityId: azaz,
    party,
    partyId: null,
    restaurantId: null,
    typeCode: party === 'customer' ? 'missing_item' : 'order_problem',
    description: 'اتصل الزبون',
  });
  const id = await db.db.transaction((tx) =>
    support.openIn(tx, prepared, target, by, randomUUID(), now),
  );
  return support.ticket(azaz, id);
}

async function openAlerts(ticketId: string) {
  return (
    await sql.query(
      "SELECT code, severity, details FROM notifications.alerts WHERE subject_type = 'ticket' AND subject_id = $1 AND resolved_at IS NULL",
      [ticketId],
    )
  ).rows;
}

async function typeCodes(list: string) {
  return (
    await sql.query('SELECT code FROM content.reasons WHERE list = $1 ORDER BY position', [list])
  ).rows.map((row) => row.code as string);
}

describe('«تذكرة يدوية»', () => {
  it('opens a ticket on a party with its number, type and the resolution timer', async () => {
    const own = await admin(['OWN']);
    const restaurantId = await restaurant();
    const [type] = await typeCodes('merchant_ticket_type');
    const key = randomUUID();
    const body = {
      cityId: azaz,
      party: 'restaurant',
      partyId: restaurantId,
      typeCode: type,
      description: 'المطعم يسأل عن الكشف',
    };
    const before = Date.now();
    const opened = await own.post('/v1/admin/tickets', body, key);
    expect(opened.statusCode).toBe(200);
    const ticket = opened.json();
    expect(ticket).toMatchObject({
      source: 'manual',
      party: 'restaurant',
      partyId: restaurantId,
      orderId: null,
      urgent: false,
      typeCode: type,
      status: 'new',
      assigneeId: null,
      openedByName: own.name,
      sla: { kind: 'resolution', stoppedAt: null },
    });
    expect(ticket.partyName).toMatch(/^مطعم التذاكر/);
    const hours = (Date.parse(ticket.sla.dueAt) - Date.parse(ticket.sla.startedAt)) / 3_600_000;
    expect(hours).toBe(24);
    expect(Date.parse(ticket.openedAt)).toBeGreaterThanOrEqual(before - 1000);
    expect(await openAlerts(ticket.id)).toEqual([]);
    // A repeat answers the same ticket; the key with another body is refused.
    expect((await own.post('/v1/admin/tickets', body, key)).json().id).toBe(ticket.id);
    const reused = await own.post('/v1/admin/tickets', { ...body, description: 'آخر' }, key);
    expect(reused.statusCode).toBe(422);
    // The next ticket of the city takes the next number.
    const next = (await own.post('/v1/admin/tickets', body)).json();
    expect(BigInt(next.number)).toBe(BigInt(ticket.number) + 1n);
  });

  it("refuses a type outside the party's list and a party of no such id", async () => {
    const sup = await admin(['SUP']);
    const captainId = await captain();
    const body = {
      cityId: azaz,
      party: 'captain',
      partyId: captainId,
      typeCode: 'not_a_type',
      description: 'x',
    };
    expect((await sup.post('/v1/admin/tickets', body)).json()).toMatchObject({
      statusCode: 400,
      error: 'unknown_reason',
    });
    const [type] = await typeCodes('captain_ticket_type');
    const unknown = await sup.post('/v1/admin/tickets', {
      ...body,
      typeCode: type,
      partyId: randomUUID(),
    });
    expect(unknown.json()).toMatchObject({ statusCode: 404, error: 'unknown_party' });
  });

  it('gives the three type lists, the assignees and finds a party by name', async () => {
    const sup = await admin(['SUP']);
    const types = (await sup.get('/v1/admin/tickets/types')).json();
    // «سعر مختلف عن المحل» after the Content list, opened by hand (2.23b).
    expect(types.customer.map((each: { code: string }) => each.code)).toEqual([
      ...(await typeCodes('customer_problem')),
      'price_difference',
    ]);
    expect(types.restaurant.map((each: { code: string }) => each.code)).toEqual(
      await typeCodes('merchant_ticket_type'),
    );
    expect(types.captain.map((each: { code: string }) => each.code)).toEqual(
      await typeCodes('captain_ticket_type'),
    );
    const fin = await admin(['FIN']);
    const assignees = (await sup.get('/v1/admin/tickets/assignees')).json().assignees;
    expect(assignees).toContainEqual({ id: sup.accountId, name: sup.name });
    expect(assignees.map((each: { id: string }) => each.id)).not.toContain(fin.accountId);
    const restaurantId = await restaurant();
    const [{ nameAr }] = (
      await sql.query('SELECT name_ar AS "nameAr" FROM merchants.restaurants WHERE id = $1', [
        restaurantId,
      ])
    ).rows;
    const found = await sup.post(
      '/v1/admin/tickets/parties/search',
      { cityId: azaz, party: 'restaurant', q: nameAr.slice(-12) },
      null,
    );
    expect(found.json().parties).toEqual([{ id: restaurantId, name: nameAr }]);
  });
});

describe('a ticket on an active order', () => {
  it('is urgent with the first-response timer and raises «تذكرة عاجلة» until the order ends', async () => {
    const sup = await admin(['SUP']);
    const target = order(true);
    const ticket = await openOnOrder(target, 'customer', sup.ticketAdmin);
    expect(ticket).toMatchObject({
      party: 'customer',
      partyId: target.customerId,
      orderId: target.id,
      orderNumber: target.number,
      urgent: true,
      status: 'new',
    });
    expect(ticket.sla.kind).toBe('first_response');
    expect(ticket.sla.dueAt.getTime() - ticket.sla.startedAt.getTime()).toBe(15 * 60_000);
    expect(await openAlerts(ticket.id)).toEqual([
      {
        code: 'urgent_ticket',
        severity: 'critical',
        details: { ticketNumber: ticket.number.toString(), orderNumber: target.number.toString() },
      },
    ]);
    // SUP receives it (AP §9.1.3), FIN does not.
    const alerts = (await sup.get(`/v1/admin/alerts?cityId=${azaz}&state=open`)).json().alerts;
    expect(alerts.map((each: { subjectId: string }) => each.subjectId)).toContain(ticket.id);
    const fin = await admin(['FIN']);
    const finAlerts = (await fin.get(`/v1/admin/alerts?cityId=${azaz}&state=open`)).json().alerts;
    expect(finAlerts.map((each: { subjectId: string }) => each.subjectId)).not.toContain(ticket.id);
    expect(await support.ordersWithOpenTickets([target.id, randomUUID()])).toEqual(
      new Set([target.id]),
    );
    // The order's detail lists it.
    const listed = (await sup.get(`/v1/admin/orders/${target.id}/tickets`)).json().tickets;
    expect(listed.map((each: { id: string }) => each.id)).toEqual([ticket.id]);
    // The order ends: «عادية», and the alert closes.
    await db.db.transaction((tx) => app.get(TicketSync).orderEnded(tx, target.id, new Date()));
    expect(await openAlerts(ticket.id)).toEqual([]);
    expect((await support.ticket(azaz, ticket.id)).urgent).toBe(false);
  });

  it("takes the captain's id from the order, and refuses a captain's ticket without one", async () => {
    const ops = await admin(['OPS']);
    const captainId = await captain();
    const withCaptain = await openOnOrder(order(true, captainId), 'captain', ops.ticketAdmin);
    expect(withCaptain.partyId).toBe(captainId);
    await expect(openOnOrder(order(true), 'captain', ops.ticketAdmin)).rejects.toMatchObject({
      refusal: 'no_captain',
    });
  });

  it('is normal with the resolution timer on an order that already ended', async () => {
    const sup = await admin(['SUP']);
    const ticket = await openOnOrder(order(false), 'restaurant', sup.ticketAdmin);
    expect(ticket).toMatchObject({ urgent: false, sla: { kind: 'resolution' } });
    expect(await openAlerts(ticket.id)).toEqual([]);
  });

  it('takes the description as the text «أخرى» asks for', async () => {
    const prepared = await support.prepare({
      cityId: azaz,
      party: 'customer',
      partyId: null,
      restaurantId: null,
      typeCode: 'other',
      description: 'الزبون يريد تغيير العنوان',
    });
    expect(prepared.chosen).toMatchObject({ code: 'other', label: 'أخرى' });
  });

  it('answers 404 for an unknown order', async () => {
    const sup = await admin(['SUP']);
    const opened = await sup.post(`/v1/admin/orders/${randomUUID()}/tickets`, {
      party: 'customer',
      typeCode: 'missing_item',
      description: 'x',
    });
    expect(opened.json()).toMatchObject({ statusCode: 404, error: 'unknown_order' });
  });
});

describe('the ticket page', () => {
  it('turns «قيد المعالجة» at the first note, stopping the first response, and keeps the notes', async () => {
    const sup = await admin(['SUP']);
    const ticket = await openOnOrder(order(true), 'customer', sup.ticketAdmin);
    const url = `/v1/admin/tickets/${ticket.id}/notes`;
    const key = randomUUID();
    const noted = await sup.post(url, { cityId: azaz, body: 'اتصلت بالزبون' }, key);
    expect(noted.statusCode).toBe(200);
    const page = noted.json();
    expect(page.status).toBe('in_progress');
    expect(page.sla.stoppedAt).not.toBeNull();
    expect(page.notes).toEqual([
      expect.objectContaining({ authorName: sup.name, body: 'اتصلت بالزبون' }),
    ]);
    // A repeat adds nothing; the alert stays while the order is active.
    expect(
      (await sup.post(url, { cityId: azaz, body: 'اتصلت بالزبون' }, key)).json().notes,
    ).toHaveLength(1);
    expect(await openAlerts(ticket.id)).toHaveLength(1);
    const read = (await sup.get(`/v1/admin/tickets/${ticket.id}?cityId=${azaz}`)).json();
    expect(read.notes).toHaveLength(1);
  });

  it('assigns the ticket, sets «بانتظار رد» by hand and refuses the other moves', async () => {
    const sup = await admin(['SUP']);
    const ops = await admin(['OPS']);
    const ticket = await openOnOrder(order(false), 'customer', sup.ticketAdmin);
    const base = `/v1/admin/tickets/${ticket.id}`;
    const stranger = await sup.put(
      `${base}/assignee`,
      { cityId: azaz, assigneeId: randomUUID() },
      null,
    );
    expect(stranger.json()).toMatchObject({ statusCode: 400, error: 'unknown_assignee' });
    const assigned = (
      await sup.put(`${base}/assignee`, { cityId: azaz, assigneeId: ops.accountId }, null)
    ).json();
    expect(assigned).toMatchObject({
      status: 'in_progress',
      assigneeId: ops.accountId,
      assigneeName: ops.name,
    });
    // The resolution timer keeps running.
    expect(assigned.sla.stoppedAt).toBeNull();
    const waiting = await sup.put(`${base}/status`, { cityId: azaz, status: 'waiting' }, null);
    expect(waiting.json()).toMatchObject({ status: 'waiting', sla: { stoppedAt: null } });
    const again = await sup.put(`${base}/status`, { cityId: azaz, status: 'waiting' }, null);
    expect(again.json()).toMatchObject({ statusCode: 409, error: 'invalid_status_change' });
    const resolved = await sup.put(`${base}/status`, { cityId: azaz, status: 'resolved' }, null);
    expect(resolved.statusCode).toBe(400);
    const back = await sup.put(`${base}/status`, { cityId: azaz, status: 'in_progress' }, null);
    expect(back.json().status).toBe('in_progress');
  });
});

describe('the list', () => {
  it('filters by status, assignee and a breached timer, newest first', async () => {
    const sup = await admin(['SUP']);
    const old = await openOnOrder(
      order(true),
      'customer',
      sup.ticketAdmin,
      new Date(Date.now() - 60 * 60_000),
    );
    const fresh = await openOnOrder(order(true), 'customer', sup.ticketAdmin);
    const list = async (query: string) =>
      (await sup.get(`/v1/admin/tickets?cityId=${azaz}${query}`))
        .json()
        .tickets.map((each: { id: string }) => each.id);
    const breached = await list('&breached=true');
    expect(breached).toContain(old.id);
    expect(breached).not.toContain(fresh.id);
    const all = await list('&status=new');
    expect(all.indexOf(fresh.id)).toBeLessThan(all.indexOf(old.id));
    await sup.put(
      `/v1/admin/tickets/${fresh.id}/assignee`,
      { cityId: azaz, assigneeId: sup.accountId },
      null,
    );
    expect(await list(`&assigneeId=${sup.accountId}`)).toEqual([fresh.id]);
    expect(await list('&status=new')).not.toContain(fresh.id);
  });
});

const pushOf = async (ticketId: string) =>
  (
    await sql.query(
      'SELECT template_key, party, account_id, captain_id, body, data FROM notifications.push_messages WHERE source = $1',
      [`support:ticket_resolved:${ticketId}`],
    )
  ).rows;

// AP §9.9.3 (slice 2.23b; owner decisions 2026-11-17): resolving sends the
// message to the party at once; «إغلاق» ends a ticket without one.
describe('resolving and closing', () => {
  it('resolves a general ticket with its responsible party and tells the customer', async () => {
    const sup = await admin(['SUP']);
    const target = order(true);
    const ticket = await openOnOrder(target, 'customer', sup.ticketAdmin);
    expect(ticket.urgent).toBe(true);
    const url = `/v1/admin/tickets/${ticket.id}/resolve`;
    const resolution = {
      cityId: azaz,
      resolution: 'none_explained',
      responsible: null,
      message: 'راجعنا بلاغك ولم نجد ما يستدعي تعويضاً.',
      receivedLines: null,
    };
    const missing = await sup.post(url, resolution, null);
    expect(missing.statusCode).toBe(400);
    expect(missing.json().error).toBe('responsible_required');
    const other = await sup.post(
      url,
      { ...resolution, resolution: 'price_correct', responsible: 'customer' },
      null,
    );
    expect(other.json().error).toBe('invalid_resolution');
    // FIN reads tickets but resolves only a pickup dispute.
    const fin = await admin(['FIN']);
    expect((await fin.post(url, { ...resolution, responsible: 'customer' }, null)).statusCode).toBe(
      403,
    );

    const resolved = await sup.post(url, { ...resolution, responsible: 'customer' }, null);
    expect(resolved.statusCode).toBe(200);
    expect(resolved.json()).toMatchObject({
      status: 'resolved',
      urgent: false,
      resolution: {
        code: 'none_explained',
        responsible: 'customer',
        message: resolution.message,
        correctedLines: null,
        resolvedByName: sup.name,
      },
      closure: null,
    });
    expect(resolved.json().sla.stoppedAt).not.toBeNull();
    expect(await openAlerts(ticket.id)).toEqual([]);
    expect(await pushOf(ticket.id)).toEqual([
      {
        template_key: 'customer.ticket_resolved',
        party: 'customer',
        account_id: target.customerId,
        captain_id: null,
        body: `تم الرد على بلاغك T-${ticket.number}`,
        data: { target: 'ticket', ticketId: ticket.id },
      },
    ]);
    const again = await sup.post(url, { ...resolution, responsible: 'customer' }, null);
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('ticket_not_open');
    expect(
      (await sup.post(`/v1/admin/tickets/${ticket.id}/close`, { cityId: azaz, reason: 'x' }, null))
        .statusCode,
    ).toBe(409);
    const audit = await sql.query(
      "SELECT reason FROM audit.events WHERE action = 'ticket.resolve' AND target_id = $1",
      [ticket.id],
    );
    expect(audit.rows).toEqual([{ reason: resolution.message }]);
  });

  it("sends a captain's message to the captain", async () => {
    const sup = await admin(['SUP']);
    const captainId = await captain();
    const ticket = await openOnOrder(order(false, captainId), 'captain', sup.ticketAdmin);
    const resolved = await sup.post(
      `/v1/admin/tickets/${ticket.id}/resolve`,
      {
        cityId: azaz,
        resolution: 'none_explained',
        responsible: 'platform',
        message: 'تمت المراجعة',
        receivedLines: null,
      },
      null,
    );
    expect(resolved.statusCode).toBe(200);
    expect(await pushOf(ticket.id)).toMatchObject([
      { template_key: 'captain.ticket_resolved', party: 'captain', captain_id: captainId },
    ]);
  });

  it('closes an open ticket without a resolution or a message', async () => {
    const sup = await admin(['SUP']);
    const ticket = await openOnOrder(order(true), 'customer', sup.ticketAdmin);
    const url = `/v1/admin/tickets/${ticket.id}/close`;
    expect((await sup.post(url, { cityId: azaz, reason: '' }, null)).statusCode).toBe(400);
    const closed = await sup.post(url, { cityId: azaz, reason: 'تذكرة مكررة' }, null);
    expect(closed.statusCode).toBe(200);
    expect(closed.json()).toMatchObject({
      status: 'closed',
      urgent: false,
      resolution: null,
      closure: { reason: 'تذكرة مكررة', closedByName: sup.name },
    });
    expect(await openAlerts(ticket.id)).toEqual([]);
    expect(await pushOf(ticket.id)).toEqual([]);
    expect((await sup.post(url, { cityId: azaz, reason: 'مرة أخرى' }, null)).json().error).toBe(
      'ticket_not_open',
    );
  });
});

// AP §9.9.1, §9.9.3: «سعر مختلف عن المحل», a customer's ticket on a
// restaurant, opened by hand until the app's report (owner decision
// 2026-11-17).
describe('«سعر مختلف عن المحل»', () => {
  it('names the restaurant, needs no responsible party and offers its two resolutions', async () => {
    const sup = await admin(['SUP']);
    const restaurantId = await restaurant();
    const customerId = (
      await sql.query(
        "INSERT INTO identity.customer_accounts (phone_hash, phone_encrypted, status) VALUES ($1, 'x', 'active') RETURNING id",
        [randomUUID()],
      )
    ).rows[0].id as string;
    const body = {
      cityId: azaz,
      party: 'customer',
      partyId: customerId,
      typeCode: 'price_difference',
      description: 'سعر الشاورما في المحل 50 وفي التطبيق 60',
    };
    const without = await sup.post('/v1/admin/tickets', body);
    expect(without.statusCode).toBe(400);
    expect(without.json().error).toBe('invalid_restaurant');
    const elsewhere = await sup.post('/v1/admin/tickets', {
      ...body,
      typeCode: 'missing_item',
      restaurantId,
    });
    expect(elsewhere.json().error).toBe('invalid_restaurant');
    const opened = await sup.post('/v1/admin/tickets', { ...body, restaurantId });
    expect(opened.statusCode).toBe(200);
    const ticket = opened.json();
    expect(ticket).toMatchObject({
      kind: 'price_difference',
      typeLabel: 'سعر مختلف عن المحل',
      restaurantId,
      orderId: null,
      urgent: false,
      sla: { kind: 'resolution' },
    });
    expect(ticket.restaurantName).toContain('مطعم التذاكر');
    const url = `/v1/admin/tickets/${ticket.id}/resolve`;
    const resolution = {
      cityId: azaz,
      resolution: 'price_correct',
      responsible: null,
      message: 'السعر في التطبيق هو سعر المحل',
      receivedLines: null,
    };
    expect(
      (await sup.post(url, { ...resolution, responsible: 'restaurant' }, null)).json().error,
    ).toBe('invalid_resolution');
    expect(
      (await sup.post(url, { ...resolution, resolution: 'none_explained' }, null)).json().error,
    ).toBe('invalid_resolution');
    const resolved = await sup.post(url, resolution, null);
    expect(resolved.statusCode).toBe(200);
    expect(resolved.json().resolution).toMatchObject({ code: 'price_correct', responsible: null });
    expect(await pushOf(ticket.id)).toMatchObject([
      { template_key: 'customer.ticket_resolved', account_id: customerId },
    ]);
  });
});

// AP §9.13 «الردود الجاهزة»: the draft, read on the ticket page, edited by
// OWN and SUP.
describe('«الردود الجاهزة»', () => {
  it('starts from the draft, reads for support and edits for SUP only', async () => {
    const sup = await admin(['SUP']);
    const fin = await admin(['FIN']);
    const read = await fin.get('/v1/admin/content/canned-replies');
    expect(read.statusCode).toBe(200);
    expect(read.json().replies.length).toBeGreaterThan(0);
    expect(read.json().replies[0]).toEqual({
      title: 'لم نجد مشكلة',
      body: 'راجعنا بلاغك ولم نجد ما يستدعي تعويضاً. شكراً لتواصلك معنا.',
    });
    const replies = [{ title: 'شكر', body: 'شكراً لتواصلك معنا.' }];
    expect((await fin.put('/v1/admin/content/canned-replies', { replies }, null)).statusCode).toBe(
      403,
    );
    const edited = await sup.put('/v1/admin/content/canned-replies', { replies }, null);
    expect(edited.statusCode).toBe(200);
    expect((await sup.get('/v1/admin/content/canned-replies')).json()).toEqual({ replies });
  });
});
