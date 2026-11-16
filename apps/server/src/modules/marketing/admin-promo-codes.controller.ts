import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Query,
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import type { AdminSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PromoCodeUsesService } from './promo-code-uses.service.js';
import { promoCodeState, type PromoFields } from './promo-codes.js';
import {
  type PromoChange,
  type PromoCode,
  PromoCodesService,
  PromoRefusedError,
} from './promo-codes.service.js';
import {
  promoCodeAudiences,
  promoCodeFundings,
  promoCodeKinds,
  promoCodeVisibilities,
} from './schema.js';

const minor = z.string().regex(/^\d{1,18}$/);
const minuteOfDay = z.number().int().min(0).max(1439);
const basisPoints = z.number().int().min(1).max(10000);

const fields = {
  kind: z.enum(promoCodeKinds),
  percentBp: basisPoints.nullable().describe('A percentage code: 2000 is 20%.'),
  amount: minor.nullable().describe('A fixed-amount code: minor units of the base currency.'),
  maxDiscount: minor.nullable().describe("A percentage code's cap, or null for none."),
  minOrder: minor.nullable().describe('On the items value before discounts; null for none.'),
  validFrom: z.iso.datetime(),
  validTo: z.iso.datetime(),
  startMinute: minuteOfDay
    .nullable()
    .describe('Optional hours: minutes from midnight on the city clock, 20:00 is 1200.'),
  endMinute: minuteOfDay
    .nullable()
    .describe('At or before the start, the hours run past midnight.'),
  totalLimit: z.number().int().min(1).max(1_000_000).nullable().describe('Null: no limit.'),
  perCustomerLimit: z.number().int().min(1).max(1000).nullable().describe('Null: no limit.'),
  audience: z.enum(promoCodeAudiences),
  restaurantIds: z.array(z.uuid()).max(500).describe('None: every restaurant.'),
  zoneIds: z.array(z.uuid()).max(200).describe('None: every zone.'),
  funding: z.enum(promoCodeFundings),
  sharedMerchantBp: basisPoints
    .nullable()
    .describe("A shared code: the restaurant's share, 4000 is 40%; null otherwise."),
  dailyBudget: minor.nullable().describe('Pauses the code for the business day; null for none.'),
  visibility: z.enum(promoCodeVisibilities),
};

const promoCodeBody = z.object({
  id: z.uuid(),
  code: z.string(),
  batchId: z.uuid().nullable(),
  ...fields,
  currency: z.string().length(3),
  status: z.enum(['active', 'paused']).describe('Set by OWN.'),
  state: z
    .enum(['active', 'paused', 'scheduled', 'expired'])
    .describe('What the list shows: paused, not started, ended or running.'),
  uses: z.number().int().describe('Uses held or spent (not given back).'),
  costToDate: minor
    .nullable()
    .describe('The discounts of the uses not given back; null without marketing.read_costs.'),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
});

class AdminPromoCodeDto extends createZodDto(promoCodeBody) {}

class AdminPromoCodesQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminPromoCodesDto extends createZodDto(
  z.object({
    codes: z.array(promoCodeBody),
    restaurants: z.array(z.object({ id: z.uuid(), name: z.string() })),
    zones: z.array(z.object({ id: z.uuid(), name: z.string(), active: z.boolean() })),
    baseCurrency: z
      .string()
      .length(3)
      .nullable()
      .describe('The amounts are typed in it; null while the city has none.'),
    canManage: z.boolean().describe('Whether this admin may create, edit, pause and resume.'),
  }),
) {}

class AdminCreatePromoCodeDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    code: z.string().trim().min(3).max(20).describe('Letters and digits, saved in upper case.'),
    ...fields,
  }),
) {}

class AdminGeneratePromoCodesDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    count: z.number().int().min(2).max(500),
    prefix: z
      .string()
      .trim()
      .regex(/^[A-Za-z0-9]{0,8}$/)
      .describe('Before 8 random characters; may be empty.'),
    ...fields,
  }),
) {}

class AdminPromoCodesCreatedDto extends createZodDto(z.object({ codes: z.array(promoCodeBody) })) {}

class AdminEditPromoCodeDto extends createZodDto(z.object({ cityId: z.uuid(), ...fields })) {}

class AdminPromoCodeCityDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminPromoCodeParamsDto extends createZodDto(z.object({ codeId: z.uuid() })) {}

class AdminExtendPromoCodeDto extends createZodDto(
  z.object({ cityId: z.uuid(), validTo: z.iso.datetime().describe('The new end.') }),
) {}

const count = z.int().min(0);

