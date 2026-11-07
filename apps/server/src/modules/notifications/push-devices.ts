import { Inject, Injectable } from '@nestjs/common';
import { and, eq, inArray, isNull, ne } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AppSession, OpenAppSessions } from '../identity/index.js';
import { pushDevices, pushPlatforms } from './schema.js';

// Who a push goes to (CU §14, RA §16, CA §14): a customer's account, a
// restaurant's devices («All») or its owners' devices («Owners»), a captain.
export type PushRecipient =
  | { party: 'customer'; accountId: string }
  | { party: 'merchant'; restaurantId: string; owners: boolean }
  | { party: 'captain'; captainId: string };

export interface PushTarget {
  sessionId: string;
  token: string;
}

type Executor = Pick<Database['db'], 'select' | 'update'>;

// Architecture §8.1: the push tokens of the apps' installations, one per app
// session. A token belongs to one live session: registering it ends any
// other row holding it (a sign-in again on the device, or an account switch).
@Injectable()
export class PushDevices {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly sessions: OpenAppSessions,
  ) {}

  async register(
    session: AppSession,
    token: string,
    platform: (typeof pushPlatforms)[number],
    now: Date,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      await tx
        .update(pushDevices)
        .set({ endedAt: now, endReason: 'token_moved' })
        .where(
          and(
            eq(pushDevices.token, token),
            ne(pushDevices.sessionId, session.id),
            isNull(pushDevices.endedAt),
          ),
        );
      const values = {
        party: session.party,
        accountId: session.accountId,
        restaurantId: session.merchant?.restaurantId ?? null,
        merchantRole: session.merchant?.role ?? null,
        captainId: session.captain?.captainId ?? null,
        platform,
        token,
        registeredAt: now,
        endedAt: null,
        endReason: null,
      };
      await tx
        .insert(pushDevices)
        .values({ sessionId: session.id, ...values })
        .onConflictDoUpdate({ target: pushDevices.sessionId, set: values });
    });
  }

  // The live tokens of the recipient's open sessions.
  async targets(recipient: PushRecipient): Promise<PushTarget[]> {
    const live = isNull(pushDevices.endedAt);
    const where =
      recipient.party === 'customer'
        ? and(
            live,
            eq(pushDevices.party, 'customer'),
            eq(pushDevices.accountId, recipient.accountId),
          )
        : recipient.party === 'captain'
          ? and(live, eq(pushDevices.captainId, recipient.captainId))
          : and(
              live,
              eq(pushDevices.restaurantId, recipient.restaurantId),
              recipient.owners ? eq(pushDevices.merchantRole, 'owner') : undefined,
            );
    const rows = await this.database.db
      .select({ sessionId: pushDevices.sessionId, token: pushDevices.token })
      .from(pushDevices)
      .where(where);
    const open = await this.sessions.of(rows.map((row) => row.sessionId));
    return rows.filter((row) => open.has(row.sessionId));
  }

  // Firebase answered that these tokens are no longer registered.
  async invalidate(executor: Executor, tokens: string[], now: Date): Promise<void> {
    if (tokens.length === 0) return;
    await executor
      .update(pushDevices)
      .set({ endedAt: now, endReason: 'token_invalid' })
      .where(and(inArray(pushDevices.token, tokens), isNull(pushDevices.endedAt)));
  }
}
