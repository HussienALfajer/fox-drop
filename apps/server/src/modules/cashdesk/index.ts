import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { CaptainsModule } from '../captains/index.js';
import { ContentModule } from '../content/index.js';
import { CustomersModule } from '../customers/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule } from '../identity/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { LedgerModule } from '../ledger/index.js';
import { NotificationsModule } from '../notifications/index.js';
import { OrderingModule } from '../ordering/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminCashDeskController } from './admin-cash-desk.controller.js';
import { AdminCustomerDuesController } from './admin-customer-dues.controller.js';
import { AdminExchangeRatesController } from './admin-exchange-rates.controller.js';
import { AdminRestaurantSettlementController } from './admin-restaurant-settlement.controller.js';
import { AdminRestaurantTerminationController } from './admin-restaurant-termination.controller.js';
import { RestaurantTerminationService } from './restaurant-termination.service.js';
import { CaptainCustodyController } from './captain-custody.controller.js';
import { CaptainEarningsController } from './captain-earnings.controller.js';
import { CaptainHistoryController } from './captain-history.controller.js';
import { CaptainStatementsController } from './captain-statements.controller.js';
import {
  AdminManualEntriesController,
  AdminOrderCorrectionsController,
} from './admin-manual-entries.controller.js';
import { CashDeskService } from './cashdesk.service.js';
import { DepositsService } from './deposits.service.js';
import { CustomerDuesService } from './customer-dues.service.js';
import { ManualEntriesService } from './manual-entries.service.js';
import { EarningsService } from './earnings.service.js';
import { MerchantAccountController } from './merchant-account.controller.js';
import { MerchantAccountService } from './merchant-account.service.js';
import { MerchantRecordsController } from './merchant-records.controller.js';
import { MerchantRecordsService } from './merchant-records.service.js';
import { MerchantStatementReads } from './merchant-statement-reads.js';
import { MerchantPeriodService } from './merchant-period.service.js';
import { MerchantSettlementService } from './merchant-settlement.service.js';
import { MerchantStatementsService } from './merchant-statements.service.js';
import { MerchantStatementsWorker } from './merchant-statements.worker.js';
import { SettlementService } from './settlement.service.js';

// The cashdesk module (architecture §4.2): drawer sessions, receipts and the
// desk's transactions (AP §9.10.3). Its money moves through the ledger.
@Module({
  imports: [
    DatabaseModule,
    AuditModule,
    LedgerModule,
    CaptainsModule,
    FxModule,
    GeoModule,
    IdentityModule,
    ContentModule,
    NotificationsModule,
    OrderingModule,
    SettingsModule,
    MerchantsModule,
    CustomersModule,
  ],
  controllers: [
    AdminCashDeskController,
    AdminManualEntriesController,
    AdminOrderCorrectionsController,
    AdminRestaurantSettlementController,
    AdminRestaurantTerminationController,
    AdminCustomerDuesController,
    AdminExchangeRatesController,
    CaptainCustodyController,
    CaptainEarningsController,
    CaptainHistoryController,
    CaptainStatementsController,
    MerchantAccountController,
    MerchantRecordsController,
  ],
  providers: [
    CashDeskService,
    EarningsService,
    MerchantAccountService,
    MerchantRecordsService,
    MerchantStatementReads,
    SettlementService,
    MerchantStatementsService,
    MerchantSettlementService,
    ManualEntriesService,
    CustomerDuesService,
    DepositsService,
    RestaurantTerminationService,
  ],
  exports: [CashDeskService, SettlementService, EarningsService],
})
export class CashDeskModule {}

// The worker's sweep of the restaurants' weekly statements (AP §8.7, slice
// 2.19a): at the settlement day's cutoff, each restaurant's statement.
@Module({
  imports: [
    DatabaseModule,
    LedgerModule,
    FxModule,
    GeoModule,
    ContentModule,
    NotificationsModule,
    OrderingModule,
    SettingsModule,
    MerchantsModule,
  ],
  providers: [MerchantStatementsService, MerchantStatementsWorker],
})
export class CashDeskWorkerModule {}

// A restaurant's statement for any period (AP §9.10.5, slice 2.19g) and the
// restaurants' balances and overdue settlements (the daily report, AP
// §9.10.1, slice 2.20d), for the reporting module's screens and Excel
// exports, in the API and the worker; and a restaurant's weekly statement
// for the owner web portal's Excel export (slice 2.45d).
@Module({
  imports: [
    DatabaseModule,
    LedgerModule,
    FxModule,
    GeoModule,
    ContentModule,
    NotificationsModule,
    OrderingModule,
    SettingsModule,
    MerchantsModule,
    IdentityModule,
  ],
  providers: [MerchantPeriodService, MerchantStatementsService, MerchantStatementReads],
  exports: [MerchantPeriodService, MerchantStatementsService, MerchantStatementReads],
})
export class CashDeskPeriodModule {}

export {
  type BalanceRow,
  type CashDeskRefusal,
  CashDeskRefusedError,
  CashDeskService,
  type CashLine,
  type Conversion,
  type ConversionQuote,
  type DeskUser,
  type DrawerSession,
  type Receipt,
  type ReceiptType,
} from './cashdesk.service.js';
export {
  isDay,
  MerchantPeriodService,
  PERIOD_MAX_DAYS,
  periodFits,
  type PeriodReceipt,
  type PeriodStatementLine,
  type RestaurantPeriodStatement,
} from './merchant-period.service.js';
export {
  type MerchantReceipt,
  type MerchantSettleCommand,
  type MerchantSettlementPreview,
  MerchantSettlementService,
} from './merchant-settlement.service.js';
export { type ExceptionCause } from './merchant-statement.js';
export {
  type Decider,
  type MerchantStatementRead,
  MerchantStatementReads,
} from './merchant-statement-reads.js';
export { merchantExceptionCauses, merchantStatementLineKinds } from './schema.js';
export {
  type MerchantStatement,
  type MerchantStatementView,
  MerchantStatementsService,
  type RestaurantSettlementList,
  type RestaurantSettlementRow,
} from './merchant-statements.service.js';
export {
  type NegativeEarningsPolicy,
  type PayoutWeekday,
  type SettleCommand,
  type Settlement,
  type SettlementList,
  type SettlementPreview,
  SettlementService,
  type Statement,
} from './settlement.service.js';
export {
  type CaptainEarningsOverview,
  EarningsService,
  type EarningsWindow,
} from './earnings.service.js';
