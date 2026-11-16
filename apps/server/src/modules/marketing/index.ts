import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { ContentModule } from '../content/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule } from '../identity/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { NotificationsModule } from '../notifications/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminCompensationsController } from './admin-compensations.controller.js';
import { AdminPromoCodesController } from './admin-promo-codes.controller.js';
import { CompensationsService } from './compensations.service.js';
import { PromoCodeUsesService } from './promo-code-uses.service.js';
import { PromoCodesService } from './promo-codes.service.js';

// The marketing module (architecture §4.2): promo codes «أكواد الخصم»
// (AP §9.11.1, slice 2.21a), their use in orders (slice 2.21b), and picking
// them, «أكوادي» and the code report (slice 2.21d), and «تعويض الزبون»
// with its caps and approvals (slice 2.22a). Banners, home sections
// and mass pushes come with 2.27.
@Module({
  imports: [
    DatabaseModule,
    AuditModule,
    ContentModule,
    FxModule,
    GeoModule,
    IdentityModule,
    MerchantsModule,
    NotificationsModule,
    SettingsModule,
  ],
  controllers: [AdminPromoCodesController, AdminCompensationsController],
  providers: [PromoCodesService, PromoCodeUsesService, CompensationsService],
  exports: [PromoCodeUsesService, CompensationsService],
})
export class MarketingModule {}

export { adminOf as compensationAdminOf } from './admin-compensations.controller.js';
export {
  compensationAdmins,
  compensationBody,
  compensationOut,
  compensationValue,
  compensationValueBody,
} from './compensation-body.js';
export {
  type Compensation,
  type CompensationAdmin,
  type CompensationOrder,
  CompensationRefusedError,
  CompensationsService,
  type CompensationValue,
  type PreparedCompensation,
} from './compensations.service.js';
export {
  PromoCodeUsesService,
  type AppliedCode,
  type CodeCart,
  type CodeCheck,
  type CodeClock,
  type HeldCode,
} from './promo-code-uses.service.js';
export {
  type AvailableCode,
  type CodeRefusal,
  type CodeTerms,
  fixedAmountAboveItems,
  type MyCode,
  promoDiscount,
  type PromoDiscount,
  suggestedCode,
} from './promo-codes.js';
