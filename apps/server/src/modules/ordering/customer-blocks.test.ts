import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import pg from 'pg';
import { describe, expect, it } from 'vitest';
import {
  admin,
  app,
  appSignIn,
  azaz,
  database,
  duesOf,
  home,
  phoneNumber,
  place,
  quoteFor,
  sql,
} from './order-edits.fixture.js';

// AP §9.8 «حظر» and «فك الحظر», AP §8.8, CU §5.5 (slice 2.25a; owner
// decision 2026-11-17): the owner blocks a customer, who sees the banner and
// cannot order; a block «حتى دفع مستحق» charges the dues it waits for.

async function customer() {
  const phone = phoneNumber();
  const headers = await appSignIn('customer', phone);
  const id = JSON.parse(Buffer.from(headers.authorization.split('.')[1]!, 'base64url').toString())
    .sub as string;
  await app.inject({
    method: 'PUT',
    url: '/v1/customer/profile',
    headers,
    payload: {
      firstName: 'سامر',
      lastName: 'الحلبي',
      gender: 'male',
      birthday: null,
      acceptTerms: true,
    },
  });
  return { id, phone, headers };
}

async function panel(roles: string[]) {
  const user = await admin(roles);
  const { cookies } = user;
  return {
    ...user,
    search: (q: string) =>
      app.inject({
        method: 'POST',
        url: '/v1/admin/customers/search',
        cookies,
        payload: { cityId: azaz, q },
      }),
    profile: (customerId: string) =>
      app.inject({
        method: 'GET',
        url: `/v1/admin/customers/${customerId}?cityId=${azaz}`,
        cookies,
      }),
    block: (customerId: string, body: object, key: string = randomUUID()) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/customers/${customerId}/block`,
        cookies,
        headers: { 'idempotency-key': key },
        payload: {
          cityId: azaz,
          until: null,
          amount: null,
          reason: 'abuse',
          note: 'أساء للكابتن',
          ...body,
        },
      }),
    unblock: (customerId: string, blockId: string) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/customers/${customerId}/unblock`,
        cookies,
        payload: { cityId: azaz, blockId, note: 'راجعنا الحساب' },
      }),
  };
}

const state = (headers: Record<string, string>) =>
  app.inject({
    method: 'GET',
    url: `/v1/customer/account-state?latitude=${home.latitude}&longitude=${home.longitude}`,
    headers,
  });

const problems = async (headers: Record<string, string>) =>
  (await quoteFor(headers)).json().problems as { code: string; message: string; until: string }[];

