import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpStatus,
  NotFoundException,
  HttpCode,
  Param,
  Post,
  Put,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { CategoriesService } from '../content/index.js';
import { FilesRefusedError, FilesService } from '../files/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import type { AdminSession } from '../identity/index.js';
import { SettingsService } from '../settings/index.js';
import {
  type Coverage,
  type MerchantChange,
  MerchantsRefusedError,
  RESTAURANT_CATEGORIES_MAX,
} from './merchants.service.js';
import {
  DRAFT_ADDRESS_MAX,
  DRAFT_DESCRIPTION_MAX,
  DRAFT_NAME_MAX,
  type RestaurantDraft,
  RestaurantDraftsService,
} from './restaurant-drafts.service.js';

const minorUnits = z
  .string()
  .regex(/^\d{1,15}$/)
  .describe('Integer minor units of the currency, as a string.');

// The shapes are named in the OpenAPI document (`.meta({ id })`), so the
// clients' generator never merges them with another route's alike shape.
const money = z
  .object({ amount: minorUnits, currency: z.string().length(3) })
  .meta({ id: 'AdminDraftMoney' });

const period = z
  .object({
    weekday: z.int().min(0).max(6).describe('0 is Sunday, 6 Saturday.'),
    opensAt: z.int().min(0).max(1439).describe("Minutes after midnight on the city's clock."),
    closesAt: z
      .int()
      .min(0)
      .max(1440)
      .describe('Not after the opening: the period crosses midnight (00:00 to 00:00 is all day).'),
  })
  .meta({ id: 'AdminDraftPeriod' });

// Owner decision 2026-11-06: a radius in metres, or one or more zones. One
// flat object (no oneOf, which the Dart client cannot build).
const coverage = z
  .object({
    kind: z.enum(['radius', 'zones']),
    radiusMetres: z.int().min(1).max(100_000).nullable().describe('With kind radius only.'),
    zoneIds: z.array(z.uuid()).describe('With kind zones only, one or more.'),
  })
  .refine(
    (value) =>
      value.kind === 'radius'
        ? value.radiusMetres !== null && value.zoneIds.length === 0
        : value.radiusMetres === null && value.zoneIds.length > 0,
    { message: 'a radius alone, or zones alone' },
  )
  .meta({ id: 'AdminDraftCoverage' });

type FlatCoverage = z.infer<typeof coverage>;

const coverageOf = (flat: FlatCoverage): Coverage =>
  flat.kind === 'radius'
    ? { kind: 'radius', radiusMetres: flat.radiusMetres! }
    : { kind: 'zones', zoneIds: flat.zoneIds };

const flatOf = (value: Coverage): FlatCoverage =>
  value.kind === 'radius'
    ? { kind: 'radius', radiusMetres: value.radiusMetres, zoneIds: [] }
    : { kind: 'zones', radiusMetres: null, zoneIds: value.zoneIds };

const point = z
  .object({
    latitude: z.number().min(-90).max(90),
    longitude: z.number().min(-180).max(180),
  })
  .meta({ id: 'AdminDraftPoint' });

const choice = z.object({ id: z.uuid(), name: z.string() }).meta({ id: 'AdminDraftChoice' });

const steps = z
  .object({
    basics: z.boolean(),
    location: z.boolean(),
    operations: z.boolean(),
    commission: z.boolean(),
    contract: z.boolean().describe('Confirmed with the price-parity pledge.'),
  })
  .describe('Which steps of AP §9.6.3 hold what they need.');

class AdminRestaurantDraftsQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminRestaurantDraftParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminRestaurantDraftsDto extends createZodDto(
  z.object({
    drafts: z.array(
      z.object({
        id: z.uuid(),
        nameAr: z.string(),
        accountStatus: z
          .enum(['draft', 'test'])
          .describe('A draft, or a restaurant in test mode waiting for its activation (step 8).'),
        steps,
        createdAt: z.iso.datetime(),
        updatedAt: z.iso.datetime(),
      }),
    ),
  }),
) {}

