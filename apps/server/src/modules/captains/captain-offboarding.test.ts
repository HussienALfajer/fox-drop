import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { LedgerService } from '../ledger/index.js';
import { CaptainsRefusedError, CaptainsService } from './captains.service.js';
import {
  admin,
  app,
  awaitingKit,
  azaz,
  day,
  db,
  deposit,
  scan,
  sql,
  type Admin,
} from './application-pipeline.fixture.js';

// AP §9.7.5, §9.7.2, §9.7.1, §9.10.3, C17 (slice 2.35b): «إنهاء التعاقد»
// and its checklist, the deposit refunded or withheld at the desk, the
// account closed, and a former captain applying again on the same account.

// An activated captain whose contract was signed `signedDaysAgo` days ago,
// with `paidNow` of a 30 000 deposit paid in cash at the desk.
async function contracted(options: { signedDaysAgo: number; paidNow: string; phone?: string }) {
  const { who, id, ops } = await awaitingKit(options.phone ? { phone: options.phone } : {});
  const own = await admin('OWN');
  await ops('PUT', `captain-applications/${id}/kit`, {
    items: [{ code: 'thermal_bag', quantity: 1 }],
  });
  const recorded = await ops('PUT', `captain-applications/${id}/contract`, {
    signedOn: day(-options.signedDaysAgo),
    startsOn: day(-options.signedDaysAgo),
    uploadIds: await scan(ops, 1),
  });
  expect(recorded.statusCode).toBe(200);
  await own('PUT', `cash-desk/deposits/${id}/cash-limit`, {
    cityId: azaz,
    cashLimit: { amount: '40000', currency: 'TRY' },
  });
  await own('POST', 'cash-desk/sessions', {
    cityId: azaz,
    floats: [{ currency: 'TRY', amount: '100000' }],
  });
  const paid = await deposit(own, id, {
    amount: '30000',
    instalment: '10000',
    paidNow: options.paidNow,
  });
  expect(paid.statusCode).toBe(201);
  return { who, id, ops, own };
}

async function activate(ops: Admin, id: string) {
  return ops('POST', `captain-applications/${id}/activate`);
}

const statusOf = async (id: string) =>
  (await sql.query('SELECT status FROM captains.captains WHERE id = $1', [id])).rows[0]?.status;

const settle = (own: Admin, id: string, settlement: 'refunded' | 'withheld', key = randomUUID()) =>
  own(
    'POST',
    'cash-desk/deposit-refunds',
    { cityId: azaz, applicationId: id, settlement },
    { 'idempotency-key': key },
  );

describe('«إنهاء التعاقد» in «فترة التزام» (AP §9.7.5, C17)', () => {
  it('flags «خروج مبكر», runs the checklist, refunds the deposit and lets the number apply again', async () => {
    const { who, id, ops, own } = await contracted({ signedDaysAgo: 40, paidNow: '20000' });
    expect((await activate(ops, id)).statusCode).toBe(200);
    // Confirmed after the probation ended: the commitment starts today.
    await ops('POST', `captain-applications/${id}/confirm-probation`);

    const terminated = await ops('POST', `captain-applications/${id}/terminate`, {
      reason: 'استقالة',
    });
    expect(terminated.statusCode).toBe(200);
    expect(terminated.json().offboarding).toMatchObject({
      reason: 'استقالة',
      earlyExit: true,
      kitReturned: null,
      custodyZero: true,
      earningsZero: true,
      depositHeld: '20000',
      depositSettled: null,
      missing: ['kit', 'deposit'],
      endedAt: null,
    });
    expect(await statusOf(id)).toBe('suspended');
    expect(
      (await ops('POST', `captain-applications/${id}/terminate`, { reason: 'مرة ثانية' })).json()
        .error,
    ).toBe('already_terminated');
    // No reactivation while the contract is being ended.
    await expect(
      app
        .get(CaptainsService)
        .setStatus(
          id,
          'active',
          { actor: { type: 'system', id: null, role: null }, context: {}, reason: 'test' } as never,
          new Date(),
        ),
    ).rejects.toThrow(CaptainsRefusedError);
    const early = await ops('POST', `captain-applications/${id}/offboarding/close`);
    expect(early.statusCode).toBe(409);
    expect(early.json()).toMatchObject({
      error: 'offboarding_incomplete',
      missing: ['kit', 'deposit'],
    });

    // The desk lists it; the deposit waits for the kit's step.
    const listed = (await own('GET', `cash-desk/deposit-refunds?cityId=${azaz}`)).json();
    expect(listed.contracts).toContainEqual(
      expect.objectContaining({
        applicationId: id,
        earlyExit: true,
        kitReturned: null,
        held: { amount: '20000', currency: 'TRY' },
      }),
    );
    expect((await settle(own, id, 'refunded')).json().error).toBe('kit_not_checked');
    const kit = await ops('PUT', `captain-applications/${id}/offboarding/kit`, { returned: true });
    expect(kit.json().offboarding).toMatchObject({ kitReturned: true, missing: ['deposit'] });
    expect((await settle(own, id, 'withheld')).json().error).toBe('wrong_settlement');

    const key = randomUUID();
    const refunded = await settle(own, id, 'refunded', key);
    expect(refunded.statusCode).toBe(201);
    expect(refunded.json().receipt).toMatchObject({
      type: 'captain_deposit_refund',
      captainId: id,
      lines: [expect.objectContaining({ currency: 'TRY', amount: '20000' })],
    });
    const again = await settle(own, id, 'refunded', key);
    expect(again.json().receipt.id).toBe(refunded.json().receipt.id);
    expect((await settle(own, id, 'refunded')).json().error).toBe('deposit_settled');
    const page = (await ops('GET', `captain-applications/${id}`)).json();
    expect(page.offboarding).toMatchObject({
      depositHeld: '0',
      depositSettled: 'refunded',
      missing: [],
    });
    expect(
      (await ops('PUT', `captain-applications/${id}/offboarding/kit`, { returned: false })).json()
        .error,
    ).toBe('deposit_settled');
    // The captain still signs in during the checklist.
    expect((await who.call('GET', '/availability')).statusCode).toBe(200);

    const closed = await ops('POST', `captain-applications/${id}/offboarding/close`);
    expect(closed.statusCode).toBe(200);
    expect(closed.json().offboarding.endedAt).not.toBeNull();
    expect(await statusOf(id)).toBe('terminated');
    const { rows: accounts } = await sql.query(
      'SELECT captain_id, city_id FROM identity.captain_accounts WHERE id = $1',
      [who.accountId],
    );
    expect(accounts).toEqual([{ captain_id: null, city_id: null }]);
    expect((await who.call('GET', '/availability')).statusCode).toBe(401);
    expect((await ops('POST', `captain-applications/${id}/offboarding/close`)).json().error).toBe(
      'contract_ended',
    );
    // An ended contract leaves the board.
    const board = (await ops('GET', `captain-applications?cityId=${azaz}&stage=active`)).json();
    expect(board.applications.map((each: { id: string }) => each.id)).not.toContain(id);

    // C17: the same number applies again on the same account.
    const back = await contracted({ signedDaysAgo: 0, paidNow: '0', phone: who.phone });
    expect(back.who.accountId).toBe(who.accountId);
    const review = (await back.ops('GET', `captain-applications/${back.id}`)).json();
    expect(review.formerCaptain).toEqual({ captainId: id, earlyExit: true });
    expect(review.duplicates).toContainEqual(
      expect.objectContaining({ field: 'phone', applicationId: id, earlyExit: true }),
    );
    const byOps = await activate(back.ops, back.id);
    expect(byOps.statusCode).toBe(403);
    expect(byOps.json().error).toBe('owner_approval_required');
    const byOwner = await activate(back.own, back.id);
    expect(byOwner.statusCode).toBe(200);
    expect(byOwner.json().activation.captainId).toBe(id);
    expect(await statusOf(id)).toBe('active');
    expect((await back.who.call('GET', '/availability')).statusCode).toBe(200);
  });
});

