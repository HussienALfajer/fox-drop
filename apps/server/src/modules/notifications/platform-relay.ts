import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationShutdown,
  type OnModuleInit,
} from '@nestjs/common';
import { and, asc, inArray, isNull, notInArray } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportError } from '../../observability/error-tracking.js';
import { CaptainsService } from '../captains/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { captainChannel, merchantChannel, opsChannel, orderChannel } from './channels.js';
import { requireRealtime } from './realtime-config.js';
import { PublishFailedError, RealtimePublisher } from './realtime-publisher.js';
import { platformOutbox } from './schema.js';

// Rows taken per transaction, which holds their locks while it publishes.
const BATCH = 20;

// Channels per Centrifugo broadcast call: a city's restaurants and captains
// in a few calls.
const CHANNELS_PER_CALL = 500;

// How often the worker looks for platform broadcasts, as for alert changes.
export const PLATFORM_RELAY_MS = 1000;

// E4: publishes the committed platform broadcasts (platform-broadcasts.ts) to
// every restaurant's and captain's channel of the city (RA §18, CA §15), and
// to the panel's ops channel (AP §7), as the alerts relay does: unpublished
// rows in id order, locked and skipping those another run holds. A row of no
// city (an app's maintenance or version) goes to every active city. Each call
// carries its own idempotency key, so a run repeated after a lost answer
// sends each once.
@Injectable()
export class PlatformRelay {
  private readonly logger = new Logger('PlatformRelay');
  private readonly reported = new Set<bigint>();

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly publisher: RealtimePublisher,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
  ) {}

  // The count published; throws when any row was left.
  async drain(now: Date): Promise<number> {
    let published = 0;
    const refused: bigint[] = [];
    let failure: PublishFailedError | undefined;
    for (;;) {
      const batch = await this.database.db.transaction(async (tx) => {
        const rows = await tx
          .select()
          .from(platformOutbox)
          .where(
            and(
              isNull(platformOutbox.publishedAt),
              refused.length > 0 ? notInArray(platformOutbox.id, refused) : undefined,
            ),
          )
          .orderBy(asc(platformOutbox.id))
          .limit(BATCH)
          .for('update', { skipLocked: true });
        const done: bigint[] = [];
        for (const row of rows) {
          try {
            const channels = await this.channels(row);
            const data = { type: row.type, ...(row.payload as object) };
            for (let start = 0; start < channels.length; start += CHANNELS_PER_CALL) {
              await this.publisher.broadcast(
                channels.slice(start, start + CHANNELS_PER_CALL),
                data,
                `platform-outbox:${row.id}:${start}`,
              );
            }
            done.push(row.id);
          } catch (error) {
            if (!(error instanceof PublishFailedError)) throw error;
            failure = error;
            if (!error.answered) break;
            if (!this.reported.has(row.id)) {
              this.reported.add(row.id);
              this.logger.error(
                { err: error, platformOutboxId: row.id.toString() },
                'platform outbox row refused',
              );
            }
            refused.push(row.id);
          }
        }
        if (done.length > 0) {
          await tx
            .update(platformOutbox)
            .set({ publishedAt: now })
            .where(inArray(platformOutbox.id, done));
        }
        return { taken: rows.length, done: done.length };
      });
      published += batch.done;
      if (batch.taken < BATCH || (failure && !failure.answered)) break;
    }
    if (failure) throw failure;
    return published;
  }

  private async channels(row: typeof platformOutbox.$inferSelect): Promise<string[]> {
    const cities =
      row.cityId !== null ? [row.cityId] : (await this.geo.activeCities()).map(({ id }) => id);
    const channels: string[] = [];
    for (const cityId of cities) {
      if (row.ops) channels.push(opsChannel(cityId));
      if (row.apps.includes('merchant')) {
        for (const { id } of await this.merchants.restaurantIds(cityId)) {
          channels.push(merchantChannel(id));
        }
      }
      if (row.apps.includes('captain')) {
        for (const { id } of await this.captains.captainIds(cityId)) {
          channels.push(captainChannel(id));
        }
      }
    }
    // AP §9.1.6 item 2, CU §4.7: the customer's tracking screen.
    channels.push(...row.orderIds.map(orderChannel));
    return channels;
  }
}

// The worker's loop of the relay, every PLATFORM_RELAY_MS; a slow run is
// never overlapped by the next. While real time is off the rows wait.
@Injectable()
export class PlatformRelayWorker implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger('PlatformRelay');
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;
  private failing = false;

  constructor(
    private readonly relay: PlatformRelay,
    private readonly publisher: RealtimePublisher,
  ) {}

  onModuleInit(): void {
    requireRealtime('publishing');
    if (!this.publisher.enabled) {
      this.logger.warn('real time is not configured (CENTRIFUGO_*): broadcasts are not relayed');
      return;
    }
    this.timer = setInterval(() => {
      this.running ??= this.relay
        .drain(new Date())
        .then(() => {
          this.failing = false;
        })
        .catch((error: unknown) => {
          // Reported once per outage, not every second.
          if (this.failing) return;
          this.failing = true;
          this.logger.error({ err: error }, 'platform relay failed');
          reportError(error);
        })
        .finally(() => {
          this.running = undefined;
        });
    }, PLATFORM_RELAY_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
