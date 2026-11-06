import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { ValkeyModule } from '../../valkey/valkey.module.js';
import { SettingsModule } from '../settings/index.js';
import { OtpSenderService } from './otp-sender.service.js';
import { IDENTITY_SECRETS, identitySecretsFromEnvironment } from './secrets.js';
import { WHATSAPP_CONNECT } from './whatsapp-client.js';

// The otp-sender role (architecture §4.4): the WhatsApp session and the send
// requests of the API. Isolated, so a library crash never affects the API.
@Module({
  imports: [DatabaseModule, ValkeyModule, SettingsModule],
  providers: [
    { provide: IDENTITY_SECRETS, useFactory: identitySecretsFromEnvironment },
    // Loaded only in this role, so the API never loads the library.
    {
      provide: WHATSAPP_CONNECT,
      useFactory: async () => (await import('./whatsapp-baileys.js')).baileysConnect,
    },
    OtpSenderService,
  ],
})
export class OtpSenderModule {}