class AdminPromoCodeReportDto extends createZodDto(
  z.object({
    code: promoCodeBody,
    report: z
      .object({
        orders: count.describe('Orders with the code, uses given back left out.'),
        returned: count.describe(
          'Uses given back (rejected, cancelled, failed not by the customer).',
        ),
        customers: count.describe('Customer accounts behind those orders.'),
        newCustomers: count.describe(
          'Numbers whose order with the code was placed with no delivered order before and ended delivered.',
        ),
        cost: z
          .string()
          .regex(/^\d+$/)
          .nullable()
          .describe(
            'The discounts, minor units of the code currency; null without the cost permission.',
          ),
        merchantShare: z
          .string()
          .regex(/^\d+$/)
          .nullable()
          .describe('The restaurants part of the cost; null without the cost permission.'),
      })
      .describe('AP §9.11.1 «Code report».'),
    canManage: z.boolean().describe('Pause, resume and extend (marketing.manage).'),
  }),
) {}

type FieldsBody = z.infer<z.ZodObject<typeof fields>>;

// AP §9.11.1 «أكواد الخصم» (slice 2.21a): OWN creates, edits, pauses and
// resumes codes (marketing.manage); OPS reads them (marketing.read) and FIN
// reads them with their cost (marketing.read_costs, AP §6).
@AdminController('promo-codes')
export class AdminPromoCodesController {
  constructor(
    private readonly codes: PromoCodesService,
    private readonly uses: PromoCodeUsesService,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly fx: FxService,
  ) {}

  // Every code of the city, newest first, with what the form chooses from.
  @Get()
  @RequireAnyPermission('marketing.read', 'marketing.read_costs', 'marketing.manage')
  @ZodResponse({ status: 200, type: AdminPromoCodesDto })
  async list(
    @Query() query: AdminPromoCodesQueryDto,
    @CurrentAdminSession() session: AdminSession,
  ) {
    const [codes, restaurants, zones, baseCurrency] = await Promise.all([
      this.codes.list(query.cityId),
      this.merchants.restaurantIds(query.cityId),
      this.geo.zones(query.cityId),
      this.fx.baseCurrency(query.cityId),
    ]);
    const totals = await this.uses.totals(codes.map((code) => code.id));
    const now = new Date();
    return {
      codes: codes.map((code) => codeBody(code, session, now, totals.get(code.id))),
      restaurants: restaurants.map(({ id, nameAr }) => ({ id, name: nameAr })),
      zones,
      baseCurrency,
      canManage: session.permissions.includes('marketing.manage'),
    };
  }

  // One code typed by hand. 400 invalid_promo_code; 404 unknown_city;
  // 409 code_taken, no_base_currency; 422 idempotency_key_reused.
  @Post()
  @RequirePermission('marketing.manage')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminPromoCodesCreatedDto })
  create(
    @Body() body: AdminCreatePromoCodeDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const created = await this.codes.create(
        body.cityId,
        { code: body.code },
        fieldsOf(body),
        idempotencyKey,
        changeOf(session, request),
      );
      const now = new Date();
      return { codes: created.map((code) => codeBody(code, session, now)) };
    });
  }

  // A batch of unique generated codes with the same fields. The same
  // refusals as one code, but code_taken.
  @Post('batch')
  @RequirePermission('marketing.manage')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminPromoCodesCreatedDto })
  generate(
    @Body() body: AdminGeneratePromoCodesDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const created = await this.codes.create(
        body.cityId,
        { count: body.count, prefix: body.prefix },
        fieldsOf(body),
        idempotencyKey,
        changeOf(session, request),
      );
      const now = new Date();
      return { codes: created.map((code) => codeBody(code, session, now)) };
    });
  }

  // Sets a code's fields to the values sent (not the code itself), so no
  // Idempotency-Key. 400 invalid_promo_code; 404 unknown_promo_code;
  // 409 no_base_currency, currency_changed.
  @Put(':codeId')
  @RequirePermission('marketing.manage')
  @ZodResponse({ status: 200, type: AdminPromoCodeDto })
  edit(
    @Param() params: AdminPromoCodeParamsDto,
    @Body() body: AdminEditPromoCodeDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      codeBody(
        await this.codes.edit(
          body.cityId,
          params.codeId,
          fieldsOf(body),
          changeOf(session, request),
        ),
        session,
        new Date(),
      ),
    );
  }

  // Sets the status, so no Idempotency-Key. 404 unknown_promo_code.
  @Post(':codeId/pause')
  @RequirePermission('marketing.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminPromoCodeDto })
  pause(
    @Param() params: AdminPromoCodeParamsDto,
    @Body() body: AdminPromoCodeCityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      codeBody(
        await this.codes.setStatus(
          body.cityId,
          params.codeId,
          'paused',
          changeOf(session, request),
        ),
        session,
        new Date(),
      ),
    );
  }

  // AP §9.11.1 «Code report» (slice 2.21d): the code with its report; the
  // cost and the restaurants' part are null without the cost permission,
  // as the list's. 404 unknown_promo_code.
  @Get(':codeId/report')
  @RequireAnyPermission('marketing.read', 'marketing.read_costs', 'marketing.manage')
  @ZodResponse({ status: 200, type: AdminPromoCodeReportDto })
  async report(
    @Param() params: AdminPromoCodeParamsDto,
    @Query() query: AdminPromoCodesQueryDto,
    @CurrentAdminSession() session: AdminSession,
  ) {
    const code = await this.codes.code(query.cityId, params.codeId);
    if (code === null) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_promo_code',
      });
    }
    const report = await this.uses.report(code.id);
    const seesCosts =
      session.permissions.includes('marketing.read_costs') ||
      session.permissions.includes('marketing.manage');
    return {
      code: codeBody(code, session, new Date(), { uses: report.orders, cost: report.cost }),
      report: {
        orders: report.orders,
        returned: report.returned,
        customers: report.customers,
        newCustomers: report.newCustomers,
        cost: seesCosts ? report.cost.toString() : null,
        merchantShare: seesCosts ? report.merchantShare.toString() : null,
      },
      canManage: session.permissions.includes('marketing.manage'),
    };
  }

  // «تمديد» from the report: a later end. Sets a value, so no
  // Idempotency-Key. 400 invalid_promo_code; 404 unknown_promo_code; 409
  // currency_changed.
  @Post(':codeId/extend')
  @RequirePermission('marketing.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminPromoCodeDto })
  extend(
    @Param() params: AdminPromoCodeParamsDto,
    @Body() body: AdminExtendPromoCodeDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      codeBody(
        await this.codes.extend(
          body.cityId,
          params.codeId,
          new Date(body.validTo),
          changeOf(session, request),
        ),
        session,
        new Date(),
      ),
    );
  }

  @Post(':codeId/resume')
  @RequirePermission('marketing.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminPromoCodeDto })
  resume(
    @Param() params: AdminPromoCodeParamsDto,
    @Body() body: AdminPromoCodeCityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      codeBody(
        await this.codes.setStatus(
          body.cityId,
          params.codeId,
          'active',
          changeOf(session, request),
        ),
        session,
        new Date(),
      ),
    );
  }
}

