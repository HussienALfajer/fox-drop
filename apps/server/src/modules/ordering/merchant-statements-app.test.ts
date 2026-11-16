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
  return appSignIn('merchant', phone);
}

const get = (url: string, headers: Record<string, string>) =>
  app.inject({ method: 'GET', url, headers });

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
    const others = await otherOwner();
    expect((await get('/v1/merchant/statements', others)).json().statements).toEqual([]);
    expect((await get('/v1/merchant/receipts', others)).json().receipts).toEqual([]);
    expect((await get(`/v1/merchant/statements/${latest.id}`, others)).statusCode).toBe(404);
    expect((await get(`/v1/merchant/receipts/${issued.id}`, others)).statusCode).toBe(404);
  });

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
