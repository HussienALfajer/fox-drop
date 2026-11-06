import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { STATUS_CONTROLLERS } from './http/status.js';
import { CaptainsModule } from './modules/captains/index.js';
import { CustomersModule } from './modules/customers/index.js';
import { DispatchModule } from './modules/dispatch/index.js';
import { FxModule } from './modules/fx/index.js';
import { GeoModule } from './modules/geo/index.js';
import { IdentityModule, RouteAccessGuard } from './modules/identity/index.js';
import { MerchantsModule } from './modules/merchants/index.js';
import { NotificationsModule } from './modules/notifications/index.js';
import { OrderingModule } from './modules/ordering/index.js';
import { SettingsModule } from './modules/settings/index.js';
import { PlaceholderSeedModule } from './seed/placeholder-seed.js';

// Architecture §15.2: RouteAccessGuard sees every route of every group and
// refuses one that does not declare its access. Each module with routes is
// imported here, with FxModule, through which the settings routes check a
// city's currencies, and GeoModule, MerchantsModule and CaptainsModule, whose
// fee rule, minimum orders, menu prices, cash limits and pay tables a base
// change checks.
// The placeholder seed runs only when start-role.ts asks.
@Module({
  imports: [
    IdentityModule,
    SettingsModule,
    FxModule,
    GeoModule,
    MerchantsModule,
    CaptainsModule,
    CustomersModule,
    OrderingModule,
    DispatchModule,
    NotificationsModule,
    PlaceholderSeedModule,
  ],
  controllers: STATUS_CONTROLLERS,
  providers: [{ provide: APP_GUARD, useExisting: RouteAccessGuard }],
})
export class ApiModule {}
