import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, gt, inArray, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { AuditService } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import type { OpeningPeriod } from './hours.js';
import {
  type Coverage,
  type MerchantChange,
  type Money,
  MerchantsRefusedError,
  MerchantsService,
} from './merchants.service.js';
import type { OperatingState } from './operating-state.js';
import { holidayCloses, pauses, restaurants, stateOutbox } from './schema.js';
import { recordStateChange, type StateKind } from './state-events.js';
import {
  busyModeEnd,
  checkHolidayClose,
  PAUSE_CHOICES_MIN,
  restaurantPauseEnd,
  restaurantResume,
} from './status-rules.js';

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

// What the restaurant app's status pill and sheet show (RA §6.2, §7.2).
export interface RestaurantStatus {
  state: OperatingState;
  // The next schedule change: the end of the opening period it is in, or,
  // closed by the schedule, the next opening.
  closesAt: Date | null;
  opensAt: Date | null;
  // Busy mode while it is on, whatever the state (RA §7.3).
  busyMode: { extraMin: number; until: Date } | null;
  // RA §7.4: counted only against a maximum.
  activeOrders: number | null;
  maxActiveOrders: number | null;
  // The holiday close in force or the next one set (RA §10).
  holiday: { startsAt: Date; endsAt: Date; message: string | null } | null;
  pauseChoicesMin: readonly number[];
  busyExtraOptionsMin: number[];
  busyReminderMin: number;
}

// A committed state change as the relay sees it (state-events.ts).
export interface RelayedStateChange {
  id: bigint;
  at: Date;
  restaurantId: string;
  cityId: string;
  kind: StateKind;
  values: Record<string, string | number | boolean>;
}

// Rows taken per transaction, which holds their locks while it relays.
const RELAY_BATCH = 20;

// RA §16 #24: the pause a timer was set for.
export interface PauseEndJob {
  pauseId: string;
  restaurantId: string;
}

// RA §7.3: the busy mode a reminder was set for, by when it started.
export interface BusyReminderJob {
  restaurantId: string;
  // ISO time.
  startedAt: string;
  // ISO time, the moment the reminder was set for; a job sent before it
  // existed reminds at its run.
  due?: string;
}

// RA §10: what «الحالة والأوقات» shows an owner.
export interface RestaurantHours {
  periods: OpeningPeriod[];
  holiday: RestaurantStatus['holiday'];
  defaultPrepMin: number;
  prepFloorMin: number;
  prepCeilingMin: number;
  maxActiveOrders: number | null;
  // Read-only, set by admins (R13).
  minimumOrder: Money;
  coverage: Coverage;
  commissionBp: number | null;
  settlementWeekday: string;
}

