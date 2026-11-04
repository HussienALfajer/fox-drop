import type { Type } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { FastifyAdapter, type NestFastifyApplication } from '@nestjs/platform-fastify';

export async function createApiApp(module: Type): Promise<NestFastifyApplication> {
  const app = await NestFactory.create<NestFastifyApplication>(module, new FastifyAdapter());
  app.setGlobalPrefix('v1');
  return app;
}
