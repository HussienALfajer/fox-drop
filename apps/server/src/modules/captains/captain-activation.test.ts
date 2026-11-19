import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { LedgerService } from '../ledger/index.js';
import { SettingsService } from '../settings/index.js';
import { ApplicationPipelineService } from './application-pipeline.service.js';
import { CaptainsService } from './captains.service.js';
import {
  activated,
  admin,
  app,
  awaitingKit,
  azaz,
  day,
  db,
  deposit,
  jpeg,
  put,
  scan,
  sql,
  type Admin,
} from './application-pipeline.fixture.js';

// AP §9.7.1–9.7.2, CA §5.4–5.5, D24 (slice 2.35a): the activation's records
// at «بانتظار العدة» (the kit, the cash limit, the contract with its scan,
// the deposit) and «تفعيل», which makes the applicant a captain.

describe('the records at «بانتظار العدة» (AP §9.7.1)', () => {
  it('issues the kit from the list, with the labels and sizes as issued', async () => {
    const { id, ops } = await awaitingKit();
    const issued = await ops('PUT', `captain-applications/${id}/kit`, {
      items: [
        { code: 'thermal_bag', quantity: 1 },
        { code: 'vest', size: ' L ', quantity: 2 },
      ],
    });
    expect(issued.statusCode).toBe(200);
    expect(issued.json().activation.kit.items).toEqual([
      { code: 'thermal_bag', label: 'حقيبة حرارية', size: null, quantity: 1 },
      { code: 'vest', label: 'سترة', size: 'L', quantity: 2 },
    ]);
    expect(issued.json().events.at(-1)).toMatchObject({ kind: 'kit', stage: 'awaiting_kit' });
    const unknown = await ops('PUT', `captain-applications/${id}/kit`, {
      items: [{ code: 'helmet', quantity: 1 }],
    });
    expect(unknown.statusCode).toBe(400);
    expect(unknown.json().error).toBe('invalid_kit');
  });

  it('records the contract with its scan, accepted, and computes its dates (D24)', async () => {
    const { id, ops, who } = await awaitingKit();
    const future = await ops('PUT', `captain-applications/${id}/contract`, {
      signedOn: day(2),
      startsOn: day(3),
      uploadIds: await scan(ops, 1),
    });
    expect(future.json().error).toBe('invalid_contract');
    const recorded = await ops('PUT', `captain-applications/${id}/contract`, {
      signedOn: day(0),
      startsOn: day(1),
      uploadIds: await scan(ops, 3),
    });
    expect(recorded.statusCode).toBe(200);
    const { contract } = recorded.json().activation;
    expect(contract).toMatchObject({
      signedOn: day(0),
      startsOn: day(1),
      probationDays: 30,
      commitmentMonths: 3,
      probationEndsOn: day(31),
    });
    const scanned = recorded
      .json()
      .documents.find((each: { kind: string }) => each.kind === 'signed_contract');
    expect(scanned).toMatchObject({ status: 'accepted', uploadedByOffice: true, inForce: true });
    expect(scanned.fileUrls).toHaveLength(3);
    // The applicant never uploads it, nor the office outside «تسجيل العقد».
    const asked = await who.call('POST', '/application/documents/upload', {
      contentType: 'image/jpeg',
      sizeBytes: jpeg.length,
    });
    await put(asked.json().url);
    const byApplicant = await who.call('PUT', '/application/documents/signed_contract', {
      uploadIds: [asked.json().uploadId],
    });
    expect(byApplicant.json().error).toBe('document_not_needed');
    const byOffice = await ops('PUT', `captain-applications/${id}/documents/signed_contract`, {
      uploadIds: await scan(ops, 1),
    });
    expect(byOffice.json().error).toBe('document_not_needed');
  });

  it("takes the cash limit from FIN or OWN at the desk, in the city's base", async () => {
    const { id, ops } = await awaitingKit();
    const cashLimit = (who: Admin, currency: string) =>
      who('PUT', `cash-desk/deposits/${id}/cash-limit`, {
        cityId: azaz,
        cashLimit: { amount: '50000', currency },
      });
    expect((await cashLimit(ops, 'TRY')).statusCode).toBe(403);
    const fin = await admin('FIN');
    // FIN never reads the application's page (its documents and data).
    expect((await fin('GET', `captain-applications/${id}`)).statusCode).toBe(403);
    expect((await cashLimit(fin, 'USD')).json().error).toBe('invalid_currency');
    const set = await cashLimit(fin, 'TRY');
    expect(set.statusCode).toBe(200);
    expect(
      set.json().applications.find((each: { applicationId: string }) => each.applicationId === id)
        .cashLimit,
    ).toEqual({ amount: '50000', currency: 'TRY' });
  });

  it('refuses rejecting an application holding a paid deposit (no refund yet)', async () => {
    const { id, ops } = await awaitingKit();
    const fin = await admin('FIN');
    await fin('POST', 'cash-desk/sessions', { cityId: azaz, floats: [] });
    await deposit(fin, id, { amount: '30000', instalment: null, paidNow: '10000' });
    const rejected = await ops('POST', `captain-applications/${id}/reject`, { reason: 'test' });
    expect(rejected.json().error).toBe('deposit_paid');
  });
});

