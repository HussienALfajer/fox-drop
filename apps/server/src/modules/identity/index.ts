import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { VALKEY, ValkeyModule } from '../../valkey/valkey.module.js';
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
import { APP_CHECK_VERIFIER, appCheckVerifierFromEnvironment } from './app-check.js';
import { CODE_SENDER, codeSenderFromEnvironment } from './code-sender.js';
import { CustomerAccountsService } from './customer-accounts.service.js';
import { CustomerAuthController } from './customer-auth.controller.js';
import { EmergencySignInController } from './emergency-sign-in.controller.js';
import { EmergencySignInService } from './emergency-sign-in.service.js';
import { MerchantAccountsService } from './merchant-accounts.service.js';
import { MerchantAuthController } from './merchant-auth.controller.js';
import { OtpSenderNumbersController } from './otp-sender-numbers.controller.js';
import { OtpSenderPoolService } from './otp-sender-pool.service.js';
import { PhoneCipher } from './phone-cipher.js';
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
    OtpSenderNumbersController,
    EmergencySignInController,
  ],
  providers: [
    { provide: IDENTITY_SECRETS, useFactory: identitySecretsFromEnvironment },
    AdminSetupService,
    AdminSignInService,
    AdminSessionsService,
    AdminTeamService,
    {
      provide: CODE_SENDER,
      useFactory: codeSenderFromEnvironment,
      inject: [VALKEY, IDENTITY_SECRETS],
    },
    { provide: APP_CHECK_VERIFIER, useFactory: appCheckVerifierFromEnvironment },
    AppSigningKeys,
    AppSessionsService,
    AppSignInService,
    MerchantAccountsService,
    CaptainAccountsService,
    CustomerAccountsService,
    PhoneCipher,
    RouteAccessGuard,
    OtpSenderPoolService,
    EmergencySignInService,
  ],
  exports: [
    AdminSessionsService,
    AppSessionsService,
    MerchantAccountsService,
    CaptainAccountsService,
    CustomerAccountsService,
    PhoneCipher,
    RouteAccessGuard,
  ],
})
export class IdentityModule {}

export { OtpSenderModule } from './otp-sender.module.js';
export { ADMIN_SESSION_COOKIE, RouteAccessGuard } from './route-access.guard.js';
export { AdminSessionsService, type AdminSession } from './admin-sessions.service.js';
export { AppSessionsService, type AppParty, type AppSession } from './app-sessions.service.js';
export { adminPermissions, type AdminPermission } from './permissions.js';
export { deviceId, phone } from './app-auth.js';
export { PhoneCipher } from './phone-cipher.js';
export { CustomerAccountsService } from './customer-accounts.service.js';
// For the tests of other modules that sign an app user in.
export { CODE_SENDER, type DevelopmentCodeSender } from './code-sender.js';
export { APP_CHECK_VERIFIER, type AppCheckVerifier } from './app-check.js';
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
export { OtpSenderPoolModule } from './otp-sender-pool.module.js';
export { OpenAppSessions, OpenAppSessionsModule } from './open-app-sessions.js';
export { OtpSenderPoolService } from './otp-sender-pool.service.js';
export type { PoolAlert } from './otp-sender-pool.js';
