import {
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
  Req,
  Body,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { costReportRefusal } from './admin-cost-report.controller.js';
import { day } from './admin-restaurant-statements.controller.js';
import { AdminExportDto, exportBody } from './admin-exports.controller.js';
import { ExportsRefusedError, ExportsService } from './exports.service.js';
import { ROW_CODES, reportColumnKinds, reportRowKinds } from './report-tables.js';
import {
  mayRead,
  type Report,
  reportKinds,
  ReportRefusedError,
  ReportsService,
} from './reports.service.js';

// Every report permission of AP §6.2; each report then needs its own
// (`reportPermissions`, 403 report_not_allowed).
const REPORT_READERS = [
  'reports.all',
  'reports.operations',
  'reports.support',
  'reports.financial',
] as const;

class AdminReportParamsDto extends createZodDto(z.object({ report: z.enum(reportKinds) })) {}

const period = z.object({
  cityId: z.uuid(),
  from: day.describe('The first business day.'),
  to: day.describe('The last business day, included; at most 366 days, not after today.'),
});

class AdminReportQueryDto extends createZodDto(period) {}

class AdminReportExportBodyDto extends createZodDto(period) {}

class AdminReportDto extends createZodDto(
  z.object({
    report: z.enum(reportKinds),
    cityId: z.uuid(),
    fromDay: day,
    toDay: day,
    from: z.iso.datetime().describe('The cutoff that starts the first day.'),
    to: z.iso
      .datetime()
      .describe('The cutoff that ends the last day, or now while the last day runs.'),
    currency: z
      .string()
      .regex(/^[A-Z]{3}$/)
      .describe('The city’s base: every money cell is in it unless its row names another.'),
    tables: z.array(
      z.object({
        key: z.string().describe('The table, unique in its report.'),
        rowKind: z.enum(reportRowKinds),
        rowCodes: z
          .string()
          .nullable()
          .describe('The list of `reports.code` that names the rows’ codes; null: as they are.'),
        columns: z.array(z.object({ key: z.string(), kind: z.enum(reportColumnKinds) })),
        rows: z.array(
          z.object({
            code: z.string().nullable(),
            label: z.string().nullable(),
            currency: z
              .string()
              .nullable()
              .describe('The money cells’ currency, when not the report’s.'),
            cells: z
              .array(z.string().nullable())
              .describe(
                'One per column, as text: counts, basis points, minutes or stars to one decimal, minor units, a code or text.',
              ),
          }),
        ),
      }),
    ),
  }),
) {}

function reportBody(report: Report) {
  return {
    report: report.kind,
    cityId: report.cityId,
    fromDay: report.fromDay,
    toDay: report.toDay,
    from: report.from.toISOString(),
    to: report.to.toISOString(),
    currency: report.currency,
    tables: report.tables.map((table) => ({
      key: table.key,
      rowKind: table.rowKind,
      rowCodes: ROW_CODES[`${report.kind}.${table.key}`] ?? null,
      columns: table.columns,
      rows: table.rows.map((row) => ({ ...row, currency: row.currency ?? null })),
    })),
  };
}

function allowed(report: (typeof reportKinds)[number], session: AdminSession) {
  if (!mayRead(report, session.permissions)) {
    throw new ForbiddenException({
      statusCode: HttpStatus.FORBIDDEN,
      error: 'report_not_allowed',
    });
  }
}

function refusal(error: unknown): never {
  if (error instanceof ReportRefusedError || error instanceof ExportsRefusedError) {
    const reason = error.refusal;
    if (
      reason === 'invalid_period' ||
      reason === 'unknown_city' ||
      reason === 'no_base_currency' ||
      reason === 'rate_missing'
    ) {
      throw costReportRefusal(reason);
    }
  }
  throw error;
}

// «التقارير» (AP §9.17, §6.2; slice 2.41): OWN reads every report
// (`reports.all`), OPS, SUP and FIN theirs (`reportPermissions`).
@AdminController('reports')
export class AdminReportsController {
  constructor(
    private readonly reports: ReportsService,
    private readonly exports: ExportsService,
  ) {}

  // The report of the business days `from` to `to`. 400 invalid_period (a
  // day that does not exist, the last before the first, longer than 366
  // days, or starting after today); 403 report_not_allowed; 404
  // unknown_city; 409 no_base_currency, rate_missing.
  @Get(':report')
  @RequireAnyPermission(...REPORT_READERS)
  @ZodResponse({ status: 200, type: AdminReportDto })
  async report(
    @Param() params: AdminReportParamsDto,
    @Query() query: AdminReportQueryDto,
    @CurrentAdminSession() session: AdminSession,
  ) {
    allowed(params.report, session);
    try {
      return reportBody(
        await this.reports.report(params.report, query.cityId, query.from, query.to, new Date()),
      );
    } catch (error) {
      return refusal(error);
    }
  }

  // «تصدير Excel» (architecture §5.9): 202 with the export, written by the
  // worker as the report stands then, audited (AP §5.4). The customers
  // report writes the top customers' numbers in full for
  // `exports.phone_numbers` (OWN, OPS, SUP), masked otherwise. The refusals
  // of the report; 422 idempotency_key_reused.
  @Post(':report/exports')
  @RequireAnyPermission(...REPORT_READERS)
  @Idempotent()
  @HttpCode(202)
  @ZodResponse({ status: 202, type: AdminExportDto })
  async requestExport(
    @Param() params: AdminReportParamsDto,
    @Body() body: AdminReportExportBodyDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    allowed(params.report, session);
    try {
      const view = await this.exports.requestReport(
        {
          accountId: session.accountId,
          permissions: session.permissions,
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
        },
        { report: params.report, cityId: body.cityId, from: body.from, to: body.to },
        idempotencyKey,
        new Date(),
      );
      return exportBody(view);
    } catch (error) {
      if (error instanceof ExportsRefusedError && error.refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: error.refusal,
        });
      }
      return refusal(error);
    }
  }
}