describe('the deposit at the desk (AP §9.7.1, §8.5)', () => {
  it('records the plan and the cash paid now with its receipt «تأمين العدة»', async () => {
    const { who, id } = await awaitingKit();
    const fin = await admin('FIN');
    const offered = (await fin('GET', `cash-desk/deposits?cityId=${azaz}`)).json();
    expect(offered.applications).toContainEqual(
      expect.objectContaining({
        applicationId: id,
        deposit: { amount: null, instalment: null, paid: '0', recorded: false },
      }),
    );
    // Cash needs an open drawer; the plan alone does not.
    const noDrawer = await deposit(fin, id, {
      amount: '50000',
      instalment: '10000',
      paidNow: '20000',
    });
    expect(noDrawer.json().error).toBe('no_open_session');
    await fin('POST', 'cash-desk/sessions', { cityId: azaz, floats: [] });
    const tooMuch = await deposit(fin, id, {
      amount: '50000',
      instalment: '10000',
      paidNow: '60000',
    });
    expect(tooMuch.json().error).toBe('above_balance');
    const key = randomUUID();
    const body = { cityId: azaz, applicationId: id, amount: '50000', instalment: '10000' };
    const paid = await fin(
      'POST',
      'cash-desk/deposits',
      { ...body, paidNow: '20000' },
      { 'idempotency-key': key },
    );
    expect(paid.statusCode).toBe(201);
    // The same key again answers the same receipt and posts nothing more.
    const again = await fin(
      'POST',
      'cash-desk/deposits',
      { ...body, paidNow: '20000' },
      { 'idempotency-key': key },
    );
    expect(again.json().receipt.id).toBe(paid.json().receipt.id);
    // One journal: the deposit paid stays 20 000 (read below).
    expect(paid.json().receipt).toMatchObject({
      type: 'captain_deposit',
      captainId: id,
      lines: [{ currency: 'TRY', expected: '50000', amount: '20000', remaining: '30000' }],
    });
    const after = (await fin('GET', `cash-desk/deposits?cityId=${azaz}`))
      .json()
      .applications.find((each: { applicationId: string }) => each.applicationId === id).deposit;
    expect(after).toEqual({
      amount: { amount: '50000', currency: 'TRY' },
      instalment: { amount: '10000', currency: 'TRY' },
      paid: '20000',
      recorded: true,
    });
    const { rows } = await sql.query(
      `SELECT template_key, body FROM notifications.push_messages
       WHERE account_id = $1 AND template_key = 'captain.desk_receipt'`,
      [who.accountId],
    );
    expect(rows).toEqual([
      { template_key: 'captain.desk_receipt', body: expect.stringMatching(/تأمين العدة/) },
    ]);
    // The rest of what is left, never more.
    const rest = await deposit(fin, id, { amount: '50000', instalment: null, paidNow: '30000' });
    expect(rest.json().receipt.lines[0]).toMatchObject({ expected: '30000', remaining: '0' });
  });
});

