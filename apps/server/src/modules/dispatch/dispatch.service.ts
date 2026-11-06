import { createHash } from 'node:crypto';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { and, desc, eq, ne } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import {
  type Availability,
  CaptainsService,
  type IneligibleReason,
  type Money,
} from '../captains/index.js';
import type { Vehicle } from '../settings/index.js';
import { GeoService, lastCutoff, type Point, tripMinutes } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { type DispatchOrder, OrderAssignments } from '../ordering/index.js';
import { SettingsService } from '../settings/index.js';
import { idempotencyKeys, offers } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type Executor = Pick<NodePgDatabase, 'select'>;
type OfferRow = typeof offers.$inferSelect;

// Architecture §5.3: a key answers its command for 24 hours.
const KEY_LIFETIME_MS = 24 * 60 * 60 * 1000;

export type DispatchRefusal =
  | 'unknown_order'
  | 'unknown_captain'
  | 'unknown_offer'
  | 'order_not_assignable'
  | 'captain_not_eligible'
  | 'captain_has_offer'
  | 'offer_unavailable'
  | 'idempotency_key_reused';

// A command dispatch refuses, with the reason the routes answer; a captain
// not eligible carries why (AP §9.3.2), a state that changed the order's.
export class DispatchRefusedError extends Error {
  override readonly name = 'DispatchRefusedError';
  constructor(
    readonly refusal: DispatchRefusal,
    message: string,
    readonly reasons: (IneligibleReason | 'offline')[] = [],
  ) {
    super(message);
  }
}

// The offer timer (AP §8.3: dispatch.offer_timeout_sec, 45 s), set for the
// offer's expiry.
export interface OfferExpiryJob {
  offerId: string;
  orderId: string;
  // ISO time, the order's partition key.
  orderPlacedAt: string;
}

// An order's dispatch state after a command: its captain track, the captain
// assigned and the open offer, if any.
export interface DispatchState {
  orderId: string;
  number: bigint;
  status: DispatchOrder['status'];
  version: number;
  captainTrack: DispatchOrder['captainTrack'];
  captainId: string | null;
  offer: { id: string; captainId: string; expiresAt: Date } | null;
}

// An offer as the captain sees it (CA §8.2): before acceptance, never the
// customer's name, phone or exact address (C2).
export interface CaptainOffer {
  id: string;
  status: OfferRow['status'];
  orderId: string;
  number: bigint;
  // CA §8.4: a manual assignment from operations, «تعيين من العمليات».
  fromOperations: boolean;
  offeredAt: Date;
  expiresAt: Date;
  // The order pay of the pay table, null while the city had none; the peak
  // bonus joins with D15, waiting pay is added later («قد يُضاف أجر انتظار»).
  pay: { amount: bigint; currency: string } | null;
  restaurant: { name: string; location: Point; distanceMetres: number };
  customer: { neighbourhood: string; tripMetres: number };
  // «تدفع للمطعم» (D26: the items value) and «تقبض من الزبون».
  pickupPayment: { amount: bigint; currency: string };
  collect: { amount: bigint; currency: string };
  // «جاهز» or «قيد التحضير — جاهز بعد {د} د تقريباً».
  preparation: { ready: boolean; readyAt: Date | null };
}

// A captain in the assignment picker (AP §9.3.2).
export interface PickerCaptain {
  captainId: string;
  name: string;
  vehicle: Vehicle;
  // Greyed out with its reasons when not eligible.
  eligible: boolean;
  reasons: IneligibleReason[];
  // To the restaurant: by road within the search radius, else the straight
  // line; the ETA at order.eta_speed_kmh, null beyond the radius.
  distanceMetres: number;
  etaMin: number | null;
  ordersToday: number;
  custody: { usage: Money; limit: Money };
  // The last captain.acceptance_window_offers offers answered (CA §11.1).
  acceptanceRate: number | null;
}

export interface AdminCommand {
  orderId: string;
  captainId: string;
  admin: { accountId: string; roles: string[] };
  context: AuditRequestContext;
  idempotencyKey: string;
}

