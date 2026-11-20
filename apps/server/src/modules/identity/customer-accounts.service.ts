import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, isNull, ne, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { APP_PHONE_PATTERN } from './app-phone.js';
import { AppSessionsService } from './app-sessions.service.js';
import { AppSignInService, type CustomerRelinked } from './app-sign-in.service.js';
import { appSessions, appSignInCodes, customerAccounts } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets } from './secrets.js';

export type CustomerAccountRefusal =
  'unknown_customer' | 'invalid_phone' | 'phone_taken' | 'account_closed';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type Reader = Pick<NodePgDatabase, 'select'>;

// A customer account's state (CU §5.5, D19): the panel's search and profile.
export interface CustomerAccountState {
  id: string;
  status: 'active' | 'closed';
  createdAt: Date;
  closedAt: Date | null;
  // The admin who closed it; null when the customer did from the app.
  closedBy: string | null;
  closeReason: string | null;
}

// One account's sign-ins on one device (slice 2.25d): the first and latest
// sign-in, when the device was last seen (a refresh or an end), and the IP
// address and user agent of the latest sign-in.
export interface CustomerDeviceSighting {
  deviceId: string;
  accountId: string;
  firstSignedInAt: Date;
  lastSignedInAt: Date;
  lastSeenAt: Date;
  ipAddress: string | null;
  userAgent: string | null;
}

export class CustomerAccountRefusedError extends Error {
  override readonly name = 'CustomerAccountRefusedError';
  constructor(
    readonly refusal: CustomerAccountRefusal,
    message: string,
  ) {
    super(message);
  }
}

// An admin's command on a customer account (AP §9.8), with the reason the
// audit keeps.
export interface CustomerAccountAdmin {
  actor: AuditActor;
  context: AuditRequestContext;
  cityId: string;
  reason: string;
}

