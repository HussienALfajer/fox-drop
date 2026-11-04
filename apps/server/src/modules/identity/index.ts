import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminAuthController } from './admin-auth.controller.js';
import { AdminSessionsService } from './admin-sessions.service.js';
import { AdminSetupService } from './admin-setup.service.js';
import { AdminSignInService } from './admin-sign-in.service.js';
import { AdminTeamController } from './admin-team.controller.js';
import { AdminTeamService } from './admin-team.service.js';
import { RouteAccessGuard } from './route-access.guard.js';
import { IDENTITY_SECRETS, identitySecretsFromEnvironment } from './secrets.js';

// The identity module (architecture §4.2). So far: the admin panel's
// accounts, first sign-in, sign-in, sessions, roles and permissions, and the
// admin team (AP §5.1–5.3, §6, §9.15).
@Module({
  imports: [DatabaseModule, AuditModule, SettingsModule],
  controllers: [AdminAuthController, AdminTeamController],
  providers: [
    { provide: IDENTITY_SECRETS, useFactory: identitySecretsFromEnvironment },
    AdminSetupService,
    AdminSignInService,
    AdminSessionsService,
    AdminTeamService,
    RouteAccessGuard,
  ],
  exports: [AdminSessionsService, RouteAccessGuard],
})
export class IdentityModule {}

export {
  CurrentAdminSession,
  RequirePermission,
  RouteAccessGuard,
  SignedIn,
} from './route-access.guard.js';
export { AdminSessionsService, type AdminSession } from './admin-sessions.service.js';
export { adminPermissions, type AdminPermission } from './permissions.js';
