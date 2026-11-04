import { type INestApplicationContext, Module } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { Logger } from 'nestjs-pino';
import { ApiModule } from '../api.module.js';
import { createApiApp } from '../http/create-api-app.js';
import { LoggingModule } from '../logging/logging.module.js';
import type { ProcessRole } from './process-role.js';

@Module({ imports: [LoggingModule] })
class BackgroundRoleModule {}

// The worker, dispatcher and otp-sender roles have no HTTP server. Their jobs,
// loops and queues join this context in the slices that build them.
export async function createBackgroundContext(): Promise<INestApplicationContext> {
  const context = await NestFactory.createApplicationContext(BackgroundRoleModule, {
    bufferLogs: true,
  });
  context.useLogger(context.get(Logger));
  return context;
}

function shutdownSignal(): Promise<NodeJS.Signals> {
  // Nothing else holds the event loop open yet, so the process waits here
  // until the platform stops it.
  const keepAlive = setInterval(() => undefined, 1 << 30);
  return new Promise((resolve) => {
    const stop = (signal: NodeJS.Signals) => {
      clearInterval(keepAlive);
      resolve(signal);
    };
    process.once('SIGTERM', stop);
    process.once('SIGINT', stop);
  });
}

export async function startRole(role: ProcessRole): Promise<void> {
  let context: INestApplicationContext;
  if (role === 'api') {
    const app = await createApiApp(ApiModule);
    await app.listen({ host: '0.0.0.0', port: Number(process.env.PORT ?? 3000) });
    context = app;
  } else {
    context = await createBackgroundContext();
  }
  const logger = context.get(Logger);
  logger.log(`${role} started`, 'ProcessRole');

  const signal = await shutdownSignal();
  logger.log(`${role} stopping on ${signal}`, 'ProcessRole');
  await context.close();
}