export interface CaptainCommand {
  offerId: string;
  captainId: string;
  // The captain's app account, whose keys these are.
  accountId: string;
  idempotencyKey: string;
}

// Manual dispatch (D6; AP §9.3.2, §9.12.6; CA §8): operations offer an
// order to a captain, or assign it directly; the captain accepts or declines
// within dispatch.offer_timeout_sec, or the offer expires. Every command locks
// the order first, then the captain, as ordering's commands do.
@Injectable()
export class DispatchService {
  private readonly logger = new Logger('DispatchService');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
    private readonly settings: SettingsService,
    private readonly assignments: OrderAssignments,
    private readonly captains: CaptainsService,
    private readonly merchants: MerchantsService,
    private readonly geo: GeoService,
    private readonly audit: AuditService,
  ) {}

  // AP §9.3.2 «تعيين كابتن»: with dispatch.manual_assign_requires_accept the
  // captain gets an offer for dispatch.offer_timeout_sec (CA §8.4); without
  // it the order is the captain's at once. The captain must be eligible now
  // (AP §9.12.6); the maximum pickup amount, the only reason operations may
  // override, joins with C4.
  async assign(command: AdminCommand, now: Date): Promise<DispatchState> {
    const hash = commandHash({
      verb: 'assign',
      orderId: command.orderId,
      captainId: command.captainId,
    });
    const earlier = await this.replay(
      this.database.db,
      command.admin.accountId,
      command,
      hash,
      now,
    );
    if (earlier !== null) return this.state(earlier.orderId);
    const order = await this.assignments.find(command.orderId);
    if (order === null) throw new DispatchRefusedError('unknown_order', 'no such order');
    if (!this.assignments.assignable(order)) throw this.notAssignable();
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    const captain = await this.captains.captain(command.captainId, now);
    if (captain === null || captain.cityId !== order.cityId) {
      throw new DispatchRefusedError('unknown_captain', 'no such captain');
    }
    const seen = (
      await this.captains.candidates(order.cityId, restaurant.location, order.tripMetres, now)
    ).find((candidate) => candidate.captainId === command.captainId);
    if (!seen) {
      throw new DispatchRefusedError('captain_not_eligible', 'the captain is not online', [
        'offline',
      ]);
    }
    if (seen.reasons.length > 0) {
      throw new DispatchRefusedError(
        'captain_not_eligible',
        'the captain cannot take the order',
        seen.reasons,
      );
    }
    const [requiresAccept, timeoutSec] = await Promise.all([
      this.settings.get('dispatch.manual_assign_requires_accept', { cityId: order.cityId }),
      this.settings.get('dispatch.offer_timeout_sec', { cityId: order.cityId }),
    ]);
    const shown = requiresAccept ? await this.shown(order, seen, now) : null;
    const lockCaptain = await this.captains.assignmentLock(order.cityId, now);

    // pg-boss connects before the locks are taken, never while they are held.
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await this.assignments.lock(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      const repeat = await this.replay(tx, command.admin.accountId, command, hash, now);
      if (repeat !== null) return true;
      if (!this.assignments.assignable(locked)) return false;
      await this.lockFreeCaptain(tx, lockCaptain, command.captainId);
      const actor = { type: 'admin' as const, id: command.admin.accountId };
      let offerId: string | null = null;
      if (shown !== null) {
        const expiresAt = new Date(now.getTime() + timeoutSec * 1000);
        offerId = await this.openOffer(tx, locked, command, shown, now, expiresAt);
        await this.assignments.change(
          tx,
          locked,
          { type: 'order.offered', captainId: command.captainId },
          actor,
          now,
        );
      } else {
        await this.assignments.change(
          tx,
          locked,
          { type: 'order.assigned', captainId: command.captainId },
          actor,
          now,
        );
      }
      await this.audit.recordWrite(
        {
          actor: {
            type: 'admin',
            id: command.admin.accountId,
            role: command.admin.roles.join(','),
          },
          context: command.context,
          cityId: order.cityId,
          action: 'order.assign_captain',
          target: { type: 'order', id: order.id },
          before: { captainTrack: locked.captainTrack, captainId: null },
          after: {
            captainTrack: shown !== null ? 'offered' : 'assigned',
            captainId: command.captainId,
            offerId,
          },
          reason: null,
        },
        tx,
      );
      await keepKey(tx, command.admin.accountId, command.idempotencyKey, hash, order, offerId, now);
      return true;
    });
    if (!done) throw this.notAssignable();
    return this.state(order.id);
  }

  // CA §8.3 «قبول»: the order becomes the captain's while the offer is still
  // open and in time, the order still waits for it and the captain is still
  // online and free; else «لم يعد العرض متاحاً» (offer_unavailable).
  async accept(command: CaptainCommand, now: Date): Promise<CaptainOffer> {
    return this.answer(command, 'accepted', now);
  }

  // CA §8.3 «رفض»: no reason needed; the order returns to «بحاجة لتعيين».
  async decline(command: CaptainCommand, now: Date): Promise<CaptainOffer> {
    return this.answer(command, 'declined', now);
  }

  // AP §8.3: the offer timer. An offer still open expires («انتهت المهلة»)
  // and the order returns to «بحاجة لتعيين»; after
  // captain.offer_expiry_offline_count expired offers in a row the captain
  // goes offline (C3, AP §9.7.6). True when it expired the offer.
  async expire(job: OfferExpiryJob, now: Date): Promise<boolean> {
    await this.jobs.ready();
    const expired = await this.database.db.transaction(async (tx) => {
      const order = await this.assignments.lock(tx, job.orderId, new Date(job.orderPlacedAt));
      const offer = await lockOffer(tx, job.offerId);
      if (!order || !offer || offer.status !== 'open') return null;
      await closeOffer(tx, offer.id, 'expired', now);
      await this.assignments.change(
        tx,
        order,
        { type: 'order.offer_closed', captainId: offer.captainId, reason: 'expired' },
        { type: 'system', id: null },
        now,
      );
      return offer;
    });
    if (expired === null) return false;
    const count = await this.settings.get('captain.offer_expiry_offline_count', {
      cityId: expired.cityId,
    });
    const last = await this.database.db
      .select({ status: offers.status })
      .from(offers)
      .where(and(eq(offers.captainId, expired.captainId), ne(offers.status, 'open')))
      .orderBy(desc(offers.offeredAt))
      .limit(count);
    if (last.length === count && last.every((each) => each.status === 'expired')) {
      await this.captains.offlineForUnansweredOffers(expired.captainId, now);
      this.logger.log({ captainId: expired.captainId }, 'offline after unanswered offers (C3)');
    }
    return true;
  }

  // AP §9.3.2, the assignment picker: every online captain of the city with
  // a live position, nearest to the restaurant first, eligible or greyed out
  // with its reasons; for each, the distance and ETA to the restaurant (by
  // road for its vehicle within the search radius, owner decision
  // 2026-11-06), its vehicle, its orders today, its cash-limit usage and its
  // acceptance rate over its last captain.acceptance_window_offers offers
  // (CA §11.1).
  async picker(orderId: string, now: Date): Promise<PickerCaptain[]> {
    const order = await this.assignments.find(orderId);
    if (order === null) throw new DispatchRefusedError('unknown_order', 'no such order');
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    const candidates = await this.captains.candidates(
      order.cityId,
      restaurant.location,
      order.tripMetres,
      now,
    );
    if (candidates.length === 0) return [];
    const [speedKmh, window, cutoff, timeZone] = await Promise.all([
      this.settings.get('order.eta_speed_kmh', { cityId: order.cityId }),
      this.settings.get('captain.acceptance_window_offers', { cityId: order.cityId }),
      this.settings.get('finance.business_day_cutoff', { cityId: order.cityId }),
      this.geo.cityTimeZone(order.cityId),
    ]);
    // «طلبات اليوم»: since the business day began (finance.business_day_cutoff).
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const dayStart = lastCutoff(now, hours * 60 + minutes, timeZone ?? 'UTC');
    const ids = candidates.map((candidate) => candidate.captainId);
    const [today, rates] = await Promise.all([
      this.assignments.assignedSince(ids, dayStart),
      this.acceptanceRates(ids, window),
    ]);
    return Promise.all(
      candidates.map(async (candidate) => {
        const inRange = !candidate.reasons.includes('out_of_range');
        const distance = inRange
          ? await this.geo.distance(candidate.position, restaurant.location, {
              vehicle: candidate.vehicle,
            })
          : null;
        return {
          captainId: candidate.captainId,
          name: candidate.name,
          vehicle: candidate.vehicle,
          eligible: candidate.reasons.length === 0,
          reasons: candidate.reasons,
          distanceMetres: distance?.metres ?? candidate.straightMetres,
          etaMin: distance === null ? null : Math.ceil(tripMinutes(distance.metres, speedKmh)),
          ordersToday: today.get(candidate.captainId) ?? 0,
          custody: { usage: candidate.custody.usage, limit: candidate.custody.limit },
          acceptanceRate: rates.get(candidate.captainId) ?? null,
        };
      }),
    );
  }

  // CA §11.1: each captain's acceptance rate over its last offers answered,
  // as a whole percentage; null without one.
  private async acceptanceRates(
    captainIds: string[],
    window: number,
  ): Promise<Map<string, number | null>> {
    const rates = new Map<string, number | null>();
    for (const captainId of captainIds) {
      const last = await this.database.db
        .select({ status: offers.status })
        .from(offers)
        .where(and(eq(offers.captainId, captainId), ne(offers.status, 'open')))
        .orderBy(desc(offers.offeredAt))
        .limit(window);
      rates.set(
        captainId,
        last.length === 0
          ? null
          : Math.round(
              (last.filter((each) => each.status === 'accepted').length * 100) / last.length,
            ),
      );
    }
    return rates;
  }

  // CA §8: the captain's open offer still in time, or null.
  async currentOffer(captainId: string, now: Date): Promise<CaptainOffer | null> {
    const [offer] = await this.database.db
      .select()
      .from(offers)
      .where(and(eq(offers.captainId, captainId), eq(offers.status, 'open')));
    if (!offer || offer.expiresAt <= now) return null;
    return this.captainOffer(offer, now);
  }

  // The order's dispatch state now: its track, captain and open offer.
  async state(orderId: string): Promise<DispatchState> {
    const order = await this.assignments.find(orderId);
    if (order === null) throw new Error(`order ${orderId} not found`);
    const [offer] = await this.database.db
      .select({ id: offers.id, captainId: offers.captainId, expiresAt: offers.expiresAt })
      .from(offers)
      .where(and(eq(offers.orderId, orderId), eq(offers.status, 'open')));
    return {
      orderId: order.id,
      number: order.number,
      status: order.status,
      version: order.version,
      captainTrack: order.captainTrack,
      captainId: order.captainId,
      offer: offer ?? null,
    };
  }

  private async answer(
    command: CaptainCommand,
    response: 'accepted' | 'declined',
    now: Date,
  ): Promise<CaptainOffer> {
    const hash = commandHash({ verb: response, offerId: command.offerId });
    const earlier = await this.replay(this.database.db, command.accountId, command, hash, now);
    if (earlier?.offerId) return this.offerView(earlier.offerId, now);
    const [offer] = await this.database.db
      .select()
      .from(offers)
      .where(and(eq(offers.id, command.offerId), eq(offers.captainId, command.captainId)));
    if (!offer) throw new DispatchRefusedError('unknown_offer', 'no such offer');
    if (offer.status !== 'open' || offer.expiresAt <= now) throw this.unavailable();
    const lockCaptain =
      response === 'accepted' ? await this.captains.assignmentLock(offer.cityId, now) : null;

    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const order = await this.assignments.lock(tx, offer.orderId, offer.orderPlacedAt);
      const locked = await lockOffer(tx, offer.id);
      if (!order || !locked) throw new Error(`offer ${offer.id} lost its order`);
      const repeat = await this.replay(tx, command.accountId, command, hash, now);
      if (repeat !== null) return true;
      if (locked.status !== 'open' || locked.expiresAt <= now) return false;
      const actor = { type: 'captain' as const, id: command.captainId };
      if (response === 'accepted') {
        const free =
          order.captainId === null &&
          (order.status === 'accepted' || order.status === 'ready') &&
          (await this.captainFree(tx, lockCaptain!, command.captainId));
        if (!free) return false;
        await closeOffer(tx, offer.id, 'accepted', now);
        await this.assignments.change(
          tx,
          order,
          { type: 'order.assigned', captainId: command.captainId },
          actor,
          now,
        );
      } else {
        await closeOffer(tx, offer.id, 'declined', now);
        await this.assignments.change(
          tx,
          order,
          { type: 'order.offer_closed', captainId: command.captainId, reason: 'declined' },
          actor,
          now,
        );
      }
      await keepKey(tx, command.accountId, command.idempotencyKey, hash, order, offer.id, now);
      return true;
    });
    if (!done) throw this.unavailable();
    return this.offerView(offer.id, now);
  }

  // CA §8.2: what the offer shows that changes once it is sent: the road
  // distance from the captain to the restaurant by its vehicle (owner
  // decision 2026-11-06) and the order pay of the order's pay table.
  private async shown(
    order: DispatchOrder,
    captain: { position: Point; vehicle: Parameters<CaptainsService['orderPay']>[1] },
    now: Date,
  ) {
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    const distance = await this.geo.distance(captain.position, restaurant.location, {
      vehicle: captain.vehicle,
    });
    const pay =
      order.payTableId === null
        ? null
        : await this.captains.orderPay(order.payTableId, captain.vehicle, order.tripMetres);
    return { pickupMetres: distance.metres, pay };
  }

  private async openOffer(
    tx: Tx,
    order: DispatchOrder,
    command: AdminCommand,
    shown: { pickupMetres: number; pay: { amount: bigint; currency: string } | null },
    now: Date,
    expiresAt: Date,
  ): Promise<string> {
    const [opened] = await tx
      .insert(offers)
      .values({
        cityId: order.cityId,
        orderId: order.id,
        orderPlacedAt: order.placedAt,
        captainId: command.captainId,
        kind: 'manual',
        offeredBy: command.admin.accountId,
        offeredAt: now,
        expiresAt,
        status: 'open',
        pickupMetres: shown.pickupMetres,
        pay: shown.pay?.amount ?? null,
        payCurrency: shown.pay?.currency ?? null,
      })
      .returning({ id: offers.id });
    const job: OfferExpiryJob = {
      offerId: opened!.id,
      orderId: order.id,
      orderPlacedAt: order.placedAt.toISOString(),
    };
    // AP §8.3: the timer exists exactly when the offer does.
    await this.jobs.send(QUEUES.offerExpiry, job, {
      startAfter: expiresAt,
      db: inTransaction(tx),
    });
    return opened!.id;
  }

  // Under the captain's lock: online and receiving offers, no active order
  // and no other open offer (CA §8.1).
  private async lockFreeCaptain(
    tx: Tx,
    lockCaptain: (tx: Tx, captainId: string) => Promise<Availability>,
    captainId: string,
  ): Promise<void> {
    const state = await lockCaptain(tx, captainId);
    if (state.state !== 'online_available') {
      throw new DispatchRefusedError(
        'captain_not_eligible',
        'the captain cannot take the order',
        state.state === 'busy'
          ? ['busy']
          : state.state === 'not_receiving_offers'
            ? state.reasons
            : ['offline'],
      );
    }
    const [open] = await tx
      .select({ id: offers.id })
      .from(offers)
      .where(and(eq(offers.captainId, captainId), eq(offers.status, 'open')));
    if (open) throw new DispatchRefusedError('captain_has_offer', 'the captain has an open offer');
  }

  // Accepting: still online, and still without an active order. Cash and
  // the other reasons were checked when the offer opened.
  private async captainFree(
    tx: Tx,
    lockCaptain: (tx: Tx, captainId: string) => Promise<Availability>,
    captainId: string,
  ): Promise<boolean> {
    const state = await lockCaptain(tx, captainId);
    return state.state === 'online_available' || state.state === 'not_receiving_offers';
  }

  private async offerView(offerId: string, now: Date): Promise<CaptainOffer> {
    const [offer] = await this.database.db.select().from(offers).where(eq(offers.id, offerId));
    if (!offer) throw new Error(`offer ${offerId} not found`);
    return this.captainOffer(offer, now);
  }

  private async captainOffer(offer: OfferRow, now: Date): Promise<CaptainOffer> {
    const order = await this.assignments.find(offer.orderId);
    if (order === null) throw new Error(`order ${offer.orderId} not found`);
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    const prepDue =
      order.acceptedAt && order.prepMin !== null
        ? new Date(order.acceptedAt.getTime() + order.prepMin * 60_000)
        : null;
    return {
      id: offer.id,
      status: offer.status,
      orderId: order.id,
      number: order.number,
      fromOperations: offer.kind === 'manual',
      offeredAt: offer.offeredAt,
      expiresAt: offer.expiresAt,
      pay:
        offer.pay === null || offer.payCurrency === null
          ? null
          : { amount: offer.pay, currency: offer.payCurrency },
      restaurant: {
        name: restaurant.nameAr,
        location: restaurant.location,
        distanceMetres: offer.pickupMetres,
      },
      customer: { neighbourhood: order.neighbourhood, tripMetres: order.tripMetres },
      pickupPayment: { amount: order.itemsValue, currency: order.currency },
      collect: { amount: order.total, currency: order.currency },
      preparation: { ready: order.readyAt !== null, readyAt: order.readyAt ?? prepDue },
    };
  }

  private notAssignable() {
    return new DispatchRefusedError(
      'order_not_assignable',
      'the order has a captain or an open offer, or is not accepted or ready',
    );
  }

  private unavailable() {
    return new DispatchRefusedError('offer_unavailable', 'the offer is no longer open');
  }

  private async replay(
    executor: Executor,
    accountId: string,
    command: { idempotencyKey: string },
    requestHash: string,
    now: Date,
  ) {
    const [row] = await executor
      .select()
      .from(idempotencyKeys)
      .where(
        and(
          eq(idempotencyKeys.accountId, accountId),
          eq(idempotencyKeys.key, command.idempotencyKey),
        ),
      );
    if (!row || now.getTime() - row.createdAt.getTime() >= KEY_LIFETIME_MS) return null;
    if (row.requestHash !== requestHash) {
      throw new DispatchRefusedError('idempotency_key_reused', 'the key came with another command');
    }
    return row;
  }
}

