import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, asc, eq, inArray, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { type AccountStatus, MerchantsService } from '../merchants/index.js';
import { APP_PHONE_PATTERN } from './app-phone.js';
import { appSessions, merchantAccounts, merchantRoles } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets } from './secrets.js';

export type MerchantRole = (typeof merchantRoles)[number];

// Why a restaurant user cannot sign in (RA §5.2 items 3–4, §5.5): the number
// belongs to no restaurant, the restaurant is still a draft, or a cashier's
// restaurant was terminated.
export type MerchantSignInRefusal = 'not_registered' | 'restaurant_draft' | 'restaurant_terminated';

export class MerchantSignInRefusedError extends Error {
  constructor(readonly refusal: MerchantSignInRefusal) {
    super(`restaurant sign-in refused: ${refusal}`);
  }
}

export class MerchantAccountRefusedError extends Error {
  constructor(
    readonly refusal:
      | 'unknown_restaurant'
      | 'phone_taken'
      | 'invalid_account'
      | 'unknown_account'
      | 'restaurant_terminated'
      | 'last_owner'
      // RA §5.1, S5 (slice 2.33): an owner removes cashiers only.
      | 'not_a_cashier',
    message: string,
  ) {
    super(message);
  }
}

export interface MerchantAccount {
  id: string;
  restaurantId: string;
  role: MerchantRole;
  name: string;
}

// RA §5.5: who may sign in, by the restaurant's account status. A suspended
// restaurant still signs in (its banner shows the reason); a terminated one
// lets only its owners in, to the money section.
export function merchantSignInRefusal(
  role: MerchantRole,
  status: AccountStatus,
): MerchantSignInRefusal | null {
  if (status === 'draft') return 'restaurant_draft';
  if (status === 'terminated' && role === 'cashier') return 'restaurant_terminated';
  return null;
}

type Executor = Pick<Database['db'], 'select'>;

