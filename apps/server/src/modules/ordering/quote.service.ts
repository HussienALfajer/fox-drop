import { Injectable } from '@nestjs/common';
import { LedgerService } from '../ledger/index.js';
import { customerDues } from './customer-dues.js';
import { CaptainsService } from '../captains/index.js';
import { CustomersService } from '../customers/index.js';
import { TermsService } from '../content/index.js';
import { equivalent, FxRefusedError, FxService, type RateSnapshot } from '../fx/index.js';
import {
  type Distance,
  estimateRange,
  GeoRefusedError,
  GeoService,
  type Point,
  tripMinutes,
} from '../geo/index.js';
import { MerchantsService, type Restaurant, type StorefrontState } from '../merchants/index.js';
import { SettingsService, versionBelow } from '../settings/index.js';
import { ActiveOrders } from './active-orders.js';
import { EmergencyStops } from './emergency-stop.js';
import { platformOpening } from './platform-hours.js';
import {
  type CartLine,
  type LineProblem,
  type PricedLine,
  priceLines,
  type QuoteMoney,
  quoteMoney,
  quoteVersion,
  thresholds,
} from './quote.js';

// CU §10.6: the problems that block ordering, each with the action the app
// offers (Appendix C). A line problem names its line.
export type QuoteProblemCode =
  | 'update_required'
  | 'maintenance'
  | 'platform_closed'
  | 'outside_zones'
  | 'not_covered'
  | 'restaurant_closed'
  | 'below_minimum_order'
  | 'minimum_not_in_base_currency'
  | 'delivery_unpriced'
  | 'rates_unavailable'
  // AP §9.12.5: no captain pay table in force, so no order could be delivered.
  | 'captain_pay_unset'
  // CU §5.5, D23: «يمكنك طلب واحد في كل مرة حتى يكتمل طلبك الحالي» for a new
  // account, «وصلت إلى الحد الأقصى للطلبات الجارية» for a trusted one.
  | 'one_order_at_a_time'
  | 'active_order_limit'
  // AP §9.12.6: «الضغط عالٍ الآن، جرّب بعد دقائق».
  | 'no_captain_nearby'
  // CU §4.7, Appendix C: «وافق على الشروط الجديدة لتتمكن من الطلب».
  | 'terms_pending'
  // AP §9.1.6, CU §4.7: the city's emergency stop, with its browsing message.
  | 'emergency_stop'
  // docs/domain/08 (slice 2.8b): late cancellations stopped the account's
  // ordering, «حسابك موقوف حتى مراجعة فريق الدعم».
  | 'review_stop'
  // docs/domain/08 (slice 2.11a): a fake order's dues are unpaid, «عليك
  // {المبلغ} لـ FOX DROP. ادفعه في المكتب ليُفك الحظر تلقائياً.» (CU §5.5).
  | 'dues_unpaid'
  | LineProblem;

export interface QuoteProblem {
  code: QuoteProblemCode;
  // The index of the cart line, for a line problem.
  line: number | null;
  // platform_closed: when the platform opens next.
  opensAt: Date | null;
  // emergency_stop: the browsing message the stop's dialog set.
  message: string | null;
  // dues_unpaid: what the customer owes, in the base currency.
  amount: { amount: bigint; currency: string } | null;
}

export interface QuoteRequest {
  restaurantId: string;
  location: Point;
  lines: CartLine[];
  // «سأدفع بـ» (CU §10.5): an accepted currency, or null for «لم أحدد».
  payIn: string | null;
  appVersion: string;
  // The signed-in customer, whose active-order limit the quote checks; null
  // for a guest (CU §5.1).
  customerAccountId: string | null;
  // CU §10.6: the quote asked on opening checkout, which counts the
  // customer once per emergency stop (AP §9.1.6 item 4).
  openedCheckout?: boolean;
}