describe('«تفعيل» (AP §9.7.1, CA §5.4–5.5)', () => {
  it('waits for every condition, then makes the applicant a captain', async () => {
    const { who, id, ops } = await awaitingKit();
    const early = await ops('POST', `captain-applications/${id}/activate`);
    expect(early.statusCode).toBe(409);
    expect(early.json()).toMatchObject({
      error: 'activation_incomplete',
      missing: ['document:signed_contract', 'kit', 'deposit', 'contract', 'cash_limit'],
    });

    await ops('PUT', `captain-applications/${id}/kit`, {
      items: [{ code: 'thermal_bag', quantity: 1 }],
    });
    await ops('PUT', `captain-applications/${id}/contract`, {
      signedOn: day(0),
      startsOn: day(0),
      uploadIds: await scan(ops, 1),
    });
    const own = await admin('OWN');
    await own('PUT', `cash-desk/deposits/${id}/cash-limit`, {
      cityId: azaz,
      cashLimit: { amount: '40000', currency: 'TRY' },
    });
    // A deposit without instalments waits until it is paid in full.
    await deposit(own, id, { amount: '50000', instalment: null, paidNow: '0' });
    expect((await ops('GET', `captain-applications/${id}`)).json().activation.missing).toEqual([
      'deposit',
    ]);
    await deposit(own, id, { amount: '50000', instalment: '10000', paidNow: '0' });
    // A device the applicant registered before is the captain's after.
    await who.call('PUT', '/push-token', { token: `fid-${id}`, platform: 'android' });

    const activated = await ops('POST', `captain-applications/${id}/activate`);
    expect(activated.statusCode).toBe(200);
    expect(activated.json()).toMatchObject({
      stage: 'active',
      activation: { captainId: id, missing: [] },
    });
    const { rows: captains } = await sql.query(
      `SELECT name, vehicle, plate_number, custody_limit::text, status FROM captains.captains
       WHERE id = $1`,
      [id],
    );
    expect(captains).toEqual([
      expect.objectContaining({ vehicle: 'car', custody_limit: '40000', status: 'active' }),
    ]);
    const { rows: accounts } = await sql.query(
      'SELECT captain_id FROM identity.captain_accounts WHERE id = $1',
      [who.accountId],
    );
    expect(accounts).toEqual([{ captain_id: id }]);
    // The same session is the captain's now, «ملفي» with the application's
    // neighbourhood (CA §12.1).
    expect((await who.call('GET', '/availability')).statusCode).toBe(200);
    expect((await who.call('GET', '/profile')).json()).toMatchObject({
      neighbourhood: 'الحي الشمالي',
      vehicle: 'car',
    });
    const { rows: devices } = await sql.query(
      'SELECT captain_id FROM notifications.push_devices WHERE account_id = $1',
      [who.accountId],
    );
    expect(devices).toEqual([{ captain_id: id }]);
    const { rows: welcome } = await sql.query(
      `SELECT body FROM notifications.push_messages
       WHERE captain_id = $1 AND template_key = 'captain.application_active'`,
      [id],
    );
    expect(welcome).toEqual([{ body: 'مرحباً بك في FOX DROP!' }]);
    const { rows: audits } = await sql.query(
      `SELECT action FROM audit.events WHERE target_id = $1 AND action IN
       ('captain.create', 'captain_application.activate') ORDER BY action`,
      [id],
    );
    expect(audits.map((row) => row.action as string).toSorted()).toEqual([
      'captain.create',
      'captain_application.activate',
    ]);
    // Once is enough.
    const again = await ops('POST', `captain-applications/${id}/activate`);
    expect(again.json()).toMatchObject({ error: 'wrong_stage', stage: 'active' });
  });

  it('takes the instalment off the earnings at the Thursday settlement (AP §8.5.5)', async () => {
    const { id, ops } = await awaitingKit();
    const own = await admin('OWN');
    await ops('PUT', `captain-applications/${id}/kit`, {
      items: [{ code: 'vest', size: 'M', quantity: 1 }],
    });
    await ops('PUT', `captain-applications/${id}/contract`, {
      signedOn: day(0),
      startsOn: day(0),
      uploadIds: await scan(ops, 1),
    });
    await own('PUT', `cash-desk/deposits/${id}/cash-limit`, {
      cityId: azaz,
      cashLimit: { amount: '40000', currency: 'TRY' },
    });
    await own('POST', 'cash-desk/sessions', {
      cityId: azaz,
      floats: [{ currency: 'TRY', amount: '100000' }],
    });
    await deposit(own, id, { amount: '25000', instalment: '10000', paidNow: '10000' });
    expect((await ops('POST', `captain-applications/${id}/activate`)).statusCode).toBe(200);
    // Today is the payout day (the instalment is a payout day's).
    const weekday = new Intl.DateTimeFormat('en-US', { timeZone: 'Asia/Damascus', weekday: 'long' })
      .format(new Date())
      .toLowerCase();
    await app.get(SettingsService).update('captain.payout_weekday', { cityId: azaz }, weekday, {
      editor: 'system',
      context: { ipAddress: null, device: null },
    });
    // The captain earned 4 000 (a bonus, as the ledger books it).
    const ledger = app.get(LedgerService);
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
    const preview = (
      await own('POST', 'cash-desk/settlements/preview', { captainId: id, payoutCurrency: null })
    ).json();
    // The instalment never takes the earnings below zero: 4 000 of 10 000.
    expect(preview).toMatchObject({
      earnings: { amount: '4000', currency: 'TRY' },
      instalment: '4000',
      payout: null,
    });
    const settled = await own(
      'POST',
      'cash-desk/settlements',
      { captainId: id, custody: [], earnings: '4000', payout: null, reason: 'اختبار' },
      { 'idempotency-key': randomUUID() },
    );
    expect(settled.statusCode).toBe(201);
    expect(settled.json().statement).toMatchObject({ instalments: '4000', balance: '0' });
    const after = (await ops('GET', `captain-applications/${id}`)).json().activation.deposit;
    expect(after.paid).toBe('14000');
  });
});

