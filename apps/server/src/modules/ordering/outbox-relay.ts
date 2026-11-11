import {
  Inject,
  Injectable,
  Logger,
  type OnModuleDestroy,
  type OnModuleInit,
} from '@nestjs/common';
import { and, asc, inArray, isNull, notInArray } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import {
  captainChannel,
  merchantChannel,
  opsChannel,
  orderChannel,
  PublishFailedError,
  RealtimePublisher,
  requireRealtime,
} from '../notifications/index.js';
import { outbox } from './schema.js';

// Rows taken per transaction, which holds their locks and a connection while
// it publishes, up to 2 s a call.
const BATCH = 20;

// A run even without a transition, so rows left by runs that gave up (the
// queue's retries end after about an hour) wait at most this long.
const BACKSTOP_MS = 60_000;

// The outbox payload (recordTransition, schema 1).
interface OutboxPayload {
  schema: 1;
  orderId: string;
  number: string;
  cityId: string;
  restaurantId: string;
  customerAccountId: string;
  status: string;
  version: number;
  reason: string | null;
  at: string;
  // From slice 2.7a: operations acted for the restaurant (RA §8.15); absent
  // before.
  byOperations?: boolean;
  // From slice 2.8a: the customer cancelled while placed (RA §8.3); absent
  // before.
  byCustomer?: boolean;
  // From slice 1.11: the captain track (AP §8.2) and the captain the event is
  // about (an offer's, or the one assigned); absent before.
  captainTrack?: string | null;
  captainId?: string | null;
  // From slice 2.12b: a handover's other captain, whose channel hears it too.
  otherCaptainId?: string;
}

// What the apps receive (RA §4.3, CU §4.3): the event's type and the order's
// new state and version, without the ids only the server needs. Clients
// ignore an event whose version is not newer than the one they show.
function publication(type: string, payload: OutboxPayload) {
  const { schema, orderId, number, restaurantId, status, version, reason, at } = payload;
  const captainTrack = payload.captainTrack ?? null;
  const byOperations = payload.byOperations ?? false;
  const byCustomer = payload.byCustomer ?? false;
  return {
    type,
    schema,
    orderId,
    number,
    restaurantId,
    status,
    version,
    reason,
    at,
    byOperations,
    byCustomer,
    captainTrack,
  };
}

// CU §11.2: the customer never sees the captain track as such, so the
// order's channel carries no track and none of the captain's own steps
// before assignment or at the pickup; the app fetches the order on the
// events it gets, and a version it skipped is still older than the next.
const CUSTOMER_SKIPS = new Set([
  'order.search_started',
  'order.offered',
  'order.offer_closed',
  'order.pickup_requested',
  'order.pickup_rejected',
  'order.pickup_disputed',
  // RA §8.14: the restaurant's «حسناً», for its devices only.
  'order.cancellation_acknowledged',
  // RA §8.13: the restaurant's «اطلعت على التعديل»; the captain's pickup
  // waits for it, the customer's order does not change.
  'order.edit_acknowledged',
  // AP §10, CA §9.10.1 (slice 2.12b): the handover's steps before the
  // receipt are the captains' and operations'; the customer hears the
  // receipt only.
  'order.handover_offered',
  'order.handover_assigned',
  'order.handover_closed',
  // CA §9.11 (slice 2.13b): between the captain and operations.
  'order.cannot_complete_requested',
  'order.cannot_complete_withdrawn',
]);

// AP §10: the restaurant hears nothing of a handover but the receipt, which
// changes the captain its board shows.
const MERCHANT_SKIPS = new Set([
  'order.handover_offered',
  'order.handover_assigned',
  'order.handover_closed',
  // CA §9.11: the captain's «لا أستطيع إكمال الطلب» is for operations.
  'order.cannot_complete_requested',
  'order.cannot_complete_withdrawn',
]);

// The restaurant's own steps the captain's channel never carries.
const CAPTAIN_SKIPS = new Set(['order.cancellation_acknowledged']);

// Events whose reason is operations' text for the restaurant (RA §16 #37):
// the captain's and the customer's channels carry them without it (AP §10).
const RESTAURANT_REASONS = new Set(['order.item_report_closed']);

// Events whose reason is for operations and the captain only (AP §10, slice
// 2.12a): the withdrawal's reason code reaches the restaurant's and the
// customer's channels without it; they hear only that the captain changed.
const CAPTAIN_REASONS = new Set(['order.reassigned']);

function customerPublication(type: string, payload: OutboxPayload) {
  const { schema, orderId, number, restaurantId, status, version, at } = payload;
  const reason = RESTAURANT_REASONS.has(type) || CAPTAIN_REASONS.has(type) ? null : payload.reason;
  return { type, schema, orderId, number, restaurantId, status, version, reason, at };
}

