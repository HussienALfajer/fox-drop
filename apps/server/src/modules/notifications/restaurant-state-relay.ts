import {
  Inject,
  Injectable,
  Logger,
  type OnModuleDestroy,
  type OnModuleInit,
} from '@nestjs/common';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import { NotificationTexts } from '../content/index.js';
import {
  type RelayedStateChange,
  RestaurantStatusService,
  type StateKind,
} from '../merchants/index.js';
import { merchantChannel, opsChannel } from './channels.js';
import { PushQueue } from './push-queue.js';
import { RealtimePublisher } from './realtime-publisher.js';

// A run even without a change, so rows left by runs that gave up wait at most
// this long.
const BACKSTOP_MS = 60_000;

// RA §16: the push a restaurant state change sends to every device of the
// restaurant, with its template's values; null for none.
export function restaurantStatePush(
  kind: StateKind,
  values: RelayedStateChange['values'],
): { templateKey: string; values: Record<string, string> } | null {
  switch (kind) {
    // #3: «أُوقف مطعمك تلقائياً بعد {العدد} طلبات دون رد…»
    case 'auto_paused':
      return { templateKey: 'merchant.auto_paused', values: { العدد: String(values.count) } };
    // #24: only when the restaurant takes orders again.
    case 'pause_ended':
      return values.push === true ? { templateKey: 'merchant.pause_ended', values: {} } : null;
    // #25: «وضع الضغط ما زال مفعّلاً (+{د} د)»
    case 'busy_reminder':
      return { templateKey: 'merchant.busy_reminder', values: { د: String(values.extraMin) } };
    default:
      return null;
  }
}

// RA §18 «restaurant state changed», E4: publishes each committed change of
// a restaurant's state to its devices and to the city's operations channel
// (the panel's restaurants, AP §9.1), and queues its push. Every device reads
// its status again on the event, so a lost one is never the only copy.
@Injectable()
export class RestaurantStateRelay {
  private readonly logger = new Logger('RestaurantStateRelay');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly status: RestaurantStatusService,
    private readonly publisher: RealtimePublisher,
    private readonly queue: PushQueue,
    private readonly texts: NotificationTexts,
  ) {}

  async drain(now: Date): Promise<number> {
    return this.status.relayStateChanges(async (change) => {
      const push = restaurantStatePush(change.kind, change.values);
      if (push !== null) {
        const rendered = await this.texts.render(push.templateKey, push.values);
        // A repeat of the same source adds nothing, so a row relayed again
        // pushes once.
        await this.queue.enqueue(
          this.database.db,
          [
            {
              source: `merchants-state:${change.id}:${push.templateKey}`,
              recipient: { party: 'merchant', restaurantId: change.restaurantId, owners: false },
              templateKey: push.templateKey,
              body: rendered.body,
              level: rendered.level,
              priority: rendered.priority,
              data: { restaurantId: change.restaurantId, kind: change.kind },
              at: change.at,
            },
          ],
          now,
        );
      }
      if (!this.publisher.enabled) return;
      await this.publisher.broadcast(
        [merchantChannel(change.restaurantId), opsChannel(change.cityId)],
        {
          type: 'restaurant.state_changed',
          schema: 1,
          restaurantId: change.restaurantId,
          kind: change.kind,
          // What its notice says, as its push: the count, the minutes.
          values: change.values,
          at: change.at.toISOString(),
        },
        `merchants-state:${change.id}`,
      );
      this.logger.debug({ restaurantId: change.restaurantId, kind: change.kind }, 'relayed');
    }, now);
  }
}

// The worker's relay: every change sends a job in its transaction, so a run
// starts as soon as it commits; one run at start and one a minute take the
// rows runs left.
@Injectable()
export class RestaurantStateRelayWorker implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger('RestaurantStateRelay');
  private backstop: NodeJS.Timeout | undefined;

  constructor(
    private readonly jobs: Jobs,
    private readonly relay: RestaurantStateRelay,
  ) {}

  async onModuleInit(): Promise<void> {
    await this.jobs.work(
      QUEUES.restaurantStateRelay,
      async () => {
        try {
          await this.relay.drain(new Date());
        } catch (error) {
          this.logger.error({ err: error }, 'restaurant state relay failed');
          reportError(error);
          throw error;
        }
      },
      { pollingIntervalSeconds: 0.5, batchSize: 50 },
    );
    const run = () =>
      this.jobs.send(QUEUES.restaurantStateRelay, {}, {}).catch((error: unknown) => {
        this.logger.error({ err: error }, 'could not start a restaurant state relay run');
      });
    await run();
    this.backstop = setInterval(() => void run(), BACKSTOP_MS);
  }

  onModuleDestroy(): void {
    clearInterval(this.backstop);
  }
}
