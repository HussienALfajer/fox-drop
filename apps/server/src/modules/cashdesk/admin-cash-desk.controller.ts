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
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { CaptainsService, type Custody } from '../captains/index.js';
import { type AdminSession, CaptainAccountsService } from '../identity/index.js';
import {
  CashDeskRefusedError,
  CashDeskService,
  type DeskUser,
  type DrawerSession,
  type Receipt,
} from './cashdesk.service.js';
import { receiptTypes } from './schema.js';

const minor = z.string().regex(/^\d{1,18}$/);
const signedMinor = z.string().regex(/^-?\d{1,18}$/);
const currency = z.string().regex(/^[A-Z]{3}$/);
const money = z.object({ amount: signedMinor, currency });
const cashLines = z.array(z.object({ currency, amount: minor })).max(10);

const captainStatus = z.enum(['active', 'suspended', 'terminated']);

class AdminDeskCaptainSearchDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    q: z.string().trim().min(2).max(100).describe('A part of the name, or the number in E.164.'),
  }),
) {}

class AdminDeskCaptainsDto extends createZodDto(
  z.object({
    captains: z.array(z.object({ id: z.uuid(), name: z.string(), status: captainStatus })),
  }),
) {}

class AdminDeskCaptainParamsDto extends createZodDto(z.object({ captainId: z.uuid() })) {}

class AdminDeskCustodyDto extends createZodDto(
  z.object({
    id: z.uuid(),
    name: z.string(),
    status: captainStatus,
    usage: money,
    limit: money,
    closedDue: money.describe('Due from closed days, netted in the base currency (AP §8.5.4).'),
    lastCutoff: z.iso.datetime(),
    currencies: z.array(
      z.object({
        currency,
        balance: signedMinor.describe('+ the captain hands in, − the office owes them.'),
        closedDue: signedMinor,
        today: signedMinor,
        balanceInBase: signedMinor,
      }),
    ),
  }),
) {}

const sessionBody = z.object({
  id: z.uuid(),
  cityId: z.uuid(),
  adminAccountId: z.uuid(),
  adminName: z.string().nullable(),
  kind: z.enum(['office']),
  openedAt: z.iso.datetime(),
  closedAt: z.iso.datetime().nullable(),
  closeNote: z.string().nullable(),
  currencies: z.array(
    z.object({
      currency,
      openingFloat: minor,
      expected: signedMinor.describe('The float plus the cash moved; as at the close once closed.'),
      counted: minor.nullable(),
      variance: signedMinor.nullable(),
    }),
  ),
});

class AdminDrawerSessionDto extends createZodDto(sessionBody) {}

class AdminCurrentDrawerSessionQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminCurrentDrawerSessionDto extends createZodDto(
  z.object({
    session: sessionBody.nullable(),
    currencies: z
      .array(currency)
      .describe("The city's enabled currencies in display order: the float's fields."),
  }),
) {}

class AdminDrawerSessionsQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminDrawerSessionsDto extends createZodDto(z.object({ sessions: z.array(sessionBody) })) {}

class AdminOpenDrawerSessionDto extends createZodDto(
  z.object({ cityId: z.uuid(), floats: cashLines }),
) {}

class AdminDrawerSessionParamsDto extends createZodDto(z.object({ sessionId: z.uuid() })) {}

class AdminCloseDrawerSessionDto extends createZodDto(
  z.object({
    counted: cashLines,
    note: z.string().max(500).nullable().describe('Required when any currency has a variance.'),
  }),
) {}

class AdminHandInDto extends createZodDto(
  z.object({ captainId: z.uuid(), lines: cashLines.min(1) }),
) {}

const receiptBody = z.object({
  id: z.uuid(),
  cityId: z.uuid(),
  number: z.string().describe('Such as AZ-2026-000123 (AP §4.8).'),
  type: z.enum(receiptTypes),
  sessionId: z.uuid(),
  cashierId: z.uuid(),
  cashierName: z.string().nullable(),
  captainId: z.uuid(),
  captainName: z.string(),
  createdAt: z.iso.datetime(),
  lines: z.array(
    z.object({
      currency,
      expected: signedMinor.describe('The custody before, + to hand in, − owed to the captain.'),
      amount: minor,
      remaining: signedMinor.describe('What stays open after it.'),
    }),
  ),
});