class AdminRestaurantDraftChoicesDto extends createZodDto(
  z.object({
    categories: z.array(choice),
    categoriesMax: z.int(),
    zones: z.array(choice),
    baseCurrency: z.string().nullable(),
    centre: point
      .nullable()
      .describe("Where the map starts: the centre of the city's active zones; null without any."),
    prepFloorMin: z.int(),
    prepCeilingMin: z.int(),
    defaultPrepMin: z.int().describe('merchant.default_prep_min, the step-3 start.'),
    defaultMinimumOrder: money.nullable().describe('merchant.default_min_order; null when unset.'),
    defaultCommissionBp: z.int().describe('merchant.default_commission_pct, in basis points.'),
    nameMax: z.int(),
    descriptionMax: z.int(),
    addressMax: z.int(),
  }),
) {}

class AdminRestaurantDraftDto extends createZodDto(
  z.object({
    id: z.uuid(),
    cityId: z.uuid(),
    accountStatus: z.string(),
    basics: z.object({
      nameAr: z.string(),
      nameEn: z.string().nullable(),
      categoryIds: z.array(z.uuid()),
      description: z.string().nullable(),
      logoKey: z.string().nullable(),
      coverKey: z.string().nullable(),
    }),
    location: z.object({
      location: point.nullable(),
      address: z.string().nullable(),
      phone: z.string().nullable(),
      ownerName: z.string().nullable(),
    }),
    operations: z.object({
      periods: z.array(period),
      defaultPrepMin: z.int().nullable(),
      minimumOrder: money.nullable(),
      coverage: coverage.nullable(),
    }),
    commission: z
      .object({
        rateBp: z.int().describe('The standard commission, in basis points of the items value.'),
        launch: z
          .object({ rateBp: z.int(), until: z.iso.datetime() })
          .nullable()
          .describe('A launch commission in force until a moment, then the standard one.'),
      })
      .nullable(),
    contract: z
      .object({
        signedOn: z.string().nullable(),
        durationMonths: z.int().nullable(),
        contractUrl: z
          .string()
          .nullable()
          .describe("The scan's signed GET on the panel's origin, valid 10 minutes."),
        licenceUrl: z.string().nullable(),
        confirmedAt: z.iso.datetime().nullable(),
      })
      .nullable(),
    steps,
  }),
) {}

class AdminDraftCommissionDto extends createZodDto(
  z.object({
    rateBp: z.int().min(0).max(10_000),
    launch: z.object({ rateBp: z.int().min(0).max(10_000), until: z.iso.datetime() }).nullable(),
  }),
) {}

class AdminDraftContractDto extends createZodDto(
  z.object({
    signedOn: z.iso.date(),
    durationMonths: z.int().min(1).max(120),
    contractUploadId: z
      .uuid()
      .nullable()
      .describe('An upload of restaurant_contract to replace the scan; null keeps it.'),
    licenceUploadId: z
      .uuid()
      .nullable()
      .describe('An upload of restaurant_licence to replace the scan; null keeps it.'),
  }),
) {}

class AdminDraftConfirmContractDto extends createZodDto(
  z.object({
    parityPledge: z
      .literal(true)
      .describe('The price-parity pledge: in-app prices at most the in-store ones.'),
  }),
) {}

class AdminDraftBasicsDto extends createZodDto(
  z.object({
    cityId: z.uuid().describe('The city of a new draft; the same city for a saved one.'),
    nameAr: z.string().max(DRAFT_NAME_MAX),
    nameEn: z.string().max(DRAFT_NAME_MAX).nullable(),
    categoryIds: z
      .array(z.uuid())
      .max(RESTAURANT_CATEGORIES_MAX)
      .describe('Active categories of «التصنيفات», once each, in the chosen order.'),
    description: z.string().max(DRAFT_DESCRIPTION_MAX).nullable(),
  }),
) {}

