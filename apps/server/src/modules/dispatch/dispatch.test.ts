import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { QUEUES } from '../../jobs/job-queue.js';
import { CaptainsService, localClock, PeakBonusService } from '../captains/index.js';
import { MerchantAccountsService } from '../identity/index.js';
import { SettingsService } from '../settings/index.js';
import { DispatchService } from './index.js';
import {
  app,
  sql,
  migrator,
  azaz,
  restaurant,
  change,
  bySystem,
  centre,
  captainSpot,
  SECOND,
  phoneNumber,
  appSignIn,
  admin,
  acceptedOrder,
  onlineCaptain,
  orderRow,
  outboxTypes,
  offerRow,
} from './dispatch.fixture.js';

describe('POST /v1/admin/orders/{orderId}/assign as an offer (AP §9.3.2, CA §8.4)', () => {
  it('offers the order to the captain for 45 seconds, logged and audited', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const ops = await admin(['OPS']);
    const before = Date.now();
    const answer = await ops.assign(order.id, captain.captainId);
    expect(answer.statusCode).toBe(200);
    const { offer, ...state } = answer.json().order;
    expect(state).toMatchObject({ id: order.id, captainTrack: 'offered', captainId: null });
    expect(offer.captainId).toBe(captain.captainId);
    const expiresAt = new Date(offer.expiresAt).getTime();
    expect(expiresAt).toBeGreaterThanOrEqual(before + 45 * SECOND);
    expect(expiresAt).toBeLessThanOrEqual(Date.now() + 45 * SECOND);
    expect(await outboxTypes(order.id)).toContain('order.offered');
    const kept = await offerRow(offer.id);
    expect(kept).toMatchObject({ status: 'open', kind: 'manual', offered_by: ops.accountId });
    const job = await sql.query(
      "SELECT data, start_after FROM pgboss.job WHERE name = $1 AND data->>'offerId' = $2",
      [QUEUES.offerExpiry, offer.id],
    );
    expect(new Date(job.rows[0].start_after).getTime()).toBe(expiresAt);
    const audit = await sql.query(
      "SELECT actor_id FROM audit.events WHERE action = 'order.assign_captain' AND target_id = $1",
      [order.id],
    );
    expect(audit.rows).toEqual([{ actor_id: ops.accountId }]);

    // CA §8.2: what the captain sees, never the customer's name or pin.
    const current = await captain.call('GET', '/v1/captain/offers/current');
    expect(current.statusCode).toBe(200);
    expect(current.json().offer).toMatchObject({
      id: offer.id,
      status: 'open',
      fromOperations: true,
      // 25 TRY for the first 3 km.
      pay: { amount: '2500', currency: 'TRY' },
      restaurant: { name: 'مطعم التوزيع' },
      customer: { neighbourhood: 'المركز' },
      pickupPayment: { amount: '12000', currency: 'TRY' },
      collect: { amount: '16000', currency: 'TRY' },
      preparation: { ready: false },
    });
    expect(current.json().offer.restaurant.distanceMetres).toBeGreaterThan(1000);
    expect(JSON.stringify(current.json())).not.toMatch(/شارع السوق|قرب الجامع|36\.59\b/);
  });

  // CA §8.2, AP §9.12.5 (D15, slice 2.16): the pay shown includes the peak
  // bonus if it would apply now, with its own line, and so does the push.
  it('shows the peak bonus in the pay while a window runs', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const { minute } = localClock(new Date(), 'Asia/Damascus');
    await app.get(PeakBonusService).setPeakBonus(
      azaz,
      {
        enabled: true,
        windows: [
          {
            days: [1, 2, 3, 4, 5, 6, 7],
            startMinute: (minute - 60 + 1440) % 1440,
            endMinute: (minute + 60) % 1440,
            amount: 500n,
            zoneIds: [],
          },
        ],
      },
      change,
    );
    try {
      const offer = (await (await admin(['OPS'])).assign(order.id, captain.captainId)).json().order
        .offer;
      const current = (await captain.call('GET', '/v1/captain/offers/current')).json().offer;
      expect(current).toMatchObject({
        pay: { amount: '3000', currency: 'TRY' },
        peakBonus: { amount: '500', currency: 'TRY' },
      });
      // The offer keeps the order pay as logged.
      expect((await offerRow(offer.id)).pay).toBe('2500');
      const outbox = await sql.query(
        "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.offered'",
        [order.id],
      );
      expect(outbox.rows[0].payload.offerPay).toMatchObject({ amount: '3000' });
    } finally {
      // A newer disabled version, at once (the service would wait for the
      // window's end).
      await migrator.query(
        "INSERT INTO captains.peak_bonus_versions (city_id, enabled, currency, effective_from, editor_type, created_at) VALUES ($1, false, 'TRY', now(), 'system', now())",
        [azaz],
      );
    }
  });

  it('assigns the order when the captain accepts: the captain is busy', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const offer = (await (await admin(['OPS'])).assign(order.id, captain.captainId)).json().order
      .offer;
    const key = randomUUID();
    const accepted = await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`, key);
    expect(accepted.statusCode).toBe(200);
    expect(accepted.json().offer.status).toBe('accepted');
    const row = await orderRow(order.id);
    expect(row).toMatchObject({ captain_track: 'assigned', captain_id: captain.captainId });
    expect(await outboxTypes(order.id)).toEqual(
      expect.arrayContaining(['order.offered', 'order.assigned']),
    );
    const event = await sql.query(
      "SELECT actor_type, actor_id, captain_id FROM ordering.order_events WHERE order_id = $1 AND type = 'order.assigned'",
      [order.id],
    );
    expect(event.rows).toEqual([
      { actor_type: 'captain', actor_id: captain.captainId, captain_id: captain.captainId },
    ]);
    const state = await captain.call('GET', '/v1/captain/availability');
    expect(state.json().availability.state).toBe('busy');
    // A repeat of the key answers the offer; another key finds it closed.
    expect(
      (await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`, key)).statusCode,
    ).toBe(200);
    const again = await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`);
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('offer_unavailable');
    // Busy: no going offline (CA §15), and no other order.
    expect((await captain.call('POST', '/v1/captain/availability/offline')).statusCode).toBe(409);
    const next = await acceptedOrder();
    const refused = await (await admin(['OPS'])).assign(next.id, captain.captainId);
    expect(refused.statusCode).toBe(409);
    expect(refused.json()).toMatchObject({ error: 'captain_not_eligible', reasons: ['busy'] });
  });

  it('returns the order to «بحاجة لتعيين» when the captain declines', async () => {
    const order = await acceptedOrder();
    // The search-start job (the worker's) has run.
    await sql.query(
      "UPDATE ordering.orders SET captain_track = 'searching', search_started_at = now(), search_alert_at = now() WHERE id = $1",
      [order.id],
    );
    const captain = await onlineCaptain();
    const offer = (await (await admin(['OPS'])).assign(order.id, captain.captainId)).json().order
      .offer;
    const declined = await captain.call('POST', `/v1/captain/offers/${offer.id}/decline`);
    expect(declined.statusCode).toBe(200);
    expect(declined.json().offer.status).toBe('declined');
    expect(await orderRow(order.id)).toMatchObject({
      captain_track: 'searching',
      captain_id: null,
    });
    expect((await captain.call('GET', '/v1/captain/offers/current')).json().offer).toBeNull();
    // Another captain's offer is unknown to this one.
    const other = await onlineCaptain();
    const second = (await (await admin(['OPS'])).assign(order.id, other.captainId)).json().order
      .offer;
    expect((await captain.call('POST', `/v1/captain/offers/${second.id}/accept`)).statusCode).toBe(
      404,
    );
  });

  it('expires an unanswered offer, and sets the captain offline after 3 in a row (C3)', async () => {
    const captain = await onlineCaptain();
    const dispatch = app.get(DispatchService);
    for (let round = 1; round <= 3; round += 1) {
      const order = await acceptedOrder();
      const offer = (await (await admin(['OPS'])).assign(order.id, captain.captainId)).json().order
        .offer;
      const job = { offerId: offer.id, orderId: order.id, orderPlacedAt: order.placedAt };
      const due = new Date(Date.now() + 46 * SECOND);
      expect(await dispatch.expire(job, due)).toBe(true);
      expect(await dispatch.expire(job, due)).toBe(false);
      expect((await offerRow(offer.id)).status).toBe('expired');
      // Its search had not started yet: no track until it does.
      expect(await orderRow(order.id)).toMatchObject({ captain_track: null });
      const late = await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`);
      expect(late.json().error).toBe('offer_unavailable');
      const state = (await captain.call('GET', '/v1/captain/availability')).json().availability;
      expect(state.state).toBe(round < 3 ? 'online_available' : 'offline');
      // CA §7.4: the app says why until the captain is online again.
      expect(state.offersExpired).toBe(round < 3 ? null : 3);
    }
    const ended = await sql.query(
      'SELECT end_reason FROM captains.online_periods WHERE captain_id = $1',
      [captain.captainId],
    );
    expect(ended.rows).toEqual([{ end_reason: 'offers_expired' }]);
    // CA §7.4, §14 #3: the push and its chime, once.
    const { rows: pushes } = await sql.query(
      `SELECT body, level FROM notifications.push_messages WHERE captain_id = $1
        AND template_key = 'captain.auto_offline'`,
      [captain.captainId],
    );
    expect(pushes).toEqual([
      {
        body: 'لم ترد على 3 عروض متتالية، فأصبحت غير متصل. اضغط «متصل» عندما تكون جاهزاً.',
        level: 'chime',
      },
    ]);
  });
});

