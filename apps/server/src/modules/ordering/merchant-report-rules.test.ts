import { randomUUID } from 'node:crypto';
import { beforeAll, describe, expect, it } from 'vitest';
import { MerchantAccountsService } from '../identity/index.js';
import {
  acceptedOrder,
  admin,
  app,
  appSignIn,
  azaz,
  change,
  phoneNumber,
  restaurant,
  sql,
} from './delivery.fixture.js';

// RA §15, §8.19, §16 #29, AP §9.9.1 (slice 2.24b): the restaurant app's
// tickets on a real restaurant and order, without photos (their storage is
// the customer's reports' test: the same purpose and bucket).

beforeAll(() => {
  process.env.STORAGE_URL ??= 'http://127.0.0.1:1';
  process.env.STORAGE_KEY_ID ??= 'GK000000000000000000000001';
  process.env.STORAGE_SECRET ??= '0'.repeat(64);
  process.env.ADMIN_PANEL_URL ??= 'http://127.0.0.1:1';
  process.env.APP_UPLOAD_URL ??= 'http://127.0.0.1:1';
});

async function restaurantUser(role: 'owner' | 'cashier') {
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurant, { role, name: role, phone }, change);
  return appSignIn('merchant', phone);
}

const report = (user: { authorization: string }, body: object, key: string = randomUUID()) =>
  app.inject({
    method: 'POST',
    url: '/v1/merchant/reports',
    headers: { ...user, 'idempotency-key': key },
    payload: {
      typeCode: 'finance_inquiry',
      orderId: null,
      note: null,
      subject: null,
      photoUploadId: null,
      ...body,
    },
  });