// The customers' accounts as other modules need them.
@Injectable()
export class CustomerAccountsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly sessions: AppSessionsService,
    private readonly audit: AuditService,
    private readonly signIn: AppSignInService,
  ) {}

  // AP §9.10.7 (slice 2.20c): the customer a number belongs to, for the
  // panel's search of «القيود التصحيحية»; null when none. Found by its keyed
  // hash, so the number is never read back.
  async customerByPhone(phone: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ id: customerAccounts.id })
      .from(customerAccounts)
      .where(eq(customerAccounts.phoneHash, this.secrets.phoneHash(phone)))
      .orderBy(desc(customerAccounts.createdAt))
      .limit(1);
    return row?.id ?? null;
  }

  // AP §9.11.1 (slice 2.21b): the keyed hash of the account's number and
  // every account the number has had (a closed account's included, §8.8)
  // with the account's line (slice 2.25c, which a number change keeps), so
  // a new-user code works once per number and per person; null for an
  // unknown account.
  async phoneAccounts(
    accountId: string,
  ): Promise<{ phoneHash: string; accountIds: string[] } | null> {
    const [row] = await this.database.db
      .select({ phoneHash: customerAccounts.phoneHash })
      .from(customerAccounts)
      .where(eq(customerAccounts.id, accountId));
    if (!row) return null;
    const accounts = await this.database.db
      .select({ id: customerAccounts.id })
      .from(customerAccounts)
      .where(eq(customerAccounts.phoneHash, row.phoneHash));
    const ids = new Set([
      ...accounts.map((account) => account.id),
      ...(await this.lineage(accountId)),
    ]);
    return { phoneHash: row.phoneHash, accountIds: [...ids] };
  }

  // Whether the account exists, whatever its state.
  async exists(accountId: string): Promise<boolean> {
    const [row] = await this.database.db
      .select({ id: customerAccounts.id })
      .from(customerAccounts)
      .where(eq(customerAccounts.id, accountId));
    return row !== undefined;
  }

  // The account's own number (CA §9.5: the captain's «اتصال بالزبون» opens
  // the dialer with it, unless the order is for someone else), or null for
  // an unknown account.
  async phone(accountId: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ phoneEncrypted: customerAccounts.phoneEncrypted })
      .from(customerAccounts)
      .where(eq(customerAccounts.id, accountId));
    return row ? this.secrets.decrypt(row.phoneEncrypted) : null;
  }

  // AP §8.8 (slice 2.25c): every account of the account's line, itself
  // included: the closed accounts it continues and the account that
  // continues it. A block, dues, strikes, trust and codes of any of them
  // count for the line. Unknown, it is the account alone.
  async lineage(accountId: string, executor: Reader = this.database.db): Promise<string[]> {
    const [row] = await executor
      .select({ id: customerAccounts.id, lineageId: customerAccounts.lineageId })
      .from(customerAccounts)
      .where(eq(customerAccounts.id, accountId));
    if (!row) return [accountId];
    const root = row.lineageId ?? row.id;
    const rows = await executor
      .select({ id: customerAccounts.id })
      .from(customerAccounts)
      .where(or(eq(customerAccounts.id, root), eq(customerAccounts.lineageId, root)));
    return rows.map((each) => each.id);
  }

  // The device block (docs/domain/08; slice 2.25d): every customer account
  // signed in on a device any of the accounts used, per device and account,
  // from the sessions (kept after they end). The device is the app's
  // `deviceId`, which the customer app keeps across a reinstall.
  async deviceSightings(
    accountIds: readonly string[],
    executor: Pick<NodePgDatabase, 'select' | 'selectDistinct'> = this.database.db,
  ): Promise<CustomerDeviceSighting[]> {
    if (accountIds.length === 0) return [];
    const devices = executor
      .selectDistinct({ deviceId: appSessions.deviceId })
      .from(appSessions)
      .where(
        and(eq(appSessions.party, 'customer'), inArray(appSessions.accountId, [...accountIds])),
      );
    const rows = await executor
      .select({
        deviceId: appSessions.deviceId,
        accountId: appSessions.accountId,
        firstSignedInAt: sql<Date>`min(${appSessions.signedInAt})`.mapWith(appSessions.signedInAt),
        lastSignedInAt: sql<Date>`max(${appSessions.signedInAt})`.mapWith(appSessions.signedInAt),
        lastSeenAt:
          sql<Date>`max(coalesce(${appSessions.endedAt}, ${appSessions.lastRefreshedAt}))`.mapWith(
            appSessions.signedInAt,
          ),
        ipAddress: sql<
          string | null
        >`(array_agg(host(${appSessions.ipAddress}) ORDER BY ${appSessions.signedInAt} DESC))[1]`,
        userAgent: sql<
          string | null
        >`(array_agg(${appSessions.userAgent} ORDER BY ${appSessions.signedInAt} DESC))[1]`,
      })
      .from(appSessions)
      .where(and(eq(appSessions.party, 'customer'), inArray(appSessions.deviceId, devices)))
      .groupBy(appSessions.deviceId, appSessions.accountId)
      .orderBy(sql`min(${appSessions.signedInAt})`, appSessions.deviceId, appSessions.accountId);
    return rows;
  }

  // D19: whether the account exists and is not closed.
  async isOpen(accountId: string, executor: Reader = this.database.db): Promise<boolean> {
    const [row] = await executor
      .select({ status: customerAccounts.status })
      .from(customerAccounts)
      .where(eq(customerAccounts.id, accountId));
    return row?.status === 'active';
  }

  // AP §9.11.4 (slice 2.27d): every customer account with its line (the
  // first account it continues, or itself) and whether it is open, for the
  // mass push's audiences, which read a line's deliveries as the
  // account's (AP §8.8).
  async lines(): Promise<{ id: string; line: string; open: boolean }[]> {
    const rows = await this.database.db
      .select({
        id: customerAccounts.id,
        line: sql<string>`coalesce(${customerAccounts.lineageId}, ${customerAccounts.id})`,
        status: customerAccounts.status,
      })
      .from(customerAccounts);
    return rows.map((row) => ({ id: row.id, line: row.line, open: row.status === 'active' }));
  }

  // D19, CU §5.5: the accounts' states, for the panel; an unknown id is left
  // out.
  async states(accountIds: readonly string[]): Promise<Map<string, CustomerAccountState>> {
    if (accountIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({
        id: customerAccounts.id,
        status: customerAccounts.status,
        createdAt: customerAccounts.createdAt,
        closedAt: customerAccounts.closedAt,
        closedBy: customerAccounts.closedBy,
        closeReason: customerAccounts.closeReason,
      })
      .from(customerAccounts)
      .where(inArray(customerAccounts.id, [...accountIds]));
    return new Map(rows.map((row) => [row.id, row]));
  }

  // AP §9.1.2 «New customers» (slice 2.40): the accounts registered in
  // [from, to), an account continuing a closed one on the same number (a
  // lineage) left out. Accounts have no city: every city's.
  async newCustomersBetween(from: Date, to: Date): Promise<number> {
    const [row] = await this.database.db
      .select({ count: sql<number>`count(*)::int` })
      .from(customerAccounts)
      .where(
        and(
          isNull(customerAccounts.lineageId),
          sql`${customerAccounts.createdAt} >= ${from.toISOString()}`,
          sql`${customerAccounts.createdAt} < ${to.toISOString()}`,
        ),
      );
    return Number(row?.count ?? 0);
  }

  // AP §9.8 (slice 2.25c): every account a number has had, newest first, so
  // the panel's search by number shows a closed account beside its new one.
  async customersByPhone(phone: string): Promise<string[]> {
    const rows = await this.database.db
      .select({ id: customerAccounts.id })
      .from(customerAccounts)
      .where(eq(customerAccounts.phoneHash, this.secrets.phoneHash(phone)))
      .orderBy(desc(customerAccounts.createdAt));
    return rows.map((row) => row.id);
  }

  // Registered by the customers module at start: moves a closed account's
  // dues to the account that continues it, in the sign-in's transaction.
  onRelinked(listener: CustomerRelinked): void {
    this.signIn.onCustomerRelinked(listener);
  }

  // D19, CU §5.6, AP §9.8 «إغلاق الحساب» (slice 2.25c): in the caller's
  // transaction (customers', under the customer's ordering lock, after it
  // checked for an active order), the account becomes «مغلق» and every
  // session ends with `account_closed`; the data stays. The caller passes
  // the ended sessions to `AppSessionsService.notifyEnded` after its commit
  // (`notifyEnded` here). `admin` is null when the customer closed it from
  // the app. Audited `customer_account.close`.
  async close(
    tx: Tx,
    closure: {
      accountId: string;
      admin: CustomerAccountAdmin | null;
      context: AuditRequestContext;
      cityId: string | null;
    },
    now: Date,
  ): Promise<string[]> {
    const [account] = await tx
      .select({ status: customerAccounts.status })
      .from(customerAccounts)
      .where(eq(customerAccounts.id, closure.accountId))
      .for('update');
    if (!account) throw new CustomerAccountRefusedError('unknown_customer', 'no such customer');
    if (account.status === 'closed') {
      throw new CustomerAccountRefusedError('account_closed', 'the account is closed already');
    }
    await tx
      .update(customerAccounts)
      .set({
        status: 'closed',
        closedAt: now,
        closedBy: closure.admin?.actor.id ?? null,
        closeReason: closure.admin?.reason ?? null,
        updatedAt: now,
      })
      .where(eq(customerAccounts.id, closure.accountId));
    const sessions = await this.sessions.endAll(
      tx,
      'customer',
      closure.accountId,
      'account_closed',
      now,
    );
    await this.audit.recordWrite(
      {
        actor: closure.admin?.actor ?? { type: 'customer', id: closure.accountId, role: null },
        context: closure.admin?.context ?? closure.context,
        cityId: closure.admin?.cityId ?? closure.cityId,
        action: 'customer_account.close',
        target: { type: 'customer_account', id: closure.accountId },
        reason: closure.admin?.reason ?? null,
        before: { status: 'active' },
        after: { status: 'closed', sessionsEnded: sessions.length },
      },
      tx,
    );
    return sessions;
  }

  notifyEnded(sessionIds: string[]): void {
    this.sessions.notifyEnded(sessionIds);
  }

  // CU §5.6 (Q20): a fresh code to the account's own number before «حذف
  // الحساب», through the sign-in's code request with its limits and App
  // Check; refused as any code request (`CodeRequestRefusedError`).
  async sendCloseCode(
    accountId: string,
    request: { deviceId: string; appCheckToken: string | undefined },
    context: AuditRequestContext,
    now: Date,
  ): Promise<{ channel: 'whatsapp'; resendAfterSec: number; expiresAt: Date }> {
    const phone = await this.phone(accountId);
    if (phone === null)
      throw new CustomerAccountRefusedError('unknown_customer', 'no such customer');
    return this.signIn.requestCode({ party: 'customer', phone, ...request }, context, now);
  }

  // CU §5.6: uses the code up when right (`SignInCodeRefusedError`
  // otherwise, a wrong attempt counted), before the closure's transaction.
  async useCloseCode(
    accountId: string,
    request: { deviceId: string; code: string },
    now: Date,
  ): Promise<void> {
    const phone = await this.phone(accountId);
    if (phone === null)
      throw new CustomerAccountRefusedError('unknown_customer', 'no such customer');
    await this.signIn.useCode({ party: 'customer', phone, ...request }, now);
  }

  // AP §9.8 «تغيير الرقم» (OWN, OPS, on the customer's request; CU §5.4): the
  // new Syrian or Turkish mobile, which no other open account has; every
  // session of the account ends («phone_changed») and the customer signs in
  // again with the new number and a code. Active orders are untouched. The
  // account's own number again changes nothing, so a repeat needs no key.
  // Under both numbers' code-request lock (`identity.app_code:<hash>`); the
  // old number's open code is locked and ended, so a sign-in on it either
  // committed first (its session ends here) or finds no code; the open
  // accounts' unique index catches a sign-in that created an account on the
  // new number meanwhile. Audited without either number.
  async changePhone(
    admin: CustomerAccountAdmin,
    change: { accountId: string; phone: string },
    now: Date,
  ): Promise<void> {
    if (!APP_PHONE_PATTERN.test(change.phone)) {
      throw new CustomerAccountRefusedError('invalid_phone', 'not a Syrian or Turkish mobile');
    }
    const toHash = this.secrets.phoneHash(change.phone);
    let ended: string[];
    try {
      ended = await this.database.db.transaction(async (tx) => {
        const [account] = await tx
          .select({ phoneHash: customerAccounts.phoneHash, status: customerAccounts.status })
          .from(customerAccounts)
          .where(eq(customerAccounts.id, change.accountId));
        if (!account) {
          throw new CustomerAccountRefusedError('unknown_customer', 'no such customer');
        }
        if (account.status === 'closed') {
          throw new CustomerAccountRefusedError('account_closed', 'the account is closed');
        }
        for (const hash of [account.phoneHash, toHash].toSorted()) {
          await tx.execute(
            sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.app_code:${hash}`}, 0))`,
          );
        }
        // Already the account's number: a repeat changes nothing.
        if (account.phoneHash === toHash) return [];
        // A sign-in on the old number locks its open code: wait for one in
        // progress (its session then ends below), and end the code, so a
        // later one finds none.
        const open = await tx
          .select({ id: appSignInCodes.id })
          .from(appSignInCodes)
          .where(
            and(
              eq(appSignInCodes.party, 'customer'),
              eq(appSignInCodes.phoneHash, account.phoneHash),
              isNull(appSignInCodes.endedAt),
            ),
          )
          .for('update');
        if (open.length > 0) {
          await tx
            .update(appSignInCodes)
            .set({ endedAt: now, endReason: 'replaced' })
            .where(
              inArray(
                appSignInCodes.id,
                open.map((code) => code.id),
              ),
            );
        }
        const [taken] = await tx
          .select({ id: customerAccounts.id })
          .from(customerAccounts)
          .where(
            and(
              eq(customerAccounts.phoneHash, toHash),
              eq(customerAccounts.status, 'active'),
              ne(customerAccounts.id, change.accountId),
            ),
          );
        if (taken) {
          throw new CustomerAccountRefusedError('phone_taken', 'another account has that number');
        }
        await tx
          .update(customerAccounts)
          .set({
            phoneEncrypted: this.secrets.encrypt(change.phone),
            phoneHash: toHash,
            updatedAt: now,
          })
          .where(eq(customerAccounts.id, change.accountId));
        const sessions = await this.sessions.endAll(
          tx,
          'customer',
          change.accountId,
          'phone_changed',
          now,
        );
        await this.audit.recordWrite(
          {
            actor: admin.actor,
            context: admin.context,
            cityId: admin.cityId,
            action: 'customer_account.phone_change',
            target: { type: 'customer_account', id: change.accountId },
            reason: admin.reason,
            before: null,
            after: { phone: 'changed', sessionsEnded: sessions.length },
          },
          tx,
        );
        return sessions;
      });
    } catch (error) {
      // A sign-in created an account on the new number meanwhile.
      if (violated(error) === 'customer_accounts_active_phone') {
        throw new CustomerAccountRefusedError('phone_taken', 'another account has that number');
      }
      throw error;
    }
    this.sessions.notifyEnded(ended);
  }

  // AP §9.8 «تسجيل الخروج من كل الأجهزة» (OWN, OPS, SUP; after a lost or sold
  // phone): every session of the account ends, as the customer's own button
  // does (CU §5.4); active orders are untouched. Answers how many ended.
  async signOutEverywhere(
    admin: CustomerAccountAdmin,
    accountId: string,
    now: Date,
  ): Promise<number> {
    if (!(await this.exists(accountId))) {
      throw new CustomerAccountRefusedError('unknown_customer', 'no such customer');
    }
    const ended = await this.database.db.transaction(async (tx) => {
      const sessions = await this.sessions.endAll(
        tx,
        'customer',
        accountId,
        'sign_out_everywhere',
        now,
      );
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: admin.cityId,
          action: 'customer_account.sign_out_everywhere',
          target: { type: 'customer_account', id: accountId },
          reason: admin.reason,
          before: null,
          after: { sessionsEnded: sessions.length },
        },
        tx,
      );
      return sessions;
    });
    this.sessions.notifyEnded(ended);
    return ended.length;
  }
}

// The constraint a write broke, whether the driver's error comes bare or
// wrapped by Drizzle.
function violated(error: unknown): string | undefined {
  const found = error as { constraint?: string; cause?: { constraint?: string } } | null;
  return found?.constraint ?? found?.cause?.constraint;
}
