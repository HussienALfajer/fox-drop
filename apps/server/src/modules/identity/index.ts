import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { ValkeyModule } from '../../valkey/valkey.module.js';
import { AuditModule } from '../audit/index.js';
import { CaptainsModule } from '../captains/index.js';
import { MerchantsModule } from '../merchants/index.js';
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
import { CaptainAccountsService } from './captain-accounts.service.js';
import { CaptainAuthController } from './captain-auth.controller.js';
import { CODE_SENDER, codeSenderFromEnvironment } from './code-sender.js';
import { CustomerAuthController } from './customer-auth.controller.js';
import { MerchantAccountsService } from './merchant-accounts.service.js';
import { MerchantAuthController } from './merchant-auth.controller.js';
import { RouteAccessGuard } from './route-access.guard.js';
import { IDENTITY_SECRETS, identitySecretsFromEnvironment } from './secrets.js';

// The identity module (architecture §4.2). So far: the admin panel's
// accounts, first sign-in, sign-in, sessions, roles and permissions, and the
// admin team (AP §5.1–5.3, §6, §9.15); the apps' phone sign-in, tokens and
// sessions (architecture §8.3, §15.1), and the restaurants' owners, cashiers
// and devices (RA §5), and the captains' sign-in accounts (CA §4.9).
@Module({
  imports: [
    DatabaseModule,
    ValkeyModule,
    AuditModule,
    SettingsModule,
    MerchantsModule,
    CaptainsModule,
  ],
  controllers: [
    AdminAuthController,
    AdminTeamController,
    CustomerAuthController,
    MerchantAuthController,
    CaptainAuthController,
  ],
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
    MerchantAccountsService,
    CaptainAccountsService,
    RouteAccessGuard,
  ],
  exports: [
    AdminSessionsService,
    AppSessionsService,
    MerchantAccountsService,
    CaptainAccountsService,
    RouteAccessGuard,
  ],
})
export class IdentityModule {}

export { ADMIN_SESSION_COOKIE, RouteAccessGuard } from './route-access.guard.js';
export { AdminSessionsService, type AdminSession } from './admin-sessions.service.js';
export { AppSessionsService, type AppParty, type AppSession } from './app-sessions.service.js';
export { adminPermissions, type AdminPermission } from './permissions.js';
// For the tests of other modules that sign an app user in.
export { CODE_SENDER, type DevelopmentCodeSender } from './code-sender.js';
export {
  type MerchantAccount,
  MerchantAccountRefusedError,
  MerchantAccountsService,
  type MerchantRole,
} from './merchant-accounts.service.js';
export {
  type CaptainAccount,
  CaptainAccountRefusedError,
  CaptainAccountsService,
} from './captain-accounts.service.js';
