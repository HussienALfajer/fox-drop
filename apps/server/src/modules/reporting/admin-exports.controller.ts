import {
  Body,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Req,
  BadRequestException,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { restaurantPeriodQuery } from './admin-restaurant-statements.controller.js';
import {
  type ExportUser,
  ExportsRefusedError,
  ExportsService,
  type ExportView,
} from './exports.service.js';
import { exportKinds, exportStatuses } from './schema.js';

class AdminRestaurantStatementExportDto extends createZodDto(restaurantPeriodQuery) {}

class AdminExportParamsDto extends createZodDto(z.object({ exportId: z.uuid() })) {}

class AdminExportDto extends createZodDto(
  z.object({
    id: z.uuid(),
    kind: z.enum(exportKinds),
    status: z.enum(exportStatuses),
    fileName: z.string(),
    createdAt: z.iso.datetime(),
    expiresAt: z.iso.datetime().nullable().describe('Until when it can be downloaded.'),
    url: z
      .string()
      .nullable()
      .describe('A signed download on the panel’s origin, valid 5 minutes, while ready.'),
  }),
) {}

function exportBody(view: ExportView) {
  return {
    id: view.id,
    kind: view.kind,
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
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof ExportsRefusedError)) throw error;
    const body = (statusCode: number) => ({ statusCode, error: error.refusal });
    switch (error.refusal) {
      case 'unknown_restaurant':
      case 'unknown_export':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'invalid_period':
        throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException(body(HttpStatus.UNPROCESSABLE_ENTITY));
    }
  }
}

// Excel exports (architecture §5.9; slice 2.19g): asked, written by the
// worker, then downloaded through a short signed URL. Every export and every
// download is audited (AP §5.4).
@AdminController()
export class AdminExportsController {
  constructor(private readonly exports: ExportsService) {}

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

  // The export's state, to whoever asked for it (404 unknown_export for
  // anyone else); while ready, a download URL. The only kind so far is the
  // restaurant statement, so the route asks its permission.
  @Get('exports/:exportId')
  @RequirePermission('restaurants.statements')
  @ZodResponse({ status: 200, type: AdminExportDto })
  view(
    @Param() params: AdminExportParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      exportBody(
        await this.exports.view(params.exportId, exportUser(session, request), new Date()),
      ),
    );
  }
}
