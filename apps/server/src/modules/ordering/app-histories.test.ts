import 'reflect-metadata';
import { describe, expect, it } from 'vitest';
import { MerchantAccountsService } from '../identity/index.js';
import {
  app,
  appSignIn,
  change,
  orderAtDoor,
  phoneNumber,
  restaurant,
} from './delivery.fixture.js';

// RA §8.18 and CA §9.13 (slice 2.40): the restaurant's and the captain's
// «السجل».

async function owner() {
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurant, { role: 'owner', name: 'owner', phone }, change);
  return appSignIn('merchant', phone);
}

const history = (headers: Record<string, string>, query = '') =>
  app.inject({ method: 'GET', url: `/v1/merchant/orders/history${query}`, headers });

// The business day of a moment on Azaz's clock (UTC+3, cutoff 06:00).
const dayOf = (at: Date) =>
  new Date(at.getTime() + 3 * 3_600_000 - 6 * 3_600_000).toISOString().slice(0, 10);
const daysBefore = (day: string, days: number) =>
  new Date(Date.parse(day) - days * 86_400_000).toISOString().slice(0, 10);

describe('GET /v1/merchant/orders/history (RA §8.18)', () => {
  it('lists a delivered order with the commission and net to owners, the items value only to a cashier', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const owners = await owner();

    const ownerAnswer = await history(owners);
    expect(ownerAnswer.statusCode).toBe(200);
    const ownerPage = ownerAnswer.json();
    expect(ownerPage.owner).toBe(true);
    const today = dayOf(new Date());
    expect(ownerPage).toMatchObject({ fromDay: daysBefore(today, 7), toDay: today });
    const row = ownerPage.orders.find((each: { id: string }) => each.id === door.order.id);
    expect(row).toMatchObject({
      status: 'delivered',
      itemCount: 2,
      currency: 'TRY',
      itemsValue: '24000',
      day: today,
      owner: { commission: '3600', merchantNet: '20400', testOrder: false },
    });

    const cashierPage = (await history(door.order.cashier)).json();
    expect(cashierPage.owner).toBe(false);
    const seen = cashierPage.orders.find((each: { id: string }) => each.id === door.order.id);
    expect(seen).toMatchObject({ itemsValue: '24000', owner: null });
  });

  it('keeps a cashier to today and the 7 business days before (S12)', async () => {
    const door = await orderAtDoor();
    const today = dayOf(new Date());
    const old = `?from=${daysBefore(today, 30)}&to=${today}`;
    const refused = await history(door.order.cashier, old);
    expect(refused.statusCode).toBe(403);
    expect(refused.json().error).toBe('cashier_window');
    expect(
      (await history(door.order.cashier, `?from=${daysBefore(today, 7)}&to=${today}`)).statusCode,
    ).toBe(200);
    const owners = await owner();
    const wide = await history(owners, old);
    expect(wide.statusCode).toBe(200);
    expect(wide.json()).toMatchObject({ fromDay: daysBefore(today, 30), toDay: today });
    expect((await history(owners, `?from=${today}`)).statusCode).toBe(400);
    expect((await history(owners, `?from=${today}&to=${daysBefore(today, 1)}`)).json().error).toBe(
      'invalid_period',
    );
  });

  it('filters by status and finds an order by its number', async () => {
    const door = await orderAtDoor();
    const owners = await owner();
    const page = (await history(owners)).json();
    const number = page.orders.find((each: { id: string }) => each.id === door.order.id).number;
    const found = (await history(owners, `?number=${number}`)).json();
    expect(found.orders.map((each: { id: string }) => each.id)).toEqual([door.order.id]);
    const delivered = (await history(owners, '?status=delivered')).json();
    expect(delivered.orders.some((each: { id: string }) => each.id === door.order.id)).toBe(false);
    expect(delivered.orders.every((each: { status: string }) => each.status === 'delivered')).toBe(
      true,
    );
  });

  it('reads the pages after a cursor without repeating an order', async () => {
    const owners = await owner();
    await orderAtDoor();
    const first = (await history(owners)).json();
    expect(first.orders.length).toBeGreaterThan(0);
    if (first.next === null) return;
    const second = (await history(owners, `?cursor=${first.next}`)).json();
    const ids = new Set(first.orders.map((each: { id: string }) => each.id));
    expect(second.orders.some((each: { id: string }) => ids.has(each.id))).toBe(false);
  });
});

