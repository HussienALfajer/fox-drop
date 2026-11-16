import 'reflect-metadata';
import { describe, expect, it } from 'vitest';
import { MerchantAccountsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  app,
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

const board = (headers: Record<string, string>) =>
  app.inject({ method: 'GET', url: '/v1/merchant/orders', headers });
const account = (headers: Record<string, string>) =>
  app.inject({ method: 'GET', url: '/v1/merchant/account', headers });

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
  });
});