describe('the assignment refusals (AP §9.3.2, §9.12.6)', () => {
  it('refuses an order with an open offer, an unknown order and an unknown captain', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const first = await onlineCaptain();
    expect((await ops.assign(order.id, first.captainId)).statusCode).toBe(200);
    const second = await onlineCaptain();
    const busy = await ops.assign(order.id, second.captainId);
    expect(busy.statusCode).toBe(409);
    expect(busy.json().error).toBe('order_not_assignable');
    expect((await ops.assign(randomUUID(), second.captainId)).statusCode).toBe(404);
    expect((await ops.assign((await acceptedOrder()).id, randomUUID())).statusCode).toBe(404);
  });

  it('refuses a captain out of range or offline, and one with an open offer', async () => {
    const ops = await admin(['OPS']);
    // About 5.5 km east, beyond the 3 km search radius.
    const far = await onlineCaptain({ latitude: 36.587, longitude: 37.108 });
    const outOfRange = await ops.assign((await acceptedOrder()).id, far.captainId);
    expect(outOfRange.json()).toMatchObject({
      error: 'captain_not_eligible',
      reasons: ['out_of_range'],
    });
    const gone = await onlineCaptain();
    await app.get(CaptainsService).goOffline(gone.captainId, new Date());
    const offline = await ops.assign((await acceptedOrder()).id, gone.captainId);
    expect(offline.json()).toMatchObject({ error: 'captain_not_eligible', reasons: ['offline'] });
    const captain = await onlineCaptain();
    expect((await ops.assign((await acceptedOrder()).id, captain.captainId)).statusCode).toBe(200);
    const second = await ops.assign((await acceptedOrder()).id, captain.captainId);
    expect(second.json().error).toBe('captain_has_offer');
  });

  it('lets OWN and OPS assign, and refuses SUP and FIN with 403', async () => {
    const captain = await onlineCaptain();
    for (const role of ['SUP', 'FIN']) {
      const refused = await (
        await admin([role])
      ).assign((await acceptedOrder()).id, captain.captainId);
      expect(refused.statusCode).toBe(403);
    }
    expect(
      (await (await admin(['OWN'])).assign((await acceptedOrder()).id, captain.captainId))
        .statusCode,
    ).toBe(200);
  });
});

