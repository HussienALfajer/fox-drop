import { Injectable } from '@nestjs/common';
import { CategoriesService } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantAccountsService } from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import { type AccountStatus, MerchantsService } from '../merchants/index.js';
import { type RestaurantFigures, RestaurantFiguresService } from '../ordering/index.js';
import { phoneOf } from '../../http/phone-search.js';

// AP §9.6.1: the operating states the list shows, for a restaurant in test
// mode or active; null for the others, whose account status says it all.
export type ListedState = 'open' | 'busy' | 'paused' | 'closed';

export interface RestaurantListFilter {
  status: AccountStatus | null;
  categoryId: string | null;
  zoneId: string | null;
  // A part of the Arabic or English name, or a number (the restaurant's own,
  // or one of its users' sign-in numbers).
  q: string | null;
}

export interface ListedRestaurant extends RestaurantFigures {
  id: string;
  nameAr: string;
  nameEn: string | null;
  categories: { id: string; name: string }[];
  accountStatus: AccountStatus;
  state: ListedState | null;
  visible: boolean;
  sortWeight: number;
  zone: { id: string; name: string } | null;
  commissionBp: number | null;
  // What the restaurant owes on its account now, in the base (+ it owes, −
  // the platform owes it): the week's commission, discounts and exceptions
  // with anything earlier unpaid.
  balance: bigint;
}

// A name as typed and as stored, compared without case or diacritics, with
// «ة/ه», «ى/ي» and the alefs alike (as the customers' search, CU §8.3).
function folded(text: string): string {
  return text
    .toLowerCase()
    .normalize('NFKD')
    .replace(/[ً-ٰٟ̀-ͯ]/g, '')
    .replace(/[أإآٱ]/g, 'ا')
    .replace(/ة/g, 'ه')
    .replace(/ى/g, 'ي');
}

// AP §9.6.2 «المطاعم» (slice 2.30c): the city's restaurants with their
// columns, filtered by status, category and zone (the zone the pin is in),
// and searched by name or number. Reads every restaurant of the city at each
// call (fine for Azaz).
@Injectable()
export class RestaurantListService {
  constructor(
    private readonly merchants: MerchantsService,
    private readonly figures: RestaurantFiguresService,
    private readonly categories: CategoriesService,
    private readonly geo: GeoService,
    private readonly ledger: LedgerService,
    private readonly fx: FxService,
    private readonly accounts: MerchantAccountsService,
  ) {}

  async list(
    cityId: string,
    filter: RestaurantListFilter,
    now: Date,
  ): Promise<{ currency: string | null; restaurants: ListedRestaurant[] }> {
    const [rows, active, currency] = await Promise.all([
      this.merchants.listRows(cityId),
      this.categories.active(),
      this.fx.baseCurrency(cityId),
    ]);
    const names = new Map(active.map((category) => [category.id, category.name]));
    const phone = filter.q === null ? null : phoneOf(filter.q);
    const byPhone = phone === null ? null : await this.accounts.restaurantByPhone(phone);
    const typed = filter.q === null || phone !== null ? null : folded(filter.q.trim());
    const zoned = await Promise.all(
      rows.map(async (row) => ({
        row,
        zone: row.location === null ? null : await this.geo.zoneAt(cityId, row.location),
      })),
    );
    const kept = zoned.filter(
      ({ row, zone }) =>
        (filter.status === null || row.accountStatus === filter.status) &&
        (filter.categoryId === null || row.categoryIds.includes(filter.categoryId)) &&
        (filter.zoneId === null || zone?.id === filter.zoneId) &&
        (phone === null || row.phone === phone || row.id === byPhone) &&
        (typed === null ||
          folded(row.nameAr).includes(typed) ||
          (row.nameEn !== null && folded(row.nameEn).includes(typed))),
    );
    const figures = await this.figures.ofCity(
      cityId,
      kept.map(({ row }) => row.id),
      now,
    );
    const restaurants = await Promise.all(
      kept.map(async ({ row, zone }): Promise<ListedRestaurant> => {
        const running = row.accountStatus === 'test' || row.accountStatus === 'active';
        const [state, schedule, balance] = await Promise.all([
          running ? this.merchants.operatingState(row.id, now) : null,
          row.accountStatus === 'draft' ? null : this.merchants.commissionSchedule(row.id, now),
          this.balance(cityId, row.id, currency),
        ]);
        return {
          id: row.id,
          nameAr: row.nameAr,
          nameEn: row.nameEn,
          categories: row.categoryIds
            .filter((id) => names.has(id))
            .map((id) => ({ id, name: names.get(id)! })),
          accountStatus: row.accountStatus,
          state: state === null ? null : listedState(state.state),
          visible: row.visible,
          sortWeight: row.sortWeight,
          zone,
          commissionBp: schedule?.rateBp ?? null,
          balance,
          ...figures.get(row.id)!,
        };
      }),
    );
    return { currency, restaurants };
  }

  private async balance(cityId: string, restaurantId: string, base: string | null) {
    if (base === null) return 0n;
    const accounts = await this.ledger.ownerAccounts(cityId, restaurantId, 'merchant.account');
    const account = accounts.find((each) => each.currency === base);
    // The party's view is − the restaurant owes.
    return account ? -(await this.ledger.balance(account.id)).amount : 0n;
  }
}

// AP §9.6.1: a holiday close is «مغلق»; open in busy mode is open.
function listedState(state: string): ListedState | null {
  switch (state) {
    case 'open':
    case 'busy':
    case 'paused':
    case 'closed':
      return state;
    case 'holiday':
      return 'closed';
    default:
      return null;
  }
}
