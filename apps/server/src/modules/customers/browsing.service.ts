import { Injectable } from '@nestjs/common';
import { CategoriesService } from '../content/index.js';
import {
  estimateRange,
  GeoRefusedError,
  GeoService,
  type Point,
  tripMinutes,
} from '../geo/index.js';
import {
  type MenuCategory,
  type MenuItem,
  MerchantsService,
  type Money,
  type OpeningPeriod,
  type Restaurant,
  seenByCustomer,
  type StorefrontState,
} from '../merchants/index.js';
import { BannersService, HOME_BANNERS_MAX, HomeSectionsService } from '../marketing/index.js';
import { SettingsService } from '../settings/index.js';
import { CustomersService } from './customers.service.js';
import { matchesSearch } from './search-text.js';

// The trip of the estimate is measured as the delivery fee is, by the
// motorbike's distance (owner decision 2026-11-06 for the fee), before any
// captain is known.
const ESTIMATE_VEHICLE = 'motorbike';

// CU §11.9: «up to 5 similar restaurants» under a rejected or unanswered order.
const SIMILAR_LIMIT = 5;

// CU §8.1 (owner decisions 2026-11-18): «الأقرب إليك», «الأكثر طلباً» and
// «جديد على FOX DROP» show 10 each; the last two look 30 days back.
export const HOME_SECTION_SIZE = 10;
export const HOME_LOOKBACK_DAYS = 30;
const DAY_MS = 24 * 60 * 60_000;

// CU §8.1: a home section as the app shows it, in the panel's order. A
// restaurant section names its cards; «البانرات» and «التصنيفات» name none
// (the app fills them).
export interface HomeSectionView {
  kind: 'banners' | 'categories' | 'nearest' | 'most_ordered' | 'new' | 'offers' | 'custom';
  title: string | null;
  restaurantIds: string[];
}

// CU §8.1 (slice 2.27c): a banner as the app shows it. Its tap opens a
// restaurant's page (`restaurant`, restaurantIds holds it), a category's page,
// the banner's own list under its title (`restaurants`, cards of the same
// answer, open first and closed last) or «أكوادي» on its code.
export interface HomeBannerView {
  id: string;
  title: string;
  imageKey: string;
  target: 'restaurant' | 'category' | 'restaurants' | 'code';
  restaurantIds: string[];
  categoryId: string | null;
  code: string | null;
}

// A card with what the home sections sort by.
interface Listed {
  card: RestaurantCard;
  restaurant: Restaurant;
  metres: number;
}

