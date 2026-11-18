import { Get, HttpStatus, NotFoundException, Param, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedInOrGuest, OptionalAppSession } from '../../http/access.js';
import type { AppSession } from '../identity/index.js';
import { CustomerController } from '../../http/route-groups.js';
import type { Money, StorefrontState } from '../merchants/index.js';
import {
  BrowsingService,
  type RestaurantCard,
  type RestaurantPage,
  type StorefrontCategory,
  type StorefrontItem,
} from './browsing.service.js';
import { CustomersService } from './customers.service.js';
import { FavouritesService } from './favourites.js';
import { pointQuery } from './point-query.js';

const money = z.object({
  amount: z
    .string()
    .regex(/^-?\d+$/)
    .describe('Integer minor units (AP §8.6).'),
  currency: z.string().length(3),
});

export const state = z
  .object({
    state: z
      .enum(['open', 'busy', 'paused', 'closed', 'holiday'])
      .describe(
        'CU §9.2: open; «المطعم مشغول حالياً، جرّب بعد قليل»; «المطعم متوقف مؤقتاً…»; «مغلق — يفتح…»; «مغلق حتى {التاريخ}».',
      ),
    busyMode: z.boolean().describe('Open with busy mode on: «قد يستغرق الطلب وقتاً أطول قليلاً».'),
    until: z.iso
      .datetime()
      .nullable()
      .describe('The end of a pause or a holiday close; null for a pause until resumed.'),
    opensAt: z.iso
      .datetime()
      .nullable()
      .describe('While closed by the schedule: its next opening.'),
    message: z.string().nullable().describe("A holiday close's message, or an operations pause's."),
  })
  .describe('Only open takes orders.');

// The app shows it at a width it picks: <media>/_/w{160,320,640,1280}/plain/<key>
// (architecture §5.8, CU §4.5).
const imageKey = z
  .string()
  .nullable()
  .describe(
    'Its key in public-media, shown through imgproxy (architecture §5.8); null without one.',
  );

export const card = z.object({
  id: z.uuid(),
  nameAr: z.string(),
  nameEn: z.string().nullable(),
  category: z
    .string()
    .nullable()
    .describe('Deprecated (slice 2.27a): the first of `categories`, for older apps.'),
  categories: z
    .array(z.object({ id: z.uuid(), name: z.string() }))
    .describe('Its active categories (AP §9.13), in the restaurant’s order.'),
  logoKey: imageKey,
  coverKey: imageKey,
  rating: z
    .number()
    .nullable()
    .describe(
      "The restaurant's average stars to one decimal; null is «جديد», below 5 ratings (CU §12.1, Q16).",
    ),
  ratingCount: z
    .int()
    .nullable()
    .describe('The number of ratings beside the average (CU §8.2, §9.1); null with «جديد».'),
  testMode: z
    .boolean()
    .describe('«تجريبي»: in test mode, seen only by an admin test account (CU §8.2, AP §9.8).'),
  estimate: z
    .object({ fromMin: z.int(), toMin: z.int() })
    .describe('CU §8.4: «{fromMin}–{toMin} د».'),
  deliveryFee: z
    .object({ fee: money, free: z.boolean().describe('«توصيل مجاني».') })
    .nullable()
    .describe('To the point; null while the city has no fee rule in its base currency.'),
  state,
  favourite: z
    .boolean()
    .describe('The heart (CU §9.6): a favourite of the signed-in customer; false for a guest.'),
});

class CustomerRestaurantListDto extends createZodDto(
  z.object({
    restaurants: z
      .array(card)
      .describe(
        'CU §8.2: open first, then busy and paused, then closed; with similarTo, the open ones only (CU §11.9).',
      ),
    sections: z
      .array(
        z.object({
          kind: z
            .enum(['banners', 'categories', 'nearest', 'most_ordered', 'new', 'offers', 'custom'])
            .describe(
              '«البانرات», «التصنيفات», «الأقرب إليك», «الأكثر طلباً», «جديد على FOX DROP», «العروض», or a custom section under its title.',
            ),
          title: z.string().nullable().describe("A custom section's title; null otherwise."),
          restaurantIds: z
            .array(z.uuid())
            .describe(
              'The cards of `restaurants` it shows, in its order (open first, closed last); empty for banners and categories, which the app fills.',
            ),
        }),
      )
      .nullable()
      .describe(
        'With home: the home sections shown, in the panel’s order (CU §8.1, AP §9.11.3); a restaurant section with no restaurant is left out, and «البانرات» without a banner. Null otherwise.',
      ),
    banners: z
      .array(
        z.object({
          id: z.uuid(),
          title: z.string(),
          imageKey: z.string().describe('In public-media, 1200×500 (architecture §5.8).'),
          target: z
            .enum(['restaurant', 'category', 'restaurants', 'code'])
            .describe(
              'The tap opens the restaurant’s page (restaurantIds holds it), the category’s page, the banner’s list under its title (restaurantIds), or «أكوادي» on its code.',
            ),
          restaurantIds: z
            .array(z.uuid())
            .describe('Cards of `restaurants`, open first and closed last; empty otherwise.'),
          categoryId: z.uuid().nullable(),
          code: z.string().nullable(),
        }),
      )
      .nullable()
      .describe(
        'With home: the banners running in the point’s zone, in the panel’s order, at most 10 (CU §8.1, AP §9.11.2); one the customer cannot open here is left out. Null otherwise.',
      ),
  }),
) {}

