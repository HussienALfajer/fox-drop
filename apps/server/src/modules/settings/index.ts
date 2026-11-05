import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { ValkeyModule } from '../../valkey/valkey.module.js';
import { AuditModule } from '../audit/index.js';
import { SettingsController } from './settings.controller.js';
import { SettingsService } from './settings.service.js';

// The settings module (architecture §4.2): the typed settings of AP §4.4 and
// Appendix A, and the settings screens of AP §9.14. Other modules read them
// through SettingsService only.
@Module({
  imports: [DatabaseModule, ValkeyModule, AuditModule],
  controllers: [SettingsController],
  providers: [SettingsService],
  exports: [SettingsService],
})
export class SettingsModule {}

export {
  adminRoles,
  type AdminRole,
  type SettingKey,
  type SettingValue,
  type Vehicle,
  vehicles,
} from './catalogue.js';
export {
  lockCityCurrencies,
  SettingRefusedError,
  SettingsService,
  type CityCurrencySource,
  type SettingChange,
  type SettingRefusal,
  type SettingTarget,
} from './settings.service.js';
