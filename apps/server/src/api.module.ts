import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { STATUS_CONTROLLERS } from './http/status.js';
import { IdentityModule, RouteAccessGuard } from './modules/identity/index.js';
import { SettingsModule } from './modules/settings/index.js';

// Architecture §15.2: RouteAccessGuard sees every route of every group and
// refuses one that does not declare its access. Each module with routes is
// imported here.
@Module({
  imports: [IdentityModule, SettingsModule],
  controllers: STATUS_CONTROLLERS,
  providers: [{ provide: APP_GUARD, useExisting: RouteAccessGuard }],
})
export class ApiModule {}
