import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Query,
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { orderHistoryFilterBody, OrderHistoryService } from '../ordering/index.js';
import { costReportRefusal } from './admin-cost-report.controller.js';
import { dailyReportRefusal } from './admin-daily-report.controller.js';
import { day, restaurantPeriodQuery } from './admin-restaurant-statements.controller.js';
import {
  type ExportUser,
  ExportsRefusedError,
  ExportsService,
  type ExportView,
} from './exports.service.js';
import { adminExportKinds, exportStatuses } from './schema.js';

class AdminRestaurantStatementExportDto extends createZodDto(restaurantPeriodQuery) {}

class AdminDailyReportExportDto extends createZodDto(z.object({ cityId: z.uuid(), day })) {}

class AdminCostReportExportDto extends createZodDto(
  z.object({ cityId: z.uuid(), from: day, to: day }),
) {}

class AdminOrderHistoryExportDto extends createZodDto(
  orderHistoryFilterBody.extend({
    from: day.describe('The first business day; an export needs a period.'),
    to: day.describe('The last business day, included; at most 366 days.'),
  }),
) {}

class AdminExportParamsDto extends createZodDto(z.object({ exportId: z.uuid() })) {}

class AdminExportQueryDto extends createZodDto(
  z.object({
    download: z
      .enum(['true', 'false'])
      .optional()
      .describe('true signs a download URL (audited); the state alone otherwise.'),
  }),
) {}

export class AdminExportDto extends createZodDto(
  z.object({
    id: z.uuid(),
    kind: z.enum(adminExportKinds),
    status: z.enum(exportStatuses),
    fileName: z.string(),
    createdAt: z.iso.datetime(),
    expiresAt: z.iso.datetime().nullable().describe('Until when it can be downloaded.'),
    url: z
      .string()
      .nullable()
      .describe(
        'Asked with download=true while ready: a signed download on the panel’s origin, valid 5 minutes.',
      ),
  }),
) {}

// The panel's routes answer its own kinds only (`mayReadExport`).
export function exportBody(view: ExportView) {
  return {
    id: view.id,
    kind: view.kind as (typeof adminExportKinds)[number],
    status: view.status,
    fileName: view.fileName,
    createdAt: view.createdAt.toISOString(),
    expiresAt: view.expiresAt?.toISOString() ?? null,
    url: view.url,
  };
}

function exportUser(session: AdminSession, request: FastifyRequest): ExportUser {
  return {
    accountId: session.accountId,
    permissions: session.permissions,
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

export async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof ExportsRefusedError)) throw error;
    const body = (statusCode: number) => ({ statusCode, error: error.refusal });
    switch (error.refusal) {
      case 'unknown_restaurant':
      case 'unknown_export':
      case 'unknown_statement':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'invalid_period':
        throw costReportRefusal(error.refusal);
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException(body(HttpStatus.UNPROCESSABLE_ENTITY));
      case 'too_many_rows':
        throw new ConflictException(body(HttpStatus.CONFLICT));
      case 'invalid_day':
      case 'unknown_city':
      case 'no_base_currency':
      case 'rate_missing':
        throw dailyReportRefusal(error.refusal);
    }
  }
}

// Excel exports (architecture §5.9; slice 2.19g): asked, written by the
// worker, then downloaded through a short signed URL. Every export and every
// download is audited (AP §5.4).
@AdminController()
export class AdminExportsController {
  constructor(
    private readonly exports: ExportsService,
    private readonly history: OrderHistoryService,
  ) {}

  // «تصدير Excel» of «سجل الطلبات» (AP §9.5, slice 2.40): the filters of
  // the list with a period. 202, as the statement's. 400 invalid_period,
  // invalid_phone; 403 phone_not_allowed; 409 too_many_rows (more than
  // ADMIN_HISTORY_EXPORT_MAX orders: a shorter period or more filters);
  // 422 idempotency_key_reused.
  @Post('order-history/exports')
  @RequirePermission('order_history.read')
  @Idempotent()
  @HttpCode(202)
  @ZodResponse({ status: 202, type: AdminExportDto })
  async requestOrderHistory(
    @Body() body: AdminOrderHistoryExportDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const resolved = await this.history.resolve(body, session.permissions);
    if (resolved === 'phone_not_allowed') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: resolved });
    }
    if (resolved === 'invalid_phone' || resolved === 'invalid_period') {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: resolved });
    }
    const filter = resolved;
    return refusalsAsHttp(async () =>
      exportBody(
        await this.exports.requestOrderHistory(
          exportUser(session, request),
          {
            ...filter,
            number: filter.number === null ? null : filter.number.toString(),
            from: body.from,
            to: body.to,
          },
          idempotencyKey,
          new Date(),
        ),
      ),
    );
  }

  // «تصدير Excel» of a restaurant's statement for a period (AP §9.10.5).
  // 202: the worker writes it; read it with GET /v1/admin/exports/{id}.
  // 404 unknown_restaurant; 400 invalid_period; 422 idempotency_key_reused.
  @Post('restaurant-statements/exports')
  @RequirePermission('restaurants.statements')
  @Idempotent()
  @HttpCode(202)
  @ZodResponse({ status: 202, type: AdminExportDto })
  requestStatement(
    @Body() body: AdminRestaurantStatementExportDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      exportBody(
        await this.exports.requestRestaurantStatement(
          exportUser(session, request),
          { restaurantId: body.restaurantId, from: body.from, to: body.to },
          idempotencyKey,
          new Date(),
        ),
      ),
    );
  }

  // «تصدير Excel» of the daily report (AP §9.10.1, slice 2.20d). 202, as
  // the statement's. 400 invalid_day; 404 unknown_city; 409
  // no_base_currency; 422 idempotency_key_reused.
  @Post('daily-report/exports')
  @RequirePermission('finance.read')
  @Idempotent()
  @HttpCode(202)
  @ZodResponse({ status: 202, type: AdminExportDto })
  requestDailyReport(
    @Body() body: AdminDailyReportExportDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      exportBody(
        await this.exports.requestDailyReport(
          exportUser(session, request),
          { cityId: body.cityId, day: body.day },
          idempotencyKey,
          new Date(),
        ),
      ),
    );
  }

  // «تصدير Excel» of the cost report (AP §9.10.6, slice 2.22d). 202, as the
  // statement's. 400 invalid_period; 404 unknown_city; 409 no_base_currency;
  // 422 idempotency_key_reused.
  @Post('cost-report/exports')
  @RequirePermission('finance.read')
  @Idempotent()
  @HttpCode(202)
  @ZodResponse({ status: 202, type: AdminExportDto })
  requestCostReport(
    @Body() body: AdminCostReportExportDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      exportBody(
        await this.exports.requestCostReport(
          exportUser(session, request),
          { cityId: body.cityId, from: body.from, to: body.to },
          idempotencyKey,
          new Date(),
        ),
      ),
    );
  }

  // The export's state, to whoever asked for it while they still hold its
  // kind's permission (`exportPermissions`; 404 unknown_export for anyone
  // else); with download=true while ready, a download URL, audited.
  @Get('exports/:exportId')
  @RequireAnyPermission(
    'restaurants.statements',
    'finance.read',
    'order_history.read',
    'reports.all',
    'reports.operations',
    'reports.support',
    'reports.financial',
  )
  @ZodResponse({ status: 200, type: AdminExportDto })
  view(
    @Param() params: AdminExportParamsDto,
    @Query() query: AdminExportQueryDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      exportBody(
        await this.exports.view(
          params.exportId,
          exportUser(session, request),
          new Date(),
          query.download === 'true',
        ),
      ),
    );
  }
}
