import { ForbiddenException, Get, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { SettingsService, vehicles } from '../settings/index.js';
import { CaptainsService, type PayTable } from './captains.service.js';
import { type PayParts, samplePay } from './pay.js';

// «احسب أجري» takes a trip of 100 km at most and a wait of 24 hours at most
// (decided by us: the bounds of a sample, not of dispatch).
export const SAMPLE_MAX_METRES = 100_000;
export const SAMPLE_MAX_WAITED_MINUTES = 1_440;

// Named, so the generated clients keep one model for it apart from the
// other routes' inline amounts.
const money = z
  .object({ amount: z.string().regex(/^\d+$/), currency: z.string().length(3) })
  .meta({ id: 'CaptainPayMoney' });

const rate = z.object({
  effectiveFrom: z.iso.datetime(),
  basePay: money,
  includedMetres: z.int().describe('The distance the base pay includes.'),
  // Per km past the included distance, pro rata by the metre.
  perExtraKm: money,
  // Per whole minute past waitingThresholdMin.
  waitingPerMinute: money,
  minimumPay: money,
});

class CaptainPayTableDto extends createZodDto(
  z.object({
    vehicle: z.enum(vehicles),
    waitingThresholdMin: z.int().describe('captain.waiting_threshold_min'),
    current: rate.nullable().describe("The table in force for the captain's vehicle."),
    announced: z
      .array(rate)
      .describe('The tables published to start later, soonest first (AP §9.12.5: 7 days ahead).'),
  }),
) {}

const parts = z.object({
  base: money,
  distance: money,
  // «إكمال للحد الأدنى».
  topUp: money,
  // Base, distance and top-up.
  orderPay: money,
  waiting: money,
  // The order pay and the waiting pay.
  total: money,
});

class CaptainPayCalculationQueryDto extends createZodDto(
  z.object({
    metres: z.coerce.number().int().min(0).max(SAMPLE_MAX_METRES),
    waitedMinutes: z.coerce
      .number()
      .int()
      .min(0)
      .max(SAMPLE_MAX_WAITED_MINUTES)
      .default(0)
      .describe('Minutes waited at the restaurant; those past the threshold are paid.'),
  }),
) {}

class CaptainPayCalculationDto extends createZodDto(
  z.object({
    current: parts.nullable(),
    announced: z.array(parts.extend({ effectiveFrom: z.iso.datetime() })),
  }),
) {}

// CA §12.5 (slice 2.36c): the pay table for the captain's vehicle, the one in
// force and those announced, and «احسب أجري» by each of them.
@CaptainController('pay-table')
export class CaptainPayTableController {
  constructor(
    private readonly captains: CaptainsService,
    private readonly settings: SettingsService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainPayTableDto })
  async payTable(@CurrentAppSession() session: AppSession) {
    const { captain, current, announced, thresholdMin } = await this.tables(session);
    const view = (table: PayTable) => {
      const row = table.rates[captain.vehicle];
      const of = (amount: bigint) => ({ amount: amount.toString(), currency: table.currency });
      return {
        effectiveFrom: table.effectiveFrom.toISOString(),
        basePay: of(row.basePay),
        includedMetres: row.includedMetres,
        perExtraKm: of(row.perExtraKm),
        waitingPerMinute: of(row.waitingPerMinute),
        minimumPay: of(row.minimumPay),
      };
    };
    return {
      vehicle: captain.vehicle,
      waitingThresholdMin: thresholdMin,
      current: current && view(current),
      announced: announced.map(view),
    };
  }

  @Get('calculate')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainPayCalculationDto })
  async calculate(
    @CurrentAppSession() session: AppSession,
    @Query() query: CaptainPayCalculationQueryDto,
  ) {
    const { captain, current, announced, thresholdMin } = await this.tables(session);
    const view = (table: PayTable) => {
      const pay: PayParts = samplePay(table.rates[captain.vehicle], {
        metres: query.metres,
        waitedMinutes: query.waitedMinutes,
        thresholdMin,
      });
      const of = (amount: bigint) => ({ amount: amount.toString(), currency: table.currency });
      return {
        base: of(pay.base),
        distance: of(pay.distance),
        topUp: of(pay.topUp),
        orderPay: of(pay.orderPay),
        waiting: of(pay.waiting),
        total: of(pay.orderPay + pay.waiting),
      };
    };
    return {
      current: current && view(current),
      announced: announced.map((table) => ({
        effectiveFrom: table.effectiveFrom.toISOString(),
        ...view(table),
      })),
    };
  }

  private async tables(session: AppSession) {
    if (session.captain === null) throw new ForbiddenException();
    const now = new Date();
    const captain = await this.captains.captain(session.captain.captainId, now);
    if (!captain) throw new ForbiddenException();
    const [current, announced, thresholdMin] = await Promise.all([
      this.captains.payTable(captain.cityId, now),
      this.captains.announcedPayTables(captain.cityId, now),
      this.settings.get('captain.waiting_threshold_min', { cityId: captain.cityId }),
    ]);
    return { captain, current, announced, thresholdMin };
  }
}
