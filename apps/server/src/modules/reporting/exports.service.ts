import { Inject, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { MerchantPeriodService, MerchantStatementReads, periodFits } from '../cashdesk/index.js';
import { FilesService } from '../files/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import {
  costReportLabels,
  dailyReportLabels,
  merchantExportLabels,
  orderHistoryLabels,
  reportLabels,
} from '../content/index.js';
import { MerchantsService } from '../merchants/index.js';
import { CaptainsService } from '../captains/index.js';
import {
  ADMIN_HISTORY_EXPORT_MAX,
  type AdminHistoryFilter,
  AppHistories,
  OrderHistoryService,
  OrdersService,
  type orderStatuses,
} from '../ordering/index.js';
import { orderHistoryWorkbook } from './order-history-workbook.js';
import {
  merchantHistoryWorkbook,
  merchantReportWorkbook,
  merchantStatementWorkbook,
} from './merchant-workbooks.js';
import {
  type AdminExportKind,
  adminExportKinds,
  exports,
  type ExportKind,
  type ExportStatus,
  type MerchantExportKind,
  merchantExportKinds,
} from './schema.js';
import { costReportWorkbook } from './cost-report-workbook.js';
import { type CostReportRefusal, CostReportService } from './cost-report.service.js';
import { dailyReportWorkbook } from './daily-report-workbook.js';
import { type DailyReportRefusal, DailyReportService } from './daily-report.service.js';
import { statementWorkbook } from './statement-workbook.js';
import { reportWorkbook } from './report-workbook.js';
import {
  mayRead,
  mayReadMoney,
  type OwnerAsked,
  type ReportKind,
  type ReportRefusal,
  ReportsService,
} from './reports.service.js';
import { ownerPeriods, type OwnerPeriod } from './restaurant-report.js';

// Architecture §5.9: an export stays in private-docs this long.
export const EXPORT_KEEP_MS = 24 * 60 * 60_000;
// The orders whose owner money lines the history's export reads at once
// (each picked-up one is a query; the pool has 10 connections).
const OWNER_MONEY_CHUNK = 10;

// How long a download URL stays valid: long enough to start the download.
export const EXPORT_URL_SECONDS = 5 * 60;

const XLSX = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

export type ExportsRefusal =
  | 'unknown_restaurant'
  | 'invalid_period'
  | 'idempotency_key_reused'
  | 'unknown_export'
  | 'too_many_rows'
  | 'unknown_statement'
  | DailyReportRefusal
  | CostReportRefusal
  | ReportRefusal;

export class ExportsRefusedError extends Error {
  override readonly name = 'ExportsRefusedError';
  constructor(readonly refusal: ExportsRefusal) {
    super(refusal);
  }
}

