import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminPromoCodesController } from './admin-promo-codes.controller.js';
import { PromoCodeUsesService } from './promo-code-uses.service.js';
import { PromoCodesService } from './promo-codes.service.js';

// The marketing module (architecture §4.2): promo codes «أكواد الخصم»
// (AP §9.11.1, slice 2.21a) and their use in orders (slice 2.21b). Banners, home sections and mass pushes come
// with 2.27.
@Module({
  imports: [DatabaseModule, AuditModule, FxModule, GeoModule, MerchantsModule, SettingsModule],
  controllers: [AdminPromoCodesController],
  providers: [PromoCodesService, PromoCodeUsesService],
  exports: [PromoCodeUsesService],
})
export class MarketingModule {}

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
  promoDiscount,
  type PromoDiscount,
  suggestedCode,
} from './promo-codes.js';
