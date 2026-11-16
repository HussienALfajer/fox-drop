import { Module } from '@nestjs/common';
import { CashDeskPeriodModule } from '../cashdesk/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { AdminRestaurantStatementsController } from './admin-restaurant-statements.controller.js';

// The reporting module (architecture §4.2): statements and exports. Slice
// 2.19g: «كشوف المطاعم» (AP §9.10.5).
@Module({
  imports: [CashDeskPeriodModule, MerchantsModule],
  controllers: [AdminRestaurantStatementsController],
})
export class ReportingModule {}
