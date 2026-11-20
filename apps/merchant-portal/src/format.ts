// Money from integer minor units, with Western digits (AP §4.7), as the panel
// formats it (apps/admin/src/format.ts): the amount never passes through a
// float. The minor-unit digits of fx.currencies (migration 0008).
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

export function formatMoney(amount: string, currency: string): string {
  const digits = digitsOf(currency);
  return new Intl.NumberFormat('ar-u-nu-latn', {
    style: 'currency',
    currency,
    minimumFractionDigits: digits,
    maximumFractionDigits: digits,
  }).format(decimalOf(amount, currency));
}

// Times on the browser's clock: the owner reads the portal where the
// restaurant is (Azaz, one city in V1).
export function formatTime(at: string): string {
  return new Intl.DateTimeFormat('ar-u-nu-latn', { timeStyle: 'short' }).format(new Date(at));
}

export function formatDateTime(at: string): string {
  return new Intl.DateTimeFormat('ar-u-nu-latn', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(new Date(at));
}

// «د:ث» of a countdown or a count up, from milliseconds.
export function formatClock(ms: number): string {
  const seconds = Math.max(0, Math.floor(ms / 1000));
  const minutes = Math.floor(seconds / 60);
  return `${minutes}:${String(seconds % 60).padStart(2, '0')}`;
}
