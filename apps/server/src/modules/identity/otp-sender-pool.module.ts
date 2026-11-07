import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { ValkeyModule } from '../../valkey/valkey.module.js';
import { AuditModule } from '../audit/index.js';
import { SettingsModule } from '../settings/index.js';
import { OtpSenderPoolService } from './otp-sender-pool.service.js';
import { IDENTITY_SECRETS, identitySecretsFromEnvironment } from './secrets.js';

// The sender pool's read alone, for the worker's alerts (AP §9.1.3): the
// numbers' health without the API's routes.
@Module({
  imports: [DatabaseModule, ValkeyModule, SettingsModule, AuditModule],
  providers: [
    { provide: IDENTITY_SECRETS, useFactory: identitySecretsFromEnvironment },
    OtpSenderPoolService,
  ],
  exports: [OtpSenderPoolService],
})
export class OtpSenderPoolModule {}
