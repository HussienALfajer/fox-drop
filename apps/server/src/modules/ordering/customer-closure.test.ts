import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { CODE_SENDER, type DevelopmentCodeSender } from '../identity/index.js';
import {
  admin,
  app,
  appSignIn,
  azaz,
  duesOf,
  home,
  phoneNumber,
  place,
  quoteFor,
  sql,
} from './order-edits.fixture.js';

// D19, AP §8.8, AP §9.8 «إغلاق الحساب», CU §5.5 «مغلق», CU §5.6 «حذف
// الحساب» (slice 2.25c; owner decisions 2026-11-17): the account closes with
// a fresh code or from the panel, never with an active order; every session
// ends and the data stays; the same number registers again as a new account
// that continues the closed one: its block, dues, strikes and trust.

const sub = (headers: Record<string, string>) =>
  JSON.parse(Buffer.from(headers.authorization!.split('.')[1]!, 'base64url').toString())
    .sub as string;

async function customer(phone = phoneNumber()) {
  const headers = await appSignIn('customer', phone);
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
  return { id: sub(headers), phone, headers };
}

// The sign-in's code is past its resend wait (otp.resend_after_sec), so the
// closure's code can be asked for at once.
async function pastResendWait() {
  await sql.query(
    "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '2 minutes' WHERE party = 'customer' AND created_at > now() - interval '5 minutes'",
  );
}

const closeCode = (headers: Record<string, string>) =>
  app.inject({ method: 'POST', url: '/v1/customer/account/close-code', headers });

const closeWith = (headers: Record<string, string>, code: string) =>
  app.inject({ method: 'POST', url: '/v1/customer/account/close', headers, payload: { code } });