describe('«حظر» and «فك الحظر» (AP §9.8, CU §5.5)', () => {
  it('blocks until further notice: the banner shows, the quote and the order are refused, and «فك الحظر» lifts it', async () => {
    const buyer = await customer();
    const ops = await panel(['OPS']);
    const blocked = await ops.block(buyer.id, { kind: 'indefinite' });
    expect(blocked.statusCode).toBe(201);
    expect(blocked.json()).toMatchObject({
      status: 'blocked',
      block: { kind: 'indefinite', until: null, reason: 'abuse', reasonLabel: 'إساءة' },
    });
    expect((await state(buyer.headers)).json()).toMatchObject({
      reviewStop: false,
      block: { until: null, reason: 'مخالفة شروط الاستخدام' },
      dues: null,
      office: null,
    });
    expect(await problems(buyer.headers)).toContainEqual(
      expect.objectContaining({ code: 'account_blocked', message: 'مخالفة شروط الاستخدام' }),
    );
    const order = await place(buyer.headers);
    expect(order.statusCode).toBe(409);
    expect(order.json().error).toBe('order_blocked');

    const again = await ops.block(buyer.id, { kind: 'indefinite' });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('already_blocked');

    const blockId = blocked.json().block.id as string;
    expect((await ops.unblock(buyer.id, randomUUID())).json().error).toBe('not_blocked');
    const lifted = await ops.unblock(buyer.id, blockId);
    expect(lifted.statusCode).toBe(200);
    expect(lifted.json().status).toBe('active');
    expect(lifted.json().blocks[0]).toMatchObject({ inForce: false, endNote: 'راجعنا الحساب' });
    expect((await problems(buyer.headers)).map((problem) => problem.code)).not.toContain(
      'account_blocked',
    );
    expect((await ops.unblock(buyer.id, blockId)).json().error).toBe('not_blocked');
    expect((await place(buyer.headers)).statusCode).toBe(201);
  });

  it('blocks for a duration, which ends by itself at its time', async () => {
    const buyer = await customer();
    const ops = await panel(['OWN']);
    const past = await ops.block(buyer.id, {
      kind: 'until',
      until: new Date(Date.now() - 60_000).toISOString(),
    });
    expect(past.statusCode).toBe(400);
    expect(past.json().error).toBe('invalid_block');
    const missing = await ops.block(buyer.id, { kind: 'until' });
    expect(missing.json().error).toBe('invalid_block');
    const reason = await ops.block(buyer.id, { kind: 'indefinite', reason: 'nonsense' });
    expect(reason.json().error).toBe('unknown_reason');

    const until = new Date(Date.now() + 3 * 24 * 60 * 60 * 1000);
    expect(
      (await ops.block(buyer.id, { kind: 'until', until: until.toISOString() })).statusCode,
    ).toBe(201);
    expect((await state(buyer.headers)).json().block.until).toBe(until.toISOString());
    expect(await problems(buyer.headers)).toContainEqual(
      expect.objectContaining({ code: 'account_blocked', until: until.toISOString() }),
    );
    // The time passes: the block no longer stops ordering, and the next one
    // closes it at its end.
    const migrator = new pg.Pool({ connectionString: database.migratorUrl });
    await migrator.query(
      "UPDATE customers.blocks SET until = now() - interval '1 minute' WHERE customer_account_id = $1",
      [buyer.id],
    );
    await migrator.end();
    expect((await state(buyer.headers)).json().block).toBeNull();
    expect((await ops.block(buyer.id, { kind: 'indefinite' })).statusCode).toBe(201);
    const { rows } = await sql.query(
      'SELECT kind, ended_at IS NOT NULL AS ended, ended_by FROM customers.blocks WHERE customer_account_id = $1 ORDER BY started_at',
      [buyer.id],
    );
    expect(rows).toEqual([
      { kind: 'until', ended: true, ended_by: null },
      { kind: 'indefinite', ended: false, ended_by: null },
    ]);
  });

  it('blocks until dues of a set amount are paid: a dues.charge of the amount, once per key', async () => {
    const buyer = await customer();
    const own = await panel(['OWN']);
    const key = randomUUID();
    const first = await own.block(
      buyer.id,
      { kind: 'dues', amount: '5000', reason: 'fake_order' },
      key,
    );
    expect(first.statusCode).toBe(201);
    expect(first.json()).toMatchObject({
      status: 'dues_unpaid',
      block: null,
      dues: { amount: '5000', currency: 'TRY' },
      blocks: [{ kind: 'dues', duesAmount: '5000', duesCurrency: 'TRY', inForce: false }],
    });
    // The same request again charges nothing more; another with its key is refused.
    expect(
      (await own.block(buyer.id, { kind: 'dues', amount: '5000', reason: 'fake_order' }, key))
        .statusCode,
    ).toBe(201);
    expect(await duesOf(buyer.id)).toBe(5000n);
    const reused = await own.block(
      buyer.id,
      { kind: 'dues', amount: '6000', reason: 'fake_order' },
      key,
    );
    expect(reused.statusCode).toBe(422);
    expect((await own.block(buyer.id, { kind: 'dues', amount: '0' })).json().error).toBe(
      'invalid_block',
    );

    expect((await state(buyer.headers)).json()).toMatchObject({
      block: null,
      dues: { amount: '5000', currency: 'TRY' },
    });
    expect(await problems(buyer.headers)).toContainEqual(
      expect.objectContaining({ code: 'dues_unpaid' }),
    );
    // «فك الحظر» lifts no dues: they are paid at the desk.
    expect((await own.unblock(buyer.id, randomUUID())).json().error).toBe('not_blocked');
  });
});

describe('the customer search and profile (AP §9.8)', () => {
  it('finds a customer by the number or the name, with a masked phone', async () => {
    const buyer = await customer();
    const sup = await panel(['SUP']);
    const local = `0${buyer.phone.slice(4)}`;
    const byPhone = await sup.search(local);
    expect(byPhone.statusCode).toBe(200);
    expect(byPhone.json().customers).toEqual([
      {
        id: buyer.id,
        name: 'سامر الحلبي',
        maskedPhone: `+963 ••• ${buyer.phone.slice(-3)}`,
        status: 'active',
      },
    ]);
    expect(
      (await sup.search('سامر الحل')).json().customers.map((each: { id: string }) => each.id),
    ).toContain(buyer.id);
    const profile = await sup.profile(buyer.id);
    expect(profile.json()).toMatchObject({
      firstName: 'سامر',
      gender: 'male',
      status: 'active',
      trusted: false,
      delivered: 0,
      trustedAfter: 3,
      lateCancels: { inWindow: 0, total: 0, limit: 2, windowDays: 30 },
      fakeOrders: 0,
      dues: { amount: '0', currency: 'TRY' },
      blocks: [],
    });
    expect(JSON.stringify(profile.json())).not.toContain(buyer.phone);
    expect((await sup.profile(randomUUID())).statusCode).toBe(404);
    const elsewhere = await app.inject({
      method: 'GET',
      url: `/v1/admin/customers/${buyer.id}?cityId=${randomUUID()}`,
      cookies: sup.cookies,
    });
    expect(elsewhere.json().error).toBe('unknown_city');
  });

  it('lets OWN and OPS block, never SUP or FIN', async () => {
    const buyer = await customer();
    for (const role of ['SUP', 'FIN']) {
      expect((await (await panel([role])).block(buyer.id, { kind: 'indefinite' })).statusCode).toBe(
        403,
      );
    }
  });
});
