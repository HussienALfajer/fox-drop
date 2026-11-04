import { Inject, Injectable } from '@nestjs/common';
import { and, eq, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import { AdminSessionsService, type AdminSession } from './admin-sessions.service.js';
import { adminAccounts, adminBackupCodes } from './schema.js';
import {
  IDENTITY_SECRETS,
  type IdentitySecrets,
  normalizeBackupCode,
  verifyNoPassword,
  verifyPassword,
} from './secrets.js';
import { parseSignInName } from './sign-in-name.js';
import { verifyTotp } from './totp.js';

export class SignInRefusedError extends Error {
  constructor(readonly refusal: 'invalid' | 'locked') {
    super(`sign-in refused: ${refusal}`);
  }
}

export interface SignInInput {
  // An email or a phone (AP §5.1 item 1).
  login: string;
  password: string;
  // A 6-digit TOTP code or a backup code.
  code: string;
}

type Transaction = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

// AP §5.1: the password and a TOTP or backup code, with a lockout after
// admin.login_max_attempts failures.
@Injectable()
export class AdminSignInService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
    private readonly sessions: AdminSessionsService,
  ) {}

  // Returns the new session and its token, the only time the token is seen.
  async signIn(
    input: SignInInput,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<{ token: string; session: AdminSession }> {
    const name = parseSignInName(input.login);
    const where = !name
      ? undefined
      : 'email' in name
        ? eq(adminAccounts.email, name.email)
        : eq(adminAccounts.phoneHash, this.secrets.phoneHash(name.phone));
    const maxAttempts = await this.settings.get('admin.login_max_attempts');
    const lockoutMinutes = await this.settings.get('admin.lockout_min');

    // The failure count commits even when the sign-in is refused, so the
    // transaction returns the outcome instead of throwing it.
    const outcome = await this.database.db.transaction(async (tx) => {
      // The row lock makes concurrent attempts on one account take turns, so
      // none is left uncounted.
      const [account] = where
        ? await tx.select().from(adminAccounts).where(where).for('update')
        : [];
      if (!account || account.status !== 'active' || !account.passwordHash) {
        return { refusal: 'invalid' as const, noAccount: true };
      }
      if (account.lockedUntil && account.lockedUntil > now) return { refusal: 'locked' as const };

      const passwordValid = await verifyPassword(account.passwordHash, input.password);
      const totpStep = passwordValid ? await this.checkCode(tx, account, input.code, now) : null;
      if (totpStep === null) {
        return this.recordFailure(tx, account, maxAttempts, lockoutMinutes, context, now);
      }

      await tx
        .update(adminAccounts)
        .set({
          failedAttempts: 0,
          lockedUntil: null,
          totpLastStep: totpStep === 'backup_code' ? account.totpLastStep : totpStep,
          updatedAt: now,
        })
        .where(eq(adminAccounts.id, account.id));
      const signedIn = await this.sessions.start(tx, account, context, now);
      return { signedIn };
    });
    if ('refusal' in outcome) {
      // Outside the transaction, so a guessed name holds no connection while
      // it takes as long as a wrong password.
      if ('noAccount' in outcome) await verifyNoPassword(input.password);
      throw new SignInRefusedError(outcome.refusal);
    }
    return outcome.signedIn;
  }

  // The accepted TOTP time step, 'backup_code' for a backup code it used up,
  // or null for a wrong code.
  private async checkCode(
    tx: Transaction,
    account: typeof adminAccounts.$inferSelect,
    code: string,
    now: Date,
  ): Promise<number | 'backup_code' | null> {
    if (/^\d{6}$/.test(code)) {
      if (!account.totpSecretEncrypted) return null;
      // A code accepted once is never accepted again.
      return verifyTotp(
        this.secrets.decrypt(account.totpSecretEncrypted),
        code,
        now,
        account.totpLastStep,
      );
    }
    const used = await tx
      .update(adminBackupCodes)
      .set({ usedAt: now })
      .where(
        and(
          eq(adminBackupCodes.accountId, account.id),
          eq(adminBackupCodes.codeHash, this.secrets.backupCodeHash(normalizeBackupCode(code))),
          isNull(adminBackupCodes.usedAt),
        ),
      )
      .returning({ id: adminBackupCodes.id });
    return used.length > 0 ? 'backup_code' : null;
  }

  private async recordFailure(
    tx: Transaction,
    account: typeof adminAccounts.$inferSelect,
    maxAttempts: number,
    lockoutMinutes: number,
    context: AuditRequestContext,
    now: Date,
  ): Promise<{ refusal: 'invalid' | 'locked' }> {
    const failedAttempts = account.failedAttempts + 1;
    if (failedAttempts < maxAttempts) {
      await tx
        .update(adminAccounts)
        .set({ failedAttempts, updatedAt: now })
        .where(eq(adminAccounts.id, account.id));
      return { refusal: 'invalid' };
    }
    const lockedUntil = new Date(now.getTime() + lockoutMinutes * 60_000);
    await tx
      .update(adminAccounts)
      .set({ failedAttempts: 0, lockedUntil, updatedAt: now })
      .where(eq(adminAccounts.id, account.id));
    await this.audit.recordWrite(
      {
        actor: { type: 'system', id: null, role: null },
        context,
        cityId: null,
        action: 'admin_account.lock',
        target: { type: 'admin_account', id: account.id },
        before: {
          lockedUntil: account.lockedUntil?.toISOString() ?? null,
          failedAttempts: account.failedAttempts,
        },
        after: { lockedUntil: lockedUntil.toISOString(), failedAttempts: 0 },
      },
      tx,
    );
    return { refusal: 'locked' };
  }
}
