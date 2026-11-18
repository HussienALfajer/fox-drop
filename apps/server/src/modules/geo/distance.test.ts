import { describe, expect, it, vi } from 'vitest';
import {
  measureDistance,
  measureDistances,
  measureRoute,
  type RoadDistances,
  straightLineMetres,
} from './distance.js';

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
    table: () => Promise.reject(new Error('not asked')),
    route: () => Promise.reject(new Error('not asked')),
  };
}

function matrix(answer: () => Promise<(number | null)[]>): RoadDistances {
  return {
    metres: () => Promise.reject(new Error('not asked')),
    table: answer,
    route: () => Promise.reject(new Error('not asked')),
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

describe('measureDistances (AP §9.12.6)', () => {
  const straight = Math.round(straightLineMetres(azaz, market) * 1.3);

  it('reads each road distance, the straight line × 1.3 for one without a route', async () => {
    const onFallback = vi.fn();
    await expect(
      measureDistances(
        [azaz, north],
        market,
        'motorbike',
        'road',
        matrix(() => Promise.resolve([2345.6, null])),
        onFallback,
      ),
    ).resolves.toEqual([
      { metres: 2346, method: 'road' },
      { metres: Math.round(straightLineMetres(north, market) * 1.3), method: 'straight_x1.3' },
    ]);
    expect(onFallback).toHaveBeenCalledOnce();
  });

  it('falls back for every source when the matrix fails or has the wrong rows', async () => {
    for (const answer of [
      () => Promise.reject(new Error('timed out')),
      () => Promise.resolve([1, 2]),
    ]) {
      await expect(
        measureDistances([azaz], market, 'car', 'road', matrix(answer)),
      ).resolves.toEqual([{ metres: straight, method: 'straight_x1.3' }]);
    }
  });

  it('never asks with straight_line, and refuses a point that is not a coordinate', async () => {
    const never = matrix(() => Promise.reject(new Error('asked')));
    await expect(measureDistances([azaz], market, 'car', 'straight_line', never)).resolves.toEqual([
      { metres: straight, method: 'straight_x1.3' },
    ]);
    await expect(
      measureDistances([{ latitude: 91, longitude: 0 }], market, 'car', 'road', never),
    ).rejects.toThrow(RangeError);
  });
});

describe('measureRoute', () => {
  const line = [azaz, market];
  const routed = (answer: () => Promise<{ metres: number; seconds: number; line: typeof line }>) =>
    ({
      metres: () => Promise.reject(new Error('not asked')),
      table: () => Promise.reject(new Error('not asked')),
      route: answer,
    }) satisfies RoadDistances;

  it('answers the road route in whole metres and seconds with its line', async () => {
    const route = await measureRoute(
      azaz,
      market,
      'motorbike',
      30,
      routed(() => Promise.resolve({ metres: 1834.7, seconds: 201.3, line })),
    );
    expect(route).toEqual({ metres: 1835, seconds: 201, method: 'road', line });
  });

  it('falls back to the straight line × 1.3 at the speed, without a line', async () => {
    const onFallback = vi.fn();
    const route = await measureRoute(
      azaz,
      market,
      'motorbike',
      30,
      routed(() => Promise.reject(new Error('down'))),
      onFallback,
    );
    const metres = Math.round(straightLineMetres(azaz, market) * 1.3);
    // 30 km/h is 500 metres a minute.
    expect(route).toEqual({
      metres,
      seconds: Math.round((metres / 500) * 60),
      method: 'straight_x1.3',
      line: null,
    });
    expect(onFallback).toHaveBeenCalledOnce();
  });

  it('refuses a point off the map', async () => {
    await expect(
      measureRoute(
        { latitude: 91, longitude: 0 },
        market,
        'car',
        30,
        routed(() => Promise.reject(new Error('not asked'))),
      ),
    ).rejects.toThrow(RangeError);
  });
});
