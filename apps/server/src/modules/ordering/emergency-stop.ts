import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, count, desc, eq, inArray, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import { AuditService, type AuditRequestContext } from '../audit/index.js';
import { PlatformBroadcasts, PushQueue, type QueuedPush } from '../notifications/index.js';
import { GeoService } from '../geo/index.js';
import { SettingsService } from '../settings/index.js';
import { emergencyStopAttempts, emergencyStops, orders } from './schema.js';

// AP §9.1.6 item 2: the orders whose customer gets the delay notice, from
// placed to the captain at the door.
const ACTIVE = ['placed', 'accepted', 'ready', 'picked_up', 'arrived'] as const;

// The placeholder of the delay notice, filled from the customer-facing reason.
const REASON = '{السبب}';

// The timer of the optional automatic resume (AP §9.1.6), set with the stop.
export interface EmergencyResumeJob {
  stopId: string;
}

export interface EmergencyStop {
  id: string;
  cityId: string;
  startedAt: Date;
  startedBy: string;
  internalReason: string;
  browseMessage: string;
  delayNotice: string;
  customerReason: string;
  resumeAt: Date | null;
}

// AP §9.1.6 item 4: the stop as the panel shows it, with its attempts.
export interface EmergencyStopView extends EmergencyStop {
  attempts: number;
}

export interface StartStop {
  cityId: string;
  internalReason: string;
  browseMessage: string;
  delayNotice: string;
  customerReason: string;
  resumeAt: Date | null;
}

export interface Admin {
  accountId: string;
  roles: string[];
}

export type EmergencyStopRefusal =
  // No such city.
  | 'unknown_city'
  // A stop is already on in the city.
  | 'already_stopped'
  // The automatic resume is not after now.
  | 'resume_at_past'
  // No such stop in the city.
  | 'unknown_stop'
  // The stop already ended (resumed by someone else, or automatically).
  | 'stop_ended';

export class EmergencyStopRefusedError extends Error {
  constructor(readonly refusal: EmergencyStopRefusal) {
    super(refusal);
  }
}

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

// The delay notice a customer reads (CU §14 #18, §11.6).
export function delayNoticeText(stop: Pick<EmergencyStop, 'delayNotice' | 'customerReason'>) {
  return stop.delayNotice.replaceAll(REASON, stop.customerReason);
}

