import { Module } from '@nestjs/common';
import { STATUS_CONTROLLERS } from './http/status.js';
import { IdentityModule } from './modules/identity/index.js';

@Module({ imports: [IdentityModule], controllers: STATUS_CONTROLLERS })
export class ApiModule {}