describe('the contract phases (AP §9.7.2, CA §12.3, §14 #28)', () => {
  it('asks the review, confirms it and tells each phase once', async () => {
    const { who, id, ops } = await activated();
    const pipeline = app.get(ApplicationPipelineService);
    const inDays = (days: number) => new Date(Date.now() + days * 86_400_000);
    const reviewOf = async (days: number) =>
      (await pipeline.probationReviews(azaz, inDays(days))).find((each) => each.captainId === id)
        ?.review;
    expect(await reviewOf(0)).toBeUndefined();
    expect(await reviewOf(28)).toBe('due');
    expect(await reviewOf(31)).toBe('overdue');

    const page = (await ops('GET', `captain-applications/${id}`)).json();
    expect(page.activation.contract).toMatchObject({
      phase: 'probation',
      probationEndsOn: day(30),
      commitmentStartsOn: day(30),
      probationConfirmedOn: null,
      review: 'none',
    });
    const confirmed = await ops('POST', `captain-applications/${id}/confirm-probation`);
    expect(confirmed.statusCode).toBe(200);
    expect(confirmed.json().activation.contract).toMatchObject({
      probationConfirmedOn: day(0),
      commitmentStartsOn: day(30),
      phase: 'probation',
    });
    expect(await reviewOf(31)).toBeUndefined();
    const again = await ops('POST', `captain-applications/${id}/confirm-probation`);
    expect(again.json().error).toBe('already_confirmed');

    // The phase changes on its day, told once.
    const told: { captainId: string; phase: string; from: string }[] = [];
    const notify = async (_tx: unknown, change: (typeof told)[number]) => {
      if (change.captainId === id) told.push(change);
    };
    await pipeline.sweepContractPhases(azaz, inDays(1), notify);
    expect(told).toEqual([]);
    await pipeline.sweepContractPhases(azaz, inDays(31), notify);
    await pipeline.sweepContractPhases(azaz, inDays(31), notify);
    expect(told).toEqual([expect.objectContaining({ phase: 'commitment', from: day(30) })]);

    const mine = await who.call('GET', '/contract');
    expect(mine.statusCode).toBe(200);
    expect(mine.json()).toEqual({
      contract: expect.objectContaining({ phase: 'probation', probationConfirmed: true }),
      kit: [
        { label: 'حقيبة حرارية', size: null, quantity: 1 },
        { label: 'سترة', size: 'L', quantity: 1 },
      ],
      deposit: {
        amount: { amount: '30000', currency: 'TRY' },
        paid: '0',
        instalment: { amount: '10000', currency: 'TRY' },
      },
    });
  });
});

