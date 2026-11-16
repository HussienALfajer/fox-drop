import { Get, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import { pointQuery } from '../customers/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import type { AppSession } from '../identity/index.js';
import { type MyCode, PromoCodeUsesService } from '../marketing/index.js';
import { MerchantsService } from '../merchants/index.js';
import { QuoteService } from './quote.service.js';

class CustomerCodesQueryDto extends createZodDto(pointQuery) {}

const minor = z.string().regex(/^\d+$/).describe('Minor units of `currency`.');

class CustomerCodesDto extends createZodDto(
  z.object({
    currency: z.string().length(3).nullable().describe('The city base; null outside every city.'),
    codes: z
      .array(
        z.object({
          code: z.string(),
          kind: z.enum(['percentage', 'fixed_amount', 'free_delivery']),
          percentBp: z.int().nullable().describe('A percentage in basis points (2000 is 20%).'),
          amount: minor.nullable(),
          maxDiscount: minor.nullable(),
          minOrder: minor.nullable().describe('The minimum on the items value.'),
          restaurants: z
            .array(z.object({ id: z.uuid(), name: z.string() }))
            .describe('The restaurants it works with; none: all.'),
          zones: z.array(z.string()).describe('The zones it works in, by name; none: all.'),
          hours: z
            .object({ startMinute: z.int(), endMinute: z.int() })
            .nullable()
            .describe(
              'The hours on the city clock, minutes from midnight; an end at or before the start runs past midnight.',
            ),
          validTo: z.iso.datetime().describe('«ينتهي {التاريخ}».'),
          usesLeft: z.int().nullable().describe('What the customer has left; null: no limit.'),
          ended: z
            .object({ reason: z.enum(['used', 'expired']), at: z.iso.datetime() })
            .nullable()
            .describe('null in «متاحة»; else «منتهية», used or expired.'),
        }),
      )
      .describe('«متاحة» by the nearest end, then «منتهية» newest first.'),
  }),
) {}

// CU §12.4 «أكوادي» (slice 2.21d): the customer's codes in the city of the
// selected point, since the app knows no city (GeoService.locate).
@CustomerController('promo-codes')
export class CustomerCodesController {
  constructor(
    private readonly geo: GeoService,
    private readonly fx: FxService,
    private readonly codes: PromoCodeUsesService,
    private readonly quotes: QuoteService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerCodesDto })
  async list(@CurrentAppSession() session: AppSession, @Query() query: CustomerCodesQueryDto) {
    const now = new Date();
    const city = await this.geo.locate(query);
    const baseCurrency = city === null ? null : await this.fx.baseCurrency(city.cityId);
    if (city === null || baseCurrency === null) return { currency: null, codes: [] };
    const customer = await this.quotes.codeCustomer(session.accountId, session.deviceId);
    const mine = await this.codes.mine(
      {
        cityId: city.cityId,
        baseCurrency,
        clock: await this.codes.clock(city.cityId, now),
        customer,
      },
      now,
    );
    // Only restaurants and zones customers see are named; a code whose
    // places are all hidden or gone is left out, so a restricted code never
    // reads as working everywhere.
    const ids = [...new Set(mine.flatMap((code) => code.restaurantIds))];
    const [restaurants, zones] = await Promise.all([
      Promise.all(ids.map((id) => this.merchants.restaurant(id, now))),
      this.geo.zones(city.cityId),
    ]);
    const names = new Map(
      restaurants.flatMap((restaurant) =>
        restaurant !== null && restaurant.accountStatus === 'active' && restaurant.visible
          ? [[restaurant.id, restaurant.nameAr] as const]
          : [],
      ),
    );
    const zoneNames = new Map(
      zones.flatMap((zone) => (zone.active ? [[zone.id, zone.name] as const] : [])),
    );
    const codes = mine.flatMap((code) => {
      const shown = body(code, names, zoneNames);
      const hidden =
        (code.restaurantIds.length > 0 && shown.restaurants.length === 0) ||
        (code.zoneIds.length > 0 && shown.zones.length === 0);
      return hidden ? [] : [shown];
    });
    return { currency: baseCurrency, codes };
  }
}

function body(code: MyCode, names: Map<string, string>, zoneNames: Map<string, string>) {
  const text = (value: bigint | null) => (value === null ? null : value.toString());
  return {
    code: code.code,
    kind: code.kind,
    percentBp: code.percentBp,
    amount: text(code.amount),
    maxDiscount: text(code.maxDiscount),
    minOrder: text(code.minOrder),
    restaurants: code.restaurantIds.flatMap((id) => {
      const name = names.get(id);
      return name === undefined ? [] : [{ id, name }];
    }),
    zones: code.zoneIds.flatMap((id) => zoneNames.get(id) ?? []),
    hours:
      code.startMinute === null || code.endMinute === null
        ? null
        : { startMinute: code.startMinute, endMinute: code.endMinute },
    validTo: code.validTo.toISOString(),
    usesLeft: code.usesLeft,
    ended: code.ended && { reason: code.ended.reason, at: code.ended.at.toISOString() },
  };
}
