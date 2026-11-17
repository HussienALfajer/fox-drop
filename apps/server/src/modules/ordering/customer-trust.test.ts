import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { CustomersService } from '../customers/index.js';
import {
  admin,
  app,
  appSignIn,
  azaz,
  db,
  phoneNumber,
  place,
  quoteFor,
} from './order-edits.fixture.js';

// AP §9.8 «توثيق», «إزالة الثقة», «مسح المخالفات» and «إنهاء الإيقاف»,
// D23, docs/domain/08 (slice 2.25b; owner decisions 2026-11-17).

async function customer() {
  const headers = await appSignIn('customer', phoneNumber());
  const id = JSON.parse(Buffer.from(headers.authorization.split('.')[1]!, 'base64url').toString())
    .sub as string;
  return { id, headers };
}

async function panel(roles: string[]) {
  const { cookies } = await admin(roles);
  const post = (customerId: string, action: string, body: object) =>
    app.inject({
      method: 'POST',
      url: `/v1/admin/customers/${customerId}/${action}`,
      cookies,
      payload: { cityId: azaz, note: 'بعد مراجعة الدعم', ...body },
    });
  return {
    profile: async (customerId: string) =>
      (
        await app.inject({
          method: 'GET',
          url: `/v1/admin/customers/${customerId}?cityId=${azaz}`,
          cookies,
        })
      ).json(),
    trust: (customerId: string, trusted: boolean) => post(customerId, 'trust', { trusted }),
    clear: (customerId: string) => post(customerId, 'clear-strikes', {}),
    endStop: (customerId: string, stopId: string) =>
      post(customerId, 'end-review-stop', { stopId }),
  };
}

const problems = async (headers: Record<string, string>) =>
  ((await quoteFor(headers)).json().problems as { code: string }[]).map((problem) => problem.code);

// A late cancellation as operations' cancellation records it, at `at`.
async function strike(accountId: string, at = new Date()) {
  return db.db.transaction((tx) =>
    app.get(CustomersService).recordLateCancel(tx, {
      accountId,
      orderId: randomUUID(),
      cityId: azaz,
      at,
      strikes: 2,
      windowDays: 30,
    }),
  );
}

describe('«توثيق» and «إزالة الثقة» (AP §9.8, D23)', () => {
  it('trusts a new account at once, and removing the trust brings the new limit back', async () => {
    const buyer = await customer();
    const ops = await panel(['OPS']);
    expect((await place(buyer.headers)).statusCode).toBe(201);
    expect(await problems(buyer.headers)).toContain('one_order_at_a_time');

    const marked = await ops.trust(buyer.id, true);
    expect(marked.statusCode).toBe(200);
    expect(marked.json()).toMatchObject({
      trusted: true,
      delivered: 0,
      trustMark: { trusted: true, note: 'بعد مراجعة الدعم' },
    });
    expect(await problems(buyer.headers)).not.toContain('one_order_at_a_time');
    expect((await place(buyer.headers)).statusCode).toBe(201);

    const removed = await ops.trust(buyer.id, false);
    expect(removed.json()).toMatchObject({ trusted: false, trustMark: { trusted: false } });
    expect(await problems(buyer.headers)).toContain('one_order_at_a_time');
  });

  it('is refused to support (OWN and OPS only)', async () => {
    const buyer = await customer();
    expect((await (await panel(['SUP'])).trust(buyer.id, true)).statusCode).toBe(403);
  });
});

describe('«مسح المخالفات» and «إنهاء الإيقاف» (AP §9.8, docs/domain/08)', () => {
  it('ends a review stop and keeps the strikes, so the next late cancellation stops again', async () => {
    const buyer = await customer();
    const sup = await panel(['SUP']);
    await strike(buyer.id);
    expect((await strike(buyer.id)).reviewStopped).toBe(true);
    const stopped = await sup.profile(buyer.id);
    expect(stopped).toMatchObject({ status: 'review_stop', lateCancels: { inWindow: 2 } });
    expect(await problems(buyer.headers)).toContain('review_stop');

    expect((await sup.endStop(buyer.id, randomUUID())).json().error).toBe('not_stopped');
    const ended = await sup.endStop(buyer.id, stopped.reviewStop.id);
    expect(ended.statusCode).toBe(200);
    expect(ended.json()).toMatchObject({
      status: 'active',
      reviewStop: null,
      lateCancels: { inWindow: 2, cleared: null },
    });
    expect(await problems(buyer.headers)).not.toContain('review_stop');
    expect((await sup.endStop(buyer.id, stopped.reviewStop.id)).json().error).toBe('not_stopped');

    expect((await strike(buyer.id)).reviewStopped).toBe(true);
    expect(await problems(buyer.headers)).toContain('review_stop');
  });

  it('restarts the count from the clear, ends the stop with it and deletes nothing', async () => {
    const buyer = await customer();
    const sup = await panel(['SUP']);
    expect((await sup.clear(buyer.id)).json().error).toBe('nothing_to_clear');
    await strike(buyer.id, new Date(Date.now() - 60_000));
    await strike(buyer.id, new Date(Date.now() - 30_000));
    const cleared = await sup.clear(buyer.id);
    expect(cleared.statusCode).toBe(200);
    expect(cleared.json()).toMatchObject({
      status: 'active',
      reviewStop: null,
      lateCancels: { inWindow: 0, total: 2, cleared: { note: 'بعد مراجعة الدعم' } },
    });
    expect(await problems(buyer.headers)).not.toContain('review_stop');
    expect((await sup.clear(buyer.id)).json().error).toBe('nothing_to_clear');

    expect((await strike(buyer.id)).reviewStopped).toBe(false);
    expect((await sup.profile(buyer.id)).lateCancels).toMatchObject({ inWindow: 1, total: 3 });
  });

  it('is refused to finance', async () => {
    const buyer = await customer();
    expect((await (await panel(['FIN'])).clear(buyer.id)).statusCode).toBe(403);
  });
});
