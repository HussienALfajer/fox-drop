import { Inject, Injectable } from '@nestjs/common';
import { and, eq, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditExecutor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import { adminAccounts, adminSessions } from './schema.js';
import { newToken, tokenHash } from './secrets.js';

export interface AdminSession {
  id: string;
  accountId: string;
  roles: string[];
  signedInAt: Date;
  // The earlier of the idle end and the maximum end, as of the last activity.
  expiresAt: Date;
}

type Executor = AuditExecutor & Pick<Database['db'], 'select' | 'update'>;

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
    account: { id: string; roles: string[] },
    context: AuditRequestContext,
    now: Date,
  ): Promise<{ token: string; session: AdminSession }> {
    const token = newToken();
    const [row] = await tx
      .insert(adminSessions)
      .values({
        accountId: account.id,
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
        actor: { type: 'admin', id: account.id, role: account.roles.join(',') },
        context,
        cityId: null,
        action: 'admin_session.sign_in',
        target: { type: 'admin_session', id: row.id },
        before: null,
        after: { accountId: account.id },
      },
      tx,
    );
    const session = {
      id: row.id,
      accountId: account.id,
      roles: account.roles,
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
        roles: adminAccounts.roles,
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
      roles: row.roles,
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
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
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
    reason: 'sign_out' | 'idle' | 'max_lifetime',
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
