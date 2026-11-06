import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { type AccountStatus, MerchantsService } from '../merchants/index.js';
import { APP_PHONE_PATTERN } from './app-phone.js';
import { merchantAccounts, merchantRoles } from './schema.js';
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
    readonly refusal: 'unknown_restaurant' | 'phone_taken' | 'invalid_account',
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
export class MerchantAccountsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
  ) {}

  // An owner or a cashier of a restaurant. A number belongs to at most one
  // restaurant (S6): one taken by an account not removed is refused.
  async addAccount(
    restaurantId: string,
    account: { role: MerchantRole; name: string; phone: string },
    change: { actor: AuditActor; context: AuditRequestContext },
  ): Promise<string> {
    const name = account.name.trim();
    if (name.length === 0 || !APP_PHONE_PATTERN.test(account.phone)) {
      throw new MerchantAccountRefusedError(
        'invalid_account',
        'an account needs a name and a Syrian or Turkish mobile in E.164',
      );
    }
    const restaurant = await this.merchants.restaurant(restaurantId);
    if (!restaurant) {
      throw new MerchantAccountRefusedError('unknown_restaurant', 'no such restaurant');
    }
    const phoneHash = this.secrets.phoneHash(account.phone);
    return this.database.db.transaction(async (tx) => {
      // The partial unique index refuses a second account; the lock turns
      // that into a refusal instead of an error.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.merchant_phone:${phoneHash}`}, 0))`,
      );
      const [taken] = await tx
        .select({ id: merchantAccounts.id })
        .from(merchantAccounts)
        .where(and(eq(merchantAccounts.phoneHash, phoneHash), isNull(merchantAccounts.removedAt)));
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
