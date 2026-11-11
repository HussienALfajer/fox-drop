import { ForbiddenException, Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { CaptainsService } from './captains.service.js';
import { PeakBonusService } from './peak-bonus.service.js';

const money = z.object({ amount: z.string().regex(/^\d+$/), currency: z.string().length(3) });
const zones = z
  .array(z.object({ id: z.uuid(), name: z.string() }))
  .describe('The zones of the restaurants it pays for; none: every zone.');

class CaptainPeakBonusDto extends createZodDto(
  z.object({
    windows: z
      .array(
        z.object({
          days: z.array(z.int().min(1).max(7)).describe('ISO days: 1 Monday to 7 Sunday.'),
          startMinute: z.int().describe('Minutes from midnight on the city clock.'),
          endMinute: z
            .int()
            .describe('Minutes from midnight; at or before the start it ends the next day.'),
          amount: money.describe('Per delivered order.'),
          zones,
        }),
      )
      .describe('The windows in force while the bonus is on (CA §12.5); empty while it is off.'),
    active: z
      .array(
        z.object({
          amount: money,
          until: z.iso.datetime(),
          zones,
        }),
      )
      .describe('«مكافأة الذروة الآن: +{المبلغ} لكل طلب حتى {الساعة}» on the home screen.'),
  }),
) {}

// CA §12.5 (AP §9.12.5, D15): the peak windows the captain sees, and those
// running now. The app reads it on opening the home screen and when a
// window it shows ends.
@CaptainController('peak-bonus')
export class CaptainPeakBonusController {
  constructor(
    private readonly captains: CaptainsService,
    private readonly peak: PeakBonusService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainPeakBonusDto })
  async peakBonus(@CurrentAppSession() session: AppSession) {
    if (session.captain === null) throw new ForbiddenException();
    const now = new Date();
    const captain = await this.captains.captain(session.captain.captainId, now);
    if (!captain) throw new ForbiddenException();
    const [{ inForce }, active] = await Promise.all([
      this.peak.state(captain.cityId, now),
      this.peak.activeNow(captain.cityId, now),
    ]);
    const windows = inForce?.enabled ? inForce.windows : [];
    const currency = inForce?.currency ?? '';
    return {
      windows: windows.map((window) => ({
        days: window.days,
        startMinute: window.startMinute,
        endMinute: window.endMinute,
        amount: { amount: window.amount.toString(), currency },
        zones: window.zones,
      })),
      active: active.map((window) => ({
        amount: { amount: window.amount.toString(), currency: window.currency },
        until: window.until.toISOString(),
        zones: window.zones,
      })),
    };
  }
}
