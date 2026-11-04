import { Module } from '@nestjs/common';
import { STATUS_CONTROLLERS } from './http/status.js';

@Module({ controllers: STATUS_CONTROLLERS })
export class ApiModule {}
