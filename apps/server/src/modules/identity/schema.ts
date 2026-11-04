import { sql } from 'drizzle-orm';
import {
  bigint,
  check,
  index,
  inet,
  integer,
  pgSchema,
  primaryKey,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';

// Architecture §4.3: the identity module owns the identity schema.
export const identity = pgSchema('identity');

// totp_reset: OWN reset the TOTP (AP §5.3); the account keeps its password
// and enrols again through a link before it can sign in.
export const adminAccountStatuses = ['pending', 'active', 'totp_reset', 'disabled'] as const;

// A user of the admin panel (AP §5.1, §5.3). It signs in with its email or its
// phone. A pending account has neither password nor TOTP until its setup link
// is used. Secrets are never stored in clear (architecture §10.3, §15.3).
export const adminAccounts = identity.table(
  'admin_accounts',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    // The person's name for the admin team list (AP §9.15); null only for a
    // first OWN, which the server command creates without one.
    name: text('name'),
    // Lower case.
    email: text('email').unique(),
    // The E.164 phone, encrypted, and its keyed hash to find it by.
    phoneEncrypted: text('phone_encrypted'),
    phoneHash: text('phone_hash').unique(),
    // Deprecated: the roles are rows of admin_account_roles. Kept, empty for
    // new accounts, until a later migration drops it (expand, then contract).
    roles: text('roles')
      .array()
      .notNull()
      .default(sql`'{}'`),
    status: text('status', { enum: adminAccountStatuses }).notNull().default('pending'),
    // Argon2id.
    passwordHash: text('password_hash'),
    totpSecretEncrypted: text('totp_secret_encrypted'),
    // The last TOTP time step accepted, so a code is never accepted twice.
    totpLastStep: bigint('totp_last_step', { mode: 'number' }),
    // Failures since the last success or lockout (admin.login_max_attempts).
    failedAttempts: integer('failed_attempts').notNull().default(0),
    lockedUntil: timestamp('locked_until', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    check(
      'admin_accounts_status_values',
      sql`${table.status} IN ('pending', 'active', 'totp_reset', 'disabled')`,
    ),
    check(
      'admin_accounts_has_sign_in_name',
      sql`${table.email} IS NOT NULL OR ${table.phoneHash} IS NOT NULL`,
    ),
    check(
      'admin_accounts_phone_complete',
      sql`(${table.phoneHash} IS NULL) = (${table.phoneEncrypted} IS NULL)`,
    ),
    check(
      'admin_accounts_active_is_set_up',
      sql`${table.status} <> 'active' OR (${table.passwordHash} IS NOT NULL AND ${table.totpSecretEncrypted} IS NOT NULL)`,
    ),
    check(
      'admin_accounts_totp_reset_has_password',
      sql`${table.status} <> 'totp_reset' OR (${table.passwordHash} IS NOT NULL AND ${table.totpSecretEncrypted} IS NULL)`,
    ),
  ],
);

// AP §6.1: the five fixed roles of V1, as rows so V2 can add custom ones.
export const adminRoles = identity.table('admin_roles', {
  code: text('code').primaryKey(),
});

// AP §6.2–6.3: one row per permission (permissions.ts lists the codes).
export const adminPermissions = identity.table('admin_permissions', {
  code: text('code').primaryKey(),
});

// Which role holds which permission. The application role only reads these
// three tables; a migration changes them.
export const adminRolePermissions = identity.table(
  'admin_role_permissions',
  {
    roleCode: text('role_code')
      .notNull()
      .references(() => adminRoles.code),
    permissionCode: text('permission_code')
      .notNull()
      .references(() => adminPermissions.code),
  },
  (table) => [
    primaryKey({ columns: [table.roleCode, table.permissionCode] }),
    index('admin_role_permissions_permission').on(table.permissionCode),
  ],
);

// The roles an account holds (AP §6.1: one or more). A removed role is
// revoked, never deleted, so the rows keep who held what and when.
export const adminAccountRoles = identity.table(
  'admin_account_roles',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    accountId: uuid('account_id')
      .notNull()
      .references(() => adminAccounts.id),
    roleCode: text('role_code')
      .notNull()
      .references(() => adminRoles.code),
    grantedAt: timestamp('granted_at', { withTimezone: true }).notNull().defaultNow(),
    revokedAt: timestamp('revoked_at', { withTimezone: true }),
  },
  (table) => [
    index('admin_account_roles_account').on(table.accountId),
    index('admin_account_roles_role').on(table.roleCode),
    uniqueIndex('admin_account_roles_held')
      .on(table.accountId, table.roleCode)
      .where(sql`${table.revokedAt} IS NULL`),
  ],
);

