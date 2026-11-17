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
import {
  type AdminSession,
  type CustomerAccountAdmin,
  CustomerAccountRefusedError,
  CustomerAccountsService,
} from '../identity/index.js';
import { type BlockCommand, maskedPhone } from './blocks.js';
import {
  type AdminMark,
  type CustomerAdmin,
  CustomerAdminRefusedError,
  CustomerAdminService,
  type CustomerProfileView,
} from './customer-admin.service.js';
import { blockKinds, genders } from './schema.js';

const minor = z.string().regex(/^-?\d{1,18}$/);
const reason = z.string().trim().min(1).max(500);
const status = z
  .enum(['active', 'blocked', 'dues_unpaid', 'review_stop', 'closed'])
  .describe(
    '«نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم», «مغلق» (AP §9.8).',
  );

const adminMark = z.object({
  at: z.iso.datetime(),
  byName: z.string().nullable(),
  note: z.string(),
});

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
    reviewStop: z.object({ id: z.uuid(), startedAt: z.iso.datetime() }).nullable(),
    closed: z
      .object({
        at: z.iso.datetime(),
        byName: z.string().nullable().describe('null when the customer closed it from the app.'),
        reason: z.string().nullable(),
      })
      .nullable()
      .describe('«مغلق» (D19): when, by whom and why; null while open.'),
    linkedAccounts: z
      .array(
        z.object({
          id: z.uuid(),
          status: z.enum(['active', 'closed']),
          createdAt: z.iso.datetime(),
          closedAt: z.iso.datetime().nullable(),
        }),
      )
      .describe(
        'The other accounts of the line, newest first: the closed accounts this one continues, or the account that continues it (AP §8.8).',
      ),
    trusted: z.boolean().describe('«موثوق» by D23 and the latest mark.'),
    delivered: z.int().describe('The normal deliveries that count toward the trust.'),
    trustedAfter: z.int(),
    trustMark: adminMark
      .extend({ trusted: z.boolean() })
      .nullable()
      .describe('The latest «توثيق» or «إزالة الثقة».'),
    lateCancels: z.object({
      inWindow: z.int().describe('Within the window, from the latest clear.'),
      total: z.int(),
      limit: z.int(),
      windowDays: z.int(),
      cleared: adminMark.nullable().describe('The latest «مسح المخالفات».'),
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
    testAccount: z.boolean().describe('«حساب تجريبي للإدارة»: sees the restaurants in test mode.'),
    orders: z.object({
      count: z.int().describe("The customer's orders in the city, re-deliveries left out."),
      spent: z
        .array(z.object({ currency: z.string(), amount: minor }))
        .describe('The delivered orders’ totals per currency.'),
      last: z
        .object({
          id: z.uuid(),
          number: z.string(),
          status: z.string(),
          placedAt: z.iso.datetime(),
        })
        .nullable(),
    }),
    tickets: z.array(
      z.object({
        id: z.uuid(),
        number: z.string(),
        typeLabel: z.string(),
        status: z.string(),
        orderNumber: z.string().nullable(),
        openedAt: z.iso.datetime(),
      }),
    ),
    codes: z
      .array(
        z.object({
          code: z.string(),
          kind: z.string(),
          orderId: z.uuid(),
          currency: z.string(),
          discount: minor,
          status: z.string().describe('held, spent, or returned (given back).'),
          heldAt: z.iso.datetime(),
        }),
      )
      .describe('The codes used in the city, newest first.'),
    addresses: z.array(
      z.object({
        id: z.uuid(),
        label: z.string(),
        customLabel: z.string().nullable(),
        street: z.string(),
        floor: z.string().nullable(),
        landmark: z.string(),
        neighbourhood: z.string().nullable(),
        location: z.object({ latitude: z.number(), longitude: z.number() }),
        isDefault: z.boolean(),
        recipientName: z.string().nullable(),
        maskedContactPhone: z
          .string()
          .nullable()
          .describe("Another contact number, masked; null is the account's own."),
      }),
    ),
    notes: z.array(
      z.object({
        id: z.uuid(),
        body: z.string(),
        authorName: z.string().nullable(),
        createdAt: z.iso.datetime(),
      }),
    ),
  }),
) {}

class AdminSetCustomerTestAccountDto extends createZodDto(
  z.object({ cityId: z.uuid(), flagged: z.boolean() }),
) {}

class AdminChangeCustomerPhoneDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    phone: z
      .string()
      .trim()
      .min(1)
      .max(30)
      .describe('The new Syrian or Turkish mobile, in any usual form.'),
    note: reason.describe('The required reason.'),
  }),
) {}

class AdminCloseCustomerAccountDto extends createZodDto(
  z.object({ cityId: z.uuid(), note: reason.describe('The required reason.') }),
) {}

