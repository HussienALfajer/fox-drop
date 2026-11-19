import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpStatus,
  NotFoundException,
  Param,
  Put,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { FxService } from '../fx/index.js';
import {
  type DeliveryFeeRule,
  type FeeRuleVersion,
  type GeoChange,
  GeoRefusedError,
  GeoService,
} from '../geo/index.js';
import { type AdminSession, AdminSessionsService } from '../identity/index.js';
import { MerchantsService, type RestaurantListRow } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';

const minor = z.string().regex(/^\d{1,18}$/);

const ruleFields = {
  currency: z.string().regex(/^[A-Z]{3}$/),
  minimumFee: minor.nullable().describe('A lower fee is raised to it; null for none.'),
  freeDeliveryFrom: minor
    .nullable()
    .describe('An items value from which delivery is free; null for none.'),
};
const band = z.object({
  upToMetres: z
    .number()
    .int()
    .positive()
    .nullable()
    .describe("The band's upper edge in metres, included; null for the last band."),
  fee: minor,
});
// «ثابت» or «شرائح مسافة» (AP §9.12.3), amounts in minor units.
const ruleBody = z.discriminatedUnion('kind', [
  z.object({ kind: z.literal('flat'), flatFee: minor, ...ruleFields }),
  z.object({
    kind: z.literal('distance_bands'),
    bands: z.array(band).min(1).max(20),
    ...ruleFields,
  }),
]);
const storedRule = z.discriminatedUnion('kind', [
  z.object({ id: z.uuid(), kind: z.literal('flat'), flatFee: minor, ...ruleFields }),
  z.object({
    id: z.uuid(),
    kind: z.literal('distance_bands'),
    bands: z.array(band),
    ...ruleFields,
  }),
]);
const version = z.object({
  rule: storedRule,
  editorName: z.string().nullable().describe('Null for the system or an unknown admin.'),
  reason: z.string().nullable(),
  createdAt: z.iso.datetime(),
});
const point = z.object({
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
});

class AdminDeliveryFeesQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminDeliveryFeesDto extends createZodDto(
  z.object({
    baseCurrency: z
      .string()
      .length(3)
      .nullable()
      .describe('The amounts are typed in it; null while the city has none.'),
    distanceMethod: z
      .enum(['road', 'straight_line'])
      .describe('pricing.distance_method: how a distance-band fee is measured.'),
    versions: z
      .array(version)
      .describe("The city's rule, newest first (the first is in effect), the latest 50."),
    restaurants: z
      .array(
        z.object({
          id: z.uuid(),
          nameAr: z.string(),
          location: point,
          ownRule: version.nullable().describe("Its own rule in effect; null: the city's."),
        }),
      )
      .describe('The restaurants with a pin, not terminated, by name.'),
  }),
) {}

class AdminSetDeliveryFeeDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    rule: ruleBody,
    reason: z.string().trim().max(300).nullable(),
  }),
) {}

class AdminDeliveryFeeRestaurantParamsDto extends createZodDto(
  z.object({ restaurantId: z.uuid() }),
) {}

class AdminSetRestaurantDeliveryFeeDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    rule: ruleBody.nullable().describe("Null returns the restaurant to the city's rule."),
    reason: z.string().trim().max(300).nullable(),
  }),
) {}

class AdminDeliveryFeePreviewQueryDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    restaurantId: z.uuid(),
    latitude: z.coerce.number().min(-90).max(90),
    longitude: z.coerce.number().min(-180).max(180),
    itemsValue: z
      .string()
      .regex(/^\d{1,18}$/)
      .default('0')
      .describe('Minor units of the base currency; 0 is the fee before any item.'),
  }),
) {}

class AdminDeliveryFeePreviewDto extends createZodDto(
  z.object({
    fee: minor,
    currency: z.string().length(3),
    free: z.boolean().describe('The free-delivery threshold reached.'),
    scope: z.enum(['city', 'restaurant']).describe("The city's rule or the restaurant's own."),
    ruleId: z.uuid(),
    freeDeliveryFrom: minor.nullable(),
    distance: z
      .object({
        metres: z.number().int(),
        method: z.enum(['road', 'straight_x1.3']),
      })
      .describe("The motorbike's distance from the restaurant, as a band fee measures it."),
    covers: z.boolean().describe('Whether the restaurant delivers to the point (CU §8).'),
    zoneName: z.string().nullable().describe('The active zone at the point; null outside.'),
  }),
) {}

