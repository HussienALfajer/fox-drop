import { Get, HttpStatus, NotFoundException, Param, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { overviewPeriods, RestaurantFiguresService } from './restaurant-figures.js';

class AdminRestaurantOverviewParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminRestaurantOverviewQueryDto extends createZodDto(
  z.object({
    period: z
      .enum(overviewPeriods)
      .default('today')
      .describe('Business days on the city’s clock: «اليوم», «آخر 7 أيام», «آخر 30 يوماً».'),
  }),
) {}

const share = z.int().nullable().describe('Basis points; null with nothing to count.');

class AdminRestaurantOverviewDto extends createZodDto(
  z.object({
    from: z.iso.datetime().describe('The period’s first business-day cutoff.'),
    orders: z.int().describe('Placed in the period, test orders left out.'),
    sales: z
      .array(z.object({ currency: z.string(), amount: z.string() }))
      .describe('The items value of the orders delivered, in minor units per currency.'),
    acceptanceBp: share.describe(
      'Accepted of those answered or timed out (as «المطاعم»), in basis points.',
    ),
    rejectionBp: share.describe('Rejected of the same, in basis points.'),
    rejectionReasons: z
      .array(z.object({ label: z.string(), count: z.int() }))
      .describe('The rejections by their reason’s label as chosen, most first.'),
    unanswered: z.int().describe('Cancelled because the restaurant never answered.'),
    prepActualMin: z
      .number()
      .nullable()
      .describe('Of the orders marked ready: the average minutes from acceptance to ready.'),
    prepChosenMin: z.number().nullable().describe('Their average prep time chosen.'),
    lateBp: share.describe('Of the same, the share ready after the prep time chosen.'),
    ratingCount: z.int(),
    ratingAverage: z.number().nullable().describe('The period’s ratings; null with none.'),
  }),
) {}

// AP §9.6.4 «نظرة عامة» (slice 2.30d): a restaurant's orders, sales,
// acceptance, prep times, late and rejection rates with the reasons, rating
// and unanswered orders, for today, 7 or 30 business days.
@AdminController('restaurants')
export class AdminRestaurantOverviewController {
  constructor(private readonly figures: RestaurantFiguresService) {}

  @Get(':restaurantId/overview')
  @RequirePermission('restaurants.read')
  @ZodResponse({ status: 200, type: AdminRestaurantOverviewDto })
  async overview(
    @Param() params: AdminRestaurantOverviewParamsDto,
    @Query() query: AdminRestaurantOverviewQueryDto,
  ) {
    const overview = await this.figures.overview(params.restaurantId, query.period, new Date());
    if (overview === null) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    return {
      from: overview.from.toISOString(),
      orders: overview.orders,
      sales: overview.sales.map((line) => ({
        currency: line.currency,
        amount: line.amount.toString(),
      })),
      acceptanceBp: overview.acceptanceBp,
      rejectionBp: overview.rejectionBp,
      rejectionReasons: overview.rejectionReasons,
      unanswered: overview.unanswered,
      prepActualMin: overview.prepActualMin,
      prepChosenMin: overview.prepChosenMin,
      lateBp: overview.lateBp,
      ratingCount: overview.rating?.count ?? 0,
      ratingAverage:
        overview.rating === null ? null : Math.round(overview.rating.average * 10) / 10,
    };
  }
}
