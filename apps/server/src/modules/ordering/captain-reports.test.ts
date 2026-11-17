import { randomUUID } from 'node:crypto';
import { beforeAll, describe, expect, it } from 'vitest';
import {
  admin,
  app,
  assignedOrder,
  azaz,
  onlineCaptain,
  orderAtDoor,
  pickedUpOrder,
  sql,
  TRY,
} from './delivery.fixture.js';

// CA §13, §9.11, §9.4 item 6, AP §9.9.1 (slice 2.24c): the captain app's
// tickets on a real order, without photos (their storage is the customer's
// reports' test: the same purpose and bucket).

beforeAll(() => {
  process.env.STORAGE_URL ??= 'http://127.0.0.1:1';
  process.env.STORAGE_KEY_ID ??= 'GK000000000000000000000001';
  process.env.STORAGE_SECRET ??= '0'.repeat(64);
  process.env.ADMIN_PANEL_URL ??= 'http://127.0.0.1:1';
  process.env.APP_UPLOAD_URL ??= 'http://127.0.0.1:1';
});

type Headers = { authorization: string };

const report = (captain: Headers, body: object, key: string = randomUUID()) =>
  app.inject({
    method: 'POST',
    url: '/v1/captain/reports',
    headers: { ...captain, 'idempotency-key': key },
    payload: { typeCode: 'app_problem', orderId: null, note: null, photoUploadId: null, ...body },
  });

const problem = (captain: Headers, orderId: string, body: object, key: string = randomUUID()) =>
  app.inject({
    method: 'POST',
    url: `/v1/captain/orders/${orderId}/problem`,
    headers: { ...captain, 'idempotency-key': key },
    payload: { reasonCode: 'restaurant_late', note: null, paidLines: null, ...body },
  });

const mine = async (captain: Headers) =>
  (await app.inject({ method: 'GET', url: '/v1/captain/reports', headers: captain })).json()
    .tickets as { id: string; openedBy: string; status: string; message: string | null }[];

describe('«إبلاغ عن مشكلة»', () => {
  it('opens a ticket in the panel and repeats its key', async () => {
    const { headers } = await onlineCaptain();
    const key = randomUUID();
    const sent = await report(headers, { note: 'التطبيق يتوقف' }, key);
    expect(sent.statusCode).toBe(200);
    const { ticket } = sent.json();
    expect(ticket).toMatchObject({
      typeLabel: 'مشكلة في التطبيق',
      status: 'new',
      description: 'التطبيق يتوقف',
      orderId: null,
      openedBy: 'me',
      replyWithinMinutes: 24 * 60,
    });
    expect((await report(headers, { note: 'التطبيق يتوقف' }, key)).json().ticket.id).toBe(
      ticket.id,
    );
    expect((await report(headers, { note: 'غير' }, key)).statusCode).toBe(422);

    const sup = await admin(['SUP']);
    const page = (await sup.get(`/v1/admin/tickets/${ticket.id}?cityId=${azaz}`)).json();
    expect(page).toMatchObject({
      source: 'captain_report',
      party: 'captain',
      urgent: false,
      openedByName: 'كابتن الوصول',
      report: { photoUrls: [] },
    });

    const refused = await report(headers, { typeCode: 'restaurant_late' });
    expect(refused.statusCode).toBe(400);
    expect(refused.json().error).toBe('unknown_reason');
  });

  it("names one of the captain's orders only, urgent while it is active", async () => {
    const { order, captain } = await assignedOrder();
    const sent = await report(captain.headers, { typeCode: 'order_problem', orderId: order.id });
    expect(sent.statusCode).toBe(200);
    expect(sent.json().ticket).toMatchObject({ orderId: order.id, replyWithinMinutes: 15 });

    const other = await onlineCaptain();
    const refused = await report(other.headers, { typeCode: 'order_problem', orderId: order.id });
    expect(refused.statusCode).toBe(404);
    expect(refused.json().error).toBe('unknown_order');
  });
});

