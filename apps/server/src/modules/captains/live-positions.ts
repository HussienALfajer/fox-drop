import { Inject, Injectable, Logger } from '@nestjs/common';
import { Valkey } from 'iovalkey';
import { VALKEY } from '../../valkey/valkey.module.js';

export interface LivePosition {
  latitude: number;
  longitude: number;
  accuracyMetres: number;
  recordedAt: Date;
}

// The hash outlives the last point by this many seconds, so an app that died
// online leaves no position for long.
const POSITION_TTL_SECONDS = 600;
// How long an ended online period refuses a late write.
const ENDED_TTL_SECONDS = 86_400;

// Writes only a newer position of an online period that has not ended, so a
// late batch never moves a captain back or brings back an offline captain.
const SET_IF_NEWER = `
if redis.call('GET', KEYS[3]) == ARGV[6] then return 0 end
local stored = redis.call('HGET', KEYS[2], 'recordedAt')
if stored and tonumber(stored) >= tonumber(ARGV[4]) then return 0 end
redis.call('HSET', KEYS[2], 'latitude', ARGV[2], 'longitude', ARGV[1], 'accuracy', ARGV[3], 'recordedAt', ARGV[4])
redis.call('EXPIRE', KEYS[2], ARGV[7])
redis.call('GEOADD', KEYS[1], ARGV[1], ARGV[2], ARGV[5])
return 1
`;

// Architecture §7.3: the online captains' last positions in Valkey, for
// dispatch and the live map: a geo set per city and a hash per captain, which
// expires 10 minutes after its last point. The locations table holds every
// point, so nothing here is the only copy (architecture §5.7), and a failed
// write is logged, never fatal. A reader checks the hash's recordedAt and the
// captain's state in the database: the geo set has no expiry.
@Injectable()
export class LivePositions {
  private readonly logger = new Logger(LivePositions.name);

  constructor(@Inject(VALKEY) private readonly valkey: Valkey) {}

  async set(
    cityId: string,
    captainId: string,
    periodId: string,
    position: LivePosition,
  ): Promise<void> {
    try {
      await this.valkey.eval(
        SET_IF_NEWER,
        3,
        cityKey(cityId),
        captainKey(captainId),
        endedKey(captainId),
        String(position.longitude),
        String(position.latitude),
        String(position.accuracyMetres),
        String(position.recordedAt.getTime()),
        captainId,
        periodId,
        String(POSITION_TTL_SECONDS),
      );
    } catch (error) {
      this.logger.warn({ err: error }, 'the live position was not written');
    }
  }

  // Going offline: no position is kept for an offline captain (CA §4.3), and
  // the ended period refuses a write still on its way.
  async remove(cityId: string, captainId: string, periodId: string): Promise<void> {
    try {
      await this.valkey
        .multi()
        .set(endedKey(captainId), periodId, 'EX', ENDED_TTL_SECONDS)
        .zrem(cityKey(cityId), captainId)
        .del(captainKey(captainId))
        .exec();
    } catch (error) {
      this.logger.warn({ err: error }, 'the live position was not removed');
    }
  }
}

const cityKey = (cityId: string) => `captains:online:${cityId}`;
const captainKey = (captainId: string) => `captains:position:${captainId}`;
const endedKey = (captainId: string) => `captains:ended:${captainId}`;
