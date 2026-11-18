import { ForbiddenException, Get, HttpStatus, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { ratingPeriods, RatingPagesService } from './rating-pages.js';

class MerchantRatingsQueryDto extends createZodDto(
  z.object({
    period: z
      .enum(ratingPeriods)
      .default('all')
      .describe(
        'Business days on the city’s clock (RA §11): «الكل», «اليوم», «أمس», «آخر 7 أيام», «آخر 30 يوماً».',
      ),
    stars: z.coerce
      .number()
      .int()
      .min(1)
      .max(5)
      .optional()
      .describe('Only the ratings with these stars; the summary counts every star.'),
    page: z.coerce
      .number()
      .int()
      .min(0)
      .max(10_000)
      .default(0)
      .describe('The page, from 0, for «عرض المزيد».'),
    asOf: z.iso
      .datetime()
      .optional()
      .describe('The first page’s `asOf`, sent with every next page so the pages agree.'),
  }),
) {}

class MerchantRatingsDto extends createZodDto(
  z.object({
    asOf: z.iso.datetime().describe('The moment the pages are read up to.'),
    count: z.int().describe('The ratings of the period, test orders left out.'),
    average: z.number().nullable().describe('Their average stars to one decimal; null with none.'),
    distribution: z
      .array(z.object({ stars: z.int(), count: z.int() }))
      .describe('The count of each star, from 5 down to 1.'),
    ratings: z
      .array(
        z.object({
          stars: z.int(),
          reasons: z
            .array(z.object({ code: z.string(), label: z.string() }))
            .describe('The reasons the customer picked, their labels as chosen.'),
          comment: z.string().nullable(),
          day: z.iso.date().describe('The business day it was sent, on the city’s clock.'),
        }),
      )
      .describe(
        'The page, newest first. Never the customer, the order or the time, so a comment cannot be traced (RA §13, CU §12.1).',
      ),
    more: z.boolean().describe('Whether a next page follows.'),
  }),
) {}

// RA §13, §6.1 row 7 (slice 2.26b): «التقييمات», owners only (a cashier
// gets 403 owner_only); a terminated restaurant's owners keep only the
// money section (RA §5.5, 403 restaurant_terminated). No replies (R16).
@MerchantController()
export class MerchantRatingsController {
  constructor(
    private readonly ratings: RatingPagesService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get('ratings')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantRatingsDto })
  async read(@CurrentAppSession() session: AppSession, @Query() query: MerchantRatingsQueryDto) {
    const merchant = session.merchant;
    if (!merchant) throw new Error('a merchant route without a restaurant user');
    if (merchant.role !== 'owner') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
    }
    const restaurant = await this.merchants.restaurant(merchant.restaurantId);
    if (!restaurant) throw new Error('the session names no restaurant');
    if (restaurant.accountStatus === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    const found = await this.ratings.read(
      { party: 'restaurant', id: restaurant.id, cityId: restaurant.cityId },
      {
        period: query.period,
        stars: query.stars ?? null,
        page: query.page,
        asOf: query.asOf === undefined ? null : new Date(query.asOf),
      },
      new Date(),
    );
    // Never the order nor the time (RA §13), so they are left out here.
    return {
      ...found,
      asOf: found.asOf.toISOString(),
      ratings: found.ratings.map(({ stars, reasons, comment, day }) => ({
        stars,
        reasons,
        comment,
        day,
      })),
    };
  }
}
