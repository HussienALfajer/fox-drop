import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { LedgerModule } from '../ledger/index.js';
import { SettingsModule } from '../settings/index.js';
import { CaptainsService } from './captains.service.js';

// The captains module (architecture §4.2): the captain record, its cash
// limit and availability, and the city's pay table. Other modules read them
// through CaptainsService only.
@Module({
  imports: [DatabaseModule, SettingsModule, FxModule, GeoModule, LedgerModule, AuditModule],
  providers: [CaptainsService],
  exports: [CaptainsService],
})
export class CaptainsModule {}

export type {
  Availability,
  CaptainStatus,
  NoOffersReason,
  OnlineBlock,
} from './availability.js';
export { orderPay, type PayRate } from './pay.js';
export {
  type Captain,
  type CaptainChange,
  type CaptainState,
  type CaptainsRefusal,
  CaptainsRefusedError,
  CaptainsService,
  type Custody,
  type Money,
  type NewCaptain,
  type PayTable,
} from './captains.service.js';
