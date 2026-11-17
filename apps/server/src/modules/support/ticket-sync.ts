import { Inject, Injectable } from '@nestjs/common';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { and, eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { AlertsService, PlatformBroadcasts } from '../notifications/index.js';
import { tickets } from './schema.js';
import { isUrgent, ticketKind } from './tickets.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type TicketRow = typeof tickets.$inferSelect;

// What follows a ticket's change in its transaction (E4): the alert
// «تذكرة عاجلة» (AP §9.1.3) and the panel's channel (architecture §6.2).
// The API's SupportService and ordering's worker share it.
@Injectable()
export class TicketSync {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly alerts: AlertsService,
    private readonly broadcasts: PlatformBroadcasts,
  ) {}

  async changed(tx: Tx, row: TicketRow, now: Date): Promise<void> {
    const details: Record<string, string> = { ticketNumber: row.number.toString() };
    if (row.orderNumber !== null) details.orderNumber = row.orderNumber.toString();
    // A pickup dispute's alert reaches FIN too (AP §9.1.3; slice 2.23b).
    const kind = ticketKind(row.typeCode);
    const code = kind === 'pickup_dispute' ? 'urgent_dispute_ticket' : 'urgent_ticket';
    await this.alerts.sync(
      tx,
      { type: 'ticket', id: row.id, cityId: row.cityId, details },
      ['urgent_ticket', 'urgent_dispute_ticket'],
      isUrgent({ status: row.status, orderActive: row.orderActive, kind }) ? [code] : [],
      now,
    );
    await this.broadcasts.enqueue(tx, {
      type: 'ticket.changed',
      cityId: row.cityId,
      ticketId: row.id,
      at: now,
    });
  }

  // The orders whose tickets are still urgent, for the worker's start.
  async urgentOrderIds(): Promise<string[]> {
    const rows = await this.database.db
      .selectDistinct({ orderId: tickets.orderId })
      .from(tickets)
      .where(eq(tickets.orderActive, true));
    return rows.flatMap((row) => (row.orderId === null ? [] : [row.orderId]));
  }

  // Ordering, in the transaction of an order's change under its lock: once
  // the order is no longer active its tickets turn «عادية» and their alert
  // closes (owner decision 2026-11-17). A no-op for an order without one.
  async orderEnded(tx: Tx, orderId: string, now: Date): Promise<void> {
    const ended = await tx
      .update(tickets)
      .set({ orderActive: false, updatedAt: now })
      .where(and(eq(tickets.orderId, orderId), eq(tickets.orderActive, true)))
      .returning();
    for (const row of ended) await this.changed(tx, row, now);
  }
}