describe('a direct assignment (dispatch.manual_assign_requires_accept off, CA §8.4)', () => {
  it("makes the order the captain's at once, with no offer", async () => {
    const settings = app.get(SettingsService);
    await settings.update(
      'dispatch.manual_assign_requires_accept',
      { cityId: azaz },
      false,
      bySystem,
    );
    try {
      const order = await acceptedOrder();
      const captain = await onlineCaptain();
      const ops = await admin(['OPS']);
      const answer = await ops.assign(order.id, captain.captainId);
      expect(answer.statusCode).toBe(200);
      expect(answer.json().order).toMatchObject({
        captainTrack: 'assigned',
        captainId: captain.captainId,
        offer: null,
      });
      const event = await sql.query(
        "SELECT actor_type, actor_id FROM ordering.order_events WHERE order_id = $1 AND type = 'order.assigned'",
        [order.id],
      );
      expect(event.rows).toEqual([{ actor_type: 'admin', actor_id: ops.accountId }]);
      const offers = await sql.query('SELECT 1 FROM dispatch.offers WHERE order_id = $1', [
        order.id,
      ]);
      expect(offers.rowCount).toBe(0);
    } finally {
      await settings.update(
        'dispatch.manual_assign_requires_accept',
        { cityId: azaz },
        true,
        bySystem,
      );
    }
  });
});

