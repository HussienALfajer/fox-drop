import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminAuthController } from './admin-auth.controller.js';
import { AdminSessionGuard } from './admin-session.guard.js';
import { AdminSessionsService } from './admin-sessions.service.js';
import { AdminSetupService } from './admin-setup.service.js';
import { AdminSignInService } from './admin-sign-in.service.js';
import { IDENTITY_SECRETS, identitySecretsFromEnvironment } from './secrets.js';

// The identity module (architecture §4.2). This slice: the admin panel's
// accounts, first sign-in, sign-in and sessions (AP §5.1–5.3).
@Module({
  imports: [DatabaseModule, AuditModule, SettingsModule],
  controllers: [AdminAuthController],
  providers: [
    { provide: IDENTITY_SECRETS, useFactory: identitySecretsFromEnvironment },
    AdminSetupService,
    AdminSignInService,
    AdminSessionsService,
    AdminSessionGuard,
  ],
  exports: [AdminSessionsService, AdminSessionGuard],
})
export class IdentityModule {}

export { AdminSessionGuard, CurrentAdminSession } from './admin-session.guard.js';
export { AdminSessionsService, type AdminSession } from './admin-sessions.service.js';