// CU §8.2: a restaurant card for the selected point.
export interface RestaurantCard {
  id: string;
  nameAr: string;
  nameEn: string | null;
  // AP §9.13: its active categories, in the restaurant's order.
  categories: { id: string; name: string }[];
  logoKey: string | null;
  coverKey: string | null;
  // CU §8.4: the 10-minute range before ordering.
  estimate: { fromMin: number; toMin: number };
  // The fee to the point, or null while the city has no fee rule in its base.
  deliveryFee: { fee: Money; free: boolean } | null;
  state: StorefrontState;
  // «تجريبي» (CU §8.2): a restaurant in test mode, which only an admin test
  // account sees (AP §9.8).
  testMode: boolean;
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

// CU §8.3: an item found by the search, with its restaurant and price.
export interface SearchItem extends StorefrontItem {
  restaurantId: string;
  restaurantName: string;
  restaurantState: StorefrontState;
}

// CU §8.3: what a search found at a point. `place` is null outside every
// zone, where nothing is searched.
export interface SearchResult {
  place: { cityId: string; zoneId: string } | null;
  restaurants: RestaurantCard[];
  items: SearchItem[];
}

// CU §8.3 (decided by us): the items tab shows the first 50 found, in the
// restaurants' order (closed last), each restaurant's in its menu's order.
export const SEARCH_ITEMS_MAX = 50;

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
    private readonly categories: CategoriesService,
    private readonly sections: HomeSectionsService,
    private readonly banners: BannersService,
    private readonly customers: CustomersService,
  ) {}

  // The active categories by id, for the cards (a removed one is left out).
  private async categoryNames(): Promise<Map<string, string>> {
    const active = await this.categories.active();
    return new Map(active.map((category) => [category.id, category.name]));
  }

  // CU §8.2: open restaurants first, then busy and paused, then closed,
  // each group in the restaurants' own order. With a category (the category
  // page, slice 2.27a), only the restaurants linked to it; none for a
  // category that is not active.
  async restaurants(
    point: Point,
    now: Date,
    testAccount = false,
    categoryId?: string,
  ): Promise<RestaurantCard[]> {
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) return [];
    const names = await this.categoryNames();
    if (categoryId !== undefined && !names.has(categoryId)) return [];
    const listed = await this.listed(place.cityId, point, now, testAccount, names);
    return ranked(
      categoryId === undefined
        ? listed
        : listed.filter(({ restaurant }) => restaurant.categoryIds.includes(categoryId)),
    ).map(({ card }) => card);
  }

  // CU §9.6 (slice 2.28b): «المفضلة», the favourites among the restaurants
  // that deliver to the point, in the list's order (open first, closed
  // last); one that does not deliver here is left out (owner decision
  // 2026-11-18).
  async favourites(
    point: Point,
    now: Date,
    testAccount: boolean,
    favouriteIds: readonly string[],
  ): Promise<RestaurantCard[]> {
    if (favouriteIds.length === 0) return [];
    const hearted = new Set(favouriteIds);
    const cards = await this.restaurants(point, now, testAccount);
    return cards.filter((card) => hearted.has(card.id));
  }

  // Whether customers (or this admin test account) see the restaurant, so
  // it can be hearted.
  async seen(id: string, now: Date, testAccount: boolean): Promise<boolean> {
    const restaurant = await this.merchants.restaurant(id, now);
    return restaurant !== null && seenByCustomer(restaurant, testAccount);
  }

  // CU §8.1, AP §9.11.3 (slice 2.27b): the list's cards and the shown
  // sections in the panel's order. «الأقرب إليك» the HOME_SECTION_SIZE
  // nearest by the card's trip; «الأكثر طلباً» those with the most orders
  // delivered in HOME_LOOKBACK_DAYS (ties in the list's order); «جديد على
  // FOX DROP» those first activated within them, newest first; «العروض»
  // every restaurant of a visible code limited to restaurants, in the
  // list's order; a custom section its restaurants in the admin's order.
  // Each takes its restaurants by its own rule whatever their state, then
  // shows open first and closed last (owner decision 2026-11-18). A
  // restaurant section with none is left out.
  async home(
    point: Point,
    now: Date,
    testAccount = false,
  ): Promise<{
    restaurants: RestaurantCard[];
    sections: HomeSectionView[];
    banners: HomeBannerView[];
  }> {
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) {
      return { restaurants: [], sections: [], banners: [] };
    }
    const zoneId = place.zone.id;
    const [names, stored] = await Promise.all([
      this.categoryNames(),
      this.sections.sections(place.cityId),
    ]);
    const shown = stored.filter((section) => section.visible);
    const listed = await this.listed(place.cityId, point, now, testAccount, names);
    const since = new Date(now.getTime() - HOME_LOOKBACK_DAYS * DAY_MS);
    const kinds = new Set(shown.map((section) => section.kind));
    const [counts, offers, running] = await Promise.all([
      kinds.has('most_ordered')
        ? this.customers.deliveredCounts(
            listed.map(({ card }) => card.id),
            since,
          )
        : new Map<string, number>(),
      kinds.has('offers')
        ? this.sections.offerRestaurants(place.cityId, zoneId, now)
        : new Set<string>(),
      kinds.has('banners') ? this.banners.running(place.cityId, zoneId, now) : [],
    ]);
    const byId = new Map(listed.map((entry) => [entry.card.id, entry]));
    const picked = (kind: HomeSectionView['kind'], ids: string[]): Listed[] => {
      switch (kind) {
        case 'nearest':
          return byPosition(listed, (a, b) => a.metres - b.metres).slice(0, HOME_SECTION_SIZE);
        case 'most_ordered':
          return byPosition(
            listed.filter(({ card }) => (counts.get(card.id) ?? 0) > 0),
            (a, b) => counts.get(b.card.id)! - counts.get(a.card.id)!,
          ).slice(0, HOME_SECTION_SIZE);
        case 'new':
          return byPosition(
            listed.filter(
              ({ restaurant }) =>
                restaurant.activatedAt !== null &&
                restaurant.activatedAt.getTime() >= since.getTime(),
            ),
            (a, b) => b.restaurant.activatedAt!.getTime() - a.restaurant.activatedAt!.getTime(),
          ).slice(0, HOME_SECTION_SIZE);
        case 'offers':
          return listed.filter(({ card }) => offers.has(card.id));
        case 'custom':
          return ids.flatMap((id) => byId.get(id) ?? []);
        default:
          return [];
      }
    };
    // A banner whose target the customer cannot open here is left out: a
    // restaurant that does not deliver to the point, a list with none that
    // does, a category no longer active (decided by us); then the first
    // HOME_BANNERS_MAX (owner decision 2026-11-18).
    const banners = running
      .flatMap((banner): HomeBannerView[] => {
        const view = {
          id: banner.id,
          title: banner.title,
          imageKey: banner.imageKey,
          target: banner.target,
          restaurantIds: [] as string[],
          categoryId: null,
          code: null,
        };
        switch (banner.target) {
          case 'restaurant':
          case 'restaurants': {
            const ids = ranked(banner.restaurantIds.flatMap((id) => byId.get(id) ?? [])).map(
              ({ card }) => card.id,
            );
            return ids.length === 0 ? [] : [{ ...view, restaurantIds: ids }];
          }
          case 'category':
            return banner.categoryId !== null && names.has(banner.categoryId)
              ? [{ ...view, categoryId: banner.categoryId }]
              : [];
          case 'code':
            return [{ ...view, code: banner.code }];
        }
      })
      .slice(0, HOME_BANNERS_MAX);
    const sections = shown.flatMap((section): HomeSectionView[] => {
      const view = { kind: section.kind, title: section.title };
      if (section.kind === 'banners') {
        return banners.length === 0 ? [] : [{ ...view, restaurantIds: [] }];
      }
      if (section.kind === 'categories') {
        return [{ ...view, restaurantIds: [] }];
      }
      const restaurantIds = ranked(picked(section.kind, section.restaurantIds)).map(
        ({ card }) => card.id,
      );
      return restaurantIds.length === 0 ? [] : [{ ...view, restaurantIds }];
    });
    return { restaurants: ranked(listed).map(({ card }) => card), sections, banners };
  }

  // CU §8.3 (owner decision 2026-11-18): the restaurants that deliver to the
  // point whose name or active category matches, and their items whose name
  // or description does (hidden ones never), both open first and closed
  // last as the list sorts them (`searchText` decides the match).
  async search(point: Point, now: Date, query: string, testAccount = false): Promise<SearchResult> {
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) return { place: null, restaurants: [], items: [] };
    const names = await this.categoryNames();
    const listed = ranked(await this.listed(place.cityId, point, now, testAccount, names));
    const menus = await Promise.all(
      listed.map(({ restaurant }) => this.merchants.menu(restaurant.id, now)),
    );
    const restaurants = listed
      .filter(({ card }) =>
        matchesSearch(query, [
          card.nameAr,
          card.nameEn,
          ...card.categories.map((category) => category.name),
        ]),
      )
      .map(({ card }) => card);
    const items = listed
      .flatMap(({ card }, index) =>
        storefrontMenu(menus[index]!.categories)
          .flatMap((category) => category.items)
          .filter((item) => matchesSearch(query, [item.name, item.description]))
          .map((item): SearchItem => ({
            ...item,
            restaurantId: card.id,
            restaurantName: card.nameAr,
            restaurantState: card.state,
          })),
      )
      .slice(0, SEARCH_ITEMS_MAX);
    return { place: { cityId: place.cityId, zoneId: place.zone.id }, restaurants, items };
  }

  // The cards of the restaurants that cover the point, in the restaurants'
  // own order (the sort weight, AP §9.6.5), with the trip each card
  // measured; a restaurant suspended since it was listed is left out.
  private async listed(
    cityId: string,
    point: Point,
    now: Date,
    testAccount: boolean,
    names: Map<string, string>,
  ): Promise<Listed[]> {
    const ids = await this.merchants.coveringRestaurants(cityId, point, testAccount);
    const listed = await Promise.all(
      ids.map(async (id) => {
        const restaurant = await this.merchants.restaurant(id, now);
        if (restaurant === null) return null;
        return { restaurant, ...(await this.measured(restaurant, point, now, names)) };
      }),
    );
    return listed.filter(
      (entry): entry is Listed => entry !== null && rank(entry.card.state) !== null,
    );
  }

  // CU §11.9: under a rejected or unanswered order, the open restaurants that
  // share an active category with it and deliver to the order's pin, in the
  // list's own order, without the restaurant itself. Open in busy mode is
  // open. Empty when the restaurant has no active category.
  async similar(
    id: string,
    point: Point,
    now: Date,
    testAccount = false,
  ): Promise<RestaurantCard[]> {
    const source = await this.merchants.restaurant(id, now);
    if (source === null) return [];
    const names = await this.categoryNames();
    const shared = new Set(source.categoryIds.filter((category) => names.has(category)));
    if (shared.size === 0) return [];
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) return [];
    const ids = await this.merchants.coveringRestaurants(place.cityId, point, testAccount);
    const restaurants = await Promise.all(
      ids.filter((other) => other !== id).map((other) => this.merchants.restaurant(other, now)),
    );
    const sameCategory = restaurants.filter(
      (restaurant): restaurant is Restaurant =>
        restaurant?.categoryIds.some((category) => shared.has(category)) ?? false,
    );
    // The state first, so only the open ones are priced and measured.
    const states = await Promise.all(
      sameCategory.map((restaurant) => this.merchants.storefrontState(restaurant.id, now)),
    );
    const open = sameCategory
      .filter((_, index) => states[index]!.state.state === 'open')
      .slice(0, SIMILAR_LIMIT);
    const cards = await Promise.all(
      open.map((restaurant) => this.card(restaurant, point, now, names)),
    );
    // A restaurant paused since its state was read is left out.
    return cards.filter((card) => card.state.state.state === 'open');
  }

  // CU §9.1–9.4; null for a restaurant customers do not see (CU §8.2).
  async restaurantPage(
    id: string,
    point: Point,
    now: Date,
    testAccount = false,
  ): Promise<RestaurantPage | null> {
    const restaurant = await this.merchants.restaurant(id, now);
    if (restaurant === null || !seenByCustomer(restaurant, testAccount)) return null;
    const names = await this.categoryNames();
    const [card, deliversHere, rule, menu] = await Promise.all([
      this.card(restaurant, point, now, names),
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

  private async card(
    restaurant: Restaurant,
    point: Point,
    now: Date,
    names: Map<string, string>,
  ): Promise<RestaurantCard> {
    return (await this.measured(restaurant, point, now, names)).card;
  }

  // The card and the trip's metres it measured.
  private async measured(
    restaurant: Restaurant,
    point: Point,
    now: Date,
    names: Map<string, string>,
  ): Promise<{ card: RestaurantCard; metres: number }> {
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
    const card: RestaurantCard = {
      id: restaurant.id,
      nameAr: restaurant.nameAr,
      nameEn: restaurant.nameEn,
      categories: restaurant.categoryIds.flatMap((category) => {
        const name = names.get(category);
        return name === undefined ? [] : [{ id: category, name }];
      }),
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
      testMode: restaurant.accountStatus === 'test',
    };
    return { card, metres: distance.metres };
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

// CU §8.2: open first, then busy and paused, then closed, each group in the
// order it came in.
function ranked(listed: Listed[]): Listed[] {
  return listed
    .map((entry, position) => ({ entry, position }))
    .sort(
      (a, b) => rank(a.entry.card.state)! - rank(b.entry.card.state)! || a.position - b.position,
    )
    .map(({ entry }) => entry);
}

// Sorted by the comparison, ties in the order it came in.
function byPosition(listed: Listed[], compare: (a: Listed, b: Listed) => number): Listed[] {
  return listed
    .map((entry, position) => ({ entry, position }))
    .sort((a, b) => compare(a.entry, b.entry) || a.position - b.position)
    .map(({ entry }) => entry);
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
