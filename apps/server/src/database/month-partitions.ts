import { Logger, type OnModuleDestroy, type OnModuleInit } from '@nestjs/common';
import type { SQL } from 'drizzle-orm';
import { reportError } from '../observability/error-tracking.js';
import type { Database } from './database.js';

const DAY = 24 * 60 * 60 * 1000;

// A row of a table partitioned by month needs the partition of its month
// (architecture §5.4). The worker runs the table's partition function, which
// creates this month's and the next, at start and every day, so a partition
// always exists a month ahead. A pg-boss schedule replaces the timer when the
// worker gets its job queue.
export abstract class MonthPartitions implements OnModuleInit, OnModuleDestroy {
  private readonly logger: Logger;
  private timer: NodeJS.Timeout | undefined;

  protected constructor(
    private readonly database: Database,
    private readonly table: string,
    private readonly createStatement: SQL,
  ) {
    this.logger = new Logger(`${table} partitions`);
  }

  async onModuleInit(): Promise<void> {
    await this.create();
    this.timer = setInterval(() => {
      this.create().catch((error: unknown) => {
        this.logger.error({ err: error }, `creating the ${this.table} partitions failed`);
        reportError(error);
      });
    }, DAY);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    clearInterval(this.timer);
  }

  private async create(): Promise<void> {
    await this.database.db.execute(this.createStatement);
  }
}
