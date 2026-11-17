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
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { phoneOf } from '../../http/phone-search.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { type BlockCommand } from './blocks.js';
import {
  type CustomerAdmin,
  CustomerAdminRefusedError,
  CustomerAdminService,
  type CustomerProfileView,
} from './customer-admin.service.js';
import { blockKinds, genders } from './schema.js';

const minor = z.string().regex(/^-?\d{1,18}$/);
const reason = z.string().trim().min(1).max(500);
const status = z
  .enum(['active', 'blocked', 'dues_unpaid', 'review_stop'])
  .describe(
    '«نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم» (AP §9.8).',
  );

class AdminCustomerSearchDto extends createZodDto(
  z.object({
    cityId: z.uuid().describe("The panel's city, whose dues the status reads."),
    q: z
      .string()
      .trim()
      .min(1)
      .max(60)
      .describe('A number in any usual form, or a part of a name.'),
  }),
) {}

class AdminCustomersFoundDto extends createZodDto(
  z.object({
    customers: z.array(
      z.object({
        id: z.uuid(),
        name: z.string().nullable().describe('null until «أكمل بياناتك».'),
        maskedPhone: z.string().nullable(),
        status,
      }),
    ),
  }),
) {}

class AdminCustomerQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminCustomerParamsDto extends createZodDto(z.object({ customerId: z.uuid() })) {}

// Nested enums travel as strings (the Dart generator misnames them); the
// panel is TypeScript, so its kinds keep their enum.
class AdminCustomerDto extends createZodDto(
  z.object({
    id: z.uuid(),
    firstName: z.string().nullable(),
    lastName: z.string().nullable(),
    gender: z.enum(genders).nullable(),
    birthday: z.iso.date().nullable(),
    maskedPhone: z.string().nullable(),
    status,
    block: z
      .object({
        id: z.uuid(),
        kind: z.enum(blockKinds),
        until: z.iso.datetime().nullable(),
        reason: z.string(),
        reasonLabel: z.string(),
        customerText: z.string(),
        note: z.string(),
        startedAt: z.iso.datetime(),
      })
      .nullable()
      .describe('The block in force: a duration or until further notice.'),
    reviewStop: z.object({ startedAt: z.iso.datetime() }).nullable(),
    trusted: z.boolean().describe('«موثوق» by D23.'),
    delivered: z.int().describe('The normal deliveries that count toward the trust.'),
    trustedAfter: z.int(),
    lateCancels: z.object({
      inWindow: z.int(),
      total: z.int(),
      limit: z.int(),
      windowDays: z.int(),
    }),
    fakeOrders: z.int(),
    dues: z
      .object({ amount: minor, currency: z.string().nullable() })
      .describe("In the city's base: + the customer owes, − a credit (AP §8.8)."),
    blocks: z.array(
      z.object({
        id: z.uuid(),
        kind: z.enum(blockKinds),
        reason: z.string(),
        reasonLabel: z.string(),
        note: z.string(),
        until: z.iso.datetime().nullable(),
        duesAmount: minor.nullable(),
        duesCurrency: z.string().nullable(),
        startedAt: z.iso.datetime(),
        startedByName: z.string().nullable(),
        endedAt: z.iso.datetime().nullable().describe('A duration that ran out ends at its time.'),
        endedByName: z.string().nullable(),
        endNote: z.string().nullable(),
        inForce: z.boolean(),
      }),
    ),
    blockReasons: z
      .array(z.object({ code: z.string(), label: z.string() }))
      .describe("Content's active customer_block reasons (AP Appendix B)."),
  }),
) {}

class AdminBlockCustomerDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    kind: z
      .enum(blockKinds)
      .describe('«لمدة» until a moment, «حتى إشعار آخر», or «حتى دفع مستحق» of an amount.'),
    until: z.iso.datetime().nullable().describe('The duration kind: when the block ends.'),
    amount: z
      .string()
      .regex(/^\d{1,15}$/)
      .nullable()
      .describe("The dues kind: the amount in minor units of the city's base."),
    reason: z.string().describe("A code of Content's customer_block list (AP Appendix B)."),
    note: reason.describe('The internal reason (AP §9.8: required).'),
  }),
) {}

class AdminUnblockCustomerDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    blockId: z.uuid().describe('The block in force the panel showed.'),
    note: reason.describe('The required reason.'),
  }),
) {}