export interface Quote {
  version: string;
  restaurant: { id: string; state: StorefrontState };
  lines: PricedLine[];
  currency: string;
  money: QuoteMoney;
  deliveryFree: boolean;
  // The total in every other accepted currency, each by its own rounding
  // (AP §8.6).
  equivalents: { currency: string; amount: bigint }[];
  // «ستدفع حوالي {المبلغ} {العملة}»; null for «لم أحدد», and for a currency
  // the city no longer accepts, since the choice is not binding (CU §10.5).
  payIn: { currency: string; amount: bigint } | null;
  estimate: { fromMin: number; toMin: number };
  minimumOrder: { amount: bigint; currency: string; reached: boolean; missing: bigint };
  freeDelivery: { threshold: bigint; reached: boolean; missing: bigint } | null;
  // The exchange-rate version (AP §8.6): each currency's rate version.
  rates: { currency: string; rateVersionId: string | null }[];
  problems: QuoteProblem[];
}

// A quote and what an order placed from it keeps.
export interface PricedQuote {
  quote: Quote;
  // null while the city cannot have one (rates_unavailable).
  snapshot: RateSnapshot | null;
  // null while the city has no fee rule in its base (delivery_unpriced).
  feeRuleId: string | null;
  restaurant: Restaurant;
  // The trip of the estimate: its duration in whole seconds rounded up, and
  // its distance in whole metres.
  trip: { seconds: number; metres: number };
}

export type QuoteRefusal = 'unknown_restaurant';

// A quote the server cannot answer at all, as opposed to a problem it shows.
export class QuoteRefusedError extends Error {
  override readonly name = 'QuoteRefusedError';
  constructor(
    readonly refusal: QuoteRefusal,
    message: string,
  ) {
    super(message);
  }
}

// The trip is measured as the delivery fee is, by the motorbike's distance
// (owner decision 2026-11-06), before any captain is known.
const TRIP_VEHICLE = 'motorbike';

// CU §10.6: the versioned quote of a cart for a delivery point. Every check
// with data is run (owner decision 2026-11-06), the signed-in customer's
// active-order limit, the terms version, the emergency stop and the capacity
// check included; account states and codes (Phase 2) pass until their slices.
@Injectable()
export class QuoteService {
  constructor(
    private readonly settings: SettingsService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly activeOrders: ActiveOrders,
    private readonly captains: CaptainsService,
    private readonly terms: TermsService,
    private readonly emergencyStops: EmergencyStops,
    private readonly customers: CustomersService,
    private readonly ledger: LedgerService,
  ) {}

  async quote(request: QuoteRequest, now: Date): Promise<Quote> {
    return (await this.price(request, now)).quote;
  }