class AdminProfileBasicsDto extends createZodDto(
  z.object({
    nameAr: z.string().max(DRAFT_NAME_MAX),
    nameEn: z.string().max(DRAFT_NAME_MAX).nullable(),
    categoryIds: z
      .array(z.uuid())
      .max(RESTAURANT_CATEGORIES_MAX)
      .describe('Active categories of «التصنيفات», once each, in the chosen order.'),
    description: z.string().max(DRAFT_DESCRIPTION_MAX).nullable(),
  }),
) {}

class AdminDraftLocationDto extends createZodDto(
  z.object({
    location: point,
    address: z.string().max(DRAFT_ADDRESS_MAX).nullable(),
    phone: z.string().nullable().describe("The restaurant's number in E.164."),
    ownerName: z.string().max(DRAFT_NAME_MAX).nullable(),
  }),
) {}

class AdminDraftOperationsDto extends createZodDto(
  z.object({
    periods: z.array(period).min(1).max(70),
    defaultPrepMin: z.int(),
    minimumOrder: money,
    coverage,
  }),
) {}

const operationsOf = (body: AdminDraftOperationsDto) => ({
  ...body,
  coverage: coverageOf(body.coverage),
  minimumOrder: {
    amount: BigInt(body.minimumOrder.amount),
    currency: body.minimumOrder.currency,
  },
});

function refusalAsHttp(error: unknown): never {
  if (error instanceof MerchantsRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_restaurant' || error.refusal === 'unknown_city') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (error.refusal === 'restaurant_terminated') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, ...body });
    }
    if (
      error.refusal === 'not_a_draft' ||
      error.refusal === 'still_a_draft' ||
      error.refusal === 'not_in_base_currency' ||
      error.refusal === 'upload_used'
    ) {
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
    }
    throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
  }
  if (error instanceof FilesRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'upload_not_found') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (error.refusal === 'upload_wrong_purpose' || error.refusal === 'upload_invalid') {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
  }
  throw error;
}

