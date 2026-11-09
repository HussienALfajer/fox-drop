import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, gt, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
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
import { holidayCloses, pauses, restaurants } from './schema.js';
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
      await tx.insert(pauses).values({
        restaurantId,
        source: 'restaurant',
        startsAt: now,
        endsAt: outcome.endsAt,
        setById: change.actor.id,
      });
      await this.record(tx, change, row.cityId, restaurantId, 'restaurant.pause', {
        before: { state: state.state },
        after: { minutes, until: outcome.endsAt.toISOString() },
      });
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
          .set({ busyExtraMin: null, busyUntil: null, updatedAt: sql`now()` })
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
          .set({ busyExtraMin: extraMin, busyUntil: outcome.endsAt, updatedAt: sql`now()` })
          .where(eq(restaurants.id, restaurantId));
      }
      await this.record(tx, change, row.cityId, restaurantId, 'restaurant.busy_mode', {
        before,
        after: extraMin === null ? null : { extraMin },
      });
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
      await tx.insert(holidayCloses).values({
        restaurantId,
        startsAt: startsAt.getTime() < now.getTime() ? now : startsAt,
        endsAt: close.endsAt,
        message,
        ...setBy(change),
      });
      await this.record(tx, change, row.cityId, restaurantId, 'restaurant.holiday_close', {
        before,
        after: { startsAt: startsAt.toISOString(), endsAt: close.endsAt.toISOString(), message },
      });
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
    });
  }

  // RA §10: the default prep time preselected on the accept prompt (§8.5),
  // within the chooser's limits, and the maximum active orders (off, or 1 to
  // 50, §7.4). Each applies at once.
  async setOrderSettings(
    restaurantId: string,
    settings: { defaultPrepMin: number; maxActiveOrders: number | null },
    change: MerchantChange,
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
    });
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
    const [row] = await tx
      .select({ cityId: restaurants.cityId, accountStatus: restaurants.accountStatus })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId))
      .for('update');
    if (!row) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    if (row.accountStatus === 'terminated') {
      throw new MerchantsRefusedError('restaurant_terminated', 'the restaurant is terminated');
    }
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
