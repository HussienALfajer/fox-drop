import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, isNull } from 'drizzle-orm';
import { generateSecret, generateURI } from 'otplib';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import { adminAccounts, adminBackupCodes, adminSetupLinks } from './schema.js';
import {
  BACKUP_CODE_COUNT,
  hashPassword,
  IDENTITY_SECRETS,
  type IdentitySecrets,
  newBackupCode,
  normalizeBackupCode,
  tokenHash,
} from './secrets.js';
import { verifyTotp } from './totp.js';

// AP §5.1: a TOTP app shows this name above the codes.
const TOTP_ISSUER = 'FOX DROP';

export type SetupRefusal =
  'link_invalid' | 'enrolment_not_started' | 'password_too_short' | 'code_invalid';

export class SetupRefusedError extends Error {
  constructor(
    readonly refusal: SetupRefusal,
    readonly passwordMinLength?: number,
  ) {
    super(`setup refused: ${refusal}`);
  }
}

export interface TotpEnrolment {
  secret: string;
  otpauthUri: string;
}

// AP §5.1 item 3: the first sign-in. The setup link sets the password and
// enrols TOTP once, then shows the 10 backup codes once.
@Injectable()
export class AdminSetupService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
  ) {}

  // A new secret on every call, so each secret is returned once; the last one
  // offered is the one the setup checks.
  async startTotpEnrolment(token: string, now = new Date()): Promise<TotpEnrolment> {
    const link = await this.usableLink(this.database.db, token, now);
    const secret = generateSecret();
    await this.database.db
      .update(adminSetupLinks)
      .set({ pendingTotpSecretEncrypted: this.secrets.encrypt(secret) })
      .where(eq(adminSetupLinks.id, link.id));
    const label = link.email ?? (link.phoneEncrypted && this.secrets.decrypt(link.phoneEncrypted));
    return {
      secret,
      otpauthUri: generateURI({ issuer: TOTP_ISSUER, label: label ?? link.accountId, secret }),
    };
  }

  // Returns the backup codes, the only time they are shown.
  async completeSetup(
    input: { token: string; password: string; code: string },
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<string[]> {
    const minLength = await this.settings.get('admin.password_min_length');
    if (input.password.length < minLength) {
      throw new SetupRefusedError('password_too_short', minLength);
    }
    const passwordHash = await hashPassword(input.password);
    const backupCodes = Array.from({ length: BACKUP_CODE_COUNT }, newBackupCode);

    await this.database.db.transaction(async (tx) => {
      const link = await this.usableLink(tx, input.token, now, true);
      if (!link.pendingTotpSecretEncrypted) throw new SetupRefusedError('enrolment_not_started');
      const totpSecret = this.secrets.decrypt(link.pendingTotpSecretEncrypted);
      const totpStep = await verifyTotp(totpSecret, input.code, now);
      if (totpStep === null) throw new SetupRefusedError('code_invalid');

      await tx
        .update(adminAccounts)
        .set({
          status: 'active',
          passwordHash,
          totpSecretEncrypted: this.secrets.encrypt(totpSecret),
          totpLastStep: totpStep,
          failedAttempts: 0,
          lockedUntil: null,
          updatedAt: now,
        })
        .where(eq(adminAccounts.id, link.accountId));
      await tx
        .update(adminSetupLinks)
        .set({ usedAt: now, pendingTotpSecretEncrypted: null })
        .where(eq(adminSetupLinks.id, link.id));
      await tx.insert(adminBackupCodes).values(
        backupCodes.map((code) => ({
          accountId: link.accountId,
          codeHash: this.secrets.backupCodeHash(normalizeBackupCode(code)),
          createdAt: now,
        })),
      );
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: link.accountId, role: link.roles.join(',') },
          context,
          cityId: null,
          action: 'admin_account.setup',
          target: { type: 'admin_account', id: link.accountId },
          before: { status: 'pending' },
          after: {
            status: 'active',
            passwordSet: true,
            totpEnrolled: true,
            backupCodesIssued: BACKUP_CODE_COUNT,
          },
        },
        tx,
      );
    });
    return backupCodes;
  }

  // An unused, unexpired link of a pending account. `lock` holds the link
  // until the transaction ends, so two setups with one link cannot both pass.
  private async usableLink(
    db: Pick<Database['db'], 'select'>,
    token: string,
    now: Date,
    lock = false,
  ) {
    const query = db
      .select({
        id: adminSetupLinks.id,
        accountId: adminSetupLinks.accountId,
        pendingTotpSecretEncrypted: adminSetupLinks.pendingTotpSecretEncrypted,
        email: adminAccounts.email,
        phoneEncrypted: adminAccounts.phoneEncrypted,
        roles: adminAccounts.roles,
      })
      .from(adminSetupLinks)
      .innerJoin(adminAccounts, eq(adminAccounts.id, adminSetupLinks.accountId))
      .where(
        and(
          eq(adminSetupLinks.tokenHash, tokenHash(token)),
          isNull(adminSetupLinks.usedAt),
          gt(adminSetupLinks.expiresAt, now),
          eq(adminAccounts.status, 'pending'),
        ),
      );
    const [link] = await (lock ? query.for('update') : query);
    if (!link) throw new SetupRefusedError('link_invalid');
    return link;
  }
}