function adminChange(session: AdminSession, request: FastifyRequest): MerchantChange {
  return {
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

// How long a scan's signed GET lasts.
const SCAN_URL_SECONDS = 600;

async function draftAsJson(draft: RestaurantDraft, files: FilesService) {
  const scan = (key: string | null) =>
    key === null ? Promise.resolve(null) : files.privateImageUrl(key, SCAN_URL_SECONDS);
  const contract = draft.contract;
  return {
    id: draft.id,
    cityId: draft.cityId,
    accountStatus: draft.accountStatus,
    basics: draft.basics,
    location: draft.location,
    operations: {
      periods: draft.operations.periods,
      defaultPrepMin: draft.operations.defaultPrepMin,
      minimumOrder:
        draft.operations.minimumOrder === null
          ? null
          : {
              amount: draft.operations.minimumOrder.amount.toString(),
              currency: draft.operations.minimumOrder.currency,
            },
      coverage: draft.operations.coverage && flatOf(draft.operations.coverage),
    },
    commission:
      draft.commission === null
        ? null
        : {
            rateBp: draft.commission.rateBp,
            launch:
              draft.commission.launch === null
                ? null
                : {
                    rateBp: draft.commission.launch.rateBp,
                    until: draft.commission.launch.until.toISOString(),
                  },
          },
    contract:
      contract === null
        ? null
        : {
            signedOn: contract.signedOn,
            durationMonths: contract.durationMonths,
            contractUrl: await scan(contract.contractKey),
            licenceUrl: await scan(contract.licenceKey),
            confirmedAt: contract.confirmedAt?.toISOString() ?? null,
          },
    steps: draft.steps,
  };
}

// The onboarding wizard «إضافة مطعم» (AP §9.6.3 steps 1–3; slice 2.30a):
// the city's drafts, the wizard's choices, a draft's read and each step's
// save. The panel names a new draft's id, so a step's save sets values and
// takes no Idempotency-Key: a retry writes nothing more. Steps 1–3 are
// DATA's, OPS's and OWN's (restaurants.create); the logo and cover use the
// restaurant's own routes. 400 invalid_restaurant, invalid_schedule,
// invalid_prep_time, invalid_coverage, unknown_category; 404
// unknown_restaurant, unknown_city; 409 not_a_draft, not_in_base_currency.
@AdminController('restaurant-drafts')
export class AdminRestaurantDraftsController {
  constructor(
    private readonly drafts: RestaurantDraftsService,
    private readonly categories: CategoriesService,
    private readonly geo: GeoService,
    private readonly fx: FxService,
    private readonly settings: SettingsService,
    private readonly files: FilesService,
  ) {}

  @Get()
  @RequireAnyPermission('restaurants.read', 'restaurants.create')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftsDto })
  async list(@Query() query: AdminRestaurantDraftsQueryDto) {
    const drafts = await this.drafts.drafts(query.cityId);
    return {
      drafts: drafts.map((draft) => ({
        ...draft,
        createdAt: draft.createdAt.toISOString(),
        updatedAt: draft.updatedAt.toISOString(),
      })),
    };
  }

  @Get('choices')
  @RequireAnyPermission('restaurants.read', 'restaurants.create')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftChoicesDto })
  async choices(@Query() query: AdminRestaurantDraftsQueryDto) {
    const scope = { cityId: query.cityId };
    const [categories, zones, centre, baseCurrency, floor, ceiling, prep, minimum, commission] =
      await Promise.all([
        this.categories.active(),
        this.geo.zones(query.cityId),
        this.geo.zonesCentre(query.cityId),
        this.fx.baseCurrency(query.cityId),
        this.settings.get('merchant.prep_time_floor_min', scope),
        this.settings.get('merchant.prep_time_ceiling_min', scope),
        this.settings.get('merchant.default_prep_min', scope),
        this.settings.get('merchant.default_min_order', scope),
        this.settings.get('merchant.default_commission_pct', scope),
      ]);
    return {
      categories: categories.map((category) => ({ id: category.id, name: category.name })),
      categoriesMax: RESTAURANT_CATEGORIES_MAX,
      zones: zones.filter((zone) => zone.active).map(({ id, name }) => ({ id, name })),
      baseCurrency,
      centre,
      prepFloorMin: floor,
      prepCeilingMin: ceiling,
      defaultPrepMin: prep,
      defaultMinimumOrder:
        minimum === null || minimum.currency === null
          ? null
          : { amount: String(minimum.amountMinor), currency: minimum.currency },
      defaultCommissionBp: Math.round(commission * 100),
      nameMax: DRAFT_NAME_MAX,
      descriptionMax: DRAFT_DESCRIPTION_MAX,
      addressMax: DRAFT_ADDRESS_MAX,
    };
  }

  @Get(':restaurantId')
  @RequireAnyPermission('restaurants.read', 'restaurants.create')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async read(
    @Param() params: AdminRestaurantDraftParamsDto,
    @CurrentAdminSession() session: AdminSession,
  ) {
    const draft = await this.found(params.restaurantId);
    // DATA (restaurants.create without restaurants.read, owner decision
    // 2026-11-05) reads drafts only, and test mode, whose menu is still
    // theirs (step 7, slice 2.30b): an active restaurant is theirs to read no
    // more.
    if (
      draft.accountStatus !== 'draft' &&
      draft.accountStatus !== 'test' &&
      !session.permissions.includes('restaurants.read')
    ) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    return draftAsJson(draft, this.files);
  }

  @Put(':restaurantId/basics')
  @RequirePermission('restaurants.create')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async basics(
    @Param() params: AdminRestaurantDraftParamsDto,
    @Body() body: AdminDraftBasicsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      const { cityId, ...basics } = body;
      await this.drafts.saveBasics(
        params.restaurantId,
        cityId,
        basics,
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  @Put(':restaurantId/location')
  @RequirePermission('restaurants.create')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async location(
    @Param() params: AdminRestaurantDraftParamsDto,
    @Body() body: AdminDraftLocationDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.drafts.saveLocation(params.restaurantId, body, adminChange(session, request));
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  @Put(':restaurantId/operations')
  @RequirePermission('restaurants.create')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async operations(
    @Param() params: AdminRestaurantDraftParamsDto,
    @Body() body: AdminDraftOperationsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.drafts.saveOperations(
        params.restaurantId,
        operationsOf(body),
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  // Step 4, OWN alone (restaurants.commission): the commission and an
  // optional launch rate until a moment (D16, D26).
  @Put(':restaurantId/commission')
  @RequirePermission('restaurants.commission')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async commission(
    @Param() params: AdminRestaurantDraftParamsDto,
    @Body() body: AdminDraftCommissionDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.drafts.saveCommission(
        params.restaurantId,
        {
          rateBp: body.rateBp,
          launch:
            body.launch === null
              ? null
              : { rateBp: body.launch.rateBp, until: new Date(body.launch.until) },
        },
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  // Step 5: DATA enters the contract and uploads its scans
  // (restaurants.create)...
  @Put(':restaurantId/contract')
  @RequirePermission('restaurants.create')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async contract(
    @Param() params: AdminRestaurantDraftParamsDto,
    @Body() body: AdminDraftContractDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.drafts.saveContract(params.restaurantId, body, adminChange(session, request));
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  // ...and OWN or OPS confirm it with the pledge (restaurants.manage). A
  // repeat changes nothing, so no Idempotency-Key.
  @Post(':restaurantId/contract/confirm')
  @HttpCode(200)
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async confirmContract(
    @Param() params: AdminRestaurantDraftParamsDto,
    @Body() _body: AdminDraftConfirmContractDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.drafts.confirmContract(params.restaurantId, adminChange(session, request));
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  private async answer(restaurantId: string) {
    return draftAsJson(await this.found(restaurantId), this.files);
  }

  private async found(restaurantId: string): Promise<RestaurantDraft> {
    const draft = await this.drafts.draft(restaurantId);
    if (draft === null) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    return draft;
  }
}

// AP §9.6.4 «البيانات», «الموقع», «الأوقات» (slice 2.30d, owner decision
// 2026-11-18): the restaurant profile edits the wizard's steps 1–3 of a
// restaurant past its draft (test mode, active or suspended), OWN and OPS
// (restaurants.manage: «Edit, except commission», AP §6.2). The same bodies
// and checks as the wizard's, each answering the restaurant as the wizard
// reads it; no Idempotency-Key, since each sets values. 409 still_a_draft
// (the wizard's), 403 restaurant_terminated.
@AdminController('restaurants')
export class AdminRestaurantProfileController {
  constructor(
    private readonly drafts: RestaurantDraftsService,
    private readonly files: FilesService,
  ) {}

  @Put(':restaurantId/profile/basics')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async basics(
    @Param() params: AdminRestaurantDraftParamsDto,
    @Body() body: AdminProfileBasicsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.drafts.editBasics(params.restaurantId, body, adminChange(session, request));
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  @Put(':restaurantId/profile/location')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async location(
    @Param() params: AdminRestaurantDraftParamsDto,
    @Body() body: AdminDraftLocationDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.drafts.saveLocation(
        params.restaurantId,
        body,
        adminChange(session, request),
        'profile',
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  @Put(':restaurantId/profile/operations')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantDraftDto })
  async operations(
    @Param() params: AdminRestaurantDraftParamsDto,
    @Body() body: AdminDraftOperationsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.drafts.saveOperations(
        params.restaurantId,
        operationsOf(body),
        adminChange(session, request),
        'profile',
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  private async answer(restaurantId: string) {
    const draft = await this.drafts.draft(restaurantId);
    if (draft === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_restaurant' });
    }
    return draftAsJson(draft, this.files);
  }
}
