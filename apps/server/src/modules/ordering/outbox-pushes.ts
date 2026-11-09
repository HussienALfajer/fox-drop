import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationShutdown,
  type OnModuleInit,
} from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNull, lte, notInArray } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportError } from '../../observability/error-tracking.js';
import { CaptainsService } from '../captains/index.js';
import { GENERIC_CUSTOMER_TEXT, NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PushQueue, type QueuedPush } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import {
  formatMoney,
  formatTime,
  orderPushes,
  type OrderPushFacts,
  PICKUP_EVENTS,
} from './order-pushes.js';
import { orderEvents, orders, outbox, pickupRequests } from './schema.js';
import { unansweredInBusinessDay } from './unanswered.js';

// Rows taken per transaction, which holds their locks while it reads what
// the pushes say.
const BATCH = 20;
// How often the worker looks for events to push: «within seconds», as the
// apps' real time (a poll of the unqueued rows' index).
export const OUTBOX_PUSH_MS = 1000;

interface OutboxPayload {
  orderId: string;
  number: string;
  cityId: string;
  version: number;
  reason: string | null;
  at: string;
  captainId?: string | null;
  offerPay?: { amount: string; currency: string } | null;
  offerExpiresAt?: string;
}

interface Line {
  amount: string;
  currency: string;
}

type Currencies = ReadonlyMap<string, { symbol: string; decimals: number }>;

