import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { CaptainsModule } from '../captains/index.js';
import { ContentModule } from '../content/index.js';
import { CustomersModule } from '../customers/index.js';
import { FilesModule } from '../files/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule } from '../identity/index.js';
import { MarketingModule } from '../marketing/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { NotificationsModule, NotificationsWorkerModule } from '../notifications/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminTicketsController } from './admin-tickets.controller.js';
import { CustomerPriceReportsController } from './customer-price-reports.controller.js';
import { SupportService } from './support.service.js';
import { TicketSync } from './ticket-sync.js';

// The support module (architecture §4.2): tickets «الدعم» (AP §9.9; slice
// 2.23a: manual tickets, their list, page, notes, assignee, status, SLA
// timers and the alert «تذكرة عاجلة»). Compensation lives in marketing.
@Module({
  imports: [
    DatabaseModule,
    AuditModule,
    ContentModule,
    SettingsModule,
    NotificationsModule,
    IdentityModule,
    CaptainsModule,
    MerchantsModule,
    CustomersModule,
    MarketingModule,
    FilesModule,
    FxModule,
    GeoModule,
  ],
  controllers: [AdminTicketsController, CustomerPriceReportsController],
  providers: [SupportService, TicketSync],
  exports: [SupportService, TicketSync],
})
export class SupportModule {}

// The worker's side: ordering's alerts sync tells it when an order ends.
@Module({
  imports: [DatabaseModule, NotificationsWorkerModule, AuditModule],
  providers: [TicketSync],
  exports: [TicketSync],
})
export class SupportWorkerModule {}

export {
  type CustomerReport,
  type CustomerReportView,
  type OpenTicket,
  type ReportedOrder,
  type ReportingCustomer,
  type Ticket,
  type TicketAdmin,
  type TicketOrder,
  openingHash,
  TicketRefusedError,
  SupportService,
} from './support.service.js';
export {
  type CorrectionEntry,
  type MoneyLine,
  type PickupCorrectionPreview,
  type PickupDisputeFacts,
  type PickupDisputes,
} from './pickup-disputes.js';
export {
  type AffectedLine,
  type StoredAffectedLine,
  type TicketMoneyInput,
  type TicketMoneyPreview,
  type TicketOrderFacts,
  type TicketOrders,
  type TicketRedelivery,
} from './ticket-orders.js';
export { TicketSync } from './ticket-sync.js';
export {
  answered as ticketAnswered,
  openTicketFields,
  ticketAdminOf,
  ticketBody,
  ticketOut,
} from './ticket-body.js';
export { type TicketParty } from './tickets.js';
