import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { GeoService } from './geo.service.js';

// The geo module (architecture §4.2): cities, and later zones and distances.
// Other modules read them through GeoService only.
@Module({
  imports: [DatabaseModule],
  providers: [GeoService],
  exports: [GeoService],
})
export class GeoModule {}

export { GeoService } from './geo.service.js';
