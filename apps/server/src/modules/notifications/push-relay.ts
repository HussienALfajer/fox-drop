import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationShutdown,
  type OnModuleInit,
} from '@nestjs/common';
import { and, asc, eq, inArray, isNotNull, isNull, lte } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportError } from '../../observability/error-tracking.js';
import {
  criticalAlertsOn,
  PUSH_SENDER,
  type PushInterruption,
  type PushResult,
  type PushSender,
} from './fcm-sender.js';
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

// A push's title unless it has its own (a mass push's): the brand, as the
// apps' name (the texts carry the news).
export const PUSH_TITLE = 'FOX DROP';

type Row = typeof pushMessages.$inferSelect;

// The Android channel of a push: its level, except a restaurant's ring,
// which the restaurant app plays with its bundled sound on `ring_order`
// (slice 2.42, packages/core_push/CLAUDE.md: a channel keeps its first sound),
// and silently on an owner's device with ringing off (RA §4.4, §16), and a
// captain's offer, which the captain app plays with its bundled offer sound
// on `ring_offer` (CA §4.4, slice 2.43).
export function channelOf(row: Pick<Row, 'level' | 'party'>, ringingOff: boolean): string {
  if (row.level === 'offer' && row.party === 'captain') return 'ring_offer';
  if (row.level !== 'ring' || row.party !== 'merchant') return row.level;
  return ringingOff ? 'silent' : 'ring_order';
}

// CU §4.4, §14 #4–#5: the customer's pushes an iPhone shows as
// time-sensitive.
const CUSTOMER_TIME_SENSITIVE = new Set([
  'customer.captain_arrived',
  'customer.captain_arrived_recipient',
  'customer.door_ping',
  'customer.door_ping_recipient',
]);

// How an iPhone shows a push (slice 2.46): a captain's offer is
// time-sensitive (CA §4.4, K15), critical once Apple granted the
// entitlement; the customer's arrival and door ping time-sensitive (CU
// §4.4); a silent push passive, as its Android channel.
export function interruptionOf(
  row: Pick<Row, 'level' | 'party' | 'templateKey'>,
  ringingOff: boolean,
  critical: boolean,
): PushInterruption {
  if (channelOf(row, ringingOff) === 'silent') return 'passive';
  if (row.level === 'offer' && row.party === 'captain') {
    return critical ? 'critical' : 'time-sensitive';
  }
  if (row.party === 'customer' && CUSTOMER_TIME_SENSITIVE.has(row.templateKey)) {
    return 'time-sensitive';
  }
  return 'active';
}

function recipientOf(row: Row): PushRecipient {
  if (row.party === 'customer') return { party: 'customer', accountId: row.accountId! };
  if (row.party === 'captain') {
    return row.captainId === null
      ? { party: 'applicant', accountId: row.accountId! }
      : { party: 'captain', captainId: row.captainId };
  }
  return {
    party: 'merchant',
    restaurantId: row.restaurantId!,
    owners: row.ownersOnly,
    reporter: row.accountId,
  };
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
    // Each batch reads the clock again (from `now`, so tests keep their own
    // time): a push queued while a campaign's thousands are sent is due at
    // the next batch, and each lease counts from its own claim.
    const started = Date.now();
    for (;;) {
      const at = new Date(now.getTime() + (Date.now() - started));
      const rows = await this.database.db.transaction(async (tx) => {
        const due = (campaigns: boolean, limit: number) =>
          tx
            .select()
            .from(pushMessages)
            .where(
              and(
                isNull(pushMessages.sentAt),
                isNull(pushMessages.gaveUpAt),
                lte(pushMessages.nextAttemptAt, at),
                campaigns ? isNotNull(pushMessages.campaignId) : isNull(pushMessages.campaignId),
              ),
            )
            .orderBy(asc(pushMessages.nextAttemptAt), asc(pushMessages.id))
            .limit(limit)
            .for('update', { skipLocked: true });
        // A mass push's thousands wait behind every other due push (AP
        // §9.11.4): each batch takes them only after the others.
        const others = await due(false, BATCH);
        const taken =
          others.length < BATCH ? [...others, ...(await due(true, BATCH - others.length))] : others;
        if (taken.length > 0) {
          await tx
            .update(pushMessages)
            .set({ nextAttemptAt: new Date(at.getTime() + LEASE_MS) })
            .where(
              inArray(
                pushMessages.id,
                taken.map((row) => row.id),
              ),
            );
        }
        return taken;
      });
      for (const row of rows) {
        if (await this.send(row, at)) finished += 1;
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
    const critical = criticalAlertsOn();
    for (const target of targets) {
      const result = await this.sender.send({
        token: target.token,
        title: row.title ?? PUSH_TITLE,
        body: row.body,
        channel: channelOf(row, target.ringingOff),
        priority: row.priority,
        data: { ...row.data, messageId: row.id },
        ttlSeconds: Math.max(1, Math.floor((row.expiresAt.getTime() - now.getTime()) / 1000)),
        interruption: interruptionOf(row, target.ringingOff, critical),
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
