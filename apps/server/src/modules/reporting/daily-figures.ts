import type { AccountPurpose, CityTotal, JournalType, OwnerBalance } from '../ledger/index.js';

// «التقرير اليومي» (AP §9.10.1, §8.11; slice 2.20d): one business day's
// figures, read from the ledger's totals of the day (`cityTotals`, from the
// platform's side: + a debit) and the balances at the day's end.

// What one business day needs, read by DailyReportService.
export interface DayInput {
  // The city's base currency: every figure but the cash is in it.
  base: string;
  // The orders delivered in the day, test orders left out.
  orders: { count: number; gmv: bigint; itemsValue: bigint };
  totals: CityTotal[];
  // The distance part of the day's order pay booked to platform.captain_pay,
  // as the collections recorded it.
  distancePay: bigint;
  // An amount in the base: at the journal's rate version, else at the rate
  // in force at the day's end.
  toBase: (amount: bigint, currency: string, versionId: string | null) => bigint;
  // Every captain's custody and every restaurant's account at the day's end,
  // from the party's view.
  custody: OwnerBalance[];
  restaurants: OwnerBalance[];
}

// The cash of one currency (AP §9.10.1 «Cash from captains, per currency»),
// in that currency.
export interface CashFigures {
  currency: string;
  // The custody the day's orders left with the captains: collections less
  // the pickup payments, change and pickup corrections.
  custodyCreated: bigint;
  handedIn: bigint;
  reimbursed: bigint;
  // At the day's end: what captains hold, and what the office owes them.
  openCustody: bigint;
  owedToCaptains: bigint;
  // The desk's cash out to captains' earnings and in from restaurants.
  captainPayouts: bigint;
  restaurantPayments: bigint;
}

export interface DailyFigures {
  currency: string;
  orders: { count: number; gmv: bigint; itemsValue: bigint };
  deliveryFees: bigint;
  discounts: { platform: bigint; restaurant: bigint };
  // Earned by the platform (platform.revenue_commission).
  commission: bigint;
  // What captains earned by part, booked to platform.captain_pay: pay the
  // platform bears under AP §8.9 is in the operating cost and a test order's
  // in the test cost, so the lines add up to the margin.
  captainPay: {
    base: bigint;
    distance: bigint;
    waiting: bigint;
    peak: bigint;
    bonuses: bigint;
    total: bigint;
  };
  compensation: bigint;
  operatingCost: bigint;
  testCost: bigint;
  // + a gain for the platform.
  fxRounding: bigint;
  adjustments: bigint;
  // Kit deposits withheld at termination (C17, slice 2.35b), a revenue.
  withheldDeposits: bigint;
  // Revenues less costs, every platform account of AP §8.11 but the cash
  // and the order clearing.
  margin: bigint;
  cash: CashFigures[];
  // AP §9.10.1 «Owed by restaurants», + the restaurant owes.
  restaurants: {
    // Posted to the restaurants today, the commission of a failed order
    // included.
    commission: bigint;
    discountShare: bigint;
    owedByRestaurants: bigint;
    owedToRestaurants: bigint;
  };
}

const orderCustody = new Set<JournalType>([
  'custody.collect',
  'custody.change_given',
  'custody.pay_merchant',
  'custody.pickup_correction',
]);

// The platform's own accounts that make the margin, with the sign that
// turns their entries into a gain.
const marginAccounts: readonly AccountPurpose[] = [
  'platform.revenue_commission',
  'platform.revenue_delivery',
  'platform.discount_cost',
  'platform.compensation_cost',
  'platform.operating_cost',
  'platform.captain_pay',
  'platform.test_cost',
  'platform.fx_rounding',
  'platform.adjustments',
  'platform.revenue_deposits',
];

