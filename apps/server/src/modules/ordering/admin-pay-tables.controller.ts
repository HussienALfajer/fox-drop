import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpStatus,
  NotFoundException,
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
import {
  CaptainsRefusedError,
  CaptainsService,
  checkPayRate,
  PAY_TABLE_NOTICE_DAYS,
  type PayParts,
  type PayRate,
  type PayTable,
  payTableStates,
  samplePay,
} from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { type AdminSession, AdminSessionsService } from '../identity/index.js';
import { SettingsService, type Vehicle, vehicles } from '../settings/index.js';

// The calculator's bounds, as «احسب أجري»'s (captains, slice 2.36c).
const PREVIEW_MAX_METRES = 100_000;
const PREVIEW_MAX_WAITED_MINUTES = 1_440;

const minor = z.string().regex(/^\d{1,18}$/);

const rateFields = {
  basePay: minor.describe('Pays the first includedMetres.'),
  includedMetres: z.int().min(0).max(1_000_000).describe('The distance the base pay includes.'),
  perExtraKm: minor.describe('Per km past the included distance, pro rata by the metre.'),
  waitingPerMinute: minor.describe('Per whole minute past captain.waiting_threshold_min.'),
  minimumPay: minor.describe('The order pay is raised to it.'),
};
const vehicleRate = z.object({ vehicle: z.enum(vehicles), ...rateFields });

const version = z.object({
  id: z.uuid(),
  state: z
    .enum(payTableStates)
    .describe(
      'in_force; announced: starts later; replaced: a later version with the same start took its place; ended.',
    ),
  currency: z.string().length(3),
  effectiveFrom: z.iso.datetime(),
  rates: z.array(vehicleRate).describe('One per vehicle, in the catalogue order.'),
  editorName: z.string().nullable().describe('Null for the system or an unknown admin.'),
  reason: z.string().nullable(),
  createdAt: z.iso.datetime(),
});

class AdminPayTablesQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminPayTablesDto extends createZodDto(
  z.object({
    baseCurrency: z
      .string()
      .length(3)
      .nullable()
      .describe('The amounts are typed in it; null while the city has none.'),
    waitingThresholdMin: z.int().describe('captain.waiting_threshold_min'),
    noticeDays: z.int().describe('A change takes effect this many days after it is published.'),
    earliestStart: z.iso
      .datetime()
      .describe('The earliest start of a version published now: now for the first.'),
    maxDistanceKm: z
      .array(z.object({ vehicle: z.enum(vehicles), km: z.number() }))
      .describe('The setting dispatch.max_distance_km of each vehicle, changed at once.'),
    versions: z.array(version).describe('Newest first, the latest 50.'),
  }),
) {}

class AdminPublishPayTableDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    currency: z.string().regex(/^[A-Z]{3}$/),
    effectiveFrom: z.iso.datetime(),
    rates: z.array(vehicleRate).length(vehicles.length).describe('One per vehicle.'),
    reason: z.string().trim().min(1).max(300),
  }),
) {}

// An empty value is no number (z.coerce alone would read it as 0).
const whole = (max: number) =>
  z.preprocess(
    (value) => (value === '' ? undefined : value),
    z.coerce.number().int().min(0).max(max),
  );
const optionalMinor = minor.optional();

class AdminPayTablePreviewQueryDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    vehicle: z.enum(vehicles),
    metres: whole(PREVIEW_MAX_METRES),
    waitedMinutes: whole(PREVIEW_MAX_WAITED_MINUTES)
      .default(0)
      .describe('Minutes waited at the restaurant; those past the threshold are paid.'),
    // The table being typed, all five or none.
    draftBasePay: optionalMinor,
    draftIncludedMetres: whole(1_000_000).optional(),
    draftPerExtraKm: optionalMinor,
    draftWaitingPerMinute: optionalMinor,
    draftMinimumPay: optionalMinor,
  }),
) {}

const money = z.object({ amount: minor, currency: z.string().length(3) });
const parts = z.object({
  base: money,
  distance: money,
  // «إكمال للحد الأدنى».
  topUp: money,
  orderPay: money,
  waiting: money,
  total: money.describe('The order pay and the waiting pay.'),
});

