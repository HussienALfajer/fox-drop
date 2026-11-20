import { SupportModule, SupportWorkerModule } from '../support/index.js';
import { AdminOrderTicketsController } from './admin-order-tickets.controller.js';
import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { JobsModule } from '../../jobs/jobs.module.js';
import { CaptainsModule } from '../captains/index.js';
import { CustomersModule } from '../customers/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { FilesModule } from '../files/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { NotificationsModule, NotificationsWorkerModule } from '../notifications/index.js';
import { ContentModule } from '../content/index.js';
import { SettingsModule } from '../settings/index.js';
import { AuditModule } from '../audit/index.js';
import { ActiveOrders } from './active-orders.js';
import { AppHistories } from './app-histories.js';
import { CaptainOrders } from './captain-orders.js';
import { CaptainOrdersController } from './captain-orders.controller.js';
import { DeliveryBooking } from './delivery-booking.js';
import { PickupBooking, PickupTimersWorker } from './pickup-booking.js';
import { PickupCommands } from './pickup-commands.js';
import { PickupCorrections } from './pickup-corrections.js';
import { TicketMoney } from './ticket-orders.js';
import { IdentityModule } from '../identity/index.js';
import { MarketingModule } from '../marketing/index.js';
import { LedgerModule } from '../ledger/index.js';
import { AdminOrderCompensationsController } from './admin-order-compensations.controller.js';
import { AdminOrdersController } from './admin-orders.controller.js';
import { CustomerOrdersController } from './customer-orders.controller.js';
import { CustomerCodesController } from './customer-codes.controller.js';
import { CustomerQuoteController } from './customer-quote.controller.js';
import { CaptainTicketsController } from './captain-reports.controller.js';
import { MerchantTicketsController } from './merchant-reports.controller.js';
import { MerchantOrdersController } from './merchant-orders.controller.js';
import { OrderAlerts, OrderAlertsWorker } from './order-alerts.js';
import { OrderChannelAccess } from './order-channel.js';
import {
  CaptainOrderRouteController,
  CustomerOrderRouteController,
} from './order-routes.controller.js';
import { OrderRoutes } from './order-routes.js';
import { OrderAssignmentsModule } from './order-assignments.js';
import { OrderCommands } from './order-commands.js';
import { OrderPartitions } from './order-partitions.js';
import { OrderTimers, OrderTimersWorker } from './order-timers.js';
import { OperationsViews } from './operations-views.js';
import { OrdersService } from './orders.service.js';
export type { OrderView } from './order-views.js';
import { OutboxPushes, OutboxPushesWorker } from './outbox-pushes.js';
import { OutboxRelay, OutboxRelayWorker } from './outbox-relay.js';
import { QuoteService } from './quote.service.js';
import { ResendNotification } from './resend-notification.js';
import { EmergencyStops, EmergencyStopWorker } from './emergency-stop.js';
import { RatingsService } from './ratings.js';
import { AdminRatingsController } from './admin-ratings.controller.js';
import { CaptainRatingsController } from './captain-ratings.controller.js';
import { MerchantRatingsController } from './merchant-ratings.controller.js';
import { RatingPagesService } from './rating-pages.js';
import { CaptainFiguresService } from './captain-figures.js';
import { RestaurantFiguresService } from './restaurant-figures.js';
import { DashboardOrdersService } from './dashboard-orders.js';
import { AdminRestaurantOverviewController } from './admin-restaurant-overview.controller.js';
import { AdminDeliveryFeesController } from './admin-delivery-fees.controller.js';
import { AdminPayTablesController } from './admin-pay-tables.controller.js';
import { AdminSearchController } from './admin-search.controller.js';
import { AdminSearch } from './admin-search.js';
import { OrderHistoryService } from './order-history.js';
import { AdminOrderHistoryController } from './admin-order-history.controller.js';
import {
  AdminEmergencyStopController,
  CaptainEmergencyStopController,
  CustomerEmergencyStopController,
  MerchantEmergencyStopController,
} from './emergency-stop.controller.js';

