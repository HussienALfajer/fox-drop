import { randomUUID } from 'node:crypto';
import type { Valkey } from 'iovalkey';

export const HOUR_MS = 3_600_000;
export const DAY_MS = 24 * HOUR_MS;

// One limit: at most max events in the window ending now.
export interface Limit {
  key: string;
  windowMs: number;
  max: number;
}

// Trims every key to the longest window (a day), then checks each limit in
// order; when all pass, records the event in every key, all in one step, so
// parallel requests cannot all pass. Returns 0, or the 1-based index of the
// first limit reached and the time of the oldest event in its window.
const RESERVE = `
local now = tonumber(ARGV[1])
local member = ARGV[2]
local longest = tonumber(ARGV[3])
for i = 1, #KEYS do
  redis.call('ZREMRANGEBYSCORE', KEYS[i], '-inf', now - longest)
end
for i = 1, #KEYS do
  local since = now - tonumber(ARGV[2 + i * 2])
  local max = tonumber(ARGV[3 + i * 2])
  if redis.call('ZCOUNT', KEYS[i], '(' .. since, '+inf') >= max then
    local oldest = redis.call('ZRANGEBYSCORE', KEYS[i], '(' .. since, '+inf', 'WITHSCORES', 'LIMIT', 0, 1)
    return {i, oldest[2]}
  end
end
for i = 1, #KEYS do
  redis.call('ZADD', KEYS[i], now, member)
  redis.call('PEXPIRE', KEYS[i], longest)
end
return {0, '0'}
`;

export type Reservation =
  | { reserved: true; release(): Promise<void> }
  | { reserved: false; limit: Limit; retryAfterSec: number };

// Architecture §8.3.3 item 2: the code request limits, kept in Valkey as
// rolling windows (a sorted set of times per number, device or IP address), so
// no burst fits across a window's edge. Losing them only lifts the limits
// until they fill again (architecture §5.7).
export class RequestLimits {
  constructor(private readonly valkey: Valkey) {}

  // Records the event when every limit allows it; a refused event is not
  // recorded. release() takes a recorded event back, such as a code that was
  // not sent.
  async reserve(limits: Limit[], now: Date): Promise<Reservation> {
    const member = `${now.getTime()}:${randomUUID()}`;
    const keys = limits.map((limit) => limit.key);
    const [index, oldest] = (await this.valkey.eval(
      RESERVE,
      keys.length,
      ...keys,
      now.getTime(),
      member,
      DAY_MS,
      ...limits.flatMap((limit) => [limit.windowMs, limit.max]),
    )) as [number, string];
    const reached = limits[index - 1];
    if (!reached) {
      return {
        reserved: true,
        release: async () => {
          await Promise.all([...new Set(keys)].map((key) => this.valkey.zrem(key, member)));
        },
      };
    }
    const retryAfterMs = Number(oldest) + reached.windowMs - now.getTime();
    return {
      reserved: false,
      limit: reached,
      retryAfterSec: Math.max(1, Math.ceil(retryAfterMs / 1000)),
    };
  }
}