class AdminCustomerSignOutDto extends createZodDto(
  z.object({ cityId: z.uuid(), note: reason.describe('The required reason.') }),
) {}

class AdminCustomerSignedOutDto extends createZodDto(
  z.object({ sessionsEnded: z.int().describe('The devices signed out.') }),
) {}

class AdminAddCustomerNoteDto extends createZodDto(
  z.object({ cityId: z.uuid(), body: reason.describe('The note, up to 500 characters.') }),
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

class AdminMarkCustomerTrustDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    trusted: z.boolean().describe('«توثيق» (true) or «إزالة الثقة» (false).'),
    note: reason.describe('The required reason.'),
  }),
) {}

class AdminClearCustomerStrikesDto extends createZodDto(
  z.object({ cityId: z.uuid(), note: reason.describe('The required reason.') }),
) {}

class AdminEndCustomerReviewStopDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    stopId: z.uuid().describe('The open review stop the panel showed.'),
    note: reason.describe('The required reason.'),
  }),
) {}

// AP §9.8 «الزبائن» (slices 2.25a, 2.25b): the search, the profile and its
// actions.
@AdminController('customers')
export class AdminCustomersController {
  constructor(
    private readonly customers: CustomerAdminService,
    private readonly accounts: CustomerAccountsService,
  ) {}

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