class AdminReceiptDto extends createZodDto(receiptBody) {}

class AdminHandInReceiptsDto extends createZodDto(z.object({ receipts: z.array(receiptBody) })) {}

class AdminReceiptParamsDto extends createZodDto(z.object({ receiptId: z.uuid() })) {}

// A number as the desk types it: international (+ or 00), or the local
// Syrian 09… and Turkish 05… mobiles the captains sign in with.
export function phoneOf(text: string): string | null {
  const compact = text.replace(/[\s-]/g, '');
  if (/^(\+|00)\d{8,15}$/.test(compact)) return compact.replace(/^00/, '+');
  if (/^09\d{8}$/.test(compact)) return `+963${compact.slice(1)}`;
  if (/^05\d{9}$/.test(compact)) return `+90${compact.slice(1)}`;
  return null;
}

// AP §9.10.3 «الصندوق» (slice 2.17a): the drawer sessions and the daily
// hand-in, for OWN and FIN (AP §6.3 `cash_desk.record`).
@AdminController('cash-desk')
export class AdminCashDeskController {
  constructor(
    private readonly desk: CashDeskService,
    private readonly captains: CaptainsService,
    private readonly accounts: CaptainAccountsService,
  ) {}

  // Step 1: by a part of the name, or by the number. A read, sent as a POST
  // so a number never sits in a URL (access logs, history); it changes
  // nothing, so no Idempotency-Key.
  @Post('captains/search')
  @RequirePermission('cash_desk.record')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminDeskCaptainsDto })
  async findCaptains(@Body() query: AdminDeskCaptainSearchDto) {
    const phone = phoneOf(query.q);
    if (phone !== null) {
      const id = await this.accounts.captainByPhone(phone);
      const found = id ? await this.captains.captain(id, new Date()) : null;
      return {
        captains:
          found && found.cityId === query.cityId
            ? [{ id: found.id, name: found.name, status: found.status }]
            : [],
      };
    }
    const found = await this.captains.findByName(query.cityId, query.q, 20);
    return { captains: found.map(({ id, name, status }) => ({ id, name, status })) };
  }

  // Step 2: the custody per currency, split into closed days and today.
  @Get('captains/:captainId')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminDeskCustodyDto })
  async custody(@Param() params: AdminDeskCaptainParamsDto) {
    const found = await this.captains.deskCustody(params.captainId, new Date()).catch((error) => {
      if ((error as { refusal?: string }).refusal === 'unknown_captain') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_captain' });
      }
      throw error;
    });
    return { id: found.id, name: found.name, status: found.status, ...custodyBody(found.custody) };
  }

  // The user's open session, or null, and the city's currencies to count.
  @Get('sessions/current')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminCurrentDrawerSessionDto })
  async current(
    @Query() query: AdminCurrentDrawerSessionQueryDto,
    @CurrentAdminSession() session: AdminSession,
  ) {
    const [open, currencies] = await Promise.all([
      this.desk.openSessionOf(session.accountId),
      this.desk.deskCurrencies(query.cityId),
    ]);
    return { session: open && drawerBody(open), currencies };
  }

  // The city's sessions with their variances, newest first: every user's
  // for OWN, the user's own otherwise.
  @Get('sessions')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminDrawerSessionsDto })
  async sessions(
    @Query() query: AdminDrawerSessionsQueryDto,
    @CurrentAdminSession() session: AdminSession,
  ) {
    const sessions = await this.desk.sessions(
      query.cityId,
      session.roles.includes('OWN') ? null : session.accountId,
      50,
    );
    return { sessions: sessions.map(drawerBody) };
  }

  // «فتح الصندوق». A second open is refused 409 session_open, so it takes no
  // Idempotency-Key.
  @Post('sessions')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 201, type: AdminDrawerSessionDto })
  open(
    @Body() body: AdminOpenDrawerSessionDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      drawerBody(
        await this.desk.openSession(
          deskUser(session, request),
          body.cityId,
          body.floats.map(cashLine),
          new Date(),
        ),
      ),
    );
  }

  // «إقفال الصندوق». A repeat is refused 409 session_closed, so no key.
  @Post('sessions/:sessionId/close')
  @RequirePermission('cash_desk.record')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminDrawerSessionDto })
  close(
    @Param() params: AdminDrawerSessionParamsDto,
    @Body() body: AdminCloseDrawerSessionDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      drawerBody(
        await this.desk.closeSession(
          deskUser(session, request),
          params.sessionId,
          body.counted.map(cashLine),
          body.note,
          new Date(),
        ),
      ),
    );
  }

  // «تسليم النقد اليومي»: the receipts it issued, a hand-in and a
  // reimbursement apart. Refused 409 no_open_session, nothing_due,
  // above_custody; 404 unknown_captain.
  @Post('hand-ins')
  @RequirePermission('cash_desk.record')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminHandInReceiptsDto })
  handIn(
    @Body() body: AdminHandInDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const issued = await this.desk.handIn(
        deskUser(session, request),
        { captainId: body.captainId, lines: body.lines.map(cashLine), idempotencyKey },
        new Date(),
      );
      return { receipts: issued.map(receiptBodyOf) };
    });
  }

  // A receipt to show and print (80 mm or A4).
  @Get('receipts/:receiptId')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminReceiptDto })
  async receipt(@Param() params: AdminReceiptParamsDto) {
    const found = await this.desk.receipt(params.receiptId);
    if (!found) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_receipt' });
    }
    return receiptBodyOf(found);
  }
}

