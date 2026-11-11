import { createHash } from 'node:crypto';
import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, desc, eq, gt, gte, lt, ne } from 'drizzle-orm';
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
import {
  type AssignmentActor,
  type DispatchOrder,
  HANDOVER_FROM,
  type HandoverCloseReason,
  type OpenHandover,
  OrderAssignments,
} from '../ordering/index.js';
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
  // AP §9.3.2 «تسليم لكابتن آخر» (slice 2.12b): not picked up or arrived
  // with a captain, a handover already open, or an outcome waiting.
  | 'order_not_handoverable'
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
  // handover: the offer of a picked-up order to a second captain (slice
  // 2.12b).
  offer: { id: string; captainId: string; expiresAt: Date; handover: boolean } | null;
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
  // CA §9.10.1 (slice 2.12b): «استلام من كابتن», from the order's captain at
  // their latest point (null without one); the pickup payment is then 0,
  // «لا تدفع شيئاً», and distanceMetres in restaurant is to them.
  handover: {
    fromCaptainName: string;
    location: (Point & { recordedAt: Date }) | null;
  } | null;
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
  // «تسليم لكابتن آخر»: operations' required note (AP §9.3.2).
  reason?: string;
  admin: { accountId: string; roles: string[] };
  context: AuditRequestContext;
  idempotencyKey: string;
}

export interface CaptainCommand {
  offerId: string;
  captainId: string;
  // The captain's app account, whose keys these are, and the app
  // installation (CA §15).
  accountId: string;
  deviceId: string;
  idempotencyKey: string;
}

// Manual dispatch (D6; AP §9.3.2, §9.12.6; CA §8): operations offer an
// order to a captain, or assign it directly; the captain accepts or declines
// within dispatch.offer_timeout_sec, or the offer expires. Every command locks
// the order first, then the captain, as ordering's commands do.
@Injectable()
export class DispatchService implements OnModuleInit {
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

