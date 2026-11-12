import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { CaptainsModule } from '../captains/index.js';
import { ContentModule } from '../content/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule } from '../identity/index.js';
import { LedgerModule } from '../ledger/index.js';
import { NotificationsModule } from '../notifications/index.js';
import { OrderingModule } from '../ordering/index.js';
import { AdminCashDeskController } from './admin-cash-desk.controller.js';
import { CaptainCustodyController } from './captain-custody.controller.js';
import { CashDeskService } from './cashdesk.service.js';

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
  ],
  controllers: [AdminCashDeskController, CaptainCustodyController],
  providers: [CashDeskService],
  exports: [CashDeskService],
})
export class CashDeskModule {}

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