// AP §9.12.3 «رسوم التوصيل» (slice 2.37a): the city's rule and its versions,
// the restaurants' own rules (owner decision 2026-11-19), and the preview
// calculator. Read with zones.read (OWN, OPS, FIN; AP §6.2), changed with
// zones.manage (OWN). The changes set a rule to the value sent, so no
// Idempotency-Key. Here, not in geo, since the restaurants are merchants'
// and the editors' names identity's.
@AdminController('delivery-fees')
export class AdminDeliveryFeesController {
  constructor(
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly fx: FxService,
    private readonly settings: SettingsService,
    private readonly sessions: AdminSessionsService,
  ) {}

  // 404 unknown_city.
  @Get()
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminDeliveryFeesDto })
  async screen(@Query() query: AdminDeliveryFeesQueryDto) {
    const { cityId } = query;
    await this.knownCity(cityId);
    const [baseCurrency, distanceMethod, versions, own, rows] = await Promise.all([
      this.fx.baseCurrency(cityId),
      this.settings.get('pricing.distance_method', {}),
      this.geo.deliveryFeeVersions(cityId),
      this.geo.restaurantFeeRules(cityId),
      this.merchants.listRows(cityId),
    ]);
    const ownBy = new Map(own.map((entry) => [entry.restaurantId, entry]));
    const names = await this.sessions.names(
      [...versions, ...own].flatMap((entry) => (entry.editorId === null ? [] : [entry.editorId])),
    );
    const view = (entry: FeeRuleVersion) => ({
      rule: ruleView(entry.rule),
      editorName: entry.editorId === null ? null : (names.get(entry.editorId) ?? null),
      reason: entry.reason,
      createdAt: entry.createdAt.toISOString(),
    });
    return {
      baseCurrency,
      distanceMethod,
      versions: versions.map(view),
      restaurants: listed(rows).map((row) => {
        const entry = ownBy.get(row.id);
        return {
          id: row.id,
          nameAr: row.nameAr,
          location: row.location!,
          ownRule: entry === undefined ? null : view(entry),
        };
      }),
    };
  }

  // 400 invalid_fee_rule; 409 fee_not_in_base_currency; 404 unknown_city.
  @Put()
  @RequirePermission('zones.manage')
  @ZodResponse({ status: 200, type: AdminDeliveryFeesDto })
  async setCityRule(
    @Body() body: AdminSetDeliveryFeeDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await this.knownCity(body.cityId);
    await refusals(() =>
      this.geo.setDeliveryFeeRule(
        body.cityId,
        ruleOf(body.rule),
        changeOf(session, request, body.reason),
      ),
    );
    return this.screen({ cityId: body.cityId });
  }

  // 400 invalid_fee_rule; 409 fee_not_in_base_currency; 404 unknown_city,
  // unknown_restaurant (not the city's, terminated or without its pin).
  @Put('restaurants/:restaurantId')
  @RequirePermission('zones.manage')
  @ZodResponse({ status: 200, type: AdminDeliveryFeesDto })
  async setRestaurantRule(
    @Param() params: AdminDeliveryFeeRestaurantParamsDto,
    @Body() body: AdminSetRestaurantDeliveryFeeDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await this.knownCity(body.cityId);
    await this.restaurantOf(body.cityId, params.restaurantId);
    await refusals(() =>
      this.geo.setRestaurantFeeRule(
        body.cityId,
        params.restaurantId,
        body.rule === null ? null : ruleOf(body.rule),
        changeOf(session, request, body.reason),
      ),
    );
    return this.screen({ cityId: body.cityId });
  }

  // The fee a customer would pay from the restaurant to the point (AP
  // §9.12.3 preview calculator). 409 no_fee_rule, fee_not_in_base_currency;
  // 404 unknown_city, unknown_restaurant.
  @Get('preview')
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminDeliveryFeePreviewDto })
  async preview(@Query() query: AdminDeliveryFeePreviewQueryDto) {
    await this.knownCity(query.cityId);
    const restaurant = await this.restaurantOf(query.cityId, query.restaurantId);
    const to = { latitude: query.latitude, longitude: query.longitude };
    const from = restaurant.location!;
    const [priced, covers, zone] = await Promise.all([
      refusals(() =>
        this.geo.deliveryFee(query.cityId, {
          restaurantId: restaurant.id,
          from,
          to,
          itemsValue: BigInt(query.itemsValue),
        }),
      ),
      this.merchants.covers(restaurant.id, to),
      this.geo.zoneAt(query.cityId, to),
    ]);
    // A flat rule measures nothing; the calculator shows the trip all the
    // same.
    const distance =
      priced.distance ?? (await this.geo.distance(from, to, { vehicle: 'motorbike' }));
    return {
      fee: priced.fee.toString(),
      currency: priced.currency,
      free: priced.free,
      scope: priced.scope,
      ruleId: priced.ruleId,
      freeDeliveryFrom: priced.freeDeliveryFrom?.toString() ?? null,
      distance,
      covers,
      zoneName: zone?.name ?? null,
    };
  }

  private async knownCity(cityId: string): Promise<void> {
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
  }

  private async restaurantOf(cityId: string, restaurantId: string): Promise<RestaurantListRow> {
    const row = listed(await this.merchants.listRows(cityId)).find(
      (each) => each.id === restaurantId,
    );
    if (row === undefined) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    return row;
  }
}

