import { Inject, Injectable } from '@nestjs/common';
import { desc, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { customerAccounts } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets } from './secrets.js';

// The customers' accounts as other modules need them.
@Injectable()
export class CustomerAccountsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
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
}