// RA §7, §10, §18: the restaurant's status commands. Each takes the
// restaurant's row lock, reads the state inside its transaction, and is
// audited with who set it and from which device (RA §7.1 «Logging»).
@Injectable()
export class RestaurantStatusService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly settings: SettingsService,
    private readonly audit: AuditService,
    private readonly jobs: Jobs,
  ) {}

  async status(restaurantId: string, now = new Date()): Promise<RestaurantStatus> {
    const db = this.database.db;
    const storefront = await this.merchants.storefrontState(restaurantId, now);
    const [row] = await db
      .select({
        cityId: restaurants.cityId,
        maxActiveOrders: restaurants.maxActiveOrders,
        busyExtraMin: restaurants.busyExtraMin,
        busyUntil: restaurants.busyUntil,
      })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    if (!row) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    const [holiday] = await db
      .select({
        startsAt: holidayCloses.startsAt,
        endsAt: holidayCloses.endsAt,
        message: holidayCloses.message,
      })
      .from(holidayCloses)
      .where(
        and(
          eq(holidayCloses.restaurantId, restaurantId),
          isNull(holidayCloses.endedAt),
          gt(holidayCloses.endsAt, now),
        ),
      )
      .orderBy(asc(holidayCloses.startsAt))
      .limit(1);
    const scope = { cityId: row.cityId };
    const [busyExtraOptionsMin, busyReminderMin] = await Promise.all([
      this.settings.get('merchant.busy_extra_options_min', scope),
      this.settings.get('merchant.busy_mode_reminder_min', scope),
    ]);
    return {
      state: storefront.state,
      closesAt: storefront.closesAt,
      opensAt: storefront.opensAt,
      busyMode:
        row.busyExtraMin !== null && row.busyUntil !== null && row.busyUntil > now
          ? { extraMin: row.busyExtraMin, until: row.busyUntil }
          : null,
      activeOrders:
        row.maxActiveOrders === null ? null : await this.merchants.activeOrderCount(restaurantId),
      maxActiveOrders: row.maxActiveOrders,
      holiday: holiday ?? null,
      pauseChoicesMin: PAUSE_CHOICES_MIN,
      busyExtraOptionsMin,
      busyReminderMin,
    };
  }

  async hours(restaurantId: string, now = new Date()): Promise<RestaurantHours> {
    const restaurant = await this.merchants.restaurant(restaurantId, now);
    if (!restaurant) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    const scope = { cityId: restaurant.cityId };
    const [status, prepFloorMin, prepCeilingMin, settlementWeekday] = await Promise.all([
      this.status(restaurantId, now),
      this.settings.get('merchant.prep_time_floor_min', scope),
      this.settings.get('merchant.prep_time_ceiling_min', scope),
      this.settings.get('merchant.settlement_weekday', scope),
    ]);
    return {
      periods: restaurant.schedule,
      holiday: status.holiday,
      defaultPrepMin: restaurant.defaultPrepMin,
      prepFloorMin,
      prepCeilingMin,
      maxActiveOrders: restaurant.maxActiveOrders,
      minimumOrder: restaurant.minimumOrder,
      coverage: restaurant.coverage,
      commissionBp: restaurant.commissionBp,
      settlementWeekday,
    };
  }

  // RA §7.2: «إيقاف 15 د», «30 د», «60 د» or «حتى أعيد الفتح» (null).
  async pause(
    restaurantId: string,
    minutes: number | null,
    change: MerchantChange,
    now = new Date(),
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lock(tx, restaurantId);
      const { state, closesAt } = await this.merchants.storefrontState(restaurantId, now, tx);
      const outcome = restaurantPauseEnd(state, closesAt, minutes, now);
      if ('refusal' in outcome) throw refused(outcome.refusal);
      // Its own pause is replaced (one pause at a time).
      await this.endOwnPause(tx, restaurantId, change, now);
      const [pause] = await tx
        .insert(pauses)
        .values({
          restaurantId,
          source: 'restaurant',
          startsAt: now,
          endsAt: outcome.endsAt,
          setById: change.actor.id,
        })
        .returning({ id: pauses.id });
      const job: PauseEndJob = { pauseId: pause!.id, restaurantId };
      await this.jobs.send(QUEUES.pauseEnd, job, {
        startAfter: outcome.endsAt,
        db: inTransaction(tx),
      });
      await this.record(tx, change, row.cityId, restaurantId, 'restaurant.pause', {
        before: { state: state.state },
        after: { minutes, until: outcome.endsAt.toISOString() },
      });
      await this.changed(tx, row.cityId, restaurantId, 'paused', now);
    });
  }

  // RA §7.2 «استئناف الاستقبال»: ends the restaurant's own pause.
  async resume(restaurantId: string, change: MerchantChange, now = new Date()): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lock(tx, restaurantId);
      const { state } = await this.merchants.storefrontState(restaurantId, now, tx);
      const outcome = restaurantResume(state);
      if (outcome === 'paused_by_operations') throw refused(outcome);
      if (outcome === 'nothing') return;
      await this.endOwnPause(tx, restaurantId, change, now);
      await this.record(tx, change, row.cityId, restaurantId, 'restaurant.resume', {
        before: { state: state.state },
        after: null,
      });
      await this.changed(tx, row.cityId, restaurantId, 'resumed', now);
    });
  }

  // RA §7.3: busy mode on with +10 or +20 minutes, or off (null).
  async setBusyMode(
    restaurantId: string,
    extraMin: number | null,
    change: MerchantChange,
    now = new Date(),
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lock(tx, restaurantId);
      const [current] = await tx
        .select({ extraMin: restaurants.busyExtraMin, until: restaurants.busyUntil })
        .from(restaurants)
        .where(eq(restaurants.id, restaurantId));
      const before =
        current?.extraMin != null && current.until !== null && current.until > now
          ? { extraMin: current.extraMin }
          : null;
      if (extraMin === null) {
        if (before === null) return;
        await tx
          .update(restaurants)
          .set({ busyExtraMin: null, busyUntil: null, busyStartedAt: null, updatedAt: sql`now()` })
          .where(eq(restaurants.id, restaurantId));
      } else {
        const { state, closesAt } = await this.merchants.storefrontState(restaurantId, now, tx);
        const options = await this.settings.get('merchant.busy_extra_options_min', {
          cityId: row.cityId,
        });
        const outcome = busyModeEnd(state, closesAt, extraMin, options);
        if ('refusal' in outcome) throw refused(outcome.refusal);
        if (before?.extraMin === extraMin) return;
        await tx
          .update(restaurants)
          .set({
            busyExtraMin: extraMin,
            busyUntil: outcome.endsAt,
            busyStartedAt: now,
            updatedAt: sql`now()`,
          })
          .where(eq(restaurants.id, restaurantId));
        await this.remindBusyMode(tx, row.cityId, { restaurantId, startedAt: now }, now);
      }
      await this.record(tx, change, row.cityId, restaurantId, 'restaurant.busy_mode', {
        before,
        after: extraMin === null ? null : { extraMin },
      });
      await this.changed(tx, row.cityId, restaurantId, 'busy_mode', now);
    });
  }

  // RA §10 «إغلاق لعدة أيام»: from now or a later moment until a later one,
  // with an optional message. One at a time: a new one replaces the one in
  // force or set. Active orders are not affected.
  async setHolidayClose(
    restaurantId: string,
    close: { startsAt: Date | null; endsAt: Date; message: string | null },
    change: MerchantChange,
    now = new Date(),
  ): Promise<void> {
    const message = close.message?.trim() || null;
    const startsAt = close.startsAt ?? now;
    const problem = checkHolidayClose({ startsAt, endsAt: close.endsAt, message }, now);
    if (problem !== null) throw new MerchantsRefusedError('invalid_holiday_close', problem);
    await this.database.db.transaction(async (tx) => {
      const row = await this.lock(tx, restaurantId);
      // RA §18 «Holiday close / end»: not while suspended.
      if (row.accountStatus === 'suspended') {
        throw new MerchantsRefusedError('restaurant_suspended', 'the restaurant is suspended');
      }
      const before = await this.endHolidays(tx, restaurantId, change, now);
      const storedStart = startsAt.getTime() < now.getTime() ? now : startsAt;
      await tx.insert(holidayCloses).values({
        restaurantId,
        startsAt: storedStart,
        endsAt: close.endsAt,
        message,
        ...setBy(change),
      });
      await this.record(tx, change, row.cityId, restaurantId, 'restaurant.holiday_close', {
        before,
        after: {
          startsAt: storedStart.toISOString(),
          endsAt: close.endsAt.toISOString(),
          message,
        },
      });
      await this.changed(tx, row.cityId, restaurantId, 'holiday_close', now);
    });
  }

  // RA §10: ends the holiday close in force, or cancels the one set.
  async endHolidayClose(
    restaurantId: string,
    change: MerchantChange,
    now = new Date(),
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lock(tx, restaurantId);
      const before = await this.endHolidays(tx, restaurantId, change, now);
      if (before === null) return;
      await this.record(tx, change, row.cityId, restaurantId, 'restaurant.holiday_close.end', {
        before,
        after: null,
      });
      await this.changed(tx, row.cityId, restaurantId, 'holiday_close', now);
    });
  }

  // RA §10: the default prep time preselected on the accept prompt (§8.5),
  // within the chooser's limits, and the maximum active orders (off, or 1 to
  // 50, §7.4). Each applies at once.
  async setOrderSettings(
    restaurantId: string,
    settings: { defaultPrepMin: number; maxActiveOrders: number | null },
    change: MerchantChange,
    now = new Date(),
  ): Promise<void> {
    const { defaultPrepMin, maxActiveOrders } = settings;
    if (
      maxActiveOrders !== null &&
      (!Number.isInteger(maxActiveOrders) || maxActiveOrders < 1 || maxActiveOrders > 50)
    ) {
      throw new MerchantsRefusedError(
        'invalid_max_active_orders',
        'the maximum active orders is off or 1 to 50',
      );
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.lock(tx, restaurantId);
      const scope = { cityId: row.cityId };
      const [floor, ceiling] = await Promise.all([
        this.settings.get('merchant.prep_time_floor_min', scope),
        this.settings.get('merchant.prep_time_ceiling_min', scope),
      ]);
      if (!Number.isInteger(defaultPrepMin) || defaultPrepMin < floor || defaultPrepMin > ceiling) {
        throw new MerchantsRefusedError(
          'invalid_prep_time',
          `the default prep time is ${floor} to ${ceiling} minutes`,
        );
      }
      const [current] = await tx
        .select({
          defaultPrepMin: restaurants.defaultPrepMin,
          maxActiveOrders: restaurants.maxActiveOrders,
        })
        .from(restaurants)
        .where(eq(restaurants.id, restaurantId));
      if (!current) return;
      if (
        current.defaultPrepMin === defaultPrepMin &&
        current.maxActiveOrders === maxActiveOrders
      ) {
        return;
      }
      if (current.defaultPrepMin !== defaultPrepMin) {
        await this.record(tx, change, row.cityId, restaurantId, 'restaurant.prep_time', {
          before: { defaultPrepMin: current.defaultPrepMin },
          after: { defaultPrepMin },
        });
      }
      if (current.maxActiveOrders !== maxActiveOrders) {
        await this.record(tx, change, row.cityId, restaurantId, 'restaurant.max_active_orders', {
          before: { maxActiveOrders: current.maxActiveOrders },
          after: { maxActiveOrders },
        });
      }
      await tx
        .update(restaurants)
        .set({ defaultPrepMin, maxActiveOrders, updatedAt: sql`now()` })
        .where(eq(restaurants.id, restaurantId));
      await this.changed(tx, row.cityId, restaurantId, 'order_settings', now);
    });
  }

  // RA §16 #24: a timed pause reached its end. Only the pause the job was
  // set for, not ended early, and once (`end_told_at`); the push says the
  // restaurant takes orders only when it does (a pause that ended with the
  // opening period leaves it closed). pg-boss starts jobs by the database's
  // clock, so the end is due by either clock; one early by both is sent again
  // for its moment. True when it recorded the end.
  async pauseEnded(job: PauseEndJob, now = new Date()): Promise<boolean> {
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockAny(tx, job.restaurantId);
      if (row.accountStatus === 'terminated') return false;
      const [pause] = await tx
        .select({ endsAt: pauses.endsAt, endedAt: pauses.endedAt, toldAt: pauses.endToldAt })
        .from(pauses)
        .where(and(eq(pauses.id, job.pauseId), eq(pauses.restaurantId, job.restaurantId)))
        .for('update');
      if (!pause || pause.endedAt !== null || pause.toldAt !== null || pause.endsAt === null) {
        return false;
      }
      const at = new Date(Math.max(now.getTime(), (await databaseNow(tx)).getTime()));
      if (pause.endsAt > at) {
        await this.jobs.send(QUEUES.pauseEnd, job, {
          startAfter: pause.endsAt,
          db: inTransaction(tx),
        });
        return false;
      }
      await tx.update(pauses).set({ endToldAt: at }).where(eq(pauses.id, job.pauseId));
      const { state } = await this.merchants.storefrontState(job.restaurantId, at, tx);
      const takesOrders = state.state === 'open' || state.state === 'busy';
      await this.changed(tx, row.cityId, job.restaurantId, 'pause_ended', at, {
        push: takesOrders,
      });
      return true;
    });
  }

  // RA §7.3, §16 #25: busy mode is still the one the job was set for and this
  // reminder's moment is newer than the last one sent (`busy_reminded_at`), so
  // a repeated job sends nothing; the next is set while busy mode lasts, with
  // an id derived from its moment, so a repeat never starts a second chain.
  // True when it reminded.
  async busyReminder(job: BusyReminderJob, now = new Date()): Promise<boolean> {
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockAny(tx, job.restaurantId);
      if (row.accountStatus === 'terminated') return false;
      const [busy] = await tx
        .select({
          extraMin: restaurants.busyExtraMin,
          until: restaurants.busyUntil,
          startedAt: restaurants.busyStartedAt,
          remindedAt: restaurants.busyRemindedAt,
        })
        .from(restaurants)
        .where(eq(restaurants.id, job.restaurantId));
      const due = new Date(job.due ?? now.toISOString());
      if (
        !busy ||
        busy.extraMin === null ||
        busy.until === null ||
        busy.until <= now ||
        busy.startedAt?.getTime() !== new Date(job.startedAt).getTime() ||
        (busy.remindedAt !== null && busy.remindedAt >= due)
      ) {
        return false;
      }
      await tx
        .update(restaurants)
        .set({ busyRemindedAt: due })
        .where(eq(restaurants.id, job.restaurantId));
      await this.changed(tx, row.cityId, job.restaurantId, 'busy_reminder', now, {
        extraMin: busy.extraMin,
      });
      await this.remindBusyMode(
        tx,
        row.cityId,
        { restaurantId: job.restaurantId, startedAt: new Date(job.startedAt) },
        due,
        busy.until,
      );
      return true;
    });
  }

  // The next reminder, merchant.busy_mode_reminder_min after [from], while
  // busy mode lasts.
  private async remindBusyMode(
    tx: Tx,
    cityId: string,
    busy: { restaurantId: string; startedAt: Date },
    from: Date,
    until?: Date,
  ): Promise<void> {
    const reminderMin = await this.settings.get('merchant.busy_mode_reminder_min', { cityId });
    const at = new Date(from.getTime() + reminderMin * 60_000);
    if (until !== undefined && at >= until) return;
    const job: BusyReminderJob = {
      restaurantId: busy.restaurantId,
      startedAt: busy.startedAt.toISOString(),
      due: at.toISOString(),
    };
    await this.jobs.send(QUEUES.busyReminder, job, {
      id: jobId(`${busy.restaurantId}:${job.startedAt}`, at),
      startAfter: at,
      db: inTransaction(tx),
    });
  }

  private async changed(
    tx: Tx,
    cityId: string,
    restaurantId: string,
    kind: StateKind,
    at: Date,
    values?: Record<string, string | number | boolean>,
  ): Promise<void> {
    await recordStateChange(tx, this.jobs, {
      restaurantId,
      cityId,
      kind,
      at,
      ...(values ? { values } : {}),
    });
  }

  // RA §8.3, AP §9.6.5: the auto-pause after the business day's unanswered
  // orders, written in the transaction of the automatic cancellation. It
  // takes the restaurant's lock first and then reads the count (`unanswered`,
  // read through the transaction), so two cancellations committing together
  // never both miss the limit. It replaces a restaurant pause (one pause at a
  // time), holds across opening periods until operations resume it, and is
  // not added over an operations pause or an auto-pause already in force, nor
  // for a terminated restaurant. True when it paused.
  async autoPauseIfDue(
    tx: Tx,
    restaurantId: string,
    unanswered: () => Promise<{ count: number; limit: number }>,
    now: Date,
  ): Promise<boolean> {
    const row = await this.lockAny(tx, restaurantId);
    if (row.accountStatus === 'terminated') return false;
    const { count, limit } = await unanswered();
    if (count < limit) return false;
    const { state } = await this.merchants.storefrontState(restaurantId, now, tx);
    if (state.state === 'paused' && state.source !== 'restaurant') return false;
    const [held] = await tx
      .select({ id: pauses.id })
      .from(pauses)
      .where(
        and(
          eq(pauses.restaurantId, restaurantId),
          inArray(pauses.source, ['ops', 'auto']),
          isNull(pauses.endedAt),
          sql`(${pauses.endsAt} IS NULL OR ${pauses.endsAt} > ${now.toISOString()})`,
        ),
      )
      .limit(1);
    if (held) return false;
    const system: MerchantChange = {
      actor: { type: 'system', id: null, role: null },
      context: { ipAddress: null, device: null },
    };
    await tx
      .update(pauses)
      .set({ endedAt: now, endedByType: 'system', endedById: null })
      .where(
        and(
          eq(pauses.restaurantId, restaurantId),
          eq(pauses.source, 'restaurant'),
          isNull(pauses.endedAt),
          sql`${pauses.endsAt} > ${now.toISOString()}`,
        ),
      );
    await tx.insert(pauses).values({ restaurantId, source: 'auto', startsAt: now });
    await this.record(tx, system, row.cityId, restaurantId, 'restaurant.auto_pause', {
      before: { state: state.state },
      after: { unansweredOrders: count },
    });
    await this.changed(tx, row.cityId, restaurantId, 'auto_paused', now, { count });
    return true;
  }

  // AP §9.1.3 «مطعم أوقف تلقائياً»: the city's restaurants under an
  // auto-pause now, with their names, for the alerts sweep.
  async autoPaused(cityId: string, now = new Date()): Promise<{ id: string; nameAr: string }[]> {
    return this.database.db
      .selectDistinct({ id: restaurants.id, nameAr: restaurants.nameAr })
      .from(pauses)
      .innerJoin(restaurants, eq(restaurants.id, pauses.restaurantId))
      .where(
        and(
          eq(restaurants.cityId, cityId),
          eq(pauses.source, 'auto'),
          isNull(pauses.endedAt),
          sql`${pauses.startsAt} <= ${now.toISOString()}`,
        ),
      );
  }

  // E4: hands the committed state changes, in id order, to the relay (the
  // notifications module publishes and pushes them; this module cannot import
  // it), and marks each relayed once it returns. Rows another run holds are
  // skipped; a row the relay throws on stops the run and stays for the next.
  async relayStateChanges(
    relay: (change: RelayedStateChange) => Promise<void>,
    now = new Date(),
  ): Promise<number> {
    let relayed = 0;
    let failure: unknown;
    for (;;) {
      const batch = await this.database.db.transaction(async (tx) => {
        const rows = await tx
          .select()
          .from(stateOutbox)
          .where(isNull(stateOutbox.relayedAt))
          .orderBy(asc(stateOutbox.id))
          .limit(RELAY_BATCH)
          .for('update', { skipLocked: true });
        const done: bigint[] = [];
        for (const row of rows) {
          try {
            await relay({
              id: row.id,
              at: row.createdAt,
              restaurantId: row.restaurantId,
              cityId: row.cityId,
              kind: row.kind as StateKind,
              values: (row.payload as { values?: RelayedStateChange['values'] }).values ?? {},
            });
          } catch (error) {
            failure = error;
            break;
          }
          done.push(row.id);
        }
        // Marked in the same transaction, which commits even when one failed.
        if (done.length > 0) {
          await tx.update(stateOutbox).set({ relayedAt: now }).where(inArray(stateOutbox.id, done));
        }
        return { taken: rows.length, done: done.length };
      });
      relayed += batch.done;
      if (failure !== undefined) throw failure;
      if (batch.taken < RELAY_BATCH) return relayed;
    }
  }

  // The holiday closes not ended and not over: the one in force and any set.
  private async endHolidays(
    tx: Tx,
    restaurantId: string,
    change: MerchantChange,
    now: Date,
  ): Promise<{ startsAt: string; endsAt: string } | null> {
    const ended = await tx
      .update(holidayCloses)
      .set({ endedAt: now, ...endedBy(change) })
      .where(
        and(
          eq(holidayCloses.restaurantId, restaurantId),
          isNull(holidayCloses.endedAt),
          gt(holidayCloses.endsAt, now),
        ),
      )
      .returning({ startsAt: holidayCloses.startsAt, endsAt: holidayCloses.endsAt });
    const [first] = ended;
    return first
      ? { startsAt: first.startsAt.toISOString(), endsAt: first.endsAt.toISOString() }
      : null;
  }

  private async endOwnPause(
    tx: Tx,
    restaurantId: string,
    change: MerchantChange,
    now: Date,
  ): Promise<void> {
    await tx
      .update(pauses)
      .set({ endedAt: now, endedByType: 'merchant', endedById: change.actor.id })
      .where(
        and(
          eq(pauses.restaurantId, restaurantId),
          eq(pauses.source, 'restaurant'),
          isNull(pauses.endedAt),
          sql`${pauses.endsAt} > ${now.toISOString()}`,
        ),
      );
  }

  private async lock(tx: Tx, restaurantId: string) {
    const row = await this.lockAny(tx, restaurantId);
    if (row.accountStatus === 'terminated') {
      throw new MerchantsRefusedError('restaurant_terminated', 'the restaurant is terminated');
    }
    return row;
  }

  // The lock of the timers and the auto-pause, which leave a terminated
  // restaurant alone rather than fail.
  private async lockAny(tx: Tx, restaurantId: string) {
    const [row] = await tx
      .select({ cityId: restaurants.cityId, accountStatus: restaurants.accountStatus })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId))
      .for('update');
    if (!row) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    return row;
  }

  private async record(
    tx: Tx,
    change: MerchantChange,
    cityId: string,
    restaurantId: string,
    action: string,
    values: { before: Record<string, unknown> | null; after: Record<string, unknown> | null },
  ): Promise<void> {
    await this.audit.recordWrite(
      {
        actor: change.actor,
        context: change.context,
        cityId,
        action,
        target: { type: 'restaurant', id: restaurantId },
        before: values.before,
        after: values.after,
        reason: change.reason ?? null,
      },
      tx,
    );
  }
}

