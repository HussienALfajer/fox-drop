import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CaptainsService } from '../captains/index.js';
import { formatMoney, NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { type LedgerActor, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PushQueue } from '../notifications/index.js';
import {
  type MoneyLine,
  type PickupCorrectionPreview,
  type PickupDisputeFacts,
  type PickupDisputes,
  SupportService,
  TicketRefusedError,
} from '../support/index.js';
import { postOrderJournals } from './outcome-facts.js';
import { snapshotOf } from './order-views.js';
import { checkLines, linesOf } from './pickup-booking.js';
import { pickupCorrection } from './pickup-correction.js';
import { orders, pickupDisputes, pickupRequests } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// How long the captain's push of a correction may wait for a phone that is
// off.
const CORRECTION_PUSH_MS = 24 * 3_600_000;

// AP §9.9.3 «خلاف على دفعة الاستلام» (slice 2.23b): what support's ticket
// reads of a dispute after the pickup and «تصحيح في الحسابات», which only
// ordering can work out and post (it owns the pickup, its lines and the
// order's rates). Registered with SupportService at start.
@Injectable()
export class PickupCorrections implements PickupDisputes, OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly support: SupportService,
    private readonly ledger: LedgerService,
    private readonly captains: CaptainsService,
    private readonly merchants: MerchantsService,
    private readonly fx: FxService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  onModuleInit(): void {
    this.support.usePickupDisputes(this);
  }

  async facts(disputeId: string): Promise<PickupDisputeFacts> {
    const dispute = await this.read(disputeId);
    const names = await this.captains.names([dispute.captainId]);
    return {
      pickupPayment: { currency: dispute.currency, amount: dispute.amount },
      recorded: dispute.recorded,
      received: dispute.received,
      openedBy: dispute.openedBy,
      confirmedBy: dispute.confirmedBy,
      captainId: dispute.captainId,
      captainName: names.get(dispute.captainId) ?? null,
      disputedAt: dispute.disputedAt,
      currencies: dispute.snapshot.currencies.map((each) => each.code),
    };
  }

  // 400 invalid_lines (a currency the order did not accept, a repeated
  // currency, a line at zero), no_difference (nothing to post).
  async preview(disputeId: string, received: MoneyLine[]): Promise<PickupCorrectionPreview> {
    const { dispute, correction } = await this.correction(disputeId, received);
    const [captains, restaurants] = await Promise.all([
      this.captains.names([dispute.captainId]),
      this.merchants.names([dispute.restaurantId]),
    ]);
    const name = (kind: string) =>
      kind === 'captain'
        ? (captains.get(dispute.captainId) ?? null)
        : kind === 'merchant'
          ? (restaurants.get(dispute.restaurantId)?.nameAr ?? null)
          : null;
    return {
      captainChanges: correction.captainChanges,
      merchant: { currency: dispute.snapshot.baseCurrency, amount: correction.merchantAmount },
      entries: correction.journals.flatMap((journal) =>
        journal.entries.map((entry) => ({
          type: journal.type,
          reason: journal.reason,
          account: entry.account,
          party: {
            kind: entry.party.kind as 'merchant' | 'captain' | 'platform',
            id: entry.party.id,
            name: name(entry.party.kind),
          },
          amount: { currency: entry.currency, amount: entry.amount },
        })),
      ),
    };
  }

  // In the resolution's transaction (support holds the ticket's lock, so it
  // posts once): the journals, with the order as their source, and the
  // captain's silent push of their custody's change (owner decision
  // 2026-11-17).
  async correct(
    tx: Tx,
    input: { disputeId: string; received: MoneyLine[]; actor: LedgerActor; now: Date },
  ): Promise<string[]> {
    const { dispute, correction } = await this.correction(input.disputeId, input.received, tx);
    const ids = await postOrderJournals(
      tx,
      this.ledger,
      { id: dispute.orderId, cityId: dispute.cityId },
      input.actor,
      correction.journals,
    );
    if (correction.captainChanges.length > 0) {
      const known = new Map(
        (await this.fx.currencies(tx)).map((each) => [
          each.code,
          { symbol: each.symbol, decimals: each.decimals },
        ]),
      );
      const change = correction.captainChanges
        .map(
          (line) =>
            `${line.amount > 0n ? '+' : ''}${formatMoney(line.amount, line.currency, known)}`,
        )
        .join(' · ');
      const templateKey = 'captain.pickup_corrected';
      const rendered = await this.texts.render(
        templateKey,
        { رقم: dispute.orderNumber.toString(), التغيير: change },
        tx,
      );
      await this.pushes.enqueue(
        tx,
        [
          {
            source: `ordering:${templateKey}:${input.disputeId}`,
            recipient: { party: 'captain', captainId: dispute.captainId },
            templateKey,
            body: rendered.body,
            level: rendered.level,
            priority: rendered.priority,
            data: { target: 'custody' },
            at: input.now,
            expiresAt: new Date(input.now.getTime() + CORRECTION_PUSH_MS),
          },
        ],
        input.now,
      );
    }
    return ids;
  }

  private async correction(
    disputeId: string,
    received: MoneyLine[],
    executor: Pick<Database['db'], 'select'> = this.database.db,
  ) {
    const dispute = await this.read(disputeId, executor);
    const refusal = checkLines(
      dispute.snapshot,
      received,
      null,
      dispute.snapshot.currencies.map((each) => each.code),
    );
    if (refusal !== null) throw new TicketRefusedError('invalid_lines', refusal);
    const correction = pickupCorrection({
      snapshot: dispute.snapshot,
      captainId: dispute.captainId,
      restaurantId: dispute.restaurantId,
      recorded: dispute.recorded,
      received,
    });
    if (correction.journals.length === 0) {
      throw new TicketRefusedError('no_difference', 'the lines are those recorded');
    }
    return { dispute, correction };
  }

  // The dispute, the confirmed request it is about (its booked lines and its
  // captain, who paid) and the order's rates. Nothing of it changes after
  // the pickup; posting reads it in the resolution's transaction.
  private async read(
    disputeId: string,
    executor: Pick<Database['db'], 'select'> = this.database.db,
  ) {
    const [row] = await executor
      .select({
        orderId: pickupDisputes.orderId,
        placedAt: pickupDisputes.orderPlacedAt,
        cityId: pickupDisputes.cityId,
        received: pickupDisputes.receivedLines,
        disputedAt: pickupDisputes.createdAt,
        openedBy: pickupDisputes.openedBy,
        captainId: pickupRequests.captainId,
        currency: pickupRequests.currency,
        amount: pickupRequests.amount,
        lines: pickupRequests.lines,
        bookedLines: pickupRequests.bookedLines,
        outcome: pickupRequests.outcome,
      })
      .from(pickupDisputes)
      .innerJoin(pickupRequests, eq(pickupRequests.id, pickupDisputes.pickupRequestId))
      .where(eq(pickupDisputes.id, disputeId));
    if (!row) throw new Error(`pickup dispute ${disputeId} not found`);
    const [order] = await executor
      .select({
        number: orders.number,
        restaurantId: orders.restaurantId,
        rateSnapshot: orders.rateSnapshot,
      })
      .from(orders)
      .where(and(eq(orders.id, row.orderId), eq(orders.placedAt, row.placedAt)));
    if (!order) throw new Error(`order ${row.orderId} not found`);
    return {
      orderId: row.orderId,
      cityId: row.cityId,
      orderNumber: order.number,
      restaurantId: order.restaurantId,
      snapshot: snapshotOf(order.rateSnapshot),
      captainId: row.captainId,
      currency: row.currency,
      amount: row.amount,
      recorded: linesOf(row.bookedLines ?? row.lines),
      received: linesOf(row.received),
      confirmedBy: (row.outcome ?? 'restaurant') as PickupDisputeFacts['confirmedBy'],
      disputedAt: row.disputedAt,
      openedBy: row.openedBy as PickupDisputeFacts['openedBy'],
    };
  }
}
