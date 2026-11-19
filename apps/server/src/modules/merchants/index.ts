import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { ContentModule } from '../content/index.js';
import { FilesModule } from '../files/index.js';
import { JobsModule } from '../../jobs/jobs.module.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { SettingsModule } from '../settings/index.js';
import {
  AdminRestaurantDraftsController,
  AdminRestaurantProfileController,
} from './admin-restaurant-drafts.controller.js';
import { AdminRestaurantAccountController } from './admin-restaurant-account.controller.js';
import { AdminRestaurantActivationController } from './admin-restaurant-activation.controller.js';
import { ActivationService } from './activation.service.js';
import { AdminRestaurantMenuController } from './admin-restaurant-menu.controller.js';
import { AdminRestaurantImagesController } from './admin-restaurant-images.controller.js';
import { AdminRestaurantStatusController } from './admin-restaurant-status.controller.js';
import { MerchantMenuController } from './merchant-menu.controller.js';
import { MenuEditorService } from './menu-editor.service.js';
import { MerchantsService } from './merchants.service.js';
import { RestaurantDraftsService } from './restaurant-drafts.service.js';
import { RestaurantStatusService } from './restaurant-status.service.js';
import { RestaurantStatusTimersWorker } from './status-timers.js';
import { MerchantStatusController } from './merchant-status.controller.js';

// The merchants module (architecture §4.2): restaurants, their hours, states,
// coverage, commission and menu. Other modules read them through
// MerchantsService only.
@Module({
  imports: [
    DatabaseModule,
    JobsModule,
    SettingsModule,
    FxModule,
    GeoModule,
    AuditModule,
    FilesModule,
    ContentModule,
  ],
  controllers: [
    MerchantMenuController,
    MerchantStatusController,
    AdminRestaurantImagesController,
    AdminRestaurantStatusController,
    AdminRestaurantDraftsController,
    AdminRestaurantProfileController,
    AdminRestaurantMenuController,
    AdminRestaurantActivationController,
    AdminRestaurantAccountController,
  ],
  providers: [
    MerchantsService,
    RestaurantStatusService,
    RestaurantDraftsService,
    MenuEditorService,
    ActivationService,
  ],
  exports: [MerchantsService, RestaurantStatusService, RestaurantDraftsService],
})
export class MerchantsModule {}

// The worker runs the restaurant status timers (status-timers.ts).
@Module({
  imports: [MerchantsModule, JobsModule],
  providers: [RestaurantStatusTimersWorker],
})
export class MerchantsWorkerModule {}

export type { CommissionVersion } from './commission.js';
// A restaurant's week uses geo's weekly hours.
export type { OpeningPeriod } from '../geo/index.js';
export type { AccountStatus, OperatingState, PauseSource } from './operating-state.js';
export { seenByCustomer, takesOrders } from './operating-state.js';
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
  type RestaurantListRow,
  type StorefrontState,
  type SwitchedOff,
} from './merchants.service.js';
export {
  type BusyReminderJob,
  type PauseEndJob,
  type RelayedStateChange,
  type RestaurantStatus,
  RestaurantStatusService,
} from './restaurant-status.service.js';
export { type StateKind, stateKinds } from './state-events.js';
export {
  type DraftBasics,
  type DraftLocation,
  type DraftOperations,
  type DraftSteps,
  type DraftSummary,
  type RestaurantDraft,
  RestaurantDraftsService,
} from './restaurant-drafts.service.js';
