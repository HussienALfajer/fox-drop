import { type INestApplicationContext, Module, type Type } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { Logger } from 'nestjs-pino';
import { ApiModule } from '../api.module.js';
import { createApiApp } from '../http/create-api-app.js';
import { LoggingModule } from '../logging/logging.module.js';
import { AuditWorkerModule } from '../modules/audit/index.js';
import { CaptainsWorkerModule } from '../modules/captains/index.js';
import { DispatchWorkerModule } from '../modules/dispatch/index.js';
import { OtpSenderModule } from '../modules/identity/index.js';
import { LedgerWorkerModule } from '../modules/ledger/index.js';
import {
  AlertsWorkerModule,
  PlatformRelayWorkerModule,
  PushWorkerModule,
} from '../modules/notifications/index.js';
import { OrderingWorkerModule } from '../modules/ordering/index.js';
import { PlaceholderSeed, seedsPlaceholders } from '../seed/placeholder-seed.js';
import type { ProcessRole } from './process-role.js';

type BackgroundRole = Exclude<ProcessRole, 'api'>;

// The worker, dispatcher and otp-sender roles have no HTTP server. Their jobs,
// loops and queues join their role here in the slices that build them.
const BACKGROUND_MODULES: Record<BackgroundRole, Type[]> = {
  worker: [
    AuditWorkerModule,
    LedgerWorkerModule,
    CaptainsWorkerModule,
    OrderingWorkerModule,
    DispatchWorkerModule,
    AlertsWorkerModule,
    PushWorkerModule,
    PlatformRelayWorkerModule,
  ],
  dispatcher: [],
  'otp-sender': [OtpSenderModule],
};

export async function createBackgroundContext(
  role: BackgroundRole,
): Promise<INestApplicationContext> {
  @Module({ imports: [LoggingModule, ...BACKGROUND_MODULES[role]] })
  class BackgroundRoleModule {}

  const context = await NestFactory.createApplicationContext(BackgroundRoleModule, {
    bufferLogs: true,
    abortOnError: false,
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
  // Listening before start-up means a stop during start-up is not ignored by
  // Node running as PID 1 in the container.
  const stopped = shutdownSignal();
  let context: INestApplicationContext;
  if (role === 'api') {
    const app = await createApiApp(ApiModule);
    if (seedsPlaceholders()) {
      await app.init();
      await app.get(PlaceholderSeed).run();
    }
    await app.listen({ host: '0.0.0.0', port: Number(process.env.PORT ?? 3000) });
    context = app;
  } else {
    context = await createBackgroundContext(role);
  }
  const logger = context.get(Logger);
  logger.log(`${role} started`, 'ProcessRole');

  const signal = await stopped;
  logger.log(`${role} stopping on ${signal}`, 'ProcessRole');
  await context.close();
}
