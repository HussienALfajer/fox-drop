import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import { type RateSnapshot, toBase } from '../fx/index.js';
import { type LedgerActor, LedgerService } from '../ledger/index.js';
import { lockOrder, type OrderRow, recordTransition } from './order-events.js';
import { snapshotOf } from './order-views.js';
import { orders, pickupRequests } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// A payment line (RA §8.10): an amount in minor units of one currency.
export interface PaymentLine {
  currency: string;
  amount: bigint;
}

// The automatic confirmation's job (AP §8.1, docs/domain/03), set for the
// request's confirm_by.
export interface PickupAutoConfirmJob {
  requestId: string;
  orderId: string;
  // ISO time, the order's partition key.
  placedAt: string;
}

export type LinesRefusal = 'invalid_lines' | 'currency_not_accepted' | 'amount_mismatch';

// At most one line per currency, each above zero; Phase 1 takes payments in
// the base currency only (owner decision 2026-11-05: RA §12.7's other
// currencies wait). With `due`, the lines' total converted by the order's
// snapshot must be within half the largest rounding unit among their
// currencies of it (AP §8.1); else amount_mismatch, «المبلغ لا يطابق المطلوب».
export function checkLines(
  snapshot: RateSnapshot,
  lines: PaymentLine[],
  due: bigint | null,
): LinesRefusal | null {
  const currencies = new Set(lines.map((line) => line.currency));
  if (lines.length === 0 || currencies.size !== lines.length) return 'invalid_lines';
  if (lines.some((line) => line.amount <= 0n)) return 'invalid_lines';
  if (lines.some((line) => line.currency !== snapshot.baseCurrency)) {
    return 'currency_not_accepted';
  }
  if (due === null) return null;
  const paid = baseTotal(snapshot, lines);
  const largestUnit = lines
    .map((line) => {
      const entry = snapshot.currencies.find((each) => each.code === line.currency)!;
      return toBase(snapshot, entry.roundingUnitMinor, line.currency);
    })
    .reduce((largest, unit) => (unit > largest ? unit : largest), 0n);
  const gap = paid > due ? paid - due : due - paid;
  return 2n * gap <= largestUnit ? null : 'amount_mismatch';
}

export function baseTotal(snapshot: RateSnapshot, lines: PaymentLine[]): bigint {
  return lines.reduce((sum, line) => sum + toBase(snapshot, line.amount, line.currency), 0n);
}

// Lines as stored in jsonb: the amounts as strings.
export function storedLines(lines: PaymentLine[]): { currency: string; amount: string }[] {
  return lines.map((line) => ({ currency: line.currency, amount: line.amount.toString() }));
}

export function linesOf(stored: unknown): PaymentLine[] {
  return (stored as { currency: string; amount: string }[]).map((line) => ({
    currency: line.currency,
    amount: BigInt(line.amount),
  }));
}

// The order as a pickup reads it under its lock.
export interface PickupOrder extends OrderRow {
  currency: string;
  itemsValue: bigint;
  snapshot: RateSnapshot;
  readyAt: Date | null;
  pickedUpAt: Date | null;
}

export async function lockForPickup(
  tx: Tx,
  id: string,
  placedAt: Date,
): Promise<PickupOrder | undefined> {
  const order = await lockOrder(tx, id, placedAt);
  if (!order) return undefined;
  const [money] = await tx
    .select({
      currency: orders.currency,
      itemsValue: orders.itemsValue,
      rateSnapshot: orders.rateSnapshot,
      readyAt: orders.readyAt,
      pickedUpAt: orders.pickedUpAt,
    })
    .from(orders)
    .where(and(eq(orders.id, id), eq(orders.placedAt, placedAt)));
  return {
    ...order,
    currency: money!.currency,
    itemsValue: money!.itemsValue,
    snapshot: snapshotOf(money!.rateSnapshot),
    readyAt: money!.readyAt,
    pickedUpAt: money!.pickedUpAt,
  };
}

// RA §8.10 rules: a pickup request is answered only while the order is
// accepted or ready and the captain is at the restaurant.
export function pickable(order: Pick<OrderRow, 'status' | 'captainTrack' | 'captainId'>): boolean {
  return (
    (order.status === 'accepted' || order.status === 'ready') &&
    order.captainId !== null &&
    (order.captainTrack === 'at_merchant' || order.captainTrack === 'pickup_pending')
  );
}

export type PickupConfirmation = 'restaurant' | 'automatic' | 'operations';

export interface PickupBy {
  outcome: PickupConfirmation;
  actor: { type: 'restaurant' | 'admin' | 'system'; id: string | null; device?: string };
  // Operations' reason, kept with the request and the audit, never published.
  reason?: string;
}

