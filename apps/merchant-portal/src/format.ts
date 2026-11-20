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

// Times on the restaurant's city clock (the session's `timeZone`), never
// the browser's, which may be set wrong.
export function formatTime(at: string, timeZone: string): string {
  return new Intl.DateTimeFormat('ar-u-nu-latn', { timeStyle: 'short', timeZone }).format(
    new Date(at),
  );
}

export function formatDateTime(at: string, timeZone: string): string {
  return new Intl.DateTimeFormat('ar-u-nu-latn', {
    dateStyle: 'medium',
    timeStyle: 'short',
    timeZone,
  }).format(new Date(at));
}

// A wall time typed on the city's clock (an <input type="datetime-local">
// value, such as 2026-11-09T18:30) as an instant; null for an empty or
// unreadable value. As the panel's zonedToUtc.
export function zonedToUtc(local: string, timeZone: string): string | null {
  const match = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})$/.exec(local);
  if (!match) return null;
  const [year, month, day, hour, minute] = match.slice(1).map(Number) as [
    number,
    number,
    number,
    number,
    number,
  ];
  const asUtc = Date.UTC(year, month - 1, day, hour, minute);
  // The zone's offset at that moment, read twice so a change of offset
  // between the guess and the answer is taken into account.
  let instant = asUtc - offsetMs(asUtc, timeZone);
  instant = asUtc - offsetMs(instant, timeZone);
  return new Date(instant).toISOString();
}

function offsetMs(instant: number, timeZone: string): number {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      hourCycle: 'h23',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    })
      .formatToParts(new Date(instant))
      .map((part) => [part.type, part.value]),
  );
  const asUtc = Date.UTC(
    Number(parts.year),
    Number(parts.month) - 1,
    Number(parts.day),
    Number(parts.hour),
    Number(parts.minute),
    Number(parts.second),
  );
  return asUtc - Math.floor(instant / 1000) * 1000;
}

// «د:ث» of a countdown or a count up, from milliseconds.
export function formatClock(ms: number): string {
  const seconds = Math.max(0, Math.floor(ms / 1000));
  const minutes = Math.floor(seconds / 60);
  return `${minutes}:${String(seconds % 60).padStart(2, '0')}`;
}