export interface ExportUser {
  accountId: string;
  // The permissions the user holds now: reading an export needs its kind's.
  permissions: readonly string[];
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

export interface DailyReportParams {
  cityId: string;
  day: string;
}

export interface CostReportParams {
  cityId: string;
  from: string;
  to: string;
}

// AP §9.5 (slice 2.40): the history's filters as resolved, JSON-safe (the
// number as text, the customer's account in place of the phone).
export type OrderHistoryParams = Omit<AdminHistoryFilter, 'number' | 'from' | 'to'> & {
  number: string | null;
  from: string;
  to: string;
};

// AP §9.17 (slice 2.41): a report of «التقارير»; `phones` writes the top
// customers' numbers in full (`exports.phone_numbers`, AP §5.4).
export interface ReportParams {
  report: ReportKind;
  cityId: string;
  from: string;
  to: string;
  phones: boolean;
  // The captains' earnings, for a reader of the money (`mayReadMoney`).
  money: boolean;
}

// RA §17 (slice 2.45d): the owner web portal's exports, each of the
// owner's restaurant: the reports of the business days `from` to `to` (a
// period's, resolved when asked, with the period kept; null for a custom
// range), «السجل» of a range, and one weekly statement.
export interface MerchantReportParams {
  restaurantId: string;
  period: OwnerPeriod | null;
  from: string | null;
  to: string | null;
}

export interface MerchantHistoryParams {
  restaurantId: string;
  from: string;
  to: string;
  status: (typeof orderStatuses)[number] | null;
  number: string | null;
}

export interface MerchantStatementParams {
  restaurantId: string;
  statementId: string;
}

type ExportParams =
  | RestaurantStatementParams
  | DailyReportParams
  | CostReportParams
  | OrderHistoryParams
  | ReportParams
  | MerchantReportParams
  | MerchantHistoryParams
  | MerchantStatementParams;

// A restaurant owner asking from the portal: their account and restaurant.
export interface MerchantExportUser {
  accountId: string;
  restaurantId: string;
  cityId: string;
  // RA §5.5: a terminated restaurant's owners keep the statements only.
  terminated: boolean;
  actor: AuditActor;
  context: AuditRequestContext;
}

const isMerchantKind = (kind: ExportKind): kind is MerchantExportKind =>
  (merchantExportKinds as readonly string[]).includes(kind);
const isAdminKind = (kind: ExportKind): kind is AdminExportKind =>
  (adminExportKinds as readonly string[]).includes(kind);

// The permission each kind of export is read with: the one its screen asks.
export const exportPermissions = {
  restaurant_statement: 'restaurants.statements',
  daily_report: 'finance.read',
  cost_report: 'finance.read',
  order_history: 'order_history.read',
  // Each report's own (`reportPermissions`), checked by `mayReadExport`.
  report: 'reports.all',
} as const satisfies Record<AdminExportKind, string>;

// Whether a user may read an export: its kind's permission; a report's, its
// report's (and `exports.phone_numbers` for one with the numbers in full).
// The portal's own kinds are never the panel's.
export function mayReadExport(
  kind: ExportKind,
  params: unknown,
  permissions: readonly string[],
): boolean {
  if (!isAdminKind(kind)) return false;
  if (kind !== 'report') return permissions.includes(exportPermissions[kind]);
  const asked = params as ReportParams;
  return (
    mayRead(asked.report, permissions) &&
    (!asked.phones || permissions.includes('exports.phone_numbers')) &&
    (asked.money === false || mayReadMoney(permissions))
  );
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
    private readonly reports: DailyReportService,
    private readonly costs: CostReportService,
    private readonly history: OrderHistoryService,
    private readonly captains: CaptainsService,
    private readonly reportsOf: ReportsService,
    private readonly histories: AppHistories,
    private readonly orders: OrdersService,
    private readonly statements: MerchantStatementReads,
  ) {}

  // RA §17 (slice 2.45d): «تصدير Excel» of the reports in the portal, a
  // period or a custom range of the owner's restaurant, as the panel's
  // exports: recorded, written by the worker, downloaded from the portal.
  async requestMerchantReport(
    user: MerchantExportUser,
    asked: { period: OwnerPeriod } | { from: string; to: string },
    idempotencyKey: string,
    now: Date,
  ): Promise<ExportView> {
    const period = 'period' in asked ? asked.period : null;
    const repeat = await this.byKey(user.accountId, idempotencyKey);
    if (repeat) {
      // The same ask: the period, or the range typed (a period's days are
      // resolved when first asked, so a repeat after the cutoff still answers).
      const first = repeat.params as MerchantReportParams;
      const same =
        repeat.kind === 'merchant_report' &&
        first.restaurantId === user.restaurantId &&
        first.period === period &&
        ('period' in asked || (first.from === asked.from && first.to === asked.to));
      if (!same) throw new ExportsRefusedError('idempotency_key_reused');
      return this.viewOf(repeat, now, null);
    }
    const days = await this.reportsOf.ownerDays(
      user.cityId,
      'period' in asked ? asked : { fromDay: asked.from, toDay: asked.to },
      now,
    );
    if (days === null) throw new ExportsRefusedError('invalid_period');
    if ((await this.fx.baseCurrency(user.cityId)) === null) {
      throw new ExportsRefusedError('no_base_currency');
    }
    // The business days the period covers when asked, so the file is the
    // one its name says even when the worker writes it after the cutoff.
    const params: MerchantReportParams = {
      restaurantId: user.restaurantId,
      period,
      from: days.fromDay,
      to: days.toDay,
    };
    const fileName = `${merchantExportLabels.report.title} ${days.fromDay} - ${days.toDay}.xlsx`;
    return this.record(user, 'merchant_report', user.cityId, params, fileName, idempotencyKey, now);
  }

