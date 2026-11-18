import { describe, expect, it } from 'vitest';
import { CustomersService } from '../customers/index.js';
import { app, orderAtDoor, sql } from './delivery.fixture.js';

// AP §9.11.4 (slice 2.27d): each customer's latest delivered order in the
// city, which the mass push's «لم يطلب منذ N يوماً» and «سجّل ولم يطلب»
// read, test orders and free re-deliveries left out, through the port
// ordering registers.
const DAY = 86_400_000;

async function delivered() {
  const door = await orderAtDoor();
  expect((await door.deliver()).statusCode).toBe(200);
  const { rows } = await sql.query(
    'SELECT customer_account_id, city_id, delivered_at FROM ordering.orders WHERE id = $1',
    [door.order.id],
  );
  return { id: door.order.id as string, ...rows[0] };
}

describe('the latest deliveries of the mass push', () => {
  it("answers each customer's latest delivered order in the city", async () => {
    const first = await delivered();
    const last = () => app.get(CustomersService).lastDeliveries(first.city_id);
    expect((await last()).get(first.customer_account_id)).toEqual(first.delivered_at);

    // An older delivery and a test order never move it.
    const older = await delivered();
    await sql.query(
      "UPDATE ordering.orders SET delivered_at = now() - interval '40 days' WHERE id = $1",
      [older.id],
    );
    const test = await delivered();
    await sql.query('UPDATE ordering.orders SET test_order = true WHERE id = $1', [test.id]);
    const latest = await last();
    // The fixture gives each order a customer of its own.
    expect(latest.get(first.customer_account_id)).toEqual(first.delivered_at);
    expect(latest.get(older.customer_account_id)?.getTime()).toBeLessThan(Date.now() - 39 * DAY);
    expect(latest.has(test.customer_account_id)).toBe(false);
    // Another city has none of them.
    expect(
      await app.get(CustomersService).lastDeliveries('00000000-0000-4000-8000-000000000000'),
    ).toEqual(new Map());
  });
});
