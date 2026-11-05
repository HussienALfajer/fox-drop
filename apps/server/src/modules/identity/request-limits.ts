import { randomUUID } from 'node:crypto';
import type { Valkey } from 'iovalkey';

export const HOUR_MS = 3_600_000;
export const DAY_MS = 24 * HOUR_MS;

// Architecture §8.3.3 item 2: the code request limits, kept in Valkey as
// rolling windows (a sorted set of times per number, device or IP address), so
// no burst fits across a window's edge. Losing them only lifts the limits
// until they fill again (architecture §5.7).
export class RequestLimits {
  constructor(private readonly valkey: Valkey) {}

  // How many events the key holds in the window ending now, and the seconds
  // until the oldest of them leaves it.
  async count(
    key: string,
    windowMs: number,
    now: Date,
  ): Promise<{ count: number; retryAfterSec: number }> {
    const since = now.getTime() - windowMs;
    const [count, oldest] = await Promise.all([
      this.valkey.zcount(key, `(${since}`, '+inf'),
      this.valkey.zrangebyscore(key, `(${since}`, '+inf', 'WITHSCORES', 'LIMIT', 0, 1),
    ]);
    const oldestAt = oldest[1] === undefined ? now.getTime() : Number(oldest[1]);
    return {
      count,
      retryAfterSec: Math.max(1, Math.ceil((oldestAt + windowMs - now.getTime()) / 1000)),
    };
  }

  // Records an event; the key keeps only the window that ends now.
  async add(key: string, windowMs: number, now: Date): Promise<void> {
    await this.valkey
      .multi()
      .zremrangebyscore(key, '-inf', now.getTime() - windowMs)
      .zadd(key, now.getTime(), `${now.getTime()}:${randomUUID()}`)
      .pexpire(key, windowMs)
      .exec();
  }
}
