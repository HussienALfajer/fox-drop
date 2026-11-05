import { Inject, Injectable } from '@nestjs/common';
import { sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { MonthPartitions } from '../../database/month-partitions.js';

// The audit log's monthly partitions, kept a month ahead by the worker.
@Injectable()
export class AuditPartitions extends MonthPartitions {
  constructor(@Inject(DATABASE) database: Database) {
    super(database, 'audit log', sql`SELECT audit.create_month_partitions()`);
  }
}
