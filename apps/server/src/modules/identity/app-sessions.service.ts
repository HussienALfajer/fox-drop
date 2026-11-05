import { Inject, Injectable } from '@nestjs/common';
import { and, eq, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import type { AuditRequestContext } from '../audit/index.js';
import { AppSigningKeys, type SigningKey } from './app-signing-keys.js';
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
}

export interface AppTokens {
  accessToken: string;
  accessTokenExpiresAt: Date;
  refreshToken: string;
}

// Any refusal of a refresh token: unknown, already used, or its session ended.
export class RefreshRefusedError extends Error {
  constructor() {
    super('refresh refused');
  }
}

type Executor = Pick<Database['db'], 'select' | 'insert' | 'update'>;

// Architecture §15.1: a 15-minute access token and a refresh token stored as
// its SHA-256, rotated on every use. A used token presented again ends its
// session, so a stolen copy and the real one cannot both live. Sessions do not
// expire with inactivity (CU §5.4).
@Injectable()
export class AppSessionsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly keys: AppSigningKeys,
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

  // A new token pair for an unused refresh token of an open session.
  async refresh(refreshToken: string, now = new Date()): Promise<AppTokens> {
    const signingKey = await this.keys.signingKey(now);
    const result = await this.database.db.transaction(async (tx) => {
      const [row] = await tx
        .select({
          tokenId: appRefreshTokens.id,
          usedAt: appRefreshTokens.usedAt,
          sessionId: appSessions.id,
          party: appSessions.party,
          accountId: appSessions.accountId,
          endedAt: appSessions.endedAt,
        })
        .from(appRefreshTokens)
        .innerJoin(appSessions, eq(appSessions.id, appRefreshTokens.sessionId))
        .where(eq(appRefreshTokens.tokenHash, tokenHash(refreshToken)))
        .for('update');
      if (!row || row.endedAt) return null;
      const session = { id: row.sessionId, party: row.party, accountId: row.accountId };
      if (row.usedAt) {
        // Reuse: end the whole family, and commit it.
        await this.end(tx, session.id, 'refresh_reuse', now);
        return null;
      }
      if (!(await this.accountIsActive(tx, session.party, session.accountId))) return null;
      await tx
        .update(appRefreshTokens)
        .set({ usedAt: now })
        .where(eq(appRefreshTokens.id, row.tokenId));
      await tx
        .update(appSessions)
        .set({ lastRefreshedAt: now })
        .where(eq(appSessions.id, session.id));
      return this.issue(tx, session, signingKey, now);
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
      .select({ id: appSessions.id })
      .from(appSessions)
      .where(
        and(
          eq(appSessions.id, claims.sessionId),
          eq(appSessions.party, party),
          eq(appSessions.accountId, claims.accountId),
          isNull(appSessions.endedAt),
        ),
      );
    return open ? { id: claims.sessionId, party, accountId: claims.accountId } : null;
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
    session: AppSession,
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

  private async accountIsActive(
    executor: Pick<Database['db'], 'select'>,
    party: AppParty,
    accountId: string,
  ): Promise<boolean> {
    switch (party) {
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
