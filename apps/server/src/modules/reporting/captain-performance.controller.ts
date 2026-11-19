import { ForbiddenException, Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import { CaptainsService, ViolationsService, violationSteps } from '../captains/index.js';
import { EarningsService } from '../cashdesk/index.js';
import { acceptanceRate, DispatchService, rateBelow } from '../dispatch/index.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { CaptainFiguresService } from '../ordering/index.js';
import { SettingsService } from '../settings/index.js';

const step = z.enum(violationSteps);

class CaptainPerformanceDto extends createZodDto(
  z.object({
    acceptance: z.object({
      rate: z.int().nullable().describe('Whole percent; null without an answered offer.'),
      accepted: z.int(),
      answered: z.int(),
      windowOffers: z.int().describe('captain.acceptance_window_offers'),
      warn: z.boolean().describe('Below captain.acceptance_alert_pct: the app warns.'),
      alertPct: z.int(),
      offers: z
        .array(
          z.object({
            offeredAt: z.iso.datetime(),
            restaurantName: z.string().nullable(),
            response: z.enum(['accepted', 'declined', 'expired']),
          }),
        )
        .describe('The answered offers counted, newest first.'),
    }),
    onTime: z
      .object({ onTime: z.int(), counted: z.int() })
      .describe('Of the last 50 delivered: those at or before the promised time.'),
    cancellations: z.int().describe('Captain cancellations within the window.'),
    windowDays: z.int().describe('captain.violation_window_days'),
    online: z.object({
      todayMinutes: z.int(),
      weekMinutes: z.int().describe('The payout week.'),
    }),
    violations: z
      .array(
        z.object({
          id: z.uuid(),
          recordedAt: z.iso.datetime(),
          type: z.string().describe('The type as chosen, with the text of «أخرى».'),
          step,
          orderNumber: z.string().nullable(),
          suspendedUntil: z.iso.datetime().nullable(),
          appeal: z
            .object({
              ticketId: z.uuid(),
              outcome: z.enum(['accepted', 'rejected']).nullable(),
            })
            .nullable()
            .describe('«اعتراض»; an accepted one voids the violation.'),
        }),
      )
      .describe('Newest first.'),
  }),
) {}

// CA §11.1–11.3 «أدائي» (slice 2.36b): the acceptance rate with the offers
// it counts and the warning below captain.acceptance_alert_pct, the on-time
// rate, the cancellations within captain.violation_window_days, online
// hours today and this week, and the violations with their appeals. The
// rating is `GET /v1/captain/ratings` (C14).
@CaptainController()
export class CaptainPerformanceController {
  constructor(
    private readonly captains: CaptainsService,
    private readonly dispatch: DispatchService,
    private readonly figures: CaptainFiguresService,
    private readonly earnings: EarningsService,
    private readonly violations: ViolationsService,
    private readonly merchants: MerchantsService,
    private readonly settings: SettingsService,
  ) {}

  @Get('performance')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainPerformanceDto })
  async read(@CurrentAppSession() session: AppSession) {
    if (session.captain === null) throw new ForbiddenException();
    const { captainId } = session.captain;
    const now = new Date();
    const captain = await this.captains.captain(captainId, now);
    if (captain === null) throw new ForbiddenException();
    const { cityId } = captain;
    const [window, alertPct, windowDays] = await Promise.all([
      this.settings.get('captain.acceptance_window_offers', { cityId }),
      this.settings.get('captain.acceptance_alert_pct', { cityId }),
      this.settings.get('captain.violation_window_days', { cityId }),
    ]);
    const [counts, latest, figures, earnings, violations] = await Promise.all([
      this.dispatch.acceptance([captainId], window),
      this.dispatch.answeredOffers(captainId, window),
      this.figures.ofCaptains(cityId, [captainId], now),
      this.earnings.earnings(captainId, now),
      this.violations.list(captainId),
    ]);
    const answered = latest.filter(
      (offer): offer is typeof offer & { status: 'accepted' | 'declined' | 'expired' } =>
        offer.status === 'accepted' || offer.status === 'declined' || offer.status === 'expired',
    );
    const restaurants = await this.figures.orderRestaurants(answered.map((offer) => offer.orderId));
    const names = await this.merchants.names([...new Set(restaurants.values())]);
    const count = counts.get(captainId);
    const rate = acceptanceRate(count);
    const own = figures.get(captainId)!;
    return {
      acceptance: {
        rate,
        accepted: count?.accepted ?? 0,
        answered: count?.answered ?? 0,
        windowOffers: window,
        warn: rateBelow(count, alertPct),
        alertPct,
        offers: answered.map((offer) => {
          const restaurantId = restaurants.get(offer.orderId);
          return {
            offeredAt: offer.offeredAt.toISOString(),
            restaurantName:
              restaurantId === undefined ? null : (names.get(restaurantId)?.nameAr ?? null),
            response: offer.status,
          };
        }),
      },
      onTime: own.onTime,
      cancellations: own.cancellations,
      windowDays,
      online: {
        todayMinutes: earnings.today.onlineMinutes,
        weekMinutes: earnings.week.onlineMinutes,
      },
      violations: violations.map((row) => ({
        id: row.id,
        recordedAt: row.recordedAt.toISOString(),
        type: row.typeNote === null ? row.typeLabel : `${row.typeLabel}: ${row.typeNote}`,
        step: row.step,
        orderNumber: row.orderNumber?.toString() ?? null,
        suspendedUntil: row.suspendedUntil?.toISOString() ?? null,
        appeal:
          row.appealTicketId === null
            ? null
            : { ticketId: row.appealTicketId, outcome: row.appealOutcome },
      })),
    };
  }
}