describe('«إنهاء التعاقد» in «فترة تجربة» (AP §9.7.2)', () => {
  it('flags nothing, withholds the deposit of a kit not returned and waits for the earnings', async () => {
    const { id, ops, own } = await contracted({ signedDaysAgo: 0, paidNow: '15000' });
    expect((await activate(ops, id)).statusCode).toBe(200);
    const terminated = await ops('POST', `captain-applications/${id}/terminate`, {
      reason: 'لم يجتز فترة التجربة',
    });
    expect(terminated.json().offboarding.earlyExit).toBe(false);
    expect((await ops('POST', `captain-applications/${id}/confirm-probation`)).json().error).toBe(
      'already_terminated',
    );
    await ops('PUT', `captain-applications/${id}/offboarding/kit`, { returned: false });

    const ledger = app.get(LedgerService);
    const revenue = await db.db.transaction((tx) =>
      ledger.openAccount(
        { cityId: azaz, purpose: 'platform.revenue_deposits', ownerId: null, currency: 'TRY' },
        tx,
      ),
    );
    const before = (await ledger.balance(revenue)).amount;
    const withheld = await settle(own, id, 'withheld');
    expect(withheld.statusCode).toBe(201);
    expect(withheld.json().receipt).toBeNull();
    expect((await ledger.balance(revenue)).amount - before).toBe(15_000n);

    // The captain earned 4 000: the account waits until they are paid.
    await db.db.transaction(async (tx) => {
      const [earnings, cost] = await Promise.all([
        ledger.openAccount(
          { cityId: azaz, purpose: 'captain.earnings', ownerId: id, currency: 'TRY' },
          tx,
        ),
        ledger.openAccount(
          { cityId: azaz, purpose: 'platform.captain_pay', ownerId: null, currency: 'TRY' },
          tx,
        ),
      ]);
      await ledger.post(
        {
          cityId: azaz,
          type: 'earn.bonus',
          source: null,
          actor: { type: 'system', id: null },
          reason: 'test',
          entries: [
            { accountId: earnings, currency: 'TRY', amount: -4_000n },
            { accountId: cost, currency: 'TRY', amount: 4_000n },
          ],
        },
        tx,
      );
    });
    const blocked = await ops('POST', `captain-applications/${id}/offboarding/close`);
    expect(blocked.json()).toMatchObject({
      error: 'offboarding_incomplete',
      missing: ['earnings'],
    });
    // OWN pays them off the cycle; no instalment is taken once terminated.
    const preview = (
      await own('POST', 'cash-desk/settlements/preview', { captainId: id, payoutCurrency: null })
    ).json();
    expect(preview).toMatchObject({ instalment: '0' });
    const paid = await own(
      'POST',
      'cash-desk/settlements',
      {
        captainId: id,
        custody: [],
        earnings: '4000',
        payout: preview.payout,
        reason: 'إنهاء التعاقد',
      },
      { 'idempotency-key': randomUUID() },
    );
    expect(paid.statusCode).toBe(201);
    const closed = await ops('POST', `captain-applications/${id}/offboarding/close`);
    expect(closed.statusCode).toBe(200);
    expect(await statusOf(id)).toBe('terminated');
  });
});