async function panel(roles: string[]) {
  const { cookies } = await admin(roles);
  return {
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
    command: (customerId: string, action: string, body: object, key?: string) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/customers/${customerId}/${action}`,
        cookies,
        ...(key ? { headers: { 'idempotency-key': key } } : {}),
        payload: { cityId: azaz, ...body },
      }),
  };
}

const problemCodes = async (headers: Record<string, string>) =>
  ((await quoteFor(headers)).json().problems as { code: string }[]).map((problem) => problem.code);

const profileStatus = async (headers: Record<string, string>) =>
  (await app.inject({ method: 'GET', url: '/v1/customer/profile', headers })).statusCode;

describe('«حذف الحساب» in the app (CU §5.6)', () => {
  it('a customer with dues deletes the account, registers again and is still blocked', async () => {
    const buyer = await customer();
    const own = await panel(['OWN']);
    expect(
      (
        await own.command(
          buyer.id,
          'block',
          { kind: 'dues', amount: '5000', until: null, reason: 'fake_order', note: 'طلب وهمي' },
          randomUUID(),
        )
      ).statusCode,
    ).toBe(201);

    // A wrong code is refused and counted; the right one closes the account.
    await pastResendWait();
    expect((await closeCode(buyer.headers)).statusCode).toBe(200);
    const wrong = await closeWith(buyer.headers, '000000');
    expect(wrong.statusCode).toBe(400);
    expect(['wrong_code', 'code_expired']).toContain(wrong.json().error);
    const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(buyer.phone)!;
    const closed = await closeWith(buyer.headers, code);
    expect(closed.statusCode).toBe(200);
    expect(closed.json()).toEqual({ status: 'closed' });
    // Signed out on every device.
    expect(await profileStatus(buyer.headers)).toBe(401);
    const { rows: sessions } = await sql.query(
      'SELECT count(*)::int AS open FROM identity.app_sessions WHERE account_id = $1 AND ended_at IS NULL',
      [buyer.id],
    );
    expect(sessions[0].open).toBe(0);

    // The same number again: a new account, linked, its dues moved over.
    await pastResendWait();
    const again = await appSignIn('customer', buyer.phone);
    const newId = sub(again);
    expect(newId).not.toBe(buyer.id);
    expect(await duesOf(newId)).toBe(5000n);
    expect(await duesOf(buyer.id)).toBe(0n);
    expect(await problemCodes(again)).toContain('dues_unpaid');
    const state = await app.inject({
      method: 'GET',
      url: `/v1/customer/account-state?latitude=${home.latitude}&longitude=${home.longitude}`,
      headers: again,
    });
    expect(state.json().dues).toEqual({ amount: '5000', currency: 'TRY' });

    // The panel: two rows for the number, the closed one «مغلق».
    const found = (await own.search(buyer.phone)).json().customers as {
      id: string;
      status: string;
    }[];
    expect(found).toEqual([
      expect.objectContaining({ id: newId, status: 'dues_unpaid' }),
      expect.objectContaining({ id: buyer.id, status: 'closed' }),
    ]);
    const old = (await own.profile(buyer.id)).json();
    expect(old.status).toBe('closed');
    expect(old.closed).toMatchObject({ byName: null, reason: null });
    expect(old.linkedAccounts).toEqual([
      expect.objectContaining({ id: newId, status: 'active', closedAt: null }),
    ]);
    const current = (await own.profile(newId)).json();
    expect(current.linkedAccounts).toEqual([
      expect.objectContaining({ id: buyer.id, status: 'closed' }),
    ]);
    expect(current.blocks).toEqual([expect.objectContaining({ kind: 'dues' })]);
  });

  it('is refused with an active order, before any code is sent', async () => {
    const buyer = await customer();
    expect((await place(buyer.headers)).statusCode).toBe(201);
    await pastResendWait();
    const asked = await closeCode(buyer.headers);
    expect(asked.statusCode).toBe(409);
    expect(asked.json().error).toBe('active_order');
    const closed = await closeWith(buyer.headers, '123456');
    expect(closed.statusCode).toBe(409);
    expect(closed.json().error).toBe('active_order');
    const ops = await panel(['OPS']);
    const byPanel = await ops.command(buyer.id, 'close', { note: 'طلب الزبون' });
    expect(byPanel.statusCode).toBe(409);
    expect(byPanel.json().error).toBe('active_order');
    expect(await profileStatus(buyer.headers)).toBe(200);
  });
});

describe('«إغلاق الحساب» in the panel (AP §9.8)', () => {
  it('closes on request; the block, the strikes and the trust carry over to the new account', async () => {
    const buyer = await customer();
    const ops = await panel(['OPS']);
    const blocked = await ops.command(
      buyer.id,
      'block',
      { kind: 'indefinite', until: null, amount: null, reason: 'abuse', note: 'أساء للكابتن' },
      randomUUID(),
    );
    expect(blocked.statusCode).toBe(201);
    expect(
      (await ops.command(buyer.id, 'trust', { trusted: true, note: 'زبون معروف' })).statusCode,
    ).toBe(200);

    expect(
      (await (await panel(['FIN'])).command(buyer.id, 'close', { note: 'x' })).statusCode,
    ).toBe(403);
    const sup = await panel(['SUP']);
    const closed = await sup.command(buyer.id, 'close', { note: 'طلب الزبون بالهاتف' });
    expect(closed.statusCode).toBe(200);
    expect(closed.json()).toMatchObject({
      status: 'closed',
      closed: { reason: 'طلب الزبون بالهاتف' },
      linkedAccounts: [],
    });
    expect(closed.json().closed.byName).not.toBeNull();
    expect(await profileStatus(buyer.headers)).toBe(401);
    const again = await sup.command(buyer.id, 'close', { note: 'مرة ثانية' });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('account_closed');
    expect(
      (await ops.command(buyer.id, 'change-phone', { phone: phoneNumber(), note: 'x' })).json()
        .error,
    ).toBe('account_closed');

    await pastResendWait();
    const back = await appSignIn('customer', buyer.phone);
    const newId = sub(back);
    expect(await problemCodes(back)).toContain('account_blocked');
    const profile = (await ops.profile(newId)).json();
    expect(profile).toMatchObject({
      status: 'blocked',
      block: { id: blocked.json().block.id },
      trusted: true,
      trustMark: { trusted: true },
    });
    // «فك الحظر» from the new account's profile lifts the closed one's block.
    const lifted = await ops.command(newId, 'unblock', {
      blockId: blocked.json().block.id,
      note: 'راجعنا الحساب',
    });
    expect(lifted.statusCode).toBe(200);
    expect(lifted.json().status).toBe('active');
    expect(await problemCodes(back)).not.toContain('account_blocked');
  });
});

describe('the line after re-registration (AP §8.8)', () => {
  it('counts dues posted on the closed account later, a review stop, and a third account', async () => {
    const buyer = await customer();
    const own = await panel(['OWN']);
    // A review stop on the first account (docs/domain/08).
    await sql.query(
      'INSERT INTO customers.review_stops (customer_account_id, started_at, order_id) VALUES ($1, now(), gen_random_uuid())',
      [buyer.id],
    );
    expect(await problemCodes(buyer.headers)).toContain('review_stop');
    expect((await own.command(buyer.id, 'close', { note: 'طلب الزبون' })).statusCode).toBe(200);

    await pastResendWait();
    const second = await appSignIn('customer', buyer.phone);
    const secondId = sub(second);
    expect(await problemCodes(second)).toContain('review_stop');
    expect(await problemCodes(second)).not.toContain('dues_unpaid');

    // Dues charged on the closed account after the move still stop the new one.
    expect(
      (
        await own.command(
          buyer.id,
          'block',
          { kind: 'dues', amount: '3000', until: null, reason: 'fake_order', note: 'طلب وهمي' },
          randomUUID(),
        )
      ).statusCode,
    ).toBe(201);
    expect(await duesOf(buyer.id)).toBe(3000n);
    expect(await problemCodes(second)).toContain('dues_unpaid');
    const profile = (await own.profile(secondId)).json();
    expect(profile.dues).toEqual({ amount: '3000', currency: 'TRY' });

    // Closed again: the third account continues the same line.
    expect((await own.command(secondId, 'close', { note: 'طلب الزبون' })).statusCode).toBe(200);
    await pastResendWait();
    const third = await appSignIn('customer', buyer.phone);
    const thirdId = sub(third);
    expect(await problemCodes(third)).toEqual(
      expect.arrayContaining(['review_stop', 'dues_unpaid']),
    );
    const linked = (await own.profile(thirdId)).json().linkedAccounts as { id: string }[];
    expect(linked.map((account) => account.id).toSorted()).toEqual([buyer.id, secondId].toSorted());
    expect(
      ((await own.search(buyer.phone)).json().customers as { id: string; status: string }[]).map(
        (row) => row.status,
      ),
    ).toEqual(['dues_unpaid', 'closed', 'closed']);
  });
});