  // The quote with what placing the order keeps: the rate snapshot it was
  // priced with, the fee rule version and the restaurant (CU §10.7).
  async price(request: QuoteRequest, now: Date): Promise<PricedQuote> {
    const restaurant = await this.merchants.restaurant(request.restaurantId, now);
    if (restaurant === null || restaurant.accountStatus !== 'active' || !restaurant.visible) {
      throw new QuoteRefusedError('unknown_restaurant', 'no restaurant customers see');
    }
    const { cityId } = restaurant;
    const point = request.location;
    const problems: QuoteProblem[] = [];
    const problem = (
      code: QuoteProblemCode,
      line: number | null = null,
      opensAt: Date | null = null,
      message: string | null = null,
      amount: QuoteProblem['amount'] = null,
    ) => problems.push({ code, line, opensAt, message, amount });

    const [
      maintenance,
      minVersion,
      hours,
      timeZone,
      zone,
      covers,
      state,
      menu,
      snapshot,
      emergencyStop,
    ] = await Promise.all([
      this.settings.get('app.<app>.maintenance', { parameter: 'customer' }),
      this.settings.get('app.<app>.min_version', { parameter: 'customer' }),
      this.settings.get('platform.hours', { cityId }),
      this.geo.cityTimeZone(cityId),
      this.geo.zoneAt(cityId, point),
      this.merchants.covers(restaurant.id, point),
      this.merchants.storefrontState(restaurant.id, now),
      this.merchants.menu(restaurant.id, now),
      this.snapshot(cityId),
      this.emergencyStops.active(cityId),
    ]);
    if (timeZone === null) throw new Error(`restaurant ${restaurant.id} is in an unknown city`);
    // Suspended since it was read: customers no longer see it.
    if (!storefront(state)) {
      throw new QuoteRefusedError('unknown_restaurant', 'no restaurant customers see');
    }

    if (minVersion !== null && versionBelow(request.appVersion, minVersion)) {
      problem('update_required');
    }
    if (maintenance.enabled) problem('maintenance');
    const platform = platformOpening(hours, now, timeZone);
    if (!platform.open) problem('platform_closed', null, platform.opensAt);
    if (emergencyStop !== null) {
      problem('emergency_stop', null, null, emergencyStop.browseMessage);
      // CU §10.6: the signed-in customer opening checkout counts once per stop.
      if (request.customerAccountId !== null && request.openedCheckout === true) {
        await this.emergencyStops.recordAttempt(emergencyStop.id, request.customerAccountId, now);
      }
    }
    if (zone === null) problem('outside_zones');
    else if (!covers) problem('not_covered');
    if (state.state.state !== 'open') problem('restaurant_closed');
    if (request.customerAccountId !== null) {
      const limit = await this.activeOrders.customer(
        request.customerAccountId,
        await this.activeOrders.rules(cityId),
      );
      if (limit.reached) problem(limit.trusted ? 'active_order_limit' : 'one_order_at_a_time');
      if (await this.terms.pending('customer', request.customerAccountId)) problem('terms_pending');
      if (await this.customers.reviewStopped(request.customerAccountId)) problem('review_stop');
      // AP §8.8: the dues block lifts by itself once the balance is 0 or less.
      const owed = await customerDues(this.ledger, cityId, request.customerAccountId);
      if (owed !== null) problem('dues_unpaid', null, null, null, owed);
    }

    const baseCurrency = snapshot?.baseCurrency ?? (await this.fx.baseCurrency(cityId));
    if (snapshot === null) problem('rates_unavailable');
    const lines = priceLines(menu, request.lines, baseCurrency);
    lines.forEach((line, index) => {
      for (const code of line.problems) problem(code, index);
    });
    const itemsValue = lines.reduce((sum, line) => sum + (line.lineTotal ?? 0n), 0n);

    const fee = await this.deliveryFee(cityId, restaurant.location, point, itemsValue);
    if (fee === null) problem('delivery_unpriced');
    if ((await this.captains.payTable(cityId, now)) === null) problem('captain_pay_unset');
    // The free-delivery threshold of the rule the fee was priced with.
    const freeDeliveryFrom = fee?.freeDeliveryFrom ?? null;
    const status = thresholds({
      itemsValue,
      minimumOrder: restaurant.minimumOrder.amount,
      freeDeliveryFrom,
    });
    // Until the first order locks the base, a minimum order may be in another
    // of the city's currencies (merchants): it cannot be compared then.
    const minimumInBase = restaurant.minimumOrder.currency === baseCurrency;
    if (!minimumInBase) problem('minimum_not_in_base_currency');
    else if (!status.minimumOrder.reached) problem('below_minimum_order');

    const base = snapshot?.currencies.find((entry) => entry.code === snapshot.baseCurrency);
    const money = quoteMoney({
      itemsValue,
      deliveryFee: fee?.fee ?? 0n,
      // Codes wait for Phase 2 (owner decision 2026-11-06).
      discount: 0n,
      rounding: base ? { unitMinor: base.roundingUnitMinor, mode: base.roundingMode } : null,
    });
    const equivalents =
      snapshot === null
        ? []
        : snapshot.currencies
            .filter((entry) => entry.code !== snapshot.baseCurrency)
            .map((entry) => ({
              currency: entry.code,
              amount: equivalent(snapshot, money.total, entry.code),
            }));
    const rates = (snapshot?.currencies ?? []).map((entry) => ({
      currency: entry.code,
      rateVersionId: entry.rateVersionId,
    }));

    const [speedKmh, bufferMin] = await Promise.all([
      this.settings.get('order.eta_speed_kmh', { cityId }),
      this.settings.get('order.eta_buffer_min', { cityId }),
    ]);
    const distance =
      fee?.distance ??
      (await this.geo.distance(restaurant.location, point, { vehicle: TRIP_VEHICLE }));
    // AP §9.12.6: no order without an eligible captain near the restaurant.
    // It costs a few reads per nearby captain, so it runs only when nothing
    // else blocks the order.
    if (
      problems.length === 0 &&
      (await this.settings.get('dispatch.capacity_check', { cityId })) &&
      !(await this.captains.eligibleNear(cityId, restaurant.location, distance.metres, now))
    ) {
      problem('no_captain_nearby');
    }

    const tripMin = tripMinutes(distance.metres, speedKmh);
    const quote: Quote = {
      version: quoteVersion({
        lines: request.lines.map((line, index) => ({
          itemId: line.itemId,
          optionIds: line.optionIds,
          quantity: line.quantity,
          unitPrice: lines[index]!.unitPrice,
        })),
        money,
        equivalents,
        rateVersions: rates,
        problems: problems.map(({ code, line }) => ({ code, line })),
      }),
      restaurant: { id: restaurant.id, state },
      lines,
      currency: baseCurrency ?? restaurant.minimumOrder.currency,
      money,
      deliveryFree: fee?.free ?? false,
      equivalents,
      payIn: payInOf(request.payIn, money.total, baseCurrency, equivalents),
      estimate: estimateRange({
        prepMin: restaurant.defaultPrepMin,
        busyExtraMin: state.state.state === 'open' ? state.state.busyExtraMin : null,
        tripMin,
        bufferMin,
      }),
      minimumOrder: { ...restaurant.minimumOrder, ...status.minimumOrder },
      freeDelivery:
        status.freeDelivery === null || freeDeliveryFrom === null
          ? null
          : { threshold: freeDeliveryFrom, ...status.freeDelivery },
      rates,
      problems,
    };
    // The order keeps the trip of the estimate shown (docs/domain/03).
    const tripSeconds = Math.ceil(tripMin * 60);
    return {
      quote,
      snapshot,
      feeRuleId: fee?.ruleId ?? null,
      restaurant,
      trip: { seconds: tripSeconds, metres: distance.metres },
    };
  }

