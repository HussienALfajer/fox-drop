import { Inject, Injectable } from '@nestjs/common';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { and, desc, eq, gte, inArray, lt, notLike, or, type SQL, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type Changes, changedFields } from './changes.js';
import { type actorTypes, type eventKinds, events } from './schema.js';

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

// An event as a target's history reads it.
export interface AuditEntry {
  id: string;
  occurredAt: Date;
  actor: AuditActor;
  action: string;
  target: { type: string; id: string };
  changes: Changes | null;
  reason: string | null;
}

// An event as «سجل التدقيق» shows it (AP §9.16): every field, and its time
// to the microsecond as the database keeps it (a Date keeps milliseconds),
// which the next page starts below.
export interface AuditLogEvent extends AuditEntry {
  position: string;
  kind: (typeof eventKinds)[number];
  cityId: string | null;
  ipAddress: string | null;
  device: string | null;
}

// The filters of «سجل التدقيق» (AP §9.16): each one left null matches all.
// `from` is included and `to` excluded; `after` is the last event of the
// page before (its `position`), so the next page starts below it.
export interface AuditLogFilter {
  actorType: (typeof actorTypes)[number] | null;
  actorId: string | null;
  action: string | null;
  targetType: string | null;
  targetId: string | null;
  from: Date | null;
  to: Date | null;
  after: { occurredAt: string; id: string } | null;
}

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

  // AP §9.6.4 «سجل التغييرات» (slice 2.30d): the write events of these
  // targets of one type each, newest first, at most `limit`.
  // `skipSuffix` leaves out the actions ending with it (the menu's
  // availability switches, slice 2.31).
  async history(
    targets: { type: string; ids: string[] }[],
    limit: number,
    skipSuffix: string | null = null,
    // Keeps the skipped actions of this actor type (slice 2.32a: the
    // restaurant's own switches stay in «سجل التغييرات», AP §9.6.6).
    keepActor: (typeof events.actorType.enumValues)[number] | null = null,
    // Only these actions (slice 2.36b: a captain's status changes).
    onlyActions: readonly string[] | null = null,
  ): Promise<AuditEntry[]> {
    const wanted = targets.filter((target) => target.ids.length > 0);
    if (wanted.length === 0) return [];
    const rows = await this.database.db
      .select({
        id: events.id,
        occurredAt: events.occurredAt,
        actorType: events.actorType,
        actorId: events.actorId,
        actorRole: events.actorRole,
        action: events.action,
        targetType: events.targetType,
        targetId: events.targetId,
        changes: events.changes,
        reason: events.reason,
      })
      .from(events)
      .where(
        and(
          eq(events.kind, 'write'),
          ...(onlyActions === null ? [] : [inArray(events.action, [...onlyActions])]),
          ...(skipSuffix === null
            ? []
            : [
                keepActor === null
                  ? notLike(events.action, `%${skipSuffix}`)
                  : or(notLike(events.action, `%${skipSuffix}`), eq(events.actorType, keepActor)),
              ]),
          or(
            ...wanted.map((target) =>
              and(eq(events.targetType, target.type), inArray(events.targetId, target.ids)),
            ),
          ),
        ),
      )
      .orderBy(desc(events.occurredAt), desc(events.id))
      .limit(limit);
    return rows.map((row) => ({
      id: row.id,
      occurredAt: row.occurredAt,
      actor: { type: row.actorType, id: row.actorId, role: row.actorRole },
      action: row.action,
      target: { type: row.targetType, id: row.targetId },
      changes: row.changes,
      reason: row.reason,
    }));
  }

  // «سجل التدقيق» (AP §9.16, slice 2.38a): the events matching the filter,
  // writes and views, newest first, at most `limit`.
  async search(filter: AuditLogFilter, limit: number): Promise<AuditLogEvent[]> {
    const conditions: SQL[] = [];
    if (filter.actorType !== null) conditions.push(eq(events.actorType, filter.actorType));
    if (filter.actorId !== null) conditions.push(eq(events.actorId, filter.actorId));
    if (filter.action !== null) conditions.push(eq(events.action, filter.action));
    if (filter.targetType !== null) conditions.push(eq(events.targetType, filter.targetType));
    if (filter.targetId !== null) conditions.push(eq(events.targetId, filter.targetId));
    if (filter.from !== null) conditions.push(gte(events.occurredAt, filter.from));
    if (filter.to !== null) conditions.push(lt(events.occurredAt, filter.to));
    if (filter.after !== null) {
      const { occurredAt, id } = filter.after;
      conditions.push(
        sql`(${events.occurredAt}, ${events.id}) < (${occurredAt}::timestamptz, ${id}::uuid)`,
      );
    }
    const rows = await this.database.db
      .select({
        id: events.id,
        occurredAt: events.occurredAt,
        position: sql<string>`to_char(${events.occurredAt} AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"')`,
        kind: events.kind,
        cityId: events.cityId,
        actorType: events.actorType,
        actorId: events.actorId,
        actorRole: events.actorRole,
        action: events.action,
        targetType: events.targetType,
        targetId: events.targetId,
        changes: events.changes,
        reason: events.reason,
        ipAddress: events.ipAddress,
        device: events.device,
      })
      .from(events)
      .where(and(...conditions))
      .orderBy(desc(events.occurredAt), desc(events.id))
      .limit(limit);
    return rows.map((row) => ({
      id: row.id,
      occurredAt: row.occurredAt,
      position: row.position,
      kind: row.kind,
      cityId: row.cityId,
      actor: { type: row.actorType, id: row.actorId, role: row.actorRole },
      action: row.action,
      target: { type: row.targetType, id: row.targetId },
      changes: row.changes,
      reason: row.reason,
      ipAddress: row.ipAddress,
      device: row.device,
    }));
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
