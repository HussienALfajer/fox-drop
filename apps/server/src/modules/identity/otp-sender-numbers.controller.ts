import {
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from './admin-sessions.service.js';
import {
  OtpSenderPoolService,
  type PoolView,
  PoolRefusedError,
} from './otp-sender-pool.service.js';
import { otpSenderNumberStatuses } from './schema.js';

class SenderNumberParamsDto extends createZodDto(z.object({ numberId: z.uuid() })) {}

class SenderNumberStatusDto extends createZodDto(
  z.object({
    status: z
      .enum(['active', 'standby'])
      .describe('«نشط» or «احتياطي» (architecture §8.3.3 item 13).'),
  }),
) {}

const counts = z.object({
  sent: z.int(),
  failed: z.int(),
  delivered: z.int(),
  read: z.int(),
});

class SenderNumberDto extends createZodDto(
  z.object({
    id: z.uuid(),
    phone: z.string().describe('The sending number, E.164.'),
    status: z.enum(otpSenderNumberStatuses),
    connected: z.boolean().describe('Whether its WhatsApp session is open now.'),
    pairedAt: z.iso.datetime(),
    stoppedAt: z.iso.datetime().nullable().describe('When WhatsApp disconnected or banned it.'),
    throttledUntil: z.iso.datetime().nullable(),
    warmup: z
      .object({
        step: z.int().describe('1 for the first step of otp.sender_warmup_caps.'),
        cap: z.int(),
        nextStepAt: z.iso.datetime(),
      })
      .nullable()
      .describe('While warming.'),
    dailyCap: z.int().describe('Sends it may attempt today, failed ones included.'),
    today: counts.describe('Today in Asia/Damascus.'),
  }),
) {}

class SenderPoolDto extends createZodDto(
  z.object({
    numbers: z.array(SenderNumberDto.schema),
    alerts: z
      .array(
        z.discriminatedUnion('type', [
          z.object({
            type: z.literal('number_stopped').describe('«رقم إرسال الرموز متوقف»'),
            severity: z.literal('warning'),
            numberIds: z.array(z.uuid()),
          }),
          z.object({
            type: z.literal('cannot_send').describe('«لا يمكن إرسال رموز الدخول»'),
            severity: z.literal('critical'),
          }),
        ]),
      )
      .describe('The alerts of architecture §8.3.3 item 14 (AP §9.1.3).'),
  }),
) {}

function poolBody(pool: PoolView): SenderPoolDto {
  return {
    alerts: pool.alerts,
    numbers: pool.numbers.map((number) => ({
      ...number,
      pairedAt: number.pairedAt.toISOString(),
      stoppedAt: number.stoppedAt?.toISOString() ?? null,
      throttledUntil: number.throttledUntil?.toISOString() ?? null,
      warmup: number.warmup && {
        ...number.warmup,
        nextStepAt: number.warmup.nextStepAt.toISOString(),
      },
    })),
  };
}

async function refusalsAsHttp(action: () => Promise<void>): Promise<void> {
  try {
    await action();
  } catch (error) {
    if (!(error instanceof PoolRefusedError)) throw error;
    if (error.refusal === 'not_found') throw new NotFoundException();
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
  }
}

// «أرقام إرسال الرموز» in Settings (AP §9.14, OWN; architecture §8.3.3 items
// 13–14). Each change answers with the pool as the list shows it.
@AdminController('otp-sender-numbers')
export class OtpSenderNumbersController {
  constructor(private readonly pool: OtpSenderPoolService) {}

  @Get()
  @RequirePermission('settings.read')
  @ZodResponse({ status: 200, type: SenderPoolDto })
  async list() {
    return poolBody(await this.pool.read(new Date()));
  }

  // 409 needs_pairing for a disconnected or banned number.
  @Put(':numberId/status')
  @RequirePermission('settings.manage')
  @ZodResponse({ status: 200, type: SenderPoolDto })
  async setStatus(
    @Param() params: SenderNumberParamsDto,
    @Body() body: SenderNumberStatusDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await refusalsAsHttp(() =>
      this.pool.setStatus(params.numberId, body.status, actor, requestContext(request)),
    );
    return poolBody(await this.pool.read(new Date()));
  }

  @Post(':numberId/disable')
  @HttpCode(200)
  @RequirePermission('settings.manage')
  @ZodResponse({ status: 200, type: SenderPoolDto })
  async disable(
    @Param() params: SenderNumberParamsDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const now = new Date();
    await refusalsAsHttp(() =>
      this.pool.disable(params.numberId, actor, requestContext(request), now),
    );
    return poolBody(await this.pool.read(now));
  }
}
