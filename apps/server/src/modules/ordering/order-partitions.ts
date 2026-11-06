import { Inject, Injectable } from '@nestjs/common';
import { sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { MonthPartitions } from '../../database/month-partitions.js';

// The monthly partitions of the orders, their lines and events, kept a month
// ahead by the worker.
@Injectable()
export class OrderPartitions extends MonthPartitions {
  constructor(@Inject(DATABASE) database: Database) {
    super(database, 'orders', sql`SELECT ordering.create_month_partitions()`);
  }
}