// AP §9.1.6, D7: a city's emergency stop. Starting it, in one transaction
// (E3, E4): the stop, its automatic resume timer, the delay push to every
// customer with an active order (CU §14 #18), the broadcast to the
// restaurant and captain apps and the panel, and the audit. The quote refuses
// new orders while it is on (emergency_stop) and counts each signed-in
// customer who opens checkout once (CU §10.6). «استئناف» ends it, with the
// optional «الخدمة عادت» push to those customers (CU §14 #19); the automatic
// resume never sends it.
@Injectable()
export class EmergencyStops {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
    private readonly pushes: PushQueue,
    private readonly broadcasts: PlatformBroadcasts,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
    private readonly geo: GeoService,
  ) {}

  // The city's open stop, or null: what the quote checks.
  async active(cityId: string): Promise<EmergencyStop | null> {
    const [stop] = await this.database.db
      .select()
      .from(emergencyStops)
      .where(and(eq(emergencyStops.cityId, cityId), isNull(emergencyStops.endedAt)));
    return stop ? toStop(stop) : null;
  }

  // AP §9.1.6 item 1, inside the order's transaction: whether the city's
  // stop is on, under the shared side of the lock a start takes, so an order
  // either commits before the stop starts (and its customer gets the delay
  // notice) or sees it.
  async stopsOrders(tx: Tx, cityId: string): Promise<boolean> {
    await tx.execute(
      sql`SELECT pg_advisory_xact_lock_shared(hashtextextended(${lockKey(cityId)}, 0))`,
    );
    const [open] = await tx
      .select({ id: emergencyStops.id })
      .from(emergencyStops)
      .where(and(eq(emergencyStops.cityId, cityId), isNull(emergencyStops.endedAt)));
    return open !== undefined;
  }

  // AP §9.1.6 item 4: the open stop with its attempts so far.
  async current(cityId: string): Promise<EmergencyStopView | null> {
    const stop = await this.active(cityId);
    if (stop === null) return null;
    const [row] = await this.database.db
      .select({ attempts: count() })
      .from(emergencyStopAttempts)
      .where(eq(emergencyStopAttempts.stopId, stop.id));
    return { ...stop, attempts: row?.attempts ?? 0 };
  }

  // The dialog's prefilled messages (AP Appendix A).
  async defaults(cityId: string): Promise<{ browseMessage: string; delayNotice: string }> {
    const [browseMessage, delayNotice] = await Promise.all([
      this.settings.get('platform.emergency_default_message_browse', { cityId }),
      this.settings.get('platform.emergency_default_message_active', { cityId }),
    ]);
    return { browseMessage, delayNotice };
  }

  // CU §10.6: a customer who opened checkout during the stop, once per stop.
  async recordAttempt(stopId: string, customerAccountId: string, now: Date): Promise<void> {
    await this.database.db
      .insert(emergencyStopAttempts)
      .values({ stopId, customerAccountId, at: now })
      .onConflictDoNothing();
  }

  async start(
    command: StartStop & { admin: Admin; context: AuditRequestContext },
    now: Date,
  ): Promise<EmergencyStopView> {
    if (command.resumeAt !== null && command.resumeAt.getTime() <= now.getTime()) {
      throw new EmergencyStopRefusedError('resume_at_past');
    }
    if ((await this.geo.cityTimeZone(command.cityId)) === null) {
      throw new EmergencyStopRefusedError('unknown_city');
    }
    await this.jobs.ready();
    return this.database.db.transaction(async (tx) => {
      await lockCity(tx, command.cityId);
      const [open] = await tx
        .select({ id: emergencyStops.id })
        .from(emergencyStops)
        .where(and(eq(emergencyStops.cityId, command.cityId), isNull(emergencyStops.endedAt)));
      if (open) throw new EmergencyStopRefusedError('already_stopped');
      const [row] = await tx
        .insert(emergencyStops)
        .values({
          cityId: command.cityId,
          startedAt: now,
          startedBy: command.admin.accountId,
          internalReason: command.internalReason,
          browseMessage: command.browseMessage,
          delayNotice: command.delayNotice,
          customerReason: command.customerReason,
          resumeAt: command.resumeAt,
        })
        .returning();
      const stop = toStop(row!);
      if (stop.resumeAt !== null) {
        const job: EmergencyResumeJob = { stopId: stop.id };
        await this.jobs.send(QUEUES.emergencyResume, job, {
          startAfter: stop.resumeAt,
          db: inTransaction(tx),
        });
      }
      const active = await activeOrders(tx, stop.cityId);
      await this.pushes.enqueue(tx, delayPushes(stop, active), now);
      await this.broadcasts.enqueue(tx, {
        type: 'platform.emergency_stop',
        cityId: stop.cityId,
        active: true,
        orderIds: active.map(({ orderId }) => orderId),
        at: now,
      });
      await this.audit.recordWrite(
        {
          actor: adminActor(command.admin),
          context: command.context,
          cityId: stop.cityId,
          action: 'emergency_stop.start',
          target: { type: 'emergency_stop', id: stop.id },
          before: null,
          after: {
            browseMessage: stop.browseMessage,
            delayNotice: stop.delayNotice,
            customerReason: stop.customerReason,
            resumeAt: stop.resumeAt?.toISOString() ?? null,
          },
          reason: stop.internalReason,
        },
        tx,
      );
      return { ...stop, attempts: 0 };
    });
  }

  // «استئناف»: ends the stop the panel showed; serviceBack is the text of
  // «الخدمة عادت», sent to the customers who opened checkout during it.
  async resume(
    command: {
      cityId: string;
      stopId: string;
      serviceBack: string | null;
      admin: Admin;
      context: AuditRequestContext;
    },
    now: Date,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      await lockCity(tx, command.cityId);
      const [row] = await tx
        .select()
        .from(emergencyStops)
        .where(
          and(eq(emergencyStops.id, command.stopId), eq(emergencyStops.cityId, command.cityId)),
        );
      if (!row) throw new EmergencyStopRefusedError('unknown_stop');
      if (row.endedAt !== null) throw new EmergencyStopRefusedError('stop_ended');
      await tx
        .update(emergencyStops)
        .set({
          endedAt: now,
          endedBy: command.admin.accountId,
          endKind: 'manual',
          serviceBackMessage: command.serviceBack,
        })
        .where(eq(emergencyStops.id, row.id));
      if (command.serviceBack !== null) {
        await this.pushes.enqueue(
          tx,
          await serviceBackPushes(tx, row.id, command.serviceBack),
          now,
        );
      }
      await this.ended(tx, row.cityId, now);
      await this.audit.recordWrite(
        {
          actor: adminActor(command.admin),
          context: command.context,
          cityId: row.cityId,
          action: 'emergency_stop.resume',
          target: { type: 'emergency_stop', id: row.id },
          before: { startedAt: row.startedAt.toISOString() },
          after: { endKind: 'manual', serviceBack: command.serviceBack },
          reason: null,
        },
        tx,
      );
    });
  }

  // The automatic resume (AP §9.1.6): ends the stop if it is still on, with
  // no push. True when it did.
  async autoResume(job: EmergencyResumeJob, now: Date): Promise<boolean> {
    return this.database.db.transaction(async (tx) => {
      const [row] = await tx
        .select({ cityId: emergencyStops.cityId })
        .from(emergencyStops)
        .where(eq(emergencyStops.id, job.stopId));
      if (!row) return false;
      await lockCity(tx, row.cityId);
      const ended = await tx
        .update(emergencyStops)
        .set({ endedAt: now, endKind: 'automatic' })
        .where(and(eq(emergencyStops.id, job.stopId), isNull(emergencyStops.endedAt)))
        .returning({ id: emergencyStops.id });
      if (ended.length === 0) return false;
      await this.ended(tx, row.cityId, now);
      await this.audit.recordWrite(
        {
          actor: { type: 'system', id: null, role: null },
          context: { ipAddress: null, device: null },
          cityId: row.cityId,
          action: 'emergency_stop.resume',
          target: { type: 'emergency_stop', id: job.stopId },
          before: null,
          after: { endKind: 'automatic', serviceBack: null },
          reason: null,
        },
        tx,
      );
      return true;
    });
  }

  // The end reaches the apps and every active order's screen, whose delay
  // banner goes (CU §4.7).
  private async ended(tx: Tx, cityId: string, now: Date): Promise<void> {
    const active = await activeOrders(tx, cityId);
    await this.broadcasts.enqueue(tx, {
      type: 'platform.emergency_stop',
      cityId,
      active: false,
      orderIds: active.map(({ orderId }) => orderId),
      at: now,
    });
  }
}