describe('GET /v1/merchant/orders/{orderId} (RA §8.18 detail)', () => {
  it('gives the order with its timeline, and refuses another restaurant’s order', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const answer = await app.inject({
      method: 'GET',
      url: `/v1/merchant/orders/${door.order.id}`,
      headers: door.order.cashier,
    });
    expect(answer.statusCode).toBe(200);
    const body = answer.json();
    expect(body.order).toMatchObject({ id: door.order.id, status: 'delivered', owner: null });
    expect(body.timeline.map((step: { step: string }) => step.step)).toEqual([
      'placed',
      'accepted',
      'picked_up',
      'arrived',
      'delivered',
    ]);
    const missing = await app.inject({
      method: 'GET',
      url: '/v1/merchant/orders/00000000-0000-4000-8000-000000000000',
      headers: door.order.cashier,
    });
    expect(missing.statusCode).toBe(404);
  });
});

const captainHistory = (headers: Record<string, string>, query = '') =>
  app.inject({ method: 'GET', url: `/v1/captain/orders/history${query}`, headers });

describe('GET /v1/captain/orders/history (CA §9.13)', () => {
  it('gives the pay, the custody effect and the captain’s steps, never the customer (K8)', async () => {
    const door = await orderAtDoor();
    expect(
      (
        await door.deliver({
          received: [{ currency: 'TRY', amount: '30000' }],
          change: [{ currency: 'TRY', amount: '2000' }],
        })
      ).statusCode,
    ).toBe(200);
    const answer = await captainHistory(door.captain.headers);
    expect(answer.statusCode).toBe(200);
    const page = answer.json();
    const row = page.orders.find((each: { id: string }) => each.id === door.order.id);
    expect(row).toMatchObject({
      status: 'delivered',
      outcome: 'normal',
      day: dayOf(new Date()),
      neighbourhood: expect.any(String),
      paidToRestaurant: [{ currency: 'TRY', amount: '24000' }],
      collected: [{ currency: 'TRY', amount: '30000' }],
      change: [{ currency: 'TRY', amount: '2000' }],
      handedOver: false,
    });
    expect(row.restaurantName).toEqual(expect.any(String));
    expect(BigInt(row.pay)).toBeGreaterThan(0n);
    expect(page.payCurrency).toBe('TRY');
    expect(row.steps.map((step: { step: string }) => step.step)).toEqual([
      'assigned',
      'arrived_at_restaurant',
      'picked_up',
      'arrived_at_customer',
      'delivered',
    ]);
    // K8: nothing that names or finds the customer.
    const text = JSON.stringify(row);
    for (const key of ['customer', 'phone', 'street', 'landmark', 'location', 'recipient']) {
      expect(text).not.toContain(`"${key}`);
    }
  });

  it('shows another captain nothing of it, and takes a date range', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const other = await orderAtDoor();
    const theirs = (await captainHistory(other.captain.headers)).json();
    expect(theirs.orders.some((each: { id: string }) => each.id === door.order.id)).toBe(false);
    const today = dayOf(new Date());
    const ranged = await captainHistory(
      door.captain.headers,
      `?from=${daysBefore(today, 3)}&to=${daysBefore(today, 1)}`,
    );
    expect(ranged.statusCode).toBe(200);
    expect(ranged.json().orders).toEqual([]);
    expect((await captainHistory(door.captain.headers, `?to=${today}`)).statusCode).toBe(400);
  });

  it('leaves out an order until it ends', async () => {
    const door = await orderAtDoor();
    const page = (await captainHistory(door.captain.headers)).json();
    expect(page.orders.some((each: { id: string }) => each.id === door.order.id)).toBe(false);
  });
});
