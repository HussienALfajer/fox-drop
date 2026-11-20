// RA §11, §13, §17 (slice 2.45d): the reports' periods in business days on
// the city's clock, and the portal's custom range (owner decision
// 2026-11-20: at most 366 days, not after today; the server checks it).
export const OWNER_PERIODS = ['today', 'yesterday', 'last_7_days', 'last_30_days'] as const;
export type OwnerPeriod = (typeof OWNER_PERIODS)[number];

export const RANGE_MAX_DAYS = 366;

export type PeriodChoice<P extends string = OwnerPeriod> =
  { kind: 'period'; period: P } | { kind: 'range'; from: string; to: string };

const DAY_MS = 86_400_000;
const isDay = (day: string) =>
  /^\d{4}-\d{2}-\d{2}$/.test(day) && new Date(Date.parse(day)).toISOString().startsWith(day);

// Why a custom range typed cannot be asked, or null: both days, the last
// not before the first, at most RANGE_MAX_DAYS.
export function rangeProblem(from: string, to: string): 'missing' | 'backwards' | 'tooLong' | null {
  if (!isDay(from) || !isDay(to)) return 'missing';
  const days = (Date.parse(to) - Date.parse(from)) / DAY_MS + 1;
  if (days < 1) return 'backwards';
  if (days > RANGE_MAX_DAYS) return 'tooLong';
  return null;
}

// The query a choice asks: the period, or `from` and `to`.
export function periodQuery<P extends string>(
  choice: PeriodChoice<P>,
): { period: P } | { from: string; to: string } {
  return choice.kind === 'period'
    ? { period: choice.period }
    : { from: choice.from, to: choice.to };
}