export const adminSetupLinkPurposes = ['setup', 'totp_reset'] as const;

// A one-time setup link (AP §5.1 item 3): valid 24 hours, used once. The TOTP
// secret offered for enrolment waits here until the setup completes. A
// totp_reset link enrols TOTP again for an account that keeps its password.
export const adminSetupLinks = identity.table(
  'admin_setup_links',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    accountId: uuid('account_id')
      .notNull()
      .references(() => adminAccounts.id),
    // SHA-256 of the token; the token itself is only in the link.
    tokenHash: text('token_hash').notNull().unique(),
    purpose: text('purpose', { enum: adminSetupLinkPurposes }).notNull().default('setup'),
    pendingTotpSecretEncrypted: text('pending_totp_secret_encrypted'),
    expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
    usedAt: timestamp('used_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index('admin_setup_links_account').on(table.accountId),
    check('admin_setup_links_purpose_values', sql`${table.purpose} IN ('setup', 'totp_reset')`),
  ],
);

// The 10 single-use backup codes of an account (AP §5.1 item 3), hashed.
export const adminBackupCodes = identity.table(
  'admin_backup_codes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    accountId: uuid('account_id')
      .notNull()
      .references(() => adminAccounts.id),
    codeHash: text('code_hash').notNull(),
    usedAt: timestamp('used_at', { withTimezone: true }),
    // A TOTP reset revokes the codes that were never used.
    revokedAt: timestamp('revoked_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [index('admin_backup_codes_account').on(table.accountId)],
);

// The last three are OWN's actions (AP §5.2–5.3).
export const adminSessionEndReasons = [
  'sign_out',
  'idle',
  'max_lifetime',
  'forced_sign_out',
  'account_disabled',
  'totp_reset',
] as const;

// A signed-in session of the panel (AP §5.2): the device and browser (its user
// agent), the IP address, the sign-in time and the last activity.
export const adminSessions = identity.table(
  'admin_sessions',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    accountId: uuid('account_id')
      .notNull()
      .references(() => adminAccounts.id),
    // SHA-256 of the cookie's token.
    tokenHash: text('token_hash').notNull().unique(),
    userAgent: text('user_agent'),
    ipAddress: inet('ip_address'),
    signedInAt: timestamp('signed_in_at', { withTimezone: true }).notNull().defaultNow(),
    lastActivityAt: timestamp('last_activity_at', { withTimezone: true }).notNull().defaultNow(),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    endReason: text('end_reason', { enum: adminSessionEndReasons }),
  },
  (table) => [
    index('admin_sessions_account').on(table.accountId),
    // The team list: each account's last sign-in and its open sessions.
    index('admin_sessions_account_signed_in').on(table.accountId, table.signedInAt),
    index('admin_sessions_open')
      .on(table.accountId)
      .where(sql`${table.endedAt} IS NULL`),
    check(
      'admin_sessions_end_reason_values',
      sql`${table.endReason} IN ('sign_out', 'idle', 'max_lifetime', 'forced_sign_out', 'account_disabled', 'totp_reset')`,
    ),
    check(
      'admin_sessions_ended_with_reason',
      sql`(${table.endedAt} IS NULL) = (${table.endReason} IS NULL)`,
    ),
  ],
);