// Architecture §8.1, E4: turns each committed order event into the pushes
// of CU §14, RA §16 and CA §14 (order-pushes.ts), rendered from their
// templates (AP §9.13) and queued for the push relay in the transaction that
// marks the event, so each is queued once; a repeat of a lost mark is
// dropped by the push's source. Apart from the real-time relay, so neither
// holds the other back.
@Injectable()
export class OutboxPushes {
  private readonly logger = new Logger('OutboxPushes');
  private currencies: Currencies | undefined;
  // The rows whose failure was reported, so a row failing every second is
  // reported once.
  private readonly reported = new Set<bigint>();

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly queue: PushQueue,
    private readonly texts: NotificationTexts,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
    private readonly settings: SettingsService,
  ) {}

  // The count of events whose pushes it queued. What the pushes say is read
  // before the transaction (the other modules' reads take pool connections of
  // their own); the transaction then takes the rows no other run took.
  // A row whose pushes cannot be read (a template or a value that fails) is
  // logged and reported once and left unqueued for the next run, so it never
  // holds back the events after it.
  async drain(now: Date): Promise<number> {
    let queued = 0;
    const failed: bigint[] = [];
    for (;;) {
      const rows = await this.database.db
        .select({
          id: outbox.id,
          type: outbox.type,
          payload: outbox.payload,
          createdAt: outbox.createdAt,
        })
        .from(outbox)
        .where(
          and(
            isNull(outbox.pushQueuedAt),
            failed.length > 0 ? notInArray(outbox.id, failed) : undefined,
          ),
        )
        .orderBy(asc(outbox.id))
        .limit(BATCH);
      const pushes = new Map<bigint, QueuedPush[]>();
      for (const row of rows) {
        try {
          const found = await this.pushesOf(row.type, row.payload as OutboxPayload, now);
          pushes.set(
            row.id,
            found.map((push) => ({
              ...push,
              source: `outbox:${row.id}:${push.source}`,
              // CU §13: its time is the event's, and so is its expiry.
              at: row.createdAt,
            })),
          );
        } catch (error) {
          failed.push(row.id);
          if (!this.reported.has(row.id)) {
            this.reported.add(row.id);
            this.logger.error(
              { err: error, outboxId: row.id.toString() },
              "an order event's pushes could not be read",
            );
            reportError(error);
          }
        }
      }
      const ready = rows.filter((row) => pushes.has(row.id));
      const taken = await this.database.db.transaction(async (tx) => {
        const locked = ready.length
          ? await tx
              .select({ id: outbox.id })
              .from(outbox)
              .where(
                and(
                  inArray(
                    outbox.id,
                    ready.map((row) => row.id),
                  ),
                  isNull(outbox.pushQueuedAt),
                ),
              )
              .for('update', { skipLocked: true })
          : [];
        if (locked.length === 0) return 0;
        await this.queue.enqueue(
          tx,
          locked.flatMap((row) => pushes.get(row.id) ?? []),
          now,
        );
        await tx
          .update(outbox)
          .set({ pushQueuedAt: now })
          .where(
            inArray(
              outbox.id,
              locked.map((row) => row.id),
            ),
          );
        return locked.length;
      });
      queued += taken;
      if (rows.length < BATCH) break;
    }
    return queued;
  }

  private async pushesOf(type: string, payload: OutboxPayload, now: Date): Promise<QueuedPush[]> {
    const facts = await this.facts(type, payload, now);
    if (facts === null) return [];
    const pushes = orderPushes(type, payload.reason, facts);
    return Promise.all(
      pushes.map(async (push) => {
        const rendered = await this.texts.render(push.templateKey, push.values);
        return {
          source: `${push.party}:${push.templateKey}`,
          recipient: push.recipient,
          templateKey: push.templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: push.data,
          // CA §14 #1–2: an offer's push ends with the offer.
          ...(type === 'order.offered' && payload.offerExpiresAt
            ? { expiresAt: new Date(payload.offerExpiresAt) }
            : {}),
        };
      }),
    );
  }

  // What the event's pushes say, read through the transaction for the
  // order's own rows and from the other modules' services.
  private async facts(
    type: string,
    payload: OutboxPayload,
    now: Date,
  ): Promise<OrderPushFacts | null> {
    const db = this.database.db;
    const [order] = await db.select().from(orders).where(eq(orders.id, payload.orderId));
    if (!order) return null;
    const [event] = await db
      .select({ actorType: orderEvents.actorType })
      .from(orderEvents)
      .where(
        and(
          eq(orderEvents.orderId, order.id),
          eq(orderEvents.orderPlacedAt, order.placedAt),
          eq(orderEvents.version, payload.version),
        ),
      );
    const currencies = await this.knownCurrencies();
    // The captain the event was about; an event older than the payload's
    // captain falls back to the order's.
    const captainId = 'captainId' in payload ? (payload.captainId ?? null) : order.captainId;
    const [names, captain, timeZone] = await Promise.all([
      this.merchants.names([order.restaurantId]),
      captainId ? this.captains.captain(captainId, now) : null,
      this.geo.cityTimeZone(order.cityId),
    ]);
    const pickup = PICKUP_EVENTS.has(type) ? await this.pickup(order, new Date(payload.at)) : null;
    const money = (lines: Line[] | null) =>
      lines && lines.length > 0
        ? lines
            .map((line) => formatMoney(BigInt(line.amount), line.currency, currencies))
            .join(' + ')
        : null;
    return {
      orderId: order.id,
      number: order.number.toString(),
      customerAccountId: order.customerAccountId,
      restaurantId: order.restaurantId,
      restaurantName: names.get(order.restaurantId)?.nameAr ?? '',
      captainId,
      captainFirstName: captain ? captain.name.trim().split(/\s+/)[0]! : null,
      recipientName: order.recipientName,
      promisedTime: order.promisedAt && timeZone ? formatTime(order.promisedAt, timeZone) : null,
      total: formatMoney(order.total, order.currency, currencies),
      cancelText:
        order.status === 'cancelled' ? (order.cancelCustomerText ?? GENERIC_CUSTOMER_TEXT) : null,
      cancelReason: order.cancelReason,
      rejectText: order.status === 'rejected' ? order.rejectCustomerText : null,
      rejectLabel: order.status === 'rejected' ? order.rejectReasonLabel : null,
      prepMin: order.prepMin,
      actor: event?.actorType ?? 'system',
      pickupAmount: pickup ? formatMoney(pickup.amount, pickup.currency, currencies) : null,
      receivedAmount: money(pickup?.receivedLines ?? null),
      offerPay: payload.offerPay
        ? formatMoney(BigInt(payload.offerPay.amount), payload.offerPay.currency, currencies)
        : null,
      unanswered:
        type === 'order.cancelled' && order.cancelReason === 'merchant_auto_cancel' && timeZone
          ? await this.unanswered(order, timeZone)
          : null,
    };
  }

  // The request the event is about: the latest opened by the event's time,
  // never one the captain opened since.
  private async pickup(order: typeof orders.$inferSelect, at: Date) {
    const [request] = await this.database.db
      .select({
        amount: pickupRequests.amount,
        currency: pickupRequests.currency,
        receivedLines: pickupRequests.receivedLines,
      })
      .from(pickupRequests)
      .where(
        and(
          eq(pickupRequests.orderId, order.id),
          eq(pickupRequests.orderPlacedAt, order.placedAt),
          lte(pickupRequests.openedAt, at),
        ),
      )
      .orderBy(desc(pickupRequests.openedAt))
      .limit(1);
    return request
      ? { ...request, receivedLines: (request.receivedLines as Line[] | null) ?? null }
      : null;
  }

  // RA §16 #2, RA §11: the restaurant's unanswered orders of the
  // cancellation's business day up to it, and the count that pauses it.
  private async unanswered(
    order: typeof orders.$inferSelect,
    timeZone: string,
  ): Promise<{ count: number; limit: number } | null> {
    if (order.cancelledAt === null) return null;
    return unansweredInBusinessDay(this.database.db, this.settings, {
      restaurantId: order.restaurantId,
      cityId: order.cityId,
      moment: order.cancelledAt,
      timeZone,
    });
  }

  private async knownCurrencies(): Promise<Currencies> {
    this.currencies ??= new Map(
      (await this.fx.currencies()).map((currency) => [
        currency.code,
        { symbol: currency.symbol, decimals: currency.decimals },
      ]),
    );
    return this.currencies;
  }
}

// The worker's loop, every OUTBOX_PUSH_MS; a slow run is never overlapped by
// the next. It queues whether push is on or not: the push relay sends them
// while it is, and a customer's are «الإشعارات» either way (CU §13).
@Injectable()
export class OutboxPushesWorker implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger('OutboxPushes');
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;
  private failing = false;

  constructor(private readonly pushes: OutboxPushes) {}

  onModuleInit(): void {
    this.timer = setInterval(() => {
      this.running ??= this.pushes
        .drain(new Date())
        .then(() => {
          this.failing = false;
        })
        .catch((error: unknown) => {
          // Reported once per outage, not every second.
          if (this.failing) return;
          this.failing = true;
          this.logger.error({ err: error }, 'queuing the order pushes failed');
          reportError(error);
        })
        .finally(() => {
          this.running = undefined;
        });
    }, OUTBOX_PUSH_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
