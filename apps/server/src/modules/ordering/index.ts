import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { JobsModule } from '../../jobs/jobs.module.js';
import { CaptainsModule } from '../captains/index.js';
import { CustomersModule } from '../customers/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { SettingsModule } from '../settings/index.js';
import { ActiveOrders } from './active-orders.js';
import { CustomerOrdersController } from './customer-orders.controller.js';
import { CustomerQuoteController } from './customer-quote.controller.js';
import { OrderPartitions } from './order-partitions.js';
import { OrderTimers, OrderTimersWorker } from './order-timers.js';
import { OrdersService } from './orders.service.js';
import { QuoteService } from './quote.service.js';

// The ordering module (architecture §4.2): the quote (CU §10.6) and the
// order (CU §10.7); its state machine and outcomes join with slice 1.9
// onwards.
@Module({
  imports: [
    DatabaseModule,
    JobsModule,
    SettingsModule,
    FxModule,
    GeoModule,
    MerchantsModule,
    CustomersModule,
    CaptainsModule,
  ],
  controllers: [CustomerQuoteController, CustomerOrdersController],
  providers: [ActiveOrders, QuoteService, OrdersService, OrderTimers],
  exports: [QuoteService, OrdersService],
})
export class OrderingModule {}

// The worker keeps the orders' monthly partitions a month ahead and runs
// their timers (AP §8.3).
@Module({
  imports: [DatabaseModule, JobsModule],
  providers: [OrderPartitions, OrderTimers, OrderTimersWorker],
})
export class OrderingWorkerModule {}

export {
  type OrderRefusal,
  OrderRefusedError,
  OrdersService,
  type PlacedOrder,
  type PlaceOrder,
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