export function dailyFigures(day: DayInput): DailyFigures {
  const { totals, base } = day;
  // In the base, from the platform's side.
  const inBase = (row: CityTotal) =>
    day.toBase(
      row.amount,
      row.currency,
      row.rates?.find((rate) => rate.currency === row.currency)?.rateVersionId ?? null,
    );
  const sum = (match: (row: CityTotal) => boolean) =>
    totals.filter(match).reduce((total, row) => total + inBase(row), 0n);
  const account = (purpose: AccountPurpose) => sum((row) => row.purpose === purpose);
  const typed = (purpose: AccountPurpose, type: JournalType) =>
    sum((row) => row.purpose === purpose && row.type === type);

  const orderPay = typed('platform.captain_pay', 'earn.order_pay');
  const captainPay = {
    base: orderPay - day.distancePay,
    distance: day.distancePay,
    waiting: typed('platform.captain_pay', 'earn.waiting_pay'),
    peak: typed('platform.captain_pay', 'earn.peak_bonus'),
    bonuses: typed('platform.captain_pay', 'earn.bonus'),
    total: 0n,
  };
  captainPay.total =
    captainPay.base +
    captainPay.distance +
    captainPay.waiting +
    captainPay.peak +
    captainPay.bonuses;

  const restaurantsOwe = day.restaurants.filter((row) => row.currency === base);
  return {
    currency: base,
    orders: day.orders,
    deliveryFees: -account('platform.revenue_delivery'),
    discounts: {
      platform: account('platform.discount_cost'),
      restaurant: typed('merchant.account', 'merchant.discount_share'),
    },
    commission: -account('platform.revenue_commission'),
    captainPay,
    compensation: account('platform.compensation_cost'),
    operatingCost: account('platform.operating_cost'),
    testCost: account('platform.test_cost'),
    fxRounding: -account('platform.fx_rounding'),
    adjustments: -account('platform.adjustments'),
    withheldDeposits: -account('platform.revenue_deposits'),
    margin: -sum((row) => marginAccounts.includes(row.purpose)),
    cash: cashOf(day),
    restaurants: {
      commission: typed('merchant.account', 'merchant.commission'),
      discountShare: typed('merchant.account', 'merchant.discount_share'),
      owedByRestaurants: restaurantsOwe
        .filter((row) => row.amount < 0n)
        .reduce((total, row) => total - row.amount, 0n),
      owedToRestaurants: restaurantsOwe
        .filter((row) => row.amount > 0n)
        .reduce((total, row) => total + row.amount, 0n),
    },
  };
}

// Each currency the day's cash or the open custody touched, the base first.
function cashOf(day: DayInput): CashFigures[] {
  const currencies = new Set<string>();
  const cashRows = day.totals.filter(
    (row) =>
      (row.purpose === 'captain.custody' &&
        (orderCustody.has(row.type) ||
          row.type === 'custody.hand_in' ||
          row.type === 'custody.reimburse')) ||
      (row.purpose === 'platform.cash' &&
        (row.type === 'earn.payout' || row.type === 'merchant.settlement')),
  );
  for (const row of cashRows) currencies.add(row.currency);
  for (const row of day.custody) currencies.add(row.currency);
  const ordered = [...currencies].sort((a, b) =>
    a === day.base ? -1 : b === day.base ? 1 : a.localeCompare(b),
  );
  return ordered.map((currency) => {
    const of = (match: (row: CityTotal) => boolean) =>
      cashRows
        .filter((row) => row.currency === currency && match(row))
        .reduce((total, row) => total + row.amount, 0n);
    const custody = day.custody.filter((row) => row.currency === currency);
    return {
      currency,
      custodyCreated: of((row) => row.purpose === 'captain.custody' && orderCustody.has(row.type)),
      handedIn: -of((row) => row.purpose === 'captain.custody' && row.type === 'custody.hand_in'),
      reimbursed: of(
        (row) => row.purpose === 'captain.custody' && row.type === 'custody.reimburse',
      ),
      openCustody: custody
        .filter((row) => row.amount > 0n)
        .reduce((total, row) => total + row.amount, 0n),
      owedToCaptains: custody
        .filter((row) => row.amount < 0n)
        .reduce((total, row) => total - row.amount, 0n),
      captainPayouts: -of((row) => row.purpose === 'platform.cash' && row.type === 'earn.payout'),
      restaurantPayments: of(
        (row) => row.purpose === 'platform.cash' && row.type === 'merchant.settlement',
      ),
    };
  });
}
