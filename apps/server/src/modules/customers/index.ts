import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { ContentModule } from '../content/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule } from '../identity/index.js';
import { LedgerModule } from '../ledger/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminCustomersController } from './admin-customers.controller.js';
import { BrowsingService } from './browsing.service.js';
import { CustomerAccountStateController } from './customer-account-state.controller.js';
import { CustomerAdminService } from './customer-admin.service.js';
import { CustomerBrowsingController } from './customer-browsing.controller.js';
import { CustomerProfileController } from './customer-profile.controller.js';
import { CustomersService } from './customers.service.js';

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
    FxModule,
    AuditModule,
  ],
  controllers: [
    CustomerProfileController,
    CustomerBrowsingController,
    CustomerAccountStateController,
    AdminCustomersController,
  ],
  providers: [CustomersService, BrowsingService, CustomerAdminService],
  exports: [CustomersService],
})
export class CustomersModule {}

export { unsavedAddressFields, withRecipient } from './address-fields.js';
export {
  type ActiveBlock,
  type Address,
  type AddressFields,
  type CustomersRefusal,
  CustomersRefusedError,
  CustomersService,
  customerOrderLock,
  type Location,
  type OrderAddress,
  type Profile,
  type UnsavedAddressFields,
} from './customers.service.js';
export { pointQuery } from './point-query.js';
