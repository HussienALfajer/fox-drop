import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import {
  CashDeskService,
  type DeskUser,
  MerchantSettlementService,
  MerchantStatementsService,
} from '../cashdesk/index.js';
import { MerchantAccountsService } from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  acceptedOrder,
  admin,
  app,
  appSignIn,
  azaz,
  change,
  db,
  orderAtDoor,
  phoneNumber,
  restaurant,
  sql,
} from './delivery.fixture.js';

// RA §12.3–12.5, §16 #30–#31, R10 (slice 2.19e): «الكشوف» and «الإيصالات»
// in the restaurant app, owners only.
async function owner() {
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurant, { role: 'owner', name: 'owner', phone }, change);
  return appSignIn('merchant', phone);
}

async function otherOwner() {
  const merchants = app.get(MerchantsService);
  const other = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم آخر',
      location: { latitude: 36.587, longitude: 37.046 },
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1000,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(other, 'active', change);
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(other, { role: 'owner', name: 'owner', phone }, change);
  return { id: other, headers: await appSignIn('merchant', phone) };
}

const get = (url: string, headers: Record<string, string>) =>
  app.inject({ method: 'GET', url, headers });

// What the platform owes the restaurant, posted by the system: a credit on
// an order (RA §12.5 «تعويض عن طلب أُلغي بعد التحضير»).
async function systemCredit(restaurantId: string, amount: bigint) {
  const ledger = app.get(LedgerService);
  await db.db.transaction(async (tx) => {
    const own = await ledger.openAccount(
      { cityId: azaz, purpose: 'merchant.account', ownerId: restaurantId, currency: 'TRY' },
      tx,
    );
    const other = await ledger.openAccount(
      { cityId: azaz, purpose: 'platform.order_clearing', ownerId: null, currency: 'TRY' },
      tx,
    );
    await ledger.post(
      {
        cityId: azaz,
        type: 'merchant.credit',
        source: { kind: 'order', id: randomUUID() },
        actor: { type: 'system', id: null },
        entries: [
          { accountId: own, currency: 'TRY', amount: -amount },
          { accountId: other, currency: 'TRY', amount },
        ],
      },
      tx,
    );
  });
}

// A manual correction by a finance admin, + the restaurant owes (RA §12.5).
async function adjustment(adminId: string, owes: bigint) {
  const ledger = app.get(LedgerService);
  await db.db.transaction(async (tx) => {
    const own = await ledger.openAccount(
      { cityId: azaz, purpose: 'merchant.account', ownerId: restaurant, currency: 'TRY' },
      tx,
    );
    const other = await ledger.openAccount(
      { cityId: azaz, purpose: 'platform.adjustments', ownerId: null, currency: 'TRY' },
      tx,
    );
    await ledger.post(
      {
        cityId: azaz,
        type: 'merchant.adjustment',
        source: null,
        actor: { type: 'admin', id: adminId },
        reason: 'فرق جرد',
        entries: [
          { accountId: own, currency: 'TRY', amount: owes },
          { accountId: other, currency: 'TRY', amount: -owes },
        ],
      },
      tx,
    );
  });
}

