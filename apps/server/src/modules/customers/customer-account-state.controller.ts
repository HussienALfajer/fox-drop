import { Get, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import { GeoService } from '../geo/index.js';
import type { AppSession } from '../identity/index.js';
import { CustomersService, DEVICE_BLOCK_TEXT } from './customers.service.js';
import { pointQuery } from './point-query.js';

class CustomerAccountStateQueryDto extends createZodDto(pointQuery) {}

class CustomerAccountStateDto extends createZodDto(
  z.object({
    reviewStop: z
      .boolean()
      .describe('«حسابك موقوف حتى مراجعة فريق الدعم», with call and WhatsApp (CU §5.5).'),
    block: z
      .object({
        until: z.iso
          .datetime()
          .nullable()
          .describe(
            '«حسابك محظور حتى {التاريخ}: {السبب}»; null «حسابك محظور: {السبب}. تواصل مع الدعم.»',
          ),
        reason: z.string().describe("The block reason's customer text (CU Appendix C)."),
      })
      .nullable(),
    dues: z
      .object({
        amount: z.string().regex(/^\d+$/).describe('Minor units, above zero.'),
        currency: z.string(),
      })
      .nullable()
      .describe(
        '«عليك {المبلغ} لـ FOX DROP. ادفعه في المكتب ليُفك الحظر تلقائياً.» in the city of the point (AP §8.8).',
      ),
    office: z
      .object({
        latitude: z.number(),
        longitude: z.number(),
        hours: z
          .array(
            z.object({
              weekday: z.number().int().describe('0 Sunday to 6 Saturday.'),
              opensAt: z.number().int().describe('Minutes after midnight on the city clock.'),
              closesAt: z
                .number()
                .int()
                .describe(
                  'Minutes after midnight; at or before the opening it runs past midnight.',
                ),
            }),
          )
          .describe('The desk hours per weekday; a weekday not listed is closed.'),
        timeZone: z.string(),
        open: z.boolean(),
        closesAt: z.iso.datetime().nullable(),
        opensAt: z.iso.datetime().nullable(),
      })
      .nullable()
      .describe(
        "The dues sheet's office and its hours (AP §9.12.1); null until the owner sets it.",
      ),
  }),
) {}

// CU §5.5 (slice 2.25a): the banners of the account's state, read on
// opening and on returning to the app, at the selected point's city (the
// app knows no city; the dues and the office are the city's). Outside
// every city: the block and the review stop only.
@CustomerController('account-state')
export class CustomerAccountStateController {
  constructor(
    private readonly customers: CustomersService,
    private readonly geo: GeoService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerAccountStateDto })
  async read(
    @Query() query: CustomerAccountStateQueryDto,
    @CurrentAppSession() session: AppSession,
  ) {
    const now = new Date();
    const city = await this.geo.locate(query);
    const [reviewStop, ownBlock, owed] = await Promise.all([
      this.customers.reviewStopped(session.accountId),
      this.customers.activeBlock(session.accountId, now),
      city === null ? null : this.customers.dues(city.cityId, session.accountId),
    ]);
    // Slice 2.25d: another account's dues on the same phone show as a device
    // block, without its amount or the office.
    const dues = owed?.viaAccountId === null ? owed : null;
    const block =
      ownBlock ??
      (owed !== null && owed.viaAccountId !== null
        ? { until: null, customerText: DEVICE_BLOCK_TEXT }
        : null);
    const office = dues === null || city === null ? null : await this.geo.office(city.cityId, now);
    return {
      reviewStop,
      block: block && { until: block.until?.toISOString() ?? null, reason: block.customerText },
      dues: dues && { amount: dues.amount.toString(), currency: dues.currency },
      office: office && {
        latitude: office.location.latitude,
        longitude: office.location.longitude,
        hours: office.hours,
        timeZone: office.timeZone,
        open: office.open,
        closesAt: office.closesAt?.toISOString() ?? null,
        opensAt: office.opensAt?.toISOString() ?? null,
      },
    };
  }
}
