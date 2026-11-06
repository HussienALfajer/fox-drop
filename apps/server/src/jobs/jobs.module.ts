import { Injectable, Logger, Module, type OnApplicationShutdown } from '@nestjs/common';
import type { PgBoss, SendOptions, WorkHandler } from 'pg-boss';
import { reportError } from '../observability/error-tracking.js';
import { createJobQueue, type QueueName } from './job-queue.js';

// The process's pg-boss, as the application role. It connects on first use,
// so building the API app without a database (the OpenAPI generation) never
// opens one. Only the worker supervises: maintenance and the timers that move
// jobs along.
@Injectable()
export class Jobs implements OnApplicationShutdown {
  private readonly logger = new Logger('Jobs');
  private started: Promise<PgBoss> | undefined;

  // A job, sent in the caller's transaction with { db: inTransaction(tx) }.
  async send(name: QueueName, data: object, options: SendOptions): Promise<string | null> {
    return (await this.boss()).send(name, data, options);
  }

  // The worker's handler of a queue; a job that throws is retried.
  async work<Data extends object>(name: QueueName, handler: WorkHandler<Data>): Promise<void> {
    await (await this.boss()).work<Data>(name, handler);
  }

  async onApplicationShutdown(): Promise<void> {
    if (this.started) await (await this.started).stop({ graceful: true, timeout: 10_000 });
  }

  private boss(): Promise<PgBoss> {
    // A failed start is tried again on the next use.
    this.started ??= this.start().catch((error: unknown) => {
      this.started = undefined;
      throw error;
    });
    return this.started;
  }

  private async start(): Promise<PgBoss> {
    const url = process.env.DATABASE_URL;
    if (!url) throw new Error('DATABASE_URL is not set');
    const boss = createJobQueue(url, process.env.PROCESS_ROLE === 'worker');
    boss.on('error', (error: unknown) => {
      this.logger.error({ err: error }, 'the job queue failed');
      reportError(error);
    });
    return boss.start();
  }
}

// Imported by every module that sends or works jobs (architecture §5.5).
@Module({ providers: [Jobs], exports: [Jobs] })
export class JobsModule {}
