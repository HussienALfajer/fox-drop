// Money from integer minor units, and times on the city's clock, with
// Western digits (AP §4.7). The amount never passes through a float: the
// decimal string is built from the digits and Intl formats it.
const fractionDigits = new Map<string, number>();

function digitsOf(currency: string): number {
  let digits = fractionDigits.get(currency);
  if (digits === undefined) {
    digits =
      new Intl.NumberFormat('en', { style: 'currency', currency }).resolvedOptions()
        .maximumFractionDigits ?? 2;
    fractionDigits.set(currency, digits);
  }
  return digits;
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
  return new Intl.NumberFormat('ar-u-nu-latn', {
    style: 'currency',
    currency: money.currency,
  }).format(decimalOf(money.amount, money.currency));
}

export function formatTime(at: string, timeZone: string): string {
  return new Intl.DateTimeFormat('ar-u-nu-latn', { timeStyle: 'short', timeZone }).format(
    new Date(at),
  );
}

export function formatDistance(metres: number): string {
  return new Intl.NumberFormat('ar-u-nu-latn', {
    style: 'unit',
    unit: metres >= 1000 ? 'kilometer' : 'meter',
    maximumFractionDigits: 1,
  }).format(metres >= 1000 ? metres / 1000 : metres);
}
