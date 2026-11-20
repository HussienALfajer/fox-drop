import { BadRequestException, ForbiddenException, Get, HttpStatus, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { RatingPagesService, ratingPeriods, RatingRangeRefusedError } from './rating-pages.js';

class MerchantRatingsQueryDto extends createZodDto(
  z
    .object({
      period: z
        .enum(ratingPeriods)
        .optional()
        .describe(
          'Business days on the city’s clock (RA §11): «الكل» (the default), «اليوم», «أمس», «آخر 7 أيام», «آخر 30 يوماً»; or `from` and `to`.',
        ),
      from: z.iso
        .date()
        .optional()
        .describe(
          'The portal’s custom range (RA §17): its first business day, with `to`, in place of `period`.',
        ),
      to: z.iso
        .date()
        .optional()
        .describe('The last business day, included: at most 366 days, not after today.'),
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
    })
    .refine(
      (query) =>
        (query.from === undefined) === (query.to === undefined) &&
        (query.from === undefined || query.period === undefined),
      { message: 'a period, or from and to' },
    ),
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
// money section (RA §5.5, 403 restaurant_terminated). No replies (R16). The
// owner web portal adds the custom range (RA §17, slice 2.45d; 400
// invalid_period for one longer than 366 days or ending after today).
@MerchantController()
export class MerchantRatingsController {
  constructor(
    private readonly ratings: RatingPagesService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get('ratings')
  @AppSignedIn({ portal: true })
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
    const found = await this.rangeRefusals(() =>
      this.ratings.read(
        { party: 'restaurant', id: restaurant.id, cityId: restaurant.cityId },
        {
          period: query.period ?? 'all',
          range: query.from === undefined ? null : { fromDay: query.from, toDay: query.to! },
          stars: query.stars ?? null,
          page: query.page,
          asOf: query.asOf === undefined ? null : new Date(query.asOf),
        },
        new Date(),
      ),
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

  private async rangeRefusals<T>(run: () => Promise<T>): Promise<T> {
    try {
      return await run();
    } catch (error) {
      if (!(error instanceof RatingRangeRefusedError)) throw error;
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
    }
  }
}