// Architecture §5.5, E4: publishes the committed outbox rows to Centrifugo,
// at least once, then marks them. Each run takes the unpublished rows in id
// order, locked and skipping those another run holds, so relays run side by
// side without sending a row twice at once. Ids are taken at insert, not at
// commit, so the relay keeps no «last published id»: it selects by
// published_at alone, and clients order events by the order version
// (RA §4.3). A row is published again only when its mark was lost, and
// Centrifugo drops a repeat of its idempotency key for a few minutes.
@Injectable()
export class OutboxRelay {
  private readonly logger = new Logger('OutboxRelay');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly publisher: RealtimePublisher,
  ) {}

  // Publishes every row it can; the count published. Centrifugo out of reach
  // stops the run; a row it refuses is logged and left for a later run, so it
  // never holds back the others. Throws when any row was left, so the worker
  // reports it and the queue tries again.
  async drain(now: Date): Promise<number> {
    let published = 0;
    const refused: bigint[] = [];
    let failure: PublishFailedError | undefined;
    for (;;) {
      const batch = await this.database.db.transaction(async (tx) => {
        const rows = await tx
          .select({ id: outbox.id, type: outbox.type, payload: outbox.payload })
          .from(outbox)
          .where(
            and(
              isNull(outbox.publishedAt),
              refused.length > 0 ? notInArray(outbox.id, refused) : undefined,
            ),
          )
          .orderBy(asc(outbox.id))
          .limit(BATCH)
          .for('update', { skipLocked: true });
        const done: bigint[] = [];
        for (const row of rows) {
          const payload = row.payload as OutboxPayload;
          try {
            // CA §15: the offer's captain, or the order's once assigned.
            // A handover's event reaches both captains (slice 2.12b).
            const captain = CAPTAIN_SKIPS.has(row.type)
              ? []
              : [payload.captainId, payload.otherCaptainId]
                  .filter((id): id is string => typeof id === 'string' && id.length > 0)
                  .map((id) => captainChannel(id));
            const ownReason = RESTAURANT_REASONS.has(row.type);
            const captainReason = CAPTAIN_REASONS.has(row.type);
            await this.publisher.broadcast(
              [
                ...(captainReason || MERCHANT_SKIPS.has(row.type)
                  ? []
                  : [merchantChannel(payload.restaurantId)]),
                // Architecture §6.2: the panel's board and detail of the city.
                opsChannel(payload.cityId),
                ...(ownReason ? [] : captain),
              ],
              publication(row.type, payload),
              `outbox:${row.id}`,
            );
            if (captainReason) {
              await this.publisher.broadcast(
                [merchantChannel(payload.restaurantId)],
                { ...publication(row.type, payload), reason: null },
                `outbox:${row.id}:merchant`,
              );
            }
            if (ownReason && captain.length > 0) {
              await this.publisher.broadcast(
                captain,
                { ...publication(row.type, payload), reason: null },
                `outbox:${row.id}:captain`,
              );
            }
            if (!CUSTOMER_SKIPS.has(row.type)) {
              await this.publisher.broadcast(
                [orderChannel(payload.orderId)],
                customerPublication(row.type, payload),
                `outbox:${row.id}:order`,
              );
            }
            done.push(row.id);
          } catch (error) {
            if (!(error instanceof PublishFailedError)) throw error;
            failure = error;
            if (!error.answered) break;
            this.logger.error({ err: error, outboxId: row.id.toString() }, 'outbox row refused');
            refused.push(row.id);
          }
        }
        if (done.length > 0) {
          await tx.update(outbox).set({ publishedAt: now }).where(inArray(outbox.id, done));
        }
        return { taken: rows.length, done: done.length };
      });
      published += batch.done;
      if (batch.taken < BATCH || (failure && !failure.answered)) break;
    }
    if (failure) throw failure;
    return published;
  }
}

// The worker's relay: every transition sends a job in its transaction
// (recordTransition), so a run starts as soon as the row commits; a failed
// run is tried again with the queue's backoff, and any later run takes the
// rows it left. One run at start takes the rows written while no worker ran,
// and one a minute those left by runs that gave up.
@Injectable()
export class OutboxRelayWorker implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger('OutboxRelay');
  private backstop: NodeJS.Timeout | undefined;

  constructor(
    private readonly jobs: Jobs,
    private readonly relay: OutboxRelay,
    private readonly publisher: RealtimePublisher,
  ) {}

  async onModuleInit(): Promise<void> {
    requireRealtime('publishing');
    if (!this.publisher.enabled) {
      // Staging until Centrifugo joins it: the rows wait in the outbox.
      this.logger.warn('real time is not configured (CENTRIFUGO_*): the outbox is not relayed');
      return;
    }
    await this.jobs.work(
      QUEUES.outboxRelay,
      async () => {
        try {
          await this.relay.drain(new Date());
        } catch (error) {
          this.logger.error({ err: error }, 'outbox relay failed');
          reportError(error);
          throw error;
        }
      },
      // A burst of transitions sends a job each; one run takes them all.
      { pollingIntervalSeconds: 0.5, batchSize: 50 },
    );
    const run = () =>
      this.jobs.send(QUEUES.outboxRelay, {}, {}).catch((error: unknown) => {
        this.logger.error({ err: error }, 'could not start an outbox relay run');
      });
    await run();
    this.backstop = setInterval(() => void run(), BACKSTOP_MS);
  }

  onModuleDestroy(): void {
    clearInterval(this.backstop);
  }
}