// A restaurant's owners and cashiers (RA §5.1).
@Injectable()
export class MerchantAccountsService implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
  ) {}

  // AP §9.6.3 step 8 (slice 2.30b): the activation checklist counts the
  // restaurant's owner accounts, which merchants cannot read.
  onModuleInit(): void {
    this.merchants.countOwnerAccounts((restaurantId) => this.ownerCount(restaurantId));
  }

  // The restaurant's owner accounts not removed.
  async ownerCount(restaurantId: string): Promise<number> {
    const [row] = await this.database.db
      .select({ count: sql<number>`count(*)::int` })
      .from(merchantAccounts)
      .where(
        and(
          eq(merchantAccounts.restaurantId, restaurantId),
          eq(merchantAccounts.role, 'owner'),
          isNull(merchantAccounts.removedAt),
        ),
      );
    return row?.count ?? 0;
  }

  // An owner or a cashier of a restaurant. A number belongs to at most one
  // restaurant (S6): one taken by an account not removed is refused. With
  // `notTerminated` (the wizard's step 6, slice 2.30a, the profile's
  // «الحسابات», slice 2.30d, and the owners' «الموظفون», slice 2.33) the
  // restaurant must not be terminated, read under its row's share lock in
  // the add's transaction.
  async addAccount(
    restaurantId: string,
    account: { role: MerchantRole; name: string; phone: string },
    change: { actor: AuditActor; context: AuditRequestContext },
    { notTerminated = false }: { notTerminated?: boolean } = {},
  ): Promise<string> {
    const name = account.name.trim();
    if (name.length === 0 || !APP_PHONE_PATTERN.test(account.phone)) {
      throw new MerchantAccountRefusedError(
        'invalid_account',
        'an account needs a name and a Syrian or Turkish mobile in E.164',
      );
    }
    const restaurant = await this.merchants.cityAndStatus(restaurantId);
    if (!restaurant) {
      throw new MerchantAccountRefusedError('unknown_restaurant', 'no such restaurant');
    }
    const phoneHash = this.secrets.phoneHash(account.phone);
    return this.database.db.transaction(async (tx) => {
      if (notTerminated) await this.checkOpen(tx, restaurantId);
      // The partial unique index refuses a second account; the lock turns
      // that into a refusal instead of an error.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.merchant_phone:${phoneHash}`}, 0))`,
      );
      const [taken] = await tx
        .select({
          id: merchantAccounts.id,
          restaurantId: merchantAccounts.restaurantId,
          role: merchantAccounts.role,
          name: merchantAccounts.name,
        })
        .from(merchantAccounts)
        .where(and(eq(merchantAccounts.phoneHash, phoneHash), isNull(merchantAccounts.removedAt)));
      // The same account again (a retry of the wizard's add) is answered as
      // it was made.
      if (
        taken &&
        taken.restaurantId === restaurantId &&
        taken.role === account.role &&
        taken.name === name
      ) {
        return taken.id;
      }
      if (taken) {
        throw new MerchantAccountRefusedError(
          'phone_taken',
          'the number already belongs to a restaurant',
        );
      }
      const [created] = await tx
        .insert(merchantAccounts)
        .values({
          cityId: restaurant.cityId,
          restaurantId,
          role: account.role,
          name,
          phoneEncrypted: this.secrets.encrypt(account.phone),
          phoneHash,
        })
        .returning({ id: merchantAccounts.id });
      if (!created) throw new Error('the account was not created');
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: restaurant.cityId,
          action: 'merchant_account.create',
          target: { type: 'merchant_account', id: created.id },
          before: null,
          after: { restaurantId, role: account.role, name },
        },
        tx,
      );
      return created.id;
    });
  }

  // The wizard's step 6 (AP §9.6.3; slice 2.30a): the accounts with their
  // numbers, owners first, for the panel.
  async accountsWithPhones(restaurantId: string): Promise<(MerchantAccount & { phone: string })[]> {
    const rows = await this.database.db
      .select({
        id: merchantAccounts.id,
        restaurantId: merchantAccounts.restaurantId,
        role: merchantAccounts.role,
        name: merchantAccounts.name,
        phoneEncrypted: merchantAccounts.phoneEncrypted,
      })
      .from(merchantAccounts)
      .where(
        and(eq(merchantAccounts.restaurantId, restaurantId), isNull(merchantAccounts.removedAt)),
      )
      .orderBy(sql`${merchantAccounts.role} = 'cashier'`, asc(merchantAccounts.createdAt));
    return rows.map(({ phoneEncrypted, ...account }) => ({
      ...account,
      phone: this.secrets.decrypt(phoneEncrypted),
    }));
  }

  // Removes a restaurant user from the panel (the wizard's step 6, slice
  // 2.30a; the profile's «الحسابات», AP §9.6.4, slice 2.30d), of a restaurant
  // not terminated: its sessions end at once in the same transaction
  // (`account_removed`, RA §14.1); the caller passes their ids to
  // notifyEnded once it commits. Removing one already removed is
  // unknown_account. With `cashierOnly` (an owner in the app, RA §14.1,
  // slice 2.33) an owner's account is refused with not_a_cashier.
  async removeAccount(
    restaurantId: string,
    accountId: string,
    change: { actor: AuditActor; context: AuditRequestContext },
    { cashierOnly = false }: { cashierOnly?: boolean } = {},
    now = new Date(),
  ): Promise<string[]> {
    return this.database.db.transaction(async (tx) => {
      const status = await this.checkOpen(tx, restaurantId);
      // Two removals of one restaurant's users take turns, so the owner
      // count below never misses the other's.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.merchant_users:${restaurantId}`}, 0))`,
      );
      const [removed] = await tx
        .update(merchantAccounts)
        .set({ removedAt: now })
        .where(
          and(
            eq(merchantAccounts.id, accountId),
            eq(merchantAccounts.restaurantId, restaurantId),
            isNull(merchantAccounts.removedAt),
          ),
        )
        .returning({
          cityId: merchantAccounts.cityId,
          role: merchantAccounts.role,
          name: merchantAccounts.name,
        });
      if (!removed) {
        throw new MerchantAccountRefusedError('unknown_account', 'no such account');
      }
      // The transaction rolls the removal back.
      if (cashierOnly && removed.role !== 'cashier') {
        throw new MerchantAccountRefusedError('not_a_cashier', 'owners are FOX DROP’s to remove');
      }
      // RA §5.1: past the draft a restaurant keeps one owner or more.
      if (removed.role === 'owner' && status !== 'draft') {
        const [left] = await tx
          .select({ count: sql<number>`count(*)::int` })
          .from(merchantAccounts)
          .where(
            and(
              eq(merchantAccounts.restaurantId, restaurantId),
              eq(merchantAccounts.role, 'owner'),
              isNull(merchantAccounts.removedAt),
            ),
          );
        if ((left?.count ?? 0) === 0) {
          throw new MerchantAccountRefusedError('last_owner', 'the restaurant keeps one owner');
        }
      }
      const ended = await tx
        .update(appSessions)
        .set({ endedAt: now, endReason: 'account_removed' })
        .where(
          and(
            eq(appSessions.party, 'merchant'),
            eq(appSessions.accountId, accountId),
            isNull(appSessions.endedAt),
          ),
        )
        .returning({ id: appSessions.id });
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: removed.cityId,
          action: 'merchant_account.remove',
          target: { type: 'merchant_account', id: accountId },
          before: { restaurantId, role: removed.role, name: removed.name },
          after: null,
        },
        tx,
      );
      return ended.map((row) => row.id);
    });
  }

  // 404 unknown_restaurant, 403 restaurant_terminated, read under the
  // restaurant row's share lock until the caller's transaction ends.
  private async checkOpen(
    tx: Parameters<MerchantsService['lockedAccountStatus']>[0],
    restaurantId: string,
  ) {
    const status = await this.merchants.lockedAccountStatus(tx, restaurantId);
    if (status === null) {
      throw new MerchantAccountRefusedError('unknown_restaurant', 'no such restaurant');
    }
    if (status === 'terminated') {
      throw new MerchantAccountRefusedError('restaurant_terminated', 'the contract has ended');
    }
    return status;
  }

  // RA §14.1 (slice 2.33): the owners' «الموظفون»: every account not
  // removed, owners first, with its number, the devices it is signed in on
  // now and its last activity (its latest session's last refresh or end,
  // null before any sign-in).
  async staff(
    restaurantId: string,
  ): Promise<(MerchantAccount & { phone: string; devices: number; lastActiveAt: Date | null })[]> {
    const accounts = await this.accountsWithPhones(restaurantId);
    if (accounts.length === 0) return [];
    const rows = await this.database.db
      .select({
        accountId: appSessions.accountId,
        devices: sql<number>`(count(*) FILTER (WHERE ${appSessions.endedAt} IS NULL))::int`,
        lastActiveAt: sql<Date | null>`max(coalesce(${appSessions.endedAt}, ${appSessions.lastRefreshedAt}))`,
      })
      .from(appSessions)
      .where(
        and(
          eq(appSessions.party, 'merchant'),
          inArray(
            appSessions.accountId,
            accounts.map((account) => account.id),
          ),
        ),
      )
      .groupBy(appSessions.accountId);
    const byAccount = new Map(rows.map((row) => [row.accountId, row]));
    return accounts.map((account) => {
      const row = byAccount.get(account.id);
      return {
        ...account,
        devices: row?.devices ?? 0,
        lastActiveAt: row?.lastActiveAt ? new Date(row.lastActiveAt) : null,
      };
    });
  }

  // AP §9.6.4 «سجل التغييرات» (slice 2.30d): every account the restaurant
  // ever had, removed ones included, by id with its name.
  async everyAccount(restaurantId: string): Promise<Map<string, string>> {
    const rows = await this.database.db
      .select({ id: merchantAccounts.id, name: merchantAccounts.name })
      .from(merchantAccounts)
      .where(eq(merchantAccounts.restaurantId, restaurantId));
    return new Map(rows.map((row) => [row.id, row.name]));
  }

  // The restaurant's accounts not removed, owners first.
  async accounts(restaurantId: string): Promise<MerchantAccount[]> {
    return this.database.db
      .select({
        id: merchantAccounts.id,
        restaurantId: merchantAccounts.restaurantId,
        role: merchantAccounts.role,
        name: merchantAccounts.name,
      })
      .from(merchantAccounts)
      .where(
        and(eq(merchantAccounts.restaurantId, restaurantId), isNull(merchantAccounts.removedAt)),
      )
      .orderBy(sql`${merchantAccounts.role} = 'cashier'`, asc(merchantAccounts.createdAt));
  }

  // The account a number signs in to (RA §5.2), or why it cannot. The code
  // request answers the refusal before sending anything (architecture §8.3.2
  // allows RA §5.2 items 3–4 their messages, and §8.3.3 sends codes to real
  // users only); the sign-in checks it again. Read outside any transaction,
  // since the restaurant's status takes a pool connection of its own.
  async signInAccount(phoneHash: string): Promise<MerchantAccount | MerchantSignInRefusal> {
    const [account] = await this.database.db
      .select({
        id: merchantAccounts.id,
        restaurantId: merchantAccounts.restaurantId,
        role: merchantAccounts.role,
        name: merchantAccounts.name,
      })
      .from(merchantAccounts)
      .where(and(eq(merchantAccounts.phoneHash, phoneHash), isNull(merchantAccounts.removedAt)));
    if (!account) return 'not_registered';
    return (await this.refusal(account)) ?? account;
  }

  // AP §9.6.2 (slice 2.30c): the restaurant whose user signs in with this
  // number (E.164), the search of «المطاعم» by phone; null without one.
  async restaurantByPhone(phone: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ restaurantId: merchantAccounts.restaurantId })
      .from(merchantAccounts)
      .where(
        and(
          eq(merchantAccounts.phoneHash, this.secrets.phoneHash(phone)),
          isNull(merchantAccounts.removedAt),
        ),
      );
    return row?.restaurantId ?? null;
  }

  // An account not removed, or null.
  async account(executor: Executor, accountId: string): Promise<MerchantAccount | null> {
    const [account] = await executor
      .select({
        id: merchantAccounts.id,
        restaurantId: merchantAccounts.restaurantId,
        role: merchantAccounts.role,
        name: merchantAccounts.name,
      })
      .from(merchantAccounts)
      .where(and(eq(merchantAccounts.id, accountId), isNull(merchantAccounts.removedAt)));
    return account ?? null;
  }

  // Whether the account may still sign in and refresh, by its restaurant's
  // account status now (RA §5.5).
  async mayUse(account: MerchantAccount): Promise<boolean> {
    return (await this.refusal(account)) === null;
  }

  private async refusal(account: MerchantAccount): Promise<MerchantSignInRefusal | null> {
    const status = await this.merchants.accountStatus(account.restaurantId);
    if (status === null) return 'not_registered';
    return merchantSignInRefusal(account.role, status);
  }
}
