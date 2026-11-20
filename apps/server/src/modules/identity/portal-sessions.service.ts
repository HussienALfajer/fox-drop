import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gt, inArray, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { type MerchantAccount, MerchantAccountsService } from './merchant-accounts.service.js';
import { merchantAccounts, merchantPortalSessions } from './schema.js';
import { newToken, tokenHash } from './secrets.js';

type Executor = Pick<Database['db'], 'insert' | 'update'>;

// An owner's open portal session, as the guard and the real-time proxy see it.
// An open portal session as «الأجهزة» lists it (slice 2.45c).
export interface OpenPortalSession {
  id: string;
  ownerName: string;
  userAgent: string | null;
  signedInAt: Date;
  expiresAt: Date;
}

export class PortalSessionsRefusedError extends Error {
  constructor(
    readonly refusal: 'unknown_session',
    message: string,
  ) {
    super(message);
  }
}

export interface PortalSession {
  id: string;
  account: MerchantAccount;
  browserId: string;
}

// The owner web portal's sessions (RA §17, §5.3, S14; slice 2.45a): a random
// token in an HTTP-only cookie, kept as SHA-256, valid from the sign-in for
// `merchant.web_session_days` (the caller reads it before its transaction).
// Only an owner's account has one, checked at every request with its
// restaurant's status (RA §5.5), so a removed owner or a draft restaurant is
// refused at once. The sessions are not app sessions: the portal is never a
// device (RA §4.6).
@Injectable()
export class PortalSessionsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly accounts: MerchantAccountsService,
    private readonly audit: AuditService,
  ) {}

  // Called by the sign-in in its transaction. The token is shown once, in
  // the cookie.
  async start(
    tx: Executor,
    accountId: string,
    browserId: string,
    context: AuditRequestContext,
    sessionDays: number,
    now: Date,
  ): Promise<{ id: string; token: string; expiresAt: Date }> {
    // A browser keeps one session per owner: signing in again ends the last.
    await tx
      .update(merchantPortalSessions)
      .set({ endedAt: now, endReason: 'new_sign_in' })
      .where(
        and(
          eq(merchantPortalSessions.accountId, accountId),
          eq(merchantPortalSessions.browserId, browserId),
          isNull(merchantPortalSessions.endedAt),
        ),
      );
    const token = newToken();
    const expiresAt = new Date(now.getTime() + sessionDays * 86_400_000);
    const [session] = await tx
      .insert(merchantPortalSessions)
      .values({
        accountId,
        browserId,
        tokenHash: tokenHash(token),
        userAgent: context.device,
        ipAddress: context.ipAddress,
        signedInAt: now,
        expiresAt,
      })
      .returning({ id: merchantPortalSessions.id });
    if (!session) throw new Error('the portal session was not created');
    return { id: session.id, token, expiresAt };
  }

  // The open session of a cookie's token, or null.
  async authenticate(token: string, now = new Date()): Promise<PortalSession | null> {
    const [row] = await this.database.db
      .select({
        id: merchantPortalSessions.id,
        accountId: merchantPortalSessions.accountId,
        browserId: merchantPortalSessions.browserId,
      })
      .from(merchantPortalSessions)
      .where(
        and(
          eq(merchantPortalSessions.tokenHash, tokenHash(token)),
          isNull(merchantPortalSessions.endedAt),
          gt(merchantPortalSessions.expiresAt, now),
        ),
      );
    return row ? this.usable(row) : null;
  }

  // The session while it is open, for the real-time subscription proxy
  // (architecture §6.1), which knows the session and the account.
  async openSession(
    accountId: string,
    sessionId: string,
    now = new Date(),
  ): Promise<PortalSession | null> {
    const [row] = await this.database.db
      .select({
        id: merchantPortalSessions.id,
        accountId: merchantPortalSessions.accountId,
        browserId: merchantPortalSessions.browserId,
      })
      .from(merchantPortalSessions)
      .where(
        and(
          eq(merchantPortalSessions.id, sessionId),
          eq(merchantPortalSessions.accountId, accountId),
          isNull(merchantPortalSessions.endedAt),
          gt(merchantPortalSessions.expiresAt, now),
        ),
      );
    return row ? this.usable(row) : null;
  }

  // Whether it was open.
  async signOut(sessionId: string, now = new Date()): Promise<boolean> {
    const ended = await this.database.db
      .update(merchantPortalSessions)
      .set({ endedAt: now, endReason: 'sign_out' })
      .where(and(eq(merchantPortalSessions.id, sessionId), isNull(merchantPortalSessions.endedAt)))
      .returning({ id: merchantPortalSessions.id });
    return ended.length > 0;
  }

  // The restaurant's open portal sessions, the latest sign-in first (RA
  // §14.2, owner decision 2026-11-20: a lost laptop is signed out from
  // «الأجهزة»).
  async openSessions(restaurantId: string, now = new Date()): Promise<OpenPortalSession[]> {
    return this.database.db
      .select({
        id: merchantPortalSessions.id,
        ownerName: merchantAccounts.name,
        userAgent: merchantPortalSessions.userAgent,
        signedInAt: merchantPortalSessions.signedInAt,
        expiresAt: merchantPortalSessions.expiresAt,
      })
      .from(merchantPortalSessions)
      .innerJoin(merchantAccounts, eq(merchantAccounts.id, merchantPortalSessions.accountId))
      .where(
        and(
          eq(merchantAccounts.restaurantId, restaurantId),
          isNull(merchantAccounts.removedAt),
          isNull(merchantPortalSessions.endedAt),
          gt(merchantPortalSessions.expiresAt, now),
        ),
      )
      .orderBy(desc(merchantPortalSessions.signedInAt));
  }

  // An owner ends one of the restaurant's open portal sessions
  // (`signed_out_by_owner`), audited `merchant_portal_session.sign_out`.
  // 404 unknown_session for one not open or not the restaurant's, so a
  // repeat changes nothing.
  async signOutByOwner(
    restaurant: { id: string; cityId: string },
    sessionId: string,
    change: { actor: AuditActor; context: AuditRequestContext },
    now = new Date(),
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const owners = tx
        .select({ id: merchantAccounts.id })
        .from(merchantAccounts)
        .where(eq(merchantAccounts.restaurantId, restaurant.id));
      const ended = await tx
        .update(merchantPortalSessions)
        .set({ endedAt: now, endReason: 'signed_out_by_owner' })
        .where(
          and(
            eq(merchantPortalSessions.id, sessionId),
            isNull(merchantPortalSessions.endedAt),
            gt(merchantPortalSessions.expiresAt, now),
            inArray(merchantPortalSessions.accountId, owners),
          ),
        )
        .returning({ id: merchantPortalSessions.id });
      if (ended.length === 0) {
        throw new PortalSessionsRefusedError('unknown_session', 'no such open session');
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: restaurant.cityId,
          action: 'merchant_portal_session.sign_out',
          target: { type: 'restaurant', id: restaurant.id },
          before: null,
          after: { sessionId },
          reason: null,
        },
        tx,
      );
    });
  }

  private async usable(row: {
    id: string;
    accountId: string;
    browserId: string;
  }): Promise<PortalSession | null> {
    const account = await this.accounts.account(this.database.db, row.accountId);
    if (account === null || account.role !== 'owner') return null;
    if (!(await this.accounts.mayUse(account))) return null;
    return { id: row.id, account, browserId: row.browserId };
  }
}
