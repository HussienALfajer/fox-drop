import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { CaptainsModule } from '../captains/index.js';
import { ContentModule } from '../content/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule } from '../identity/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { LedgerModule } from '../ledger/index.js';
import { NotificationsModule } from '../notifications/index.js';
import { OrderingModule } from '../ordering/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminCashDeskController } from './admin-cash-desk.controller.js';
import { AdminRestaurantSettlementController } from './admin-restaurant-settlement.controller.js';
import { CaptainCustodyController } from './captain-custody.controller.js';
import { CaptainEarningsController } from './captain-earnings.controller.js';
import { CaptainStatementsController } from './captain-statements.controller.js';
import { CashDeskService } from './cashdesk.service.js';
import { EarningsService } from './earnings.service.js';
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
  ],
  controllers: [
    AdminCashDeskController,
    AdminRestaurantSettlementController,
    CaptainCustodyController,
    CaptainEarningsController,
    CaptainStatementsController,
  ],
  providers: [CashDeskService, EarningsService, SettlementService, MerchantStatementsService],
  exports: [CashDeskService, SettlementService],
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