const optionGroup = z.object({
  id: z.uuid(),
  name: z.string(),
  minChoices: z.int().describe('0 is an add-on group; 1 or more is «إجباري».'),
  maxChoices: z.int(),
  options: z.array(
    z.object({
      id: z.uuid(),
      name: z.string(),
      priceDelta: money,
      available: z.boolean().describe('Faded and not pickable when false.'),
    }),
  ),
});

// CU §9.3: an item of the menu as the customer sees it.
export const storefrontItem = z.object({
  id: z.uuid(),
  name: z.string(),
  description: z.string().nullable(),
  photoKey: imageKey,
  price: money,
  fromPrice: money.nullable().describe('«من {أقل سعر}» when a required group changes it.'),
  available: z.boolean(),
  unavailableReason: z
    .enum(['tomorrow', 'window', 'unavailable'])
    .nullable()
    .describe('«يتوفر غداً», «متوفر من {الساعة}» (its category window) or «غير متوفر حالياً».'),
  optionGroups: z.array(optionGroup),
});

class CustomerRestaurantPageDto extends createZodDto(
  card.extend({
    description: z.string().nullable(),
    minimumOrder: money,
    freeDeliveryFrom: money
      .nullable()
      .describe('«توصيل مجاني للطلبات من {المبلغ} فأكثر»; null without a threshold.'),
    schedule: z
      .array(
        z.object({
          weekday: z.int().describe('0 Sunday to 6 Saturday.'),
          opensAt: z.int().describe('Minutes after midnight on the city clock.'),
          closesAt: z.int().describe('Not after opensAt: crosses midnight.'),
        }),
      )
      .describe('«أوقات العمل» (RA §10).'),
    deliversHere: z
      .boolean()
      .describe(
        'Whether the restaurant covers the point; when false, the fee and estimate are no offer and nothing can be added.',
      ),
    menu: z.array(
      z.object({
        id: z.uuid(),
        name: z.string(),
        window: z
          .object({ startsAt: z.int(), endsAt: z.int() })
          .nullable()
          .describe('Minutes after midnight on the city clock; «متوفر من {الساعة}» outside it.'),
        items: z.array(storefrontItem),
      }),
    ),
  }),
) {}

class CustomerRestaurantPointQueryDto extends createZodDto(pointQuery) {}

class CustomerRestaurantListQueryDto extends createZodDto(
  pointQuery.extend({
    similarTo: z
      .uuid()
      .optional()
      .describe(
        'CU §11.9: under a rejected or unanswered order, at its pin: up to 5 open restaurants sharing an active category with this one, without it; empty when it has none.',
      ),
    categoryId: z
      .uuid()
      .optional()
      .describe(
        "CU §8.2: the category page, only the restaurants of that category in the list's order; empty for a category that is not active. Ignored with similarTo.",
      ),
    home: z
      .enum(['true', 'false'])
      .optional()
      .describe('CU §8.1: the home, which adds `sections`. Ignored with similarTo or categoryId.'),
  }),
) {}

class CustomerRestaurantParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

// CU §8.2, §9.1–9.4: the restaurants that deliver to the selected point and a
// restaurant's page, open to guests (CU §5.1).
@CustomerController('restaurants')
export class CustomerBrowsingController {
  constructor(
    private readonly browsing: BrowsingService,
    private readonly customers: CustomersService,
    private readonly favourites: FavouritesService,
  ) {}

  // A signed-in admin test account also sees the restaurants in test mode
  // (AP §9.8, slice 2.25b); a guest never does.
  private testAccount(session: AppSession | null): Promise<boolean> {
    return session === null
      ? Promise.resolve(false)
      : this.customers.isTestAccount(session.accountId);
  }

