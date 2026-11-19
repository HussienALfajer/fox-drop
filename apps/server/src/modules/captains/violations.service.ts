import { createHash } from 'node:crypto';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { and, desc, eq, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { ContentRefusedError, ContentService } from '../content/index.js';
import { GeoService } from '../geo/index.js';
import { SettingsService } from '../settings/index.js';
import {
  ApplicationPipelineService,
  PipelineRefusedError,
} from './application-pipeline.service.js';
import type { Tx } from './applications.service.js';
import { CaptainsRefusedError, CaptainsService, type StatusChanged } from './captains.service.js';
import { captainRecords, violations } from './schema.js';
import {
  type AppealOutcome,
  STEP_LABELS,
  suggestedStep,
  suspensionEnd,
  type ViolationStep,
} from './violations.js';

// The longest reason the panel takes (the table's CHECK).
export const VIOLATION_REASON_MAX = 500;

// The Content lists of the violation types (owner decision 2026-11-19).
export const VIOLATION_LISTS = {
  regular: 'captain_violation',
  severe: 'captain_violation_severe',
} as const;

export type ViolationRow = typeof violations.$inferSelect;

export type ViolationRefusal =
  | 'unknown_captain'
  | 'unknown_violation'
  | 'unknown_reason'
  | 'reason_note_required'
  | 'reason_note_not_allowed'
  | 'reason_required'
  | 'captain_terminated'
  | 'no_contract'
  | 'already_terminated'
  | 'offboarding_open'
  | 'already_appealed'
  | 'idempotency_key_reused';

export class ViolationRefusedError extends Error {
  override readonly name = 'ViolationRefusedError';
  constructor(
    readonly refusal: ViolationRefusal,
    message: string,
  ) {
    super(message);
  }
}

export interface ViolationAdmin {
  actor: AuditActor;
  context: AuditRequestContext;
}

export interface NewViolation {
  // Which list the type is from: a severe type terminates at once.
  severe: boolean;
  typeCode: string;
  typeNote: string | null;
  step: ViolationStep;
  order: { id: string; number: bigint } | null;
  reason: string;
  idempotencyKey: string;
}

// CA §14 #25: a violation recorded, told in its transaction.
export interface ViolationRecorded {
  captainId: string;
  cityId: string;
  violationId: string;
  typeLabel: string;
  step: ViolationStep;
  at: Date;
}

type ViolationListener = (tx: Tx, recorded: ViolationRecorded) => Promise<void>;

// AP §9.7.5–9.7.6, CA §11.3 (slice 2.36b; owner decisions 2026-11-19):
// «تسجيل مخالفة» with the ladder's suggestion, its consequence (a «إيقاف»
// step suspends for its days, «إنهاء التعاقد» starts the offboarding), and
// the appeal's outcome (an accepted appeal voids the violation and lifts the
// suspension it set while that still runs).
@Injectable()
export class ViolationsService {
  private readonly logger = new Logger(ViolationsService.name);
  private readonly listeners: ViolationListener[] = [];

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly captains: CaptainsService,
    private readonly pipeline: ApplicationPipelineService,
    private readonly content: ContentService,
    private readonly settings: SettingsService,
    private readonly geo: GeoService,
    private readonly audit: AuditService,
  ) {}

  // Notifications pushes CA §14 #25 (captains cannot import it).
  onRecorded(listener: ViolationListener): void {
    this.listeners.push(listener);
  }

  // The captain's violations, newest first.
  async list(captainId: string): Promise<ViolationRow[]> {
    return this.database.db
      .select()
      .from(violations)
      .where(eq(violations.captainId, captainId))
      .orderBy(desc(violations.recordedAt), desc(violations.id));
  }

  // The step the ladder suggests now for a type that is not severe (a
  // severe one is always «إنهاء التعاقد»), with the window it counts.
  async suggestion(
    captainId: string,
    cityId: string,
    now: Date,
  ): Promise<{ step: ViolationStep; windowDays: number }> {
    const windowDays = await this.settings.get('captain.violation_window_days', { cityId });
    const earlier = await this.earlier(this.database.db, captainId);
    return { step: suggestedStep(earlier, { severe: false, windowDays, now }), windowDays };
  }

  // Records the violation with the step the admin confirmed, and its
  // consequence in the same transaction. A repeat of the key answers the
  // first violation; another request with it is idempotency_key_reused.
  async record(
    captainId: string,
    input: NewViolation,
    admin: ViolationAdmin,
    now: Date,
  ): Promise<string> {
    const reason = input.reason.trim();
    if (reason === '') throw new ViolationRefusedError('reason_required', 'a reason is required');
    const captain = await this.captains.captain(captainId, now);
    if (captain === null) throw new ViolationRefusedError('unknown_captain', 'no such captain');
    const requestHash = hashOf([
      captainId,
      input.severe,
      input.typeCode,
      input.typeNote?.trim() || '',
      input.step,
      input.order?.id ?? '',
      reason,
    ]);
    // A repeat answers the first before anything it read can refuse it (a
    // type deactivated since).
    const [earlier] = await this.database.db
      .select({ id: violations.id, requestHash: violations.requestHash })
      .from(violations)
      .where(
        and(
          eq(violations.recordedBy, admin.actor.id!),
          eq(violations.idempotencyKey, input.idempotencyKey),
        ),
      );
    if (earlier) {
      if (earlier.requestHash !== requestHash) {
        throw new ViolationRefusedError('idempotency_key_reused', 'the key named another');
      }
      return earlier.id;
    }
    const chosen = await this.content
      .choose(input.severe ? VIOLATION_LISTS.severe : VIOLATION_LISTS.regular, {
        code: input.typeCode,
        note: input.typeNote,
      })
      .catch((error: unknown) => {
        if (error instanceof ContentRefusedError) {
          const refusal = error.refusal === 'invalid_value' ? 'unknown_reason' : error.refusal;
          throw new ViolationRefusedError(refusal as ViolationRefusal, error.message);
        }
        throw error;
      });
    const [windowDays, timeZone] = await Promise.all([
      this.settings.get('captain.violation_window_days', { cityId: captain.cityId }),
      this.geo.cityTimeZone(captain.cityId),
    ]);
    const typeLabel = chosen.note === null ? chosen.label : `${chosen.label}: ${chosen.note}`;
    let changed: StatusChanged | null = null;
    const id = await this.database.db
      .transaction(async (tx) => {
        // One violation of a captain at a time, so the ladder counts them all.
        await tx.execute(
          sql`SELECT pg_advisory_xact_lock(hashtextextended(${`captains.violations:${captainId}`}, 0))`,
        );
        const [replayed] = await tx
          .select({ id: violations.id, requestHash: violations.requestHash })
          .from(violations)
          .where(
            and(
              eq(violations.recordedBy, admin.actor.id!),
              eq(violations.idempotencyKey, input.idempotencyKey),
            ),
          );
        if (replayed) {
          if (replayed.requestHash !== requestHash) {
            throw new ViolationRefusedError('idempotency_key_reused', 'the key named another');
          }
          return replayed.id;
        }
        const [row] = await tx
          .select({ status: captainRecords.status })
          .from(captainRecords)
          .where(eq(captainRecords.id, captainId));
        if (row?.status === 'terminated') {
          throw new ViolationRefusedError('captain_terminated', 'the captain is terminated');
        }
        const suggested = suggestedStep(await this.earlier(tx, captainId), {
          severe: input.severe,
          windowDays,
          now,
        });
        const until = suspensionEnd(input.step, now);
        const consequence = `${STEP_LABELS[input.step]}: ${typeLabel}`;
        if (until !== null) {
          // A suspension running longer (or until further notice) stays: the
          // step never shortens it, and its appeal then lifts nothing.
          const [current] = await tx
            .select({
              status: captainRecords.status,
              suspendedUntil: captainRecords.suspendedUntil,
            })
            .from(captainRecords)
            .where(eq(captainRecords.id, captainId))
            .for('update');
          const running =
            current?.status === 'suspended' &&
            (current.suspendedUntil === null || current.suspendedUntil > now);
          const longer =
            running && (current.suspendedUntil === null || current.suspendedUntil >= until);
          if (!longer) {
            changed = await this.captains.setStatusIn(
              tx,
              captainId,
              'suspended',
              { ...admin, reason: consequence, until, byViolation: true },
              now,
            );
          }
        }
        if (input.step === 'termination') {
          const applicationId = await this.pipeline.contractOf(tx, captainId);
          if (applicationId === null) {
            throw new ViolationRefusedError('no_contract', 'the captain has no contract to end');
          }
          changed = (
            await this.pipeline.terminateIn(
              tx,
              applicationId,
              admin,
              consequence,
              timeZone ?? 'UTC',
              now,
              true,
            )
          ).changed;
        }
        const [inserted] = await tx
          .insert(violations)
          .values({
            cityId: captain.cityId,
            captainId,
            typeCode: chosen.code,
            typeLabel: chosen.label,
            typeNote: chosen.note,
            severe: input.severe,
            suggestedStep: suggested,
            step: input.step,
            orderId: input.order?.id ?? null,
            orderNumber: input.order?.number ?? null,
            reason,
            suspendedUntil: until,
            recordedBy: admin.actor.id!,
            recordedAt: now,
            idempotencyKey: input.idempotencyKey,
            requestHash,
          })
          .returning({ id: violations.id });
        await this.audit.recordWrite(
          {
            ...admin,
            cityId: captain.cityId,
            action: 'captain.violation',
            target: { type: 'captain', id: captainId },
            before: null,
            after: {
              violationId: inserted!.id,
              type: chosen.code,
              severe: input.severe,
              suggestedStep: suggested,
              step: input.step,
              orderId: input.order?.id ?? null,
              ...(until === null ? {} : { suspendedUntil: until.toISOString() }),
            },
            reason,
          },
          tx,
        );
        for (const listener of this.listeners) {
          await listener(tx, {
            captainId,
            cityId: captain.cityId,
            violationId: inserted!.id,
            typeLabel,
            step: input.step,
            at: now,
          });
        }
        return inserted!.id;
      })
      .catch((error: unknown) => {
        // Two requests with one key for different captains at once.
        if (uniqueViolation(error, 'violations_key')) {
          throw new ViolationRefusedError('idempotency_key_reused', 'the key named another');
        }
        throw refusalOf(error);
      });
    if (changed !== null) await this.captains.afterStatus(captainId, changed, now);
    return id;
  }

  // The captain's «اعتراض» (CA §11.3), in support's transaction: the
  // violation locked, the captain's, neither appealed nor voided. 404
  // unknown_violation; 409 already_appealed.
  async lockForAppeal(tx: Tx, captainId: string, violationId: string): Promise<ViolationRow> {
    const [row] = await tx
      .select()
      .from(violations)
      .where(and(eq(violations.id, violationId), eq(violations.captainId, captainId)))
      .for('update');
    if (!row) throw new ViolationRefusedError('unknown_violation', 'no such violation');
    if (row.appealTicketId !== null) {
      throw new ViolationRefusedError('already_appealed', 'the violation was appealed');
    }
    return row;
  }

  // The ticket the appeal opened, set once.
  async linkAppealIn(tx: Tx, violationId: string, ticketId: string, now: Date): Promise<void> {
    await tx
      .update(violations)
      .set({ appealTicketId: ticketId, appealedAt: now })
      .where(eq(violations.id, violationId));
  }

  // The appeal's ticket resolved (AP §9.7.5), in support's transaction: the
  // outcome on the violation, audited `captain.violation_appeal`; an
  // accepted appeal voids it and lifts the suspension it set while that
  // still runs (owner decision 2026-11-19). An offboarding it started stays
  // (it has no undo; the checklist decides). The caller runs `afterStatus`
  // with the answer once it commits.
  async decideAppealIn(
    tx: Tx,
    ticketId: string,
    outcome: AppealOutcome,
    admin: ViolationAdmin,
    now: Date,
  ): Promise<{ captainId: string; changed: StatusChanged | null }> {
    const [row] = await tx
      .select()
      .from(violations)
      .where(eq(violations.appealTicketId, ticketId))
      .for('update');
    if (!row) throw new ViolationRefusedError('unknown_violation', 'the ticket is no appeal');
    await tx
      .update(violations)
      .set({ appealOutcome: outcome, appealDecidedBy: admin.actor.id!, appealDecidedAt: now })
      .where(eq(violations.id, row.id));
    let changed: StatusChanged | null = null;
    if (outcome === 'accepted' && row.suspendedUntil !== null && row.suspendedUntil > now) {
      const [captain] = await tx
        .select({
          status: captainRecords.status,
          suspendedUntil: captainRecords.suspendedUntil,
        })
        .from(captainRecords)
        .where(eq(captainRecords.id, row.captainId))
        .for('update');
      // Still the violation's suspension: a later one replaced its end.
      if (
        captain?.status === 'suspended' &&
        captain.suspendedUntil?.getTime() === row.suspendedUntil.getTime()
      ) {
        changed = await this.captains.setStatusIn(
          tx,
          row.captainId,
          'active',
          { ...admin, reason: 'قُبل الاعتراض على المخالفة' },
          now,
        );
      }
    }
    await this.audit.recordWrite(
      {
        ...admin,
        cityId: row.cityId,
        action: 'captain.violation_appeal',
        target: { type: 'captain', id: row.captainId },
        before: { violationId: row.id, appealOutcome: null },
        after: { violationId: row.id, appealOutcome: outcome, suspensionLifted: changed !== null },
        reason: null,
      },
      tx,
    );
    return { captainId: row.captainId, changed };
  }

  async afterAppeal(decided: { captainId: string; changed: StatusChanged | null }, now: Date) {
    if (decided.changed === null) return;
    await this.captains.afterStatus(decided.captainId, decided.changed, now).catch((error) => {
      this.logger.error({ err: error }, 'the lifted suspension could not finish');
    });
  }

  private async earlier(
    executor: Pick<Database['db'], 'select'>,
    captainId: string,
  ): Promise<{ recordedAt: Date; voided: boolean }[]> {
    const rows = await executor
      .select({ recordedAt: violations.recordedAt, outcome: violations.appealOutcome })
      .from(violations)
      .where(eq(violations.captainId, captainId));
    return rows.map((row) => ({ recordedAt: row.recordedAt, voided: row.outcome === 'accepted' }));
  }
}

function uniqueViolation(error: unknown, constraint: string): boolean {
  for (let cause: unknown = error; cause instanceof Object;) {
    const each = cause as { code?: string; constraint?: string; cause?: unknown };
    if (each.code === '23505' && each.constraint === constraint) return true;
    cause = each.cause;
  }
  return false;
}

function hashOf(parts: readonly unknown[]): string {
  return createHash('sha256').update(JSON.stringify(parts)).digest('hex');
}

// The refusals of the status change and the offboarding, as the violation's.
function refusalOf(error: unknown): unknown {
  if (error instanceof CaptainsRefusedError) {
    if (error.refusal === 'offboarding_open' || error.refusal === 'unknown_captain') {
      return new ViolationRefusedError(error.refusal, error.message);
    }
    if (error.refusal === 'status_change_not_allowed') {
      return new ViolationRefusedError('captain_terminated', error.message);
    }
  }
  if (error instanceof PipelineRefusedError) {
    if (error.refusal === 'already_terminated' || error.refusal === 'contract_ended') {
      return new ViolationRefusedError('already_terminated', error.message);
    }
    if (error.refusal === 'captain_terminated') {
      return new ViolationRefusedError('captain_terminated', error.message);
    }
  }
  return error;
}
