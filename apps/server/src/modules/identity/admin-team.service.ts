import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, inArray, isNull, max, ne, or, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import type { AdminRole } from '../settings/index.js';
import {
  type AdminSession,
  AdminSessionsService,
  type OpenSession,
} from './admin-sessions.service.js';
import { SETUP_LINK_HOURS } from './first-owner.js';
import { actorRole } from './roles.js';
import {
  adminAccountRoles,
  adminAccounts,
  adminAccountStatuses,
  adminBackupCodes,
  adminRolePermissions,
  adminSessions,
  adminSetupLinks,
} from './schema.js';
import { IDENTITY_SECRETS, type IdentitySecrets, newToken, tokenHash } from './secrets.js';

export type TeamRefusal =
  | 'not_found'
  | 'name_taken'
  // Owner decision 2026-11-05: the platform never has no active OWN.
  | 'last_owner'
  | 'own_account'
  | 'wrong_status';

export class TeamRefusedError extends Error {
  constructor(readonly refusal: TeamRefusal) {
    super(`admin team action refused: ${refusal}`);
  }
}

export interface TeamUser {
  id: string;
  name: string | null;
  email: string | null;
  phone: string | null;
  roles: string[];
  status: (typeof adminAccountStatuses)[number];
  totpEnrolled: boolean;
  lastSignInAt: Date | null;
  openSessions: OpenSession[];
}

export interface IssuedLink {
  accountId: string;
  // Shown once; the panel puts it in the link the owner shares.
  setupToken: string;
  setupExpiresAt: Date;
}

export interface NewTeamUser {
  name: string;
  // Already normalised; either or both (owner decision 2026-11-05).
  email: string | null;
  phone: string | null;
  roles: readonly AdminRole[];
}

type Transaction = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