  onModuleInit(): void {
    this.captains.onWentOffline((captainId, now) => this.withdraw(captainId, now));
    // AP §9.3.2 «إلغاء الطلب» (slice 2.8b): the order's open offer is
    // withdrawn in the cancellation's transaction, before it; the captain
    // hears nothing (the app shows «لم يعد العرض متاحاً»).
    // An outcome or operations' delivery withdraws a handover's offer the
    // same way (slice 2.12b).
    this.assignments.onCancel(async (tx, order, actor, now) => {
      const [open] = await tx
        .select()
        .from(offers)
        .where(and(eq(offers.orderId, order.id), eq(offers.status, 'open')))
        .for('update');
      if (!open) return;
      // A handover's offer closes its handover as ended (slice 2.12b).
      await this.close(tx, order, open, 'withdrawn', now, actor, 'ended');
    });
  }

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
    // An open offer is checked under the lock, where one past its time
    // expires first.
    if (!this.assignments.assignable({ ...order, captainTrack: null })) throw this.notAssignable();
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
      // An offer past its time that the worker has not expired yet.
      const current = await this.expireLate(tx, locked, now);
      if (!this.assignments.assignable(current)) return false;
      await this.lockFreeCaptain(tx, lockCaptain, command.captainId);
      const actor = { type: 'admin' as const, id: command.admin.accountId };
      let offerId: string | null = null;
      if (shown !== null) {
        const expiresAt = new Date(now.getTime() + timeoutSec * 1000);
        offerId = await this.openOffer(tx, current, command, shown, now, expiresAt);
        await this.assignments.change(
          tx,
          current,
          { type: 'order.offered', captainId: command.captainId, pay: shown.pay, expiresAt },
          actor,
          now,
        );
      } else {
        await this.assignments.change(
          tx,
          current,
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
          before: { captainTrack: current.captainTrack, captainId: null },
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
    const outcome = await this.database.db.transaction(async (tx) => {
      const order = await this.assignments.lock(tx, job.orderId, new Date(job.orderPlacedAt));
      const offer = await lockOffer(tx, job.offerId);
      if (!order || !offer) return null;
      if (offer.status !== 'open') return { offer, expired: false };
      // The job may start early by the database's clock: the captain keeps
      // the whole time, and the queue tries again.
      if (now < offer.expiresAt) throw new Error(`offer ${offer.id} is not due yet`);
      await this.close(tx, order, offer, 'expired', now);
      return { offer, expired: true };
    });
    // C3 runs again with a retry after it failed, once the offer expired.
    if (outcome?.offer.status === 'expired' || outcome?.expired) {
      await this.offlineAfterUnanswered(outcome.offer, now);
    }
    return outcome?.expired ?? false;
  }

  // C3, CA §7.4: offline when the captain's last
  // captain.offer_expiry_offline_count answered offers of this online period
  // all expired; an acceptance, a decline or going offline starts the run
  // again.
  private async offlineAfterUnanswered(offer: OfferRow, now: Date): Promise<void> {
    const since = await this.captains.onlineSince(offer.captainId);
    if (since === null) return;
    const count = await this.settings.get('captain.offer_expiry_offline_count', {
      cityId: offer.cityId,
    });
    const last = await this.database.db
      .select({ status: offers.status })
      .from(offers)
      .where(
        and(
          eq(offers.captainId, offer.captainId),
          ne(offers.status, 'open'),
          gte(offers.offeredAt, since),
        ),
      )
      .orderBy(desc(offers.offeredAt))
      .limit(count);
    if (last.length === count && last.every((each) => each.status === 'expired')) {
      if (await this.captains.offlineForUnansweredOffers(offer.captainId, now)) {
        this.logger.log({ captainId: offer.captainId }, 'offline after unanswered offers (C3)');
      }
    }
  }

  // An open offer of the locked order past its time, which the worker has
  // not expired yet, expires now; the order as it is then.
  private async expireLate(tx: Tx, order: DispatchOrder, now: Date): Promise<DispatchOrder> {
    const [open] = await tx
      .select()
      .from(offers)
      .where(and(eq(offers.orderId, order.id), eq(offers.status, 'open')))
      .for('update');
    if (!open || now < open.expiresAt) return order;
    return this.close(tx, order, open, 'expired', now);
  }

  // Closes an open offer and returns its order to «بحاجة لتعيين»
  // (order.offer_closed).
  private async close(
    tx: Tx,
    order: DispatchOrder,
    offer: OfferRow,
    status: 'declined' | 'expired' | 'withdrawn',
    now: Date,
    actor: AssignmentActor = { type: 'system', id: null },
    // A handover's offer withdrawn because the order ended or the handover
    // was replaced says so (slice 2.12b).
    handoverReason: HandoverCloseReason = status,
  ): Promise<DispatchOrder> {
    await closeOffer(tx, offer.id, status, now);
    if (offer.handover) {
      // Slice 2.12b: the handover closes with its offer; the order stays its
      // captain's.
      const handover = await this.assignments.openHandover(tx, order);
      if (handover === null || handover.offerId !== offer.id) return order;
      return this.assignments.closeHandover(tx, order, handover, handoverReason, actor, now);
    }
    return this.assignments.change(
      tx,
      order,
      { type: 'order.offer_closed', captainId: offer.captainId, reason: status },
      actor,
      now,
    );
  }

  // The captain went offline (CA §7.5, a suspension, a termination, C3): an
  // offer still open is withdrawn, so operations can offer the order again
  // at once.
  async withdraw(captainId: string, now: Date): Promise<void> {
    const [open] = await this.database.db
      .select()
      .from(offers)
      .where(and(eq(offers.captainId, captainId), eq(offers.status, 'open')));
    if (!open) return;
    await this.jobs.ready();
    await this.database.db.transaction(async (tx) => {
      const order = await this.assignments.lock(tx, open.orderId, open.orderPlacedAt);
      const offer = await lockOffer(tx, open.id);
      if (!order || !offer || offer.status !== 'open') return;
      await this.close(tx, order, offer, 'withdrawn', now);
    });
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
    // After the pickup the picker is for «تسليم لكابتن آخر»: measured from
    // the order's captain (slice 2.12b), who is left out.
    const handover = HANDOVER_FROM.includes(order.status) && order.captainId !== null;
    const from = handover
      ? await this.handoverPoint(order, now)
      : (await this.restaurantOf(order, now)).location;
    const candidates = (
      await this.captains.candidates(order.cityId, from, order.tripMetres, now)
    ).filter((candidate) => candidate.captainId !== order.captainId);
    if (candidates.length === 0) return [];
    const [speedKmh, window, cutoff, timeZone] = await Promise.all([
      this.settings.get('order.eta_speed_kmh', { cityId: order.cityId }),
      this.settings.get('captain.acceptance_window_offers', { cityId: order.cityId }),
      this.settings.get('finance.business_day_cutoff', { cityId: order.cityId }),
      this.geo.cityTimeZone(order.cityId),
    ]);
    // «طلبات اليوم»: since the business day began (finance.business_day_cutoff).
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    if (timeZone === null) throw new Error(`city ${order.cityId} has no time zone`);
    const dayStart = lastCutoff(now, hours * 60 + minutes, timeZone);
    const ids = candidates.map((candidate) => candidate.captainId);
    const [today, rates] = await Promise.all([
      this.assignments.assignedSince(ids, dayStart),
      this.acceptanceRates(ids, window),
    ]);
    const listed = await Promise.all(
      candidates.map(async (candidate) => {
        const inRange = !candidate.reasons.includes('out_of_range');
        const distance = inRange
          ? await this.geo.distance(candidate.position, from, { vehicle: candidate.vehicle })
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
    return listed.sort(
      (a, b) => a.distanceMetres - b.distanceMetres || a.ordersToday - b.ordersToday,
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
  async state(orderId: string, now = new Date()): Promise<DispatchState> {
    const order = await this.assignments.find(orderId);
    if (order === null) throw new Error(`order ${orderId} not found`);
    const [offer] = await this.database.db
      .select({
        id: offers.id,
        captainId: offers.captainId,
        expiresAt: offers.expiresAt,
        handover: offers.handover,
      })
      .from(offers)
      .where(
        and(eq(offers.orderId, orderId), eq(offers.status, 'open'), gt(offers.expiresAt, now)),
      );
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
      const actor = { type: 'captain' as const, id: command.captainId, device: command.deviceId };
      if (response === 'accepted' && locked.handover) {
        // CA §9.10.1: the second captain has the handover; the order stays
        // the first captain's until the receipt.
        const handover = await this.assignments.openHandover(tx, order);
        const free =
          handover !== null &&
          handover.offerId === offer.id &&
          handover.assignedAt === null &&
          HANDOVER_FROM.includes(order.status) &&
          (await this.captainFree(tx, lockCaptain!, command.captainId));
        if (!free) return false;
        await closeOffer(tx, offer.id, 'accepted', now);
        await this.assignments.assignHandover(tx, order, handover, actor, now);
      } else if (response === 'accepted') {
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
        await this.close(tx, order, locked, 'declined', now, actor);
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
    // A handover's offer measures to the first captain (slice 2.12b).
    to: Point | null = null,
  ) {
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    const distance = await this.geo.distance(captain.position, to ?? restaurant.location, {
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
    handover = false,
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
        handover,
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
        state.state === 'busy' || state.state === 'last_order'
          ? [state.state]
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
    const handover =
      offer.handover && order.captainId !== null
        ? await this.handoverFrom(order.captainId, now)
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
      // CA §9.10.1: «لا تدفع شيئاً» on a handover's offer.
      pickupPayment: { amount: handover ? 0n : order.itemsValue, currency: order.currency },
      collect: { amount: order.total, currency: order.currency },
      preparation: { ready: order.readyAt !== null, readyAt: order.readyAt ?? prepDue },
      handover,
    };
  }

  // CA §9.10.1: the first captain's name and latest point.
  private async handoverFrom(captainId: string, now: Date) {
    const [captain, point] = await Promise.all([
      this.captains.captain(captainId, now),
      this.captains.latestPoint(captainId),
    ]);
    if (!captain) throw new Error(`captain ${captainId} not found`);
    return { fromCaptainName: captain.name, location: point };
  }

  // AP §9.3.2 «تسليم لكابتن آخر», CA §9.10.1 (slice 2.12b): operations hand a
  // picked-up or arrived order from its captain to a second one, as a manual
  // dispatch (owner decision 2026-11-10): with
  // dispatch.manual_assign_requires_accept an offer marked «استلام من كابتن»
  // for dispatch.offer_timeout_sec, else the handover is the captain's at
  // once. The second captain must be eligible now, measured from the first
  // captain's latest point (the restaurant without one); C4 does not apply
  // (they pay nothing). The order stays the first captain's until the
  // receipt (owner decision 2026-11-11).
  async handover(command: AdminCommand & { reason: string }, now: Date): Promise<DispatchState> {
    const hash = commandHash({
      verb: 'handover',
      orderId: command.orderId,
      captainId: command.captainId,
      reason: command.reason,
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
    // Checked again under the lock, where an open offer past its time
    // expires first.
    const before = await this.assignments.handoverProblem(
      this.database.db,
      order,
      command.captainId,
    );
    if (before === 'same_captain') throw this.captainBusy();
    if (before !== null) throw this.notHandoverable();
    const captain = await this.captains.captain(command.captainId, now);
    if (captain === null || captain.cityId !== order.cityId) {
      throw new DispatchRefusedError('unknown_captain', 'no such captain');
    }
    if (order.captainId === null || !HANDOVER_FROM.includes(order.status)) {
      throw this.notHandoverable();
    }
    const from = await this.handoverPoint(order, now);
    const seen = (await this.captains.candidates(order.cityId, from, order.tripMetres, now)).find(
      (candidate) => candidate.captainId === command.captainId,
    );
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
    const shown = requiresAccept ? await this.shown(order, seen, now, from) : null;
    const lockCaptain = await this.captains.assignmentLock(order.cityId, now);

    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await this.assignments.lock(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      const repeat = await this.replay(tx, command.admin.accountId, command, hash, now);
      if (repeat !== null) return true;
      const late = await this.expireLate(tx, locked, now);
      const problem = await this.assignments.handoverProblem(tx, late, command.captainId);
      if (problem === 'same_captain') throw this.captainBusy();
      if (problem !== null) return false;
      // Owner decision 2026-11-11: a new handover replaces the open one (its
      // offer withdrawn, or its second captain freed).
      const open = await this.assignments.openHandover(tx, late);
      const current =
        open === null
          ? late
          : await this.replaceHandover(
              tx,
              late,
              open,
              { type: 'admin', id: command.admin.accountId },
              now,
            );
      await this.lockFreeCaptain(tx, lockCaptain, command.captainId);
      let offerId: string | null = null;
      if (shown !== null) {
        const expiresAt = new Date(now.getTime() + timeoutSec * 1000);
        offerId = await this.openOffer(tx, current, command, shown, now, expiresAt, true);
        await this.assignments.startHandover(
          tx,
          current,
          {
            toCaptainId: command.captainId,
            note: command.reason,
            adminId: command.admin.accountId,
            offer: { id: offerId, pay: shown.pay, expiresAt },
          },
          now,
        );
      } else {
        await this.assignments.startHandover(
          tx,
          current,
          {
            toCaptainId: command.captainId,
            note: command.reason,
            adminId: command.admin.accountId,
            offer: null,
          },
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
          action: 'order.handover',
          target: { type: 'order', id: order.id },
          before: { captainId: current.captainId, status: current.status },
          after: { toCaptainId: command.captainId, offerId },
          reason: command.reason,
        },
        tx,
      );
      await keepKey(tx, command.admin.accountId, command.idempotencyKey, hash, order, offerId, now);
      return true;
    });
    if (!done) throw this.notHandoverable();
    return this.state(order.id);
  }

  private async restaurantOf(order: DispatchOrder, now: Date) {
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    return restaurant;
  }

  // Closes the order's open handover as replaced: its open offer withdrawn,
  // or its assignment ended, so the second captain is free.
  private async replaceHandover(
    tx: Tx,
    order: DispatchOrder,
    open: OpenHandover,
    actor: AssignmentActor,
    now: Date,
  ): Promise<DispatchOrder> {
    if (open.assignedAt === null && open.offerId !== null) {
      const offer = await lockOffer(tx, open.offerId);
      if (offer?.status === 'open') {
        return this.close(tx, order, offer, 'withdrawn', now, actor, 'replaced');
      }
    }
    return this.assignments.closeHandover(tx, order, open, 'replaced', actor, now);
  }

  // Where a handover's second captain is measured from: the first captain's
  // latest point, or the restaurant without one.
  private async handoverPoint(order: DispatchOrder, now: Date): Promise<Point> {
    const point =
      order.captainId === null ? null : await this.captains.latestPoint(order.captainId);
    if (point) return { latitude: point.latitude, longitude: point.longitude };
    return (await this.restaurantOf(order, now)).location;
  }

  private notHandoverable() {
    return new DispatchRefusedError(
      'order_not_handoverable',
      'the order is not picked up or arrived with a captain, or has a handover open or an outcome waiting',
    );
  }

  private captainBusy() {
    return new DispatchRefusedError('captain_not_eligible', 'the order is already theirs', [
      'busy',
    ]);
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
  status: 'accepted' | 'declined' | 'expired' | 'withdrawn',
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
  // An older key is used again; one another command took meanwhile (two
  // sent at once about different orders) refuses this one, which rolls back.
  const [taken] = await tx
    .insert(idempotencyKeys)
    .values({ accountId, key, ...kept })
    .onConflictDoUpdate({
      target: [idempotencyKeys.accountId, idempotencyKeys.key],
      set: kept,
      setWhere: lt(idempotencyKeys.createdAt, new Date(now.getTime() - KEY_LIFETIME_MS)),
    })
    .returning({ key: idempotencyKeys.key });
  if (!taken) {
    throw new DispatchRefusedError('idempotency_key_reused', 'the key came with another command');
  }
}

function commandHash(command: unknown): string {
  return createHash('sha256').update(JSON.stringify(command)).digest('hex');
}
