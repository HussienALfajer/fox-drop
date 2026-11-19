import 'reflect-metadata';
import { describe, expect, it } from 'vitest';
import { CaptainsService } from '../captains/index.js';
import { AcceptanceReviews, DispatchService } from '../dispatch/index.js';
import { GeoService } from '../geo/index.js';
import { AlertsService } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { admin, app, db, orderAtDoor, sql } from './delivery.fixture.js';

// AP §9.7.6, CA §11.1–11.3 (slice 2.36b): the acceptance review task and
// the captain's «أدائي».

// Offers of the captain on the order, newest first by the statuses given.
async function offersOf(orderId: string, captainId: string, statuses: string[], minutesAgo = 100) {
  for (const [index, status] of statuses.entries()) {
    await sql.query(
      `INSERT INTO dispatch.offers (city_id, order_id, order_placed_at, captain_id, kind,
         offered_by, offered_at, expires_at, status, responded_at, pickup_metres)
       SELECT city_id, id, placed_at, $2, 'auto', NULL,
              now() - make_interval(mins => $3), now() - make_interval(mins => $3) + interval '45 seconds',
              $4, now() - make_interval(mins => $3) + interval '10 seconds', 100
         FROM ordering.orders WHERE id = $1`,
      [orderId, captainId, minutesAgo + index, status],
    );
  }
}

const reviews = () =>
  new AcceptanceReviews(
    db,
    app.get(DispatchService),
    app.get(CaptainsService),
    app.get(GeoService),
    app.get(SettingsService),
    app.get(AlertsService),
  );

const reviewOpen = async (captainId: string) =>
  (
    await sql.query(
      "SELECT count(*)::int AS n FROM notifications.alerts WHERE code = 'acceptance_review' AND subject_id = $1 AND resolved_at IS NULL",
      [captainId],
    )
  ).rows[0].n as number;

describe('the acceptance review (AP §9.7.6)', () => {
  it('opens below captain.acceptance_review_pct and closes once the rate is back', async () => {
    const door = await orderAtDoor();
    const { captainId } = door.captain;
    // 1 accepted of 3 answered: 33%, below 50%.
    await offersOf(door.order.id, captainId, ['declined', 'expired', 'accepted', 'withdrawn']);
    await reviews().run(new Date());
    expect(await reviewOpen(captainId)).toBe(1);
    // A second run keeps the one alert.
    await reviews().run(new Date());
    expect(await reviewOpen(captainId)).toBe(1);
    // Three accepted since: 4 of 6, 67%.
    await offersOf(door.order.id, captainId, ['accepted', 'accepted', 'accepted'], 10);
    await reviews().run(new Date());
    expect(await reviewOpen(captainId)).toBe(0);
  });
});

describe('«أدائي» (CA §11.1–11.3)', () => {
  it('answers the rate with its offers and warning, on time and the violations', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const { captainId, headers } = door.captain;
    // 2 accepted of 3 answered: 67%, below 70%.
    await offersOf(door.order.id, captainId, ['accepted', 'withdrawn', 'declined', 'accepted']);
    const ops = await admin(['OPS']);
    expect(
      (
        await ops.post(`/v1/admin/captains/${captainId}/violations`, {
          severe: false,
          typeCode: 'no_helmet',
          typeNote: null,
          step: 'warning',
          orderId: door.order.id,
          reason: 'شوهد بلا خوذة',
        })
      ).statusCode,
    ).toBe(201);

    const read = await app.inject({ method: 'GET', url: '/v1/captain/performance', headers });
    expect(read.statusCode).toBe(200);
    const body = read.json();
    expect(body.acceptance).toMatchObject({
      rate: 67,
      accepted: 2,
      answered: 3,
      windowOffers: 50,
      warn: true,
      alertPct: 70,
    });
    expect(body.acceptance.offers.map((offer: { response: string }) => offer.response)).toEqual([
      'accepted',
      'declined',
      'accepted',
    ]);
    expect(body.acceptance.offers[0].restaurantName).toEqual(expect.any(String));
    expect(body).toMatchObject({
      onTime: { onTime: 1, counted: 1 },
      cancellations: 0,
      windowDays: 90,
    });
    expect(body.violations).toEqual([
      expect.objectContaining({
        type: 'عدم ارتداء الخوذة',
        step: 'warning',
        orderNumber: expect.any(String),
        suspendedUntil: null,
        appeal: null,
      }),
    ]);
  });
});
