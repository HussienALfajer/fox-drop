import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { DATABASE } from '../../database/database.module.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { CaptainsService } from '../captains/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { AlertsService } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { TicketSync } from '../support/index.js';
import { admin, app, azaz, db, placedOrder, sql } from './order-edits.fixture.js';
import { OrderAlerts } from './order-alerts.js';

// AP §9.3.1–9.3.2, §9.9.2, §9.1.3 (slice 2.23a): «فتح تذكرة» on a real order,
// the party taken from it under its lock, «تذكرة عاجلة» while it is active,
// and its closing once the order ends through the order's alerts sync.

let staff = 0;
async function supportUser(roles: string[]) {
  staff += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Support ${staff}`, `order-tickets${staff}@example.test`],
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
  return {
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    post: (url: string, payload: object, key: string = randomUUID()) =>
      app.inject({ method: 'POST', url, cookies, headers: { 'idempotency-key': key }, payload }),
    put: (url: string, payload: object) => app.inject({ method: 'PUT', url, cookies, payload }),
  };
}

const syncAlerts = async (orderId: string) => {
  const { rows } = await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [
    orderId,
  ]);
  await new OrderAlerts(
    app.get(DATABASE),
    app.get(Jobs),
    app.get(AlertsService),
    app.get(CaptainsService),
    app.get(SettingsService),
    app.get(TicketSync),
  ).sync({ orderId, placedAt: rows[0].placed_at.toISOString() }, new Date(), false);
};

async function urgentAlert(ticketId: string) {
  const { rows } = await sql.query(
    "SELECT resolved_at FROM notifications.alerts WHERE code = 'urgent_ticket' AND subject_id = $1",
    [ticketId],
  );
  return rows[0] ?? null;
}

describe('«فتح تذكرة» on an order', () => {
  it("names the order's customer, is urgent while the order is active and closes with it", async () => {
    const sup = await supportUser(['SUP']);
    const order = await placedOrder();
    const body = { party: 'customer', typeCode: 'missing_item', description: 'اتصل الزبون' };
    const key = randomUUID();
    const opened = await sup.post(`/v1/admin/orders/${order.id}/tickets`, body, key);
    expect(opened.statusCode).toBe(200);
    const ticket = opened.json();
    const [{ customer_account_id: customerId, number }] = (
      await sql.query('SELECT customer_account_id, number FROM ordering.orders WHERE id = $1', [
        order.id,
      ])
    ).rows;
    expect(ticket).toMatchObject({
      party: 'customer',
      partyId: customerId,
      orderId: order.id,
      orderNumber: String(number),
      urgent: true,
      sla: { kind: 'first_response' },
    });
    // A repeat answers the ticket; the key with another body is refused.
    expect((await sup.post(`/v1/admin/orders/${order.id}/tickets`, body, key)).json().id).toBe(
      ticket.id,
    );
    const reused = await sup.post(
      `/v1/admin/orders/${order.id}/tickets`,
      { ...body, description: 'آخر' },
      key,
    );
    expect(reused.statusCode).toBe(422);
    expect(await urgentAlert(ticket.id)).toEqual({ resolved_at: null });
    // The board's card says «لها تذكرة».
    const ops = await admin(['OPS']);
    const boardRead = await supportUser(['OPS']);
    const card = (await boardRead.get(`/v1/admin/orders?cityId=${azaz}`))
      .json()
      .orders.find((each: { id: string }) => each.id === order.id);
    expect(card.badges.ticket).toBe(true);
    // The order ends: its alerts sync closes «تذكرة عاجلة».
    const cancelled = await ops.cancel(order.id, {
      cancellation: 'customer_request',
      responsible: 'customer',
      foodPrepared: false,
      compensateCaptain: false,
      cash: null,
      reason: 'ملاحظة',
    });
    expect(cancelled.statusCode).toBe(200);
    await syncAlerts(order.id);
    expect((await urgentAlert(ticket.id))?.resolved_at).not.toBeNull();
    const read = await sup.get(`/v1/admin/tickets/${ticket.id}?cityId=${azaz}`);
    expect(read.json().urgent).toBe(false);
  });

  it("refuses a captain's ticket on an order without a captain", async () => {
    const sup = await supportUser(['SUP']);
    const order = await placedOrder();
    const refused = await sup.post(`/v1/admin/orders/${order.id}/tickets`, {
      party: 'captain',
      typeCode: 'order_problem',
      description: 'x',
    });
    expect(refused.json()).toMatchObject({ statusCode: 409, error: 'no_captain' });
  });

  it("opens a list ticket for a customer without a profile, and hides it from another city's reads", async () => {
    const sup = await supportUser(['SUP']);
    const order = await placedOrder();
    const [{ customer_account_id: customerId }] = (
      await sql.query('SELECT customer_account_id FROM ordering.orders WHERE id = $1', [order.id])
    ).rows;
    const opened = await sup.post('/v1/admin/tickets', {
      cityId: azaz,
      party: 'customer',
      partyId: customerId,
      typeCode: 'missing_item',
      description: 'اتصل قبل إكمال بياناته',
    });
    expect(opened.statusCode).toBe(200);
    const id = opened.json().id;
    const other = randomUUID();
    expect((await sup.get(`/v1/admin/tickets/${id}?cityId=${other}`)).statusCode).toBe(404);
    const note = await sup.post(`/v1/admin/tickets/${id}/notes`, { cityId: other, body: 'x' });
    expect(note.statusCode).toBe(404);
    const status = await sup.put(`/v1/admin/tickets/${id}/status`, {
      cityId: other,
      status: 'waiting',
    });
    expect(status.statusCode).toBe(404);
    const list = (await sup.get(`/v1/admin/tickets?cityId=${other}`)).json().tickets;
    expect(list).toEqual([]);
  });
});