describe('«مشكلة» with a quick reason (CA §9.11)', () => {
  it('opens an urgent ticket on the active order', async () => {
    const { order, captain } = await assignedOrder();
    const sent = await problem(captain.headers, order.id, { note: 'ينتظر منذ نصف ساعة' });
    expect(sent.statusCode).toBe(200);
    const { ticket } = sent.json();
    expect(ticket).toMatchObject({
      typeLabel: 'المطعم متأخر',
      orderId: order.id,
      replyWithinMinutes: 15,
    });
    const sup = await admin(['SUP']);
    const page = (await sup.get(`/v1/admin/tickets/${ticket.id}?cityId=${azaz}`)).json();
    expect(page).toMatchObject({ source: 'captain_problem', party: 'captain', urgent: true });

    const lines = await problem(captain.headers, order.id, { paidLines: TRY('24000') });
    expect(lines.statusCode).toBe(400);
    expect(lines.json().error).toBe('lines_not_allowed');
    const unknown = await problem(captain.headers, order.id, { reasonCode: 'app_problem' });
    expect(unknown.statusCode).toBe(400);
    expect(unknown.json().error).toBe('unknown_reason');

    const other = await onlineCaptain();
    expect((await problem(other.headers, order.id, {})).statusCode).toBe(404);
  });

  it('answers a repeat with its ticket after the order left the captain', async () => {
    const { order, captain, ops } = await assignedOrder();
    const key = randomUUID();
    const sent = await problem(captain.headers, order.id, {}, key);
    expect(sent.statusCode).toBe(200);
    const reassigned = await ops.post(`/v1/admin/orders/${order.id}/reassign`, {
      reassignment: 'captain_request',
      captainFault: false,
      cash: null,
      reason: 'طلب الكابتن',
    });
    expect(reassigned.statusCode).toBe(200);
    const again = await problem(captain.headers, order.id, {}, key);
    expect(again.statusCode).toBe(200);
    expect(again.json().ticket.id).toBe(sent.json().ticket.id);
    // A new one is refused: the order is no longer theirs.
    expect((await problem(captain.headers, order.id, {})).statusCode).toBe(404);
  });

  it('is refused once the order ended', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const late = await problem(door.captain.headers, door.order.id, {});
    expect(late.statusCode).toBe(409);
    expect(late.json().error).toBe('order_state_changed');
    // «إبلاغ عن مشكلة» may still name it (CA §13).
    const report_ = await report(door.captain.headers, {
      typeCode: 'order_problem',
      orderId: door.order.id,
    });
    expect(report_.statusCode).toBe(200);
    expect(report_.json().ticket.replyWithinMinutes).toBe(24 * 60);
  });
});

