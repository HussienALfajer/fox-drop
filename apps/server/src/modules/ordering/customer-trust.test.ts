import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { CustomersService } from '../customers/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from '../identity/index.js';
import { SettingsService } from '../settings/index.js';
import {
  admin,
  app,
  appSignIn,
  azaz,
  bySystem,
  db,
  home,
  phoneNumber,
  pickedUpOrder,
  place,
  quoteFor,
  sql,
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
    note: (customerId: string, body: string, key: string) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/customers/${customerId}/notes`,
        cookies,
        headers: { 'idempotency-key': key },
        payload: { cityId: azaz, body },
      }),
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

describe("the profile's orders, addresses and notes (AP §9.8)", () => {
  it('shows the orders in the city, the saved addresses with any other number masked, and the notes', async () => {
    const buyer = await customer();
    const fin = await panel(['FIN']);
    const fresh = await fin.profile(buyer.id);
    expect(fresh).toMatchObject({
      orders: { count: 0, spent: [], last: null },
      tickets: [],
      codes: [],
      addresses: [],
      notes: [],
    });

    const order = await place(buyer.headers);
    expect(order.statusCode).toBe(201);
    const saved = await app.inject({
      method: 'POST',
      url: '/v1/customer/addresses',
      headers: buyer.headers,
      payload: {
        location: home,
        label: 'home',
        customLabel: null,
        street: 'شارع الجامع',
        floor: null,
        landmark: 'قرب الجامع',
        contactPhone: '+905321234567',
        recipientName: 'محمد',
        directions: null,
        isDefault: false,
      },
    });
    expect(saved.statusCode).toBe(201);

    const read = await fin.profile(buyer.id);
    expect(read.orders).toMatchObject({
      count: 1,
      spent: [],
      last: { id: order.json().order.id, status: 'placed' },
    });
    expect(read.addresses).toEqual([
      expect.objectContaining({
        street: 'شارع الجامع',
        recipientName: 'محمد',
        maskedContactPhone: '+90 ••• 567',
        isDefault: true,
      }),
    ]);
    expect(JSON.stringify(read)).not.toContain('5321234567');

    const key = randomUUID();
    const noted = await fin.note(buyer.id, 'يفضل الاتصال قبل الوصول', key);
    expect(noted.statusCode).toBe(201);
    expect(noted.json().notes).toEqual([
      expect.objectContaining({ body: 'يفضل الاتصال قبل الوصول', authorName: expect.any(String) }),
    ]);
    expect((await fin.note(buyer.id, 'يفضل الاتصال قبل الوصول', key)).json().notes).toHaveLength(1);
    expect((await fin.note(buyer.id, 'نص آخر', key)).statusCode).toBe(422);
  });
});

describe('«تغيير الرقم» and «تسجيل الخروج من كل الأجهزة» (AP §9.8, CU §5.4)', () => {
  const sub = (headers: { authorization: string }) =>
    JSON.parse(Buffer.from(headers.authorization.split('.')[1]!, 'base64url').toString())
      .sub as string;
  const profileStatus = async (headers: Record<string, string>) =>
    (await app.inject({ method: 'GET', url: '/v1/customer/profile', headers })).statusCode;
  const command = async (roles: string[], customerId: string, action: string, body: object) => {
    const { cookies } = await admin(roles);
    return app.inject({
      method: 'POST',
      url: `/v1/admin/customers/${customerId}/${action}`,
      cookies,
      payload: { cityId: azaz, note: 'طلب الزبون عبر الدعم', ...body },
    });
  };

  it('moves the account to the new number, signs every device out, and the customer signs in with it', async () => {
    const buyer = await customer();
    const other = phoneNumber();
    await appSignIn('customer', other);
    const changePhone = (phone: string, roles = ['OPS']) =>
      command(roles, buyer.id, 'change-phone', { phone });

    expect((await changePhone('abc')).json().error).toBe('invalid_phone');
    expect((await changePhone(other)).json().error).toBe('phone_taken');
    expect((await changePhone(phoneNumber(), ['SUP'])).statusCode).toBe(403);

    const fresh = phoneNumber();
    const local = `0${fresh.slice(4)}`;
    const changed = await changePhone(local);
    expect(changed.statusCode).toBe(200);
    expect(changed.json().maskedPhone).toBe(`+963 ••• ${fresh.slice(-3)}`);
    expect(await profileStatus(buyer.headers)).toBe(401);
    const again = await appSignIn('customer', fresh);
    expect(sub(again)).toBe(buyer.id);
    expect(await profileStatus(again)).toBe(200);

    expect((await changePhone(fresh)).statusCode).toBe(200);
    expect(await profileStatus(again)).toBe(200);
  });

  it("ends the old number's open code, so a sign-in racing the change finds none", async () => {
    const settings = app.get(SettingsService);
    await settings.update('otp.resend_after_sec', {}, 1, bySystem);
    const phone = phoneNumber();
    const id = sub(await appSignIn('customer', phone));
    await new Promise((resolve) => setTimeout(resolve, 1_100));
    const deviceId = randomUUID();
    const asked = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/code',
      payload: { phone, deviceId },
    });
    expect(asked.statusCode).toBe(200);
    const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
    expect((await command(['OPS'], id, 'change-phone', { phone: phoneNumber() })).statusCode).toBe(
      200,
    );
    const late = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/sign-in',
      payload: { phone, deviceId, code },
    });
    expect(late.statusCode).not.toBe(200);
    expect(late.json().error).toBe('code_expired');
    await settings.update('otp.resend_after_sec', {}, 60, bySystem);
  });

  it('signs every device out, and support may do it', async () => {
    const signedIn = await appSignIn('customer', phoneNumber());
    const id = sub(signedIn);
    expect((await command(['FIN'], id, 'sign-out-everywhere', {})).statusCode).toBe(403);
    const signedOut = await command(['SUP'], id, 'sign-out-everywhere', {});
    expect(signedOut.statusCode).toBe(200);
    expect(signedOut.json()).toEqual({ sessionsEnded: 1 });
    expect(await profileStatus(signedIn)).toBe(401);
    expect((await command(['SUP'], id, 'sign-out-everywhere', {})).json()).toEqual({
      sessionsEnded: 0,
    });
  });
});

describe('the profile’s total spent and a repeated mark (AP §9.8)', () => {
  it('counts what a normal delivery collected, and the same trust value again writes nothing', async () => {
    const buyer = await customer();
    const ops = await panel(['OPS']);
    const order = await pickedUpOrder(buyer.headers);
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    const { rows } = await sql.query('SELECT total FROM ordering.orders WHERE id = $1', [
      order.order.id,
    ]);
    const total = String(rows[0].total);
    expect((await order.deliver(total)).statusCode).toBe(200);
    expect((await ops.profile(buyer.id)).orders).toMatchObject({
      count: 1,
      spent: [{ currency: 'TRY', amount: total }],
      last: { status: 'delivered' },
    });

    const removed = (await ops.trust(buyer.id, false)).json().trustMark;
    const again = (await ops.trust(buyer.id, false)).json().trustMark;
    expect(again.at).toBe(removed.at);
  });
});
