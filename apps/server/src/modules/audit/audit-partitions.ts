import {
  Inject,
  Injectable,
  Logger,
  type OnModuleDestroy,
  type OnModuleInit,
} from '@nestjs/common';
import { sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';

const DAY = 24 * 60 * 60 * 1000;

// An event needs the partition of its month (architecture §5.4). The worker
// creates this month's and the next at start and checks them every day, so a
// partition always exists a month ahead. A pg-boss schedule replaces the timer
// when the worker gets its job queue.
@Injectable()
export class AuditPartitions implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(AuditPartitions.name);
  private timer: NodeJS.Timeout | undefined;

  constructor(@Inject(DATABASE) private readonly database: Database) {}

  async onModuleInit(): Promise<void> {
    await this.create();
    this.timer = setInterval(() => {
      this.create().catch((error: unknown) =>
        this.logger.error({ err: error }, 'creating the audit partitions failed'),
      );
    }, DAY);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    clearInterval(this.timer);
  }

  private async create(): Promise<void> {
    await this.database.db.execute(sql`SELECT audit.create_month_partitions()`);
  }
}
