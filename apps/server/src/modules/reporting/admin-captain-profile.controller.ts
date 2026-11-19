import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  Inject,
  NotFoundException,
  Param,
  Post,
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { AuditService } from '../audit/index.js';
import {
  ApplicationPipelineService,
  CAPTAIN_NOTE_MAX,
  CaptainNoteKeyReusedError,
  CaptainNotesService,
  CaptainsRefusedError,
  CaptainsService,
  type Money,
} from '../captains/index.js';
import { EarningsService, type EarningsWindow } from '../cashdesk/index.js';
import { NotificationTexts } from '../content/index.js';
import { DispatchService } from '../dispatch/index.js';
import { GeoService } from '../geo/index.js';
import {
  type AdminSession,
  AdminSessionsService,
  CaptainAccountsService,
} from '../identity/index.js';
import { PushQueue } from '../notifications/index.js';
import { CaptainFiguresService, OrdersService } from '../ordering/index.js';
import { SettingsService } from '../settings/index.js';
import { CHANGE_LOG_LIMIT } from './admin-restaurant-profile.controller.js';
import { CaptainListService, listedCaptainStatuses, listedStatus } from './captain-list.service.js';

// «سجل العروض» shows as many, newest first (decided by us).
export const OFFER_LOG_LIMIT = 200;

// CA §14 #24: operations' direct message, at most this long (decided by us).
export const CAPTAIN_MESSAGE_MAX = 300;

const minor = z.string().regex(/^-?\d{1,18}$/);
const money = z.object({ amount: minor, currency: z.string().length(3) });
const moneyOf = (value: Money) => ({ amount: value.amount.toString(), currency: value.currency });
const status = z.enum(listedCaptainStatuses);
const phase = z.enum(['probation', 'commitment', 'open']).nullable();
const acceptance = z
  .object({ accepted: z.int(), answered: z.int() })
  .nullable()
  .describe('Of the last captain.acceptance_window_offers answered; null without one.');
const onTime = z
  .object({ onTime: z.int(), counted: z.int() })
  .describe('Of the last 50 delivered: those at or before the promised time.');
const rating = z.object({ count: z.int(), average: z.number() }).nullable();

class AdminCaptainListQueryDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    status: status.nullable().describe('Only this listed status; null for every one.'),
    q: z
      .string()
      .trim()
      .min(1)
      .max(60)
      .nullable()
      .describe('A part of the name, or the sign-in number (E.164, 00…, 09…, 05…).'),
  }),
) {}

class AdminCaptainListDto extends createZodDto(
  z.object({
    captains: z
      .array(
        z.object({
          id: z.uuid(),
          name: z.string(),
          maskedPhone: z.string().nullable(),
          vehicle: z.string(),
          plateNumber: z.string().nullable(),
          status,
          applicationId: z.uuid().nullable(),
          contractPhase: phase,
          custody: z.object({
            usage: money.describe('The positive positions at current rates, in the base.'),
            limit: money,
            closedDue: money,
          }),
          earnings: money.describe('+ the platform owes the captain.'),
          ordersToday: z.int(),
          acceptance,
          ratingAverage: z.number().nullable(),
          ratingCount: z.int(),
        }),
      )
      .describe('By name.'),
  }),
) {}

class AdminCaptainProfileParamsDto extends createZodDto(z.object({ captainId: z.uuid() })) {}

const window = z.object({
  from: z.iso.datetime(),
  earnings: minor,
  orders: z.int(),
  onlineMinutes: z.int(),
});