const problem = (
  user: { authorization: string },
  orderId: string,
  body: object,
  key: string = randomUUID(),
) =>
  app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/problem`,
    headers: { ...user, 'idempotency-key': key },
    payload: { reasonCode: 'captain_late', note: null, ...body },
  });

const mine = async (user: { authorization: string }) =>
  (await app.inject({ method: 'GET', url: '/v1/merchant/reports', headers: user })).json()
    .tickets as { id: string; openedByMe: boolean }[];

describe('«إبلاغ عن مشكلة»', () => {
  it('opens a ticket in the panel, repeats its key and asks a data change its subject', async () => {
    const cashier = await restaurantUser('cashier');
    const key = randomUUID();
    const sent = await report(cashier, { note: 'متى يصل الكشف؟' }, key);
    expect(sent.statusCode).toBe(200);
    const { ticket } = sent.json();
    expect(ticket).toMatchObject({
      typeLabel: 'استفسار مالي',
      status: 'new',
      description: 'متى يصل الكشف؟',
      orderId: null,
      openedByMe: true,
      replyWithinMinutes: 24 * 60,
    });
    expect((await report(cashier, { note: 'متى يصل الكشف؟' }, key)).json().ticket.id).toBe(
      ticket.id,
    );
    expect((await report(cashier, { note: 'غير' }, key)).statusCode).toBe(422);

    const sup = await admin(['SUP']);
    const page = (await sup.get(`/v1/admin/tickets/${ticket.id}?cityId=${azaz}`)).json();
    expect(page).toMatchObject({
      source: 'merchant_report',
      party: 'restaurant',
      partyId: restaurant,
      urgent: false,
      report: { subject: null, photoUrls: [] },
    });

    const refused = async (body: object) => {
      const answer = await report(cashier, body);
      expect(answer.statusCode).toBe(400);
      return answer.json().error;
    };
    expect(await refused({ typeCode: 'data_change' })).toBe('subject_required');
    expect(await refused({ subject: 'coverage' })).toBe('invalid_subject');
    expect(await refused({ typeCode: 'captain_late' })).toBe('unknown_reason');

    const change = await report(cashier, {
      typeCode: 'data_change',
      subject: 'min_order',
      note: 'نريد الحد الأدنى 50',
    });
    expect(change.json().ticket).toMatchObject({
      typeLabel: 'طلب تعديل بيانات',
      subject: 'min_order',
    });
    const changePage = (
      await sup.get(`/v1/admin/tickets/${change.json().ticket.id}?cityId=${azaz}`)
    ).json();
    expect(changePage.report.subject).toBe('min_order');
  });

  it("links only the restaurant's own order", async () => {
    const order = await acceptedOrder();
    const sent = await report(order.cashier, { typeCode: 'order_problem', orderId: order.id });
    expect(sent.statusCode).toBe(200);
    expect(sent.json().ticket.orderNumber).not.toBeNull();
    const unknown = await report(order.cashier, { orderId: randomUUID() });
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json().error).toBe('unknown_order');
  });
});

describe('«مشكلة في الطلب»', () => {
  it('opens a ticket on the order, urgent while it is active', async () => {
    const order = await acceptedOrder();
    const sent = await problem(order.cashier, order.id, {});
    expect(sent.statusCode).toBe(200);
    const { ticket } = sent.json();
    expect(ticket).toMatchObject({ typeLabel: 'الكابتن تأخر', orderId: order.id });
    const sup = await admin(['SUP']);
    const page = (await sup.get(`/v1/admin/tickets/${ticket.id}?cityId=${azaz}`)).json();
    expect(page).toMatchObject({
      source: 'order_problem',
      urgent: true,
      sla: { kind: 'first_response' },
    });
    const { rows } = await sql.query(
      "SELECT count(*)::int AS n FROM notifications.alerts WHERE subject_id = $1 AND code = 'urgent_ticket' AND resolved_at IS NULL",
      [ticket.id],
    );
    expect(rows[0].n).toBe(1);
  });

  it("refuses another restaurant's order and a reason outside its list", async () => {
    const order = await acceptedOrder();
    expect((await problem(order.cashier, randomUUID(), {})).statusCode).toBe(404);
    const wrong = await problem(order.cashier, order.id, { reasonCode: 'finance_inquiry' });
    expect(wrong.statusCode).toBe(400);
    expect(wrong.json().error).toBe('unknown_reason');
  });
});

describe('«بلاغاتي»', () => {
  it('shows an owner every ticket of the restaurant and a cashier their own', async () => {
    const first = await restaurantUser('cashier');
    const second = await restaurantUser('cashier');
    const owner = await restaurantUser('owner');
    const a = (await report(first, {})).json().ticket.id;
    const b = (await report(second, {})).json().ticket.id;
    const firstSees = (await mine(first)).map((each) => each.id);
    expect(firstSees).toContain(a);
    expect(firstSees).not.toContain(b);
    const ownerSees = await mine(owner);
    expect(ownerSees.map((each) => each.id)).toEqual(expect.arrayContaining([a, b]));
    expect(ownerSees.every((each) => !each.openedByMe)).toBe(true);
  });

  it('shows the resolution, and tells the owners and the reporter', async () => {
    const cashier = await restaurantUser('cashier');
    const { ticket } = (await report(cashier, {})).json();
    const sup = await admin(['SUP']);
    const resolved = await sup.post(`/v1/admin/tickets/${ticket.id}/resolve`, {
      cityId: azaz,
      resolution: 'none_explained',
      responsible: 'platform',
      message: 'الكشف يصل السبت.',
      receivedLines: null,
    });
    expect(resolved.statusCode).toBe(200);
    expect((await mine(cashier)).find((each) => each.id === ticket.id)).toMatchObject({
      status: 'resolved',
      message: 'الكشف يصل السبت.',
    });
    const { rows } = await sql.query(
      `SELECT p.restaurant_id, p.owners_only, p.account_id, t.opened_by
         FROM notifications.push_messages p JOIN support.tickets t ON t.id::text = p.data->>'ticketId'
        WHERE t.id = $1 AND p.template_key = 'merchant.ticket_resolved'`,
      [ticket.id],
    );
    expect(rows).toHaveLength(1);
    expect(rows[0]).toMatchObject({ restaurant_id: restaurant, owners_only: true });
    expect(rows[0].account_id).toBe(rows[0].opened_by);
  });
});
