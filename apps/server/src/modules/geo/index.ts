import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { FxModule } from '../fx/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminCitiesController } from './admin-cities.controller.js';
import { ROAD_DISTANCES } from './distance.js';
import { GeoService } from './geo.service.js';
import { roadDistancesFromEnvironment } from './osrm-road-distances.js';

// The geo module (architecture §4.2): cities, distances, service zones and
// the delivery fee. Other modules read them through GeoService only.
@Module({
  imports: [DatabaseModule, SettingsModule, FxModule, AuditModule],
  controllers: [AdminCitiesController],
  providers: [GeoService, { provide: ROAD_DISTANCES, useFactory: roadDistancesFromEnvironment }],
  exports: [GeoService],
})
export class GeoModule {}

export { lastCutoff, nextCutoff } from './business-day.js';
export { estimateRange, tripMinutes } from './delivery-estimate.js';
export type { DeliveryFeeRule, DistanceBand } from './delivery-fee.js';
export { type Distance, type DistanceMethod, type Point, straightLineMetres } from './distance.js';
export {
  type DeliveryFee,
  type GeoChange,
  type GeoRefusal,
  GeoRefusedError,
  GeoService,
  type Zone,
} from './geo.service.js';
