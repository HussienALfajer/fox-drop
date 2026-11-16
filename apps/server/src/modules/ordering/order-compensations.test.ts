import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { app, db, placedOrder, sql } from './order-edits.fixture.js';

// AP §9.3.2 «تعويض الزبون», §6.4 (slice 2.22a) through the order's routes:
// the read with what the cap leaves, a code issued within it, a request above
// it, and the refusals the panel explains.
async function session(roles: string[]) {
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Support ${roles.join('')}`, `${randomUUID()}@example.test`],
  );
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [rows[0].id, role],
    );
  }
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return {
    read: (orderId: string) =>
      app.inject({ method: 'GET', url: `/v1/admin/orders/${orderId}/compensations`, cookies }),
    give: (orderId: string, payload: object, key: string = randomUUID()) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${orderId}/compensations`,
        cookies,
        headers: { 'idempotency-key': key },
        payload,
      }),
    reject: (id: string, cityId: string) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/compensations/${id}/reject`,
        cookies,
        payload: { cityId },
      }),
  };
}

const amount = (minor: string) => ({
  kind: 'fixed_amount',
  amount: minor,
  percentBp: null,
  maxDiscount: null,
});
const late = { code: 'late', note: null };

describe('«تعويض الزبون» on an order', () => {
  it('reads what the cap leaves, issues within it and asks OWN above it', async () => {
    const order = await placedOrder();
    const [row] = (
      await sql.query('SELECT total, city_id FROM ordering.orders WHERE id = $1', [order.id])
    ).rows;
    const cap = (BigInt(row.total) * 30n) / 100n;
    const sup = await session(['SUP']);

    const before = await sup.read(order.id);
    expect(before.statusCode).toBe(200);
    expect(before.json()).toMatchObject({
      compensations: [],
      currency: 'TRY',
      capLeft: cap.toString(),
      canCompensate: true,
    });
    expect(before.json().reasons).toContainEqual({ code: 'late', label: 'تأخير' });

    const issued = await sup.give(order.id, { value: amount('100'), reason: late });
    expect(issued.statusCode).toBe(200);
    expect(issued.json()).toMatchObject({
      status: 'issued',
      amount: '100',
      reason: { code: 'late', label: 'تأخير' },
      requestedBy: 'Support SUP',
    });
    expect(issued.json().code).toMatch(/^[A-Z2-9]{8}$/);
    expect((await sup.read(order.id)).json().capLeft).toBe((cap - 100n).toString());

    const asked = await sup.give(order.id, { value: amount(cap.toString()), reason: late });
    expect(asked.json()).toMatchObject({ status: 'waiting', code: null });

    const own = await session(['OWN']);
    expect((await own.read(order.id)).json().capLeft).toBeNull();
    const rejected = await own.reject(asked.json().id, row.city_id);
    expect(rejected.statusCode).toBe(200);
    expect(rejected.json()).toMatchObject({ status: 'rejected', decidedBy: 'Support OWN' });
  });

  it('refuses a value whose fields do not fit its kind, an unknown reason and a reused key', async () => {
    const order = await placedOrder();
    const sup = await session(['SUP']);
    const mixed = await sup.give(order.id, {
      value: { kind: 'fixed_amount', amount: '100', percentBp: 1000, maxDiscount: null },
      reason: late,
    });
    expect(mixed.statusCode).toBe(400);
    expect(mixed.json().error).toBe('invalid_value');
    const unknown = await sup.give(order.id, {
      value: amount('100'),
      reason: { code: 'nope', note: null },
    });
    expect(unknown.statusCode).toBe(400);
    expect(unknown.json().error).toBe('unknown_reason');
    const key = randomUUID();
    expect((await sup.give(order.id, { value: amount('100'), reason: late }, key)).statusCode).toBe(
      200,
    );
    const reused = await sup.give(order.id, { value: amount('200'), reason: late }, key);
    expect(reused.statusCode).toBe(422);
    expect(reused.json().error).toBe('idempotency_key_reused');
  });

  it('lets FIN read the compensations but not give one', async () => {
    const order = await placedOrder();
    const ops = await session(['OPS']);
    expect((await ops.read(order.id)).json().canCompensate).toBe(true);
    const fin = await session(['FIN']);
    expect((await fin.give(order.id, { value: amount('100'), reason: late })).statusCode).toBe(403);
  });
});
