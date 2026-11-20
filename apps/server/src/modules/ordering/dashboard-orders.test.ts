import { describe, expect, it } from 'vitest';
import { DashboardOrdersService } from './dashboard-orders.js';
import {
  acceptedOrder,
  admin,
  app,
  azaz,
  orderAtDoor,
  restaurant,
  sql,
} from './delivery.fixture.js';

// «لوحة التحكم» (AP §9.1; slice 2.40): the orders the dashboard counts, and
// its route through the API.
const MINUTE = 60_000;
const DAY = 86_400_000;

async function deliveredOrder() {
  const door = await orderAtDoor();
  expect((await door.deliver()).statusCode).toBe(200);
}

const dashboardOf = async (roles: string[]) =>
  (await admin(roles)).get(`/v1/admin/dashboard?cityId=${azaz}`);

describe("the dashboard's orders", () => {
  it('reads the window, test orders left out, with the first order and lateness', async () => {
    const orders = app.get(DashboardOrdersService);
    const from = new Date(Date.now() - MINUTE);
    await deliveredOrder();
    await acceptedOrder();
    const test = (await acceptedOrder()).id;
    await sql.query('UPDATE ordering.orders SET test_order = true WHERE id = $1', [test]);
    const now = new Date();
    const rows = await orders.placedBetween(azaz, from, new Date(now.getTime() + MINUTE), now);
    expect(rows.map((row) => row.status).sort()).toEqual(['accepted', 'delivered']);
    // Each customer is new.
    expect(rows.every((row) => row.firstOrder)).toBe(true);
    expect(rows.every((row) => !row.late && !row.rejected)).toBe(true);
    // Past the prep time chosen (20 minutes) and still not ready: late.
    const later = new Date(now.getTime() + 25 * MINUTE);
    const late = await orders.placedBetween(azaz, from, later, later);
    expect(late.find((row) => row.status === 'accepted')?.late).toBe(true);
    expect(late.find((row) => row.status === 'delivered')?.late).toBe(false);
  });

  it('answers today against the same weekday last week up to the same moment', async () => {
    const own = await admin(['OWN']);
    const read = async () => {
      const answer = await own.get(`/v1/admin/dashboard?cityId=${azaz}`);
      expect(answer.statusCode).toBe(200);
      return answer.json();
    };
    const before = await read();
    await deliveredOrder();
    await acceptedOrder();
    const after = await read();
    expect(after.today.orders.placed).toBe(before.today.orders.placed + 2);
    expect(after.today.orders.delivered).toBe(before.today.orders.delivered + 1);
    expect(after.today.orders.inProgress).toBe(before.today.orders.inProgress + 1);
    expect(after.today.orders.firstOrders).toBe(before.today.orders.firstOrders + 2);
    expect(after.today.newCustomers).toBeGreaterThanOrEqual(before.today.newCustomers + 2);
    expect(after.today.money.currency).toBe('TRY');
    expect(BigInt(after.today.money.gmv)).toBeGreaterThan(BigInt(before.today.money.gmv));
    expect(
      after.hours.reduce((total: number, hour: { today: number }) => total + hour.today, 0),
    ).toBe(after.today.orders.placed);
    expect(after.topRestaurants[0]).toMatchObject({ restaurantId: restaurant });
    expect(after.status.restaurants.open + after.status.restaurants.busy).toBeGreaterThan(0);
    expect(after.status.withoutDevice).toBeNull();
    // Last week: the business day 7 days before, read to the same moment.
    expect(Date.parse(after.day) - Date.parse(after.lastWeekDay)).toBe(7 * DAY);
    expect(Date.parse(after.lastWeek.until) - Date.parse(after.lastWeek.from)).toBe(
      Date.parse(after.today.until) - Date.parse(after.today.from),
    );
    expect(after.lastWeek.orders.placed).toBe(0);
  });

  it('gives each role its tasks', async () => {
    const keys = async (roles: string[]) =>
      (await dashboardOf(roles)).json().tasks.map((task: { key: string }) => task.key);
    expect(await keys(['SUP'])).toEqual([]);
    const ops = await keys(['OPS']);
    expect(ops).toContain('menuChanges');
    expect(ops).not.toContain('settlementsDue');
    const fin = await keys(['FIN']);
    expect(fin).toContain('settlementsDue');
    expect(fin).not.toContain('menuChanges');
    expect((await dashboardOf(['DATA'])).statusCode).toBe(403);
  });
});
