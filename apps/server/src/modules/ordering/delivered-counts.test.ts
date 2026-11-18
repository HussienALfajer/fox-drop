import { describe, expect, it } from 'vitest';
import { CustomersService } from '../customers/index.js';
import { app, orderAtDoor, restaurant, sql } from './delivery.fixture.js';

// CU §8.1 «الأكثر طلباً» (slice 2.27b, owner decision 2026-11-18): the
// orders each restaurant delivered in the period, test orders and free
// re-deliveries left out, through the port ordering registers.
const DAY = 86_400_000;

async function delivered() {
  const door = await orderAtDoor();
  expect((await door.deliver()).statusCode).toBe(200);
  return door.order.id as string;
}

describe('the delivered counts of «الأكثر طلباً»', () => {
  it('counts the deliveries since the moment, without test orders', async () => {
    const counts = () =>
      app.get(CustomersService).deliveredCounts([restaurant], new Date(Date.now() - 30 * DAY));
    const before = (await counts()).get(restaurant) ?? 0;
    await delivered();
    const test = await delivered();
    await sql.query('UPDATE ordering.orders SET test_order = true WHERE id = $1', [test]);
    // Delivered 31 days back: out of the period.
    const old = await delivered();
    await sql.query(
      `UPDATE ordering.orders SET delivered_at = now() - interval '31 days',
         placed_at = placed_at WHERE id = $1`,
      [old],
    );
    expect((await counts()).get(restaurant)).toBe(before + 1);
    expect(
      await app.get(CustomersService).deliveredCounts([], new Date(Date.now() - 30 * DAY)),
    ).toEqual(new Map());
  });
});
