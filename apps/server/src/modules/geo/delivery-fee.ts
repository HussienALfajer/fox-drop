// A city's delivery fee rule (AP §9.12.3), its amounts in integer minor units
// of the city's base currency (docs/domain/04-order-money.md).
export interface DistanceBand {
  // The band's upper edge in metres, included; null for the last band, which
  // has no edge.
  upToMetres: number | null;
  fee: bigint;
}

interface RuleCommon {
  currency: string;
  // A fee below it is raised to it; null for none.
  minimumFee: bigint | null;
  // An items value from which delivery is free; null for none.
  freeDeliveryFrom: bigint | null;
}

export type DeliveryFeeRule =
  | (RuleCommon & { kind: 'flat'; flatFee: bigint })
  | (RuleCommon & { kind: 'distance_bands'; bands: DistanceBand[] });

// The largest amount a PostgreSQL bigint holds, and the largest band edge an
// integer column holds.
const MAX_AMOUNT = 2n ** 63n - 1n;
const MAX_METRES = 2 ** 31 - 1;

// Why a rule cannot be saved, or null when it can.
export function checkDeliveryFeeRule(rule: DeliveryFeeRule): string | null {
  if (!/^[A-Z]{3}$/.test(rule.currency)) return 'the currency is a three-letter code';
  const amounts = [
    rule.minimumFee,
    rule.freeDeliveryFrom,
    ...(rule.kind === 'flat' ? [rule.flatFee] : rule.bands.map((band) => band.fee)),
  ];
  if (amounts.some((amount) => amount !== null && amount > MAX_AMOUNT)) {
    return 'an amount is too large';
  }
  if (rule.minimumFee !== null && rule.minimumFee < 0n) return 'the minimum fee is not negative';
  if (rule.freeDeliveryFrom !== null && rule.freeDeliveryFrom <= 0n) {
    return 'the free-delivery threshold is above zero';
  }
  if (rule.kind === 'flat') return rule.flatFee < 0n ? 'the fee is not negative' : null;

  const { bands } = rule;
  if (bands.length === 0 || bands.at(-1)!.upToMetres !== null) {
    return 'the last band has no upper edge, so every distance has a fee';
  }
  let previous = 0;
  for (const [index, band] of bands.entries()) {
    if (band.fee < 0n) return 'a band fee is not negative';
    if (index === bands.length - 1) break;
    const edge = band.upToMetres;
    if (edge === null || !Number.isInteger(edge) || edge <= previous || edge > MAX_METRES) {
      return 'the band edges are whole metres, above zero and increasing';
    }
    previous = edge;
  }
  return null;
}

// The fee for an order with this items value. A distance-band rule needs the
// distance in metres; a flat rule ignores it. A distance on a band's edge
// takes that band, the lower fee; free delivery pays 0 whatever the minimum
// fee (owner decisions 2026-11-06).
export function deliveryFeeFor(
  rule: DeliveryFeeRule,
  { itemsValue, metres }: { itemsValue: bigint; metres?: number | undefined },
): { fee: bigint; free: boolean } {
  if (rule.freeDeliveryFrom !== null && itemsValue >= rule.freeDeliveryFrom) {
    return { fee: 0n, free: true };
  }
  let fee: bigint;
  if (rule.kind === 'flat') {
    fee = rule.flatFee;
  } else {
    if (metres === undefined) throw new RangeError('distance bands need the distance');
    fee = rule.bands.find((band) => band.upToMetres === null || metres <= band.upToMetres)!.fee;
  }
  if (rule.minimumFee !== null && fee < rule.minimumFee) fee = rule.minimumFee;
  return { fee, free: false };
}
