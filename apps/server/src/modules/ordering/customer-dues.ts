import type { LedgerService } from '../ledger/index.js';

// AP §8.8 «مستحقات الزبون» (slice 2.11a): what the customer owes in the
// city, from their customer.dues accounts (the base currency; one per
// currency should another appear), or null when nothing is owed. A dues
// block lasts exactly while this is above zero, so it lifts by itself when
// the desk's payment (slice 2.25) or «تغيير النتيجة» (2.11c) brings the
// balance to 0 or less.
export async function customerDues(
  ledger: Pick<LedgerService, 'ownerAccounts' | 'balance'>,
  cityId: string,
  customerAccountId: string,
): Promise<{ amount: bigint; currency: string } | null> {
  const accounts = await ledger.ownerAccounts(cityId, customerAccountId, 'customer.dues');
  for (const account of accounts) {
    const balance = await ledger.balance(account.id);
    if (balance.amount > 0n) return balance;
  }
  return null;
}
