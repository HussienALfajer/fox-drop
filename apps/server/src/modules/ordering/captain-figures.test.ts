import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { CaptainFiguresService } from './captain-figures.js';
import { app, azaz, orderAtDoor, sql } from './delivery.fixture.js';

// AP §9.7.3–9.7.4, CA §11.2 (slice 2.36a): a captain's orders today, the
// on-time rate over the last 50 delivered and the captain cancellations in
// the violation window.
const figuresOf = async (captainId: string) =>
  (await app.get(CaptainFiguresService).ofCaptains(azaz, [captainId], new Date())).get(captainId)!;

describe('CaptainFiguresService.ofCaptains', () => {
  it('counts a delivery today and on time, then late once the promise is earlier', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const { captainId } = door.captain;
    expect(await figuresOf(captainId)).toEqual({
      ordersToday: 1,
      delivered: 1,
      onTime: { onTime: 1, counted: 1 },
      cancellations: 0,
      rating: null,
    });
    await sql.query(
      "UPDATE ordering.orders SET promised_at = delivered_at - interval '1 minute' WHERE id = $1",
      [door.order.id],
    );
    expect((await figuresOf(captainId)).onTime).toEqual({ onTime: 0, counted: 1 });
  });

  it('counts a withdrawal by the captain’s fault within the window only', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const { captainId } = door.captain;
    const withdrawal = (faulty: boolean, daysAgo: number) =>
      sql.query(
        `INSERT INTO ordering.reassignments
           (order_id, order_placed_at, city_id, captain_id, reason, reason_label, captain_fault,
            note, admin_id, at)
         SELECT id, placed_at, city_id, $2, 'other', 'أخرى', $3, 'x', $4,
                now() - make_interval(days => $5)
           FROM ordering.orders WHERE id = $1`,
        [door.order.id, captainId, faulty, randomUUID(), daysAgo],
      );
    await withdrawal(true, 1);
    await withdrawal(false, 1);
    await withdrawal(true, 91);
    expect((await figuresOf(captainId)).cancellations).toBe(1);
  });

  it('answers zeros for a captain with no order', async () => {
    expect(await figuresOf(randomUUID())).toEqual({
      ordersToday: 0,
      delivered: 0,
      onTime: { onTime: 0, counted: 0 },
      cancellations: 0,
      rating: null,
    });
  });
});
