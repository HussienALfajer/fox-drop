import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, isNull, or } from 'drizzle-orm';
import { generateSecret, generateURI } from 'otplib';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import { recordFailedAttempt } from './lockout.js';
import { accountAccess, actorRole } from './roles.js';
import { adminAccounts, adminBackupCodes, adminSetupLinks } from './schema.js';
import {
  BACKUP_CODE_COUNT,
  hashPassword,
  IDENTITY_SECRETS,
  type IdentitySecrets,
  newBackupCode,
  normalizeBackupCode,
  tokenHash,
  verifyPassword,
} from './secrets.js';
import { verifyTotp } from './totp.js';

// AP §5.1: a TOTP app shows this name above the codes.
const TOTP_ISSUER = 'FOX DROP';

export type SetupRefusal =
  | 'link_invalid'
  | 'enrolment_not_started'
  | 'password_too_short'
  | 'password_invalid'
  | 'account_locked'
  | 'code_invalid';

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

type Transaction = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

// AP §5.1 item 3: the first sign-in. The setup link sets the password and
// enrols TOTP once, then shows the 10 backup codes once. A TOTP reset link
// (AP §5.3, owner decision 2026-11-05) takes the password the account
// already has instead of setting one, and enrols TOTP again the same way.
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
    // A setup that completed meanwhile used the link up.
    const offered = await this.database.db
      .update(adminSetupLinks)
      .set({ pendingTotpSecretEncrypted: this.secrets.encrypt(secret) })
      .where(and(eq(adminSetupLinks.id, link.id), isNull(adminSetupLinks.usedAt)))
      .returning({ id: adminSetupLinks.id });
    if (offered.length === 0) throw new SetupRefusedError('link_invalid');
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
    // A cheap check first, so a made-up token never costs an Argon2 hash. The
    // transaction checks again under the lock.
    const { purpose, accountId } = await this.usableLink(this.database.db, input.token, now);
    let passwordHash: string | null = null;
    if (purpose === 'setup') {
      const minLength = await this.settings.get('admin.password_min_length');
      if (input.password.length < minLength) {
        throw new SetupRefusedError('password_too_short', minLength);
      }
      passwordHash = await hashPassword(input.password);
    }
    const limits = {
      maxAttempts: await this.settings.get('admin.login_max_attempts'),
      lockoutMinutes: await this.settings.get('admin.lockout_min'),
    };
    const backupCodes = Array.from({ length: BACKUP_CODE_COUNT }, newBackupCode);

    // A wrong password commits its failure count, so the transaction returns
    // the refusal instead of throwing it.
    const refusal = await this.database.db.transaction(async (tx) => {
      // The account first, then the link: the order the admin team's actions
      // lock them in, so a TOTP reset during an enrolment cannot deadlock.
      await tx
        .select({ id: adminAccounts.id })
        .from(adminAccounts)
        .where(eq(adminAccounts.id, accountId))
        .for('update');
      const link = await this.usableLink(tx, input.token, now, true);
      if (!link.pendingTotpSecretEncrypted) throw new SetupRefusedError('enrolment_not_started');
      if (link.purpose === 'totp_reset') {
        const passwordRefusal = await this.checkPassword(tx, link.accountId, input.password, {
          limits,
          context,
          now,
        });
        if (passwordRefusal) return passwordRefusal;
      }
      const totpSecret = this.secrets.decrypt(link.pendingTotpSecretEncrypted);
      const totpStep = await verifyTotp(totpSecret, input.code, now);
      if (totpStep === null) throw new SetupRefusedError('code_invalid');

      await tx
        .update(adminAccounts)
        .set({
          status: 'active',
          ...(passwordHash ? { passwordHash } : {}),
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
      const { roles } = await accountAccess(tx, link.accountId);
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: link.accountId, role: actorRole(roles) },
          context,
          cityId: null,
          action: link.purpose === 'setup' ? 'admin_account.setup' : 'admin_account.totp_enrol',
          target: { type: 'admin_account', id: link.accountId },
          before: { status: link.status },
          after: {
            status: 'active',
            ...(link.purpose === 'setup' ? { passwordSet: true } : {}),
            totpEnrolled: true,
            backupCodesIssued: BACKUP_CODE_COUNT,
          },
        },
        tx,
      );
      return null;
    });
    if (refusal) throw new SetupRefusedError(refusal);
    return backupCodes;
  }

  // The account's own password at a TOTP re-enrolment, under its row lock,
  // with the sign-in's lockout (AP §5.1 item 4). The hash runs under the row
  // lock, as at sign-in.
  private async checkPassword(
    tx: Transaction,
    accountId: string,
    password: string,
    {
      limits,
      context,
      now,
    }: {
      limits: { maxAttempts: number; lockoutMinutes: number };
      context: AuditRequestContext;
      now: Date;
    },
  ): Promise<'password_invalid' | 'account_locked' | null> {
    const [account] = await tx
      .select()
      .from(adminAccounts)
      .where(eq(adminAccounts.id, accountId))
      .for('update');
    if (!account?.passwordHash) return 'password_invalid';
    if (account.lockedUntil && account.lockedUntil > now) return 'account_locked';
    if (await verifyPassword(account.passwordHash, password)) return null;
    const locked = await recordFailedAttempt(tx, this.audit, account, limits, context, now);
    return locked ? 'account_locked' : 'password_invalid';
  }

  // An unused, unexpired link whose account waits for it: a pending account
  // for a setup link, an account whose TOTP was reset for a reset link.
  // `lock` holds the link until the transaction ends, so two setups with one
  // link cannot both pass.
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
        purpose: adminSetupLinks.purpose,
        pendingTotpSecretEncrypted: adminSetupLinks.pendingTotpSecretEncrypted,
        email: adminAccounts.email,
        phoneEncrypted: adminAccounts.phoneEncrypted,
        status: adminAccounts.status,
      })
      .from(adminSetupLinks)
      .innerJoin(adminAccounts, eq(adminAccounts.id, adminSetupLinks.accountId))
      .where(
        and(
          eq(adminSetupLinks.tokenHash, tokenHash(token)),
          isNull(adminSetupLinks.usedAt),
          gt(adminSetupLinks.expiresAt, now),
          or(
            and(eq(adminSetupLinks.purpose, 'setup'), eq(adminAccounts.status, 'pending')),
            and(eq(adminSetupLinks.purpose, 'totp_reset'), eq(adminAccounts.status, 'totp_reset')),
          ),
        ),
      );
    const [link] = await (lock ? query.for('update') : query);
    if (!link) throw new SetupRefusedError('link_invalid');
    return link;
  }
}
