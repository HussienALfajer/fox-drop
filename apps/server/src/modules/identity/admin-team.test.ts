import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import { Get, Module } from '@nestjs/common';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import { Valkey } from 'iovalkey';
import { generate, generateSecret } from 'otplib';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { RequirePermission } from '../../http/access.js';
import { createApiApp } from '../../http/create-api-app.js';
import { createOpenApiDocument } from '../../http/openapi.js';
import { AdminController, ROUTE_GROUPS } from '../../http/route-groups.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { adminRoles } from '../settings/index.js';
import { AdminSessionsService } from './admin-sessions.service.js';
import { AdminSetupService } from './admin-setup.service.js';
import { AdminSignInService } from './admin-sign-in.service.js';
import { AdminTeamService } from './admin-team.service.js';
import { type AdminPermission, adminPermissions } from './permissions.js';
import { ADMIN_SESSION_COOKIE } from './route-access.guard.js';
import { adminAccountRoles, adminAccounts } from './schema.js';
import { hashPassword, IdentitySecrets } from './secrets.js';

// Routes that exist only in this test: one that declares no access, and two
// that need a permission of OPS and of FIN, for the union of two roles.
@AdminController('test-access')
class AccessTestController {
  @Get('undeclared')
  undeclared() {
    return {};
  }

  @Get('operations')
  @RequirePermission('operations.manage')
  operations() {
    return {};
  }

  @Get('finance')
  @RequirePermission('finance.manage')
  finance() {
    return {};
  }
}

@Module({ imports: [ApiModule], controllers: [AccessTestController] })
class TestApiModule {}

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let valkey: Valkey;
let db: Database;
let sessions: AdminSessionsService;
let setup: AdminSetupService;
let signIn: AdminSignInService;
let team: AdminTeamService;
let passwordHash: string;

const key = randomBytes(32);
const secrets = new IdentitySecrets(key);
const context = { ipAddress: '203.0.113.9', device: 'Firefox 140 on Windows' };
const password = 'correct horse battery';

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = key.toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  valkey = new Valkey(cache.url);
  db = createDatabase(database.appUrl);
  app = await createApiApp(TestApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  sessions = app.get(AdminSessionsService);
  setup = app.get(AdminSetupService);
  signIn = app.get(AdminSignInService);
  team = app.get(AdminTeamService);
  passwordHash = await hashPassword(password);
}, 300_000);