// AP §5.2 last item, §5.3 and §9.15: OWN's administration of the panel's
// users. Each action and its audit event are one transaction.
@Injectable()
export class AdminTeamService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly audit: AuditService,
    private readonly sessions: AdminSessionsService,
  ) {}

  // Every user, oldest first, with their open sessions.
  async list(now = new Date()): Promise<TeamUser[]> {
    const db = this.database.db;
    const [accounts, roles, lastSignIns, openSessions] = await Promise.all([
      db.select().from(adminAccounts).orderBy(adminAccounts.createdAt),
      db
        .select({ accountId: adminAccountRoles.accountId, role: adminAccountRoles.roleCode })
        .from(adminAccountRoles)
        .where(isNull(adminAccountRoles.revokedAt)),
      db
        .select({ accountId: adminSessions.accountId, at: max(adminSessions.signedInAt) })
        .from(adminSessions)
        .groupBy(adminSessions.accountId),
      this.sessions.openSessions(now),
    ]);
    return accounts.map((account) => ({
      id: account.id,
      name: account.name,
      email: account.email,
      phone: account.phoneEncrypted && this.secrets.decrypt(account.phoneEncrypted),
      roles: roles
        .filter((row) => row.accountId === account.id)
        .map((row) => row.role)
        .sort(),
      status: account.status,
      totpEnrolled: account.totpSecretEncrypted !== null,
      lastSignInAt: lastSignIns.find((row) => row.accountId === account.id)?.at ?? null,
      openSessions: openSessions.filter((session) => session.accountId === account.id),
    }));
  }

  // AP §5.3: a pending user and its setup link, valid 24 hours.
  async create(
    user: NewTeamUser,
    actor: AdminSession,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<IssuedLink> {
    const phoneHash = user.phone && this.secrets.phoneHash(user.phone);
    return this.database.db.transaction(async (tx) => {
      const taken = await tx
        .select({ id: adminAccounts.id })
        .from(adminAccounts)
        .where(
          or(
            user.email ? eq(adminAccounts.email, user.email) : sql`false`,
            phoneHash ? eq(adminAccounts.phoneHash, phoneHash) : sql`false`,
          ),
        );
      if (taken.length > 0) throw new TeamRefusedError('name_taken');
      const [account] = await tx
        .insert(adminAccounts)
        .values({
          name: user.name,
          email: user.email,
          phoneEncrypted: user.phone && this.secrets.encrypt(user.phone),
          phoneHash,
          status: 'pending',
          createdAt: now,
          updatedAt: now,
        })
        .returning({ id: adminAccounts.id });
      if (!account) throw new Error('the account was not created');
      const roles = [...new Set(user.roles)].sort();
      await tx
        .insert(adminAccountRoles)
        .values(roles.map((roleCode) => ({ accountId: account.id, roleCode, grantedAt: now })));
      const link = await this.issueLink(tx, account.id, 'setup', now);
      await this.audit.recordWrite(
        {
          actor: this.actor(actor),
          context,
          cityId: null,
          action: 'admin_account.create',
          target: { type: 'admin_account', id: account.id },
          before: null,
          after: {
            roles,
            status: 'pending',
            hasEmail: user.email !== null,
            hasPhone: user.phone !== null,
            setupLinkExpiresAt: link.setupExpiresAt.toISOString(),
          },
        },
        tx,
      );
      return link;
    });
  }

  // AP §5.3, §6.1: one or more roles; permissions follow at the next request.
  async changeRoles(
    accountId: string,
    roles: readonly AdminRole[],
    actor: AdminSession,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<void> {
    const wanted: string[] = [...new Set(roles)].sort();
    await this.database.db.transaction(async (tx) => {
      await this.lockOwners(tx);
      const account = await this.account(tx, accountId);
      const held = await this.heldRoles(tx, accountId);
      if (held.join(',') === wanted.join(',')) return;
      if (held.includes('OWN') && !wanted.includes('OWN')) {
        await this.refuseLastOwner(tx, account);
      }
      const removed = held.filter((role) => !wanted.includes(role));
      const added = wanted.filter((role) => !held.includes(role));
      if (removed.length > 0) {
        await tx
          .update(adminAccountRoles)
          .set({ revokedAt: now })
          .where(
            and(
              eq(adminAccountRoles.accountId, accountId),
              inArray(adminAccountRoles.roleCode, removed),
              isNull(adminAccountRoles.revokedAt),
            ),
          );
      }
      if (added.length > 0) {
        await tx
          .insert(adminAccountRoles)
          .values(added.map((roleCode) => ({ accountId, roleCode, grantedAt: now })));
      }
      await this.audit.recordWrite(
        {
          actor: this.actor(actor),
          context,
          cityId: null,
          action: 'admin_account.roles_change',
          target: { type: 'admin_account', id: accountId },
          before: { roles: held },
          after: { roles: wanted },
        },
        tx,
      );
    });
  }

  // AP §5.3: takes effect at once and ends every session of the user.
  async disable(
    accountId: string,
    actor: AdminSession,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<void> {
    if (accountId === actor.accountId) throw new TeamRefusedError('own_account');
    await this.database.db.transaction(async (tx) => {
      await this.lockOwners(tx);
      const account = await this.account(tx, accountId);
      if (account.status === 'disabled') return;
      await this.refuseLastOwner(tx, account);
      await tx
        .update(adminAccounts)
        .set({ status: 'disabled', updatedAt: now })
        .where(eq(adminAccounts.id, accountId));
      const sessionsEnded = await this.sessions.endAll(tx, accountId, 'account_disabled', now);
      await this.audit.recordWrite(
        {
          actor: this.actor(actor),
          context,
          cityId: null,
          action: 'admin_account.disable',
          target: { type: 'admin_account', id: accountId },
          before: { status: account.status },
          after: { status: 'disabled', sessionsEnded },
        },
        tx,
      );
    });
  }

  // Back to where the user was before: active once set up, waiting for its
  // TOTP enrolment after a reset, otherwise pending.
  async enable(
    accountId: string,
    actor: AdminSession,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const account = await this.account(tx, accountId);
      if (account.status !== 'disabled') return;
      const status = !account.passwordHash
        ? 'pending'
        : account.totpSecretEncrypted
          ? 'active'
          : 'totp_reset';
      await tx
        .update(adminAccounts)
        .set({ status, updatedAt: now })
        .where(eq(adminAccounts.id, accountId));
      await this.audit.recordWrite(
        {
          actor: this.actor(actor),
          context,
          cityId: null,
          action: 'admin_account.enable',
          target: { type: 'admin_account', id: accountId },
          before: { status: 'disabled' },
          after: { status },
        },
        tx,
      );
    });
  }

  // AP §5.2: ends every session of the user.
  async forceSignOut(
    accountId: string,
    actor: AdminSession,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      await this.account(tx, accountId);
      const sessionsEnded = await this.sessions.endAll(tx, accountId, 'forced_sign_out', now);
      await this.audit.recordWrite(
        {
          actor: this.actor(actor),
          context,
          cityId: null,
          action: 'admin_account.force_sign_out',
          target: { type: 'admin_account', id: accountId },
          before: null,
          after: { sessionsEnded },
        },
        tx,
      );
    });
  }

  // AP §5.3, owner decision 2026-11-05: the TOTP and the unused backup codes
  // stop working and the sessions end at once; the user enrols again through
  // a link with the password they already have. Again for a user still
  // waiting, it replaces the link.
  async resetTotp(
    accountId: string,
    actor: AdminSession,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<IssuedLink> {
    return this.database.db.transaction(async (tx) => {
      await this.lockOwners(tx);
      const account = await this.account(tx, accountId);
      if (account.status !== 'active' && account.status !== 'totp_reset') {
        throw new TeamRefusedError('wrong_status');
      }
      if (account.status === 'active') await this.refuseLastOwner(tx, account);
      await tx
        .update(adminAccounts)
        .set({
          status: 'totp_reset',
          totpSecretEncrypted: null,
          totpLastStep: null,
          updatedAt: now,
        })
        .where(eq(adminAccounts.id, accountId));
      await tx
        .update(adminBackupCodes)
        .set({ revokedAt: now })
        .where(
          and(
            eq(adminBackupCodes.accountId, accountId),
            isNull(adminBackupCodes.usedAt),
            isNull(adminBackupCodes.revokedAt),
          ),
        );
      await tx
        .update(adminSetupLinks)
        .set({ expiresAt: now })
        .where(
          and(
            eq(adminSetupLinks.accountId, accountId),
            isNull(adminSetupLinks.usedAt),
            gt(adminSetupLinks.expiresAt, now),
          ),
        );
      const sessionsEnded = await this.sessions.endAll(tx, accountId, 'totp_reset', now);
      const link = await this.issueLink(tx, accountId, 'totp_reset', now);
      await this.audit.recordWrite(
        {
          actor: this.actor(actor),
          context,
          cityId: null,
          action: 'admin_account.totp_reset',
          target: { type: 'admin_account', id: accountId },
          before: { status: account.status, totpEnrolled: account.status === 'active' },
          after: {
            status: 'totp_reset',
            totpEnrolled: false,
            sessionsEnded,
            setupLinkExpiresAt: link.setupExpiresAt.toISOString(),
          },
        },
        tx,
      );
      return link;
    });
  }

  private actor(session: AdminSession) {
    return { type: 'admin' as const, id: session.accountId, role: actorRole(session.roles) };
  }

  // Actions that could leave no active OWN take turns, so two OWNs cannot
  // disable each other at once.
  private async lockOwners(tx: Transaction): Promise<void> {
    await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtext('identity.owners'))`);
  }

  private async account(tx: Transaction, accountId: string) {
    const [account] = await tx
      .select()
      .from(adminAccounts)
      .where(eq(adminAccounts.id, accountId))
      .for('update');
    if (!account) throw new TeamRefusedError('not_found');
    return account;
  }

  private async heldRoles(tx: Transaction, accountId: string): Promise<string[]> {
    const rows = await tx
      .select({ role: adminAccountRoles.roleCode })
      .from(adminAccountRoles)
      .where(and(eq(adminAccountRoles.accountId, accountId), isNull(adminAccountRoles.revokedAt)));
    return rows.map((row) => row.role).sort();
  }

  // Refuses when the account is an active OWN and no other active account
  // holds OWN.
  private async refuseLastOwner(
    tx: Transaction,
    account: { id: string; status: string },
  ): Promise<void> {
    if (account.status !== 'active') return;
    const held = await this.heldRoles(tx, account.id);
    if (!held.includes('OWN')) return;
    const others = await tx
      .select({ id: adminAccounts.id })
      .from(adminAccounts)
      .innerJoin(adminAccountRoles, eq(adminAccountRoles.accountId, adminAccounts.id))
      .where(
        and(
          eq(adminAccountRoles.roleCode, 'OWN'),
          isNull(adminAccountRoles.revokedAt),
          eq(adminAccounts.status, 'active'),
          ne(adminAccounts.id, account.id),
        ),
      )
      .limit(1);
    if (others.length === 0) throw new TeamRefusedError('last_owner');
  }

  private async issueLink(
    tx: Transaction,
    accountId: string,
    purpose: 'setup' | 'totp_reset',
    now: Date,
  ): Promise<IssuedLink> {
    const setupToken = newToken();
    const setupExpiresAt = new Date(now.getTime() + SETUP_LINK_HOURS * 3_600_000);
    await tx.insert(adminSetupLinks).values({
      accountId,
      tokenHash: tokenHash(setupToken),
      purpose,
      expiresAt: setupExpiresAt,
      createdAt: now,
    });
    return { accountId, setupToken, setupExpiresAt };
  }

  // The role matrix (AP §9.15, read-only in V1): each role's permissions.
  async roleMatrix(): Promise<{ role: string; permissions: string[] }[]> {
    const rows = await this.database.db
      .select()
      .from(adminRolePermissions)
      .orderBy(adminRolePermissions.roleCode, adminRolePermissions.permissionCode);
    const matrix = new Map<string, string[]>();
    for (const row of rows) {
      matrix.set(row.roleCode, [...(matrix.get(row.roleCode) ?? []), row.permissionCode]);
    }
    return [...matrix].map(([role, permissions]) => ({ role, permissions }));
  }
}
