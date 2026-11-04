import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { STATUS_CONTROLLERS } from './http/status.js';
import { IdentityModule, RouteAccessGuard } from './modules/identity/index.js';

// Architecture §15.2: RouteAccessGuard sees every route of every group and
// refuses one that does not declare its access.
@Module({
  imports: [IdentityModule],
  controllers: STATUS_CONTROLLERS,
  providers: [{ provide: APP_GUARD, useExisting: RouteAccessGuard }],
})
export class ApiModule {}
