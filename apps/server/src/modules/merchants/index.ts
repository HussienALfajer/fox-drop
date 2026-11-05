import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { MerchantsService } from './merchants.service.js';

// The merchants module (architecture §4.2): restaurants, their hours, states,
// coverage, commission and menu. Other modules read them through
// MerchantsService only.
@Module({
  imports: [DatabaseModule, FxModule, GeoModule, AuditModule],
  providers: [MerchantsService],
  exports: [MerchantsService],
})
export class MerchantsModule {}

export type { CommissionVersion } from './commission.js';
export type { OpeningPeriod } from './hours.js';
export type { AccountStatus, OperatingState, PauseSource } from './operating-state.js';
export { takesOrders } from './operating-state.js';
export {
  type Coverage,
  type MerchantChange,
  type MerchantsRefusal,
  MerchantsRefusedError,
  MerchantsService,
  type Menu,
  type MenuCategory,
  type MenuItem,
  type MenuOption,
  type MenuOptionGroup,
  type Money,
  type NewRestaurant,
  type Restaurant,
} from './merchants.service.js';
