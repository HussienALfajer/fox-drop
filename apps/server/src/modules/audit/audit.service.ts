import { Inject, Injectable } from '@nestjs/common';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type Changes, changedFields } from './changes.js';
import { type actorTypes, events } from './schema.js';

export interface AuditActor {
  type: (typeof actorTypes)[number];
  // Empty only for the system.
  id: string | null;
  // The actor's role when it acted, such as OWN or OPS.
  role: string | null;
}

// Where the request came from (AP §9.16).
export interface AuditRequestContext {
  ipAddress: string | null;
  device: string | null;
}

interface AuditEvent {
  actor: AuditActor;
  context: AuditRequestContext;
  // Empty for an action on the whole platform.
  cityId: string | null;
  // A dotted name such as setting.update or customer.phone.view.
  action: string;
  target: { type: string; id: string };
  reason?: string | null;
}

export interface AuditWrite extends AuditEvent {
  // The target before and after the write; null when created or removed.
  before: Readonly<Record<string, unknown>> | null;
  after: Readonly<Record<string, unknown>> | null;
}

export type AuditView = AuditEvent;

// The database or the open transaction of the write being audited, so the
// event commits or rolls back with it.
export type AuditExecutor = Pick<NodePgDatabase, 'insert'>;

// The one way to add to the audit log (AP §4.6): every write action and every
// sensitive view. Events are never changed or removed.
@Injectable()
export class AuditService {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  // A write is recorded in its own transaction, never on its own.
  async recordWrite(event: AuditWrite, executor: AuditExecutor): Promise<void> {
    await this.insert(event, 'write', changedFields(event.before, event.after), executor);
  }

  async recordView(event: AuditView, executor?: AuditExecutor): Promise<void> {
    await this.insert(event, 'view', null, executor);
  }

  private async insert(
    event: AuditEvent,
    kind: 'write' | 'view',
    changes: Changes | null,
    executor: AuditExecutor = this.database.db,
  ): Promise<void> {
    await executor.insert(events).values({
      cityId: event.cityId,
      actorType: event.actor.type,
      actorId: event.actor.id,
      actorRole: event.actor.role,
      kind,
      action: event.action,
      targetType: event.target.type,
      targetId: event.target.id,
      changes,
      reason: event.reason ?? null,
      ipAddress: event.context.ipAddress,
      device: event.context.device,
    });
  }
}
