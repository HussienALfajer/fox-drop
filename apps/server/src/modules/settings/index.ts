import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { ValkeyModule } from '../../valkey/valkey.module.js';
import { AuditModule } from '../audit/index.js';
import { SettingsService } from './settings.service.js';

// The settings module (architecture §4.2): the typed settings of AP §4.4 and
// Appendix A. Other modules read them through SettingsService only.
@Module({
  imports: [DatabaseModule, ValkeyModule, AuditModule],
  providers: [SettingsService],
  exports: [SettingsService],
})
export class SettingsModule {}

export { adminRoles, type AdminRole, type SettingKey, type SettingValue } from './catalogue.js';
export {
  SettingRefusedError,
  SettingsService,
  type SettingChange,
  type SettingRefusal,
  type SettingTarget,
} from './settings.service.js';
