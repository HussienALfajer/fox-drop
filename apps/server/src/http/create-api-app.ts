import { Module, type Type } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { FastifyAdapter, type NestFastifyApplication } from '@nestjs/platform-fastify';
import { Logger } from 'nestjs-pino';
import { ZodValidationPipe } from 'nestjs-zod';
import { LoggingModule } from '../logging/logging.module.js';

export async function createApiApp(module: Type): Promise<NestFastifyApplication> {
  @Module({ imports: [LoggingModule, module] })
  class RootModule {}

  const app = await NestFactory.create<NestFastifyApplication>(RootModule, new FastifyAdapter(), {
    bufferLogs: true,
  });
  app.useLogger(app.get(Logger));
  app.setGlobalPrefix('v1');
  app.useGlobalPipes(new ZodValidationPipe());

  // The apps compute their clock offset from this header (RA §4.7), so it is
  // set as late as possible and on every response, errors included.
  app
    .getHttpAdapter()
    .getInstance()
    .addHook('onSend', async (_request, reply) => {
      reply.header('Server-Time', String(Date.now()));
    });

  return app;
}
