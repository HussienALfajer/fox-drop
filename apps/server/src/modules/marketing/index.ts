import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { ContentModule } from '../content/index.js';
import { FilesModule } from '../files/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule } from '../identity/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { NotificationsModule } from '../notifications/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminBannersController } from './admin-banners.controller.js';
import { AdminCompensationsController } from './admin-compensations.controller.js';
import { AdminHomeSectionsController } from './admin-home-sections.controller.js';
import { AdminMassPushesController } from './admin-mass-pushes.controller.js';
import { AdminPromoCodesController } from './admin-promo-codes.controller.js';
import { BannersService } from './banners.service.js';
import { CompensationsService } from './compensations.service.js';
import { HomeSectionsService } from './home-sections.service.js';
import { LateCodesService } from './late-codes.service.js';
import { MassPushesService } from './mass-pushes.service.js';
import { PromoCodeUsesService } from './promo-code-uses.service.js';
import { PromoCodesService } from './promo-codes.service.js';

// The marketing module (architecture §4.2): promo codes «أكواد الخصم»
// (AP §9.11.1, slice 2.21a), their use in orders (slice 2.21b), and picking
// them, «أكوادي» and the code report (slice 2.21d), and «تعويض الزبون»
// with its caps and approvals (slice 2.22a), the late code (slice 2.22c),
// the home sections (slice 2.27b), the banners (slice 2.27c) and the mass
// pushes (slice 2.27d).
@Module({
  imports: [
    DatabaseModule,
    AuditModule,
    ContentModule,
    FilesModule,
    FxModule,
    GeoModule,
    IdentityModule,
    MerchantsModule,
    NotificationsModule,
    SettingsModule,
  ],
  controllers: [
    AdminPromoCodesController,
    AdminCompensationsController,
    AdminHomeSectionsController,
    AdminBannersController,
    AdminMassPushesController,
  ],
  providers: [
    PromoCodesService,
    PromoCodeUsesService,
    CompensationsService,
    LateCodesService,
    HomeSectionsService,
    BannersService,
    MassPushesService,
  ],
  exports: [
    PromoCodeUsesService,
    CompensationsService,
    LateCodesService,
    HomeSectionsService,
    BannersService,
    MassPushesService,
  ],
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
  type PersonalCodeOrigin,
  type PreparedCompensation,
  WRONG_CHANGE_COMPENSATION,
} from './compensations.service.js';
export { type Banner, BannersService, HOME_BANNERS_MAX } from './banners.service.js';
export {
  type MassPushAudience,
  type MassPushAudienceSource,
  MassPushesService,
} from './mass-pushes.service.js';
export {
  BUILT_IN_SECTIONS,
  type HomeSection,
  HomeSectionsService,
} from './home-sections.service.js';
export {
  type LateCode,
  type LateCodeOrder,
  LateCodesService,
  type LateCodeSkip,
} from './late-codes.service.js';
export {
  PromoCodeUsesService,
  type CustomerCodeUse,
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