// The atomic pickup (AP §8.1, RA §8.10 item 4): in the transaction that
// holds the order's lock and its open request's, custody.pay_merchant with
// the payment lines and picked_up together; ready recorded at the same moment
// when it was not pressed («لم يُضغط جاهز»). From then the pickup payment is
// frozen.
@Injectable()
export class PickupBooking {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
    private readonly ledger: LedgerService,
  ) {}

  async complete(
    tx: Tx,
    order: PickupOrder,
    requestId: string,
    lines: PaymentLine[],
    by: PickupBy,
    now: Date,
  ): Promise<void> {
    if (order.captainId === null) throw new Error(`order ${order.id} has no captain`);
    const version = order.version + 1;
    await tx
      .update(orders)
      .set({
        status: 'picked_up',
        version,
        captainTrack: 'picked_up',
        pickedUpAt: now,
        readyAt: order.readyAt ?? now,
        readyByPickup: order.readyAt === null,
      })
      .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
    await tx
      .update(pickupRequests)
      .set({
        status: 'confirmed',
        outcome: by.outcome,
        closedAt: now,
        closedByType: by.actor.type,
        closedById: by.actor.id,
        closedByDevice: by.actor.device ?? null,
        bookedLines: storedLines(lines),
        reason: by.reason ?? null,
      })
      .where(eq(pickupRequests.id, requestId));
    await this.post(tx, order, order.captainId, lines, by.actor);
    await recordTransition(tx, this.jobs, order, {
      type: 'order.picked_up',
      from: order.status,
      to: 'picked_up',
      version,
      actor: by.actor,
      reason: by.outcome,
      at: now,
      captainTrack: 'picked_up',
    });
  }

  // AP §8.1, docs/domain/03: a request still open at its confirm_by is
  // confirmed by the server, «تأكيد تلقائي»; true when it was.
  async autoConfirm(job: PickupAutoConfirmJob, now: Date): Promise<boolean> {
    return this.database.db.transaction(async (tx) => {
      const order = await lockForPickup(tx, job.orderId, new Date(job.placedAt));
      if (!order) return false;
      const [request] = await tx
        .select()
        .from(pickupRequests)
        .where(eq(pickupRequests.id, job.requestId))
        .for('update');
      if (!request || request.status !== 'open' || !pickable(order)) return false;
      // A job that starts early by the database's clock is tried again, so
      // the restaurant keeps its whole minute.
      if (request.confirmBy.getTime() > now.getTime()) {
        throw new Error(`pickup request ${request.id} is not due yet`);
      }
      await this.complete(
        tx,
        order,
        request.id,
        linesOf(request.lines),
        { outcome: 'automatic', actor: { type: 'system', id: null } },
        now,
      );
      return true;
    });
  }

  // custody.pay_merchant per currency of the lines (D26, docs/domain/05):
  // the captain's custody down, the order clearing account up. The gap
  // between the lines' base total and the items value, allowed within
  // rounding, goes to platform.fx_rounding (RA §12.7), so the order's
  // clearing account holds the full items value, as the restaurant's account
  // counts it.
  private async post(
    tx: Tx,
    order: PickupOrder,
    captainId: string,
    lines: PaymentLine[],
    actor: PickupBy['actor'],
  ): Promise<void> {
    const { cityId } = order;
    const source = { kind: 'order' as const, id: order.id };
    const ledgerActor: LedgerActor = {
      type: actor.type === 'restaurant' ? 'merchant' : actor.type,
      id: actor.id,
    };
    const entries = [];
    for (const line of lines) {
      const custody = await this.ledger.openAccount(
        { cityId, purpose: 'captain.custody', ownerId: captainId, currency: line.currency },
        tx,
      );
      const clearing = await this.ledger.openAccount(
        { cityId, purpose: 'platform.order_clearing', ownerId: null, currency: line.currency },
        tx,
      );
      entries.push(
        { accountId: custody, currency: line.currency, amount: -line.amount },
        { accountId: clearing, currency: line.currency, amount: line.amount },
      );
    }
    await this.ledger.post(
      { cityId, type: 'custody.pay_merchant', source, actor: ledgerActor, entries },
      tx,
    );
    const gap = order.itemsValue - baseTotal(order.snapshot, lines);
    if (gap === 0n) return;
    const base = order.snapshot.baseCurrency;
    const [clearing, rounding] = await Promise.all([
      this.ledger.openAccount(
        { cityId, purpose: 'platform.order_clearing', ownerId: null, currency: base },
        tx,
      ),
      this.ledger.openAccount(
        { cityId, purpose: 'platform.fx_rounding', ownerId: null, currency: base },
        tx,
      ),
    ]);
    await this.ledger.post(
      {
        cityId,
        type: 'platform.fx_rounding',
        source,
        actor: ledgerActor,
        entries: [
          { accountId: clearing, currency: base, amount: gap },
          { accountId: rounding, currency: base, amount: -gap },
        ],
      },
      tx,
    );
  }
}

// The worker's handler of the automatic confirmation.
@Injectable()
export class PickupTimersWorker implements OnModuleInit {
  private readonly logger = new Logger('PickupTimers');

  constructor(
    private readonly jobs: Jobs,
    private readonly booking: PickupBooking,
  ) {}

  async onModuleInit(): Promise<void> {
    // The restaurant has a minute: poll every second, so the captain does
    // not wait long past it.
    await this.jobs.work<PickupAutoConfirmJob>(
      QUEUES.pickupAutoConfirm,
      async (batch) => {
        for (const job of batch) {
          try {
            if (await this.booking.autoConfirm(job.data, new Date())) {
              this.logger.log({ orderId: job.data.orderId }, 'pickup confirmed automatically');
            }
          } catch (error) {
            // pg-boss tries it again (QUEUE_OPTIONS); each failure is reported.
            this.logger.error(
              { err: error, orderId: job.data.orderId },
              'automatic pickup confirmation failed',
            );
            reportError(error);
            throw error;
          }
        }
      },
      { pollingIntervalSeconds: 1 },
    );
  }
}
