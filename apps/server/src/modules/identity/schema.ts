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

// The apps whose users sign in with a phone and a WhatsApp code (architecture
// §8.3, §15.1; owner decision 2026-11-05): the customer, restaurant and
// captain apps.
export const appParties = ['customer', 'merchant', 'captain'] as const;

export const appSignInCodeEndReasons = ['used', 'replaced', 'attempts_exhausted'] as const;

// An app sign-in code (architecture §8.3.2): only its keyed hash, with the
// number (by its keyed hash), the device and the expiry. One open code per
// number and app: a new request ends the old one.
export const appSignInCodes = identity.table(
  'app_sign_in_codes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    party: text('party', { enum: appParties }).notNull(),
    phoneHash: text('phone_hash').notNull(),
    // The app installation that asked for it; only it can use the code.
    deviceId: text('device_id').notNull(),
    codeHash: text('code_hash').notNull(),
    // Wrong codes entered so far (otp.max_attempts).
    attempts: integer('attempts').notNull().default(0),
    expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    endReason: text('end_reason', { enum: appSignInCodeEndReasons }),
  },
  (table) => [
    uniqueIndex('app_sign_in_codes_open_per_number')
      .on(table.party, table.phoneHash)
      .where(sql`${table.endedAt} IS NULL`),
    index('app_sign_in_codes_number_created').on(table.phoneHash, table.createdAt),
    check(
      'app_sign_in_codes_party_values',
      sql`${table.party} IN ('customer', 'merchant', 'captain')`,
    ),
    check(
      'app_sign_in_codes_end_reason_values',
      sql`${table.endReason} IN ('used', 'replaced', 'attempts_exhausted')`,
    ),
    check(
      'app_sign_in_codes_ended_with_reason',
      sql`(${table.endedAt} IS NULL) = (${table.endReason} IS NULL)`,
    ),
  ],
);

// A customer (CU §5). The first sign-in of a number creates it; the details
// screen (CU §5.3) fills the rest later. One active account per number: a
// closed account (CU §5.5) leaves its number free for a new one.
export const customerAccountStatuses = ['active'] as const;

export const customerAccounts = identity.table(
  'customer_accounts',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    // The E.164 phone, encrypted, and its keyed hash to find it by.
    phoneEncrypted: text('phone_encrypted').notNull(),
    phoneHash: text('phone_hash').notNull(),
    status: text('status', { enum: customerAccountStatuses }).notNull().default('active'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    uniqueIndex('customer_accounts_active_phone')
      .on(table.phoneHash)
      .where(sql`${table.status} = 'active'`),
    check('customer_accounts_status_values', sql`${table.status} IN ('active')`),
  ],
);

export const merchantRoles = ['owner', 'cashier'] as const;

// A restaurant's owner «مالك» or cashier «كاشير» (RA §5.1). There is no
// self-signup: OPS adds owners and owners add cashiers. In V1 a number belongs
// to at most one restaurant (S6), so it has one account not removed. A removed
// account keeps its row with removed_at. The restaurant and its city belong to
// merchants and geo: plain columns here.
export const merchantAccounts = identity.table(
  'merchant_accounts',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    restaurantId: uuid('restaurant_id').notNull(),
    role: text('role', { enum: merchantRoles }).notNull(),
    name: text('name').notNull(),
    // The E.164 phone, encrypted, and its keyed hash to find it by.
    phoneEncrypted: text('phone_encrypted').notNull(),
    phoneHash: text('phone_hash').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    removedAt: timestamp('removed_at', { withTimezone: true }),
  },
  (table) => [
    uniqueIndex('merchant_accounts_phone')
      .on(table.phoneHash)
      .where(sql`${table.removedAt} IS NULL`),
    index('merchant_accounts_restaurant').on(table.restaurantId),
    check('merchant_accounts_role_values', sql`${table.role} IN ('owner', 'cashier')`),
  ],
);

// A captain's sign-in (CA §4.9): one number per captain record, never created
// by sign-in; OPS change the number (a later slice). The captain and its city
// belong to captains and geo: plain columns here.
export const captainAccounts = identity.table('captain_accounts', {
  id: uuid('id')
    .primaryKey()
    .default(sql`uuidv7()`),
  cityId: uuid('city_id').notNull(),
  captainId: uuid('captain_id').notNull().unique(),
  // The E.164 phone, encrypted, and its keyed hash to find it by.
  phoneEncrypted: text('phone_encrypted').notNull(),
  phoneHash: text('phone_hash').notNull().unique(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// other_device: a captain signed in on another device (CA §4.9, K5).
export const appSessionEndReasons = [
  'sign_out',
  'sign_out_everywhere',
  'refresh_reuse',
  'new_sign_in',
  'other_device',
] as const;

// A signed-in app installation (architecture §15.1): one refresh token family.
// It does not expire with inactivity (CU §5.4); it ends on sign-out, sign-out
// everywhere, a reused refresh token, or a new sign-in on the same device.
export const appSessions = identity.table(
  'app_sessions',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    party: text('party', { enum: appParties }).notNull(),
    // The party's account, such as a customer_accounts row.
    accountId: uuid('account_id').notNull(),
    deviceId: text('device_id').notNull(),
    userAgent: text('user_agent'),
    ipAddress: inet('ip_address'),
    signedInAt: timestamp('signed_in_at', { withTimezone: true }).notNull(),
    lastRefreshedAt: timestamp('last_refreshed_at', { withTimezone: true }).notNull(),
    // The refresh token used last, the only one a retry may present again.
    lastUsedTokenId: uuid('last_used_token_id'),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    endReason: text('end_reason', { enum: appSessionEndReasons }),
  },
  (table) => [
    index('app_sessions_open_account')
      .on(table.party, table.accountId)
      .where(sql`${table.endedAt} IS NULL`),
    index('app_sessions_open_device')
      .on(table.party, table.deviceId)
      .where(sql`${table.endedAt} IS NULL`),
    check('app_sessions_party_values', sql`${table.party} IN ('customer', 'merchant', 'captain')`),
    check(
      'app_sessions_end_reason_values',
      sql`${table.endReason} IN ('sign_out', 'sign_out_everywhere', 'refresh_reuse', 'new_sign_in', 'other_device')`,
    ),
    check(
      'app_sessions_ended_with_reason',
      sql`(${table.endedAt} IS NULL) = (${table.endReason} IS NULL)`,
    ),
  ],
);

// A refresh token of a session (architecture §15.1): stored as SHA-256, used
// once. Presenting a used one again ends its session.
export const appRefreshTokens = identity.table(
  'app_refresh_tokens',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    sessionId: uuid('session_id')
      .notNull()
      .references(() => appSessions.id),
    tokenHash: text('token_hash').notNull().unique(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
    usedAt: timestamp('used_at', { withTimezone: true }),
    // Set when a retry within the grace replaced it before it was used.
    supersededAt: timestamp('superseded_at', { withTimezone: true }),
  },
  (table) => [index('app_refresh_tokens_session').on(table.sessionId)],
);

// The Ed25519 keys that sign the apps' access tokens (architecture §15.1). A
// new key every 30 days (owner decision 2026-11-05); an old one still verifies
// until the last token it signed has expired. The private key is encrypted.
export const appSigningKeys = identity.table('app_signing_keys', {
  id: uuid('id')
    .primaryKey()
    .default(sql`uuidv7()`),
  privateKeyEncrypted: text('private_key_encrypted').notNull(),
  publicKey: text('public_key').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
});