class AdminPayTablePreviewDto extends createZodDto(
  z.object({
    waitingThresholdMin: z.int(),
    inForce: parts
      .extend({ effectiveFrom: z.iso.datetime() })
      .nullable()
      .describe('By the version in force; null without one.'),
    announced: z
      .array(parts.extend({ effectiveFrom: z.iso.datetime() }))
      .describe('By each version announced, soonest first.'),
    draft: parts.nullable().describe('By the rate typed; null without one or without a base.'),
  }),
) {}

// AP §9.12.5 «أجور الكباتن» (slice 2.37b): the city's pay table versions,
// publishing a new one (effective 7 days or more later; captains, which
// announce it), and the preview calculator for a sample trip. Read with
// zones.read (OWN, OPS, FIN; AP §6.2), published with pricing.edit_pay_tables
// (OWN, AP §6.3). The maximum distance per vehicle is the setting
// dispatch.max_distance_km.<vehicle>, changed at once through the settings
// routes (owner decision 2026-11-19). Here, not in captains, since the
// editors' names are identity's, which imports captains.
@AdminController('pay-tables')
export class AdminPayTablesController {
  constructor(
    private readonly captains: CaptainsService,
    private readonly geo: GeoService,
    private readonly fx: FxService,
    private readonly settings: SettingsService,
    private readonly sessions: AdminSessionsService,
  ) {}

  // 404 unknown_city.
  @Get()
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminPayTablesDto })
  async screen(@Query() query: AdminPayTablesQueryDto) {
    const { cityId } = query;
    await this.knownCity(cityId);
    const now = new Date();
    const [baseCurrency, waitingThresholdMin, versions, maxDistanceKm, earliest] =
      await Promise.all([
        this.fx.baseCurrency(cityId),
        this.settings.get('captain.waiting_threshold_min', { cityId }),
        this.captains.payTableVersions(cityId, now),
        Promise.all(
          vehicles.map(async (vehicle) => ({
            vehicle,
            km: await this.settings.get(`dispatch.max_distance_km.${vehicle}`, { cityId }),
          })),
        ),
        this.captains.earliestPayTableStart(cityId),
      ]);
    const names = await this.sessions.names(
      versions.flatMap((entry) => (entry.editorId === null ? [] : [entry.editorId])),
    );
    return {
      baseCurrency,
      waitingThresholdMin,
      noticeDays: PAY_TABLE_NOTICE_DAYS,
      earliestStart: earliest.toISOString(),
      maxDistanceKm,
      versions: versions.map((entry) => ({
        id: entry.id,
        state: entry.state,
        currency: entry.currency,
        effectiveFrom: entry.effectiveFrom.toISOString(),
        rates: vehicles.map((vehicle) => ({ vehicle, ...rateView(entry.rates[vehicle]) })),
        editorName: entry.editorId === null ? null : (names.get(entry.editorId) ?? null),
        reason: entry.reason,
        createdAt: entry.createdAt.toISOString(),
      })),
    };
  }

  // A repeat of the newest version at the same start answers it, so no
  // Idempotency-Key. 400 invalid_pay_table, reason_required; 409
  // not_in_base_currency; 404 unknown_city.
  @Put()
  @RequirePermission('pricing.edit_pay_tables')
  @ZodResponse({ status: 200, type: AdminPayTablesDto })
  async publish(
    @Body() body: AdminPublishPayTableDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await this.knownCity(body.cityId);
    const rates = Object.fromEntries(
      body.rates.map((entry) => [entry.vehicle, rateOf(entry)]),
    ) as Record<Vehicle, PayRate>;
    if (Object.keys(rates).length !== vehicles.length) {
      throw new BadRequestException({
        statusCode: HttpStatus.BAD_REQUEST,
        error: 'invalid_pay_table',
        message: 'one rate per vehicle',
      });
    }
    await refusals(() =>
      this.captains.setPayTable(
        body.cityId,
        { currency: body.currency, rates, effectiveFrom: new Date(body.effectiveFrom) },
        {
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
          reason: body.reason,
        },
      ),
    );
    return this.screen({ cityId: body.cityId });
  }

  // The pay of a sample trip by the version in force, each announced one and
  // the rate typed (AP §9.12.5 preview calculator). 400 invalid_pay_table
  // for a draft given in part or out of bounds; 404 unknown_city.
  @Get('preview')
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminPayTablePreviewDto })
  async preview(@Query() query: AdminPayTablePreviewQueryDto) {
    await this.knownCity(query.cityId);
    const draft = draftOf(query);
    const now = new Date();
    const [current, announced, thresholdMin, baseCurrency] = await Promise.all([
      this.captains.payTable(query.cityId, now),
      this.captains.announcedPayTables(query.cityId, now),
      this.settings.get('captain.waiting_threshold_min', { cityId: query.cityId }),
      this.fx.baseCurrency(query.cityId),
    ]);
    const trip = { metres: query.metres, waitedMinutes: query.waitedMinutes, thresholdMin };
    const by = (table: PayTable) => ({
      effectiveFrom: table.effectiveFrom.toISOString(),
      ...partsView(samplePay(table.rates[query.vehicle], trip), table.currency),
    });
    return {
      waitingThresholdMin: thresholdMin,
      inForce: current && by(current),
      announced: announced.map(by),
      draft:
        draft === null || baseCurrency === null
          ? null
          : partsView(samplePay(draft, trip), baseCurrency),
    };
  }

  private async knownCity(cityId: string): Promise<void> {
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
  }
}

