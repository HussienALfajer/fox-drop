import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { lockCityCurrencies, SettingsService } from '../settings/index.js';
import {
  parseRate,
  type Rate,
  type RateInput,
  type RateSnapshot,
  type RoundingMode,
  type SnapshotCurrency,
} from './conversion.js';
import { cityBases, cityCurrencies, currencies, rateVersions } from './schema.js';

export type FxRefusal =
  | 'unknown_currency'
  | 'inactive_currency'
  | 'not_city_currency'
  | 'no_base_currency'
  | 'base_locked'
  | 'base_disabled'
  | 'rate_missing'
  | 'rounding_unit_missing'
  | 'invalid_rate'
  | 'large_change_unconfirmed'
  | 'editor_required'
  | 'amounts_in_other_currency';

// A change or a snapshot fx refuses, with the reason the routes and the
// ordering module map to their own answers.
export class FxRefusedError extends Error {
  override readonly name = 'FxRefusedError';
  constructor(
    readonly refusal: FxRefusal,
    message: string,
  ) {
    super(message);
  }
}

export interface Currency {
  code: string;
  nameAr: string;
  symbol: string;
  decimals: number;
  status: 'active' | 'inactive';
}

// One of a city's accepted currencies (AP §8.6).
export interface CityCurrency {
  currency: string;
  displayOrder: number;
  enabled: boolean;
  isBase: boolean;
}

// The rate of a currency now, for the exchange rates screen (AP §9.10.4).
export interface CurrentRate {
  currency: string;
  baseCurrency: string;
  rate: Rate;
  versionId: string;
  editorId: string;
  reason: string | null;
  setAt: Date;
}

// Who changes the city's currencies and why, for the audit log. A rate is
// set by an admin only.
export interface FxChange {
  actor: AuditActor;
  context: AuditRequestContext;
  reason?: string | null;
}

// The database, or the open transaction of the caller's change.
export type FxExecutor = Pick<NodePgDatabase, 'select' | 'selectDistinctOn' | 'update' | 'execute'>;

