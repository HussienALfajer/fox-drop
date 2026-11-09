import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { FilesModule } from '../files/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminRestaurantImagesController } from './admin-restaurant-images.controller.js';
import { MerchantMenuController } from './merchant-menu.controller.js';
import { MerchantsService } from './merchants.service.js';
import { RestaurantStatusService } from './restaurant-status.service.js';
import { MerchantStatusController } from './merchant-status.controller.js';

// The merchants module (architecture §4.2): restaurants, their hours, states,
// coverage, commission and menu. Other modules read them through
// MerchantsService only.
@Module({
  imports: [DatabaseModule, SettingsModule, FxModule, GeoModule, AuditModule, FilesModule],
  controllers: [MerchantMenuController, MerchantStatusController, AdminRestaurantImagesController],
  providers: [MerchantsService, RestaurantStatusService],
  exports: [MerchantsService, RestaurantStatusService],
})
export class MerchantsModule {}

export type { CommissionVersion } from './commission.js';
export { currentPeriod, nextOpening, type OpeningPeriod } from './hours.js';
export type { AccountStatus, OperatingState, PauseSource } from './operating-state.js';
export { takesOrders } from './operating-state.js';
export { devicePlatforms } from './schema.js';
export {
  type ActiveOrderCount,
  type Coverage,
  type DevicePlatform,
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
  type StorefrontState,
  type SwitchedOff,
} from './merchants.service.js';
export { type RestaurantStatus, RestaurantStatusService } from './restaurant-status.service.js';
