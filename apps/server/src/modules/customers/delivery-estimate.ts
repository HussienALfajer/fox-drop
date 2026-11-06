// docs/domain/03-timers.md (Q7): the trip time of a distance at the city's
// average speed (order.eta_speed_kmh).
export function tripMinutes(metres: number, speedKmh: number): number {
  return (metres / 1000 / speedKmh) * 60;
}

// CU §8.4: the estimate before ordering, estimate_min = default prep +
// busy-mode minutes + trip_min + order.eta_buffer_min, shown as a 10-minute
// range (fixed) starting at the estimate rounded up to 5 minutes.
export function estimateRange({
  prepMin,
  busyExtraMin,
  tripMin,
  bufferMin,
}: {
  prepMin: number;
  busyExtraMin: number | null;
  tripMin: number;
  bufferMin: number;
}): { fromMin: number; toMin: number } {
  const estimate = prepMin + (busyExtraMin ?? 0) + tripMin + bufferMin;
  const fromMin = Math.ceil(estimate / 5) * 5;
  return { fromMin, toMin: fromMin + 10 };
}
