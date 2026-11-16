import { Inject, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { MerchantPeriodService, periodFits } from '../cashdesk/index.js';
import { FilesService } from '../files/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { exports, type ExportKind, type ExportStatus } from './schema.js';
import { statementWorkbook } from './statement-workbook.js';

// Architecture §5.9: an export stays in private-docs this long.
export const EXPORT_KEEP_MS = 24 * 60 * 60_000;
// How long a download URL stays valid: long enough to start the download.
export const EXPORT_URL_SECONDS = 5 * 60;

const XLSX = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

export type ExportsRefusal =
  'unknown_restaurant' | 'invalid_period' | 'idempotency_key_reused' | 'unknown_export';

export class ExportsRefusedError extends Error {
  override readonly name = 'ExportsRefusedError';
  constructor(readonly refusal: ExportsRefusal) {
    super(refusal);
  }
}

export interface ExportUser {
  accountId: string;
  actor: AuditActor;
  context: AuditRequestContext;
}

export interface ExportView {
  id: string;
  kind: ExportKind;
  status: ExportStatus;
  fileName: string;
  createdAt: Date;
  // Until when it can be downloaded, once ready.
  expiresAt: Date | null;
  // A short signed URL on the panel's origin, while ready.
  url: string | null;
}

export interface RestaurantStatementParams {
  restaurantId: string;
  from: string;
  to: string;
}

export interface ExportJob {
  exportId: string;
}

type Row = typeof exports.$inferSelect;

// Characters a file name may not hold on Windows, macOS or Linux; line
// breaks and tabs become spaces.
const unsafe = /[\\/:*?"<>|]/g;

@Injectable()
export class ExportsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
    private readonly audit: AuditService,
    private readonly files: FilesService,
    private readonly periods: MerchantPeriodService,
    private readonly merchants: MerchantsService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
  ) {}

  // «تصدير Excel» of a restaurant's statement (AP §9.10.5): records the
  // export and queues its job in one transaction, audited (AP §5.4). A
  // repeat of the key answers the same export.
  async requestRestaurantStatement(
    user: ExportUser,
    params: RestaurantStatementParams,
    idempotencyKey: string,
    now: Date,
  ): Promise<ExportView> {
    const repeat = await this.byKey(user.accountId, idempotencyKey);
    if (repeat) return this.answerRepeat(repeat, params, now);
    if (!periodFits(params.from, params.to)) throw new ExportsRefusedError('invalid_period');
    const restaurant = await this.merchants.restaurant(params.restaurantId);
    if (!restaurant) throw new ExportsRefusedError('unknown_restaurant');
    const fileName = `كشف ${restaurant.nameAr.replace(unsafe, '-').replace(/\s+/g, ' ')} ${params.from} - ${params.to}.xlsx`;
    await this.jobs.ready();
    const inserted = await this.database.db.transaction(async (tx) => {
      const [row] = await tx
        .insert(exports)
        .values({
          cityId: restaurant.cityId,
          kind: 'restaurant_statement',
          params,
          requestedBy: user.accountId,
          idempotencyKey,
          fileName,
        })
        .onConflictDoNothing()
        .returning();
      // A request sent twice at once: the other one recorded it.
      if (!row) return null;
      await this.jobs.send(QUEUES.exportBuild, { exportId: row.id } satisfies ExportJob, {
        db: inTransaction(tx),
      });
      await this.audit.recordWrite(
        {
          actor: user.actor,
          context: user.context,
          cityId: row.cityId,
          action: 'export.create',
          target: { type: 'export', id: row.id },
          before: null,
          after: { kind: row.kind, ...params },
        },
        tx,
      );
      return row;
    });
    if (inserted) return this.viewOf(inserted, now, null);
    const other = await this.byKey(user.accountId, idempotencyKey);
    if (!other) throw new Error('the export of a conflicting key is missing');
    return this.answerRepeat(other, params, now);
  }

  // The export's state, to its requester only. With `download`, while it is
  // ready, a fresh download URL, audited as a view of the file (architecture
  // §5.8): only when the user downloads, so reading the state logs nothing.
  async view(exportId: string, user: ExportUser, now: Date, download = false): Promise<ExportView> {
    const [row] = await this.database.db
      .select()
      .from(exports)
      .where(and(eq(exports.id, exportId), eq(exports.requestedBy, user.accountId)));
    if (!row) throw new ExportsRefusedError('unknown_export');
    const view = this.viewOf(row, now, null);
    if (!download || view.status !== 'ready' || row.objectKey === null) return view;
    const url = await this.files.privateDownloadUrl(
      row.objectKey,
      row.fileName,
      EXPORT_URL_SECONDS,
    );
    await this.audit.recordView({
      actor: user.actor,
      context: user.context,
      cityId: row.cityId,
      action: 'export.download',
      target: { type: 'export', id: row.id },
    });
    return { ...view, url };
  }

  // The worker's job: writes the file once, then marks it ready and queues
  // its removal. A repeat of a written export changes nothing; a failure is
  // retried (the file is written again under the same key).
  async build(exportId: string, now: Date): Promise<boolean> {
    const [row] = await this.database.db.select().from(exports).where(eq(exports.id, exportId));
    if (!row || row.status !== 'pending') return false;
    const params = row.params as RestaurantStatementParams;
    const statement = await this.periods.statement(params.restaurantId, params.from, params.to);
    if (statement === null || statement === 'invalid_period') {
      throw new Error(`export ${row.id} asks for a statement that cannot be read`);
    }
    const [timeZone, currencies] = await Promise.all([
      this.geo.cityTimeZone(statement.cityId),
      this.fx.currencies(),
    ]);
    if (timeZone === null) throw new Error(`city ${statement.cityId} does not exist`);
    const file = await statementWorkbook(
      statement,
      timeZone,
      new Map(currencies.map((each) => [each.code, each.decimals])),
    );
    const objectKey = `exports/${row.id}.xlsx`;
    await this.files.putPrivate(objectKey, file, XLSX);
    const expiresAt = new Date(now.getTime() + EXPORT_KEEP_MS);
    await this.jobs.ready();
    return this.database.db.transaction(async (tx) => {
      const [written] = await tx
        .update(exports)
        .set({ status: 'ready', objectKey, readyAt: now, expiresAt })
        .where(and(eq(exports.id, row.id), eq(exports.status, 'pending')))
        .returning({ id: exports.id });
      if (!written) return false;
      await this.jobs.send(QUEUES.exportExpiry, { exportId: row.id } satisfies ExportJob, {
        db: inTransaction(tx),
        startAfter: expiresAt,
      });
      return true;
    });
  }

  // Removes the file once its 24 hours are over. The job is queued for that
  // moment by the database's clock; one run early by the worker's clock is
  // still the file's end (the URLs stop at expires_at anyway), so it never
  // completes without removing the file. Removing a file already gone is
  // fine, so a repeat changes nothing.
  async expire(exportId: string): Promise<boolean> {
    const [row] = await this.database.db.select().from(exports).where(eq(exports.id, exportId));
    if (!row || row.status !== 'ready' || row.objectKey === null) return false;
    await this.files.deletePrivate(row.objectKey);
    await this.database.db
      .update(exports)
      .set({ status: 'expired' })
      .where(and(eq(exports.id, row.id), eq(exports.status, 'ready')));
    return true;
  }

  private async byKey(accountId: string, idempotencyKey: string): Promise<Row | undefined> {
    const [row] = await this.database.db
      .select()
      .from(exports)
      .where(and(eq(exports.requestedBy, accountId), eq(exports.idempotencyKey, idempotencyKey)));
    return row;
  }

  private answerRepeat(row: Row, params: RestaurantStatementParams, now: Date): ExportView {
    const asked = row.params as RestaurantStatementParams;
    if (
      row.kind !== 'restaurant_statement' ||
      asked.restaurantId !== params.restaurantId ||
      asked.from !== params.from ||
      asked.to !== params.to
    ) {
      throw new ExportsRefusedError('idempotency_key_reused');
    }
    return this.viewOf(row, now, null);
  }

  private viewOf(row: Row, now: Date, url: string | null): ExportView {
    const lapsed =
      row.status === 'ready' && row.expiresAt !== null && row.expiresAt.getTime() <= now.getTime();
    return {
      id: row.id,
      kind: row.kind,
      status: lapsed ? 'expired' : row.status,
      fileName: row.fileName,
      createdAt: row.createdAt,
      expiresAt: row.expiresAt,
      url,
    };
  }
}