class AdminCaptainProfileDto extends createZodDto(
  z.object({
    id: z.uuid(),
    cityId: z.uuid(),
    name: z.string(),
    phone: z
      .string()
      .nullable()
      .describe('In full for captains.manage (each view audited), masked otherwise.'),
    vehicle: z.string(),
    plateNumber: z.string().nullable(),
    status,
    suspension: z
      .object({ reason: z.string(), until: z.iso.datetime().nullable() })
      .nullable()
      .describe('Running now; null otherwise.'),
    applicationId: z.uuid().nullable().describe("The captain's file; null for a seeded one."),
    contractPhase: phase,
    custody: z.object({
      usage: money,
      limit: money,
      closedDue: money,
      currencies: z.array(
        z.object({
          currency: z.string().length(3),
          balance: minor.describe('+ the captain must hand in, − the office owes them.'),
          closedDue: minor,
          today: minor,
          balanceInBase: minor,
        }),
      ),
      blocks: z.array(z.enum(['closed_due', 'cash_limit'])),
      handInGraceUntil: z.iso.datetime().nullable(),
    }),
    earnings: z.object({
      currency: z.string().length(3),
      balance: minor,
      today: window,
      week: window.describe('The payout week.'),
      month: window.describe('From the business day on the first of the month.'),
    }),
    ordersToday: z.int(),
    delivered: z.int(),
    onTime,
    cancellations: z
      .int()
      .describe('Captain cancellations within captain.violation_window_days (AP §9.7.6).'),
    acceptance,
    rating,
    app: z.object({
      maxPickup: money.nullable().describe('«أقصى مبلغ أحمله»; null for no limit.'),
      maxPickupAnswered: z.boolean(),
      carriedCurrencies: z.array(z.string().length(3)),
      expiredInRow: z.int().describe('The latest answered offers that expired in a row.'),
    }),
  }),
) {}

class AdminCaptainOffersDto extends createZodDto(
  z.object({
    offers: z
      .array(
        z.object({
          id: z.uuid(),
          orderId: z.uuid(),
          orderNumber: z.string().nullable(),
          kind: z.enum(['manual', 'auto']),
          handover: z.boolean(),
          offeredAt: z.iso.datetime(),
          status: z.enum(['open', 'accepted', 'declined', 'expired', 'withdrawn']),
          respondedAt: z.iso.datetime().nullable(),
          responseSeconds: z.int().nullable().describe('From the offer to the response.'),
        }),
      )
      .describe(`The latest ${OFFER_LOG_LIMIT}, newest first.`),
  }),
) {}

class AdminCaptainNotesDto extends createZodDto(
  z.object({
    notes: z
      .array(
        z.object({
          id: z.uuid(),
          body: z.string(),
          authorName: z.string().nullable(),
          createdAt: z.iso.datetime(),
        }),
      )
      .describe('Newest first.'),
  }),
) {}

class AdminAddCaptainNoteDto extends createZodDto(
  z.object({ body: z.string().trim().min(1).max(CAPTAIN_NOTE_MAX) }),
) {}

class AdminCaptainMessageDto extends createZodDto(
  z.object({ text: z.string().trim().min(1).max(CAPTAIN_MESSAGE_MAX) }),
) {}

class AdminCaptainMessageSentDto extends createZodDto(z.object({ sent: z.literal(true) })) {}

class AdminCaptainChangeLogDto extends createZodDto(
  z.object({
    entries: z
      .array(
        z.object({
          id: z.uuid(),
          at: z.iso.datetime(),
          action: z.string().describe('The audit action, such as captain.status.'),
          actorType: z.enum(['admin', 'merchant', 'captain', 'customer', 'system']),
          actorName: z.string().nullable().describe('The admin; null for the others.'),
          actorRole: z.string().nullable(),
          changes: z.array(
            z.object({
              field: z.string(),
              before: z.string().nullable().describe('The value as JSON; null for none.'),
              after: z.string().nullable(),
            }),
          ),
          reason: z.string().nullable(),
        }),
      )
      .describe(`The latest ${CHANGE_LOG_LIMIT} changes, newest first.`),
  }),
) {}

const json = (value: unknown) =>
  value === null || value === undefined ? null : JSON.stringify(value);

const windowOf = (each: EarningsWindow) => ({
  from: each.from.toISOString(),
  earnings: each.earnings.toString(),
  orders: each.orders,
  onlineMinutes: each.onlineMinutes,
});

