import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CaptainsService } from '../captains/index.js';
import { formatMoney, NotificationTexts } from '../content/index.js';
import { FxService, toBase } from '../fx/index.js';
import { type LedgerActor, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PushQueue, type QueuedPush } from '../notifications/index.js';
import {
  type StoredAffectedLine,
  SupportService,
  type TicketMoneyInput,
  type TicketMoneyPreview,
  type TicketOrderFacts,
  type TicketOrders,
  TicketRefusedError,
} from '../support/index.js';
import { merchantItemDiscount } from './order-discount.js';
import { orderKey, type OrderView, readOrders } from './order-views.js';
import { postOrderJournals } from './outcome-facts.js';
import { orders as schemaOrders } from './schema.js';
import { affectedValue, commissionOn, ticketMoneyEntries } from './ticket-money.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// How long the debit's and the charge's pushes may wait for a phone that is
// off.
const MONEY_PUSH_MS = 24 * 3_600_000;

// AP §8.10, §9.9.3 (slice 2.23c): what support's ticket reads of its order
// and the entries of a problem after a normal delivery, which only ordering
// can work out and post (it owns the order, its lines and its commission).
// Registered with SupportService at start, as PickupCorrections is.
@Injectable()
export class TicketMoney implements TicketOrders, OnModuleInit {
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
    this.support.useTicketOrders(this);
  }

  async facts(orderId: string): Promise<TicketOrderFacts | null> {
    const order = await this.find(orderId);
    if (order === null) return null;
    return {
      orderId: order.id,
      cityId: order.cityId,
      number: order.number,
      customerAccountId: order.customerAccountId,
      restaurantId: order.restaurantId,
      captainId: order.captainId,
      currency: order.currency,
      total: order.money.total,
      itemsValue: order.money.itemsValue,
      deliveredNormally: deliveredNormally(order),
      lines: order.lines.map((line) => ({
        position: line.position,
        name: line.name,
        quantity: line.quantity,
        unitPrice: line.unitPrice,
        lineTotal: line.lineTotal,
      })),
      received: order.delivery?.received ?? [],
      change: order.delivery?.change ?? [],
      receivedTotal: (order.delivery?.received ?? []).reduce(
        (sum, line) => sum + toBase(order.snapshot, line.amount, line.currency),
        0n,
      ),
      testOrder: order.testOrder,
    };
  }

  // 400 invalid_affected (a line not the order's, named twice, or a
  // quantity beyond it).
  async preview(orderId: string, input: TicketMoneyInput): Promise<TicketMoneyPreview> {
    const { order, booking, value } = await this.booking(orderId, input);
    const [captains, restaurants] = await Promise.all([
      this.captains.names(order.captainId === null ? [] : [order.captainId]),
      this.merchants.names([order.restaurantId]),
    ]);
    const name = (kind: string) =>
      kind === 'captain'
        ? (captains.get(order.captainId!) ?? null)
        : kind === 'merchant'
          ? (restaurants.get(order.restaurantId)?.nameAr ?? null)
          : null;
    return {
      currency: order.currency,
      affectedValue: value,
      merchantDebit: merchantOwes(booking.journals),
      captainCharge: booking.captainCharge,
      entries: booking.journals.flatMap((journal) =>
        journal.entries.map((entry) => ({
          type: journal.type,
          reason: journal.reason,
          account: entry.account,
          party: {
            kind: entry.party.kind,
            id: entry.party.id,
            name: name(entry.party.kind),
          },
          amount: { currency: entry.currency, amount: entry.amount },
        })),
      ),
    };
  }

  // In the resolution's transaction (support holds the ticket's lock, so it
  // posts once): the journals with the order as their source, then the
  // owners' silent push of the restaurant's debit and the captain's of
  // their charge (AP §10, CA §14 #14).
  async post(
    tx: Tx,
    input: {
      orderId: string;
      ticketId: string;
      ticketNumber: bigint;
      money: TicketMoneyInput;
      actor: LedgerActor;
      now: Date;
    },
  ): Promise<{ journalIds: string[]; affected: StoredAffectedLine[]; affectedValue: bigint }> {
    const { order, booking, value } = await this.booking(input.orderId, input.money, tx);
    const journalIds = await postOrderJournals(
      tx,
      this.ledger,
      { id: order.id, cityId: order.cityId },
      input.actor,
      booking.journals,
    );
    const known = new Map(
      (await this.fx.currencies(tx)).map((each) => [
        each.code,
        { symbol: each.symbol, decimals: each.decimals },
      ]),
    );
    const owes = merchantOwes(booking.journals);
    const pushes: QueuedPush[] = [];
    const expiresAt = new Date(input.now.getTime() + MONEY_PUSH_MS);
    if (owes > 0n) {
      const templateKey = 'merchant.ticket_debit';
      const rendered = await this.texts.render(
        templateKey,
        { رقم: order.number.toString(), المبلغ: formatMoney(owes, order.currency, known) },
        tx,
      );
      pushes.push({
        source: `ordering:${templateKey}:${input.ticketId}`,
        recipient: { party: 'merchant', restaurantId: order.restaurantId, owners: true },
        templateKey,
        body: rendered.body,
        level: rendered.level,
        priority: rendered.priority,
        data: { target: 'account' },
        at: input.now,
        expiresAt,
      });
    }
    for (const journal of booking.journals) {
      if (journal.type !== 'earn.charge') continue;
      const entry = journal.entries.find((each) => each.account === 'captain.earnings')!;
      const templateKey = 'captain.charge';
      const rendered = await this.texts.render(
        templateKey,
        {
          المبلغ: formatMoney(entry.amount, entry.currency, known),
          السبب: journal.reason ?? '',
        },
        tx,
      );
      pushes.push({
        source: `ordering:${templateKey}:ticket:${input.ticketId}:${journal.reason}`,
        recipient: { party: 'captain', captainId: entry.party.id! },
        templateKey,
        body: rendered.body,
        level: rendered.level,
        priority: rendered.priority,
        data: { target: 'earnings' },
        at: input.now,
        expiresAt,
      });
    }
    if (pushes.length > 0) await this.pushes.enqueue(tx, pushes, input.now);
    const byPosition = new Map(order.lines.map((line) => [line.position, line]));
    return {
      journalIds,
      affectedValue: value,
      affected: input.money.affected.map((each) => {
        const line = byPosition.get(each.position)!;
        return { ...each, name: line.name, value: line.unitPrice * BigInt(each.quantity) };
      }),
    };
  }

  private async booking(
    orderId: string,
    money: TicketMoneyInput,
    executor: Pick<Database['db'], 'select'> = this.database.db,
  ) {
    const order = await this.read(orderId, executor);
    const value = affectedValue(order.lines, money.affected);
    // A line at no price affects nothing: V is above zero once items are named.
    if (value === null || (money.affected.length > 0 && value === 0n)) {
      throw new TicketRefusedError('invalid_affected', 'the affected lines');
    }
    const itemDiscount = merchantItemDiscount({
      total: order.money.discount,
      merchant: order.discountMerchant,
      onDelivery: order.discountOnDelivery,
    });
    const booking = ticketMoneyEntries({
      responsible: money.responsible,
      restaurantId: order.restaurantId,
      captainId: order.captainId,
      currency: order.currency,
      itemsValue: order.money.itemsValue,
      // AP §8.4: on the items value after the restaurant-funded item
      // discount; none on a test order (AP §9.6.3).
      commissionOf: commissionOn(order.commissionBp, itemDiscount, order.testOrder),
      affected: value,
      wrongChange: money.wrongChange,
    });
    // AP §9.6.3 (decided by us): a test order's problem keeps V and M on the
    // ticket and posts nothing, so no test money reaches the costs.
    if (order.testOrder)
      return { order, booking: { ...booking, journals: [], captainCharge: 0n }, value };
    return { order, booking, value };
  }

  // The order by its id alone (support keeps no `placed_at`), in any month's
  // partition.
  private async read(
    orderId: string,
    executor: Pick<Database['db'], 'select'> = this.database.db,
  ): Promise<OrderView> {
    const order = await this.find(orderId, executor);
    if (order === null) throw new Error(`order ${orderId} not found`);
    return order;
  }

  private async find(
    orderId: string,
    executor: Pick<Database['db'], 'select'> = this.database.db,
  ): Promise<OrderView | null> {
    const [placed] = await executor
      .select({ placedAt: schemaOrders.placedAt })
      .from(schemaOrders)
      .where(eq(schemaOrders.id, orderId));
    if (!placed) return null;
    const [order] = await readOrders(executor, orderKey(orderId, placed.placedAt));
    return order ?? null;
  }
}

// docs/domain/10: a problem after a normal delivery has money only on an
// order delivered with the outcome normal (no outcome set).
function deliveredNormally(order: OrderView): boolean {
  return (
    order.status === 'delivered' && order.delivery?.outcome === 'normal' && order.outcome === null
  );
}

// What the restaurant ends up owing from the journals: its account's entries
// (+ it owes), the debit less the commission reversed.
function merchantOwes(journals: ReturnType<typeof ticketMoneyEntries>['journals']): bigint {
  return journals
    .flatMap((journal) => journal.entries)
    .filter((entry) => entry.account === 'merchant.account')
    .reduce((sum, entry) => sum + entry.amount, 0n);
}
