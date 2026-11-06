// One vehicle's row of a pay table (AP §9.12.5), its amounts in integer minor
// units of the table's currency, the city's base (AP §8.6).
export interface PayRate {
  // Pays the first includedMetres.
  basePay: bigint;
  includedMetres: number;
  perExtraKm: bigint;
  // Per whole minute of waiting past captain.waiting_threshold_min.
  waitingPerMinute: bigint;
  minimumPay: bigint;
}

// The largest amount a PostgreSQL bigint holds, and the largest distance an
// integer column holds.
const MAX_AMOUNT = 2n ** 63n - 1n;
const MAX_METRES = 2 ** 31 - 1;

// Why a rate cannot be saved, or null when it can.
export function checkPayRate(rate: PayRate): string | null {
  const amounts = [rate.basePay, rate.perExtraKm, rate.waitingPerMinute, rate.minimumPay];
  if (amounts.some((amount) => amount < 0n)) return 'the amounts are not negative';
  if (amounts.some((amount) => amount > MAX_AMOUNT)) return 'an amount is too large';
  if (
    !Number.isInteger(rate.includedMetres) ||
    rate.includedMetres < 0 ||
    rate.includedMetres > MAX_METRES
  ) {
    return 'the included distance is whole metres, zero or more';
  }
  return null;
}

// An order's pay in its parts (AP §8.4, §8.5.5; CA §9.8): the base pay, the
// distance pay, the top-up to the minimum («إكمال للحد الأدنى»), their sum
// `orderPay` (earn.order_pay), and the waiting pay (earn.waiting_pay).
export interface PayParts {
  base: bigint;
  distance: bigint;
  topUp: bigint;
  orderPay: bigint;
  waiting: bigint;
}

// The pay of one order: the base pay, each metre past the included distance
// pro rata and rounded down to the minor unit, raised to the minimum pay;
// the waiting pay on top, never absorbed by the minimum (docs/domain/04;
// owner decision 2026-11-06).
export function orderPay(
  rate: PayRate,
  { metres, waitingMinutes }: { metres: number; waitingMinutes: number },
): PayParts {
  if (!Number.isInteger(metres) || metres < 0) {
    throw new RangeError('the distance is whole metres, zero or more');
  }
  if (!Number.isInteger(waitingMinutes) || waitingMinutes < 0) {
    throw new RangeError('the waiting time is whole minutes, zero or more');
  }
  const extraMetres = BigInt(Math.max(0, metres - rate.includedMetres));
  const base = rate.basePay;
  const distance = (extraMetres * rate.perExtraKm) / 1_000n;
  const topUp = base + distance < rate.minimumPay ? rate.minimumPay - base - distance : 0n;
  return {
    base,
    distance,
    topUp,
    orderPay: base + distance + topUp,
    waiting: BigInt(waitingMinutes) * rate.waitingPerMinute,
  };
}
