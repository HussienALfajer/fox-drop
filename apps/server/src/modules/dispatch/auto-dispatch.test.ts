import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { afterEach, beforeAll, describe, expect, it } from 'vitest';
import { QUEUES } from '../../jobs/job-queue.js';
import { GeoService, type Point } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { AutoDispatcher, DispatchService } from './index.js';
import {
  app,
  sql,
  db,
  azaz,
  change,
  bySystem,
  allWeek,
  SECOND,
  admin,
  acceptedOrder,
  onlineCaptain,
  orderRow,
  outboxTypes,
  offerRow,
} from './dispatch.fixture.js';

// AP §9.12.6 «آلي» and «مختلط» (slice 2.15b): the dispatcher's pass over the
// city, at a restaurant about 5 km north of the main one, so the manual
// tests' captains are beyond dispatch.search_radius_km.
describe('automatic dispatch (AP §9.12.6, CA §8.1)', () => {
  const north = { latitude: 36.632, longitude: 37.046 };
  const northHome = { latitude: 36.634, longitude: 37.046 };
  let at: { restaurant: string; item: string; home: Point };
  const started: Awaited<ReturnType<typeof onlineCaptain>>[] = [];
  const dispatch = () => app.get(DispatchService);
  const update = (key: 'dispatch.mode' | 'dispatch.max_offers_before_manual', value: unknown) =>
    app.get(SettingsService).update(key, { cityId: azaz }, value as never, bySystem);
  const mode = (value: 'manual' | 'auto' | 'mixed') => update('dispatch.mode', value);

  beforeAll(async () => {
    const merchants = app.get(MerchantsService);
    const id = await merchants.createRestaurant(
      azaz,
      {
        nameAr: 'مطعم الشمال',
        location: north,
        coverage: { kind: 'radius', radiusMetres: 1000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    await merchants.setAccountStatus(id, 'active', change);
    await merchants.setWeeklySchedule(id, allWeek, change);
    const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
    const northItem = await merchants.addItem(
      id,
      { categoryId: category, name: 'فلافل', price: { amount: 12_000n, currency: 'TRY' } },
      change,
    );
    at = { restaurant: id, item: northItem, home: northHome };
  });

  // Each test's orders leave automatic dispatch after it (the dispatcher
  // would otherwise offer a test's order still waiting to the next test's
  // nearest captain), its captains go offline (a busy one cannot, and is not
  // eligible anyway), and the city goes back to manual.
  afterEach(async () => {
    await sql.query(
      `INSERT INTO dispatch.manual_orders (order_id, order_placed_at, city_id, reason, failed_offers, at)
       SELECT id, placed_at, city_id, 'max_offers', 0, now() FROM ordering.orders WHERE restaurant_id = $1
       ON CONFLICT DO NOTHING`,
      [at.restaurant],
    );
    for (const captain of started.splice(0)) {
      await captain.call('POST', '/v1/captain/availability/offline');
    }
    await mode('manual');
    await update('dispatch.max_offers_before_manual', 5);
  });

  // A captain the given metres north of the restaurant.
  async function captainNorth(metres: number) {
    const captain = await onlineCaptain({
      latitude: north.latitude + metres / 111_195,
      longitude: north.longitude,
    });
    started.push(captain);
    return captain;
  }

  // An accepted order at the north restaurant, its search started (the
  // worker's job), «طلب بلا كابتن» an hour away.
  async function searchingOrder() {
    const order = await acceptedOrder(at);
    await sql.query(
      `UPDATE ordering.orders SET captain_track = 'searching', search_started_at = now(),
         search_alert_at = now() + interval '1 hour' WHERE id = $1`,
      [order.id],
    );
    return order;
  }

  const offersOf = async (orderId: string) =>
    (
      await sql.query(
        'SELECT captain_id, kind, offered_by, status FROM dispatch.offers WHERE order_id = $1 ORDER BY offered_at',
        [orderId],
      )
    ).rows;

  const openOffer = async (orderId: string) =>
    (await offersOf(orderId)).find((offer) => offer.status === 'open');

  const currentOffer = async (captain: Awaited<ReturnType<typeof onlineCaptain>>) =>
    (await captain.call('GET', '/v1/captain/offers/current')).json().offer;

  const manualRow = async (orderId: string) =>
    (
      await sql.query(
        'SELECT reason, failed_offers FROM dispatch.manual_orders WHERE order_id = $1',
        [orderId],
      )
    ).rows;

  it('sends nothing in manual mode (D6)', async () => {
    const order = await searchingOrder();
    await captainNorth(300);
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await offersOf(order.id)).toEqual([]);
  });

  it('offers the nearest eligible captain, passing over one above its «أقصى مبلغ أحمله» (C4)', async () => {
    await mode('auto');
    const order = await searchingOrder();
    await captainNorth(1500);
    const near = await captainNorth(600);
    const nearest = await captainNorth(200);
    // 100 TRY, below the order's 120 TRY of items.
    const limited = await app.inject({
      method: 'PUT',
      url: '/v1/captain/settings/max-pickup-amount',
      headers: nearest.headers,
      payload: { amount: '10000' },
    });
    expect(limited.statusCode).toBe(200);
    await dispatch().autoDispatchCity(azaz, new Date());
    expect(await offersOf(order.id)).toEqual([
      { captain_id: near.captainId, kind: 'auto', offered_by: null, status: 'open' },
    ]);
    expect(await orderRow(order.id)).toMatchObject({ captain_track: 'offered' });
    const event = await sql.query(
      "SELECT actor_type FROM ordering.order_events WHERE order_id = $1 AND type = 'order.offered'",
      [order.id],
    );
    expect(event.rows).toEqual([{ actor_type: 'system' }]);
    const job = await sql.query(
      "SELECT 1 FROM pgboss.job WHERE name = $1 AND data->>'orderId' = $2",
      [QUEUES.offerExpiry, order.id],
    );
    expect(job.rowCount).toBe(1);
    // CA §8.2: an automatic offer is not «تعيين من العمليات».
    const offer = await currentOffer(near);
    expect(offer).toMatchObject({ fromOperations: false, pay: { amount: '2500' } });
    expect(offer.restaurant.distanceMetres).toBeGreaterThan(500);
    // One offer at a time: the next pass leaves the order alone.
    await dispatch().autoDispatchCity(azaz, new Date());
    expect(await offersOf(order.id)).toHaveLength(1);
    // Accepted, the order is the captain's.
    const accepted = await near.call('POST', `/v1/captain/offers/${offer.id}/accept`);
    expect(accepted.statusCode).toBe(200);
    expect(await orderRow(order.id)).toMatchObject({ captain_id: near.captainId });
  });

  it('offers the next captain on a decline, an expiry or a withdrawal, never one already offered', async () => {
    await mode('auto');
    const order = await searchingOrder();
    const first = await captainNorth(200);
    const second = await captainNorth(400);
    const third = await captainNorth(600);
    const fourth = await captainNorth(800);

    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(first.captainId);
    await first.call('POST', `/v1/captain/offers/${(await currentOffer(first)).id}/decline`);

    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(second.captainId);
    const job = {
      offerId: (await currentOffer(second)).id,
      orderId: order.id,
      orderPlacedAt: order.placedAt,
    };
    expect(await dispatch().expire(job, new Date(Date.now() + 46 * SECOND))).toBe(true);

    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(third.captainId);
    // Going offline withdraws the offer (CA §7.5).
    await third.call('POST', '/v1/captain/availability/offline');

    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(fourth.captainId);
    await fourth.call('POST', `/v1/captain/offers/${(await currentOffer(fourth)).id}/decline`);

    // No captain left who was not offered: nothing, and no new search for
    // 30 seconds; one who comes online meanwhile gets it after them.
    const start = Date.now();
    expect(await dispatch().autoDispatchCity(azaz, new Date(start))).toBe(0);
    const fifth = await captainNorth(1000);
    await dispatch().autoDispatchCity(azaz, new Date(start + 20 * SECOND));
    expect(await openOffer(order.id)).toBeUndefined();
    await dispatch().autoDispatchCity(azaz, new Date(start + 31 * SECOND));
    expect((await openOffer(order.id))?.captain_id).toBe(fifth.captainId);
    expect((await offersOf(order.id)).map((offer) => offer.status)).toEqual([
      'declined',
      'expired',
      'withdrawn',
      'declined',
      'open',
    ]);
  });

  it('passes over a captain with another open offer', async () => {
    await mode('auto');
    const first = await searchingOrder();
    const second = await searchingOrder();
    const near = await captainNorth(200);
    const far = await captainNorth(900);
    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(first.id))?.captain_id).toBe(near.captainId);
    expect((await openOffer(second.id))?.captain_id).toBe(far.captainId);
  });

  it('«مختلط»: leaves automatic dispatch after dispatch.max_offers_before_manual failed offers', async () => {
    await mode('mixed');
    await update('dispatch.max_offers_before_manual', 2);
    const order = await searchingOrder();
    const first = await captainNorth(200);
    const second = await captainNorth(400);
    const third = await captainNorth(600);
    for (const captain of [first, second]) {
      await dispatch().autoDispatchCity(azaz, new Date());
      await captain.call('POST', `/v1/captain/offers/${(await currentOffer(captain)).id}/decline`);
    }
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await offersOf(order.id)).toHaveLength(2);
    expect(await manualRow(order.id)).toEqual([{ reason: 'max_offers', failed_offers: 2 }]);
    // «بحاجة لتعيين»: operations offer it by hand.
    expect(await orderRow(order.id)).toMatchObject({ captain_track: 'searching' });
    const assigned = await (await admin(['OPS'])).assign(order.id, third.captainId);
    expect(assigned.statusCode).toBe(200);
  });

  // The order's card on the board.
  const cardOf = async (orderId: string) =>
    (
      (await (await admin(['SUP'])).get(`/v1/admin/orders?cityId=${azaz}`)).json().orders as {
        id: string;
      }[]
    ).find((each) => each.id === orderId) as Record<string, unknown>;

  it('shows the dispatch state on the card: «بحاجة لتعيين» only once the order left automatic dispatch', async () => {
    await mode('mixed');
    await update('dispatch.max_offers_before_manual', 2);
    const order = await searchingOrder();
    expect(await cardOf(order.id)).toMatchObject({
      captainTrack: 'searching',
      badges: { needsAssignment: false },
      dispatch: { mode: 'mixed', manual: null, autoOffers: 0, maxOffers: 2 },
    });
    const first = await captainNorth(200);
    const second = await captainNorth(400);
    await dispatch().autoDispatchCity(azaz, new Date());
    expect(await cardOf(order.id)).toMatchObject({
      captainTrack: 'offered',
      dispatch: { autoOffers: 1, autoOfferOpen: true, maxOffers: 2 },
    });
    for (const captain of [first, second]) {
      if (captain === second) await dispatch().autoDispatchCity(azaz, new Date());
      await captain.call('POST', `/v1/captain/offers/${(await currentOffer(captain)).id}/decline`);
    }
    await dispatch().autoDispatchCity(azaz, new Date());
    const card = await cardOf(order.id);
    expect(card).toMatchObject({
      badges: { needsAssignment: true },
      dispatch: { mode: 'mixed', manual: { reason: 'max_offers' }, autoOffers: 2 },
    });
    // The move is an event of the order, so the board hears it (AP §9.3.1).
    const event = await sql.query(
      "SELECT actor_type, reason FROM ordering.order_events WHERE order_id = $1 AND type = 'order.moved_to_manual'",
      [order.id],
    );
    expect(event.rows).toEqual([{ actor_type: 'system', reason: 'max_offers' }]);
    expect(await outboxTypes(order.id)).toContain('order.moved_to_manual');
    // In «آلي» there is no limit; in «يدوي» every searching order needs
    // assignment (D6).
    const other = await searchingOrder();
    await mode('auto');
    expect(await cardOf(other.id)).toMatchObject({
      badges: { needsAssignment: false },
      dispatch: { mode: 'auto', manual: null, maxOffers: null },
    });
    await mode('manual');
    expect(await cardOf(other.id)).toMatchObject({
      badges: { needsAssignment: true },
      dispatch: { mode: 'manual' },
    });
  });

  it('«توزيع يدوي لهذا الطلب»: takes the order out, its open offer keeping its time (AP §9.3.2)', async () => {
    await mode('auto');
    const order = await searchingOrder();
    const first = await captainNorth(200);
    await captainNorth(400);
    await dispatch().autoDispatchCity(azaz, new Date());
    const offer = await currentOffer(first);
    expect(offer).not.toBeNull();

    const ops = await admin(['OPS']);
    const key = randomUUID();
    const moved = await ops.manualDispatch(order.id, key);
    expect(moved.statusCode).toBe(200);
    expect(moved.json().order).toMatchObject({
      captainTrack: 'offered',
      offer: { id: offer.id, captainId: first.captainId },
    });
    const row = await sql.query(
      'SELECT reason, failed_offers, by FROM dispatch.manual_orders WHERE order_id = $1',
      [order.id],
    );
    expect(row.rows).toEqual([{ reason: 'operations', failed_offers: 0, by: ops.accountId }]);
    const event = await sql.query(
      "SELECT actor_type, actor_id, reason FROM ordering.order_events WHERE order_id = $1 AND type = 'order.moved_to_manual'",
      [order.id],
    );
    expect(event.rows).toEqual([
      { actor_type: 'admin', actor_id: ops.accountId, reason: 'operations' },
    ]);
    const audit = await sql.query(
      "SELECT 1 FROM audit.events WHERE action = 'order.manual_dispatch' AND target_id = $1",
      [order.id],
    );
    expect(audit.rowCount).toBe(1);
    // A repeat answers again; another key finds it out already.
    expect((await ops.manualDispatch(order.id, key)).statusCode).toBe(200);
    const again = await ops.manualDispatch(order.id);
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('order_not_automatic');

    // The open offer keeps its time; declined, no automatic offer follows.
    expect((await offerRow(offer.id)).status).toBe('open');
    await first.call('POST', `/v1/captain/offers/${offer.id}/decline`);
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await cardOf(order.id)).toMatchObject({
      captainTrack: 'searching',
      badges: { needsAssignment: true },
      dispatch: { mode: 'auto', manual: { reason: 'operations' }, autoOffers: 1 },
    });
  });

  it('«توزيع يدوي لهذا الطلب» in «مختلط» keeps the failed offers, and works on a placed order', async () => {
    await mode('mixed');
    const order = await searchingOrder();
    const first = await captainNorth(200);
    await dispatch().autoDispatchCity(azaz, new Date());
    await first.call('POST', `/v1/captain/offers/${(await currentOffer(first)).id}/decline`);
    const ops = await admin(['OPS']);
    const key = randomUUID();
    expect((await ops.manualDispatch(order.id, key)).statusCode).toBe(200);
    expect(await manualRow(order.id)).toEqual([{ reason: 'operations', failed_offers: 1 }]);
    expect(await cardOf(order.id)).toMatchObject({
      badges: { needsAssignment: true },
      dispatch: { autoOffers: 1, autoOfferOpen: false },
    });
    // The key belongs to that order's move (architecture §5.3).
    const other = await searchingOrder();
    const reused = await ops.manualDispatch(other.id, key);
    expect(reused.statusCode).toBe(422);
    expect(reused.json().error).toBe('idempotency_key_reused');

    // AP §9.3.2 «Before assignment»: an order the restaurant has not
    // accepted yet leaves too, and its automatic cancellation still runs.
    const fresh = await acceptedOrder(at, { accept: false });
    expect((await ops.manualDispatch(fresh.id)).statusCode).toBe(200);
    expect(await manualRow(fresh.id)).toEqual([{ reason: 'operations', failed_offers: 0 }]);
    expect(await orderRow(fresh.id)).toMatchObject({ status: 'placed', version: 2 });
  });

  it('refuses «توزيع يدوي لهذا الطلب» in manual mode, after assignment, and to SUP', async () => {
    const order = await searchingOrder();
    const ops = await admin(['OPS']);
    const manual = await ops.manualDispatch(order.id);
    expect(manual.statusCode).toBe(409);
    expect(manual.json().error).toBe('order_not_automatic');
    await mode('auto');
    expect((await (await admin(['SUP'])).manualDispatch(order.id)).statusCode).toBe(403);
    expect((await ops.manualDispatch(randomUUID())).statusCode).toBe(404);
    const captain = await captainNorth(200);
    expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
    await captain.call('POST', `/v1/captain/offers/${(await currentOffer(captain)).id}/accept`);
    const assigned = await ops.manualDispatch(order.id);
    expect(assigned.statusCode).toBe(409);
    expect(assigned.json().error).toBe('order_not_assignable');
  });

  it("lists the order's offers with the captain, the answer and the response time (AP §9.7.4)", async () => {
    await mode('auto');
    const order = await searchingOrder();
    const first = await captainNorth(200);
    const second = await captainNorth(400);
    await dispatch().autoDispatchCity(azaz, new Date());
    await first.call('POST', `/v1/captain/offers/${(await currentOffer(first)).id}/decline`);
    await dispatch().autoDispatchCity(azaz, new Date());
    const sup = await admin(['SUP']);
    const log = await sup.get(`/v1/admin/orders/${order.id}/offers`);
    expect(log.statusCode).toBe(200);
    const offers = log.json().offers as Record<string, unknown>[];
    expect(offers).toMatchObject([
      {
        captain: { id: first.captainId, name: 'كابتن التوزيع' },
        kind: 'auto',
        handover: false,
        status: 'declined',
      },
      {
        captain: { id: second.captainId },
        kind: 'auto',
        status: 'open',
        respondedAt: null,
        responseSec: null,
      },
    ]);
    expect(offers[0]!.responseSec).toEqual(expect.any(Number));
    expect(offers[0]!.respondedAt).toEqual(expect.any(String));
    expect((await sup.get(`/v1/admin/orders/${randomUUID()}/offers`)).statusCode).toBe(404);
    expect(
      (await (await admin(['DATA'])).get(`/v1/admin/orders/${order.id}/offers`)).statusCode,
    ).toBe(403);
  });

  it('«مختلط»: leaves automatic dispatch at the no-captain alert, while «آلي» keeps searching', async () => {
    const order = await searchingOrder();
    const captain = await captainNorth(200);
    await sql.query(
      "UPDATE ordering.orders SET search_alert_at = now() - interval '1 second' WHERE id = $1",
      [order.id],
    );
    await mode('auto');
    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(captain.captainId);
    await captain.call('POST', `/v1/captain/offers/${(await currentOffer(captain)).id}/decline`);

    await mode('mixed');
    await captainNorth(300);
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await manualRow(order.id)).toEqual([{ reason: 'no_captain_alert', failed_offers: 1 }]);
    // Back in «آلي», an order left to operations stays theirs.
    await mode('auto');
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await offersOf(order.id)).toHaveLength(1);
  });
});