function maskedPhone(phone: string): string {
  const code = phone.startsWith('+90') ? '+90' : phone.startsWith('+963') ? '+963' : '+';
  return `${code} ••• ${phone.slice(-3)}`;
}

// AP §9.7.3 «الكباتن» (slice 2.36a): the city's captains with the list's
// columns. A read sent as a POST, so a number searched never sits in a URL
// (as the restaurants' list); no key. 404 unknown_city.
@AdminController('captain-list')
export class AdminCaptainListController {
  constructor(
    private readonly list: CaptainListService,
    private readonly geo: GeoService,
  ) {}

  @Post()
  @RequireAnyPermission('captains.read', 'captains.money')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCaptainListDto })
  async captainList(@Body() body: AdminCaptainListQueryDto) {
    if ((await this.geo.cityTimeZone(body.cityId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
    const captains = await this.list.list(
      body.cityId,
      { status: body.status, q: body.q },
      new Date(),
    );
    return {
      captains: captains.map((captain) => ({
        id: captain.id,
        name: captain.name,
        maskedPhone: captain.phone === null ? null : maskedPhone(captain.phone),
        vehicle: captain.vehicle,
        plateNumber: captain.plateNumber,
        status: captain.status,
        applicationId: captain.applicationId,
        contractPhase: captain.contractPhase,
        custody: {
          usage: moneyOf(captain.custody.usage),
          limit: moneyOf(captain.custody.limit),
          closedDue: moneyOf(captain.custody.closedDue),
        },
        earnings: moneyOf(captain.earnings),
        ordersToday: captain.ordersToday,
        acceptance: captain.acceptance,
        ratingAverage:
          captain.rating === null ? null : Math.round(captain.rating.average * 10) / 10,
        ratingCount: captain.rating?.count ?? 0,
      })),
    };
  }
}

// AP §9.7.4 «ملف الكابتن» (slice 2.36a): the profile's overview and «التطبيق», «سجل العروض», «ملاحظات» (any reader adds
// one, as the restaurants'), «سجل التغييرات», and the message or push of
// AP §9.7.5 (captains.manage). Reads need captains.read or captains.money
// (FIN reads captains' money, AP §6.2).
@AdminController('captains')
export class AdminCaptainProfileController {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly captains: CaptainsService,
    private readonly pipeline: ApplicationPipelineService,
    private readonly notes: CaptainNotesService,
    private readonly figures: CaptainFiguresService,
    private readonly earnings: EarningsService,
    private readonly dispatch: DispatchService,
    private readonly orders: OrdersService,
    private readonly accounts: CaptainAccountsService,
    private readonly admins: AdminSessionsService,
    private readonly audit: AuditService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  // «نظرة عامة» and «التطبيق». 404 unknown_captain.
  @Get(':captainId/profile')
  @RequireAnyPermission('captains.read', 'captains.money')
  @ZodResponse({ status: 200, type: AdminCaptainProfileDto })
  async profile(
    @Param() params: AdminCaptainProfileParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const now = new Date();
    const captain = await this.found(params.captainId, now);
    const { cityId } = captain;
    const [balance, state, files, figures, earnings, window, phone, carried, maxPickup] =
      await Promise.all([
        this.captains.balance(captain.id, now),
        captain.status === 'terminated' ? null : this.captains.state(captain.id, now),
        this.pipeline.captainFiles(cityId, now),
        this.figures.ofCaptains(cityId, [captain.id], now),
        this.earnings.overview(captain.id, now),
        this.settings.get('captain.acceptance_window_offers', { cityId }),
        this.accounts.phone(captain.id),
        this.captains.carriedCurrencies(captain.id),
        this.captains.maxPickup(captain.id),
      ]);
    const [acceptance, latest] = await Promise.all([
      this.dispatch.acceptance([captain.id], window),
      this.dispatch.captainOffers(captain.id, window),
    ]);
    const answered = latest.filter(
      (offer) => offer.status !== 'open' && offer.status !== 'withdrawn',
    );
    const firstNotExpired = answered.findIndex((offer) => offer.status !== 'expired');
    const full = phone !== null && session.permissions.includes('captains.manage');
    if (full) {
      await this.audit.recordView({
        actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
        context: requestContext(request),
        cityId,
        action: 'captain.phone_view',
        target: { type: 'captain', id: captain.id },
      });
    }
    const file = files.get(captain.id) ?? null;
    const own = figures.get(captain.id)!;
    const suspended = state?.availability.state === 'suspended' ? state.availability : null;
    return {
      id: captain.id,
      cityId,
      name: captain.name,
      phone: phone === null ? null : full ? phone : maskedPhone(phone),
      vehicle: captain.vehicle,
      plateNumber: captain.plateNumber,
      status: listedStatus(balance!, state?.availability.state ?? null),
      suspension:
        suspended === null
          ? null
          : { reason: suspended.reason, until: suspended.until?.toISOString() ?? null },
      applicationId: file?.applicationId ?? null,
      contractPhase: file?.phase ?? null,
      custody: {
        usage: moneyOf(balance!.custody.usage),
        limit: moneyOf(balance!.custody.limit),
        closedDue: moneyOf(balance!.custody.closedDue),
        currencies: balance!.custody.currencies.map((line) => ({
          currency: line.currency,
          balance: line.balance.toString(),
          closedDue: line.closedDue.toString(),
          today: line.today.toString(),
          balanceInBase: line.balanceInBase.toString(),
        })),
        blocks: balance!.blocks,
        handInGraceUntil: balance!.handInGrace?.until.toISOString() ?? null,
      },
      earnings: {
        currency: earnings.currency,
        balance: earnings.balance.toString(),
        today: windowOf(earnings.today),
        week: windowOf(earnings.week),
        month: windowOf(earnings.month),
      },
      ordersToday: own.ordersToday,
      delivered: own.delivered,
      onTime: own.onTime,
      cancellations: own.cancellations,
      acceptance: acceptance.get(captain.id) ?? null,
      rating: own.rating,
      app: {
        maxPickup: maxPickup.limit === null ? null : moneyOf(maxPickup.limit),
        maxPickupAnswered: maxPickup.answered,
        carriedCurrencies: carried.carried,
        expiredInRow: firstNotExpired === -1 ? answered.length : firstNotExpired,
      },
    };
  }

  // «سجل العروض» (AP §9.7.4): every offer with the order, the response and
  // the response time. 404 unknown_captain.
  @Get(':captainId/offers')
  @RequireAnyPermission('captains.read', 'captains.money')
  @ZodResponse({ status: 200, type: AdminCaptainOffersDto })
  async offers(@Param() params: AdminCaptainProfileParamsDto) {
    await this.found(params.captainId, new Date());
    const offers = await this.dispatch.captainOffers(params.captainId, OFFER_LOG_LIMIT);
    const numbers = await this.orders.orderNumbers(offers.map((offer) => offer.orderId));
    return {
      offers: offers.map((offer) => ({
        id: offer.id,
        orderId: offer.orderId,
        orderNumber: numbers.get(offer.orderId)?.toString() ?? null,
        kind: offer.kind,
        handover: offer.handover,
        offeredAt: offer.offeredAt.toISOString(),
        status: offer.status,
        respondedAt: offer.respondedAt?.toISOString() ?? null,
        responseSeconds:
          offer.respondedAt === null
            ? null
            : Math.round((offer.respondedAt.getTime() - offer.offeredAt.getTime()) / 1000),
      })),
    };
  }

  @Get(':captainId/notes')
  @RequireAnyPermission('captains.read', 'captains.money')
  @ZodResponse({ status: 200, type: AdminCaptainNotesDto })
  async listNotes(@Param() params: AdminCaptainProfileParamsDto) {
    await this.found(params.captainId, new Date());
    return this.notesAnswer(params.captainId);
  }

  // Idempotency-Key; 422 idempotency_key_reused; 404 unknown_captain.
  @Post(':captainId/notes')
  @RequireAnyPermission('captains.read', 'captains.money')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminCaptainNotesDto })
  async addNote(
    @Param() params: AdminCaptainProfileParamsDto,
    @Body() body: AdminAddCaptainNoteDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.notes.add(
        params.captainId,
        { body: body.body, idempotencyKey },
        {
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
        },
      );
    } catch (error) {
      if (error instanceof CaptainNoteKeyReusedError) {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: 'idempotency_key_reused',
        });
      }
      if (error instanceof CaptainsRefusedError && error.refusal === 'unknown_captain') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      if (error instanceof CaptainsRefusedError) {
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
      }
      throw error;
    }
    return this.notesAnswer(params.captainId);
  }

  // «سجل التغييرات»: the audit log's writes on the captain and on every
  // application that became it (the pipeline's steps, the offboarding).
  // 404 unknown_captain.
  @Get(':captainId/change-log')
  @RequireAnyPermission('captains.read', 'captains.money')
  @ZodResponse({ status: 200, type: AdminCaptainChangeLogDto })
  async changeLog(@Param() params: AdminCaptainProfileParamsDto) {
    await this.found(params.captainId, new Date());
    const entries = await this.audit.history(
      [
        { type: 'captain', ids: [params.captainId] },
        { type: 'captain_application', ids: await this.pipeline.applicationIds(params.captainId) },
      ],
      CHANGE_LOG_LIMIT,
    );
    const admins = await this.admins.names(
      entries.flatMap((entry) =>
        entry.actor.type === 'admin' && entry.actor.id !== null ? [entry.actor.id] : [],
      ),
    );
    return {
      entries: entries.map((entry) => ({
        id: entry.id,
        at: entry.occurredAt.toISOString(),
        action: entry.action,
        actorType: entry.actor.type,
        actorName:
          entry.actor.type === 'admin' && entry.actor.id !== null
            ? (admins.get(entry.actor.id) ?? null)
            : null,
        actorRole: entry.actor.role,
        changes: Object.entries(entry.changes ?? {}).map(([field, change]) => ({
          field,
          before: json(change.before),
          after: json(change.after),
        })),
        reason: entry.reason,
      })),
    };
  }

  // AP §9.7.5 «Message or push», CA §14 #24: the text as typed, with the
  // chime, audited without the text (it may hold a number). The
  // Idempotency-Key names the push (per admin), so a retry queues none. 404
  // unknown_captain; 409 captain_terminated.
  @Post(':captainId/message')
  @RequirePermission('captains.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCaptainMessageSentDto })
  async message(
    @Param() params: AdminCaptainProfileParamsDto,
    @Body() body: AdminCaptainMessageDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const now = new Date();
    const captain = await this.found(params.captainId, now);
    if (captain.status === 'terminated') {
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: 'captain_terminated' });
    }
    const templateKey = 'captain.message';
    await this.database.db.transaction(async (tx) => {
      const rendered = await this.texts.render(templateKey, { الرسالة: body.text }, tx);
      await this.pushes.enqueue(
        tx,
        [
          {
            source: `captain:${templateKey}:${session.accountId}:${idempotencyKey}`,
            recipient: { party: 'captain', captainId: captain.id },
            templateKey,
            body: rendered.body,
            level: rendered.level,
            priority: rendered.priority,
            data: { type: 'captain.message' },
            at: now,
          },
        ],
        now,
      );
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
          cityId: captain.cityId,
          action: 'captain.message',
          target: { type: 'captain', id: captain.id },
          before: null,
          after: { length: body.text.length },
        },
        tx,
      );
    });
    return { sent: true as const };
  }

  private async notesAnswer(captainId: string) {
    const notes = await this.notes.notes(captainId);
    const names = await this.admins.names(notes.map((note) => note.authorId));
    return {
      notes: notes.map((note) => ({
        id: note.id,
        body: note.body,
        authorName: names.get(note.authorId) ?? null,
        createdAt: note.createdAt.toISOString(),
      })),
    };
  }

  private async found(captainId: string, now: Date) {
    const captain = await this.captains.captain(captainId, now);
    if (captain === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_captain' });
    }
    return captain;
  }
}