describe('«مشكلة في مبلغ الاستلام» (CA §9.4 item 6)', () => {
  const pickupAmount = (paidLines: object | null, note: string | null = null) => ({
    reasonCode: 'pickup_amount',
    paidLines,
    note,
  });

  it('opens «خلاف على دفعة الاستلام» once, with the lines the captain handed over', async () => {
    const picked = await pickedUpOrder();
    const { headers } = picked.captain;
    const orderId = picked.order.id;

    const missing = await problem(headers, orderId, pickupAmount(null));
    expect(missing.json().error).toBe('lines_required');
    const same = await problem(headers, orderId, pickupAmount(TRY('24000')));
    expect(same.statusCode).toBe(400);
    expect(same.json().error).toBe('no_difference');

    const sent = await problem(headers, orderId, pickupAmount(TRY('25000'), 'لم يرجع الباقي'));
    expect(sent.statusCode).toBe(200);
    const { ticket } = sent.json();
    expect(ticket).toMatchObject({
      typeLabel: 'خلاف على دفعة الاستلام',
      description: 'لم يرجع الباقي',
      orderId,
      openedBy: 'me',
    });
    const dispute = await sql.query(
      'SELECT opened_by, received_lines FROM ordering.pickup_disputes WHERE order_id = $1',
      [orderId],
    );
    expect(dispute.rows).toEqual([
      { opened_by: 'captain', received_lines: [{ currency: 'TRY', amount: '25000' }] },
    ]);

    // The panel shows the dispute as the restaurant's: urgent, with the lines.
    const fin = await admin(['FIN']);
    const page = (await fin.get(`/v1/admin/tickets/${ticket.id}?cityId=${azaz}`)).json();
    expect(page).toMatchObject({
      source: 'pickup_dispute',
      party: 'captain',
      kind: 'pickup_dispute',
      urgent: true,
      openedByName: 'كابتن الوصول',
      pickupDispute: {
        openedBy: 'captain',
        recorded: [{ currency: 'TRY', amount: '24000' }],
        received: [{ currency: 'TRY', amount: '25000' }],
      },
    });

    // Once per order: neither the captain nor the restaurant again.
    const again = await problem(headers, orderId, pickupAmount(TRY('26000')));
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('pickup_already_disputed');
    const restaurant = await picked.restaurant('dispute', { receivedLines: TRY('23000') });
    expect(restaurant.statusCode).toBe(409);
    expect(restaurant.json().error).toBe('pickup_already_disputed');
    // «فتح المطعم بلاغاً…» is the restaurant's; the board offers no dispute.
    expect((await picked.captain.active()).json().order.pickup.disputedAt).toBeNull();
    expect(await picked.boardOrder()).toMatchObject({
      pickup: { disputeUntil: null, disputedAt: null },
    });

    // «تصحيح في الحسابات»: the desk reimburses the captain, the restaurant is
    // debited; the captain's «بلاغاتي» shows the resolution.
    const resolved = await fin.post(`/v1/admin/tickets/${ticket.id}/resolve`, {
      cityId: azaz,
      resolution: 'accounts_corrected',
      responsible: 'restaurant',
      message: 'يعيد المطعم 10 ₺ في التسوية',
      receivedLines: TRY('25000'),
    });
    expect(resolved.statusCode).toBe(200);
    expect(await mine(headers)).toEqual([
      expect.objectContaining({
        id: ticket.id,
        status: 'resolved',
        message: 'يعيد المطعم 10 ₺ في التسوية',
      }),
    ]);
  });

  it('is refused before the pickup and once the order ended', async () => {
    const { order, captain } = await assignedOrder();
    const early = await problem(captain.headers, order.id, pickupAmount(TRY('25000')));
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');

    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const late = await problem(door.captain.headers, door.order.id, pickupAmount(TRY('25000')));
    expect(late.statusCode).toBe(409);
    expect(late.json().error).toBe('order_state_changed');
  });

  it("takes only the order's currencies", async () => {
    const picked = await pickedUpOrder();
    const refused = await problem(
      picked.captain.headers,
      picked.order.id,
      pickupAmount([{ currency: 'EUR', amount: '1000' }]),
    );
    expect(refused.statusCode).toBe(400);
    expect(refused.json().error).toBe('invalid_lines');
    // The app stops offering it once the captain reported it.
    expect(
      (await problem(picked.captain.headers, picked.order.id, pickupAmount(TRY('25000'))))
        .statusCode,
    ).toBe(200);
    const pickup = (await picked.captain.active()).json().order.pickup;
    expect(pickup.disputedAt).toBeNull();
    expect(pickup.reportedAt).not.toBeNull();
  });

  it('is refused once the restaurant disputed the pickup', async () => {
    const picked = await pickedUpOrder();
    expect((await picked.restaurant('dispute', { receivedLines: TRY('23000') })).statusCode).toBe(
      200,
    );
    const refused = await problem(picked.captain.headers, picked.order.id, {
      reasonCode: 'pickup_amount',
      paidLines: TRY('25000'),
    });
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('pickup_already_disputed');
  });
});

describe('«بلاغاتي» (CA §13)', () => {
  it("shows a captain their own tickets, the panel's included, and no one else's", async () => {
    const { order, captain, ops } = await assignedOrder();
    const own = (await report(captain.headers, { note: 'سؤال' })).json().ticket;
    const opened = await ops.post(`/v1/admin/orders/${order.id}/tickets`, {
      party: 'captain',
      typeCode: 'custody_or_earnings',
      description: 'اتصل الكابتن',
    });
    expect(opened.statusCode).toBe(200);

    const listed = await mine(captain.headers);
    expect(listed.map((each) => [each.id, each.openedBy])).toEqual([
      [opened.json().id, 'operations'],
      [own.id, 'me'],
    ]);
    expect(await mine((await onlineCaptain()).headers)).toEqual([]);
  });
});