describe('the assignment picker (AP §9.3.2)', () => {
  it('lists the eligible captains with their distance, ETA and cash, and greys out the rest', async () => {
    const order = await acceptedOrder();
    const near = await onlineCaptain();
    const far = await onlineCaptain({ latitude: 36.587, longitude: 37.108 });
    const ops = await admin(['OPS']);
    const answer = await ops.get(`/v1/admin/orders/${order.id}/captains`);
    expect(answer.statusCode).toBe(200);
    const listed = new Map(
      (
        answer.json().captains as { captainId: string; distanceMetres: number; etaMin: number }[]
      ).map((each) => [each.captainId, each]),
    );
    expect(listed.get(near.captainId)).toMatchObject({
      name: 'كابتن التوزيع',
      vehicle: 'motorbike',
      eligible: true,
      reasons: [],
      ordersToday: 0,
      custody: { usage: { amount: '0', currency: 'TRY' }, limit: { amount: '300000' } },
      acceptanceRate: null,
    });
    const nearDistance = listed.get(near.captainId)!.distanceMetres;
    expect(nearDistance).toBeGreaterThan(1000);
    expect(listed.get(near.captainId)!.etaMin).toBeGreaterThan(0);
    expect(listed.get(far.captainId)).toMatchObject({
      eligible: false,
      reasons: ['out_of_range'],
      etaMin: null,
    });
    // Nearest first.
    const order_ = [...listed.keys()];
    expect(order_.indexOf(near.captainId)).toBeLessThan(order_.indexOf(far.captainId));
    expect((await ops.get(`/v1/admin/orders/${randomUUID()}/captains`)).statusCode).toBe(404);
    expect(
      (await (await admin(['SUP'])).get(`/v1/admin/orders/${order.id}/captains`)).statusCode,
    ).toBe(403);
  });
});

