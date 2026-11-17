import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import {
  admin,
  app,
  appSignIn,
  azaz,
  home,
  phoneNumber,
  place,
  quoteFor,
  sql,
} from './order-edits.fixture.js';

// The device block (docs/domain/08, AP §9.8, CU §5.5; slice 2.25d, owner
// decisions 2026-11-10 and 2026-11-18): a block or unpaid dues follow the
// phone, so any account signed in on it cannot order, until OWN lifts the
// device's block for a phone sold on.

const sub = (headers: Record<string, string>) =>
  JSON.parse(Buffer.from(headers.authorization!.split('.')[1]!, 'base64url').toString())
    .sub as string;

async function customer(deviceId: string, phone = phoneNumber()) {
  const headers = await signInAgain(phone, deviceId);
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

// The number's earlier code is past its resend wait, so it signs in again.
async function signInAgain(phone: string, deviceId: string) {
  await sql.query(
    "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '2 minutes' WHERE party = 'customer' AND created_at > now() - interval '5 minutes'",
  );
  return appSignIn('customer', phone, deviceId);
}

async function panel(roles: string[]) {
  const { cookies } = await admin(roles);
  return {
    profile: async (customerId: string) =>
      (
        await app.inject({
          method: 'GET',
          url: `/v1/admin/customers/${customerId}?cityId=${azaz}`,
          cookies,
        })
      ).json(),
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

const accountState = async (headers: Record<string, string>) =>
  (
    await app.inject({
      method: 'GET',
      url: `/v1/customer/account-state?latitude=${home.latitude}&longitude=${home.longitude}`,
      headers,
    })
  ).json();

async function blockIndefinitely(customerId: string) {
  const own = await panel(['OWN']);
  const answer = await own.command(
    customerId,
    'block',
    { kind: 'indefinite', until: null, amount: null, reason: 'abuse', note: 'أساء للكابتن' },
    randomUUID(),
  );
  expect(answer.statusCode).toBe(201);
}

describe('the device block (docs/domain/08)', () => {
  it('stops another number on the same phone, after a reinstall too, until OWN lifts it', async () => {
    const phone = randomUUID();
    const blocked = await customer(phone);
    await blockIndefinitely(blocked.id);

    // A reinstall keeps the device id; another number signs in on it.
    const other = await customer(phone);
    expect(other.id).not.toBe(blocked.id);
    expect(await problemCodes(other.headers)).toContain('account_blocked');
    // Never the other account's reason.
    expect((await accountState(other.headers)).block).toEqual({
      until: null,
      reason: 'هذا الهاتف مرتبط بحساب آخر محظور',
    });
    const placed = await place(other.headers);
    expect(placed.statusCode).toBe(409);
    expect(placed.json().error).toBe('order_blocked');

    const own = await panel(['OWN']);
    const profile = await own.profile(other.id);
    expect(profile.status).toBe('blocked');
    expect(profile.block).toMatchObject({ viaAccountId: blocked.id });
    expect(profile.devices).toEqual([
      expect.objectContaining({
        deviceId: phone,
        blocked: true,
        ipAddress: '127.0.0.1',
        lift: null,
        accounts: [expect.objectContaining({ id: blocked.id, status: 'blocked' })],
      }),
    ]);
    // «فك الحظر» ends the line's own blocks only.
    const unblock = await own.command(other.id, 'unblock', {
      blockId: profile.block.id,
      note: 'x',
    });
    expect(unblock.statusCode).toBe(409);
    expect(unblock.json().error).toBe('not_blocked');

    // OWN alone lifts it, with a reason.
    const lift = { deviceId: phone, note: 'بيع الهاتف لزبون آخر' };
    expect(
      (await (await panel(['OPS'])).command(other.id, 'lift-device-block', lift)).statusCode,
    ).toBe(403);
    const lifted = await own.command(other.id, 'lift-device-block', lift);
    expect(lifted.statusCode).toBe(200);
    expect(lifted.json().status).toBe('active');
    expect(lifted.json().devices).toEqual([
      expect.objectContaining({
        blocked: false,
        accounts: [],
        lift: expect.objectContaining({ note: 'بيع الهاتف لزبون آخر' }),
      }),
    ]);
    expect(await problemCodes(other.headers)).not.toContain('account_blocked');
    // Nothing is left to lift.
    const again = await own.command(other.id, 'lift-device-block', lift);
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('device_not_blocked');
    const { rows } = await sql.query(
      "SELECT reason FROM audit.events WHERE action = 'customer.lift_device_block' AND target_id = $1",
      [other.id],
    );
    expect(rows).toEqual([{ reason: 'بيع الهاتف لزبون آخر' }]);

    // The blocked customer signs in on it again: linked again.
    const relinked = await signInAgain(blocked.phone, phone);
    expect(await problemCodes(relinked)).toContain('account_blocked');
    // Its sign-in ended the other account's session on the phone (one per
    // device); signing in again there links it again.
    expect((await own.profile(other.id)).status).toBe('active');
    const otherAgain = await signInAgain(other.phone, phone);
    expect(await problemCodes(otherAgain)).toContain('account_blocked');
  });

  it('stops every account signed in on the phone, an older one too (a family phone)', async () => {
    const phone = randomUUID();
    const family = await customer(phone);
    const blocked = await customer(phone);
    await blockIndefinitely(blocked.id);
    const back = await signInAgain(family.phone, phone);
    expect(await problemCodes(back)).toContain('account_blocked');
    // The blocked account's own profile shows its device and the other account.
    const profile = await (await panel(['SUP'])).profile(blocked.id);
    expect(profile.block.viaAccountId).toBeNull();
    expect(profile.devices[0].accounts).toEqual([
      expect.objectContaining({ id: family.id, status: 'blocked' }),
    ]);
  });

  it('carries unpaid dues to the phone, and stops one step away', async () => {
    const phone = randomUUID();
    const owing = await customer(phone);
    const own = await panel(['OWN']);
    expect(
      (
        await own.command(
          owing.id,
          'block',
          { kind: 'dues', amount: '5000', until: null, reason: 'fake_order', note: 'طلب وهمي' },
          randomUUID(),
        )
      ).statusCode,
    ).toBe(201);
    const tablet = randomUUID();
    const other = await customer(phone);
    // Another account's dues show as a device block, without the amount.
    expect(await problemCodes(other.headers)).toEqual(expect.arrayContaining(['account_blocked']));
    expect(await problemCodes(other.headers)).not.toContain('dues_unpaid');
    const state = await accountState(other.headers);
    expect(state.dues).toBeNull();
    expect(state.office).toBeNull();
    expect(state.block).toEqual({ until: null, reason: 'هذا الهاتف مرتبط بحساب آخر محظور' });
    const profile = await own.profile(other.id);
    expect(profile.status).toBe('dues_unpaid');
    // The desk takes them on the account that owes them.
    expect(profile.duesViaAccountId).toBe(owing.id);

    // Another account on the other account's tablet is not linked to the
    // first phone's account.
    await signInAgain(other.phone, tablet);
    const far = await customer(tablet);
    expect(await problemCodes(far.headers)).not.toContain('dues_unpaid');
    expect(await problemCodes(far.headers)).not.toContain('account_blocked');

    // Dues alone block the phone, so OWN lifts it.
    const lifted = await own.command(other.id, 'lift-device-block', {
      deviceId: phone,
      note: 'هاتف العائلة',
    });
    expect(lifted.statusCode).toBe(200);
    expect(lifted.json().status).toBe('active');
  });

  it("takes the customer app's name-based UUID (Android ID) as the device", async () => {
    // What MainActivity sends: UUID.nameUUIDFromBytes, a version 3 UUID.
    const androidDevice = '6d1f5a2e-3c4b-3a9d-8e7f-0123456789ab';
    const someone = await customer(androidDevice);
    const profile = await (await panel(['OWN'])).profile(someone.id);
    expect(profile.devices).toEqual([expect.objectContaining({ deviceId: androidDevice })]);
  });

  it('refuses a device the customer never signed in on', async () => {
    const someone = await customer(randomUUID());
    const answer = await (
      await panel(['OWN'])
    ).command(someone.id, 'lift-device-block', {
      deviceId: randomUUID(),
      note: 'x',
    });
    expect(answer.statusCode).toBe(404);
    expect(answer.json().error).toBe('unknown_device');
  });
});
