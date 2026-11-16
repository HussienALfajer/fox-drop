import 'reflect-metadata';
import { describe, expect, it, vi } from 'vitest';
import { MerchantStatementsService } from '../cashdesk/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantAccountsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  app,
  azaz,
  acceptedOrder,
  appSignIn,
  change,
  orderAtDoor,
  phoneNumber,
  restaurant,
} from './delivery.fixture.js';

// RA §8.4, §12.1–12.2, R10 (slice 2.19d): the owners' money lines on the
// board and «الحساب»; a cashier sees neither.
async function owner() {
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurant, { role: 'owner', name: 'owner', phone }, change);
  return appSignIn('merchant', phone);
}

// An owner of another restaurant, with nothing owed.
async function otherOwner() {
  const merchants = app.get(MerchantsService);
  const other = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم آخر ${phoneNumber()}`,
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

const board = (headers: Record<string, string>) =>
  app.inject({ method: 'GET', url: '/v1/merchant/orders', headers });
const account = (headers: Record<string, string>) =>
  app.inject({ method: 'GET', url: '/v1/merchant/account', headers });
const overdue = (headers: Record<string, string>) =>
  app.inject({ method: 'GET', url: '/v1/merchant/account/overdue', headers });

describe('the owners’ lines of an order (RA §8.4)', () => {
  it('gives owners the commission and the net, and a cashier neither', async () => {
    const order = await acceptedOrder();
    const owners = await owner();
    const seen = (await board(owners))
      .json()
      .orders.find((each: { id: string }) => each.id === order.id);
    // 2 × 120 TRY at 15%: 36 of commission, 204 for the restaurant.
    expect(seen.owner).toEqual({
      testOrder: false,
      commissionBp: 1500,
      commission: '3600',
      discountShare: '0',
      discountOnDelivery: false,
      merchantNet: '20400',
    });
    const cashiers = (await board(order.cashier)).json().orders;
    expect(cashiers.find((each: { id: string }) => each.id === order.id).owner).toBeNull();
  });
});

describe('GET /v1/merchant/account (RA §12.2)', () => {
  it('shows the owner the balance, today’s pickup and the week after a delivery', async () => {
    const owners = await owner();
    const before = (await account(owners)).json();
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const answer = await account(owners);
    expect(answer.statusCode).toBe(200);
    const after = answer.json();
    expect(after.currency).toBe('TRY');
    // The commission of 36 TRY is owed now.
    expect(BigInt(after.balance) - BigInt(before.balance)).toBe(3_600n);
    expect(after.commissionBp).toBe(1500);
    expect(after.settlementDate).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    const pickup = after.pickups.find(
      (each: { orderId: string }) => each.orderId === door.order.id,
    );
    expect(pickup).toMatchObject({
      captainName: 'كابتن',
      amount: '24000',
      lines: [{ currency: 'TRY', amount: '24000' }],
    });
    const line = after.weekLines.find(
      (each: { orderId: string | null }) => each.orderId === door.order.id,
    );
    expect(line).toMatchObject({
      kind: 'order',
      orderNumber: pickup.orderNumber,
      itemsValue: '24000',
      commission: '3600',
      discountShare: '0',
      cause: null,
    });
    expect(line.day).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });

  it('shows a commission change scheduled for new orders', async () => {
    const owners = await owner();
    const from = new Date(Date.now() + 7 * 86_400_000);
    await app
      .get(MerchantsService)
      .setCommission(restaurant, { rateBp: 1200, effectiveFrom: from }, change);
    expect((await account(owners)).json()).toMatchObject({
      commissionBp: 1500,
      nextCommission: { rateBp: 1200, from: from.toISOString() },
    });
  });

  it('refuses a cashier', async () => {
    const order = await acceptedOrder();
    const refused = await account(order.cashier);
    expect(refused.statusCode).toBe(403);
    expect(refused.json().error).toBe('owner_only');
    const banner = await overdue(order.cashier);
    expect(banner.statusCode).toBe(403);
    expect(banner.json().error).toBe('owner_only');
  });

  it('shows another restaurant’s owner nothing of this one', async () => {
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
    const owners = await appSignIn('merchant', phone);
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    expect((await account(owners)).json()).toMatchObject({
      balance: '0',
      commissionBp: 1000,
      pickups: [],
      weekLines: [],
    });
    expect((await board(owners)).json().orders).toEqual([]);
  });

  // Last: it closes a statement on the shared restaurant.
  it('starts the week at the latest statement and dates the settlement by it', async () => {
    const owners = await owner();
    const earlier = await orderAtDoor();
    expect((await earlier.deliver()).statusCode).toBe(200);
    const cutoff = new Date();
    await app.get(MerchantStatementsService).closeAt(azaz, cutoff, cutoff, { notify: false });
    const later = await orderAtDoor();
    expect((await later.deliver()).statusCode).toBe(200);
    const answer = (await account(owners)).json();
    expect(answer.weekFrom).toBe(cutoff.toISOString());
    const orders = answer.weekLines.map((line: { orderId: string | null }) => line.orderId);
    expect(orders).toContain(later.order.id);
    expect(orders).not.toContain(earlier.order.id);
    // The statement is unpaid, so it is the one to settle.
    const timeZone = (await app.get(GeoService).cityTimeZone(azaz))!;
    expect(answer.settlementDate).toBe(
      new Intl.DateTimeFormat('en-CA', {
        timeZone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      }).format(cutoff),
    );
    // RA §12.6 (slice 2.19f): not overdue on the settlement day itself.
    expect(answer.overdue).toBeNull();
    expect((await overdue(owners)).json()).toEqual({ overdue: null });

    // Two days after it, unpaid: the red line and the banner.
    vi.useFakeTimers({ toFake: ['Date'] });
    try {
      vi.setSystemTime(new Date(cutoff.getTime() + 2 * 86_400_000 + 60_000));
      const statementDate = answer.settlementDate;
      // Signed in then: the earlier session's token has expired by now.
      const later = await owner();
      const late = (await account(later)).json().overdue;
      expect(late).toEqual({ amount: expect.stringMatching(/^[1-9]\d*$/), statementDate });
      expect((await overdue(later)).json()).toEqual({
        overdue: { currency: 'TRY', amount: late.amount, statementDate },
      });
      // Another restaurant's owner sees nothing of this one.
      expect((await overdue(await otherOwner())).json()).toEqual({ overdue: null });
    } finally {
      vi.useRealTimers();
    }
  });
});
