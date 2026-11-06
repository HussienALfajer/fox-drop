import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule } from '../identity/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { CustomerProfileController } from './customer-profile.controller.js';
import { CustomersService } from './customers.service.js';

// The customers module (architecture §4.2): the customers' profiles and
// saved addresses. Other modules read them through CustomersService only.
@Module({
  imports: [DatabaseModule, GeoModule, MerchantsModule, IdentityModule],
  controllers: [CustomerProfileController],
  providers: [CustomersService],
  exports: [CustomersService],
})
export class CustomersModule {}

export {
  type Address,
  type AddressFields,
  type CustomersRefusal,
  CustomersRefusedError,
  CustomersService,
  type Location,
  type Profile,
} from './customers.service.js';