// Currencies, a city's base and accepted currencies, rate versions and the
// rate snapshot an order keeps (AP §8.6, §9.10.4; architecture §4.2). The
// rounding unit and mode of each currency are the settings
// currency.<code>.rounding_unit and rounding_mode (Appendix A), read here.
@Injectable()
export class FxService implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly settings: SettingsService,
    private readonly audit: AuditService,
  ) {}

  // The settings check currency keys and amounts against the city's
  // currencies (AP §8.6) through this source.
  onModuleInit(): void {
    this.settings.useCityCurrencies({
      currenciesOfCity: async (cityId) => ({
        base: await this.baseCurrency(cityId),
        codes: (await this.cityCurrencies(cityId)).map((entry) => entry.currency),
      }),
    });
  }

  async currencies(): Promise<Currency[]> {
    return this.database.db.select().from(currencies).orderBy(asc(currencies.code));
  }

  async baseCurrency(cityId: string, executor: FxExecutor = this.database.db) {
    return (await this.base(cityId, executor))?.currency ?? null;
  }

  // The city's currencies in display order, enabled or not.
  async cityCurrencies(cityId: string, executor: FxExecutor = this.database.db) {
    const rows = await executor
      .select({
        currency: cityCurrencies.currency,
        displayOrder: cityCurrencies.displayOrder,
        enabled: cityCurrencies.enabled,
        base: cityBases.currency,
      })
      .from(cityCurrencies)
      .leftJoin(
        cityBases,
        and(
          eq(cityBases.cityId, cityCurrencies.cityId),
          eq(cityBases.currency, cityCurrencies.currency),
        ),
      )
      .where(eq(cityCurrencies.cityId, cityId))
      .orderBy(asc(cityCurrencies.displayOrder), asc(cityCurrencies.currency));
    return rows.map(({ base, ...row }): CityCurrency => ({ ...row, isBase: base !== null }));
  }

  // The newest rate of each of the city's other currencies, set since its
  // base currency was last chosen.
  async currentRates(cityId: string, executor: FxExecutor = this.database.db) {
    const base = await this.base(cityId, executor);
    if (base === null) return [];
    const rows = await executor
      .selectDistinctOn([rateVersions.currency])
      .from(rateVersions)
      .where(and(eq(rateVersions.cityId, cityId), eq(rateVersions.baseEpoch, base.epoch)))
      .orderBy(asc(rateVersions.currency), desc(rateVersions.id));
    return rows.map(rateOf);
  }

  // Every rate one currency of the city has had, newest first, for the
  // exchange rates screen (AP §9.10.4).
  async rateHistory(cityId: string, currency: string): Promise<CurrentRate[]> {
    const rows = await this.database.db
      .select()
      .from(rateVersions)
      .where(and(eq(rateVersions.cityId, cityId), eq(rateVersions.currency, currency)))
      .orderBy(desc(rateVersions.id))
      .limit(RATE_HISTORY_LIMIT);
    return rows.map(rateOf);
  }

  // Adds a currency to the city or changes its order or enabled flag. The
  // base currency stays enabled, and once the city has a base another
  // currency is enabled only with a rate against it.
  async setCityCurrency(
    cityId: string,
    entry: { currency: string; displayOrder: number; enabled: boolean },
    change: FxChange,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      await this.lockCity(tx, cityId);
      const currency = await this.currency(tx, entry.currency);
      const [before] = await tx
        .select({ displayOrder: cityCurrencies.displayOrder, enabled: cityCurrencies.enabled })
        .from(cityCurrencies)
        .where(and(eq(cityCurrencies.cityId, cityId), eq(cityCurrencies.currency, entry.currency)));
      if (!before && currency.status !== 'active') {
        throw new FxRefusedError('inactive_currency', `${entry.currency} is no longer in use`);
      }
      const base = await this.baseCurrency(cityId, tx);
      if (entry.currency === base && !entry.enabled) {
        throw new FxRefusedError('base_disabled', 'the base currency stays enabled');
      }
      if (entry.enabled && base !== null && entry.currency !== base) {
        if (currency.status !== 'active') {
          throw new FxRefusedError('inactive_currency', `${entry.currency} is no longer in use`);
        }
        const rates = await this.currentRates(cityId, tx);
        if (!rates.some((rate) => rate.currency === entry.currency)) {
          throw new FxRefusedError(
            'rate_missing',
            `${entry.currency} needs a rate against the base currency before it is enabled`,
          );
        }
      }
      const after = { displayOrder: entry.displayOrder, enabled: entry.enabled };
      if (before?.displayOrder === after.displayOrder && before.enabled === after.enabled) return;
      if (before) {
        await tx
          .update(cityCurrencies)
          .set({ ...after, updatedAt: sql`now()` })
          .where(
            and(eq(cityCurrencies.cityId, cityId), eq(cityCurrencies.currency, entry.currency)),
          );
      } else {
        await tx.insert(cityCurrencies).values({ cityId, currency: entry.currency, ...after });
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'city_currency.set',
          target: { type: 'city_currency', id: entry.currency },
          before: before ?? null,
          after,
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // Chooses the city's base currency (D25), one of its currencies.
  // It can change until the city's first order (snapshotForOrder), never
  // after.
  async setBaseCurrency(cityId: string, currency: string, change: FxChange): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      await this.lockCity(tx, cityId);
      const [current] = await tx
        .select()
        .from(cityBases)
        .where(eq(cityBases.cityId, cityId))
        .for('update');
      if (current?.lockedAt) {
        throw new FxRefusedError(
          'base_locked',
          'the base currency is locked since the city first order',
        );
      }
      if (current?.currency === currency) return;
      const [accepted] = await tx
        .select({ enabled: cityCurrencies.enabled })
        .from(cityCurrencies)
        .where(and(eq(cityCurrencies.cityId, cityId), eq(cityCurrencies.currency, currency)));
      if (!accepted) {
        throw new FxRefusedError('not_city_currency', `${currency} is not a currency of the city`);
      }
      // The city's money settings are in its base currency (AP §8.6). A
      // settings change takes the same lock, so none slips in meanwhile.
      const amounts = (await this.settings.cityAmounts(cityId)).filter(
        (amount) => amount.currency !== currency,
      );
      if (amounts.length > 0) {
        throw new FxRefusedError(
          'amounts_in_other_currency',
          `set these settings in ${currency} first: ${amounts.map((amount) => amount.key).join(', ')}`,
        );
      }
      // The base is always enabled. Every rate is against the base, so the
      // other currencies have none against the new one: they are disabled
      // until each gets its rate.
      if (!accepted.enabled) {
        await tx
          .update(cityCurrencies)
          .set({ enabled: true, updatedAt: sql`now()` })
          .where(and(eq(cityCurrencies.cityId, cityId), eq(cityCurrencies.currency, currency)));
      }
      const disabled = (await this.cityCurrencies(cityId, tx))
        .filter((entry) => entry.enabled && entry.currency !== currency)
        .map((entry) => entry.currency);
      if (disabled.length > 0) {
        await tx
          .update(cityCurrencies)
          .set({ enabled: false, updatedAt: sql`now()` })
          .where(
            and(eq(cityCurrencies.cityId, cityId), inArray(cityCurrencies.currency, disabled)),
          );
      }
      if (current) {
        await tx
          .update(cityBases)
          .set({ currency, epoch: current.epoch + 1, updatedAt: sql`now()` })
          .where(eq(cityBases.cityId, cityId));
      } else {
        await tx.insert(cityBases).values({ cityId, currency });
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'base_currency.set',
          target: { type: 'city', id: cityId },
          before: current ? { currency: current.currency } : null,
          after: { currency, disabled },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // A new rate version for one of the city's currencies, in effect at once
  // (AP §8.6). A change above fx.large_change_confirm_pct needs the editor's
  // second confirmation.
  async setRate(
    cityId: string,
    currency: string,
    input: RateInput,
    change: FxChange & { confirmLargeChange?: boolean },
  ): Promise<string> {
    const editorId = change.actor.type === 'admin' ? change.actor.id : null;
    if (editorId === null) {
      throw new FxRefusedError('editor_required', 'a rate is set by an admin');
    }
    let rate: Rate;
    try {
      rate = parseRate(input);
    } catch (error) {
      throw new FxRefusedError('invalid_rate', (error as Error).message);
    }
    const confirmPct = await this.settings.get('fx.large_change_confirm_pct', { cityId });

    return this.database.db.transaction(async (tx) => {
      await this.lockCity(tx, cityId);
      const current = await this.base(cityId, tx);
      if (current === null) {
        throw new FxRefusedError('no_base_currency', 'the city has no base currency');
      }
      const base = current.currency;
      const accepted = await this.cityCurrencies(cityId, tx);
      if (!accepted.some((entry) => entry.currency === currency)) {
        throw new FxRefusedError('not_city_currency', `${currency} is not a currency of the city`);
      }
      if (currency === base) {
        throw new FxRefusedError('invalid_rate', 'the base currency has no rate');
      }
      const previous = (await this.currentRates(cityId, tx)).find(
        (entry) => entry.currency === currency,
      );
      if (
        previous &&
        !change.confirmLargeChange &&
        isLargeChange(previous.rate, rate, confirmPct, input.direction)
      ) {
        throw new FxRefusedError(
          'large_change_unconfirmed',
          `the rate moves by more than ${confirmPct}%; confirm it again`,
        );
      }
      const [version] = await tx
        .insert(rateVersions)
        .values({
          cityId,
          currency,
          baseCurrency: base,
          baseEpoch: current.epoch,
          rateNumerator: rate.numerator,
          rateDenominator: rate.denominator,
          editorId,
          reason: change.reason?.trim() || null,
        })
        .returning({ id: rateVersions.id });
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'rate.set',
          target: { type: 'rate', id: currency },
          before: previous ? { rate: rateText(previous.rate), baseCurrency: base } : null,
          after: { rate: rateText(rate), baseCurrency: base },
          reason: change.reason ?? null,
        },
        tx,
      );
      return version!.id;
    });
  }

  // The rates a quote shows: every enabled currency of the city with its
  // current rate version and rounding rule.
  async snapshot(cityId: string, executor: FxExecutor = this.database.db): Promise<RateSnapshot> {
    const base = await this.baseCurrency(cityId, executor);
    if (base === null)
      throw new FxRefusedError('no_base_currency', 'the city has no base currency');
    const accepted = (await this.cityCurrencies(cityId, executor)).filter((entry) => entry.enabled);
    const rates = new Map(
      (await this.currentRates(cityId, executor)).map((rate) => [rate.currency, rate]),
    );
    const decimals = new Map(
      (await executor.select().from(currencies)).map((row) => [row.code, row.decimals]),
    );
    const snapshot: SnapshotCurrency[] = [];
    for (const entry of accepted) {
      const rate = entry.currency === base ? null : rates.get(entry.currency);
      if (rate === undefined) {
        throw new FxRefusedError('rate_missing', `${entry.currency} has no rate`);
      }
      snapshot.push({
        code: entry.currency,
        decimals: decimals.get(entry.currency)!,
        rate: rate?.rate ?? { numerator: 1n, denominator: 1n },
        rateVersionId: rate?.versionId ?? null,
        ...(await this.rounding(cityId, entry.currency)),
      });
    }
    return { cityId, baseCurrency: base, takenAt: new Date(), currencies: snapshot };
  }

  // The snapshot an order keeps, inside the transaction that places it: the
  // city's base currency is locked from its first order on (AP §8.6). The
  // first order writes the lock; every order then holds a shared row lock,
  // which other orders share and a base change waits for (or makes them wait).
  async snapshotForOrder(cityId: string, tx: FxExecutor): Promise<RateSnapshot> {
    await tx
      .update(cityBases)
      .set({ lockedAt: sql`now()` })
      .where(and(eq(cityBases.cityId, cityId), isNull(cityBases.lockedAt)));
    const [base] = await tx
      .select({ currency: cityBases.currency })
      .from(cityBases)
      .where(eq(cityBases.cityId, cityId))
      .for('share');
    if (!base) throw new FxRefusedError('no_base_currency', 'the city has no base currency');
    return this.snapshot(cityId, tx);
  }

  private async rounding(cityId: string, code: string) {
    const target = { cityId, parameter: code };
    const [unit, mode] = await Promise.all([
      this.settings.get('currency.<code>.rounding_unit', target),
      this.settings.get('currency.<code>.rounding_mode', target),
    ]);
    // Owner decision 2026-11-05: no order without the rounding unit, which
    // is entered before launch.
    if (unit === null) {
      throw new FxRefusedError('rounding_unit_missing', `${code} has no rounding unit`);
    }
    return { roundingUnitMinor: BigInt(unit.amountMinor), roundingMode: mode as RoundingMode };
  }

  private async currency(executor: FxExecutor, code: string) {
    const [row] = await executor.select().from(currencies).where(eq(currencies.code, code));
    if (!row) throw new FxRefusedError('unknown_currency', `${code} is not a supported currency`);
    return row;
  }

  private async base(cityId: string, executor: FxExecutor) {
    const [row] = await executor
      .select({ currency: cityBases.currency, epoch: cityBases.epoch })
      .from(cityBases)
      .where(eq(cityBases.cityId, cityId));
    return row ?? null;
  }

  // Changes of one city's currencies, and of its money settings, take turns,
  // so each checks the state the other left.
  private lockCity(executor: FxExecutor, cityId: string): Promise<void> {
    return lockCityCurrencies(executor, cityId);
  }
}

