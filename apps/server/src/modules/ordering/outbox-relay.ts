import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, asc, inArray, isNull, notInArray } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import {
  merchantChannel,
  orderChannel,
  PublishFailedError,
  RealtimePublisher,
} from '../notifications/index.js';
import { outbox } from './schema.js';

// Rows taken per transaction, which holds their locks while it publishes.
const BATCH = 50;

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
          const payload = row.payload as { orderId: string; restaurantId: string };
          try {
            await this.publisher.broadcast(
              [merchantChannel(payload.restaurantId), orderChannel(payload.orderId)],
              payload,
              `outbox:${row.id}`,
            );
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
// rows it left. One run at start takes the rows written while no worker ran.
@Injectable()
export class OutboxRelayWorker implements OnModuleInit {
  private readonly logger = new Logger('OutboxRelay');

  constructor(
    private readonly jobs: Jobs,
    private readonly relay: OutboxRelay,
    private readonly publisher: RealtimePublisher,
  ) {}

  async onModuleInit(): Promise<void> {
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
    await this.jobs.send(QUEUES.outboxRelay, {}, {});
  }
}