function deskUser(session: AdminSession, request: FastifyRequest): DeskUser {
  return {
    accountId: session.accountId,
    roles: session.roles,
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

function cashLine(line: { currency: string; amount: string }) {
  return { currency: line.currency, amount: BigInt(line.amount) };
}

function custodyBody(custody: Custody) {
  const moneyOf = (value: { amount: bigint; currency: string }) => ({
    amount: value.amount.toString(),
    currency: value.currency,
  });
  return {
    usage: moneyOf(custody.usage),
    limit: moneyOf(custody.limit),
    closedDue: moneyOf(custody.closedDue),
    lastCutoff: custody.lastCutoff.toISOString(),
    currencies: custody.currencies.map((line) => ({
      currency: line.currency,
      balance: line.balance.toString(),
      closedDue: line.closedDue.toString(),
      today: line.today.toString(),
      balanceInBase: line.balanceInBase.toString(),
    })),
  };
}

function drawerBody(session: DrawerSession) {
  return {
    id: session.id,
    cityId: session.cityId,
    adminAccountId: session.adminAccountId,
    adminName: session.adminName,
    kind: session.kind,
    openedAt: session.openedAt.toISOString(),
    closedAt: session.closedAt?.toISOString() ?? null,
    closeNote: session.closeNote,
    currencies: session.currencies.map((line) => ({
      currency: line.currency,
      openingFloat: line.openingFloat.toString(),
      expected: line.expected.toString(),
      counted: line.counted?.toString() ?? null,
      variance: line.variance?.toString() ?? null,
    })),
  };
}

function receiptBodyOf(receipt: Receipt) {
  return {
    id: receipt.id,
    cityId: receipt.cityId,
    number: receipt.number,
    type: receipt.type,
    sessionId: receipt.sessionId,
    cashierId: receipt.cashierId,
    cashierName: receipt.cashierName,
    captainId: receipt.captainId,
    captainName: receipt.captainName,
    createdAt: receipt.createdAt.toISOString(),
    lines: receipt.lines.map((line) => ({
      currency: line.currency,
      expected: line.expected.toString(),
      amount: line.amount.toString(),
      remaining: line.remaining.toString(),
    })),
  };
}

// The refusals as HTTP answers.
async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof CashDeskRefusedError)) throw error;
    const { refusal, message } = error;
    const body = (statusCode: number) => ({ statusCode, error: refusal, message });
    switch (refusal) {
      case 'unknown_session':
      case 'unknown_captain':
      case 'unknown_city':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'not_your_session':
        throw new ForbiddenException(body(HttpStatus.FORBIDDEN));
      case 'invalid_amounts':
      case 'note_required':
        throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException(body(HttpStatus.UNPROCESSABLE_ENTITY));
      default:
        throw new ConflictException(body(HttpStatus.CONFLICT));
    }
  }
}
