import { Inject, Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { and, desc, eq, gte, sql } from 'drizzle-orm';
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

export interface QueuedPush {
  // What queued it, once: a repeat with the same source adds nothing.
  source: string;
  recipient: PushRecipient;
  templateKey: string;
  body: string;
  level: string;
  priority: 'high' | 'normal';
  data: Record<string, string>;
}

export interface InboxEntry {
  id: string;
  at: Date;
  body: string;
  data: Record<string, string>;
}

type Executor = Pick<Database['db'], 'insert' | 'select'>;

// Queues pushes in the caller's transaction (E4), so a push exists exactly
// when what it tells committed; the worker's push relay sends them.
@Injectable()
export class PushQueue {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  async enqueue(executor: Executor, pushes: QueuedPush[], now: Date): Promise<void> {
    if (pushes.length === 0) return;
    await executor
      .insert(pushMessages)
      .values(
        pushes.map((push) => ({
          createdAt: now,
          source: push.source,
          party: push.recipient.party,
          accountId: push.recipient.party === 'customer' ? push.recipient.accountId : null,
          restaurantId: push.recipient.party === 'merchant' ? push.recipient.restaurantId : null,
          ownersOnly: push.recipient.party === 'merchant' && push.recipient.owners,
          captainId: push.recipient.party === 'captain' ? push.recipient.captainId : null,
          templateKey: push.templateKey,
          body: push.body,
          level: push.level,
          priority: push.priority,
          data: push.data,
          expiresAt: new Date(now.getTime() + PUSH_TTL_SECONDS * 1000),
          nextAttemptAt: now,
        })),
      )
      .onConflictDoNothing({ target: pushMessages.source });
  }

  // AP §9.3.2 «إعادة إرسال الإشعار»: queues again the latest push of the
  // order to the recipient, which tells its current state. Null when the
  // order sent the recipient none.
  async resend(
    executor: Executor,
    orderId: string,
    recipient: PushRecipient,
    now: Date,
  ): Promise<{ templateKey: string; body: string } | null> {
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
          sql`${pushMessages.data}->>'orderId' = ${orderId}`,
        ),
      )
      .orderBy(desc(pushMessages.createdAt))
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
        ),
      )
      .orderBy(desc(pushMessages.createdAt))
      .limit(INBOX_MAX);
    return rows;
  }
}