describe('the statements and receipts in the restaurant app (RA §12.3–12.4)', () => {
  it('lists the statement, opens it with who decided, and shows the receipt', async () => {
    const owners = await owner();
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const finance = await admin(['FIN']);
    await adjustment(finance.accountId, 1_000n);
    // «الحساب»'s week names who decided it too (RA §12.2, §12.5).
    const week = (await get('/v1/merchant/account', owners)).json().weekLines;
    expect(week).toContainEqual(
      expect.objectContaining({
        kind: 'exception',
        cause: 'adjustment',
        decidedBy: 'admin',
        decidedByName: expect.stringMatching(/^Operator \d+$/),
      }),
    );
    expect(
      week.find((line: { orderId: string | null }) => line.orderId === door.order.id),
    ).toMatchObject({ decidedBy: null, decidedByName: null });
    const cutoff = new Date();
    await app.get(MerchantStatementsService).closeAt(azaz, cutoff, cutoff, { notify: false });

    const list = await get('/v1/merchant/statements', owners);
    expect(list.statusCode).toBe(200);
    const [latest] = list.json().statements;
    expect(latest).toMatchObject({
      cutoff: cutoff.toISOString(),
      currency: 'TRY',
      status: 'unpaid',
    });
    const totalDue = BigInt(latest.totalDue);
    expect(totalDue).toBeGreaterThan(0n);

    const opened = await get(`/v1/merchant/statements/${latest.id}`, owners);
    expect(opened.statusCode).toBe(200);
    const statement = opened.json();
    expect(statement).toMatchObject({ id: latest.id, status: 'unpaid', unpaid: latest.totalDue });
    expect(statement.lines).toContainEqual(
      expect.objectContaining({
        kind: 'order',
        orderId: door.order.id,
        itemsValue: '24000',
        commission: '3600',
        pickupLines: [{ currency: 'TRY', amount: '24000' }],
      }),
    );
    expect(statement.lines).toContainEqual(
      expect.objectContaining({
        kind: 'exception',
        cause: 'adjustment',
        amount: '1000',
        reason: 'فرق جرد',
        decidedBy: 'admin',
        decidedByName: expect.stringMatching(/^Operator \d+$/),
      }),
    );
    const order = statement.lines.find(
      (line: { orderId: string | null }) => line.orderId === door.order.id,
    );
    expect(order).toMatchObject({ decidedBy: null, decidedByName: null });

    // The office takes part of it (RA §12.4): the receipt shows in the app.
    const user: DeskUser = {
      accountId: finance.accountId,
      roles: ['FIN'],
      actor: { type: 'admin', id: finance.accountId, role: 'FIN' },
      context: { ipAddress: '203.0.113.9', device: 'test' },
    };
    await app.get(CashDeskService).openSession(user, azaz, [], new Date());
    const settlements = app.get(MerchantSettlementService);
    const lines = [{ currency: 'TRY', amount: 1_000n }];
    const preview = await settlements.preview(restaurant, lines);
    const issued = await settlements.settle(
      user,
      {
        session: 'office',
        visitorId: null,
        restaurantId: restaurant,
        due: preview.due,
        lines: preview.lines.map(({ currency, amount, base, rates }) => ({
          currency,
          amount,
          base,
          rates,
        })),
        idempotencyKey: randomUUID(),
      },
      new Date(),
    );

    const receipts = await get('/v1/merchant/receipts', owners);
    expect(receipts.statusCode).toBe(200);
    expect(receipts.json().receipts[0]).toMatchObject({
      id: issued.id,
      number: issued.number,
      type: 'merchant_settlement',
      method: 'office',
      staffName: issued.cashierName,
      currency: 'TRY',
      total: '1000',
      lines: [{ currency: 'TRY', amount: '1000', base: '1000' }],
    });
    const receipt = await get(`/v1/merchant/receipts/${issued.id}`, owners);
    expect(receipt.statusCode).toBe(200);
    expect(receipt.json()).toMatchObject({
      id: issued.id,
      number: issued.number,
      dueBefore: preview.due.toString(),
      dueAfter: (preview.due - 1_000n).toString(),
    });
    // Paid in part, the rest stays due.
    expect((await get('/v1/merchant/statements', owners)).json().statements[0].status).toBe(
      'partly_paid',
    );

    // Another restaurant's owner sees neither.
    const { headers: others } = await otherOwner();
    expect((await get('/v1/merchant/statements', others)).json().statements).toEqual([]);
    expect((await get('/v1/merchant/receipts', others)).json().receipts).toEqual([]);
    expect((await get(`/v1/merchant/statements/${latest.id}`, others)).statusCode).toBe(404);
    expect((await get(`/v1/merchant/receipts/${issued.id}`, others)).statusCode).toBe(404);
  });

  it(
    'shows a payout recorded at the desk for a visitor, a decision by the ' +
      'system, and keeps both for a terminated restaurant',
    async () => {
      const other = await otherOwner();
      await systemCredit(other.id, 5_000n);
      const cutoff = new Date();
      await app.get(MerchantStatementsService).closeAt(azaz, cutoff, cutoff, { notify: false });
      const [latest] = (await get('/v1/merchant/statements', other.headers)).json().statements;
      // The platform owes the restaurant: the statement asks nothing of it.
      expect(latest).toMatchObject({ totalDue: '-5000', status: null });
      const statement = (await get(`/v1/merchant/statements/${latest.id}`, other.headers)).json();
      expect(statement.lines).toContainEqual(
        expect.objectContaining({
          kind: 'exception',
          cause: 'credit',
          amount: '-5000',
          decidedBy: 'system',
          decidedByName: null,
        }),
      );

      // The desk pays it, naming the staff member without FIN who visited
      // (RA §12.4, AP §9.10.3).
      const finance = await admin(['FIN']);
      const visitor = await admin(['OPS']);
      const visitorName = (
        await sql.query('SELECT name FROM identity.admin_accounts WHERE id = $1', [
          visitor.accountId,
        ])
      ).rows[0].name as string;
      const user: DeskUser = {
        accountId: finance.accountId,
        roles: ['FIN'],
        actor: { type: 'admin', id: finance.accountId, role: 'FIN' },
        context: { ipAddress: '203.0.113.9', device: 'test' },
      };
      await app
        .get(CashDeskService)
        .openSession(user, azaz, [{ currency: 'TRY', amount: 100_000n }], new Date());
      const settlements = app.get(MerchantSettlementService);
      const lines = [{ currency: 'TRY', amount: 5_000n }];
      const preview = await settlements.preview(other.id, lines);
      const issued = await settlements.settle(
        user,
        {
          session: 'office',
          visitorId: visitor.accountId,
          restaurantId: other.id,
          due: preview.due,
          lines: preview.lines.map(({ currency, amount, base, rates }) => ({
            currency,
            amount,
            base,
            rates,
          })),
          idempotencyKey: randomUUID(),
        },
        new Date(),
      );

      // RA §5.5: a terminated restaurant's owners keep their statements and
      // receipts.
      await app.get(MerchantsService).setAccountStatus(other.id, 'terminated', change);
      expect((await get('/v1/merchant/statements', other.headers)).statusCode).toBe(200);
      const receipts = await get('/v1/merchant/receipts', other.headers);
      expect(receipts.statusCode).toBe(200);
      expect(receipts.json().receipts).toEqual([
        expect.objectContaining({
          id: issued.id,
          type: 'merchant_payout',
          method: 'field',
          staffName: visitorName,
          total: '5000',
        }),
      ]);
      expect((await get(`/v1/merchant/receipts/${issued.id}`, other.headers)).json()).toMatchObject(
        {
          dueBefore: '-5000',
          dueAfter: '0',
        },
      );
    },
  );

  it('refuses a cashier every one of them', async () => {
    const { cashier } = await acceptedOrder();
    const id = randomUUID();
    for (const url of [
      '/v1/merchant/statements',
      `/v1/merchant/statements/${id}`,
      '/v1/merchant/receipts',
      `/v1/merchant/receipts/${id}`,
    ]) {
      const refused = await get(url, cashier);
      expect(refused.statusCode).toBe(403);
      expect(refused.json().error).toBe('owner_only');
    }
  });

  it('answers an unknown statement and receipt as such', async () => {
    const owners = await owner();
    const id = randomUUID();
    const statement = await get(`/v1/merchant/statements/${id}`, owners);
    expect(statement.statusCode).toBe(404);
    expect(statement.json().error).toBe('unknown_statement');
    const receipt = await get(`/v1/merchant/receipts/${id}`, owners);
    expect(receipt.statusCode).toBe(404);
    expect(receipt.json().error).toBe('unknown_receipt');
  });
});
