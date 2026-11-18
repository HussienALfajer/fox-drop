import { Inject, Injectable } from '@nestjs/common';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { LedgerService } from '../ledger/index.js';
import { type MerchantChange, MerchantsService } from '../merchants/index.js';
import { OrdersService } from '../ordering/index.js';
import { CashDeskRefusedError } from './cashdesk.service.js';
import { lockRestaurantAccount } from './merchant-statements.service.js';

// AP §9.6.5 «إنهاء» (slice 2.30c): OWN ends the contract once the
// restaurant's account is settled to zero. The account lives here (the
// ledger's merchant.account, read under the statement's lock, so a payment
// or a statement being taken is read whole), so the termination runs here and
// merchants writes the status in the same transaction.
@Injectable()
export class RestaurantTerminationService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly ledger: LedgerService,
    private readonly orders: OrdersService,
  ) {}

  async terminate(restaurantId: string, change: MerchantChange): Promise<void> {
    const found = await this.merchants.cityAndStatus(restaurantId);
    if (found === null) {
      throw new CashDeskRefusedError('unknown_restaurant', 'no such restaurant');
    }
    if (found.accountStatus === 'terminated') return;
    // An order not finished would still post to the account (decided by
    // us): read before the transaction, as the restaurant takes no order
    // lock; an order placed in between finds the restaurant terminated at
    // its acceptance.
    if ((await this.orders.unfinishedOrderCount(restaurantId)) > 0) {
      throw new CashDeskRefusedError('orders_unfinished', 'the restaurant has orders not finished');
    }
    await this.database.db.transaction(async (tx) => {
      await lockRestaurantAccount(tx, restaurantId);
      for (const account of await this.ledger.ownerAccounts(
        found.cityId,
        restaurantId,
        'merchant.account',
        tx,
      )) {
        const { amount } = await this.ledger.balance(account.id, tx);
        if (amount !== 0n) {
          throw new CashDeskRefusedError(
            'balance_not_zero',
            `the account holds ${amount.toString()} ${account.currency}`,
          );
        }
      }
      await this.merchants.terminateIn(tx, restaurantId, change);
    });
  }
}
