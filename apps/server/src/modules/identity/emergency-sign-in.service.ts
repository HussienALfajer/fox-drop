import { Inject, Injectable } from '@nestjs/common';
import { and, eq, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import type { AdminSession } from './admin-sessions.service.js';
import { CaptainAccountsService, type CaptainSignInRefusal } from './captain-accounts.service.js';
import {
  MerchantAccountsService,
  type MerchantSignInRefusal,
} from './merchant-accounts.service.js';
import { actorRole } from './roles.js';
import { appSignInCodes, captainAccounts, merchantAccounts } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets, newSignInCode } from './secrets.js';

// Owner decision 2026-11-07: an emergency code is valid 10 minutes, fixed.
export const EMERGENCY_CODE_MINUTES = 10;

export type EmergencyParty = 'captain' | 'merchant';

export class EmergencyCodeRefusedError extends Error {
  constructor(readonly refusal: CaptainSignInRefusal | MerchantSignInRefusal) {
    super(`emergency code refused: ${refusal}`);
  }
}

// The emergency sign-in (W4, architecture §22 item 1; owner decisions
// 2026-11-07): when no code reaches a captain or a restaurant user, OWN or OPS
// verify them by a phone call and issue a one-time code bound to their number,
// shown once and read out to them. They type it in the app's usual code screen;
// the code has no device, so the first device that enters it signs in, and the
// sign-in runs as for a WhatsApp code. Customers are not covered.
@Injectable()
export class EmergencySignInService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly captainAccounts: CaptainAccountsService,
    private readonly merchantAccounts: MerchantAccountsService,
    private readonly audit: AuditService,
  ) {}

  async issue(
    request: { party: EmergencyParty; phone: string; reason: string },
    actor: AdminSession,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<{ code: string; expiresAt: Date; accountId: string }> {
    const phoneHash = this.secrets.phoneHash(request.phone);
    // Only a number that may sign in gets a code; the sign-in checks again.
    // Read outside the transaction: the status takes a connection of its own.
    const account =
      request.party === 'captain'
        ? await this.captainAccounts.signInAccount(phoneHash, now)
        : await this.merchantAccounts.signInAccount(phoneHash);
    if (typeof account === 'string') throw new EmergencyCodeRefusedError(account);

    // The audit event carries the account's city (AP D28, §9.16).
    const table = request.party === 'captain' ? captainAccounts : merchantAccounts;
    const [city] = await this.database.db
      .select({ cityId: table.cityId })
      .from(table)
      .where(eq(table.id, account.id));
    if (!city) throw new Error('the account has no city');

    const code = newSignInCode();
    const expiresAt = new Date(now.getTime() + EMERGENCY_CODE_MINUTES * 60_000);
    await this.database.db.transaction(async (tx) => {
      // The code request's lock: one open code per number and app.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.app_code:${phoneHash}`}, 0))`,
      );
      await tx
        .update(appSignInCodes)
        .set({ endedAt: now, endReason: 'replaced' })
        .where(
          and(
            eq(appSignInCodes.party, request.party),
            eq(appSignInCodes.phoneHash, phoneHash),
            isNull(appSignInCodes.endedAt),
          ),
        );
      await tx.insert(appSignInCodes).values({
        party: request.party,
        phoneHash,
        deviceId: null,
        issuedBy: actor.accountId,
        issueReason: request.reason,
        codeHash: this.secrets.signInCodeHash(request.phone, code),
        expiresAt,
        createdAt: now,
      });
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: actor.accountId, role: actorRole(actor.roles) },
          context,
          cityId: city.cityId,
          action: 'app_sign_in_code.emergency_issue',
          target: {
            type: request.party === 'captain' ? 'captain_account' : 'merchant_account',
            id: account.id,
          },
          reason: request.reason,
          before: null,
          after: { party: request.party, expiresAt: expiresAt.toISOString() },
        },
        tx,
      );
    });
    return { code, expiresAt, accountId: account.id };
  }
}
