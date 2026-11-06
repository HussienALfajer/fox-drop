import { Injectable } from '@nestjs/common';
import { GeoRefusedError, GeoService, type Point } from '../geo/index.js';
import {
  type MenuCategory,
  type MenuItem,
  MerchantsService,
  type Money,
  type OpeningPeriod,
  type Restaurant,
  type StorefrontState,
} from '../merchants/index.js';
import { estimateRange, tripMinutes } from '../ordering/index.js';
import { SettingsService } from '../settings/index.js';

// The trip of the estimate is measured as the delivery fee is, by the
// motorbike's distance (owner decision 2026-11-06 for the fee), before any
// captain is known.
const ESTIMATE_VEHICLE = 'motorbike';

// CU §8.2: a restaurant card for the selected point.
export interface RestaurantCard {
  id: string;
  nameAr: string;
  nameEn: string | null;
  category: string | null;
  logoKey: string | null;
  coverKey: string | null;
  // CU §8.4: the 10-minute range before ordering.
  estimate: { fromMin: number; toMin: number };
  // The fee to the point, or null while the city has no fee rule in its base.
  deliveryFee: { fee: Money; free: boolean } | null;
  state: StorefrontState;
}

// CU §9.3: why an item cannot be ordered: «يتوفر غداً» when everything that
// holds it back is off only until tomorrow; «متوفر من {الساعة}» when only its
// category's window does; «غير متوفر حالياً» otherwise.
export type UnavailableReason = 'tomorrow' | 'window' | 'unavailable';

export interface StorefrontItem {
  id: string;
  name: string;
  description: string | null;
  photoKey: string | null;
  price: Money;
  // «من {أقل سعر}» when a required group changes the price (CU §9.3).
  fromPrice: Money | null;
  available: boolean;
  unavailableReason: UnavailableReason | null;
  optionGroups: MenuItem['optionGroups'];
}

export interface StorefrontCategory {
  id: string;
  name: string;
  // Minutes after midnight on the city's clock; null all day.
  window: { startsAt: number; endsAt: number } | null;
  items: StorefrontItem[];
}

// CU §9.1: the restaurant page for the selected point.
export interface RestaurantPage extends RestaurantCard {
  description: string | null;
  minimumOrder: Money;
  // «توصيل مجاني للطلبات من {المبلغ} فأكثر» (AP §9.12.3).
  freeDeliveryFrom: Money | null;
  schedule: OpeningPeriod[];
  // Whether it covers the point; the add buttons wait for this and an open
  // state (CU §9.2).
  deliversHere: boolean;
  menu: StorefrontCategory[];
}

// The customer's browsing (CU §8.2, §8.4, §9.1–9.4): the restaurants that
// deliver to a point, as cards, and a restaurant's page with its menu.
@Injectable()
export class BrowsingService {
  constructor(
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly settings: SettingsService,
  ) {}

