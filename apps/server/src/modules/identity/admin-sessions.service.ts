import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, inArray, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditExecutor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import type { AdminPermission } from './permissions.js';
import { accountAccess, actorRole } from './roles.js';
import { adminAccounts, adminSessionEndReasons, adminSessions } from './schema.js';
import { newToken, tokenHash } from './secrets.js';

export interface AdminSession {
  id: string;
  accountId: string;
  // The roles held now, sorted, and the union of their permissions (AP §6.1).
  roles: string[];
  permissions: AdminPermission[];
  signedInAt: Date;
  // The earlier of the idle end and the maximum end, as of the last activity.
  expiresAt: Date;
}

type Executor = AuditExecutor & Pick<Database['db'], 'select' | 'update'>;

export type SessionEndReason = (typeof adminSessionEndReasons)[number];

export interface OpenSession {
  id: string;
  accountId: string;
  userAgent: string | null;
  ipAddress: string | null;
  signedInAt: Date;
  lastActivityAt: Date;
}

// AP §5.2: a session ends after admin.session_idle_min without activity, and
// in any case admin.session_max_hours after sign-in, both read at every check
// so a settings change applies to open sessions too.
@Injectable()
export class AdminSessionsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
  ) {}

  // Called by the sign-in inside its transaction.
  async start(
    tx: Executor,
    accountId: string,
    context: AuditRequestContext,
    now: Date,
  ): Promise<{ token: string; session: AdminSession }> {
    const access = await accountAccess(tx, accountId);
    const token = newToken();
    const [row] = await tx
      .insert(adminSessions)
      .values({
        accountId,
        tokenHash: tokenHash(token),
        userAgent: context.device,
        ipAddress: context.ipAddress,
        signedInAt: now,
        lastActivityAt: now,
      })
      .returning({ id: adminSessions.id });
    if (!row) throw new Error('the session was not created');
    await this.audit.recordWrite(
      {
        actor: { type: 'admin', id: accountId, role: actorRole(access.roles) },
        context,
        cityId: null,
        action: 'admin_session.sign_in',
        target: { type: 'admin_session', id: row.id },
        before: null,
        after: { accountId },
      },
      tx,
    );
    const session = {
      id: row.id,
      accountId,
      ...access,
      signedInAt: now,
      expiresAt: await this.expiresAt(now, now),
    };
    return { token, session };
  }

  // The open session of a cookie's token, its activity recorded; null when
  // there is none or it has just ended.
  async authenticate(token: string, now = new Date()): Promise<AdminSession | null> {
    const [row] = await this.database.db
      .select({
        id: adminSessions.id,
        accountId: adminSessions.accountId,
        status: adminAccounts.status,
        signedInAt: adminSessions.signedInAt,
        lastActivityAt: adminSessions.lastActivityAt,
      })
      .from(adminSessions)
      .innerJoin(adminAccounts, eq(adminAccounts.id, adminSessions.accountId))
      .where(and(eq(adminSessions.tokenHash, tokenHash(token)), isNull(adminSessions.endedAt)));
    if (!row || row.status !== 'active') return null;

    const idleMinutes = await this.settings.get('admin.session_idle_min');
    const maxHours = await this.settings.get('admin.session_max_hours');
    if (now.getTime() >= row.signedInAt.getTime() + maxHours * 3_600_000) {
      await this.end(row.id, 'max_lifetime', now);
      return null;
    }
    if (now.getTime() >= row.lastActivityAt.getTime() + idleMinutes * 60_000) {
      await this.end(row.id, 'idle', now);
      return null;
    }
    await this.database.db
      .update(adminSessions)
      .set({ lastActivityAt: now })
      .where(eq(adminSessions.id, row.id));
    return {
      id: row.id,
      accountId: row.accountId,
      ...(await accountAccess(this.database.db, row.accountId)),
      signedInAt: row.signedInAt,
      expiresAt: await this.expiresAt(row.signedInAt, now),
    };
  }

  async signOut(session: AdminSession, context: AuditRequestContext, now = new Date()) {
    await this.database.db.transaction(async (tx) => {
      const ended = await this.end(session.id, 'sign_out', now, tx);
      if (!ended) return;
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: session.accountId, role: actorRole(session.roles) },
          context,
          cityId: null,
          action: 'admin_session.sign_out',
          target: { type: 'admin_session', id: session.id },
          before: { ended: false },
          after: { ended: true, endReason: 'sign_out' },
        },
        tx,
      );
    });
  }

  // The sessions not yet ended nor past their idle or maximum end (AP §5.2:
  // OWN sees every open session), oldest first.
  async openSessions(now = new Date()): Promise<OpenSession[]> {
    const idleMinutes = await this.settings.get('admin.session_idle_min');
    const maxHours = await this.settings.get('admin.session_max_hours');
    return this.database.db
      .select({
        id: adminSessions.id,
        accountId: adminSessions.accountId,
        userAgent: adminSessions.userAgent,
        ipAddress: adminSessions.ipAddress,
        signedInAt: adminSessions.signedInAt,
        lastActivityAt: adminSessions.lastActivityAt,
      })
      .from(adminSessions)
      .where(
        and(
          isNull(adminSessions.endedAt),
          gt(adminSessions.lastActivityAt, new Date(now.getTime() - idleMinutes * 60_000)),
          gt(adminSessions.signedInAt, new Date(now.getTime() - maxHours * 3_600_000)),
        ),
      )
      .orderBy(adminSessions.signedInAt);
  }

  // Ends every open session of an account, inside the caller's transaction
  // (AP §5.2–5.3: force sign-out, disable, TOTP reset). Returns how many.
  async endAll(
    executor: Pick<Database['db'], 'update'>,
    accountId: string,
    reason: SessionEndReason,
    now: Date,
  ): Promise<number> {
    const ended = await executor
      .update(adminSessions)
      .set({ endedAt: now, endReason: reason })
      .where(and(eq(adminSessions.accountId, accountId), isNull(adminSessions.endedAt)))
      .returning({ id: adminSessions.id });
    return ended.length;
  }

  // The names of admin accounts, for who took an alert (AP §7.3); an account
  // without a name (a first OWN) is left out.
  async names(accountIds: readonly string[]): Promise<Map<string, string>> {
    if (accountIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ id: adminAccounts.id, name: adminAccounts.name })
      .from(adminAccounts)
      .where(inArray(adminAccounts.id, [...new Set(accountIds)]));
    return new Map(rows.flatMap((row) => (row.name === null ? [] : [[row.id, row.name] as const])));
  }

  // The longest a cookie can still be useful, for its Max-Age.
  async maxLifetimeSeconds(): Promise<number> {
    return (await this.settings.get('admin.session_max_hours')) * 3600;
  }

  private async expiresAt(signedInAt: Date, lastActivityAt: Date): Promise<Date> {
    const idleMinutes = await this.settings.get('admin.session_idle_min');
    const maxHours = await this.settings.get('admin.session_max_hours');
    return new Date(
      Math.min(
        lastActivityAt.getTime() + idleMinutes * 60_000,
        signedInAt.getTime() + maxHours * 3_600_000,
      ),
    );
  }

  // Ends an open session; false when it had already ended.
  private async end(
    id: string,
    reason: SessionEndReason,
    now: Date,
    executor: Pick<Database['db'], 'update'> = this.database.db,
  ): Promise<boolean> {
    const ended = await executor
      .update(adminSessions)
      .set({ endedAt: now, endReason: reason })
      .where(and(eq(adminSessions.id, id), isNull(adminSessions.endedAt)))
      .returning({ id: adminSessions.id });
    return ended.length > 0;
  }
}
