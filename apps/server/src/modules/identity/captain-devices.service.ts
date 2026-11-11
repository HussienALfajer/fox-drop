import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import type { AdminSession } from './admin-sessions.service.js';
import { AppSessionsService } from './app-sessions.service.js';
import { actorRole } from './roles.js';
import { captainAccounts } from './schema.js';

// unknown_captain: no sign-in account for the captain; no_device: no device
// is signed in.
export class DeviceReleaseRefusedError extends Error {
  constructor(readonly refusal: 'unknown_captain' | 'no_device') {
    super(`device release refused: ${refusal}`);
  }
}

// AP §9.7.5 «تحرير الجهاز» (CA §4.9, K5; slice 2.12c): OWN or OPS sign out the
// captain's device, with a reason, so they can sign in on another phone, also
// during an active order. The captain stays online (owner decision
// 2026-11-11): the order continues, and the location resumes from the new
// phone.
@Injectable()
export class CaptainDevicesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly sessions: AppSessionsService,
    private readonly audit: AuditService,
  ) {}

  async release(
    captainId: string,
    reason: string,
    actor: AdminSession,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<void> {
    const ended = await this.database.db.transaction(async (tx) => {
      const [account] = await tx
        .select({ id: captainAccounts.id, cityId: captainAccounts.cityId })
        .from(captainAccounts)
        .where(eq(captainAccounts.captainId, captainId));
      if (!account) throw new DeviceReleaseRefusedError('unknown_captain');
      const ended = await this.sessions.endAll(tx, 'captain', account.id, 'device_released', now);
      if (ended.length === 0) throw new DeviceReleaseRefusedError('no_device');
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: actor.accountId, role: actorRole(actor.roles) },
          context,
          cityId: account.cityId,
          action: 'captain_account.release_device',
          target: { type: 'captain_account', id: account.id },
          reason,
          before: { signedInDevices: ended.length },
          after: { signedInDevices: 0 },
        },
        tx,
      );
      return ended;
    });
    // The released device's connections end once the commit is done.
    this.sessions.notifyEnded(ended);
  }
}
