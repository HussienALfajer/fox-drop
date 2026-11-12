// How a push shows money and times (CU §4.6, AP §4.7), shared by every
// module that renders a notification text.

// CU §4.6, AP §4.7: an amount as the apps show it, «120 ₺» or «10.50 $», with
// Western digits: a whole amount drops its fraction.
export function formatMoney(
  minor: bigint,
  currency: string,
  known: ReadonlyMap<string, { symbol: string; decimals: number }>,
): string {
  const { symbol, decimals } = known.get(currency) ?? { symbol: currency, decimals: 2 };
  const negative = minor < 0n;
  const digits = (negative ? -minor : minor).toString().padStart(decimals + 1, '0');
  const whole = digits.slice(0, digits.length - decimals);
  const fraction = digits.slice(digits.length - decimals);
  const amount = /^0*$/.test(fraction) ? whole : `${whole}.${fraction}`;
  return `${negative ? '-' : ''}${amount} ${symbol}`;
}

// A 12-hour time on the city's clock with «ص» or «م», as the apps show it.
export function formatTime(moment: Date, timeZone: string): string {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      hour: 'numeric',
      minute: '2-digit',
      hourCycle: 'h23',
    })
      .formatToParts(moment)
      .map((part) => [part.type, part.value]),
  );
  const hour = Number(parts.hour) % 24;
  return `${hour % 12 === 0 ? 12 : hour % 12}:${parts.minute} ${hour < 12 ? 'ص' : 'م'}`;
}

// AP §9.10.3, CA §14 #19 «إيصال {رقم}: {النوع} {المبلغ}»: the type printed on a
// desk receipt and named in its push (slice 2.17a; the wording is ours, to
// confirm with the owner).
export const receiptTypeLabels = {
  captain_hand_in: 'تسليم نقد',
  captain_reimbursement: 'صرف للكابتن',
} as const;