describe('the dispatcher role (architecture §4.4)', () => {
  // Only this file's database: the run's other test files share the server.
  const advisoryLocks = async () =>
    (
      await sql.query<{ n: number }>(
        "SELECT count(*)::int AS n FROM pg_locks WHERE locktype = 'advisory' AND database = (SELECT oid FROM pg_database WHERE datname = current_database())",
      )
    ).rows[0]?.n;

  it('leads each city from one process at a time, and hands over when it stops', async () => {
    const passes: string[] = [];
    const counting = (name: string) =>
      ({
        autoDispatchCity: (cityId: string) => {
          if (cityId === azaz) passes.push(name);
          return Promise.resolve(0);
        },
      }) as unknown as DispatchService;
    const first = new AutoDispatcher(db, app.get(GeoService), counting('first'));
    const second = new AutoDispatcher(db, app.get(GeoService), counting('second'));
    try {
      await first.tick();
      await second.tick();
      await first.tick();
      expect(passes).toEqual(['first', 'first']);
      await first.onModuleDestroy();
      // Stopping waits until the server freed the lock, not only until the
      // end was sent: a busy server let `second` find it still held.
      expect(await advisoryLocks()).toBe(0);
      await second.tick();
      expect(passes).toEqual(['first', 'first', 'second']);
      // The leader's session ends on the server: it connects again and
      // takes the free lock at its next tick, so the city keeps one leader.
      // Only this file's database: the run's other test files share the
      // server and the role.
      await sql.query(
        "SELECT pg_terminate_backend(pid) FROM pg_locks WHERE locktype = 'advisory' AND pid <> pg_backend_pid() AND database = (SELECT oid FROM pg_database WHERE datname = current_database())",
      );
      await second.tick();
      await second.tick();
      expect(passes.at(-1)).toBe('second');
      const third = new AutoDispatcher(db, app.get(GeoService), counting('third'));
      try {
        await third.tick();
        expect(passes).not.toContain('third');
      } finally {
        await third.onModuleDestroy();
      }
    } finally {
      await first.onModuleDestroy();
      await second.onModuleDestroy();
    }
  });

  it('keeps a fallback to manual as logged: the application role cannot change it', async () => {
    await expect(
      sql.query("UPDATE dispatch.manual_orders SET reason = 'max_offers'"),
    ).rejects.toThrow(/permission denied/);
    // Operations' move names its admin, and only it does (a CHECK).
    const insert = (reason: string, by: string | null) =>
      sql.query(
        `INSERT INTO dispatch.manual_orders (order_id, order_placed_at, city_id, reason, failed_offers, at, by)
         VALUES ($1, now(), $2, $3, 0, now(), $4)`,
        [randomUUID(), azaz, reason, by],
      );
    await expect(insert('operations', null)).rejects.toThrow(/manual_orders_by/);
    await expect(insert('max_offers', randomUUID())).rejects.toThrow(/manual_orders_by/);
  });
});