// The newest versions a history read returns.
const RATE_HISTORY_LIMIT = 100;

function rateOf(row: typeof rateVersions.$inferSelect): CurrentRate {
  return {
    currency: row.currency,
    baseCurrency: row.baseCurrency,
    rate: { numerator: row.rateNumerator, denominator: row.rateDenominator },
    versionId: row.id,
    editorId: row.editorId,
    reason: row.reason,
    setAt: row.createdAt,
  };
}

// |new − old| / old > pct %, in the direction the editor entered the rate,
// compared exactly: the percentage is taken to millionths, which no rate
// decision needs finer.
function isLargeChange(
  previous: Rate,
  next: Rate,
  pct: number,
  direction: RateInput['direction'],
): boolean {
  if (direction === 'units_per_base') {
    return isLargeChange(invert(previous), invert(next), pct, 'base_per_unit');
  }
  const scaledPct = BigInt(Math.round(pct * 1_000_000));
  const difference = next.numerator * previous.denominator - previous.numerator * next.denominator;
  const magnitude = difference < 0n ? -difference : difference;
  return magnitude * 100n * 1_000_000n > scaledPct * previous.numerator * next.denominator;
}

function invert(rate: Rate): Rate {
  return { numerator: rate.denominator, denominator: rate.numerator };
}

function rateText(rate: Rate): string {
  return `${rate.numerator}/${rate.denominator}`;
}
