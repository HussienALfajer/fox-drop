import { Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { SignedIn } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { GeoService } from './geo.service.js';

class AdminCitiesDto extends createZodDto(
  z.object({
    cities: z
      .array(
        z.object({
          id: z.uuid(),
          code: z.string().describe('Such as AZ (AP §4.8).'),
          name: z.string(),
          timeZone: z.string().describe("The city's clock, such as Asia/Damascus."),
        }),
      )
      .describe('The active cities, by name.'),
  }),
) {}

// AP §7.2: the top bar's city selector, for every signed-in panel user. The
// city reads (the operations board, settings) take the chosen city's id.
@AdminController('cities')
export class AdminCitiesController {
  constructor(private readonly geo: GeoService) {}

  @Get()
  @SignedIn()
  @ZodResponse({ status: 200, type: AdminCitiesDto })
  async list() {
    return { cities: await this.geo.activeCities() };
  }
}