  // The rates of a quote (AP §8.6); null while the city cannot have one, such
  // as a currency without its rounding unit.
  private async snapshot(cityId: string): Promise<RateSnapshot | null> {
    try {
      return await this.fx.snapshot(cityId);
    } catch (error) {
      if (error instanceof FxRefusedError) return null;
      throw error;
    }
  }

  // The fee for this items value (AP §9.12.3), with the distance a
  // distance-band rule measured; null while the city has no fee rule in its
  // base currency.
  private async deliveryFee(
    cityId: string,
    from: Point,
    to: Point,
    itemsValue: bigint,
  ): Promise<{
    fee: bigint;
    free: boolean;
    freeDeliveryFrom: bigint | null;
    distance: Distance | null;
    ruleId: string;
  } | null> {
    try {
      const { fee, free, freeDeliveryFrom, distance, ruleId } = await this.geo.deliveryFee(cityId, {
        from,
        to,
        itemsValue,
      });
      return { fee, free: free || fee === 0n, freeDeliveryFrom, distance, ruleId };
    } catch (error) {
      if (
        error instanceof GeoRefusedError &&
        (error.refusal === 'no_fee_rule' || error.refusal === 'fee_not_in_base_currency')
      ) {
        return null;
      }
      throw error;
    }
  }
}

function payInOf(
  payIn: string | null,
  total: bigint,
  baseCurrency: string | null,
  equivalents: { currency: string; amount: bigint }[],
): Quote['payIn'] {
  if (payIn === null) return null;
  if (payIn === baseCurrency) return { currency: payIn, amount: total };
  return equivalents.find((entry) => entry.currency === payIn) ?? null;
}

// The states customers see (CU §9.2); draft, suspended and terminated
// restaurants are not shown.
function storefront({ state }: StorefrontState): boolean {
  return ['open', 'busy', 'paused', 'closed', 'holiday'].includes(state.state);
}
