import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { type AdminSession, AdminSessionsService } from '../identity/index.js';
import {
  compensationAdmins,
  compensationBody,
  compensationOut,
  compensationValue,
  compensationValueBody,
} from './compensation-body.js';
import {
  type Compensation,
  type CompensationAdmin,
  CompensationRefusedError,
  CompensationsService,
} from './compensations.service.js';

class AdminCompensationsQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminCompensationParamsDto extends createZodDto(z.object({ compensationId: z.uuid() })) {}

class AdminApproveCompensationDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    value: compensationValueBody
      .nullable()
      .describe('«تعديل القيمة»: the value OWN gives instead; null keeps the one asked.'),
  }),
) {}

class AdminRejectCompensationDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminCompensationRequestsDto extends createZodDto(
  z.object({ requests: z.array(compensationBody).describe('Oldest first.') }),
) {}

class AdminCompensationDto extends createZodDto(compensationBody) {}

// AP §6.4 «طلبات الموافقة» (slice 2.22a): OWN approves, edits or rejects a
// compensation asked above its issuer's cap (compensation.approve_above_cap).
@AdminController('compensations')
export class AdminCompensationsController {
  constructor(
    private readonly compensations: CompensationsService,
    private readonly sessions: AdminSessionsService,
  ) {}

  @Get()
  @RequirePermission('compensation.approve_above_cap')
  @ZodResponse({ status: 200, type: AdminCompensationRequestsDto })
  async list(@Query() query: AdminCompensationsQueryDto) {
    const rows = await this.compensations.waiting(query.cityId);
    return { requests: await this.out(rows) } as AdminCompensationRequestsDto;
  }

  // The customer gets the code and its push only now (AP §6.4 item 3).
  // 400 invalid_value; 404 unknown_compensation; 409 compensation_decided,
  // no_base_currency, currency_changed.
  @Post(':compensationId/approve')
  @RequirePermission('compensation.approve_above_cap')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCompensationDto })
  async approve(
    @Param() params: AdminCompensationParamsDto,
    @Body() body: AdminApproveCompensationDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const value = body.value === null ? null : compensationValue(body.value);
    if (body.value !== null && value === null) {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: 'invalid_value' });
    }
    return this.decided(() =>
      this.compensations.approve(
        body.cityId,
        params.compensationId,
        value,
        adminOf(session, request),
        new Date(),
      ),
    );
  }

  // 404 unknown_compensation; 409 compensation_decided.
  @Post(':compensationId/reject')
  @RequirePermission('compensation.approve_above_cap')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCompensationDto })
  async reject(
    @Param() params: AdminCompensationParamsDto,
    @Body() body: AdminRejectCompensationDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.decided(() =>
      this.compensations.reject(
        body.cityId,
        params.compensationId,
        adminOf(session, request),
        new Date(),
      ),
    );
  }

  private async decided(run: () => Promise<Compensation>) {
    try {
      const [row] = await this.out([await run()]);
      return row as AdminCompensationDto;
    } catch (error) {
      if (!(error instanceof CompensationRefusedError)) throw error;
      if (error.refusal === 'unknown_compensation') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
    }
  }

  private async out(rows: Compensation[]) {
    const names = await this.sessions.names(compensationAdmins(rows));
    return rows.map((row) => compensationOut(row, names));
  }
}

export function adminOf(session: AdminSession, request: FastifyRequest): CompensationAdmin {
  return {
    accountId: session.accountId,
    roles: session.roles,
    permissions: session.permissions,
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}