function setBy(change: MerchantChange) {
  const { type, id } = change.actor;
  if (type !== 'admin' && type !== 'merchant' && type !== 'system') {
    throw new Error(`a ${type} does not change a restaurant`);
  }
  return { setByType: type, setById: id };
}

function endedBy(change: MerchantChange) {
  const { setByType, setById } = setBy(change);
  return { endedByType: setByType, endedById: setById };
}

function refused(
  refusal: 'restaurant_closed' | 'paused_by_operations' | 'invalid_pause' | 'invalid_busy_extra',
) {
  const messages = {
    restaurant_closed: 'the restaurant is not open',
    paused_by_operations: 'operations or the auto-pause paused the restaurant',
    invalid_pause: 'a pause lasts 15, 30 or 60 minutes, or until reopening',
    invalid_busy_extra: 'busy mode adds one of merchant.busy_extra_options_min',
  };
  return new MerchantsRefusedError(refusal, messages[refusal]);
}

async function databaseNow(tx: Tx): Promise<Date> {
  const [row] = (await tx
    .execute<{ now: Date }>(sql`SELECT now() AS now`)
    .then((result) => result.rows)) as [{ now: Date }];
  return new Date(row.now);
}

// A job id derived from its subject and moment (a UUID v5 shape), so the same
// timer sent twice is one job.
function jobId(subject: string, moment: Date): string {
  const hex = createHash('sha1').update(`${subject}:${moment.toISOString()}`).digest('hex');
  const variant = ((parseInt(hex.slice(16, 18), 16) & 0x3f) | 0x80).toString(16);
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-5${hex.slice(13, 16)}-${variant}${hex.slice(18, 20)}-${hex.slice(20, 32)}`;
}
