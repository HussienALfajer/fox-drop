import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationShutdown,
  type OnModuleInit,
} from '@nestjs/common';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportError } from '../../observability/error-tracking.js';
import { CaptainsService } from '../captains/index.js';
import { formatMoney, formatTime, NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, lastCutoff } from '../geo/index.js';
import { PushQueue, type QueuedPush } from './push-queue.js';

// How often the worker sweeps each city's captains: a warning reaches the
// captain within this of usage rising past it.
export const CASH_NOTICES_MS = 30_000;
// CA §10.3: the hand-in reminder at 22:00 city time (fixed), still sent by a
// worker back within this.
export const HAND_IN_REMINDER_MINUTES = 22 * 60;
export const HAND_IN_REMINDER_CATCH_UP_MS = 10 * 60_000;

// The captain's cash pushes (slice 2.17d), each city on its own:
// - CA §10.4, §14 #15: the cash limit warning, through
//   CaptainsService.sweepCustodyWarnings (its push is queued by
//   CaptainAvailabilityNotices in the warning's transaction);
// - CA §10.3, §14 #16: at 22:00, to each captain holding cash collected
//   today above the tolerance while the office is open, «عليك تسليم {المبلغ}
//   اليوم. المكتب مفتوح حتى {الساعة}.», once a day;
// - CA §10.3, §14 #17: to a captain online across the cutoff with cash due,
//   «سلّم نقد أمس قبل {الساعة} لتستمر العروض», once per cutoff, while the
//   offers still continue.
@Injectable()
export class CaptainCashNotices {
  private readonly logger = new Logger('CaptainCashNotices');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly captains: CaptainsService,
    private readonly geo: GeoService,
    private readonly fx: FxService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  async run(now: Date): Promise<void> {
    for (const city of await this.geo.activeCities()) {
      // A failure of one never holds back the other.
      for (const [step, work] of [
        ['custody warnings', () => this.captains.sweepCustodyWarnings(city.id, now)],
        ['hand-in reminders', () => this.remind(city, now)],
      ] as const) {
        try {
          await work();
        } catch (error) {
          this.logger.error({ err: error, cityId: city.id, step }, 'captain cash notices failed');
          reportError(error);
        }
      }
    }
  }

  private async remind(city: { id: string; timeZone: string }, now: Date): Promise<void> {
    const reminderAt = lastCutoff(now, HAND_IN_REMINDER_MINUTES, city.timeZone);
    const evening = now.getTime() - reminderAt.getTime() <= HAND_IN_REMINDER_CATCH_UP_MS;
    const reminders = await this.captains.cashReminders(city.id, now, { evening });
    if (reminders.length === 0) return;
    const office = evening ? await this.geo.office(city.id, now) : null;
    const closesAt = office?.open ? office.closesAt : null;
    const pushes: QueuedPush[] = [];
    let known: Map<string, { symbol: string; decimals: number }> | undefined;
    for (const reminder of reminders) {
      if (closesAt !== null && reminder.heldToday && reminder.handIn !== null) {
        known ??= new Map(
          (await this.fx.currencies()).map((currency) => [
            currency.code,
            { symbol: currency.symbol, decimals: currency.decimals },
          ]),
        );
        const templateKey = 'captain.hand_in_reminder';
        const rendered = await this.texts.render(templateKey, {
          المبلغ: formatMoney(reminder.handIn.amount, reminder.handIn.currency, known),
          الساعة: formatTime(closesAt, city.timeZone),
        });
        pushes.push({
          source: `captain:${templateKey}:${reminder.captainId}:${reminderAt.toISOString()}`,
          recipient: { party: 'captain', captainId: reminder.captainId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: { target: 'custody' },
          at: reminderAt,
          expiresAt: closesAt,
        });
      }
      if (reminder.remitBy !== null) {
        const templateKey = 'captain.cutoff_passed';
        const rendered = await this.texts.render(templateKey, {
          الساعة: formatTime(reminder.remitBy, city.timeZone),
        });
        pushes.push({
          source: `captain:${templateKey}:${reminder.captainId}:${reminder.remitBy.toISOString()}`,
          recipient: { party: 'captain', captainId: reminder.captainId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: { target: 'custody' },
          at: now,
          expiresAt: reminder.remitBy,
        });
      }
    }
    if (pushes.length > 0) await this.pushes.enqueue(this.database.db, pushes, now);
  }
}

// The worker's loop of the cash notices.
@Injectable()
export class CaptainCashNoticesWorker implements OnModuleInit, OnApplicationShutdown {
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;

  constructor(private readonly notices: CaptainCashNotices) {}

  onModuleInit(): void {
    this.timer = setInterval(() => {
      // A slow run is never overlapped by the next.
      this.running ??= this.notices.run(new Date()).finally(() => {
        this.running = undefined;
      });
    }, CASH_NOTICES_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