// Starting, resuming and the automatic resume of one city take turns.
const lockKey = (cityId: string) => `emergency-stop:${cityId}`;

async function lockCity(tx: Tx, cityId: string): Promise<void> {
  await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtextextended(${lockKey(cityId)}, 0))`);
}

function adminActor(admin: Admin) {
  return { type: 'admin' as const, id: admin.accountId, role: admin.roles.join(',') };
}

function toStop(row: typeof emergencyStops.$inferSelect): EmergencyStop {
  return {
    id: row.id,
    cityId: row.cityId,
    startedAt: row.startedAt,
    startedBy: row.startedBy,
    internalReason: row.internalReason,
    browseMessage: row.browseMessage,
    delayNotice: row.delayNotice,
    customerReason: row.customerReason,
    resumeAt: row.resumeAt,
  };
}

// The city's active orders, newest first.
async function activeOrders(
  tx: Tx,
  cityId: string,
): Promise<{ accountId: string; orderId: string }[]> {
  return tx
    .select({ accountId: orders.customerAccountId, orderId: orders.id })
    .from(orders)
    .where(and(eq(orders.cityId, cityId), inArray(orders.status, [...ACTIVE])))
    .orderBy(desc(orders.placedAt));
}

// CU §14 #18: one delay notice per customer with an active order in the
// city, opening their latest active order.
function delayPushes(
  stop: EmergencyStop,
  active: { accountId: string; orderId: string }[],
): QueuedPush[] {
  const body = delayNoticeText(stop);
  const seen = new Set<string>();
  return active.flatMap(({ accountId, orderId }) => {
    if (seen.has(accountId)) return [];
    seen.add(accountId);
    return [
      {
        source: `emergency-delay:${stop.id}:${accountId}`,
        recipient: { party: 'customer' as const, accountId },
        templateKey: 'customer.emergency_delay',
        body,
        level: 'default',
        priority: 'normal' as const,
        data: { target: 'order', orderId },
      },
    ];
  });
}

// CU §14 #19: «الخدمة عادت» to every customer who opened checkout during
// the stop.
async function serviceBackPushes(tx: Tx, stopId: string, body: string): Promise<QueuedPush[]> {
  const attempts = await tx
    .select({ accountId: emergencyStopAttempts.customerAccountId })
    .from(emergencyStopAttempts)
    .where(eq(emergencyStopAttempts.stopId, stopId));
  return attempts.map(({ accountId }) => ({
    source: `emergency-back:${stopId}:${accountId}`,
    recipient: { party: 'customer' as const, accountId },
    templateKey: 'customer.service_back',
    body,
    level: 'default',
    priority: 'normal' as const,
    data: { target: 'home' },
  }));
}

// The worker's automatic resume.
@Injectable()
export class EmergencyStopWorker implements OnModuleInit {
  private readonly logger = new Logger('EmergencyStop');

  constructor(
    private readonly jobs: Jobs,
    private readonly stops: EmergencyStops,
  ) {}

  async onModuleInit(): Promise<void> {
    await this.jobs.work<EmergencyResumeJob>(QUEUES.emergencyResume, async (batch) => {
      for (const job of batch) {
        try {
          if (await this.stops.autoResume(job.data, new Date())) {
            this.logger.log({ stopId: job.data.stopId }, 'emergency stop resumed automatically');
          }
        } catch (error) {
          // pg-boss tries it again (QUEUE_OPTIONS); each failure is reported.
          this.logger.error({ err: error, stopId: job.data.stopId }, 'automatic resume failed');
          reportError(error);
          throw error;
        }
      }
    });
  }
}
