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
import {
  ApplicationPipelineService,
  type ContractPhaseChange,
  type ExpiringDocuments,
} from '../captains/index.js';
import { applicationDocumentLabels, formatDate, NotificationTexts } from '../content/index.js';
import { GeoService } from '../geo/index.js';
import { PushQueue } from './push-queue.js';

type ContractTx = Parameters<Parameters<ApplicationPipelineService['sweepContractPhases']>[2]>[0];

// How often the worker reads the contracts: a phase reached is told within
// this.
export const CONTRACT_NOTICES_MS = 60_000;

// CA §14 #28 «بدأت {المرحلة} من {التاريخ}» (the phases' words ours, to
// confirm with the owner).
export const phaseLabels = {
  probation: 'فترة التجربة',
  commitment: 'فترة الالتزام',
  open: 'المرحلة المفتوحة',
} as const;

// AP §9.7.2, CA §12.3, §14 #28 (slice 2.35a): each city's activated
// captains whose contract reached a phase they were not told of hear it
// once, silently: the commitment from the probation's confirmation, the
// open-ended contract on the commitment's end.
@Injectable()
export class CaptainContractNotices {
  private readonly logger = new Logger('CaptainContractNotices');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly pipeline: ApplicationPipelineService,
    private readonly geo: GeoService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  async run(now: Date): Promise<void> {
    for (const city of await this.geo.activeCities()) {
      // A failure of one never holds back the other.
      for (const [step, work] of [
        [
          'contract phases',
          () =>
            this.pipeline.sweepContractPhases(city.id, now, async (tx, change) => {
              await this.push(tx, change, now);
            }),
        ],
        ['documents', () => this.documents(city.id, now)],
      ] as const) {
        try {
          await work();
        } catch (error) {
          this.logger.error({ err: error, cityId: city.id, step }, 'contract notices failed');
          reportError(error);
        }
      }
    }
  }

  // CA §12.2, §14 #27 «تنتهي صلاحية {المستند} في {التاريخ}»: once per
  // document in force entering its notice (the source names it), silently;
  // the app's amber banner reads the documents.
  private async documents(cityId: string, now: Date): Promise<void> {
    const captains: ExpiringDocuments[] = await this.pipeline.expiringDocuments(cityId, now);
    const pushes = [];
    for (const captain of captains) {
      for (const document of captain.documents) {
        if (document.expired) continue;
        const templateKey = 'captain.document_expiring';
        const rendered = await this.texts.render(templateKey, {
          المستند: applicationDocumentLabels[document.kind],
          التاريخ: formatDate(new Date(`${document.expiresOn}T12:00:00Z`), captain.timeZone),
        });
        pushes.push({
          source: `captain:document_expiring:${document.documentId}`,
          recipient: { party: 'captain' as const, captainId: captain.captainId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: { target: 'documents' },
          at: now,
        });
      }
    }
    if (pushes.length > 0) await this.pushes.enqueue(this.database.db, pushes, now);
  }

  private async push(tx: ContractTx, change: ContractPhaseChange, now: Date): Promise<void> {
    const templateKey = 'captain.contract_phase';
    const rendered = await this.texts.render(
      templateKey,
      {
        المرحلة: phaseLabels[change.phase],
        التاريخ: formatDate(new Date(`${change.from}T12:00:00Z`), change.timeZone),
      },
      tx,
    );
    await this.pushes.enqueue(
      tx,
      [
        {
          source: `captain:contract_phase:${change.captainId}:${change.phase}:${change.from}`,
          recipient: { party: 'captain', captainId: change.captainId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: { target: 'contract' },
          at: now,
        },
      ],
      now,
    );
  }
}

@Injectable()
export class CaptainContractNoticesWorker implements OnModuleInit, OnApplicationShutdown {
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;

  constructor(private readonly notices: CaptainContractNotices) {}

  onModuleInit(): void {
    this.timer = setInterval(() => {
      // A slow run is never overlapped by the next.
      this.running ??= this.notices.run(new Date()).finally(() => {
        this.running = undefined;
      });
    }, CONTRACT_NOTICES_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
