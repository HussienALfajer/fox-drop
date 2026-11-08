import { Injectable, type OnModuleInit } from '@nestjs/common';
import { SettingsService } from '../settings/index.js';
import type { Database } from '../../database/database.js';
import { type broadcastApps, platformOutbox } from './schema.js';

export type BroadcastApp = (typeof broadcastApps)[number];

// RA §18, CA §15, AP §7: what a platform broadcast says. Each is a fact the
// app reads again in full (the stop, or GET /platform), so a missed one is
// never the only copy.
export type PlatformBroadcast =
  // AP §9.1.6: a city's emergency stop started or ended.
  | { type: 'platform.emergency_stop'; cityId: string; active: boolean; at: Date }
  // 2.4a: an app's maintenance, its messages or its versions changed.
  | { type: 'platform.app_changed'; app: BroadcastApp; at: Date };

type Executor = Pick<Database['db'], 'insert'>;

// Writes a platform broadcast in the transaction of its change (E4); the
// worker's PlatformRelay publishes it.
@Injectable()
export class PlatformBroadcasts {
  async enqueue(executor: Executor, broadcast: PlatformBroadcast): Promise<void> {
    if (broadcast.type === 'platform.emergency_stop') {
      await executor.insert(platformOutbox).values({
        createdAt: broadcast.at,
        cityId: broadcast.cityId,
        type: broadcast.type,
        apps: ['merchant', 'captain'],
        // The panel's red bar (AP §7).
        ops: true,
        payload: { schema: 1, active: broadcast.active, at: broadcast.at.toISOString() },
      });
      return;
    }
    await executor.insert(platformOutbox).values({
      createdAt: broadcast.at,
      cityId: null,
      type: broadcast.type,
      apps: [broadcast.app],
      ops: false,
      payload: { schema: 1, app: broadcast.app, at: broadcast.at.toISOString() },
    });
  }
}

// 2.4a: what GET /v1/{app}/platform answers. A change of one, for the
// restaurant or the captain app, is broadcast to that app's open devices,
// which read the platform again (RA §18, CA §15). The customer app has no
// channel of its own yet: it reads it on opening.
const APP_SETTINGS = new Set([
  'app.<app>.min_version',
  'app.<app>.latest_version',
  'app.<app>.update_message',
  'app.<app>.maintenance',
]);

@Injectable()
export class AppChangeBroadcasts implements OnModuleInit {
  constructor(
    private readonly settings: SettingsService,
    private readonly broadcasts: PlatformBroadcasts,
  ) {}

  onModuleInit(): void {
    this.settings.onChanged(async (tx, changed, now) => {
      if (!APP_SETTINGS.has(changed.template)) return;
      const app = changed.key.split('.')[1];
      if (app !== 'merchant' && app !== 'captain') return;
      await this.broadcasts.enqueue(tx, { type: 'platform.app_changed', app, at: now });
    });
  }
}
