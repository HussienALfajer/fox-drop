import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, isNotNull, isNull, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import {
  ALERT_RULES,
  type AlertCode,
  type AlertSeverity,
  type AlertSubject,
  bySeverityThenAge,
  receivedCodes,
} from './alert-rules.js';
import { type AlertEventType, alertOutbox, alerts } from './schema.js';

// A transaction, never the pool: an alert's change and its outbox row
// commit together (E4).
type Executor = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// What an alert is about, and what the panel shows beside its label.
export interface AlertSubjectRef {
  type: AlertSubject;
  id: string;
  // Null for the whole platform (the code senders).
  cityId: string | null;
  details?: Record<string, string>;
}

export interface Alert {
  id: string;
  cityId: string | null;
  code: AlertCode;
  severity: AlertSeverity;
  subjectType: AlertSubject;
  subjectId: string;
  details: Record<string, string>;
  raisedAt: Date;
  acknowledgedAt: Date | null;
  acknowledgedBy: string | null;
  resolvedAt: Date | null;
}

// AP §7.3: what a recipient can do to an alert, and the history's length.
const HISTORY_LIMIT = 100;

export class AlertNotFoundError extends Error {
  constructor() {
    super('unknown_alert');
  }
}

// AP §7.3, §9.1.3: the alerts' records. The module that owns a condition
// syncs its subject's alerts in its own transaction (`sync`), so an alert is
// raised and resolved with the state that changes it; the panel lists and
// acknowledges them.
@Injectable()
export class AlertsService {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  // Raises the codes of `open` that are not open for the subject, and
  // resolves the open ones among `evaluated` that are no longer in `open`
  // (AP §7.3, auto-resolve). A rule that does not resolve itself is raised
  // once per subject and left to its acknowledgment.
  async sync(
    executor: Executor,
    subject: AlertSubjectRef,
    evaluated: readonly AlertCode[],
    open: readonly AlertCode[],
    now: Date,
  ): Promise<void> {
    if (evaluated.length === 0) return;
    const rows = await executor
      .select({ id: alerts.id, code: alerts.code, resolvedAt: alerts.resolvedAt })
      .from(alerts)
      .where(
        and(
          eq(alerts.subjectType, subject.type),
          eq(alerts.subjectId, subject.id),
          inArray(alerts.code, [...evaluated]),
        ),
      );
    const stale = rows.filter(
      (row) =>
        row.resolvedAt === null && !open.includes(row.code) && ALERT_RULES[row.code].resolvesItself,
    );
    if (stale.length > 0) {
      const resolved = await executor
        .update(alerts)
        .set({ resolvedAt: now })
        .where(
          and(
            inArray(
              alerts.id,
              stale.map((row) => row.id),
            ),
            isNull(alerts.resolvedAt),
          ),
        )
        .returning();
      await recordEvents(executor, 'alert.resolved', resolved, now);
    }
    const missing = open.filter((code) =>
      ALERT_RULES[code].resolvesItself
        ? !rows.some((row) => row.code === code && row.resolvedAt === null)
        : !rows.some((row) => row.code === code),
    );
    if (missing.length === 0) return;
    const raised = await executor
      .insert(alerts)
      .values(
        missing.map((code) => ({
          cityId: subject.cityId,
          code,
          severity: ALERT_RULES[code].severity,
          subjectType: subject.type,
          subjectId: subject.id,
          details: subject.details ?? {},
          raisedAt: now,
        })),
      )
      // Two syncs of one subject at once: the open one stands.
      .onConflictDoNothing({
        target: [alerts.code, alerts.subjectType, alerts.subjectId],
        where: sql`${alerts.resolvedAt} IS NULL`,
      })
      .returning();
    await recordEvents(executor, 'alert.raised', raised, now);
  }

  // The subjects with an open alert of a rule, so a sweep resolves the ones
  // it no longer sees (a number disabled, a captain terminated).
  async openSubjects(code: AlertCode): Promise<{ id: string; cityId: string | null }[]> {
    return this.database.db
      .select({ id: alerts.subjectId, cityId: alerts.cityId })
      .from(alerts)
      .where(and(eq(alerts.code, code), isNull(alerts.resolvedAt)));
  }

  // AP §9.1.3: the open alerts of a city (and the platform's) that the roles
  // receive, by severity then age; with `history`, the latest closed ones,
  // newest first.
  async list(cityId: string, roles: readonly string[], history: boolean): Promise<Alert[]> {
    const codes = receivedCodes(roles);
    if (codes.length === 0) return [];
    const where = and(
      or(eq(alerts.cityId, cityId), isNull(alerts.cityId)),
      inArray(alerts.code, codes),
      history ? isNotNull(alerts.resolvedAt) : isNull(alerts.resolvedAt),
    );
    if (history) {
      const rows = await this.database.db
        .select()
        .from(alerts)
        .where(where)
        .orderBy(desc(alerts.resolvedAt))
        .limit(HISTORY_LIMIT);
      return rows.map(toAlert);
    }
    const rows = await this.database.db.select().from(alerts).where(where);
    return rows.map(toAlert).sort(bySeverityThenAge);
  }

  // AP §7.3 «استلام»: the alert is assigned to the recipient who takes it,
  // once; a later acknowledgment answers it as it is. A rule that does not
  // resolve itself closes with it. An alert the roles do not receive is
  // unknown to them.
  async acknowledge(
    alertId: string,
    accountId: string,
    roles: readonly string[],
    now: Date,
  ): Promise<Alert> {
    const codes = receivedCodes(roles);
    return this.database.db.transaction(async (tx) => {
      const [row] = await tx.select().from(alerts).where(eq(alerts.id, alertId)).for('update');
      if (!row || !codes.includes(row.code)) throw new AlertNotFoundError();
      if (row.acknowledgedAt !== null) return toAlert(row);
      const [updated] = await tx
        .update(alerts)
        .set({
          acknowledgedAt: now,
          acknowledgedBy: accountId,
          ...(ALERT_RULES[row.code].resolvesItself || row.resolvedAt !== null
            ? {}
            : { resolvedAt: now }),
        })
        .where(eq(alerts.id, alertId))
        .returning();
      await recordEvents(tx, 'alert.acknowledged', [updated!], now);
      return toAlert(updated!);
    });
  }
}

// The alert outbox payload, schema 1.
export interface AlertEventPayload {
  schema: 1;
  alertId: string;
  code: AlertCode;
  severity: AlertSeverity;
  at: string;
}

// E4: the panel hears each change on ops:city.{city_id} once it commits
// (alerts-relay.ts). The body names the alert only; the panel reads the list
// again, which answers what the session's roles receive.
async function recordEvents(
  executor: Executor,
  type: AlertEventType,
  rows: (typeof alerts.$inferSelect)[],
  now: Date,
): Promise<void> {
  if (rows.length === 0) return;
  await executor.insert(alertOutbox).values(
    rows.map((row) => ({
      createdAt: now,
      cityId: row.cityId,
      type,
      alertId: row.id,
      payload: {
        schema: 1,
        alertId: row.id,
        code: row.code,
        severity: row.severity,
        at: now.toISOString(),
      } satisfies AlertEventPayload,
    })),
  );
}

function toAlert(row: typeof alerts.$inferSelect): Alert {
  return { ...row, details: row.details as Record<string, string> };
}
