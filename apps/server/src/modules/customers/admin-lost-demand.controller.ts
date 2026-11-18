import { Get, HttpStatus, NotFoundException, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequireAnyPermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { GeoService } from '../geo/index.js';
import { LOST_DEMAND_DAYS, LOST_DEMAND_ROWS, LostDemandService } from './lost-demand.service.js';

class AdminLostDemandQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminLostDemandDto extends createZodDto(
  z.object({
    since: z.iso.datetime().describe(`${LOST_DEMAND_DAYS} days back.`),
    searches: z
      .array(
        z.object({
          query: z.string().describe('As it was typed last.'),
          count: z.int().describe('Searches typed alike that found nothing.'),
          lastAt: z.iso.datetime(),
        }),
      )
      .describe(`«بحث بلا نتائج»: the ${LOST_DEMAND_ROWS} missed most, most first.`),
    suggestions: z
      .array(
        z.object({
          id: z.uuid(),
          restaurantName: z.string(),
          note: z.string().nullable(),
          query: z.string().nullable().describe('The search the form followed.'),
          at: z.iso.datetime(),
        }),
      )
      .describe(`«مطاعم مقترحة»: the ${LOST_DEMAND_ROWS} latest.`),
  }),
) {}

// AP §9.17 «الطلب الضائع» (slice 2.28a): the searches with no result and
// the restaurants customers asked for, an operations report (AP §6.2). The
// other lost demand of AP §9.17 and the Excel export come with slice 2.41.
@AdminController('lost-demand')
export class AdminLostDemandController {
  constructor(
    private readonly lostDemand: LostDemandService,
    private readonly geo: GeoService,
  ) {}

  // 404 unknown_city.
  @Get()
  @RequireAnyPermission('reports.operations', 'reports.all')
  @ZodResponse({ status: 200, type: AdminLostDemandDto })
  async report(@Query() query: AdminLostDemandQueryDto) {
    if ((await this.geo.cityTimeZone(query.cityId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
    const report = await this.lostDemand.report(query.cityId, new Date());
    return {
      since: report.since.toISOString(),
      searches: report.searches.map((row) => ({ ...row, lastAt: row.lastAt.toISOString() })),
      suggestions: report.suggestions.map((row) => ({
        ...row,
        at: row.at.toISOString(),
      })),
    };
  }
}