// The ordering module (architecture §4.2): the quote (CU §10.6), the order
// (CU §10.7), the restaurant's acceptance and «الطلب جاهز» (RA §8.5–8.8) and
// its real-time channel (architecture §6.2); the rest of its state machine and
// its outcomes join with slice 1.11 onwards.
@Module({
  imports: [
    DatabaseModule,
    JobsModule,
    AuditModule,
    LedgerModule,
    IdentityModule,
    MarketingModule,
    SettingsModule,
    ContentModule,
    FxModule,
    GeoModule,
    MerchantsModule,
    CustomersModule,
    CaptainsModule,
    NotificationsModule,
    OrderAssignmentsModule,
    SupportModule,
    FilesModule,
  ],
  controllers: [
    CustomerQuoteController,
    CustomerOrdersController,
    MerchantOrdersController,
    MerchantTicketsController,
    CaptainTicketsController,
    AdminOrdersController,
    AdminOrderCompensationsController,
    AdminOrderTicketsController,
    CaptainOrdersController,
    AdminEmergencyStopController,
    CustomerEmergencyStopController,
    MerchantEmergencyStopController,
    CaptainEmergencyStopController,
    CustomerCodesController,
    MerchantRatingsController,
    CaptainRatingsController,
    AdminRatingsController,
    AdminRestaurantOverviewController,
    AdminDeliveryFeesController,
    AdminPayTablesController,
    AdminSearchController,
    AdminOrderHistoryController,
    CaptainOrderRouteController,
    CustomerOrderRouteController,
  ],
  providers: [
    ActiveOrders,
    QuoteService,
    OrdersService,
    OrderCommands,
    OrderTimers,
    OrderChannelAccess,
    OperationsViews,
    CaptainOrders,
    PickupBooking,
    PickupCommands,
    PickupCorrections,
    TicketMoney,
    DeliveryBooking,
    ResendNotification,
    EmergencyStops,
    RatingsService,
    RatingPagesService,
    OrderRoutes,
    RestaurantFiguresService,
    CaptainFiguresService,
    DashboardOrdersService,
    AdminSearch,
    AppHistories,
    OrderHistoryService,
  ],
  exports: [
    QuoteService,
    OrdersService,
    RestaurantFiguresService,
    CaptainFiguresService,
    DashboardOrdersService,
    AppHistories,
    OrderHistoryService,
  ],
})
export class OrderingModule {}

// The worker keeps the orders' monthly partitions a month ahead, runs their
// timers (AP §8.3), syncs their alerts (AP §9.1.3) and relays the outbox
// (architecture §5.5).
@Module({
  imports: [
    DatabaseModule,
    JobsModule,
    LedgerModule,
    MarketingModule,
    NotificationsWorkerModule,
    SupportWorkerModule,
    ContentModule,
    CaptainsModule,
    SettingsModule,
    FxModule,
    GeoModule,
    MerchantsModule,
    AuditModule,
  ],
  providers: [
    OrderAlerts,
    OrderAlertsWorker,
    OrderPartitions,
    OrderTimers,
    OrderTimersWorker,
    PickupBooking,
    PickupTimersWorker,
    OutboxRelay,
    OutboxRelayWorker,
    OutboxPushes,
    OutboxPushesWorker,
    EmergencyStops,
    EmergencyStopWorker,
  ],
})
export class OrderingWorkerModule {}

export {
  type AssignmentActor,
  type AssignmentChange,
  type DispatchView,
  type HandoverCloseReason,
  type ManualReason,
  type OpenHandover,
  type DispatchOrder,
  OrderAssignments,
  OrderAssignmentsModule,
} from './order-assignments.js';
export {
  type DeliveredTotals,
  type OrderPayParts,
  type OrderPickup,
  type OrderRefusal,
  OrderRefusedError,
  OrdersService,
  type PlaceOrder,
  type RestaurantPickup,
} from './orders.service.js';
export {
  type PricedQuote,
  type Quote,
  type QuoteProblem,
  type QuoteProblemCode,
  type QuoteRefusal,
  QuoteRefusedError,
  type QuoteRequest,
  QuoteService,
} from './quote.service.js';
export type { CartLine, PricedLine, QuoteMoney } from './quote.js';
export { HANDOVER_FROM } from './handover.js';
export {
  AppHistories,
  type CaptainHistoryRow,
  captainSteps,
  HISTORY_PAGE,
  HistoryRefusedError,
} from './app-histories.js';
export { type RestaurantFigures, RestaurantFiguresService } from './restaurant-figures.js';
export {
  ADMIN_HISTORY_EXPORT_MAX,
  type AdminHistoryFilter,
  type AdminHistoryRow,
  type CorrectionTarget,
  FINISHED_STATUSES,
  type HistoryFilterRefusal,
  type HistoryKind,
  historyKinds,
  orderHistoryFilterBody,
  type OrderHistoryFilterBody,
  OrderHistoryService,
} from './order-history.js';
export { type CaptainFigures, CaptainFiguresService, ON_TIME_WINDOW } from './captain-figures.js';
export { type DashboardOrderRow, DashboardOrdersService } from './dashboard-orders.js';
export {
  type CostOrder,
  type OperatingCostCause,
  operatingCostCause,
  operatingCostCauses,
} from './platform-costs.js';
export {
  type MerchantEntryCause,
  merchantEntryCause,
  merchantEntryCauses,
} from './merchant-causes.js';
