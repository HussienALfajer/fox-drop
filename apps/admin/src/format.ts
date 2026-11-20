// Money from integer minor units, and times on the city's clock, with
// Western digits (AP §4.7). The amount never passes through a float: the
// decimal string is built from the digits and Intl formats it.
// The minor-unit digits of fx.currencies (migration 0008), as core_l10n
// keeps them: Intl's own data gives SYP none, the server two. A currency not
// listed has two until the panel reads the currencies.
const fractionDigits: Record<string, number> = { USD: 2, TRY: 2, SYP: 2 };

function digitsOf(currency: string): number {
  return fractionDigits[currency] ?? 2;
}

export function decimalOf(minor: string, currency: string): `${number}` {
  const digits = digitsOf(currency);
  const negative = minor.startsWith('-');
  const whole = (negative ? minor.slice(1) : minor).padStart(digits + 1, '0');
  const units = whole.slice(0, whole.length - digits);
  const fraction = whole.slice(whole.length - digits);
  const text = digits === 0 ? units : `${units}.${fraction}`;
  return (negative ? `-${text}` : text) as `${number}`;
}

export function formatMoney(money: { amount: string; currency: string }): string {
  return moneyFormat(money.currency, 'auto').format(decimalOf(money.amount, money.currency));
}

// A change, with a + on a gain (the dashboard, slice 2.40).
export function formatSignedMoney(money: { amount: string; currency: string }): string {
  return moneyFormat(money.currency, 'exceptZero').format(decimalOf(money.amount, money.currency));
}

function moneyFormat(currency: string, signDisplay: 'auto' | 'exceptZero') {
  const digits = digitsOf(currency);
  return new Intl.NumberFormat('ar-u-nu-latn', {
    style: 'currency',
    currency,
    minimumFractionDigits: digits,
    maximumFractionDigits: digits,
    signDisplay,
  });
}

export function formatTime(at: string, timeZone: string): string {
  return new Intl.DateTimeFormat('ar-u-nu-latn', { timeStyle: 'short', timeZone }).format(
    new Date(at),
  );
}

// A moment that may be on another day, such as a closed alert.
export function formatDateTime(at: string, timeZone: string): string {
  return new Intl.DateTimeFormat('ar-u-nu-latn', {
    dateStyle: 'short',
    timeStyle: 'short',
    timeZone,
  }).format(new Date(at));
}

// An average of stars as the server rounds it, to one decimal (AP §9.6.4).
export function formatAverage(average: number): string {
  return new Intl.NumberFormat('ar-u-nu-latn', { maximumFractionDigits: 1 }).format(average);
}

export function formatDistance(metres: number): string {
  return new Intl.NumberFormat('ar-u-nu-latn', {
    style: 'unit',
    unit: metres >= 1000 ? 'kilometer' : 'meter',
    maximumFractionDigits: 1,
  }).format(metres >= 1000 ? metres / 1000 : metres);
}

// An amount typed in the currency's major units («40» or «40.50», Western
// digits, at most its minor-unit digits) as minor units, or null when it is
// not one.
// `digits` overrides the table when the server gives the currency's own.
export function minorOf(
  typed: string,
  currency: string,
  digits = digitsOf(currency),
): string | null {
  const match = /^(\d{1,12})(?:\.(\d+))?$/.exec(typed.trim());
  if (!match) return null;
  const fraction = match[2] ?? '';
  if (fraction.length > digits) return null;
  const minor = `${match[1]}${fraction.padEnd(digits, '0')}`.replace(/^0+(?=\d)/, '');
  return minor;
}
