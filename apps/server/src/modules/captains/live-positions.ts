import { Inject, Injectable, Logger } from '@nestjs/common';
import { Valkey } from 'iovalkey';
import { VALKEY } from '../../valkey/valkey.module.js';

export interface LivePosition {
  latitude: number;
  longitude: number;
  accuracyMetres: number;
  recordedAt: Date;
}

// Writes only a newer position, so a late batch never moves a captain back.
const SET_IF_NEWER = `
local stored = redis.call('HGET', KEYS[2], 'recordedAt')
if stored and tonumber(stored) >= tonumber(ARGV[4]) then return 0 end
redis.call('HSET', KEYS[2], 'latitude', ARGV[2], 'longitude', ARGV[1], 'accuracy', ARGV[3], 'recordedAt', ARGV[4])
redis.call('GEOADD', KEYS[1], ARGV[1], ARGV[2], ARGV[5])
return 1
`;

// Architecture §7.3: the online captains' last positions in Valkey, for
// dispatch and the live map: a geo set per city and a hash per captain. The
// locations table holds every point, so nothing here is the only copy
// (architecture §5.7), and a failed write is logged, never fatal.
@Injectable()
export class LivePositions {
  private readonly logger = new Logger(LivePositions.name);

  constructor(@Inject(VALKEY) private readonly valkey: Valkey) {}

  async set(cityId: string, captainId: string, position: LivePosition): Promise<void> {
    try {
      await this.valkey.eval(
        SET_IF_NEWER,
        2,
        cityKey(cityId),
        captainKey(captainId),
        String(position.longitude),
        String(position.latitude),
        String(position.accuracyMetres),
        String(position.recordedAt.getTime()),
        captainId,
      );
    } catch (error) {
      this.logger.warn({ err: error }, 'the live position was not written');
    }
  }

  async get(captainId: string): Promise<LivePosition | null> {
    const stored = await this.valkey.hgetall(captainKey(captainId));
    if (stored.recordedAt === undefined) return null;
    return {
      latitude: Number(stored.latitude),
      longitude: Number(stored.longitude),
      accuracyMetres: Number(stored.accuracy),
      recordedAt: new Date(Number(stored.recordedAt)),
    };
  }

  // Going offline: no position is kept for an offline captain (CA §4.3).
  async remove(cityId: string, captainId: string): Promise<void> {
    try {
      await this.valkey.multi().zrem(cityKey(cityId), captainId).del(captainKey(captainId)).exec();
    } catch (error) {
      this.logger.warn({ err: error }, 'the live position was not removed');
    }
  }
}

const cityKey = (cityId: string) => `captains:online:${cityId}`;
const captainKey = (captainId: string) => `captains:position:${captainId}`;
