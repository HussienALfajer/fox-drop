import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { SettingsModule } from '../settings/index.js';
import { ROAD_DISTANCES } from './distance.js';
import { GeoService } from './geo.service.js';
import { roadDistancesFromEnvironment } from './osrm-road-distances.js';

// The geo module (architecture §4.2): cities and distances, and later zones.
// Other modules read them through GeoService only.
@Module({
  imports: [DatabaseModule, SettingsModule],
  providers: [GeoService, { provide: ROAD_DISTANCES, useFactory: roadDistancesFromEnvironment }],
  exports: [GeoService],
})
export class GeoModule {}

export type { Distance, DistanceMethod, Point } from './distance.js';
export { GeoService } from './geo.service.js';
