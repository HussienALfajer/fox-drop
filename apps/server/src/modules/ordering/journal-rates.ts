import type { RateSnapshot } from '../fx/index.js';
import type { JournalRate } from '../ledger/index.js';

// AP §8.6, §8.11: a journal of the order whose entries span two currencies
// or more names the order's rate version of each but the base, from its
// snapshot, so platform.fx_rounding reads in the base; one in a single
// currency names none (the ledger refuses either way otherwise).
export function journalRates(
  snapshot: RateSnapshot,
  entries: readonly { currency: string }[],
): JournalRate[] | undefined {
  const currencies = new Set(entries.map((entry) => entry.currency));
  if (currencies.size < 2) return undefined;
  return [...currencies]
    .filter((currency) => currency !== snapshot.baseCurrency)
    .map((currency) => {
      const entry = snapshot.currencies.find((each) => each.code === currency);
      if (!entry?.rateVersionId) {
        throw new Error(`the order's snapshot has no rate version for ${currency}`);
      }
      return { currency, rateVersionId: entry.rateVersionId };
    });
}
