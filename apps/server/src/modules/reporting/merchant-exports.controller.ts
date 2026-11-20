import {
  Body,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { orderStatuses } from '../ordering/index.js';
import { refusalsAsHttp } from './admin-exports.controller.js';
import { day } from './admin-restaurant-statements.controller.js';
import { ExportsService, type ExportView, type MerchantExportUser } from './exports.service.js';
import { ownerPeriods } from './restaurant-report.js';
import { exportStatuses, merchantExportKinds } from './schema.js';

class MerchantReportExportDto extends createZodDto(
  z
    .object({
      period: z
        .enum(ownerPeriods)
        .nullable()
        .describe('RA §11: «اليوم», «أمس», «آخر 7 أيام», «آخر 30 يوماً»; or `from` and `to`.'),
      from: day.nullable().describe('The custom range’s first business day.'),
      to: day.nullable().describe('Its last business day, included: at most 366, not after today.'),
    })
    .refine(
      (body) =>
        body.period === null ? body.from !== null && body.to !== null : body.from === null,
      { message: 'a period, or from and to' },
    ),
) {}

class MerchantHistoryExportDto extends createZodDto(
  z.object({
    from: day.describe('The first business day.'),
    to: day.describe('The last business day, included: at most 366 days.'),
    status: z.enum(orderStatuses).nullable(),
    number: z
      .string()
      .regex(/^\d{1,12}$/)
      .nullable()
      .describe('The order number without «#».'),
  }),
) {}

class MerchantStatementExportDto extends createZodDto(z.object({ statementId: z.uuid() })) {}

class MerchantExportParamsDto extends createZodDto(z.object({ exportId: z.uuid() })) {}

class MerchantExportQueryDto extends createZodDto(
  z.object({
    download: z
      .enum(['true', 'false'])
      .optional()
      .describe('true signs a download URL (audited); the state alone otherwise.'),
  }),
) {}

class MerchantExportDto extends createZodDto(
  z.object({
    id: z.uuid(),
    kind: z.enum(merchantExportKinds),
    status: z.enum(exportStatuses),
    fileName: z.string(),
    createdAt: z.iso.datetime(),
    expiresAt: z.iso.datetime().nullable().describe('Until when it can be downloaded.'),
    url: z
      .string()
      .nullable()
      .describe(
        'Asked with download=true while ready: a signed download on the portal’s origin, valid 5 minutes.',
      ),
  }),
) {}

function body(view: ExportView) {
  return {
    id: view.id,
    kind: view.kind as (typeof merchantExportKinds)[number],
    status: view.status,
    fileName: view.fileName,
    createdAt: view.createdAt.toISOString(),
    expiresAt: view.expiresAt?.toISOString() ?? null,
    url: view.url,
  };
}

// RA §17 (slice 2.45d, owner decision 2026-11-20): the owner web portal's
// Excel files of the reports, «السجل» and a weekly statement, built on the
// server as the panel's (architecture §5.9): asked here (202), written by
// the worker, then downloaded through a short URL signed for the portal's
// origin. The portal's only (an app's token is 403 not_in_portal), owners
// only (403 owner_only); a terminated restaurant's owners keep the
// statement only (RA §5.5, 403 restaurant_terminated). Each request takes
// Idempotency-Key (422 idempotency_key_reused); every export and download
// is audited (AP §5.4).
@MerchantController()
export class MerchantExportsController {
  constructor(
    private readonly exports: ExportsService,
    private readonly merchants: MerchantsService,
  ) {}

  // 400 invalid_period (a range longer than 366 days or ending after
  // today); 409 no_base_currency.
  @Post('exports/report')
  @AppSignedIn({ portal: true })
  @Idempotent()
  @HttpCode(202)
  @ZodResponse({ status: 202, type: MerchantExportDto })
  async report(
    @Body() asked: MerchantReportExportDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAppSession() session: AppSession,
    @Req() request: FastifyRequest,
  ) {
    const user = await this.owner(session, request, false);
    return refusalsAsHttp(async () =>
      body(
        await this.exports.requestMerchantReport(
          user,
          asked.period !== null ? { period: asked.period } : { from: asked.from!, to: asked.to! },
          idempotencyKey,
          new Date(),
        ),
      ),
    );
  }

  // 400 invalid_period; 409 too_many_rows (a shorter range).
  @Post('exports/order-history')
  @AppSignedIn({ portal: true })
  @Idempotent()
  @HttpCode(202)
  @ZodResponse({ status: 202, type: MerchantExportDto })
  async history(
    @Body() asked: MerchantHistoryExportDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAppSession() session: AppSession,
    @Req() request: FastifyRequest,
  ) {
    const user = await this.owner(session, request, false);
    return refusalsAsHttp(async () =>
      body(await this.exports.requestMerchantHistory(user, asked, idempotencyKey, new Date())),
    );
  }

  // 404 unknown_statement (another restaurant's or unknown).
  @Post('exports/statement')
  @AppSignedIn({ portal: true })
  @Idempotent()
  @HttpCode(202)
  @ZodResponse({ status: 202, type: MerchantExportDto })
  async statement(
    @Body() asked: MerchantStatementExportDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAppSession() session: AppSession,
    @Req() request: FastifyRequest,
  ) {
    const user = await this.owner(session, request, true);
    return refusalsAsHttp(async () =>
      body(
        await this.exports.requestMerchantStatement(
          user,
          asked.statementId,
          idempotencyKey,
          new Date(),
        ),
      ),
    );
  }

  // The export's state to the owner who asked for it (404 unknown_export
  // for anyone else); with download=true while ready, a URL signed for the
  // portal's origin, audited.
  @Get('exports/:exportId')
  @AppSignedIn({ portal: true })
  @ZodResponse({ status: 200, type: MerchantExportDto })
  async read(
    @Param() params: MerchantExportParamsDto,
    @Query() query: MerchantExportQueryDto,
    @CurrentAppSession() session: AppSession,
    @Req() request: FastifyRequest,
  ) {
    const user = await this.owner(session, request, true);
    return refusalsAsHttp(async () =>
      body(
        await this.exports.viewMerchant(
          params.exportId,
          user,
          new Date(),
          query.download === 'true',
        ),
      ),
    );
  }

  private async owner(
    session: AppSession,
    request: FastifyRequest,
    terminatedKeeps: boolean,
  ): Promise<MerchantExportUser> {
    const merchant = session.merchant;
    if (!merchant) throw new Error('a merchant route without a restaurant user');
    if (merchant.role !== 'owner') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
    }
    if (!session.portal) {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'not_in_portal' });
    }
    const restaurant = await this.merchants.restaurant(merchant.restaurantId);
    if (!restaurant) throw new Error('the session names no restaurant');
    if (!terminatedKeeps && restaurant.accountStatus === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    return {
      accountId: merchant.id,
      restaurantId: restaurant.id,
      cityId: restaurant.cityId,
      actor: { type: 'merchant', id: merchant.id, role: merchant.role },
      context: { ipAddress: request.ip, device: session.deviceId },
    };
  }
}
