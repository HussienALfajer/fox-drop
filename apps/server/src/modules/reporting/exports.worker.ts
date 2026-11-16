import { Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import { type ExportJob, ExportsService } from './exports.service.js';

// The worker's export jobs (architecture §5.9): writing an export to
// private-docs, and removing it after its 24 hours. Each re-reads the export
// and acts only on its state, so a late or repeated job changes nothing.
@Injectable()
export class ExportsWorker implements OnModuleInit {
  private readonly logger = new Logger('Exports');

  constructor(
    private readonly jobs: Jobs,
    private readonly exports: ExportsService,
  ) {}

  async onModuleInit(): Promise<void> {
    await this.jobs.work<ExportJob>(QUEUES.exportBuild, async (batch) => {
      for (const job of batch) {
        await this.run('export written', job.data.exportId, () =>
          this.exports.build(job.data.exportId, new Date()),
        );
      }
    });
    await this.jobs.work<ExportJob>(QUEUES.exportExpiry, async (batch) => {
      for (const job of batch) {
        await this.run('export removed', job.data.exportId, () =>
          this.exports.expire(job.data.exportId),
        );
      }
    });
  }

  private async run(what: string, exportId: string, act: () => Promise<boolean>) {
    try {
      if (await act()) this.logger.log({ exportId }, what);
    } catch (error) {
      // pg-boss tries it again (QUEUE_OPTIONS); each failure is reported.
      this.logger.error({ err: error, exportId }, `${what} failed`);
      reportError(error);
      throw error;
    }
  }
}
