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
import { GeoService } from '../geo/index.js';
import type { AlertEventPayload } from './alerts.service.js';
import { opsChannel } from './channels.js';
import { requireRealtime } from './realtime-config.js';
import { PublishFailedError, RealtimePublisher } from './realtime-publisher.js';
import { alertOutbox } from './schema.js';

// Rows taken per transaction, which holds their locks while it publishes.
const BATCH = 20;

// How often the worker looks for alert changes: «within seconds» of the
// moment an alert is raised (AP §7.3). An alert change is written by many
// transactions of other modules (AlertsService.sync), so a poll of the
// unpublished rows' index wakes the relay rather than a job in each of them.
export const ALERTS_RELAY_MS = 1000;

// What the panel receives on ops:city.{city_id} for an alert change: the
// alert, its rule and severity. The panel reads the alerts again, which
// answers what the session's roles receive (AP §7.3).
function publication(type: string, payload: AlertEventPayload) {
  const { schema, alertId, code, severity, at } = payload;
  return { type, schema, alertId, code, severity, at };
}

// E4: publishes the committed alert outbox rows to the city's ops channel, at
// least once, then marks them, as the orders' relay does (ordering's
// outbox-relay.ts): unpublished rows in id order, locked and skipping those
// another run holds. An alert of the whole platform (the code senders) goes to
// every active city.
@Injectable()
export class AlertsRelay {
  private readonly logger = new Logger('AlertsRelay');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly publisher: RealtimePublisher,
    private readonly geo: GeoService,
  ) {}

  // The count published. Centrifugo out of reach stops the run; a row it
  // refuses is logged and left for a later run. Throws when any row was left.
  async drain(now: Date): Promise<number> {
    let published = 0;
    const refused: bigint[] = [];
    let failure: PublishFailedError | undefined;
    let everyCity: string[] | undefined;
    for (;;) {
      const batch = await this.database.db.transaction(async (tx) => {
        const rows = await tx
          .select({
            id: alertOutbox.id,
            cityId: alertOutbox.cityId,
            type: alertOutbox.type,
            payload: alertOutbox.payload,
          })
          .from(alertOutbox)
          .where(
            and(
              isNull(alertOutbox.publishedAt),
              refused.length > 0 ? notInArray(alertOutbox.id, refused) : undefined,
            ),
          )
          .orderBy(asc(alertOutbox.id))
          .limit(BATCH)
          .for('update', { skipLocked: true });
        const done: bigint[] = [];
        for (const row of rows) {
          let cities: string[];
          if (row.cityId !== null) cities = [row.cityId];
          else {
            everyCity ??= (await this.geo.activeCities()).map((city) => city.id);
            cities = everyCity;
          }
          try {
            if (cities.length > 0) {
              await this.publisher.broadcast(
                cities.map(opsChannel),
                publication(row.type, row.payload as AlertEventPayload),
                `alert-outbox:${row.id}`,
              );
            }
            done.push(row.id);
          } catch (error) {
            if (!(error instanceof PublishFailedError)) throw error;
            failure = error;
            if (!error.answered) break;
            this.logger.error(
              { err: error, alertOutboxId: row.id.toString() },
              'alert outbox row refused',
            );
            refused.push(row.id);
          }
        }
        if (done.length > 0) {
          await tx
            .update(alertOutbox)
            .set({ publishedAt: now })
            .where(inArray(alertOutbox.id, done));
        }
        return { taken: rows.length, done: done.length };
      });
      published += batch.done;
      if (batch.taken < BATCH || (failure && !failure.answered)) break;
    }
    if (failure) throw failure;
    return published;
  }
}

// The worker's loop of the relay, every ALERTS_RELAY_MS; a slow run is never
// overlapped by the next. While real time is off the rows wait.
@Injectable()
export class AlertsRelayWorker implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger('AlertsRelay');
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;
  private failing = false;

  constructor(
    private readonly relay: AlertsRelay,
    private readonly publisher: RealtimePublisher,
  ) {}

  onModuleInit(): void {
    requireRealtime('publishing');
    if (!this.publisher.enabled) {
      this.logger.warn('real time is not configured (CENTRIFUGO_*): alert changes are not relayed');
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
          this.logger.error({ err: error }, 'alerts relay failed');
          reportError(error);
        })
        .finally(() => {
          this.running = undefined;
        });
    }, ALERTS_RELAY_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
