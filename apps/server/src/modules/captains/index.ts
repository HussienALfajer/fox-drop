import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { ContentModule } from '../content/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { LedgerModule } from '../ledger/index.js';
import { SettingsModule } from '../settings/index.js';
import { ValkeyModule } from '../../valkey/valkey.module.js';
import { CaptainAvailabilityController } from './captain-availability.controller.js';
import { CaptainsService } from './captains.service.js';
import { LivePositions } from './live-positions.js';
import { LocationPartitions } from './location-partitions.js';

// The captains module (architecture §4.2): the captain record, its cash
// limit, availability and location, and the city's pay table. Other modules read them
// through CaptainsService only.
@Module({
  imports: [
    DatabaseModule,
    ValkeyModule,
    SettingsModule,
    FxModule,
    GeoModule,
    LedgerModule,
    AuditModule,
    ContentModule,
  ],
  controllers: [CaptainAvailabilityController],
  providers: [CaptainsService, LivePositions],
  exports: [CaptainsService],
})
export class CaptainsModule {}

// The worker role's upkeep of the captains module: the locations' monthly
// partitions.
@Module({ imports: [DatabaseModule], providers: [LocationPartitions] })
export class CaptainsWorkerModule {}

export type { Availability, CaptainStatus, NoOffersReason, OnlineBlock } from './availability.js';
export { orderPay, type PayParts, type PayRate } from './pay.js';
export {
  type ActiveOrderLookup,
  type Candidate,
  type Captain,
  type CaptainChange,
  type CaptainState,
  type CaptainsRefusal,
  CaptainsRefusedError,
  CaptainsService,
  type Custody,
  type IneligibleReason,
  type LocationPoint,
  type Money,
  type NewCaptain,
  type PayTable,
} from './captains.service.js';