describe('the documents of a captain (CA §12.2, AP §9.7.4, K6)', () => {
  it('reminds before expiry, keeps the old one with its replacement, and blocks once expired', async () => {
    const { who, id, ops } = await activated();
    const pipeline = app.get(ApplicationPipelineService);
    const inDays = (days: number) => new Date(Date.now() + days * 86_400_000);
    const mine = await who.call('GET', '/documents');
    expect(mine.statusCode).toBe(200);
    const criminal = () =>
      mine.json().documents.find((each: { kind: string }) => each.kind === 'criminal_record');
    expect(criminal()).toMatchObject({ required: true, state: 'valid', pending: null });

    // 12 months from today, within the 30 days' notice 20 days before.
    const expiring = async (days: number) =>
      (await pipeline.expiringDocuments(azaz, inDays(days))).find((each) => each.captainId === id);
    expect(await expiring(0)).toBeUndefined();
    expect((await expiring(350))?.documents).toEqual([
      expect.objectContaining({ kind: 'criminal_record', expired: false }),
    ]);

    // Expired, it blocks going online.
    const refused = await app
      .get(CaptainsService)
      .goOnline(
        id,
        { appVersion: '9.0.0', simulatedLocation: false, termsPending: false },
        inDays(400),
      )
      .catch((error: { blocks?: unknown }) => error.blocks);
    expect(refused).toEqual(
      expect.arrayContaining([{ kind: 'document_expired', documents: ['criminal_record'] }]),
    );

    // «رفع نسخة جديدة»: pending beside the one in force.
    const asked = await who.call('POST', '/documents/upload', {
      contentType: 'image/jpeg',
      sizeBytes: jpeg.length,
    });
    expect(asked.statusCode).toBe(201);
    await put(asked.json().url);
    const replaced = await who.call('PUT', '/documents/criminal_record', {
      uploadIds: [asked.json().uploadId],
      issueDate: day(0),
    });
    expect(replaced.statusCode).toBe(200);
    expect(
      replaced.json().documents.find((each: { kind: string }) => each.kind === 'criminal_record'),
    ).toMatchObject({ state: 'valid', pending: expect.objectContaining({ issueDate: day(0) }) });
    const contract = await who.call('PUT', '/documents/signed_contract', {
      uploadIds: [asked.json().uploadId],
    });
    expect(contract.statusCode).toBe(400);

    // OPS accepts it from the captain's page.
    const page = (await ops('GET', `captain-applications/${id}`)).json();
    const fresh = page.documents.find(
      (each: { kind: string; inForce: boolean }) => each.kind === 'criminal_record' && each.inForce,
    );
    expect(fresh.status).toBe('pending');
    const accepted = await ops('POST', `captain-applications/${id}/documents/${fresh.id}/review`, {
      status: 'accepted',
    });
    expect(accepted.statusCode).toBe(200);
    // Accepted, it stays valid until it expires (K6).
    const refusedReject = await ops(
      'POST',
      `captain-applications/${id}/documents/${fresh.id}/review`,
      { status: 'rejected', reason: 'غير واضح' },
    );
    expect(refusedReject.json().error).toBe('document_in_force');
    const after = (await who.call('GET', '/documents')).json();
    expect(
      after.documents.find((each: { kind: string }) => each.kind === 'criminal_record'),
    ).toMatchObject({ state: 'valid', pending: null });
  });
});
