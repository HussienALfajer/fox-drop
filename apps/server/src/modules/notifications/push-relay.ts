import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationShutdown,
  type OnModuleInit,
} from '@nestjs/common';
import { and, asc, eq, inArray, isNull, lte } from 'drizzle-orm';
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
// How long a claimed batch stays out of other runs' reach: longer than its
// sends can take (5 s per device at most), so a run that died leaves its rows
// to the next after it.
const LEASE_MS = 120_000;
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

  // The count of pushes it finished (sent or given up). Each batch is
  // claimed in a short transaction that moves its rows' next attempt past a
  // lease, so no other run takes them; the devices are read and FCM is
  // called outside any transaction, and each outcome is written in its own.
  async drain(now: Date): Promise<number> {
    let finished = 0;
    for (;;) {
      const rows = await this.database.db.transaction(async (tx) => {
        const due = await tx
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
        if (due.length > 0) {
          await tx
            .update(pushMessages)
            .set({ nextAttemptAt: new Date(now.getTime() + LEASE_MS) })
            .where(
              inArray(
                pushMessages.id,
                due.map((row) => row.id),
              ),
            );
        }
        return due;
      });
      for (const row of rows) {
        if (await this.send(row, now)) finished += 1;
      }
      if (rows.length < BATCH) break;
    }
    return finished;
  }

  // Whether the push is finished: sent, or given up.
  private async send(row: Row, now: Date): Promise<boolean> {
    if (row.expiresAt <= now) {
      await this.database.db
        .update(pushMessages)
        .set({ gaveUpAt: now })
        .where(eq(pushMessages.id, row.id));
      return true;
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
    const sent = results.filter((result) => result === 'sent').length;
    const retry = sent === 0 && results.includes('retry');
    if (!retry && results.includes('failed')) {
      this.logger.error(
        { pushMessageId: row.id, templateKey: row.templateKey },
        'FCM refused a push',
      );
    }
    if (invalid.length > 0) {
      // Visible in the logs, so FCM ending many devices at once is noticed.
      this.logger.warn(
        { pushMessageId: row.id, ended: invalid.length },
        'FCM no longer knows some devices',
      );
    }
    await this.database.db.transaction(async (tx) => {
      await this.devices.invalidate(tx, invalid, now);
      await tx
        .update(pushMessages)
        .set(
          retry
            ? {
                attempts: row.attempts + 1,
                nextAttemptAt: new Date(now.getTime() + retryDelayMs(row.attempts + 1)),
              }
            : { sentAt: now, devices: sent },
        )
        .where(eq(pushMessages.id, row.id));
    });
    return !retry;
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