afterAll(async () => {
  await app?.close();
  valkey?.disconnect();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

beforeEach(async () => {
  await valkey.flushall();
});

let accounts = 0;
function newEmail(): string {
  accounts += 1;
  return `team${accounts}@example.test`;
}

// An account that has finished its setup, holding these roles.
async function activeUser(roles: string[]) {
  const secret = generateSecret();
  const email = newEmail();
  const [account] = await db.db
    .insert(adminAccounts)
    .values({
      name: `User ${accounts}`,
      email,
      status: 'active',
      passwordHash,
      totpSecretEncrypted: secrets.encrypt(secret),
    })
    .returning({ id: adminAccounts.id });
  await db.db
    .insert(adminAccountRoles)
    .values(roles.map((roleCode) => ({ accountId: account!.id, roleCode })));
  return { accountId: account!.id, email, secret };
}

async function signedIn(accountId: string, now = new Date()) {
  const { token, session } = await sessions.start(db.db, accountId, context, now);
  return { token, session, cookies: { [ADMIN_SESSION_COOKIE]: token } };
}

async function owner() {
  const user = await activeUser(['OWN']);
  return { ...user, ...(await signedIn(user.accountId)) };
}

function totpCode(secret: string, at: Date): Promise<string> {
  return generate({ secret, epoch: Math.floor(at.getTime() / 1000) });
}

async function auditEvents(targetId: string) {
  const { rows } = await sql.query(
    `SELECT action, actor_id, actor_role FROM audit.events WHERE target_id = $1 ORDER BY occurred_at, id`,
    [targetId],
  );
  return rows;
}

// AP §6.2–6.3 as the owner wrote them. Each role's permissions, OWN aside:
// OWN holds every permission.
const specifiedGrants: Record<string, AdminPermission[]> = {
  OPS: [
    'dashboard.read',
    'dashboard.manage',
    'operations.read',
    'operations.manage',
    'operations.compensate',
    'live_map.read',
    'live_map.manage',
    'order_history.read',
    'order_history.manage',
    'restaurants.read',
    'restaurants.manage',
    'restaurants.create',
    'restaurants.menus',
    'captains.read',
    'captains.manage',
    'customers.read',
    'customers.manage',
    'customers.compensate',
    'support.read',
    'support.manage',
    'marketing.read',
    'zones.read',
    'content.read',
    'reports.operations',
    'customers.reveal_phone',
    'emergency_stop.toggle',
    'dispatch.switch_mode',
    'restaurants.activate',
    'menus.edit_prices',
    'orders.handover_after_pickup',
    'orders.confirm_pickup',
    'orders.act_for_captain',
    'captains.release_device',
    'support.resolve_pickup_dispute',
    'menus.review_change_requests',
    'restaurants.owner_accounts',
    'customers.close_account',
    'customers.clear_strikes',
    'customers.block',
    'captains.suspend',
    'exports.phone_numbers',
  ],
  SUP: [
    'dashboard.read',
    'operations.read',
    'operations.compensate',
    'live_map.read',
    'order_history.read',
    'restaurants.read',
    'captains.read',
    'customers.read',
    'customers.compensate',
    'support.read',
    'support.manage',
    'content.faqs',
    'reports.support',
    'customers.reveal_phone',
    'customers.close_account',
    'customers.clear_strikes',
    'exports.phone_numbers',
  ],
  FIN: [
    'dashboard.read',
    'operations.read',
    'order_history.read',
    'order_history.financial_correction',
    'restaurants.statements',
    'captains.money',
    'customers.read',
    'customers.dues',
    'support.read',
    'support.resolve_pickup_dispute',
    'finance.read',
    'finance.manage',
    'marketing.read_costs',
    'zones.read',
    'reports.financial',
    'captains.cash_limit',
    'cash_desk.record',
    'captains.hand_in_grace',
    'ledger.manual_adjustment',
    'fx.edit_rates',
  ],
  DATA: [
    'restaurants.create',
    'restaurants.menus',
    'menus.edit_prices',
    'marketing.banners',
    'content.categories',
  ],
};

function grantsOf(role: string): string[] {
  return role === 'OWN' ? [...adminPermissions].sort() : [...specifiedGrants[role]!].sort();
}

describe('roles and permissions as data (AP §6.1–6.3)', () => {
  it('are the five roles, the listed permissions and the matrix of AP §6', async () => {
    const roles = await sql.query('SELECT code FROM identity.admin_roles ORDER BY code');
    expect(roles.rows.map((row) => row.code)).toEqual([...adminRoles].sort());
    const permissions = await sql.query(
      'SELECT code FROM identity.admin_permissions ORDER BY code',
    );
    expect(permissions.rows.map((row) => row.code)).toEqual([...adminPermissions].sort());
    expect(new Set(adminPermissions).size).toBe(adminPermissions.length);
    for (const role of adminRoles) {
      const grants = await sql.query(
        'SELECT permission_code FROM identity.admin_role_permissions WHERE role_code = $1 ORDER BY permission_code',
        [role],
      );
      expect(grants.rows.map((row) => row.permission_code)).toEqual(grantsOf(role));
    }
    expect((await team.roleMatrix()).map((row) => row.role).sort()).toEqual([...adminRoles].sort());
  });

  it('cannot be changed by the application role', async () => {
    for (const statement of [
      "INSERT INTO identity.admin_roles (code) VALUES ('X')",
      "UPDATE identity.admin_permissions SET code = code WHERE code = 'finance.read'",
      "INSERT INTO identity.admin_role_permissions VALUES ('DATA', 'finance.read')",
      "DELETE FROM identity.admin_role_permissions WHERE role_code = 'DATA'",
    ]) {
      await expect(sql.query(statement)).rejects.toThrow(/permission denied/);
    }
  });

  it('give a user with two roles the union of both (AP §6.1)', async () => {
    const user = await activeUser(['OPS', 'FIN']);
    const { session } = await signedIn(user.accountId);
    expect(session.roles).toEqual(['FIN', 'OPS']);
    expect(session.permissions).toEqual(
      [...new Set([...grantsOf('OPS'), ...grantsOf('FIN')])].sort(),
    );
  });
});

// What each route needs. A route missing here fails the matrix, so every new
// route declares its access in this test too (architecture §15.2). A settings
// route needs a session and one of the setting's Appendix A edit roles (owner
// decision 2026-11-05); the matrix calls them with dispatch.mode (OWN, OPS),
// and the list with any setting (OWN, OPS for dispatch.mode, FIN for the
// currencies). An app route needs the app's bearer token, which no admin has.
type Access =
  'public' | 'session' | 'app_session' | 'undeclared' | AdminPermission | { editRoles: string[] };
const settingRoles = { editRoles: ['OWN', 'OPS'] };
const routeAccess: Record<string, Access> = {
  'GET /v1/admin/status': 'public',
  'GET /v1/merchant/status': 'public',
  'GET /v1/captain/status': 'public',
  'GET /v1/customer/status': 'public',
  'POST /v1/admin/auth/setup/totp': 'public',
  'POST /v1/admin/auth/setup/complete': 'public',
  'POST /v1/admin/auth/sign-in': 'public',
  'GET /v1/admin/auth/session': 'session',
  'POST /v1/admin/auth/sign-out': 'session',
  'GET /v1/admin/team/users': 'admin_team.manage',
  'POST /v1/admin/team/users': 'admin_team.manage',
  'PUT /v1/admin/team/users/{accountId}/roles': 'admin_team.manage',
  'POST /v1/admin/team/users/{accountId}/disable': 'admin_team.manage',
  'POST /v1/admin/team/users/{accountId}/enable': 'admin_team.manage',
  'POST /v1/admin/team/users/{accountId}/sign-out': 'admin_team.manage',
  'POST /v1/admin/team/users/{accountId}/totp-reset': 'admin_team.manage',
  'POST /v1/admin/team/users/{accountId}/setup-link': 'admin_team.manage',
  'GET /v1/admin/team/roles': 'admin_team.manage',
  'GET /v1/admin/settings': { editRoles: ['OWN', 'OPS', 'FIN'] },
  'PUT /v1/admin/settings/{key}': settingRoles,
  'POST /v1/admin/settings/{key}/reset': settingRoles,
  'GET /v1/admin/settings/{key}/history': settingRoles,
  'POST /v1/customer/auth/code': 'public',
  'POST /v1/customer/auth/sign-in': 'public',
  'POST /v1/customer/auth/refresh': 'public',
  'GET /v1/customer/auth/session': 'app_session',
  'POST /v1/customer/auth/sign-out': 'app_session',
  'POST /v1/customer/auth/sign-out-everywhere': 'app_session',
  'GET /v1/customer/location': 'public',
  'POST /v1/customer/zone-votes': 'public',
  'GET /v1/customer/restaurants': 'public',
  'GET /v1/customer/restaurants/{restaurantId}': 'public',
  'POST /v1/customer/quote': 'public',
  'POST /v1/customer/orders': 'app_session',
  'GET /v1/customer/orders/active': 'app_session',
  'GET /v1/customer/orders/{orderId}': 'app_session',
  'POST /v1/customer/realtime/token': 'app_session',
  'GET /v1/customer/profile': 'app_session',
  'PUT /v1/customer/profile': 'app_session',
  'GET /v1/customer/addresses': 'app_session',
  'POST /v1/customer/addresses': 'app_session',
  'PUT /v1/customer/addresses/{addressId}': 'app_session',
  'PUT /v1/customer/addresses/{addressId}/default': 'app_session',
  'DELETE /v1/customer/addresses/{addressId}': 'app_session',
  'POST /v1/merchant/auth/code': 'public',
  'POST /v1/merchant/auth/sign-in': 'public',
  'POST /v1/merchant/auth/refresh': 'public',
  'GET /v1/merchant/auth/session': 'app_session',
  'PUT /v1/merchant/auth/device': 'app_session',
  'POST /v1/merchant/auth/sign-out': 'app_session',
  'GET /v1/merchant/restaurant': 'app_session',
  'GET /v1/merchant/menu': 'app_session',
  'GET /v1/merchant/orders': 'app_session',
  'POST /v1/merchant/orders/{orderId}/accept': 'app_session',
  'POST /v1/merchant/orders/{orderId}/ready': 'app_session',
  'PUT /v1/merchant/menu/availability': 'app_session',
  'POST /v1/merchant/realtime/token': 'app_session',
  'POST /v1/captain/auth/code': 'public',
  'POST /v1/captain/auth/sign-in': 'public',
  'POST /v1/captain/auth/refresh': 'public',
  'GET /v1/captain/auth/session': 'app_session',
  'POST /v1/captain/auth/sign-out': 'app_session',
  'GET /v1/captain/availability': 'app_session',
  'POST /v1/captain/availability/online': 'app_session',
  'POST /v1/captain/availability/offline': 'app_session',
  'POST /v1/captain/location': 'app_session',
  'GET /v1/captain/offers/current': 'app_session',
  'POST /v1/captain/realtime/token': 'app_session',
  'POST /v1/captain/offers/{offerId}/accept': 'app_session',
  'POST /v1/captain/offers/{offerId}/decline': 'app_session',
  'POST /v1/admin/orders/{orderId}/assign': 'operations.manage',
  'GET /v1/admin/test-access/undeclared': 'undeclared',
  'GET /v1/admin/test-access/operations': 'operations.manage',
  'GET /v1/admin/test-access/finance': 'finance.manage',
};

// Each call is valid, so only its access can refuse it: an account that does
// not exist, and dispatch.mode set to its default, which changes nothing.
function routes(cityId: string = randomUUID()): {
  method: string;
  path: string;
  url: string;
  payload: object;
}[] {
  const document = createOpenApiDocument(app);
  return Object.entries(document.paths).flatMap(([path, item]) =>
    (['get', 'put', 'post', 'delete', 'patch'] as const).flatMap((method) =>
      item[method]
        ? [
            {
              method: method.toUpperCase(),
              path,
              url:
                path.replace('{accountId}', randomUUID()).replace('{key}', 'dispatch.mode') +
                (path.startsWith('/v1/admin/settings') && method === 'get'
                  ? `?cityId=${cityId}`
                  : ''),
              payload: path.startsWith('/v1/admin/settings')
                ? { cityId, ...(method === 'put' && { value: 'manual' }) }
                : {},
            },
          ]
        : [],
    ),
  );
}

describe('every route with every role (architecture §15.2, AP §14 item 2)', () => {
  it('declares its access in this test', () => {
    const found = routes().map((route) => `${route.method} ${route.path}`);
    expect(found.sort()).toEqual(Object.keys(routeAccess).sort());
    for (const route of found) {
      expect(ROUTE_GROUPS.some((group) => route.includes(`/v1/${group}/`))).toBe(true);
    }
  });

  it('answers 401 without a session, 403 without the permission, and lets the rest through', async () => {
    const callers = [null, ...adminRoles.map((role) => [role]), ['OPS', 'FIN']];
    const azaz: string = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0]
      .id;
    const outcomes: string[] = [];
    const expected: string[] = [];
    for (const roles of callers) {
      for (const route of routes(azaz)) {
        const access = routeAccess[`${route.method} ${route.path}`]!;
        // A fresh session per call, so a sign-out route ends only its own.
        const cookies = roles ? (await signedIn((await activeUser(roles)).accountId)).cookies : {};
        const response = await app.inject({
          method: route.method as 'GET',
          url: route.url,
          cookies,
          ...(route.method === 'GET' ? {} : { payload: route.payload }),
        });
        const permissions = (roles ?? []).flatMap(grantsOf);
        const want =
          access === 'public'
            ? 'through'
            : access === 'undeclared'
              ? '403'
              : !roles || access === 'app_session'
                ? '401'
                : typeof access === 'object'
                  ? roles.some((role) => access.editRoles.includes(role))
                    ? 'through'
                    : '403'
                  : access === 'session' || permissions.includes(access)
                    ? 'through'
                    : '403';
        const got =
          response.statusCode === 401 ? '401' : response.statusCode === 403 ? '403' : 'through';
        const caller = roles?.join('+') ?? 'nobody';
        outcomes.push(`${caller} ${route.method} ${route.path}: ${got}`);
        expected.push(`${caller} ${route.method} ${route.path}: ${want}`);
      }
    }
    expect(outcomes).toEqual(expected);
  }, 120_000);
});

describe('the admin team (AP §5.2–5.3, §9.15)', () => {
  it('creates a user with a setup link that sets the password and TOTP', async () => {
    const own = await owner();
    const email = newEmail();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/admin/team/users',
      cookies: own.cookies,
      payload: { name: 'Lina', email: email.toUpperCase(), roles: ['OPS', 'FIN'] },
    });
    expect(response.statusCode).toBe(201);
    const { accountId, setupToken } = response.json<{ accountId: string; setupToken: string }>();

    const now = new Date();
    const { secret } = await setup.startTotpEnrolment(setupToken, now);
    await setup.completeSetup(
      { token: setupToken, password, code: await totpCode(secret, now) },
      context,
      now,
    );
    const at = new Date(now.getTime() + 60_000);
    const { session } = await signIn.signIn(
      { login: email, password, code: await totpCode(secret, at) },
      context,
      at,
    );
    expect(session).toMatchObject({ accountId, roles: ['FIN', 'OPS'] });
    // Owner decision 2026-11-05: every role the actor held, sorted.
    expect(await auditEvents(accountId)).toEqual([
      { action: 'admin_account.create', actor_id: own.accountId, actor_role: 'OWN' },
      { action: 'admin_account.setup', actor_id: accountId, actor_role: 'FIN,OPS' },
    ]);

    const again = await app.inject({
      method: 'POST',
      url: '/v1/admin/team/users',
      cookies: own.cookies,
      payload: { name: 'Lina again', email, roles: ['SUP'] },
    });
    expect(again.statusCode).toBe(409);
    const noName = await app.inject({
      method: 'POST',
      url: '/v1/admin/team/users',
      cookies: own.cookies,
      payload: { name: 'Nobody', roles: ['SUP'] },
    });
    expect(noName.statusCode).toBe(400);
  });

  it('lists the users with their roles and open sessions', async () => {
    const own = await owner();
    const user = await activeUser(['SUP', 'DATA']);
    const { session } = await signedIn(user.accountId);
    const response = await app.inject({
      method: 'GET',
      url: '/v1/admin/team/users',
      cookies: own.cookies,
    });
    expect(response.statusCode).toBe(200);
    const listed = response
      .json<{ users: { id: string }[] }>()
      .users.find((row) => row.id === user.accountId);
    expect(listed).toMatchObject({
      email: user.email,
      roles: ['DATA', 'SUP'],
      status: 'active',
      totpEnrolled: true,
      lastSignInAt: session.signedInAt.toISOString(),
      openSessions: [{ id: session.id, ipAddress: context.ipAddress, userAgent: context.device }],
    });
  });

  it('changes roles, which apply at the next request', async () => {
    const own = await owner();
    const user = await activeUser(['SUP']);
    const { token } = await signedIn(user.accountId);
    await team.changeRoles(user.accountId, ['FIN', 'OPS'], own.session, context);
    expect(await sessions.authenticate(token)).toMatchObject({ roles: ['FIN', 'OPS'] });
    const { rows } = await sql.query(
      `SELECT role_code, revoked_at IS NOT NULL AS revoked FROM identity.admin_account_roles
        WHERE account_id = $1 ORDER BY role_code`,
      [user.accountId],
    );
    expect(rows).toEqual([
      { role_code: 'FIN', revoked: false },
      { role_code: 'OPS', revoked: false },
      { role_code: 'SUP', revoked: true },
    ]);
    const events = await sql.query(
      `SELECT changes FROM audit.events WHERE target_id = $1 AND action = 'admin_account.roles_change'`,
      [user.accountId],
    );
    expect(events.rows).toEqual([
      { changes: { roles: { before: ['SUP'], after: ['FIN', 'OPS'] } } },
    ]);
  });

  it('disables a user, ending their sessions at once, and enables them again', async () => {
    const own = await owner();
    const user = await activeUser(['OPS']);
    const { token } = await signedIn(user.accountId);
    const response = await app.inject({
      method: 'POST',
      url: `/v1/admin/team/users/${user.accountId}/disable`,
      cookies: own.cookies,
    });
    expect(response.statusCode).toBe(200);
    expect(await sessions.authenticate(token)).toBeNull();
    const ended = await sql.query(
      'SELECT end_reason FROM identity.admin_sessions WHERE account_id = $1',
      [user.accountId],
    );
    expect(ended.rows).toEqual([{ end_reason: 'account_disabled' }]);
    const at = new Date();
    await expect(
      signIn.signIn(
        { login: user.email, password, code: await totpCode(user.secret, at) },
        context,
        at,
      ),
    ).rejects.toMatchObject({ refusal: 'invalid' });

    await team.enable(user.accountId, own.session, context);
    const later = new Date(at.getTime() + 60_000);
    await expect(
      signIn.signIn(
        { login: user.email, password, code: await totpCode(user.secret, later) },
        context,
        later,
      ),
    ).resolves.toMatchObject({ session: { accountId: user.accountId } });
    expect((await auditEvents(user.accountId)).map((event) => event.action)).toEqual([
      'admin_account.disable',
      'admin_account.enable',
    ]);
  });

  it('forces a user out of every session', async () => {
    const own = await owner();
    const user = await activeUser(['FIN']);
    const first = await signedIn(user.accountId);
    const second = await signedIn(user.accountId);
    const response = await app.inject({
      method: 'POST',
      url: `/v1/admin/team/users/${user.accountId}/sign-out`,
      cookies: own.cookies,
    });
    expect(response.statusCode).toBe(200);
    expect(await sessions.authenticate(first.token)).toBeNull();
    expect(await sessions.authenticate(second.token)).toBeNull();
    const events = await sql.query(
      `SELECT changes FROM audit.events WHERE target_id = $1 AND action = 'admin_account.force_sign_out'`,
      [user.accountId],
    );
    expect(events.rows).toEqual([{ changes: { sessionsEnded: { before: null, after: 2 } } }]);
  });

  it('resets TOTP: the old codes stop, and the user enrols again with their password', async () => {
    const own = await owner();
    const user = await activeUser(['OPS']);
    const { token } = await signedIn(user.accountId);
    const response = await app.inject({
      method: 'POST',
      url: `/v1/admin/team/users/${user.accountId}/totp-reset`,
      cookies: own.cookies,
    });
    expect(response.statusCode).toBe(200);
    const { setupToken } = response.json<{ setupToken: string }>();
    expect(await sessions.authenticate(token)).toBeNull();

    const now = new Date();
    await expect(
      signIn.signIn(
        { login: user.email, password, code: await totpCode(user.secret, now) },
        context,
        now,
      ),
    ).rejects.toMatchObject({ refusal: 'invalid' });

    const { secret } = await setup.startTotpEnrolment(setupToken, now);
    const code = await totpCode(secret, now);
    await expect(
      setup.completeSetup({ token: setupToken, password: 'wrong password!', code }, context, now),
    ).rejects.toMatchObject({ refusal: 'password_invalid' });
    const failures = await sql.query(
      'SELECT failed_attempts FROM identity.admin_accounts WHERE id = $1',
      [user.accountId],
    );
    expect(failures.rows).toEqual([{ failed_attempts: 1 }]);

    const backupCodes = await setup.completeSetup(
      { token: setupToken, password, code },
      context,
      now,
    );
    expect(backupCodes).toHaveLength(10);
    const at = new Date(now.getTime() + 60_000);
    await expect(
      signIn.signIn({ login: user.email, password, code: await totpCode(secret, at) }, context, at),
    ).resolves.toMatchObject({ session: { accountId: user.accountId } });
    expect((await auditEvents(user.accountId)).map((event) => event.action)).toEqual([
      'admin_account.totp_reset',
      'admin_account.totp_enrol',
    ]);
  });

  it('revokes the unused backup codes at a TOTP reset', async () => {
    const own = await owner();
    const user = await activeUser(['OPS']);
    const now = new Date();
    // A real setup, so the account has backup codes.
    const { setupToken } = await team.resetTotp(user.accountId, own.session, context, now);
    const { secret } = await setup.startTotpEnrolment(setupToken, now);
    const [backupCode] = await setup.completeSetup(
      { token: setupToken, password, code: await totpCode(secret, now) },
      context,
      now,
    );
    await team.resetTotp(user.accountId, own.session, context, now);
    await expect(
      signIn.signIn({ login: user.email, password, code: backupCode! }, context, now),
    ).rejects.toMatchObject({ refusal: 'invalid' });
    const { rows } = await sql.query(
      `SELECT count(*)::int AS revoked FROM identity.admin_backup_codes
        WHERE account_id = $1 AND revoked_at IS NOT NULL`,
      [user.accountId],
    );
    expect(rows).toEqual([{ revoked: 10 }]);
  });

  // Owner decision 2026-11-05: the platform never has no active OWN.
  it('never leaves the platform without an active OWN, nor lets a user disable themselves', async () => {
    // Every other active OWN out of the way first, so this one is the last.
    await sql.query(
      `UPDATE identity.admin_accounts SET status = 'disabled'
        WHERE status = 'active' AND id IN (SELECT account_id FROM identity.admin_account_roles WHERE role_code = 'OWN')`,
    );
    const own = await owner();
    const self = (refusal: string) => expect.objectContaining({ refusal });
    await expect(team.disable(own.accountId, own.session, context)).rejects.toEqual(
      self('own_account'),
    );
    await expect(team.changeRoles(own.accountId, ['OPS'], own.session, context)).rejects.toEqual(
      self('last_owner'),
    );
    await expect(team.resetTotp(own.accountId, own.session, context)).rejects.toEqual(
      self('last_owner'),
    );

    const second = await owner();
    await team.changeRoles(own.accountId, ['OPS', 'OWN'], own.session, context);
    await team.disable(own.accountId, second.session, context);
    await expect(team.disable(second.accountId, second.session, context)).rejects.toEqual(
      self('own_account'),
    );
    const response = await app.inject({
      method: 'PUT',
      url: `/v1/admin/team/users/${second.accountId}/roles`,
      cookies: second.cookies,
      payload: { roles: ['FIN'] },
    });
    expect(response.statusCode).toBe(409);
    expect(response.json()).toMatchObject({ error: 'last_owner' });
  });

  it('answers 404 for an account that does not exist', async () => {
    const own = await owner();
    const response = await app.inject({
      method: 'POST',
      url: `/v1/admin/team/users/${randomUUID()}/sign-out`,
      cookies: own.cookies,
    });
    expect(response.statusCode).toBe(404);
  });

  it('lets only one of two OWNs disabling each other at once succeed', async () => {
    await sql.query(
      `UPDATE identity.admin_accounts SET status = 'disabled'
        WHERE status = 'active' AND id IN (SELECT account_id FROM identity.admin_account_roles WHERE role_code = 'OWN')`,
    );
    const first = await owner();
    const second = await owner();
    const results = await Promise.allSettled([
      team.disable(second.accountId, first.session, context),
      team.disable(first.accountId, second.session, context),
    ]);
    expect(results.filter((result) => result.status === 'fulfilled')).toHaveLength(1);
    const [refused] = results.filter((result) => result.status === 'rejected');
    // The loser is either the last OWN or no longer allowed to act.
    expect(['last_owner', 'actor_not_allowed']).toContain(
      (refused!.reason as { refusal: string }).refusal,
    );
    const { rows } = await sql.query(
      `SELECT count(*)::int AS owners FROM identity.admin_accounts a
         JOIN identity.admin_account_roles r ON r.account_id = a.id AND r.revoked_at IS NULL
        WHERE r.role_code = 'OWN' AND a.status = 'active'`,
    );
    expect(rows).toEqual([{ owners: 1 }]);
  });

  it('refuses an actor who lost admin_team.manage after the guard let them in', async () => {
    const own = await owner();
    const other = await owner();
    await team.changeRoles(own.accountId, ['OPS'], other.session, context);
    const user = await activeUser(['SUP']);
    await expect(team.forceSignOut(user.accountId, own.session, context)).rejects.toMatchObject({
      refusal: 'actor_not_allowed',
    });
  });

  it('reissues the setup link of a pending user, and a disable ends the open links', async () => {
    const own = await owner();
    const created = await team.create(
      { name: 'Sami', email: newEmail(), phone: '+963944000123', roles: ['DATA'] },
      own.session,
      context,
    );
    const reissued = await app.inject({
      method: 'POST',
      url: `/v1/admin/team/users/${created.accountId}/setup-link`,
      cookies: own.cookies,
    });
    expect(reissued.statusCode).toBe(200);
    const { setupToken } = reissued.json<{ setupToken: string }>();
    await expect(setup.startTotpEnrolment(created.setupToken)).rejects.toMatchObject({
      refusal: 'link_invalid',
    });

    await team.disable(created.accountId, own.session, context);
    await team.enable(created.accountId, own.session, context);
    const { rows } = await sql.query(
      'SELECT status, phone_encrypted FROM identity.admin_accounts WHERE id = $1',
      [created.accountId],
    );
    expect(rows[0].status).toBe('pending');
    expect(rows[0].phone_encrypted).not.toContain('944000123');
    await expect(setup.startTotpEnrolment(setupToken)).rejects.toMatchObject({
      refusal: 'link_invalid',
    });

    // The tokens are only in the answers, never stored or audited in clear.
    const stored = await sql.query(
      `SELECT (SELECT json_agg(l) FROM identity.admin_setup_links l WHERE l.account_id = $1)::text AS links,
              (SELECT json_agg(e) FROM audit.events e WHERE e.target_id = $1::text)::text AS events`,
      [created.accountId],
    );
    for (const token of [created.setupToken, setupToken]) {
      expect(stored.rows[0].links).not.toContain(token);
      expect(stored.rows[0].events).not.toContain(token);
    }
    expect(stored.rows[0].events).not.toContain('944000123');
    expect((await auditEvents(created.accountId)).map((event) => event.action)).toEqual([
      'admin_account.create',
      'admin_account.setup_link_reissue',
      'admin_account.disable',
      'admin_account.enable',
    ]);

    const active = await activeUser(['OPS']);
    await expect(
      team.reissueSetupLink(active.accountId, own.session, context),
    ).rejects.toMatchObject({ refusal: 'wrong_status' });
  });

  it('enables a disabled user back to the TOTP enrolment it was waiting for', async () => {
    const own = await owner();
    const user = await activeUser(['FIN']);
    await team.resetTotp(user.accountId, own.session, context);
    await team.disable(user.accountId, own.session, context);
    await team.enable(user.accountId, own.session, context);
    const { rows } = await sql.query('SELECT status FROM identity.admin_accounts WHERE id = $1', [
      user.accountId,
    ]);
    expect(rows).toEqual([{ status: 'totp_reset' }]);
  });

  it('locks the account after admin.login_max_attempts wrong passwords at a TOTP re-enrolment', async () => {
    const own = await owner();
    const user = await activeUser(['OPS']);
    const now = new Date();
    const { setupToken } = await team.resetTotp(user.accountId, own.session, context, now);
    const { secret } = await setup.startTotpEnrolment(setupToken, now);
    const code = await totpCode(secret, now);
    const wrong = { token: setupToken, password: 'wrong password!', code };
    for (const refusal of [
      'password_invalid',
      'password_invalid',
      'password_invalid',
      'password_invalid',
      'account_locked',
    ]) {
      await expect(setup.completeSetup(wrong, context, now)).rejects.toMatchObject({ refusal });
    }
    // Locked: the right password is refused too until the lockout ends.
    await expect(
      setup.completeSetup({ token: setupToken, password, code }, context, now),
    ).rejects.toMatchObject({ refusal: 'account_locked' });
    expect((await auditEvents(user.accountId)).map((event) => event.action)).toContain(
      'admin_account.lock',
    );
  });

  it('takes a setup link only for a pending account and a reset link only after a reset', async () => {
    const own = await owner();
    const created = await team.create(
      { name: 'Rami', email: newEmail(), phone: null, roles: ['SUP'] },
      own.session,
      context,
    );
    // A pending account's link cannot serve once its status no longer fits.
    await sql.query(
      `UPDATE identity.admin_setup_links SET purpose = 'totp_reset' WHERE account_id = $1`,
      [created.accountId],
    );
    await expect(setup.startTotpEnrolment(created.setupToken)).rejects.toMatchObject({
      refusal: 'link_invalid',
    });

    const user = await activeUser(['OPS']);
    const { setupToken } = await team.resetTotp(user.accountId, own.session, context);
    await sql.query(
      `UPDATE identity.admin_setup_links SET purpose = 'setup' WHERE account_id = $1`,
      [user.accountId],
    );
    await expect(setup.startTotpEnrolment(setupToken)).rejects.toMatchObject({
      refusal: 'link_invalid',
    });
  });
});
