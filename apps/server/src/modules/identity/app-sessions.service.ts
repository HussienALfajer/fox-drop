import { Inject, Injectable } from '@nestjs/common';
import { and, eq, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import type { AuditRequestContext } from '../audit/index.js';
import { AppSigningKeys, type SigningKey } from './app-signing-keys.js';
import { type MerchantAccount, MerchantAccountsService } from './merchant-accounts.service.js';
import {
  appParties,
  appRefreshTokens,
  appSessionEndReasons,
  appSessions,
  customerAccounts,
} from './schema.js';
import { newToken, tokenHash } from './secrets.js';

export type AppParty = (typeof appParties)[number];
export type AppSessionEndReason = (typeof appSessionEndReasons)[number];

// The session an app's access token stands for.
export interface AppSession {
  id: string;
  party: AppParty;
  accountId: string;
  // The app installation it signed in on.
  deviceId: string;
  // A restaurant user's restaurant and role (RA §5.1, §5.4), read at every
  // request; null for the other apps.
  merchant: MerchantAccount | null;
}

export interface AppTokens {
  accessToken: string;
  accessTokenExpiresAt: Date;
  refreshToken: string;
}

// Owner decision 2026-11-05: a used refresh token presented again within this
// many seconds of its first use is a retry whose answer was lost, not a reuse.
export const REFRESH_RETRY_GRACE_SECONDS = 10;

// Any refusal of a refresh token: unknown, already used, or its session ended.
export class RefreshRefusedError extends Error {
  constructor() {
    super('refresh refused');
  }
}

type Executor = Pick<Database['db'], 'select' | 'insert' | 'update'>;

// Architecture §15.1: a 15-minute access token and a refresh token stored as
// its SHA-256, rotated on every use. A used token presented again ends its
// session, so a stolen copy and the real one cannot both live, except a retry
// within the grace, which replaces the token its lost answer carried. Sessions
// do not expire with inactivity (CU §5.4).
@Injectable()
export class AppSessionsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly keys: AppSigningKeys,
    private readonly merchantAccounts: MerchantAccountsService,
  ) {}

  // Called by the sign-in inside its transaction. A device holds one session
  // per app: an earlier one on the same device ends.
  async start(
    tx: Executor,
    party: AppParty,
    accountId: string,
    deviceId: string,
    context: AuditRequestContext,
    signingKey: SigningKey,
    now: Date,
  ): Promise<AppTokens> {
    await tx
      .update(appSessions)
      .set({ endedAt: now, endReason: 'new_sign_in' })
      .where(
        and(
          eq(appSessions.party, party),
          eq(appSessions.deviceId, deviceId),
          isNull(appSessions.endedAt),
        ),
      );
    const [session] = await tx
      .insert(appSessions)
      .values({
        party,
        accountId,
        deviceId,
        userAgent: context.device,
        ipAddress: context.ipAddress,
        signedInAt: now,
        lastRefreshedAt: now,
      })
      .returning({ id: appSessions.id });
    if (!session) throw new Error('the session was not created');
    return this.issue(tx, { id: session.id, party, accountId }, signingKey, now);
  }

  // A new token pair for an unused refresh token of an open session, or for a
  // retry within the grace of the last token used.
  async refresh(refreshToken: string, now = new Date()): Promise<AppTokens> {
    const signingKey = await this.keys.signingKey(now);
    const hash = tokenHash(refreshToken);
    // A restaurant user refreshes only while their restaurant lets them sign
    // in (RA §5.5). Its status is read through the merchants module, on a
    // connection of its own, so before the transaction.
    const merchantAllowed = await this.merchantAllowed(hash);
    const result = await this.database.db.transaction(async (tx) => {
      // The session row first, then the token: every refresh of a session
      // takes turns on the session row, so none can deadlock another.
      const [session] = await tx
        .select({
          id: appSessions.id,
          party: appSessions.party,
          accountId: appSessions.accountId,
          endedAt: appSessions.endedAt,
          lastUsedTokenId: appSessions.lastUsedTokenId,
        })
        .from(appSessions)
        .where(
          eq(
            appSessions.id,
            tx
              .select({ id: appRefreshTokens.sessionId })
              .from(appRefreshTokens)
              .where(eq(appRefreshTokens.tokenHash, hash)),
          ),
        )
        .for('update');
      if (!session || session.endedAt) return null;
      const [token] = await tx
        .select({
          id: appRefreshTokens.id,
          usedAt: appRefreshTokens.usedAt,
          supersededAt: appRefreshTokens.supersededAt,
        })
        .from(appRefreshTokens)
        .where(eq(appRefreshTokens.tokenHash, hash))
        .for('update');
      if (!token) return null;
      // A retry: the session's last used token, within the grace of its use.
      const retry =
        token.usedAt !== null &&
        token.id === session.lastUsedTokenId &&
        now.getTime() - token.usedAt.getTime() <= REFRESH_RETRY_GRACE_SECONDS * 1000;
      if (token.supersededAt || (token.usedAt && !retry)) {
        // Reuse: end the whole family, and commit it.
        await this.end(tx, session.id, 'refresh_reuse', now);
        return null;
      }
      if (!(await this.accountIsActive(tx, session.party, session.accountId, merchantAllowed))) {
        return null;
      }
      if (retry) {
        // The retry's pair replaces the one whose answer was lost.
        await tx
          .update(appRefreshTokens)
          .set({ supersededAt: now })
          .where(
            and(
              eq(appRefreshTokens.sessionId, session.id),
              isNull(appRefreshTokens.usedAt),
              isNull(appRefreshTokens.supersededAt),
            ),
          );
      } else {
        await tx
          .update(appRefreshTokens)
          .set({ usedAt: now })
          .where(eq(appRefreshTokens.id, token.id));
      }
      await tx
        .update(appSessions)
        .set({ lastRefreshedAt: now, lastUsedTokenId: token.id })
        .where(eq(appSessions.id, session.id));
      const { id, party, accountId } = session;
      return this.issue(tx, { id, party, accountId }, signingKey, now);
    });
    if (!result) throw new RefreshRefusedError();
    return result;
  }

  // The session of an access token for this party's routes, or null. The
  // session must still be open, so sign-out everywhere, a reused refresh
  // token, blocking or closing apply at once on every device (CU §5.4–5.5).
  async authenticate(
    party: AppParty,
    accessToken: string,
    now = new Date(),
  ): Promise<AppSession | null> {
    const claims = await this.keys.verify(accessToken, party, now);
    if (!claims) return null;
    const [open] = await this.database.db
      .select({ id: appSessions.id, deviceId: appSessions.deviceId })
      .from(appSessions)
      .where(
        and(
          eq(appSessions.id, claims.sessionId),
          eq(appSessions.party, party),
          eq(appSessions.accountId, claims.accountId),
          isNull(appSessions.endedAt),
        ),
      );
    if (!open) return null;
    let merchant: MerchantAccount | null = null;
    if (party === 'merchant') {
      // RA §5.5: a cashier's access ends with the restaurant's termination,
      // without waiting for the access token to expire.
      merchant = await this.merchantAccounts.account(this.database.db, claims.accountId);
      if (merchant === null || !(await this.merchantAccounts.mayUse(merchant))) return null;
    }
    return {
      id: claims.sessionId,
      party,
      accountId: claims.accountId,
      deviceId: open.deviceId,
      merchant,
    };
  }

  async signOut(session: AppSession, now = new Date()): Promise<void> {
    await this.end(this.database.db, session.id, 'sign_out', now);
  }

  // «تسجيل الخروج من كل الأجهزة» (CU §5.4): every open session of the account,
  // this one included. Returns how many ended.
  async signOutEverywhere(session: AppSession, now = new Date()): Promise<number> {
    return this.endAll(
      this.database.db,
      session.party,
      session.accountId,
      'sign_out_everywhere',
      now,
    );
  }

  // Ends every open session of an account, inside the caller's transaction:
  // its refresh tokens stop working at once (architecture §15.1).
  async endAll(
    executor: Pick<Database['db'], 'update'>,
    party: AppParty,
    accountId: string,
    reason: AppSessionEndReason,
    now: Date,
  ): Promise<number> {
    const ended = await executor
      .update(appSessions)
      .set({ endedAt: now, endReason: reason })
      .where(
        and(
          eq(appSessions.party, party),
          eq(appSessions.accountId, accountId),
          isNull(appSessions.endedAt),
        ),
      )
      .returning({ id: appSessions.id });
    return ended.length;
  }

  // The key to sign with now. Callers resolve it before opening their
  // transaction, since loading it may take a pool connection of its own.
  signingKey(now: Date): Promise<SigningKey> {
    return this.keys.signingKey(now);
  }

  private async issue(
    tx: Executor,
    session: Pick<AppSession, 'id' | 'party' | 'accountId'>,
    signingKey: SigningKey,
    now: Date,
  ): Promise<AppTokens> {
    const refreshToken = newToken();
    await tx
      .insert(appRefreshTokens)
      .values({ sessionId: session.id, tokenHash: tokenHash(refreshToken), createdAt: now });
    const access = await this.keys.sign(
      signingKey,
      { accountId: session.accountId, sessionId: session.id, party: session.party },
      now,
    );
    return { accessToken: access.token, accessTokenExpiresAt: access.expiresAt, refreshToken };
  }

  // Whether the restaurant user of a refresh token's session may still use
  // the app; true for any other token, which the transaction checks.
  private async merchantAllowed(hash: string): Promise<boolean> {
    const [session] = await this.database.db
      .select({ party: appSessions.party, accountId: appSessions.accountId })
      .from(appSessions)
      .innerJoin(appRefreshTokens, eq(appRefreshTokens.sessionId, appSessions.id))
      .where(eq(appRefreshTokens.tokenHash, hash));
    if (session?.party !== 'merchant') return true;
    const account = await this.merchantAccounts.account(this.database.db, session.accountId);
    return account !== null && (await this.merchantAccounts.mayUse(account));
  }

  private async accountIsActive(
    executor: Pick<Database['db'], 'select'>,
    party: AppParty,
    accountId: string,
    merchantAllowed: boolean,
  ): Promise<boolean> {
    switch (party) {
      case 'merchant':
        return (
          merchantAllowed && (await this.merchantAccounts.account(executor, accountId)) !== null
        );
      case 'customer': {
        const [account] = await executor
          .select({ status: customerAccounts.status })
          .from(customerAccounts)
          .where(eq(customerAccounts.id, accountId));
        return account?.status === 'active';
      }
    }
  }

  private async end(
    executor: Pick<Database['db'], 'update'>,
    sessionId: string,
    reason: AppSessionEndReason,
    now: Date,
  ): Promise<void> {
    await executor
      .update(appSessions)
      .set({ endedAt: now, endReason: reason })
      .where(and(eq(appSessions.id, sessionId), isNull(appSessions.endedAt)));
  }
}