  // «ملاحظة داخلية» (everyone who reads the customers). Answers the profile.
  // 422 idempotency_key_reused.
  @Post(':customerId/notes')
  @RequirePermission('customers.read')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminCustomerDto })
  addNote(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminAddCustomerNoteDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      await this.customers.addNote(
        adminOf(session, request),
        { cityId: body.cityId, accountId: params.customerId, body: body.body, idempotencyKey },
        now,
      );
      return profileBody(await this.customers.profile(body.cityId, params.customerId, now));
    });
  }

  // «حساب تجريبي للإدارة» (OWN). Answers the profile.
  @Post(':customerId/test-account')
  @RequirePermission('customers.test_account')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomerDto })
  setTestAccount(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminSetCustomerTestAccountDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      await this.customers.setTestAccount(
        adminOf(session, request),
        { cityId: body.cityId, accountId: params.customerId, flagged: body.flagged },
        now,
      );
      return profileBody(await this.customers.profile(body.cityId, params.customerId, now));
    });
  }

  // «تغيير الرقم» (OWN, OPS; AP §9.8, CU §5.4): every session ends and the
  // customer signs in again with the new number. The account's own number
  // again changes nothing, so it takes no key. Answers the profile. 400
  // invalid_phone; 404 unknown_customer; 409 phone_taken.
  @Post(':customerId/change-phone')
  @RequirePermission('customers.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomerDto })
  changePhone(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminChangeCustomerPhoneDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      await this.customers.checkCustomer(body.cityId, params.customerId);
      const phone = phoneOf(body.phone);
      if (phone === null) {
        throw new CustomerAccountRefusedError('invalid_phone', 'not a mobile number');
      }
      await this.accounts.changePhone(
        accountAdminOf(session, request, body.cityId, body.note),
        { accountId: params.customerId, phone },
        now,
      );
      return profileBody(await this.customers.profile(body.cityId, params.customerId, now));
    });
  }

  // «إغلاق الحساب» (OWN, OPS, SUP; AP §9.8, D19, §8.8; slice 2.25c): on the
  // customer's request; every session ends and the data stays. A repeat is
  // refused, so it takes no key. Answers the profile. 404
  // unknown_customer, unknown_city; 409 active_order, account_closed.
  @Post(':customerId/close')
  @RequirePermission('customers.close_account')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomerDto })
  close(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminCloseCustomerAccountDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      await this.customers.close(
        adminOf(session, request),
        { cityId: body.cityId, accountId: params.customerId, note: body.note },
        now,
      );
      return profileBody(await this.customers.profile(body.cityId, params.customerId, now));
    });
  }

  // «تسجيل الخروج من كل الأجهزة» (OWN, OPS, SUP; AP §9.8): after a lost or
  // sold phone. Active orders are untouched; a repeat ends nothing more.
  @Post(':customerId/sign-out-everywhere')
  @RequirePermission('customers.sign_out_everywhere')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomerSignedOutDto })
  signOutEverywhere(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminCustomerSignOutDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      await this.customers.checkCustomer(body.cityId, params.customerId);
      const sessionsEnded = await this.accounts.signOutEverywhere(
        accountAdminOf(session, request, body.cityId, body.note),
        params.customerId,
        new Date(),
      );
      return { sessionsEnded };
    });
  }

  // «توثيق» or «إزالة الثقة» (OWN, OPS). Answers the profile.
  @Post(':customerId/trust')
  @RequirePermission('customers.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomerDto })
  markTrust(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminMarkCustomerTrustDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      await this.customers.markTrust(
        adminOf(session, request),
        {
          cityId: body.cityId,
          accountId: params.customerId,
          trusted: body.trusted,
          note: body.note,
        },
        now,
      );
      return profileBody(await this.customers.profile(body.cityId, params.customerId, now));
    });
  }

  // «مسح المخالفات» (OWN, OPS, SUP), which ends an open review stop too.
  // Answers the profile. 409 nothing_to_clear.
  @Post(':customerId/clear-strikes')
  @RequirePermission('customers.clear_strikes')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomerDto })
  clearStrikes(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminClearCustomerStrikesDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      await this.customers.clearStrikes(
        adminOf(session, request),
        { cityId: body.cityId, accountId: params.customerId, note: body.note },
        now,
      );
      return profileBody(await this.customers.profile(body.cityId, params.customerId, now));
    });
  }

  // «إنهاء الإيقاف» (OWN, OPS, SUP). Answers the profile. 409 not_stopped.
  @Post(':customerId/end-review-stop')
  @RequirePermission('customers.clear_strikes')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomerDto })
  endReviewStop(
    @Param() params: AdminCustomerParamsDto,
    @Body() body: AdminEndCustomerReviewStopDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      await this.customers.endReviewStop(
        adminOf(session, request),
        {
          cityId: body.cityId,
          accountId: params.customerId,
          stopId: body.stopId,
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

function accountAdminOf(
  session: AdminSession,
  request: FastifyRequest,
  cityId: string,
  reason: string,
): CustomerAccountAdmin {
  const { actor, context } = adminOf(session, request);
  return { actor, context, cityId, reason };
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
    reviewStop: view.reviewStop && {
      id: view.reviewStop.id,
      startedAt: view.reviewStop.startedAt.toISOString(),
    },
    closed: view.closed && { ...view.closed, at: view.closed.at.toISOString() },
    linkedAccounts: view.linkedAccounts.map((account) => ({
      ...account,
      createdAt: account.createdAt.toISOString(),
      closedAt: account.closedAt?.toISOString() ?? null,
    })),
    trustMark: view.trustMark && markBody(view.trustMark),
    lateCancels: {
      ...view.lateCancels,
      cleared: view.lateCancels.cleared && markBody(view.lateCancels.cleared),
    },
    dues: { amount: view.dues.amount.toString(), currency: view.dues.currency },
    orders: {
      count: view.orders.count,
      spent: view.orders.spent.map((line) => ({ ...line, amount: line.amount.toString() })),
      last: view.orders.last && {
        ...view.orders.last,
        number: view.orders.last.number.toString(),
        placedAt: view.orders.last.placedAt.toISOString(),
      },
    },
    tickets: view.tickets.map((ticket) => ({
      ...ticket,
      number: ticket.number.toString(),
      orderNumber: ticket.orderNumber?.toString() ?? null,
      openedAt: ticket.openedAt.toISOString(),
    })),
    codes: view.codes.map((code) => ({
      ...code,
      discount: code.discount.toString(),
      heldAt: code.heldAt.toISOString(),
    })),
    addresses: view.addresses.map((address) => ({
      id: address.id,
      label: address.label,
      customLabel: address.customLabel,
      street: address.street,
      floor: address.floor,
      landmark: address.landmark,
      neighbourhood: address.neighbourhood,
      location: address.location,
      isDefault: address.isDefault,
      recipientName: address.recipientName,
      maskedContactPhone: address.contactPhone === null ? null : maskedPhone(address.contactPhone),
    })),
    notes: view.notes.map((note) => ({ ...note, createdAt: note.createdAt.toISOString() })),
    blocks: view.blocks.map((block) => ({
      ...block,
      until: block.until?.toISOString() ?? null,
      duesAmount: block.duesAmount?.toString() ?? null,
      startedAt: block.startedAt.toISOString(),
      endedAt: block.endedAt?.toISOString() ?? null,
    })),
  };
}

function markBody<T extends AdminMark>(mark: T) {
  return { ...mark, at: mark.at.toISOString() };
}

async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (error instanceof CustomerAccountRefusedError) {
      const body = (statusCode: number) => ({ statusCode, error: error.refusal });
      switch (error.refusal) {
        case 'invalid_phone':
          throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
        case 'unknown_customer':
          throw new NotFoundException(body(HttpStatus.NOT_FOUND));
        case 'phone_taken':
        case 'account_closed':
          throw new ConflictException(body(HttpStatus.CONFLICT));
      }
    }
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
      case 'not_stopped':
      case 'nothing_to_clear':
      case 'no_base_currency':
      case 'active_order':
      case 'account_closed':
        throw new ConflictException(body(HttpStatus.CONFLICT));
    }
  }
}
