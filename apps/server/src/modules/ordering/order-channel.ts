import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { RealtimeAccess } from '../notifications/index.js';
import { orders } from './schema.js';

// Architecture §6.2: order:{order_id} is the customer's own order. The
// notifications module checks the session; this module, which owns the
// orders, checks whose order it is.
@Injectable()
export class OrderChannelAccess implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly access: RealtimeAccess,
  ) {}

  onModuleInit(): void {
    this.access.allow('order', async (session, orderId) => {
      const [own] = await this.database.db
        .select({ id: orders.id })
        .from(orders)
        .where(and(eq(orders.id, orderId), eq(orders.customerAccountId, session.accountId)))
        .limit(1);
      return own !== undefined;
    });
  }
}
