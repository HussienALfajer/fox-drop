import fastifyCookie from '@fastify/cookie';
import { Module, type Type } from '@nestjs/common';
import { NestFactory, Reflector } from '@nestjs/core';
import { FastifyAdapter, type NestFastifyApplication } from '@nestjs/platform-fastify';
import { Logger } from 'nestjs-pino';
import { ZodSerializerInterceptor, ZodValidationPipe } from 'nestjs-zod';
import { LoggingModule } from '../logging/logging.module.js';

export async function createApiApp(module: Type): Promise<NestFastifyApplication> {
  @Module({ imports: [LoggingModule, module] })
  class RootModule {}

  const app = await NestFactory.create<NestFastifyApplication>(RootModule, new FastifyAdapter(), {
    bufferLogs: true,
    abortOnError: false,
  });
  app.useLogger(app.get(Logger));
  // Reads and sets the admin session cookie (architecture §10.3).
  await app.register(fastifyCookie);
  app.setGlobalPrefix('v1');
  app.useGlobalPipes(new ZodValidationPipe());
  // Responses declared with @ZodResponse are parsed by their schema, so a
  // route cannot return more or other than its documented model.
  app.useGlobalInterceptors(new ZodSerializerInterceptor(app.get(Reflector)));

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