// AP §9.8 «الزبائن» (slice 2.25a): the search, the profile, «حظر» and
// «فك الحظر».
@AdminController('customers')
export class AdminCustomersController {
  constructor(private readonly customers: CustomerAdminService) {}

  // A read sent as a POST, so a number never sits in a URL.
  @Post('search')
  @RequirePermission('customers.read')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomersFoundDto })
  async search(@Body() body: AdminCustomerSearchDto) {
    const found = await this.customers.search(
      body.cityId,
      { text: body.q, phone: phoneOf(body.q) },
      new Date(),
    );
    return { customers: found };
  }

  // 404 unknown_customer, unknown_city.
  @Get(':customerId')
  @RequirePermission('customers.read')
  @ZodResponse({ status: 200, type: AdminCustomerDto })
  read(@Param() params: AdminCustomerParamsDto, @Query() query: AdminCustomerQueryDto) {
    return refusalsAsHttp(async () =>
      profileBody(await this.customers.profile(query.cityId, params.customerId, new Date())),
    );
  }

  // Answers the profile. 400 invalid_block (a duration not ahead or past a
  // year, an amount at zero, a kind without its field), unknown_reason;
  // 404 unknown_customer, unknown_city; 409 already_blocked, no_base_currency;
  // 422 idempotency_key_reused.
  @Post(':customerId/block')
  @RequirePermission('customers.block')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminCustomerDto })
  block(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminBlockCustomerDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      await this.customers.block(
        adminOf(session, request),
        {
          cityId: body.cityId,
          accountId: params.customerId,
          block: blockOf(body),
          reason: body.reason,
          note: body.note,
          idempotencyKey,
        },
        now,
      );
      return profileBody(await this.customers.profile(body.cityId, params.customerId, now));
    });
  }

  // Answers the profile. 409 not_blocked when the block named is not the
  // one in force (lifted, ran out or replaced since the panel read it).
  @Post(':customerId/unblock')
  @RequirePermission('customers.block')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomerDto })
  unblock(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminUnblockCustomerDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      await this.customers.unblock(
        adminOf(session, request),
        {
          cityId: body.cityId,
          accountId: params.customerId,
          blockId: body.blockId,
          note: body.note,
        },
        now,
      );
      return profileBody(await this.customers.profile(body.cityId, params.customerId, now));
    });
  }
}

function adminOf(session: AdminSession, request: FastifyRequest): CustomerAdmin {
  return {
    accountId: session.accountId,
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

function blockOf(body: AdminBlockCustomerDto): BlockCommand {
  const invalid = () =>
    new CustomerAdminRefusedError('invalid_block', 'the block does not fit its kind');
  switch (body.kind) {
    case 'until':
      if (body.until === null || body.amount !== null) throw invalid();
      return { kind: 'until', until: new Date(body.until) };
    case 'indefinite':
      if (body.until !== null || body.amount !== null) throw invalid();
      return { kind: 'indefinite' };
    case 'dues':
      if (body.until !== null || body.amount === null) throw invalid();
      return { kind: 'dues', amount: BigInt(body.amount) };
  }
}

function profileBody(view: CustomerProfileView) {
  return {
    ...view,
    block: view.block && {
      id: view.block.id,
      kind: view.block.kind,
      until: view.block.until?.toISOString() ?? null,
      reason: view.block.reason,
      reasonLabel: view.block.reasonLabel,
      customerText: view.block.customerText,
      note: view.block.note,
      startedAt: view.block.startedAt.toISOString(),
    },
    reviewStop: view.reviewStop && { startedAt: view.reviewStop.startedAt.toISOString() },
    dues: { amount: view.dues.amount.toString(), currency: view.dues.currency },
    blocks: view.blocks.map((block) => ({
      ...block,
      until: block.until?.toISOString() ?? null,
      duesAmount: block.duesAmount?.toString() ?? null,
      startedAt: block.startedAt.toISOString(),
      endedAt: block.endedAt?.toISOString() ?? null,
    })),
  };
}

async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof CustomerAdminRefusedError)) throw error;
    const body = (statusCode: number) => ({ statusCode, error: error.refusal });
    switch (error.refusal) {
      case 'unknown_customer':
      case 'unknown_city':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'invalid_block':
      case 'unknown_reason':
        throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException(body(HttpStatus.UNPROCESSABLE_ENTITY));
      case 'already_blocked':
      case 'not_blocked':
      case 'no_base_currency':
        throw new ConflictException(body(HttpStatus.CONFLICT));
    }
  }
}
