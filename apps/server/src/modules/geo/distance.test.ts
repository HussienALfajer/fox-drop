import { describe, expect, it, vi } from 'vitest';
import { measureDistance, type RoadDistances, straightLineMetres } from './distance.js';

// Architecture §7.1, AP §9.12.3: a road distance from the routing service,
// or the straight line × 1.3 when it does not answer.
const azaz = { latitude: 36.5866, longitude: 37.0463 };
const north = { latitude: 37.5866, longitude: 37.0463 };
const market = { latitude: 36.5901, longitude: 37.0518 };

function road(answer: () => Promise<number>): RoadDistances & { calls: unknown[][] } {
  const calls: unknown[][] = [];
  return {
    calls,
    metres: (...args) => {
      calls.push(args);
      return answer();
    },
  };
}

describe('straightLineMetres', () => {
  it('measures one degree of latitude as about 111.2 km', () => {
    expect(straightLineMetres(azaz, north)).toBeCloseTo(111_195, 0);
  });

  it('is zero between a point and itself, and the same both ways', () => {
    expect(straightLineMetres(azaz, azaz)).toBe(0);
    expect(straightLineMetres(azaz, market)).toBe(straightLineMetres(market, azaz));
  });
});

describe('measureDistance', () => {
  const straight = straightLineMetres(azaz, market);

  it('returns the road distance in whole metres', async () => {
    const osrm = road(() => Promise.resolve(2345.6));
    await expect(measureDistance(azaz, market, 'motorbike', 'road', osrm)).resolves.toEqual({
      metres: 2346,
      method: 'road',
    });
    expect(osrm.calls).toEqual([[azaz, market, 'motorbike']]);
  });

  it('falls back to the straight line × 1.3 when the routing service fails', async () => {
    const osrm = road(() => Promise.reject(new Error('timed out')));
    const onFallback = vi.fn();
    await expect(measureDistance(azaz, market, 'car', 'road', osrm, onFallback)).resolves.toEqual({
      metres: Math.round(straight * 1.3),
      method: 'straight_x1.3',
    });
    expect(onFallback).toHaveBeenCalledWith(new Error('timed out'));
  });

  it('refuses a point that is not a coordinate, without asking', async () => {
    const osrm = road(() => Promise.resolve(2345.6));
    for (const point of [
      { latitude: Number.NaN, longitude: 37 },
      { latitude: 91, longitude: 37 },
      { latitude: 36, longitude: -180.5 },
      { latitude: 36, longitude: Number.POSITIVE_INFINITY },
    ]) {
      await expect(measureDistance(point, market, 'car', 'road', osrm)).rejects.toThrow(RangeError);
      await expect(measureDistance(azaz, point, 'car', 'road', osrm)).rejects.toThrow(RangeError);
    }
    expect(osrm.calls).toEqual([]);
  });

  it('never calls the routing service when pricing.distance_method is straight_line', async () => {
    const osrm = road(() => Promise.resolve(2345.6));
    await expect(measureDistance(azaz, market, 'walking', 'straight_line', osrm)).resolves.toEqual({
      metres: Math.round(straight * 1.3),
      method: 'straight_x1.3',
    });
    expect(osrm.calls).toEqual([]);
  });
});