  // CU §8.2: open restaurants first, then busy and paused, then closed,
  // each group in the restaurants' own order.
  async restaurants(point: Point, now: Date): Promise<RestaurantCard[]> {
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) return [];
    const ids = await this.merchants.coveringRestaurants(place.cityId, point);
    const cards = await Promise.all(
      ids.map(async (id) => {
        const restaurant = await this.merchants.restaurant(id, now);
        return restaurant === null ? null : this.card(restaurant, point, now);
      }),
    );
    // A restaurant suspended since it was listed is left out.
    return cards
      .filter((card): card is RestaurantCard => card !== null && rank(card.state) !== null)
      .map((card, position) => ({ card, position }))
      .sort((a, b) => rank(a.card.state)! - rank(b.card.state)! || a.position - b.position)
      .map(({ card }) => card);
  }

  // CU §9.1–9.4; null for a restaurant customers do not see (CU §8.2).
  async restaurantPage(id: string, point: Point, now: Date): Promise<RestaurantPage | null> {
    const restaurant = await this.merchants.restaurant(id, now);
    if (restaurant === null || restaurant.accountStatus !== 'active' || !restaurant.visible) {
      return null;
    }
    const [card, deliversHere, rule, menu] = await Promise.all([
      this.card(restaurant, point, now),
      this.merchants.covers(id, point),
      this.geo.deliveryFeeRule(restaurant.cityId),
      this.merchants.menu(id, now),
    ]);
    if (rank(card.state) === null) return null;
    return {
      ...card,
      description: restaurant.description,
      minimumOrder: restaurant.minimumOrder,
      freeDeliveryFrom:
        card.deliveryFee === null || rule?.freeDeliveryFrom == null
          ? null
          : { amount: rule.freeDeliveryFrom, currency: rule.currency },
      schedule: restaurant.schedule,
      deliversHere,
      menu: storefrontMenu(menu.categories),
    };
  }

  private async card(restaurant: Restaurant, point: Point, now: Date): Promise<RestaurantCard> {
    const { cityId } = restaurant;
    const [state, speedKmh, bufferMin, priced] = await Promise.all([
      this.merchants.storefrontState(restaurant.id, now),
      this.settings.get('order.eta_speed_kmh', { cityId }),
      this.settings.get('order.eta_buffer_min', { cityId }),
      this.fee(cityId, restaurant.location, point),
    ]);
    // A distance-band fee measured the same trip already.
    const distance =
      priced?.distance ??
      (await this.geo.distance(restaurant.location, point, { vehicle: ESTIMATE_VEHICLE }));
    return {
      id: restaurant.id,
      nameAr: restaurant.nameAr,
      nameEn: restaurant.nameEn,
      category: restaurant.category,
      logoKey: restaurant.logoKey,
      coverKey: restaurant.coverKey,
      estimate: estimateRange({
        prepMin: restaurant.defaultPrepMin,
        busyExtraMin: state.state.state === 'open' ? state.state.busyExtraMin : null,
        tripMin: tripMinutes(distance.metres, speedKmh),
        bufferMin,
      }),
      deliveryFee: priced === null ? null : { fee: priced.fee, free: priced.free },
      state,
    };
  }

  // The card shows the fee before any item (CU §8.2), so a free-delivery
  // threshold does not apply yet. Null while the city has no fee rule in its
  // base currency.
  private async fee(cityId: string, from: Point, to: Point) {
    try {
      const { fee, currency, free, distance } = await this.geo.deliveryFee(cityId, {
        from,
        to,
        itemsValue: 0n,
      });
      return { fee: { amount: fee, currency }, free: free || fee === 0n, distance };
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

// The list's groups; null for a state customers never see.
function rank({ state }: StorefrontState): number | null {
  switch (state.state) {
    case 'open':
      return 0;
    case 'busy':
    case 'paused':
      return 1;
    case 'closed':
    case 'holiday':
      return 2;
    default:
      return null;
  }
}

// CU §9.3: hidden categories and items never appear; the rest keep their
// place with why they cannot be ordered.
function storefrontMenu(categories: MenuCategory[]): StorefrontCategory[] {
  return categories
    .filter((category) => !category.hidden)
    .map((category) => ({
      id: category.id,
      name: category.name,
      window: category.window,
      items: category.items
        .filter((item) => !item.hidden)
        .map((item) => ({
          id: item.id,
          name: item.name,
          description: item.description,
          photoKey: item.photoKey,
          price: item.price,
          fromPrice: fromPrice(item),
          available: item.available,
          unavailableReason: unavailableReason(item, category),
          optionGroups: item.optionGroups,
        })),
    }));
}

function unavailableReason(item: MenuItem, category: MenuCategory): UnavailableReason | null {
  if (item.available) return null;
  // Every switch that holds the item back: its own, its category's, and the
  // options of a required group with none left.
  const switches = [item.switchedOff, category.switchedOff];
  for (const group of item.optionGroups) {
    if (group.minChoices > 0 && group.options.every((option) => !option.available)) {
      switches.push(...group.options.map((option) => option.switchedOff));
    }
  }
  const off = switches.filter((entry) => entry !== null);
  if (off.some((entry) => entry.until === null)) return 'unavailable';
  if (off.length > 0) return 'tomorrow';
  return category.inWindow ? 'unavailable' : 'window';
}

// The lowest price with every required group's cheapest available choices,
// when a required group changes the price.
function fromPrice(item: MenuItem): Money | null {
  const required = item.optionGroups.filter((group) => group.minChoices > 0);
  if (!required.some((group) => group.options.some((option) => option.priceDelta.amount !== 0n))) {
    return null;
  }
  // Until the first order locks the base, an option may be priced in another
  // of the city's currencies: no sum across currencies.
  const options = required.flatMap((group) => group.options);
  if (options.some((option) => option.priceDelta.currency !== item.price.currency)) return null;
  let amount = item.price.amount;
  for (const group of required) {
    const deltas = group.options
      .filter((option) => option.available)
      .map((option) => option.priceDelta.amount)
      .sort((a, b) => (a < b ? -1 : a > b ? 1 : 0));
    for (const delta of deltas.slice(0, group.minChoices)) amount += delta;
  }
  return { amount, currency: item.price.currency };
}
