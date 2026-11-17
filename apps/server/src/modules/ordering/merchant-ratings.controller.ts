import { BadRequestException, ForbiddenException, Get, HttpStatus, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  ratingPeriods,
  RatingsCursorError,
  RestaurantRatingsService,
} from './restaurant-ratings.js';

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
    before: z
      .string()
      .max(64)
      .optional()
      .describe('The `next` cursor of the page before, for «عرض المزيد».'),
  }),
) {}

class MerchantRatingsDto extends createZodDto(
  z.object({
    count: z.int().describe('The ratings of the period, test orders left out.'),
    average: z.number().nullable().describe('Their average stars to one decimal; null with none.'),
    distribution: z
      .array(z.object({ stars: z.int(), count: z.int() }))
      .describe('The count of each star, from 5 down to 1.'),
    ratings: z
      .array(
        z.object({
          id: z.uuid(),
          stars: z.int(),
          reasons: z
            .array(z.object({ code: z.string(), label: z.string() }))
            .describe('The reasons the customer picked, their labels as chosen.'),
          comment: z.string().nullable(),
          at: z.iso.datetime(),
        }),
      )
      .describe(
        'The page, newest first. Never the customer or the order (RA §13, CU §12.1), so a comment cannot be traced.',
      ),
    next: z.string().nullable().describe('The cursor of the next page; null on the last.'),
  }),
) {}

// RA §13, §6.1 row 7 (slice 2.26b): «التقييمات», owners only (a cashier
// gets 403 owner_only); a terminated restaurant's owners keep only the
// money section (RA §5.5, 403 restaurant_terminated). No replies (R16).
@MerchantController()
export class MerchantRatingsController {
  constructor(
    private readonly ratings: RestaurantRatingsService,
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
    try {
      const found = await this.ratings.read(
        restaurant,
        { period: query.period, stars: query.stars ?? null, before: query.before ?? null },
        new Date(),
      );
      return {
        ...found,
        ratings: found.ratings.map((rating) => ({ ...rating, at: rating.at.toISOString() })),
      };
    } catch (error) {
      if (error instanceof RatingsCursorError) {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: 'invalid_cursor',
        });
      }
      throw error;
    }
  }
}
