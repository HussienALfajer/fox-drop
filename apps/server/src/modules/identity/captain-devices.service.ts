import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import type { AdminSession } from './admin-sessions.service.js';
import { AppSessionsService } from './app-sessions.service.js';
import { actorRole } from './roles.js';
import { appSessions, captainAccounts } from './schema.js';

// unknown_captain: no sign-in account for the captain; no_device: the device
// named is no longer signed in (released already, signed out, or replaced by
// a new phone).
export class DeviceReleaseRefusedError extends Error {
  constructor(readonly refusal: 'unknown_captain' | 'no_device') {
    super(`device release refused: ${refusal}`);
  }
}

// The captain's signed-in device: its session and when it signed in.
export interface CaptainDevice {
  sessionId: string;
  signedInAt: Date;
}

type Executor = Pick<Database['db'], 'select'>;

// AP §9.7.5 «تحرير الجهاز» (CA §4.9, K5; slice 2.12c): OWN or OPS sign out the
// captain's device, with a reason, so they can sign in on another phone, also
// during an active order. The release names the session the operator saw, so
// a second or late release never signs out the new phone. The captain stays
// online (owner decision 2026-11-11): the order continues, and the location
// resumes from the new phone.
@Injectable()
export class CaptainDevicesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly sessions: AppSessionsService,
    private readonly audit: AuditService,
  ) {}

  // The device signed in now, or null (K5: one at a time).
  async device(captainId: string): Promise<CaptainDevice | null> {
    const account = await this.account(this.database.db, captainId);
    return this.openDevice(this.database.db, account.id);
  }

  async release(
    captainId: string,
    sessionId: string,
    reason: string,
    actor: AdminSession,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const account = await this.account(tx, captainId);
      const [ended] = await tx
        .update(appSessions)
        .set({ endedAt: now, endReason: 'device_released' })
        .where(
          and(
            eq(appSessions.id, sessionId),
            eq(appSessions.party, 'captain'),
            eq(appSessions.accountId, account.id),
            isNull(appSessions.endedAt),
          ),
        )
        .returning({ id: appSessions.id, signedInAt: appSessions.signedInAt });
      if (!ended) throw new DeviceReleaseRefusedError('no_device');
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: actor.accountId, role: actorRole(actor.roles) },
          context,
          cityId: account.cityId,
          action: 'captain_account.release_device',
          target: { type: 'captain_account', id: account.id },
          reason,
          before: { sessionId: ended.id, signedInAt: ended.signedInAt.toISOString() },
          after: null,
        },
        tx,
      );
    });
    // The released device's connections end once the commit is done.
    this.sessions.notifyEnded([sessionId]);
  }

  private async account(
    executor: Executor,
    captainId: string,
  ): Promise<{ id: string; cityId: string }> {
    const [account] = await executor
      .select({ id: captainAccounts.id, cityId: captainAccounts.cityId })
      .from(captainAccounts)
      .where(eq(captainAccounts.captainId, captainId));
    if (!account) throw new DeviceReleaseRefusedError('unknown_captain');
    return account;
  }

  private async openDevice(executor: Executor, accountId: string): Promise<CaptainDevice | null> {
    const [open] = await executor
      .select({ sessionId: appSessions.id, signedInAt: appSessions.signedInAt })
      .from(appSessions)
      .where(
        and(
          eq(appSessions.party, 'captain'),
          eq(appSessions.accountId, accountId),
          isNull(appSessions.endedAt),
        ),
      )
      .orderBy(desc(appSessions.signedInAt))
      .limit(1);
    return open ?? null;
  }
}
