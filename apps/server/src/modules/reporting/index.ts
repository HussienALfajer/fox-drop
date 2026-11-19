import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { JobsModule } from '../../jobs/jobs.module.js';
import { AuditModule } from '../audit/index.js';
import { CaptainsModule } from '../captains/index.js';
import { CashDeskPeriodModule } from '../cashdesk/index.js';
import { FilesModule } from '../files/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { LedgerModule } from '../ledger/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { OrderingModule } from '../ordering/index.js';
import { SettingsModule } from '../settings/index.js';
import { MarketingModule } from '../marketing/index.js';
import { AdminCostReportController } from './admin-cost-report.controller.js';
import { AdminDailyReportController } from './admin-daily-report.controller.js';
import { AdminExportsController } from './admin-exports.controller.js';
import { AdminRestaurantListController } from './admin-restaurant-list.controller.js';
import { AdminRestaurantProfileReadsController } from './admin-restaurant-profile.controller.js';
import { AdminRestaurantStatementsController } from './admin-restaurant-statements.controller.js';
import { RestaurantListService } from './restaurant-list.service.js';
import { ContentModule } from '../content/index.js';
import { IdentityModule } from '../identity/index.js';
import { CostReportService } from './cost-report.service.js';
import { DailyReportService } from './daily-report.service.js';
import { ExportsService } from './exports.service.js';
import { ExportsWorker } from './exports.worker.js';

const imports = [
  DatabaseModule,
  JobsModule,
  AuditModule,
  CashDeskPeriodModule,
  FilesModule,
  FxModule,
  GeoModule,
  MerchantsModule,
  LedgerModule,
  MarketingModule,
  OrderingModule,
  CaptainsModule,
  SettingsModule,
];

// The reporting module (architecture §4.2): statements and exports. Slice
// 2.19g: «كشوف المطاعم» (AP §9.10.5) and the Excel exports (§5.9); slice
// 2.20d: «التقرير اليومي» (AP §9.10.1); slice 2.22d: «كلفة التعويضات
// والخصومات» (AP §9.10.6).
@Module({
  imports: [...imports, ContentModule, IdentityModule],
  controllers: [
    AdminRestaurantListController,
    AdminRestaurantProfileReadsController,
    AdminRestaurantStatementsController,
    AdminDailyReportController,
    AdminCostReportController,
    AdminExportsController,
  ],
  providers: [ExportsService, DailyReportService, CostReportService, RestaurantListService],
})
export class ReportingModule {}

// The worker's export jobs: writing each export, removing it after 24 hours.
@Module({
  imports,
  providers: [ExportsService, DailyReportService, CostReportService, ExportsWorker],
})
export class ReportingWorkerModule {}
