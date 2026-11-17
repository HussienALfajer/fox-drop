import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, ne, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { APP_PHONE_PATTERN } from './app-phone.js';
import { AppSessionsService } from './app-sessions.service.js';
import { customerAccounts } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets } from './secrets.js';

export type CustomerAccountRefusal = 'unknown_customer' | 'invalid_phone' | 'phone_taken';

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
  // every account the number has had (a closed account's included, §8.8), so
  // a new-user code works once per number; null for an unknown account.
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
    return { phoneHash: row.phoneHash, accountIds: accounts.map((account) => account.id) };
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

  // AP §9.8 «تغيير الرقم» (OWN, OPS, on the customer's request; CU §5.4): the
  // new Syrian or Turkish mobile, which no other open account has; every
  // session of the account ends («phone_changed») and the customer signs in
  // again with the new number and a code. Active orders are untouched. The
  // account's own number again changes nothing, so a repeat needs no key. Under
  // both numbers' code lock (`identity.app_code:<hash>`, the lock a code
  // request takes), and the open accounts' unique index catches a sign-in
  // that created an account on the new number meanwhile. Audited without
  // either number.
  async changePhone(
    admin: CustomerAccountAdmin,
    change: { accountId: string; phone: string },
    now: Date,
  ): Promise<void> {
    if (!APP_PHONE_PATTERN.test(change.phone)) {
      throw new CustomerAccountRefusedError('invalid_phone', 'not a Syrian or Turkish mobile');
    }
    const toHash = this.secrets.phoneHash(change.phone);
    let ended: string[] = [];
    try {
      ended = await this.database.db.transaction(async (tx) => {
        const [account] = await tx
          .select({ phoneHash: customerAccounts.phoneHash, status: customerAccounts.status })
          .from(customerAccounts)
          .where(eq(customerAccounts.id, change.accountId));
        if (!account) {
          throw new CustomerAccountRefusedError('unknown_customer', 'no such customer');
        }
        for (const hash of [account.phoneHash, toHash].toSorted()) {
          await tx.execute(
            sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.app_code:${hash}`}, 0))`,
          );
        }
        // Already the account's number: a repeat changes nothing.
        if (account.phoneHash === toHash) return [];
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