async function lockOffer(tx: Tx, offerId: string): Promise<OfferRow | undefined> {
  const [offer] = await tx.select().from(offers).where(eq(offers.id, offerId)).for('update');
  return offer;
}

async function closeOffer(
  tx: Tx,
  offerId: string,
  status: 'accepted' | 'declined' | 'expired',
  now: Date,
): Promise<void> {
  await tx.update(offers).set({ status, respondedAt: now }).where(eq(offers.id, offerId));
}

// Keeps the key with its order and offer, in the command's transaction, so
// a refused command keeps none. A key older than 24 hours is used again.
async function keepKey(
  tx: Tx,
  accountId: string,
  key: string,
  requestHash: string,
  order: { id: string; placedAt: Date },
  offerId: string | null,
  now: Date,
): Promise<void> {
  const kept = {
    requestHash,
    orderId: order.id,
    orderPlacedAt: order.placedAt,
    offerId,
    createdAt: now,
  };
  await tx
    .insert(idempotencyKeys)
    .values({ accountId, key, ...kept })
    .onConflictDoUpdate({ target: [idempotencyKeys.accountId, idempotencyKeys.key], set: kept });
}

function commandHash(command: unknown): string {
  return createHash('sha256').update(JSON.stringify(command)).digest('hex');
}
