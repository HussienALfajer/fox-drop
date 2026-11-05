import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { ValkeyModule } from '../../valkey/valkey.module.js';
import { AuditModule } from '../audit/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminAuthController } from './admin-auth.controller.js';
import { AdminSessionsService } from './admin-sessions.service.js';
import { AdminSetupService } from './admin-setup.service.js';
import { AdminSignInService } from './admin-sign-in.service.js';
import { AdminTeamController } from './admin-team.controller.js';
import { AdminTeamService } from './admin-team.service.js';
import { AppSessionsService } from './app-sessions.service.js';
import { AppSignInService } from './app-sign-in.service.js';
import { AppSigningKeys } from './app-signing-keys.js';
import { CODE_SENDER, codeSenderFromEnvironment } from './code-sender.js';
import { CustomerAuthController } from './customer-auth.controller.js';
import { RouteAccessGuard } from './route-access.guard.js';
import { IDENTITY_SECRETS, identitySecretsFromEnvironment } from './secrets.js';

// The identity module (architecture §4.2). So far: the admin panel's
// accounts, first sign-in, sign-in, sessions, roles and permissions, and the
// admin team (AP §5.1–5.3, §6, §9.15); the apps' phone sign-in, tokens and
// sessions (architecture §8.3, §15.1).
@Module({
  imports: [DatabaseModule, ValkeyModule, AuditModule, SettingsModule],
  controllers: [AdminAuthController, AdminTeamController, CustomerAuthController],
  providers: [
    { provide: IDENTITY_SECRETS, useFactory: identitySecretsFromEnvironment },
    AdminSetupService,
    AdminSignInService,
    AdminSessionsService,
    AdminTeamService,
    { provide: CODE_SENDER, useFactory: codeSenderFromEnvironment },
    AppSigningKeys,
    AppSessionsService,
    AppSignInService,
    RouteAccessGuard,
  ],
  exports: [AdminSessionsService, AppSessionsService, RouteAccessGuard],
})
export class IdentityModule {}

export { ADMIN_SESSION_COOKIE, RouteAccessGuard } from './route-access.guard.js';
export { AdminSessionsService, type AdminSession } from './admin-sessions.service.js';
export { AppSessionsService, type AppParty, type AppSession } from './app-sessions.service.js';
export { adminPermissions, type AdminPermission } from './permissions.js';
