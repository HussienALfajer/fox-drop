import { Module } from '@nestjs/common';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { SettingsModule } from '../settings/index.js';
import { CustomerQuoteController } from './customer-quote.controller.js';
import { QuoteService } from './quote.service.js';

// The ordering module (architecture §4.2): so far the quote (CU §10.6); the
// order, its state machine and outcomes join with slice 1.8 onwards.
@Module({
  imports: [SettingsModule, FxModule, GeoModule, MerchantsModule],
  controllers: [CustomerQuoteController],
  providers: [QuoteService],
  exports: [QuoteService],
})
export class OrderingModule {}

export { estimateRange, tripMinutes } from './delivery-estimate.js';
export {
  type Quote,
  type QuoteProblem,
  type QuoteProblemCode,
  type QuoteRefusal,
  QuoteRefusedError,
  type QuoteRequest,
  QuoteService,
} from './quote.service.js';
export type { CartLine, PricedLine, QuoteMoney } from './quote.js';
