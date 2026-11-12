import { Injectable, type OnModuleInit } from '@nestjs/common';
import { type AvailabilityChange, CaptainsService } from '../captains/index.js';
import { formatTime, NotificationTexts } from '../content/index.js';
import { PlatformBroadcasts } from './platform-broadcasts.js';
import { PushQueue } from './push-queue.js';

// CA §7.6, §14 #26, AP §10 (slice 2.13a): in the transaction of a change of
// the captain's availability, the captain's push with operations' reason
// for a force offline, or after unanswered offers (C3, CA §7.4, §14 #3;
// slice 2.15b) or for a hand-in grace (CA §14 #18; slice 2.17b), and a broadcast on the captain's own channel, so the
// open app reads its state again (the order events do not tell it that the
// online period ended).
@Injectable()
export class CaptainAvailabilityNotices implements OnModuleInit {
  constructor(
    private readonly captains: CaptainsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
    private readonly broadcasts: PlatformBroadcasts,
  ) {}

  onModuleInit(): void {
    this.captains.onAvailabilityChanged(async (tx, change) => {
      if (change.kind === 'forced_offline') {
        await this.pushes.enqueue(tx, [await this.forcedPush(tx, change)], change.at);
      }
      if (change.kind === 'offers_expired') {
        await this.pushes.enqueue(tx, [await this.unansweredPush(tx, change)], change.at);
      }
      if (change.kind === 'hand_in_grace') {
        await this.pushes.enqueue(tx, [await this.gracePush(tx, change)], change.at);
      }
      await this.broadcasts.enqueue(tx, {
        type: 'captain.availability_changed',
        cityId: change.cityId,
        captainId: change.captainId,
        at: change.at,
      });
    });
  }

  private async unansweredPush(
    tx: Parameters<Parameters<CaptainsService['onAvailabilityChanged']>[0]>[0],
    change: Extract<AvailabilityChange, { kind: 'offers_expired' }>,
  ) {
    const templateKey = 'captain.auto_offline';
    const rendered = await this.texts.render(templateKey, { العدد: String(change.count) }, tx);
    return {
      source: `captain:${templateKey}:${change.captainId}:${change.at.toISOString()}`,
      recipient: { party: 'captain' as const, captainId: change.captainId },
      templateKey,
      body: rendered.body,
      level: rendered.level,
      priority: rendered.priority,
      data: { type: 'captain.availability' },
      at: change.at,
    };
  }

  // CA §14 #18 (slice 2.17b): «مُنحت مهلة حتى {الساعة}», silent, once per
  // grace and captain.
  private async gracePush(
    tx: Parameters<Parameters<CaptainsService['onAvailabilityChanged']>[0]>[0],
    change: Extract<AvailabilityChange, { kind: 'hand_in_grace' }>,
  ) {
    const templateKey = 'captain.hand_in_grace';
    const rendered = await this.texts.render(
      templateKey,
      { الساعة: formatTime(change.until, change.timeZone) },
      tx,
    );
    return {
      source: `captain:${templateKey}:${change.graceId}:${change.captainId}`,
      recipient: { party: 'captain' as const, captainId: change.captainId },
      templateKey,
      body: rendered.body,
      level: rendered.level,
      priority: rendered.priority,
      data: { type: 'captain.availability' },
      at: change.at,
    };
  }

  private async forcedPush(
    tx: Parameters<Parameters<CaptainsService['onAvailabilityChanged']>[0]>[0],
    change: Extract<AvailabilityChange, { kind: 'forced_offline' }>,
  ) {
    const templateKey = change.atOnce ? 'captain.forced_offline' : 'captain.forced_last_order';
    const rendered = await this.texts.render(templateKey, { السبب: change.reason }, tx);
    return {
      source: `captain:${templateKey}:${change.captainId}:${change.at.toISOString()}`,
      recipient: { party: 'captain' as const, captainId: change.captainId },
      templateKey,
      body: rendered.body,
      level: rendered.level,
      priority: rendered.priority,
      data: { type: 'captain.availability' },
      at: change.at,
    };
  }
}
