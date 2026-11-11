// AP §9.12.6 ranking (dispatch.ranking nearest_then_fewest_today): nearest
// to the restaurant first; on a tie, fewest orders today. Equal on both
// keeps the order given (the candidates' straight-line order).
export function nearestThenFewestToday<T extends { metres: number; ordersToday: number }>(
  entries: T[],
): T[] {
  return [...entries].sort((a, b) => a.metres - b.metres || a.ordersToday - b.ordersToday);
}
