import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { SettingsModule } from '../settings/index.js';
import { FxService } from './fx.service.js';

// The fx module (architecture §4.2): currencies, a city's base and accepted
// currencies, rate versions, rounding and the rate snapshot an order keeps
// (AP §8.6). Other modules use FxService and the conversion functions only.
@Module({
  imports: [DatabaseModule, SettingsModule, AuditModule],
  providers: [FxService],
  exports: [FxService],
})
export class FxModule {}

export {
  equivalent,
  type Rate,
  type RateInput,
  type RateSnapshot,
  type RoundingMode,
  roundToUnit,
  type SnapshotCurrency,
  toBase,
} from './conversion.js';
export {
  type CityAmountSource,
  type CityCurrency,
  type Currency,
  type CurrentRate,
  type FxChange,
  type FxExecutor,
  type FxRefusal,
  FxRefusedError,
  FxService,
} from './fx.service.js';
