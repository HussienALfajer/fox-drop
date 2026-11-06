import { describe, expect, it } from 'vitest';
import { estimateRange, tripMinutes } from './delivery-estimate.js';

// docs/domain/03-timers.md (Q7) and CU §8.4: the estimate before ordering is
// the default prep, busy-mode minutes, the trip at order.eta_speed_kmh and
// order.eta_buffer_min, shown as a 10-minute range from the estimate rounded
// up to 5 minutes.
describe('tripMinutes', () => {
  it('turns the distance into minutes at the average speed', () => {
    expect(tripMinutes(5000, 20)).toBe(15);
    expect(tripMinutes(1000, 20)).toBe(3);
  });
});

describe('estimateRange', () => {
  it('adds prep, busy minutes, the trip and the buffer, from a multiple of 5', () => {
    expect(estimateRange({ prepMin: 20, busyExtraMin: null, tripMin: 3, bufferMin: 10 })).toEqual({
      fromMin: 35,
      toMin: 45,
    });
    expect(estimateRange({ prepMin: 20, busyExtraMin: 15, tripMin: 5, bufferMin: 10 })).toEqual({
      fromMin: 50,
      toMin: 60,
    });
  });

  it('keeps an estimate already on a multiple of 5', () => {
    expect(estimateRange({ prepMin: 15, busyExtraMin: null, tripMin: 5, bufferMin: 10 })).toEqual({
      fromMin: 30,
      toMin: 40,
    });
  });
});