describe('«أقصى مبلغ أحمله» (C4, K2, CA §8.4, §10.5)', () => {
  const setMax = (captain: { headers: Record<string, string> }, amount: string | null) =>
    app.inject({
      method: 'PUT',
      url: '/v1/captain/settings/max-pickup-amount',
      headers: captain.headers,
      payload: { amount },
    });

  it('keeps the captain’s answer: none at first, a limit in the base, then no limit', async () => {
    const captain = await onlineCaptain();
    const first = await app.inject({
      method: 'GET',
      url: '/v1/captain/settings/max-pickup-amount',
      headers: captain.headers,
    });
    expect(first.statusCode).toBe(200);
    expect(first.json()).toEqual({ limit: null, answered: false, baseCurrency: 'TRY' });
    const set = await setMax(captain, '50000');
    expect(set.statusCode).toBe(200);
    expect(set.json()).toEqual({
      limit: { amount: '50000', currency: 'TRY' },
      answered: true,
      baseCurrency: 'TRY',
    });
    const none = await setMax(captain, null);
    expect(none.json()).toEqual({ limit: null, answered: true, baseCurrency: 'TRY' });
    expect((await setMax(captain, '0')).statusCode).toBe(400);
    expect((await setMax(captain, '-5')).statusCode).toBe(400);
    expect((await setMax(captain, '9223372036854775808')).statusCode).toBe(400);
  });

  it('greys the captain out in the picker, and lets operations send an offer with the warning', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const roomy = await onlineCaptain();
    // The order's items value is 12000 minor units.
    await setMax(captain, '11999');
    await setMax(roomy, '12000');
    const ops = await admin(['OPS']);
    const picker = await ops.get(`/v1/admin/orders/${order.id}/captains`);
    const listed = new Map(
      (picker.json().captains as { captainId: string }[]).map((each) => [each.captainId, each]),
    );
    expect(listed.get(captain.captainId)).toMatchObject({
      eligible: false,
      reasons: ['above_max_pickup'],
    });
    expect(listed.get(roomy.captainId)).toMatchObject({ eligible: true, reasons: [] });
    expect(picker.json().assignsAsOffer).toBe(true);
    // A handover, the capacity check and the search start ask with no
    // pickup payment, so the limit never greys the captain out (CA §9.10.1,
    // AP §9.12.6).
    const unpaid = await app.get(CaptainsService).candidates(azaz, centre, 0, new Date(), null);
    expect(unpaid.find((each) => each.captainId === captain.captainId)?.reasons).toEqual([]);

    const answer = await ops.assign(order.id, captain.captainId);
    expect(answer.statusCode).toBe(200);
    const offerId = answer.json().order.offer.id as string;
    expect((await offerRow(offerId)).above_max_pickup).toBe(true);
    const current = await captain.call('GET', '/v1/captain/offers/current');
    expect(current.json().offer).toMatchObject({
      id: offerId,
      aboveMaxPickup: true,
      pickupPayment: { amount: '12000', currency: 'TRY' },
    });
    // The captain may accept it (K2).
    expect((await captain.call('POST', `/v1/captain/offers/${offerId}/accept`)).statusCode).toBe(
      200,
    );
    // CA §10.5, §15: not changed during an order.
    const during = await setMax(captain, '20000');
    expect(during.statusCode).toBe(409);
    expect(during.json()).toMatchObject({ error: 'active_order' });
  });

  it('keeps the limit and its currency together and above zero (a CHECK)', async () => {
    const captain = await onlineCaptain();
    await expect(
      sql.query(
        'UPDATE captains.captains SET max_pickup_amount = 0, max_pickup_currency = $2, max_pickup_set_at = now() WHERE id = $1',
        [captain.captainId, 'TRY'],
      ),
    ).rejects.toThrow(/captains_max_pickup/);
    await expect(
      sql.query(
        'UPDATE captains.captains SET max_pickup_amount = 100, max_pickup_set_at = now() WHERE id = $1',
        [captain.captainId],
      ),
    ).rejects.toThrow(/captains_max_pickup/);
  });

  it('marks no warning on an offer within the limit', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    await setMax(captain, '12000');
    const answer = await (await admin(['OPS'])).assign(order.id, captain.captainId);
    const current = await captain.call('GET', '/v1/captain/offers/current');
    expect(current.json().offer).toMatchObject({
      id: answer.json().order.offer.id,
      aboveMaxPickup: false,
    });
  });

  it('refuses a direct assignment above the limit, which the captain could not decline', async () => {
    const settings = app.get(SettingsService);
    await settings.update(
      'dispatch.manual_assign_requires_accept',
      { cityId: azaz },
      false,
      bySystem,
    );
    try {
      const order = await acceptedOrder();
      const captain = await onlineCaptain();
      await setMax(captain, '100');
      const answer = await (await admin(['OPS'])).assign(order.id, captain.captainId);
      expect(answer.statusCode).toBe(409);
      expect(answer.json()).toMatchObject({
        error: 'captain_not_eligible',
        reasons: ['above_max_pickup'],
      });
    } finally {
      await settings.update(
        'dispatch.manual_assign_requires_accept',
        { cityId: azaz },
        true,
        bySystem,
      );
    }
  });
});

describe('the operations board and order detail (AP §9.2, §9.3.1)', () => {
  it('shows every live order of the city with its captain, badges and passed alerts', async () => {
    const order = await acceptedOrder();
    const sup = await admin(['SUP']);
    const board = await sup.get(`/v1/admin/orders?cityId=${azaz}`);
    expect(board.statusCode).toBe(200);
    const card = (board.json().orders as { id: string }[]).find((each) => each.id === order.id);
    expect(card).toMatchObject({
      status: 'accepted',
      restaurant: { id: restaurant, name: 'مطعم التوزيع' },
      neighbourhood: 'المركز',
      captainTrack: null,
      captain: null,
      total: { amount: '16000', currency: 'TRY' },
      badges: { needsAssignment: false, note: false, newCustomer: true },
      alerts: [],
    });
    // The search started 6 minutes ago (dispatch.no_captain_alert_min is 5).
    await sql.query(
      "UPDATE ordering.orders SET captain_track = 'searching', search_started_at = now() - interval '6 minutes', search_alert_at = now() - interval '1 minute' WHERE id = $1",
      [order.id],
    );
    const later = (
      (await sup.get(`/v1/admin/orders?cityId=${azaz}`)).json().orders as { id: string }[]
    ).find((each) => each.id === order.id);
    expect(later).toMatchObject({
      captainTrack: 'searching',
      badges: { needsAssignment: true },
      alerts: ['no_captain'],
    });

    // Assigned: the captain on the card, the alert gone, the timeline told.
    const captain = await onlineCaptain();
    const assigned = await (await admin(['OPS'])).assign(order.id, captain.captainId);
    const offerId = assigned.json().order.offer.id;
    expect((await captain.call('POST', `/v1/captain/offers/${offerId}/accept`)).statusCode).toBe(
      200,
    );
    const detail = await sup.get(`/v1/admin/orders/${order.id}`);
    expect(detail.statusCode).toBe(200);
    const shown = detail.json().order;
    expect(shown).toMatchObject({
      captainTrack: 'assigned',
      captain: { id: captain.captainId, name: 'كابتن التوزيع', vehicle: 'motorbike' },
      alerts: [],
      customer: { address: { street: 'شارع السوق', landmark: 'قرب الجامع' } },
      money: { itemsValue: '12000', total: '16000', pickupPayment: '12000' },
      lines: [{ name: 'شاورما', quantity: 1, lineTotal: '12000' }],
    });
    expect((shown.timeline as { type: string }[]).map((event) => event.type)).toEqual([
      'order.placed',
      'order.accepted',
      'order.offered',
      'order.assigned',
    ]);
    expect(shown.timeline[3]).toMatchObject({
      actor: { type: 'captain', id: captain.captainId },
      captainId: captain.captainId,
    });
    expect((await sup.get(`/v1/admin/orders/${randomUUID()}`)).statusCode).toBe(404);
    expect((await (await admin(['DATA'])).get(`/v1/admin/orders?cityId=${azaz}`)).statusCode).toBe(
      403,
    );
  });
});

