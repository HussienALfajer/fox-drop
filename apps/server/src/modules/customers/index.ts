import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { ContentModule } from '../content/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule } from '../identity/index.js';
import { LedgerModule } from '../ledger/index.js';
import { MarketingModule } from '../marketing/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminCustomersController } from './admin-customers.controller.js';
import { AdminMenuPreviewController } from './admin-menu-preview.controller.js';
import { MerchantMenuPreviewController } from './merchant-menu-preview.controller.js';
import { AdminLostDemandController } from './admin-lost-demand.controller.js';
import { BrowsingService } from './browsing.service.js';
import { CustomerClosureController } from './customer-closure.controller.js';
import { CustomerAccountStateController } from './customer-account-state.controller.js';
import { CustomerAdminService } from './customer-admin.service.js';
import { CustomerBrowsingController } from './customer-browsing.controller.js';
import { CustomerFavouritesController } from './customer-favourites.controller.js';
import { CustomerProfileController } from './customer-profile.controller.js';
import { CustomerSearchController } from './customer-search.controller.js';
import { CustomersService } from './customers.service.js';
import { FavouritesService } from './favourites.js';
import { LostDemandService } from './lost-demand.service.js';
import { MassPushAudienceSource } from './mass-push-audience.js';

// The customers module (architecture §4.2): the customers' profiles and
// saved addresses, and their browsing of the restaurants that deliver to
// them. Other modules read them through CustomersService only.
@Module({
  imports: [
    DatabaseModule,
    SettingsModule,
    GeoModule,
    MerchantsModule,
    IdentityModule,
    ContentModule,
    LedgerModule,
    MarketingModule,
    FxModule,
    AuditModule,
  ],
  controllers: [
    CustomerProfileController,
    CustomerBrowsingController,
    CustomerAccountStateController,
    CustomerClosureController,
    CustomerSearchController,
    CustomerFavouritesController,
    AdminCustomersController,
    AdminMenuPreviewController,
    MerchantMenuPreviewController,
    AdminLostDemandController,
  ],
  providers: [
    CustomersService,
    BrowsingService,
    CustomerAdminService,
    LostDemandService,
    FavouritesService,
    MassPushAudienceSource,
  ],
  exports: [CustomersService],
})
export class CustomersModule {}

export { unsavedAddressFields, withRecipient } from './address-fields.js';
export {
  type ActiveBlock,
  type Address,
  type AddressFields,
  type CustomersRefusal,
  type CustomerTicket,
  type CustomerActiveOrders,
  CustomersRefusedError,
  CustomersService,
  customerOrderLock,
  DEVICE_BLOCK_TEXT,
  lockCustomerDues,
  type CustomerRating,
  type CustomerRatings,
  type Location,
  type OrderAddress,
  type Profile,
  type UnsavedAddressFields,
} from './customers.service.js';
export { maskedPhone } from './blocks.js';
export { pointQuery } from './point-query.js';
export { trustBasis, type TrustMark } from './trust.js';