function fieldsOf(body: FieldsBody): PromoFields {
  const amount = (value: string | null) => (value === null ? null : BigInt(value));
  return {
    kind: body.kind,
    percentBp: body.percentBp,
    amount: amount(body.amount),
    maxDiscount: amount(body.maxDiscount),
    minOrder: amount(body.minOrder),
    validFrom: new Date(body.validFrom),
    validTo: new Date(body.validTo),
    startMinute: body.startMinute,
    endMinute: body.endMinute,
    totalLimit: body.totalLimit,
    perCustomerLimit: body.perCustomerLimit,
    audience: body.audience,
    restaurantIds: body.restaurantIds,
    zoneIds: body.zoneIds,
    funding: body.funding,
    sharedMerchantBp: body.sharedMerchantBp,
    dailyBudget: amount(body.dailyBudget),
    visibility: body.visibility,
  };
}

function codeBody(
  code: PromoCode,
  session: AdminSession,
  now: Date,
  totals: { uses: number; cost: bigint } = { uses: 0, cost: 0n },
) {
  const text = (value: bigint | null) => (value === null ? null : value.toString());
  const seesCosts =
    session.permissions.includes('marketing.read_costs') ||
    session.permissions.includes('marketing.manage');
  return {
    id: code.id,
    code: code.code,
    batchId: code.batchId,
    kind: code.kind,
    percentBp: code.percentBp,
    amount: text(code.amount),
    maxDiscount: text(code.maxDiscount),
    minOrder: text(code.minOrder),
    validFrom: code.validFrom.toISOString(),
    validTo: code.validTo.toISOString(),
    startMinute: code.startMinute,
    endMinute: code.endMinute,
    totalLimit: code.totalLimit,
    perCustomerLimit: code.perCustomerLimit,
    audience: code.audience,
    restaurantIds: code.restaurantIds,
    zoneIds: code.zoneIds,
    funding: code.funding,
    sharedMerchantBp: code.funding === 'shared' ? code.merchantShareBp : null,
    dailyBudget: text(code.dailyBudget),
    visibility: code.visibility,
    currency: code.currency,
    status: code.status,
    state: promoCodeState(code, now),
    uses: totals.uses,
    costToDate: seesCosts ? totals.cost.toString() : null,
    createdAt: code.createdAt.toISOString(),
    updatedAt: code.updatedAt.toISOString(),
  };
}

function changeOf(session: AdminSession, request: FastifyRequest): PromoChange {
  return {
    accountId: session.accountId,
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof PromoRefusedError)) throw error;
    const body = (statusCode: number) => ({
      statusCode,
      error: error.refusal,
      message: error.message,
    });
    switch (error.refusal) {
      case 'invalid_promo_code':
        throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
      case 'unknown_city':
      case 'unknown_promo_code':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'code_taken':
      case 'no_base_currency':
      case 'currency_changed':
        throw new ConflictException(body(HttpStatus.CONFLICT));
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException(body(HttpStatus.UNPROCESSABLE_ENTITY));
    }
  }
}
