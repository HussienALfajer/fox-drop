import { Get, HttpStatus, NotFoundException, Param, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { Public } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import type { Money, StorefrontState } from '../merchants/index.js';
import {
  BrowsingService,
  type RestaurantCard,
  type RestaurantPage,
  type StorefrontCategory,
} from './browsing.service.js';
import { pointQuery } from './point-query.js';

const money = z.object({
  amount: z
    .string()
    .regex(/^-?\d+$/)
    .describe('Integer minor units (AP §8.6).'),
  currency: z.string().length(3),
});

const state = z
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

const card = z.object({
  id: z.uuid(),
  nameAr: z.string(),
  nameEn: z.string().nullable(),
  category: z.string().nullable(),
  logoKey: z.string().nullable(),
  coverKey: z.string().nullable(),
  rating: z
    .number()
    .nullable()
    .describe('The average rating; null is «جديد» (Q16). Ratings arrive with their slice.'),
  ratingCount: z.int().nullable().describe('The number of ratings on the page (CU §9.1).'),
  estimate: z
    .object({ fromMin: z.int(), toMin: z.int() })
    .describe('CU §8.4: «{fromMin}–{toMin} د».'),
  deliveryFee: z
    .object({ fee: money, free: z.boolean().describe('«توصيل مجاني».') })
    .nullable()
    .describe('To the point; null while the city has no fee rule in its base currency.'),
  state,
});

class CustomerRestaurantListDto extends createZodDto(
  z.object({
    restaurants: z.array(card).describe('CU §8.2: open first, then busy and paused, then closed.'),
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
        items: z.array(
          z.object({
            id: z.uuid(),
            name: z.string(),
            description: z.string().nullable(),
            photoKey: z.string().nullable().describe('Null until the object storage arrives (T7).'),
            price: money,
            fromPrice: money
              .nullable()
              .describe('«من {أقل سعر}» when a required group changes it.'),
            available: z.boolean(),
            unavailableReason: z
              .enum(['tomorrow', 'window', 'unavailable'])
              .nullable()
              .describe(
                '«يتوفر غداً», «متوفر من {الساعة}» (its category window) or «غير متوفر حالياً».',
              ),
            optionGroups: z.array(optionGroup),
          }),
        ),
      }),
    ),
  }),
) {}

class CustomerRestaurantPointQueryDto extends createZodDto(pointQuery) {}

class CustomerRestaurantParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

// CU §8.2, §9.1–9.4: the restaurants that deliver to the selected point and a
// restaurant's page, open to guests (CU §5.1).
@CustomerController('restaurants')
export class CustomerBrowsingController {
  constructor(private readonly browsing: BrowsingService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: CustomerRestaurantListDto })
  async list(@Query() query: CustomerRestaurantPointQueryDto) {
    const cards = await this.browsing.restaurants(query, new Date());
    return { restaurants: cards.map(cardBody) };
  }

  // 404 for a restaurant customers do not see.
  @Get(':restaurantId')
  @Public()
  @ZodResponse({ status: 200, type: CustomerRestaurantPageDto })
  async page(
    @Param() params: CustomerRestaurantParamsDto,
    @Query() query: CustomerRestaurantPointQueryDto,
  ) {
    const page = await this.browsing.restaurantPage(params.restaurantId, query, new Date());
    if (page === null) throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND });
    return pageBody(page);
  }
}

function moneyBody({ amount, currency }: Money) {
  return { amount: amount.toString(), currency };
}

function stateBody({ state, message, opensAt }: StorefrontState) {
  const until = state.state === 'paused' || state.state === 'holiday' ? state.until : null;
  return {
    state: state.state as 'open' | 'busy' | 'paused' | 'closed' | 'holiday',
    busyMode: state.state === 'open' && state.busyExtraMin !== null,
    until: until?.toISOString() ?? null,
    opensAt: opensAt?.toISOString() ?? null,
    message,
  };
}

function cardBody(card: RestaurantCard) {
  return {
    ...card,
    rating: null,
    ratingCount: null,
    deliveryFee:
      card.deliveryFee === null
        ? null
        : { fee: moneyBody(card.deliveryFee.fee), free: card.deliveryFee.free },
    state: stateBody(card.state),
  };
}

function pageBody(page: RestaurantPage) {
  return {
    ...cardBody(page),
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
    items: category.items.map((item) => ({
      ...item,
      price: moneyBody(item.price),
      fromPrice: item.fromPrice === null ? null : moneyBody(item.fromPrice),
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
    })),
  };
}