function rateOf(entry: z.infer<typeof vehicleRate>): PayRate {
  return {
    basePay: BigInt(entry.basePay),
    includedMetres: entry.includedMetres,
    perExtraKm: BigInt(entry.perExtraKm),
    waitingPerMinute: BigInt(entry.waitingPerMinute),
    minimumPay: BigInt(entry.minimumPay),
  };
}

function rateView(rate: PayRate) {
  return {
    basePay: rate.basePay.toString(),
    includedMetres: rate.includedMetres,
    perExtraKm: rate.perExtraKm.toString(),
    waitingPerMinute: rate.waitingPerMinute.toString(),
    minimumPay: rate.minimumPay.toString(),
  };
}

// The rate typed, null when none of its fields is, invalid_pay_table when
// only some are.
function draftOf(query: AdminPayTablePreviewQueryDto): PayRate | null {
  const fields = [
    query.draftBasePay,
    query.draftIncludedMetres,
    query.draftPerExtraKm,
    query.draftWaitingPerMinute,
    query.draftMinimumPay,
  ];
  if (fields.every((field) => field === undefined)) return null;
  if (fields.some((field) => field === undefined)) {
    throw new BadRequestException({
      statusCode: HttpStatus.BAD_REQUEST,
      error: 'invalid_pay_table',
      message: 'a draft rate has all its fields',
    });
  }
  const rate = rateOf({
    vehicle: query.vehicle,
    basePay: query.draftBasePay!,
    includedMetres: query.draftIncludedMetres!,
    perExtraKm: query.draftPerExtraKm!,
    waitingPerMinute: query.draftWaitingPerMinute!,
    minimumPay: query.draftMinimumPay!,
  });
  const problem = checkPayRate(rate);
  if (problem !== null) {
    throw new BadRequestException({
      statusCode: HttpStatus.BAD_REQUEST,
      error: 'invalid_pay_table',
      message: problem,
    });
  }
  return rate;
}

function partsView(pay: PayParts, currency: string) {
  const of = (amount: bigint) => ({ amount: amount.toString(), currency });
  return {
    base: of(pay.base),
    distance: of(pay.distance),
    topUp: of(pay.topUp),
    orderPay: of(pay.orderPay),
    waiting: of(pay.waiting),
    total: of(pay.orderPay + pay.waiting),
  };
}

// Captains' refusals as the routes answer them.
async function refusals<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (
      error instanceof CaptainsRefusedError &&
      (error.refusal === 'invalid_pay_table' || error.refusal === 'reason_required')
    ) {
      throw new BadRequestException({
        statusCode: HttpStatus.BAD_REQUEST,
        error: error.refusal,
        message: error.message,
      });
    }
    if (error instanceof CaptainsRefusedError && error.refusal === 'not_in_base_currency') {
      throw new ConflictException({
        statusCode: HttpStatus.CONFLICT,
        error: error.refusal,
        message: error.message,
      });
    }
    throw error;
  }
}