// The restaurants a fee applies to: with a pin and not terminated.
function listed(rows: RestaurantListRow[]): RestaurantListRow[] {
  return rows.filter((row) => row.location !== null && row.accountStatus !== 'terminated');
}

function changeOf(
  session: AdminSession,
  request: FastifyRequest,
  reason: string | null,
): GeoChange {
  return {
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
    reason: reason === null || reason === '' ? null : reason,
  };
}

function ruleOf(body: z.infer<typeof ruleBody>): DeliveryFeeRule {
  const common = {
    currency: body.currency,
    minimumFee: body.minimumFee === null ? null : BigInt(body.minimumFee),
    freeDeliveryFrom: body.freeDeliveryFrom === null ? null : BigInt(body.freeDeliveryFrom),
  };
  return body.kind === 'flat'
    ? { ...common, kind: 'flat', flatFee: BigInt(body.flatFee) }
    : {
        ...common,
        kind: 'distance_bands',
        bands: body.bands.map((each) => ({ upToMetres: each.upToMetres, fee: BigInt(each.fee) })),
      };
}

function ruleView(rule: FeeRuleVersion['rule']): z.infer<typeof storedRule> {
  const common = {
    id: rule.id,
    currency: rule.currency,
    minimumFee: rule.minimumFee?.toString() ?? null,
    freeDeliveryFrom: rule.freeDeliveryFrom?.toString() ?? null,
  };
  return rule.kind === 'flat'
    ? { ...common, kind: 'flat', flatFee: rule.flatFee.toString() }
    : {
        ...common,
        kind: 'distance_bands',
        bands: rule.bands.map((each) => ({
          upToMetres: each.upToMetres,
          fee: each.fee.toString(),
        })),
      };
}

// Geo's refusals as the routes answer them.
async function refusals<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (error instanceof GeoRefusedError && error.refusal === 'invalid_fee_rule') {
      throw new BadRequestException({
        statusCode: HttpStatus.BAD_REQUEST,
        error: error.refusal,
        message: error.message,
      });
    }
    if (
      error instanceof GeoRefusedError &&
      (error.refusal === 'fee_not_in_base_currency' || error.refusal === 'no_fee_rule')
    ) {
      throw new ConflictException({
        statusCode: HttpStatus.CONFLICT,
        error: error.refusal,
        message: error.message,
      });
    }
    throw error;
  }
}
