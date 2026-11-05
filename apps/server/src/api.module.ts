import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { STATUS_CONTROLLERS } from './http/status.js';
import { FxModule } from './modules/fx/index.js';
import { IdentityModule, RouteAccessGuard } from './modules/identity/index.js';
import { SettingsModule } from './modules/settings/index.js';
import { PlaceholderSeedModule } from './seed/placeholder-seed.js';

// Architecture §15.2: RouteAccessGuard sees every route of every group and
// refuses one that does not declare its access. Each module with routes is
// imported here, and FxModule, through which the settings routes check a
// city's currencies. The placeholder seed runs only when start-role.ts asks.
@Module({
  imports: [IdentityModule, SettingsModule, FxModule, PlaceholderSeedModule],
  controllers: STATUS_CONTROLLERS,
  providers: [{ provide: APP_GUARD, useExisting: RouteAccessGuard }],
})
export class ApiModule {}