  // «تصدير Excel» of «السجل» in the portal: a range (at most 366 days),
  // narrowed by the status and the number, of at most
  // MERCHANT_HISTORY_EXPORT_MAX orders (`too_many_rows`).
  async requestMerchantHistory(
    user: MerchantExportUser,
    asked: Omit<MerchantHistoryParams, 'restaurantId'>,
    idempotencyKey: string,
    now: Date,
  ): Promise<ExportView> {
    const params: MerchantHistoryParams = { restaurantId: user.restaurantId, ...asked };
    const repeat = await this.byKey(user.accountId, idempotencyKey);
    if (repeat) return this.answerRepeat(repeat, 'merchant_order_history', params, now);
    const range = await this.histories.restaurantRange(user.restaurantId, historyFilterOf(params));
    if (range === 'invalid_period') throw new ExportsRefusedError('invalid_period');
    if (range === 'too_many') throw new ExportsRefusedError('too_many_rows');
    const fileName = `${merchantExportLabels.history.title} ${params.from} - ${params.to}.xlsx`;
    return this.record(
      user,
      'merchant_order_history',
      user.cityId,
      params,
      fileName,
      idempotencyKey,
      now,
    );
  }

  // «تصدير Excel» of a weekly statement in the portal (RA §12.3, §17); a
  // terminated restaurant's owners keep it (RA §5.5).
  async requestMerchantStatement(
    user: MerchantExportUser,
    statementId: string,
    idempotencyKey: string,
    now: Date,
  ): Promise<ExportView> {
    const params: MerchantStatementParams = { restaurantId: user.restaurantId, statementId };
    const repeat = await this.byKey(user.accountId, idempotencyKey);
    if (repeat) return this.answerRepeat(repeat, 'merchant_statement', params, now);
    const statement = await this.statements.statement(user.restaurantId, statementId);
    if (!statement) throw new ExportsRefusedError('unknown_statement');
    const timeZone = await this.geo.cityTimeZone(statement.cityId);
    if (timeZone === null) throw new Error(`city ${statement.cityId} does not exist`);
    const day = new Intl.DateTimeFormat('en-CA', { timeZone }).format(statement.cutoff);
    const fileName = `${merchantExportLabels.statement.title} ${day}.xlsx`;
    return this.record(
      user,
      'merchant_statement',
      statement.cityId,
      params,
      fileName,
      idempotencyKey,
      now,
    );
  }

