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
  // «تصفية الخميس» (slice 2.18a): the payout and a negative balance collected.
  captain_payout: 'صرف المستحقات',
  captain_earnings_collection: 'تحصيل رصيد سالب',
  // «تسوية المطاعم» (slice 2.19b): the restaurant's payment, and the desk
  // paying a restaurant the platform owes.
  merchant_settlement: 'تسوية حساب المطعم',
  merchant_payout: 'صرف للمطعم',
  // «تسجيل دفع المستحق» (slice 2.25a): a customer's dues paid at the desk.
  customer_dues_payment: 'دفع مستحقات زبون',
} as const;

// CA §5.3, AP §9.7.1 (slice 2.34b): a captain applicant's documents in
// CA §5.3's words, as the app names them, for the pushes that name one.
export const applicationDocumentLabels = {
  national_id: 'الهوية',
  personal_photo: 'صورة شخصية',
  civil_registry: 'إخراج قيد',
  criminal_record: 'لا حكم عليه',
  vehicle_papers: 'أوراق المركبة',
  driving_licence: 'شهادة قيادة',
  signed_contract: 'العقد الموقّع',
} as const;

const WEEKDAYS = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

// A date on the city's clock as the apps show it (core_l10n's formatDate),
// «20/11/2026», with Western digits (slice 2.34b).
export function formatDate(moment: Date, timeZone: string): string {
  const [year, month, day] = new Intl.DateTimeFormat('en-CA', { timeZone })
    .format(moment)
    .split('-');
  return `${day}/${month}/${year}`;
}

// The same with its weekday, «الخميس 20/11/2026».
export function formatDay(moment: Date, timeZone: string): string {
  const day = new Intl.DateTimeFormat('en-CA', { timeZone }).format(moment);
  const weekday = new Date(`${day}T12:00:00Z`).getUTCDay();
  return `${WEEKDAYS[weekday]} ${formatDate(moment, timeZone)}`;
}
