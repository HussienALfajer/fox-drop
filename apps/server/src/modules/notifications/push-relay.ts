import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationShutdown,
  type OnModuleInit,
} from '@nestjs/common';
import { and, asc, eq, isNull, lte } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportError } from '../../observability/error-tracking.js';
import { PUSH_SENDER, type PushResult, type PushSender } from './fcm-sender.js';
import { PushDevices, type PushRecipient } from './push-devices.js';
import { pushMessages } from './schema.js';

// Rows taken per transaction, which holds their locks while it sends.
const BATCH = 20;
// How often the worker looks for pushes: many modules' transactions queue
// them, so a poll of the pending index wakes it rather than a job in each.
export const PUSH_RELAY_MS = 1000;
// The wait before trying a push again: doubles from 2 s, at most a minute.
export function retryDelayMs(attempts: number): number {
  return Math.min(2 ** attempts * 1000, 60_000);
}

// Every push's title: the brand, as the apps' name (the texts carry the news).
export const PUSH_TITLE = 'FOX DROP';

type Row = typeof pushMessages.$inferSelect;

function recipientOf(row: Row): PushRecipient {
  if (row.party === 'customer') return { party: 'customer', accountId: row.accountId! };
  if (row.party === 'captain') return { party: 'captain', captainId: row.captainId! };
  return { party: 'merchant', restaurantId: row.restaurantId!, owners: row.ownersOnly };
}

// Architecture §8.1: sends the queued pushes to every live device of their
// recipient, at least once, with retries and removal of the tokens Firebase
// no longer knows. A push whose devices all failed for a passing reason is
// tried again with a growing delay until it expires; one that reached any
// device, or none (no device registered), is done.
@Injectable()
export class PushRelay {
  private readonly logger = new Logger('PushRelay');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(PUSH_SENDER) private readonly sender: PushSender,
    private readonly devices: PushDevices,
  ) {}

  // The count of pushes it finished (sent or given up).
  async drain(now: Date): Promise<number> {
    let finished = 0;
    for (;;) {
      const batch = await this.database.db.transaction(async (tx) => {
        const rows = await tx
          .select()
          .from(pushMessages)
          .where(
            and(
              isNull(pushMessages.sentAt),
              isNull(pushMessages.gaveUpAt),
              lte(pushMessages.nextAttemptAt, now),
            ),
          )
          .orderBy(asc(pushMessages.nextAttemptAt), asc(pushMessages.id))
          .limit(BATCH)
          .for('update', { skipLocked: true });
        let done = 0;
        for (const row of rows) {
          if (row.expiresAt <= now) {
            await tx.update(pushMessages).set({ gaveUpAt: now }).where(eq(pushMessages.id, row.id));
            done += 1;
            continue;
          }
          const targets = await this.devices.targets(recipientOf(row));
          const results: PushResult[] = [];
          const invalid: string[] = [];
          for (const target of targets) {
            const result = await this.sender.send({
              token: target.token,
              title: PUSH_TITLE,
              body: row.body,
              channel: row.level,
              priority: row.priority,
              data: { ...row.data, messageId: row.id },
              ttlSeconds: Math.max(1, Math.floor((row.expiresAt.getTime() - now.getTime()) / 1000)),
            });
            results.push(result);
            if (result === 'invalid') invalid.push(target.token);
          }
          await this.devices.invalidate(tx, invalid, now);
          const sent = results.filter((result) => result === 'sent').length;
          if (sent === 0 && results.includes('retry')) {
            await tx
              .update(pushMessages)
              .set({
                attempts: row.attempts + 1,
                nextAttemptAt: new Date(now.getTime() + retryDelayMs(row.attempts + 1)),
              })
              .where(eq(pushMessages.id, row.id));
            continue;
          }
          if (results.includes('failed')) {
            this.logger.error(
              { pushMessageId: row.id, templateKey: row.templateKey },
              'FCM refused a push',
            );
          }
          await tx
            .update(pushMessages)
            .set({ sentAt: now, devices: sent })
            .where(eq(pushMessages.id, row.id));
          done += 1;
        }
        return { taken: rows.length, done };
      });
      finished += batch.done;
      if (batch.taken < BATCH) break;
    }
    return finished;
  }
}

// The worker's loop of the relay, every PUSH_RELAY_MS; a slow run is never
// overlapped by the next. While push is off (no FCM_SERVICE_ACCOUNT) the
// pushes wait, and those older than their time are given up once it is on.
@Injectable()
export class PushRelayWorker implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger('PushRelay');
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;
  private failing = false;

  constructor(
    private readonly relay: PushRelay,
    @Inject(PUSH_SENDER) private readonly sender: PushSender | null,
  ) {}

  onModuleInit(): void {
    if (!this.sender) {
      this.logger.warn('push is not configured (FCM_SERVICE_ACCOUNT): pushes are not sent');
      return;
    }
    this.timer = setInterval(() => {
      this.running ??= this.relay
        .drain(new Date())
        .then(() => {
          this.failing = false;
        })
        .catch((error: unknown) => {
          // Reported once per outage, not every second.
          if (this.failing) return;
          this.failing = true;
          this.logger.error({ err: error }, 'push relay failed');
          reportError(error);
        })
        .finally(() => {
          this.running = undefined;
        });
    }, PUSH_RELAY_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