  // A portal export's state, to the owner who asked for it, while it is of
  // their restaurant, and once it is terminated only a statement's
  // (`unknown_export` otherwise); with `download`, while
  // ready, a fresh URL signed for the portal's origin, audited as a view.
  async viewMerchant(
    exportId: string,
    user: MerchantExportUser,
    now: Date,
    download = false,
  ): Promise<ExportView> {
    const [row] = await this.database.db
      .select()
      .from(exports)
      .where(and(eq(exports.id, exportId), eq(exports.requestedBy, user.accountId)));
    if (
      !row ||
      !isMerchantKind(row.kind) ||
      (row.params as { restaurantId?: unknown }).restaurantId !== user.restaurantId ||
      (user.terminated && row.kind !== 'merchant_statement')
    ) {
      throw new ExportsRefusedError('unknown_export');
    }
    const view = this.viewOf(row, now, null);
    if (!download || view.status !== 'ready' || row.objectKey === null) return view;
    const url = await this.files.privateDownloadUrl(
      row.objectKey,
      row.fileName,
      EXPORT_URL_SECONDS,
      now,
      'portal',
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

  // «تصدير Excel» of a report of «التقارير» (AP §9.17, slice 2.41), as the
  // statement's. The customers report holds the top customers' numbers in
  // full only for a user with `exports.phone_numbers` (AP §5.4); the export
  // is audited with `phones` either way.
  async requestReport(
    user: ExportUser,
    params: Omit<ReportParams, 'phones' | 'money'>,
    idempotencyKey: string,
    now: Date,
  ): Promise<ExportView> {
    const full: ReportParams = {
      ...params,
      phones: params.report === 'customers' && user.permissions.includes('exports.phone_numbers'),
      money: mayReadMoney(user.permissions),
    };
    const repeat = await this.byKey(user.accountId, idempotencyKey);
    if (repeat) return this.answerRepeat(repeat, 'report', full, now);
    const refusal = await this.reportsOf.check(params.cityId, params.from, params.to, now);
    if (refusal !== null) throw new ExportsRefusedError(refusal);
    const fileName = `${reportLabels.title[params.report]} ${params.from} - ${params.to}.xlsx`;
    return this.record(user, 'report', params.cityId, full, fileName, idempotencyKey, now);
  }

  // «تصدير Excel» of «سجل الطلبات» (AP §9.5, slice 2.40), as the
  // statement's: a period of business days is required (at most 366).
  async requestOrderHistory(
    user: ExportUser,
    params: OrderHistoryParams,
    idempotencyKey: string,
    now: Date,
  ): Promise<ExportView> {
    const repeat = await this.byKey(user.accountId, idempotencyKey);
    if (repeat) return this.answerRepeat(repeat, 'order_history', params, now);
    if (!periodFits(params.from, params.to)) throw new ExportsRefusedError('invalid_period');
    const filter = { ...params, number: params.number === null ? null : BigInt(params.number) };
    if ((await this.history.count(filter)) > ADMIN_HISTORY_EXPORT_MAX) {
      throw new ExportsRefusedError('too_many_rows');
    }
    const fileName = `${orderHistoryLabels.title} ${params.from} - ${params.to}.xlsx`;
    return this.record(user, 'order_history', params.cityId, params, fileName, idempotencyKey, now);
  }

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
    if (repeat) return this.answerRepeat(repeat, 'restaurant_statement', params, now);
    if (!periodFits(params.from, params.to)) throw new ExportsRefusedError('invalid_period');
    const restaurant = await this.merchants.restaurant(params.restaurantId);
    if (!restaurant) throw new ExportsRefusedError('unknown_restaurant');
    const fileName = `كشف ${restaurant.nameAr.replace(unsafe, '-').replace(/\s+/g, ' ')} ${params.from} - ${params.to}.xlsx`;
    return this.record(
      user,
      'restaurant_statement',
      restaurant.cityId,
      params,
      fileName,
      idempotencyKey,
      now,
    );
  }

  // «تصدير Excel» of the daily report (AP §9.10.1, slice 2.20d), as the
  // statement's.
  async requestDailyReport(
    user: ExportUser,
    params: DailyReportParams,
    idempotencyKey: string,
    now: Date,
  ): Promise<ExportView> {
    const repeat = await this.byKey(user.accountId, idempotencyKey);
    if (repeat) return this.answerRepeat(repeat, 'daily_report', params, now);
    const refusal = await this.reports.check(params.cityId, params.day, now);
    if (refusal !== null) throw new ExportsRefusedError(refusal);
    const fileName = `${dailyReportLabels.title} ${params.day}.xlsx`;
    return this.record(user, 'daily_report', params.cityId, params, fileName, idempotencyKey, now);
  }

  // «تصدير Excel» of the cost report (AP §9.10.6, slice 2.22d), as the
  // statement's.
  async requestCostReport(
    user: ExportUser,
    params: CostReportParams,
    idempotencyKey: string,
    now: Date,
  ): Promise<ExportView> {
    const repeat = await this.byKey(user.accountId, idempotencyKey);
    if (repeat) return this.answerRepeat(repeat, 'cost_report', params, now);
    const refusal = await this.costs.check(params.cityId, params.from, params.to, now);
    if (refusal !== null) throw new ExportsRefusedError(refusal);
    const fileName = `${costReportLabels.title} ${params.from} - ${params.to}.xlsx`;
    return this.record(user, 'cost_report', params.cityId, params, fileName, idempotencyKey, now);
  }

  // Records the export and queues its job in one transaction, audited (AP
  // §5.4). A request sent twice at once answers the one recorded.
  private async record(
    user: Pick<ExportUser, 'accountId' | 'actor' | 'context'>,
    kind: ExportKind,
    cityId: string,
    params: ExportParams,
    fileName: string,
    idempotencyKey: string,
    now: Date,
  ): Promise<ExportView> {
    await this.jobs.ready();
    const inserted = await this.database.db.transaction(async (tx) => {
      const [row] = await tx
        .insert(exports)
        .values({ cityId, kind, params, requestedBy: user.accountId, idempotencyKey, fileName })
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
    return this.answerRepeat(other, kind, params, now);
  }

  // The export's state, to its requester only. With `download`, while it is
  // ready, a fresh download URL, audited as a view of the file (architecture
  // §5.8): only when the user downloads, so reading the state logs nothing.
  async view(exportId: string, user: ExportUser, now: Date, download = false): Promise<ExportView> {
    const [row] = await this.database.db
      .select()
      .from(exports)
      .where(and(eq(exports.id, exportId), eq(exports.requestedBy, user.accountId)));
    // Another's export, or one whose kind the user may no longer read.
    if (!row || !mayReadExport(row.kind, row.params, user.permissions)) {
      throw new ExportsRefusedError('unknown_export');
    }
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
    const file = await this.file(row, now);
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

  private file(row: Row, now: Date): Promise<Buffer> {
    switch (row.kind) {
      case 'restaurant_statement':
        return this.statementFile(row);
      case 'daily_report':
        return this.dailyReportFile(row.params as DailyReportParams, now);
      case 'cost_report':
        return this.costReportFile(row.params as CostReportParams, now);
      case 'order_history':
        return this.orderHistoryFile(row.params as OrderHistoryParams);
      case 'report':
        return this.reportFile(row.params as ReportParams, now);
      case 'merchant_report':
        return this.merchantReportFile(row.params as MerchantReportParams, now);
      case 'merchant_order_history':
        return this.merchantHistoryFile(row.params as MerchantHistoryParams);
      case 'merchant_statement':
        return this.merchantStatementFile(row.params as MerchantStatementParams);
    }
  }

  // The portal's reports as they stand when the worker writes them (a
  // period running today ends then).
  private async merchantReportFile(params: MerchantReportParams, now: Date): Promise<Buffer> {
    const restaurant = await this.merchants.restaurant(params.restaurantId);
    if (!restaurant) throw new Error(`restaurant ${params.restaurantId} does not exist`);
    const asked = ownerAskedOf(params);
    const [report, days, currencies] = await Promise.all([
      this.reportsOf.restaurantReport(restaurant, asked, now),
      this.reportsOf.ownerDays(restaurant.cityId, asked, now),
      this.fx.currencies(),
    ]);
    if (report === null || days === null) {
      throw new Error(`the reports of ${params.restaurantId} cannot be read`);
    }
    return merchantReportWorkbook(
      { restaurantName: restaurant.nameAr, ...days, ...report },
      new Map(currencies.map((each) => [each.code, each.decimals])),
    );
  }

  // «السجل»'s orders as they stand when the worker writes the file, with
  // the owner's money lines (RA §8.18).
  private async merchantHistoryFile(params: MerchantHistoryParams): Promise<Buffer> {
    const found = await this.histories.restaurantAll(params.restaurantId, historyFilterOf(params));
    if (typeof found === 'string') {
      throw new Error(`the history export of ${params.restaurantId} is refused: ${found}`);
    }
    // A chunk at a time: ownerMoney reads each picked-up order's edits, and
    // the worker's pool is shared with the timers and the outbox.
    const owner: Map<
      string,
      { commission: bigint; discountShare: bigint; merchantNet: bigint } | null
    > = new Map();
    for (let start = 0; start < found.orders.length; start += OWNER_MONEY_CHUNK) {
      const chunk = await this.orders.ownerMoney(
        found.orders.slice(start, start + OWNER_MONEY_CHUNK),
      );
      for (const [id, money] of chunk) owner.set(id, money);
    }
    const currencies = await this.fx.currencies();
    return merchantHistoryWorkbook(
      { fromDay: params.from, toDay: params.to, ...found, owner },
      new Map(currencies.map((each) => [each.code, each.decimals])),
    );
  }

  private async merchantStatementFile(params: MerchantStatementParams): Promise<Buffer> {
    const statement = await this.statements.statement(params.restaurantId, params.statementId);
    if (!statement) throw new Error(`statement ${params.statementId} cannot be read`);
    const [timeZone, currencies] = await Promise.all([
      this.geo.cityTimeZone(statement.cityId),
      this.fx.currencies(),
    ]);
    if (timeZone === null) throw new Error(`city ${statement.cityId} does not exist`);
    return merchantStatementWorkbook(
      statement,
      timeZone,
      new Map(currencies.map((each) => [each.code, each.decimals])),
    );
  }

  // The report as it stands when the worker writes it (a period that ends
  // today is still running).
  private async reportFile(params: ReportParams, now: Date): Promise<Buffer> {
    const [report, currencies] = await Promise.all([
      this.reportsOf.report(params.report, params.cityId, params.from, params.to, now, {
        fullPhones: params.phones,
        // An export asked before the field existed read the money.
        money: params.money !== false,
      }),
      this.fx.currencies(),
    ]);
    return reportWorkbook(report, new Map(currencies.map((each) => [each.code, each.decimals])));
  }

  // The orders as they stand when the worker writes the file.
  private async orderHistoryFile(params: OrderHistoryParams): Promise<Buffer> {
    const rows = await this.history.all({
      ...params,
      number: params.number === null ? null : BigInt(params.number),
    });
    const [timeZone, currencies, restaurants, captains] = await Promise.all([
      this.geo.cityTimeZone(params.cityId),
      this.fx.currencies(),
      this.merchants.names([...new Set(rows.map((row) => row.restaurantId))]),
      this.captains.names([
        ...new Set(rows.flatMap((row) => (row.captainId ? [row.captainId] : []))),
      ]),
    ]);
    if (timeZone === null) throw new Error(`city ${params.cityId} does not exist`);
    return orderHistoryWorkbook(
      {
        fromDay: params.from,
        toDay: params.to,
        timeZone,
        rows,
        restaurantNames: new Map([...restaurants].map(([id, name]) => [id, name.nameAr])),
        captainNames: captains,
      },
      new Map(currencies.map((each) => [each.code, each.decimals])),
    );
  }

  // The report as it stands when the worker writes it (a period that ends
  // today is still running).
  private async costReportFile(params: CostReportParams, now: Date): Promise<Buffer> {
    const [report, currencies] = await Promise.all([
      this.costs.report(params.cityId, params.from, params.to, now),
      this.fx.currencies(),
    ]);
    return costReportWorkbook(
      report,
      new Map(currencies.map((each) => [each.code, each.decimals])),
    );
  }

  private async statementFile(row: Row): Promise<Buffer> {
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
    return statementWorkbook(
      statement,
      timeZone,
      new Map(currencies.map((each) => [each.code, each.decimals])),
    );
  }

  // The report as it stands when the worker writes it (today's still running).
  private async dailyReportFile(params: DailyReportParams, now: Date): Promise<Buffer> {
    const [report, timeZone, currencies] = await Promise.all([
      this.reports.report(params.cityId, params.day, now),
      this.geo.cityTimeZone(params.cityId),
      this.fx.currencies(),
    ]);
    if (timeZone === null) throw new Error(`city ${params.cityId} does not exist`);
    return dailyReportWorkbook(
      report,
      timeZone,
      new Map(currencies.map((each) => [each.code, each.decimals])),
    );
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

  private answerRepeat(row: Row, kind: ExportKind, params: ExportParams, now: Date): ExportView {
    const asked = row.params as Record<string, unknown>;
    const same =
      row.kind === kind &&
      Object.keys(asked).length === Object.keys(params).length &&
      Object.entries(params).every(([key, value]) => asked[key] === value);
    if (!same) throw new ExportsRefusedError('idempotency_key_reused');
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

// The days the export covers; one asked before slice 2.45d's fix kept only
// its period.
function ownerAskedOf(params: MerchantReportParams): OwnerAsked {
  if (params.from !== null && params.to !== null) {
    return { fromDay: params.from, toDay: params.to };
  }
  if (params.period !== null && (ownerPeriods as readonly string[]).includes(params.period)) {
    return { period: params.period };
  }
  throw new Error('a report export without its days');
}

function historyFilterOf(params: MerchantHistoryParams) {
  return {
    fromDay: params.from,
    toDay: params.to,
    ...(params.status === null ? {} : { status: params.status }),
    ...(params.number === null ? {} : { number: BigInt(params.number) }),
  };
}
