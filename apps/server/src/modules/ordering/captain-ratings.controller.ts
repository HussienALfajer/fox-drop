import { ForbiddenException, Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { RatingPagesService } from './rating-pages.js';

class CaptainRatingsDto extends createZodDto(
  z.object({
    count: z.int().describe('Every rating of the captain, test orders left out.'),
    average: z.number().nullable().describe('Their average stars to one decimal; null with none.'),
    reasons: z
      .array(z.object({ code: z.string(), label: z.string(), count: z.int() }))
      .describe('Each reason customers picked with its count, most picked first.'),
  }),
) {}

// CA §11.2 (C14), CU §12.1, Q16 (slice 2.26c): the captain's average, count
// and reasons with counts, never a customer or a comment.
@CaptainController()
export class CaptainRatingsController {
  constructor(private readonly ratings: RatingPagesService) {}

  @Get('ratings')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainRatingsDto })
  async read(@CurrentAppSession() session: AppSession) {
    if (session.captain === null) throw new ForbiddenException();
    return this.ratings.captainSummary(session.captain.captainId);
  }
}
