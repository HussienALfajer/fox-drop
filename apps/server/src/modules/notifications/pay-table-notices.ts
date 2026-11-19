import { Injectable, type OnModuleInit } from '@nestjs/common';
import { CaptainsService, type PayTableAnnounced } from '../captains/index.js';
import { formatDay, formatTime, NotificationTexts } from '../content/index.js';
import { CAPTAIN_NOTICE_TTL_MS, PushQueue } from './push-queue.js';

type PayTableTx = Parameters<Parameters<CaptainsService['onPayTableAnnounced']>[0]>[0];

// The start as the push names it: «الخميس 26/11/2026 الساعة 2:30 م» on the
// city's clock (owner decision 2026-11-19: the day, the date and the time).
export function payTableStart(effectiveFrom: Date, timeZone: string): string {
  return `${formatDay(effectiveFrom, timeZone)} الساعة ${formatTime(effectiveFrom, timeZone)}`;
}

// CA §12.5, §14 #22, AP §9.12.5, §10 (slice 2.37b): a pay table published to
// start later is announced to every active captain of the city, silently,
// in the publishing transaction (E4); a tap opens «ملفي», which shows it.
@Injectable()
export class PayTableNotices implements OnModuleInit {
  constructor(
    private readonly captains: CaptainsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  onModuleInit(): void {
    this.captains.onPayTableAnnounced((tx, announced) => this.announce(tx, announced));
  }

  async announce(tx: PayTableTx, announced: PayTableAnnounced): Promise<void> {
    if (announced.captainIds.length === 0) return;
    const templateKey = 'captain.pay_table_change';
    const rendered = await this.texts.render(
      templateKey,
      { التاريخ: payTableStart(announced.effectiveFrom, announced.timeZone) },
      tx,
    );
    await this.pushes.enqueue(
      tx,
      announced.captainIds.map((captainId) => ({
        source: `captain:${templateKey}:${announced.tableId}:${captainId}`,
        recipient: { party: 'captain' as const, captainId },
        templateKey,
        body: rendered.body,
        level: rendered.level,
        priority: rendered.priority,
        data: { target: 'pay_table' },
        at: announced.at,
        expiresAt: new Date(announced.at.getTime() + CAPTAIN_NOTICE_TTL_MS),
      })),
      announced.at,
    );
  }
}
