import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { MerchantAccountsService } from '../identity/index.js';
import {
  admin,
  app,
  appSignIn,
  azaz,
  change,
  orderAtDoor,
  phoneNumber,
  placedOrder,
  restaurant,
} from './delivery.fixture.js';

// L.1a: what the restaurant's reads show against the panel (RA §11, DoD
// RA-21) and what they never show (RA §8.4, R11, DoD RA-23). The fixture's
// restaurant has this file's orders only.

async function owner() {
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurant, { role: 'owner', name: 'owner', phone }, change);
  return appSignIn('merchant', phone);
}

const get = (headers: Record<string, string>, url: string) =>
  app.inject({ method: 'GET', url, headers });

// Two delivered orders, the first rated: the items value 24000 each, the
// delivery fee 4000, the customer's total 28000.
async function twoDelivered() {
  const doors = [await orderAtDoor(), await orderAtDoor()];
  for (const door of doors) expect((await door.deliver()).statusCode).toBe(200);
  const rated = await app.inject({
    method: 'POST',
    url: `/v1/customer/orders/${doors[0]!.order.id}/rating`,
    headers: doors[0]!.order.customer,
    payload: { restaurant: { stars: 4, reasons: [], comment: null }, captain: null },
  });
  expect(rated.statusCode, rated.body).toBe(200);
  return doors;
}

// A placed order the restaurant rejects as too busy, which pauses nothing.
async function rejectedOrder() {
  const order = await placedOrder();
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${order.id}/reject`,
    headers: { ...order.cashier, 'idempotency-key': randomUUID() },
    payload: { reason: 'too_busy', items: [], busyExtraMin: null, pauseMin: null },
  });
  expect(answer.statusCode, answer.body).toBe(200);
}

let delivered: Awaited<ReturnType<typeof twoDelivered>> | undefined;
const deliveredOrders = async () => (delivered ??= await twoDelivered());

describe("the restaurant's reports match the panel's (RA §11)", () => {
  it('gives the same orders, sales, acceptance, rejections, late rate, rating and pauses for a day', async () => {
    await deliveredOrders();
    await rejectedOrder();
    const own = await admin(['OWN']);
    const day = (await own.get(`/v1/admin/dashboard?cityId=${azaz}`)).json().day as string;

    const app_ = await get(await owner(), `/v1/merchant/figures?day=${day}`);
    expect(app_.statusCode, app_.body).toBe(200);
    const figures = app_.json().current;

    const panel = await own.get(
      `/v1/admin/reports/restaurants?cityId=${azaz}&from=${day}&to=${day}`,
    );
    expect(panel.statusCode, panel.body).toBe(200);
    const ranking = panel
      .json()
      .tables.find((table: { key: string }) => table.key === 'ranking') as {
      columns: { key: string }[];
      rows: { label: string; cells: (string | null)[] }[];
    };
    const row = ranking.rows.find((each) => each.label === 'مطعم الاستلام')!;
    const cell = (key: string) => row.cells[ranking.columns.findIndex((each) => each.key === key)];
    const bp = (value: number | null) => (value === null ? null : String(value));

    // Non-zero orders, sales, acceptance, rejections and ratings, so the
    // comparisons below compare something. The unanswered count and the
    // pauses stay zero: either would close the restaurant this file orders from.
    expect(figures).toMatchObject({
      received: 3,
      delivered: 2,
      sales: '48000',
      rejected: 1,
      rating: { count: 1 },
    });
    expect(figures.acceptanceBp).toBeGreaterThan(0);
    expect(cell('orders')).toBe(String(figures.received));
    expect(cell('sales')).toBe(figures.sales);
    // Every order was accepted by the restaurant itself, so «نسبة القبول»
    // counts the same orders in both.
    expect(figures.acceptedByOperations).toBe(0);
    expect(cell('acceptance')).toBe(bp(figures.acceptanceBp));
    expect(cell('rejections')).toBe(String(figures.rejected));
    expect(cell('unanswered')).toBe(String(figures.unanswered));
    expect(cell('late_rate')).toBe(bp(figures.lateBp));
    expect(cell('ratings')).toBe(String(figures.rating.count));
    expect(cell('pause_minutes')).toBe(
      String(
        figures.pauseMinutes.restaurant + figures.pauseMinutes.ops + figures.pauseMinutes.auto,
      ),
    );
  });
});

describe("the restaurant never sees the delivery fee or the customer's total (RA §8.4, R11)", () => {
  it('leaves them out of the board, the order, the history and the reports, for owners and cashiers', async () => {
    const [door] = await deliveredOrders();
    // A live order on the board too.
    const live = await orderAtDoor();
    const owners = await owner();
    const reads = [
      '/v1/merchant/orders',
      `/v1/merchant/orders/${door!.order.id}`,
      `/v1/merchant/orders/${live.order.id}`,
      '/v1/merchant/orders/history',
      '/v1/merchant/figures?period=today',
    ];
    for (const headers of [owners, door!.order.cashier]) {
      for (const url of reads) {
        const answer = await get(headers, url);
        if (answer.statusCode === 403) {
          // The reports are the owners' (RA §11).
          expect(url).toContain('figures');
          continue;
        }
        expect(answer.statusCode, `${url}: ${answer.body}`).toBe(200);
        const text = answer.body;
        expect(text, url).not.toMatch(/"deliveryFee|"total|"customerTotal|"amountDue/i);
        // The fee (4000) and the total (28000) under any other name.
        expect(text, url).not.toContain('"4000"');
        expect(text, url).not.toContain('"28000"');
        // Nor the sums of the two delivered orders' fees (8000) and totals (56000).
        expect(text, url).not.toContain('"8000"');
        expect(text, url).not.toContain('"56000"');
      }
    }
    expect((await live.deliver()).statusCode).toBe(200);
  });
});
