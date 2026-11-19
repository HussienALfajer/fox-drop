import { Body, HttpCode, Post } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, SignedIn } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { ticketStatuses } from '../support/index.js';
import { AdminSearch } from './admin-search.js';
import { orderStatuses } from './schema.js';

class AdminSearchQueryDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    q: z
      .string()
      .trim()
      .min(1)
      .max(60)
      .describe(
        'An order or ticket number (#10001, T-5521), a phone, or a part of a restaurant or captain name.',
      ),
  }),
) {}

const found = z.object({ id: z.uuid(), name: z.string() });

class AdminSearchResultsDto extends createZodDto(
  z.object({
    orders: z
      .array(z.object({ id: z.uuid(), number: z.string(), status: z.enum(orderStatuses) }))
      .describe('By number, for operations.read.'),
    restaurants: z.array(found).describe('By a part of the name, for restaurants.read.'),
    captains: z.array(found).describe('By a part of the name or the phone, for captains.read.'),
    tickets: z
      .array(z.object({ id: z.uuid(), number: z.string(), status: z.enum(ticketStatuses) }))
      .describe('By number, for support.read.'),
    customers: z
      .array(found.extend({ maskedPhone: z.string() }))
      .describe('By the phone, for customers.read with customers.reveal_phone (OWN, OPS, SUP).'),
  }),
) {}

// AP §7.2 the top bar's global search. Every panel user may search; each
// kind answers only to whoever reads its module, the others are empty. A
// read sent as a POST so a phone never sits in a URL; no key.
@AdminController('search')
export class AdminSearchController {
  constructor(private readonly searches: AdminSearch) {}

  @Post()
  @SignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminSearchResultsDto })
  async search(@Body() body: AdminSearchQueryDto, @CurrentAdminSession() session: AdminSession) {
    return (await this.searches.search(
      body.cityId,
      body.q,
      session.permissions,
      new Date(),
    )) as AdminSearchResultsDto;
  }
}
