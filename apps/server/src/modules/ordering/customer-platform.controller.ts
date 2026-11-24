import { Get, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { Public } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import { GeoService } from '../geo/index.js';
import {
  platformAnswer,
  PlatformDto,
  platformVersion,
  SettingsService,
} from '../settings/index.js';
import { platformOpening } from './platform-hours.js';

// A query value: a number, never an empty string read as 0.
const coordinate = z.string().min(1).pipe(z.coerce.number());

class CustomerPlatformQueryDto extends createZodDto(
  z
    .object({
      version: platformVersion,
      latitude: coordinate
        .pipe(z.number().min(-90).max(90))
        .optional()
        .describe('The selected point (CU §7.1), with longitude: the platform hours of its city.'),
      longitude: coordinate.pipe(z.number().min(-180).max(180)).optional(),
    })
    .refine((query) => (query.latitude === undefined) === (query.longitude === undefined), {
      message: 'latitude and longitude come together',
    }),
) {}

// CU §4.2, §4.7 (slice D.11a): the customer app's GET platform, with the
// platform hours of the selected point's city (platform.hours, AP D9), read
// as the quote reads them. Here rather than in settings: settings cannot read
// geo. No point, or no city yet: no hours.
@CustomerController('platform')
export class CustomerPlatformController {
  constructor(
    private readonly settings: SettingsService,
    private readonly geo: GeoService,
  ) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: PlatformDto })
  async get(@Query() query: CustomerPlatformQueryDto): Promise<PlatformDto> {
    const now = new Date();
    const answer = await platformAnswer(this.settings, 'customer', query.version, now);
    if (query.latitude === undefined || query.longitude === undefined) return answer;
    const city = await this.geo.locate({ latitude: query.latitude, longitude: query.longitude });
    if (city === null) return answer;
    const [schedule, timeZone] = await Promise.all([
      this.settings.get('platform.hours', { cityId: city.cityId }),
      this.geo.cityTimeZone(city.cityId),
    ]);
    if (timeZone === null) return answer;
    const opening = platformOpening(schedule, now, timeZone);
    return {
      ...answer,
      hours: opening.open
        ? { open: true, opensAt: null }
        : { open: false, opensAt: opening.opensAt?.toISOString() ?? null },
    };
  }
}