describe('dispatch under races and repeats (AP §9.12.6, architecture §5.3)', () => {
  it('gives one captain one order when two assigns race, and one order one captain', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const [a, b] = [await acceptedOrder(), await acceptedOrder()];
    const both = await Promise.all([
      ops.assign(a.id, captain.captainId),
      ops.assign(b.id, captain.captainId),
    ]);
    expect(both.map((each) => each.statusCode).sort()).toEqual([200, 409]);
    const order = await acceptedOrder();
    const [first, second] = [await onlineCaptain(), await onlineCaptain()];
    const raced = await Promise.all([
      ops.assign(order.id, first.captainId),
      ops.assign(order.id, second.captainId),
    ]);
    expect(raced.map((each) => each.statusCode).sort()).toEqual([200, 409]);
    const open = await sql.query(
      "SELECT count(*)::int AS n FROM dispatch.offers WHERE order_id = $1 AND status = 'open'",
      [order.id],
    );
    expect(open.rows[0].n).toBe(1);
  });

  it('answers a repeated assign once, and refuses its key with another command (422)', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    const key = randomUUID();
    const first = await ops.assign(order.id, captain.captainId, key);
    const repeat = await ops.assign(order.id, captain.captainId, key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order.offer.id).toBe(first.json().order.offer.id);
    const other = await onlineCaptain();
    expect((await ops.assign(order.id, other.captainId, key)).statusCode).toBe(422);
  });

  it('refuses accepting an offer past its time before the worker expired it, and frees the order', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    const offer = (await ops.assign(order.id, captain.captainId)).json().order.offer;
    await migrator.query(
      "UPDATE dispatch.offers SET offered_at = offered_at - interval '1 minute', expires_at = expires_at - interval '1 minute' WHERE id = $1",
      [offer.id],
    );
    const late = await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`);
    expect(late.json().error).toBe('offer_unavailable');
    expect((await captain.call('GET', '/v1/captain/offers/current')).json().offer).toBeNull();
    // Operations may offer the order again at once: the late offer expires.
    const other = await onlineCaptain();
    const again = await ops.assign(order.id, other.captainId);
    expect(again.statusCode).toBe(200);
    expect((await offerRow(offer.id)).status).toBe('expired');
  });

  it('withdraws the open offer when the captain goes offline, freeing the order', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    const offer = (await ops.assign(order.id, captain.captainId)).json().order.offer;
    expect((await captain.call('POST', '/v1/captain/availability/offline')).statusCode).toBe(200);
    expect((await offerRow(offer.id)).status).toBe('withdrawn');
    expect(await orderRow(order.id)).toMatchObject({ captain_track: null });
    expect((await ops.assign(order.id, (await onlineCaptain()).captainId)).statusCode).toBe(200);
  });

  it('starts the C3 run again after a decline and after going offline (CA §7.4)', async () => {
    const dispatch = app.get(DispatchService);
    const captain = await onlineCaptain();
    const ops = await admin(['OPS']);
    const offerAndExpire = async () => {
      const order = await acceptedOrder();
      const offer = (await ops.assign(order.id, captain.captainId)).json().order.offer;
      const job = { offerId: offer.id, orderId: order.id, orderPlacedAt: order.placedAt };
      await migrator.query(
        "UPDATE dispatch.offers SET offered_at = offered_at - interval '1 minute', expires_at = expires_at - interval '1 minute' WHERE id = $1",
        [offer.id],
      );
      expect(await dispatch.expire(job, new Date())).toBe(true);
    };
    await offerAndExpire();
    await offerAndExpire();
    const declined = await acceptedOrder();
    const offer = (await ops.assign(declined.id, captain.captainId)).json().order.offer;
    await captain.call('POST', `/v1/captain/offers/${offer.id}/decline`);
    await offerAndExpire();
    const state = async () =>
      (await captain.call('GET', '/v1/captain/availability')).json().availability.state;
    expect(await state()).toBe('online_available');
    // Offline and back: the earlier expired offers no longer count.
    await captain.call('POST', '/v1/captain/availability/offline');
    const captains = app.get(CaptainsService);
    const now = new Date();
    await captains.goOnline(
      captain.captainId,
      { appVersion: '1.0.0', simulatedLocation: false, termsPending: false },
      now,
    );
    await captains.recordLocations(
      captain.captainId,
      [{ ...captainSpot, accuracyMetres: 8, recordedAt: now, simulated: false }],
      new Date(now.getTime() + 1),
    );
    await offerAndExpire();
    expect(await state()).toBe('online_available');
  });

  it('refuses an order that ended, a captain of another city and a customer on the captain routes', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    await sql.query(
      "UPDATE ordering.orders SET status = 'cancelled', version = version + 1, cancelled_at = now(), cancel_reason = 'test', food_prepared = false WHERE id = $1",
      [order.id],
    );
    expect((await ops.assign(order.id, captain.captainId)).json().error).toBe(
      'order_not_assignable',
    );
    const elsewhere = (
      await sql.query("INSERT INTO geo.cities (code, name) VALUES ('ZZ', 'أخرى') RETURNING id")
    ).rows[0].id as string;
    const stranger = (await onlineCaptain()).captainId;
    await sql.query('UPDATE captains.captains SET city_id = $1 WHERE id = $2', [
      elsewhere,
      stranger,
    ]);
    expect((await ops.assign((await acceptedOrder()).id, stranger)).statusCode).toBe(404);
    const customer = await appSignIn('customer', phoneNumber());
    const refused = await app.inject({
      method: 'GET',
      url: '/v1/captain/offers/current',
      headers: customer,
    });
    expect(refused.statusCode).toBe(401);
  });

  it('lets the application role change only the answer of an offer (AP §9.7.4)', async () => {
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    const offer = (await (await admin(['OPS'])).assign(order.id, captain.captainId)).json().order
      .offer;
    await expect(
      sql.query('UPDATE dispatch.offers SET pickup_metres = 1 WHERE id = $1', [offer.id]),
    ).rejects.toThrow(/permission denied/);
    await expect(
      sql.query('UPDATE dispatch.offers SET above_max_pickup = true WHERE id = $1', [offer.id]),
    ).rejects.toThrow(/permission denied/);
  });

  it('shows the restaurant the captain line (RA §8.1, §8.9)', async () => {
    const settings = app.get(SettingsService);
    await settings.update(
      'dispatch.manual_assign_requires_accept',
      { cityId: azaz },
      false,
      bySystem,
    );
    try {
      const order = await acceptedOrder();
      const captain = await onlineCaptain();
      await (await admin(['OPS'])).assign(order.id, captain.captainId);
      const phone = phoneNumber();
      await app
        .get(MerchantAccountsService)
        .addAccount(restaurant, { role: 'owner', name: 'owner', phone }, change);
      const board = await app.inject({
        method: 'GET',
        url: '/v1/merchant/orders',
        headers: await appSignIn('merchant', phone),
      });
      const card = (board.json().orders as { id: string }[]).find((each) => each.id === order.id);
      expect(card).toMatchObject({
        captainTrack: 'assigned',
        captain: { firstName: 'كابتن', vehicle: 'motorbike' },
      });
    } finally {
      await settings.update(
        'dispatch.manual_assign_requires_accept',
        { cityId: azaz },
        true,
        bySystem,
      );
    }
  });
});
