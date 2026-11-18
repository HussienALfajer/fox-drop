import { Inject, Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { and, desc, eq, gte, inArray, isNull, lte, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import type { PushRecipient } from './push-devices.js';
import { pushMessages } from './schema.js';

// How long a push may wait for a device that is off or a failing FCM: a push
// about an order's step is no use later (architecture §8.1).
export const PUSH_TTL_SECONDS = 600;

// CU §13 «الإشعارات»: the pushes of the last 30 days (fixed).
export const INBOX_DAYS = 30;
const INBOX_MAX = 200;
// Rows per insert: a mass push queues one per customer of its audience.
const INSERT_CHUNK = 1000;

export interface QueuedPush {
  // What queued it, once: a repeat with the same source adds nothing.
  source: string;
  recipient: PushRecipient;
  templateKey: string;
  body: string;
  level: string;
  priority: 'high' | 'normal';
  data: Record<string, string>;
  // When what it tells happened, which its time and expiry count from; the
  // queuing time when left out.
  at?: Date;
  // Its own end, such as an offer's (CA §14 #1); at + PUSH_TTL_SECONDS when
  // left out.
  expiresAt?: Date;
  // The phone's title; the brand (PUSH_TITLE) when left out.
  title?: string;
  // AP §9.11.4 (slice 2.27d): the mass push it belongs to. Such a push is
  // sent after every other due push, so a campaign never holds back an
  // order's.
  campaignId?: string;
}

// A mass push's counts (AP §9.11.4): its recipients, those FCM accepted for
// a device («أُرسل») and those an app acknowledged («وصل»).
export interface CampaignCounts {
  recipients: number;
  sent: number;
  delivered: number;
}

export interface InboxEntry {
  id: string;
  at: Date;
  body: string;
  data: Record<string, string>;
}

type Executor = Pick<Database['db'], 'insert' | 'select'>;
type Updater = Pick<Database['db'], 'update'>;

// Queues pushes in the caller's transaction (E4), so a push exists exactly
// when what it tells committed; the worker's push relay sends them.
@Injectable()
export class PushQueue {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  // A push whose `at` is ahead (a scheduled mass push) waits for it: the
  // relay takes it then, and «الإشعارات» shows it from then.
  async enqueue(executor: Executor, pushes: QueuedPush[], now: Date): Promise<void> {
    for (let start = 0; start < pushes.length; start += INSERT_CHUNK) {
      await executor
        .insert(pushMessages)
        .values(pushes.slice(start, start + INSERT_CHUNK).map((push) => rowOf(push, now)))
        .onConflictDoNothing({ target: pushMessages.source });
    }
  }

  // AP §9.11.4: a scheduled mass push cancelled before its time; its pushes
  // not sent are given up, so the relay never takes them.
  async cancelCampaign(executor: Updater, campaignId: string, now: Date): Promise<void> {
    await executor
      .update(pushMessages)
      .set({ gaveUpAt: now })
      .where(
        and(
          eq(pushMessages.campaignId, campaignId),
          isNull(pushMessages.sentAt),
          isNull(pushMessages.gaveUpAt),
        ),
      );
  }

  // AP §9.11.4 «الإشعارات الجماعية»: each campaign's counts; one without
  // pushes is missing from the map.
  async campaignCounts(campaignIds: string[]): Promise<Map<string, CampaignCounts>> {
    if (campaignIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({
        campaignId: pushMessages.campaignId,
        recipients: sql<number>`count(*)::int`,
        sent: sql<number>`(count(*) FILTER (WHERE ${pushMessages.devices} > 0))::int`,
        delivered: sql<number>`(count(*) FILTER (WHERE ${pushMessages.deliveredAt} IS NOT NULL))::int`,
      })
      .from(pushMessages)
      .where(inArray(pushMessages.campaignId, campaignIds))
      .groupBy(pushMessages.campaignId);
    return new Map(
      rows.map((row) => [
        row.campaignId!,
        {
          recipients: Number(row.recipients),
          sent: Number(row.sent),
          delivered: Number(row.delivered),
        },
      ]),
    );
  }

  // The app's receipt («وصل», AP §9.11.4): the first acknowledgement of a
  // customer's push counts; a repeat or an unknown id changes nothing. The
  // receipt may come before the relay records FCM's answer, so it does not
  // ask for sent_at.
  async acknowledge(messageId: string, now: Date): Promise<void> {
    await this.database.db
      .update(pushMessages)
      .set({ deliveredAt: now })
      .where(
        and(
          eq(pushMessages.id, messageId),
          eq(pushMessages.party, 'customer'),
          isNull(pushMessages.deliveredAt),
          isNull(pushMessages.gaveUpAt),
          lte(pushMessages.createdAt, now),
        ),
      );
  }

  // AP §9.3.2 «إعادة إرسال الإشعار»: queues again the latest of the order's
  // pushes to the recipient among the templates that tell its current state
  // (the caller knows which). Null when the order sent none of them.
  async resend(
    executor: Executor,
    orderId: string,
    recipient: PushRecipient,
    templateKeys: string[],
    now: Date,
  ): Promise<{ templateKey: string; body: string } | null> {
    if (templateKeys.length === 0) return null;
    const whose =
      recipient.party === 'customer'
        ? eq(pushMessages.accountId, recipient.accountId)
        : recipient.party === 'captain'
          ? eq(pushMessages.captainId, recipient.captainId)
          : eq(pushMessages.restaurantId, recipient.restaurantId);
    const [latest] = await executor
      .select()
      .from(pushMessages)
      .where(
        and(
          eq(pushMessages.party, recipient.party),
          whose,
          inArray(pushMessages.templateKey, templateKeys),
          sql`${pushMessages.data}->>'orderId' = ${orderId}`,
        ),
      )
      .orderBy(desc(pushMessages.createdAt), desc(pushMessages.id))
      .limit(1);
    if (!latest) return null;
    await this.enqueue(
      executor,
      [
        {
          source: `resend:${randomUUID()}`,
          recipient,
          templateKey: latest.templateKey,
          body: latest.body,
          level: latest.level,
          priority: latest.priority,
          data: latest.data,
        },
      ],
      now,
    );
    return { templateKey: latest.templateKey, body: latest.body };
  }

  // CU §13: a customer's pushes of the last 30 days, newest first.
  async inbox(accountId: string, now: Date): Promise<InboxEntry[]> {
    const rows = await this.database.db
      .select({
        id: pushMessages.id,
        at: pushMessages.createdAt,
        body: pushMessages.body,
        data: pushMessages.data,
      })
      .from(pushMessages)
      .where(
        and(
          eq(pushMessages.party, 'customer'),
          eq(pushMessages.accountId, accountId),
          gte(pushMessages.createdAt, new Date(now.getTime() - INBOX_DAYS * 86_400_000)),
          // A push shows once its time came; a mass push once the relay sent
          // it or gave it up at its expiry (CU §14: every push is stored),
          // never when cancelled (given up before its time).
          lte(pushMessages.createdAt, now),
          sql`(${pushMessages.campaignId} IS NULL OR ${pushMessages.sentAt} IS NOT NULL OR ${pushMessages.gaveUpAt} >= ${pushMessages.expiresAt})`,
        ),
      )
      .orderBy(desc(pushMessages.createdAt), desc(pushMessages.id))
      .limit(INBOX_MAX);
    return rows;
  }
}

function rowOf(push: QueuedPush, now: Date): typeof pushMessages.$inferInsert {
  const at = push.at ?? now;
  return {
    createdAt: at,
    source: push.source,
    party: push.recipient.party,
    accountId:
      push.recipient.party === 'customer'
        ? push.recipient.accountId
        : push.recipient.party === 'merchant'
          ? (push.recipient.reporter ?? null)
          : null,
    restaurantId: push.recipient.party === 'merchant' ? push.recipient.restaurantId : null,
    ownersOnly: push.recipient.party === 'merchant' && push.recipient.owners,
    captainId: push.recipient.party === 'captain' ? push.recipient.captainId : null,
    templateKey: push.templateKey,
    title: push.title ?? null,
    body: push.body,
    level: push.level,
    priority: push.priority,
    data: push.data,
    expiresAt: push.expiresAt ?? new Date(at.getTime() + PUSH_TTL_SECONDS * 1000),
    nextAttemptAt: at > now ? at : now,
    campaignId: push.campaignId ?? null,
  };
}