  @Get()
  @AppSignedInOrGuest()
  @ZodResponse({ status: 200, type: CustomerRestaurantListDto })
  async list(
    @Query() query: CustomerRestaurantListQueryDto,
    @OptionalAppSession() session: AppSession | null,
  ) {
    const { similarTo, categoryId, home, ...point } = query;
    const now = new Date();
    const testAccount = await this.testAccount(session);
    const {
      restaurants: cards,
      sections,
      banners,
    } = similarTo !== undefined
      ? {
          restaurants: await this.browsing.similar(similarTo, point, now, testAccount),
          sections: null,
          banners: null,
        }
      : categoryId === undefined && home === 'true'
        ? await this.browsing.home(point, now, testAccount)
        : {
            restaurants: await this.browsing.restaurants(point, now, testAccount, categoryId),
            sections: null,
            banners: null,
          };
    const [ratings, hearted] = await Promise.all([
      this.customers.ratings.restaurants(cards.map((card) => card.id)),
      heartedBy(this.favourites, session),
    ]);
    return {
      restaurants: cards.map((card) => cardBody(card, ratings.get(card.id), hearted.has(card.id))),
      sections,
      banners,
    };
  }

  // 404 for a restaurant customers do not see.
  @Get(':restaurantId')
  @AppSignedInOrGuest()
  @ZodResponse({ status: 200, type: CustomerRestaurantPageDto })
  async page(
    @Param() params: CustomerRestaurantParamsDto,
    @Query() query: CustomerRestaurantPointQueryDto,
    @OptionalAppSession() session: AppSession | null,
  ) {
    const page = await this.browsing.restaurantPage(
      params.restaurantId,
      query,
      new Date(),
      await this.testAccount(session),
    );
    if (page === null) throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND });
    const [ratings, hearted] = await Promise.all([
      this.customers.ratings.restaurants([page.id]),
      heartedBy(this.favourites, session),
    ]);
    return pageBody(page, ratings.get(page.id), hearted.has(page.id));
  }
}

function moneyBody({ amount, currency }: Money) {
  return { amount: amount.toString(), currency };
}

export function stateBody({ state, message, opensAt }: StorefrontState) {
  const until = state.state === 'paused' || state.state === 'holiday' ? state.until : null;
  return {
    state: state.state as 'open' | 'busy' | 'paused' | 'closed' | 'holiday',
    busyMode: state.state === 'open' && state.busyExtraMin !== null,
    until: until?.toISOString() ?? null,
    opensAt: opensAt?.toISOString() ?? null,
    message,
  };
}

// Q16: the average and count from RATINGS_SHOWN_FROM ratings, else «جديد».
const RATINGS_SHOWN_FROM = 5;

export type RatingSummary = { count: number; average: number } | undefined;

// CU §9.6: the signed-in customer's favourites; none for a guest.
export async function heartedBy(
  favourites: FavouritesService,
  session: AppSession | null,
): Promise<Set<string>> {
  return new Set(session === null ? [] : await favourites.ids(session.accountId));
}

export function cardBody(card: RestaurantCard, summary: RatingSummary, favourite: boolean) {
  const shown = summary !== undefined && summary.count >= RATINGS_SHOWN_FROM;
  return {
    ...card,
    category: card.categories[0]?.name ?? null,
    rating: shown ? Math.round(summary.average * 10) / 10 : null,
    ratingCount: shown ? summary.count : null,
    deliveryFee:
      card.deliveryFee === null
        ? null
        : { fee: moneyBody(card.deliveryFee.fee), free: card.deliveryFee.free },
    state: stateBody(card.state),
    favourite,
  };
}

function pageBody(page: RestaurantPage, summary: RatingSummary, favourite: boolean) {
  return {
    ...cardBody(page, summary, favourite),
    description: page.description,
    minimumOrder: moneyBody(page.minimumOrder),
    freeDeliveryFrom: page.freeDeliveryFrom === null ? null : moneyBody(page.freeDeliveryFrom),
    schedule: page.schedule,
    deliversHere: page.deliversHere,
    menu: page.menu.map(categoryBody),
  };
}

function categoryBody(category: StorefrontCategory) {
  return {
    id: category.id,
    name: category.name,
    window: category.window,
    items: category.items.map(itemBody),
  };
}

export function itemBody(item: StorefrontItem) {
  return {
    id: item.id,
    name: item.name,
    description: item.description,
    photoKey: item.photoKey,
    price: moneyBody(item.price),
    fromPrice: item.fromPrice === null ? null : moneyBody(item.fromPrice),
    available: item.available,
    unavailableReason: item.unavailableReason,
    optionGroups: item.optionGroups.map((group) => ({
      id: group.id,
      name: group.name,
      minChoices: group.minChoices,
      maxChoices: group.maxChoices,
      options: group.options.map((option) => ({
        id: option.id,
        name: option.name,
        priceDelta: moneyBody(option.priceDelta),
        available: option.available,
      })),
    })),
  };
}
