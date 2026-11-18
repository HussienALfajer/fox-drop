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
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { GeoService } from '../geo/index.js';
import { type AdminSession, AdminSessionsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { BannersService } from './banners.service.js';
import {
  MASS_PUSH_BODY_MAX,
  MASS_PUSH_INACTIVE_DAYS_MAX,
  MASS_PUSH_SCHEDULE_DAYS,
  MASS_PUSH_TITLE_MAX,
  type MassPush,
  type MassPushAudience,
  MassPushRefusedError,
  MassPushesService,
} from './mass-pushes.service.js';
import type { PromoChange } from './promo-codes.service.js';
import { massPushAudiences, massPushTargets } from './schema.js';

const audienceDescription =
  '`all` every registered customer; `zone` those with a saved address in zoneId; `inactive` those whose latest delivered order in the city is older than inactiveDays; `never_ordered` registered with no delivered order in the city.';
const targetDescription =
  '`home` the home screen; `restaurant` its page (restaurantId); `code` «أكوادي» on that code (codeId).';

const audienceFields = {
  audience: z.enum(massPushAudiences).describe(audienceDescription),
  zoneId: z.uuid().nullable(),
  inactiveDays: z.number().int().nullable().describe(`1 to ${MASS_PUSH_INACTIVE_DAYS_MAX}.`),
};

const massPushBody = z.object({
  id: z.uuid(),
  title: z.string(),
  body: z.string(),
  ...audienceFields,
  zoneName: z.string().nullable(),
  target: z.enum(massPushTargets).describe(targetDescription),
  restaurantId: z.uuid().nullable(),
  restaurantName: z.string().nullable(),
  codeId: z.uuid().nullable(),
  code: z.string().nullable(),
  scheduled: z.boolean().describe('False for «الآن»: sendAt is the confirmation.'),
  sendAt: z.iso.datetime(),
  status: z.enum(['scheduled', 'sent', 'cancelled']),
  recipients: z.number().int().describe('The audience confirmed.'),
  sent: z.number().int().describe('Accepted by FCM for a device.'),
  delivered: z.number().int().describe('Acknowledged by the app on arrival.'),
  sentBy: z.string().describe("The admin's name."),
  createdAt: z.iso.datetime(),
  cancelledBy: z.string().nullable(),
  cancelledAt: z.iso.datetime().nullable(),
});

class AdminMassPushesDto extends createZodDto(
  z.object({
    pushes: z.array(massPushBody).describe('The latest 100, newest first.'),
    restaurants: z
      .array(z.object({ id: z.uuid(), name: z.string() }))
      .describe("The city's restaurants a target picks from."),
    codes: z
      .array(z.object({ id: z.uuid(), code: z.string() }))
      .describe("The city's visible codes running now in its base currency, newest first."),
    zones: z.array(z.object({ id: z.uuid(), name: z.string() })).describe('The active zones.'),
    canManage: z.boolean().describe('Whether this admin may send (marketing.manage).'),
  }),
) {}

class AdminMassPushesQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminMassPushAudienceQueryDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    audience: z.enum(massPushAudiences),
    zoneId: z.uuid().optional(),
    inactiveDays: z.coerce.number().int().optional(),
  }),
) {}

class AdminMassPushAudienceDto extends createZodDto(
  z.object({ size: z.number().int().describe('The customers in the audience now.') }),
) {}

class AdminNewMassPushDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    title: z.string().max(200).describe(`Trimmed, 1 to ${MASS_PUSH_TITLE_MAX} characters.`),
    body: z.string().max(1000).describe(`Trimmed, 1 to ${MASS_PUSH_BODY_MAX} characters.`),
    ...audienceFields,
    target: z.enum(massPushTargets).describe(targetDescription),
    restaurantId: z.uuid().nullable(),
    codeId: z.uuid().nullable(),
    sendAt: z.iso
      .datetime()
      .nullable()
      .describe(`Null: now; else ahead, at most ${MASS_PUSH_SCHEDULE_DAYS} days.`),
    audienceSize: z
      .number()
      .int()
      .describe('The size the panel showed and the admin confirmed (GET …/audience).'),
  }),
) {}

class AdminMassPushCityDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminMassPushParamsDto extends createZodDto(z.object({ massPushId: z.uuid() })) {}

// AP §9.11.4 «الإشعارات الجماعية» (slice 2.27d, owner decisions
// 2026-11-18): OWN sends and cancels (marketing.manage), OPS reads
// (marketing.read). The create takes an Idempotency-Key; the cancellation
// names its target, so a repeat is refused.
@AdminController('mass-pushes')
export class AdminMassPushesController {
  constructor(
    private readonly pushes: MassPushesService,
    private readonly banners: BannersService,
    private readonly merchants: MerchantsService,
    private readonly geo: GeoService,
    private readonly sessions: AdminSessionsService,
  ) {}

  // 404 unknown_city.
  @Get()
  @RequireAnyPermission('marketing.read', 'marketing.manage')
  @ZodResponse({ status: 200, type: AdminMassPushesDto })
  list(@Query() query: AdminMassPushesQueryDto, @CurrentAdminSession() session: AdminSession) {
    return refusalsAsHttp(async () => {
      await this.pushes.checkCity(query.cityId);
      const now = new Date();
      return this.answer(query.cityId, session, await this.pushes.list(query.cityId, now));
    });
  }

  // The audience's size now, shown before the confirmation. 400
  // invalid_mass_push; 404 unknown_city.
  @Get('audience')
  @RequirePermission('marketing.manage')
  @ZodResponse({ status: 200, type: AdminMassPushAudienceDto })
  audience(@Query() query: AdminMassPushAudienceQueryDto) {
    return refusalsAsHttp(async () => ({
      size: await this.pushes.audienceSize(query.cityId, audienceOf(query), new Date()),
    }));
  }

  // Sends now or at its time. 400 invalid_mass_push (with the rule broken);
  // 404 unknown_city; 409 audience_changed (the size now in the message),
  // audience_empty; 422 idempotency_key_reused.
  @Post()
  @RequirePermission('marketing.manage')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminMassPushesDto })
  create(
    @Body() body: AdminNewMassPushDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const now = new Date();
      const pushes = await this.pushes.create(
        body.cityId,
        {
          title: body.title,
          body: body.body,
          audience: audienceOf(body),
          target: body.target,
          restaurantId: body.restaurantId,
          codeId: body.codeId,
          sendAt: body.sendAt === null ? null : new Date(body.sendAt),
        },
        body.audienceSize,
        idempotencyKey,
        changeOf(session, request),
        now,
      );
      return this.answer(body.cityId, session, pushes);
    });
  }

  // A scheduled push before its time. 404 unknown_mass_push; 409
  // not_cancellable.
  @Post(':massPushId/cancel')
  @RequirePermission('marketing.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminMassPushesDto })
  cancel(
    @Param() params: AdminMassPushParamsDto,
    @Body() body: AdminMassPushCityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.pushes.cancel(body.cityId, params.massPushId, changeOf(session, request)),
      ),
    );
  }

  private async answer(cityId: string, session: AdminSession, pushes: MassPush[]) {
    const [restaurants, codes, zones, names] = await Promise.all([
      this.merchants.restaurantIds(cityId),
      this.banners.codeChoices(cityId),
      this.geo.zones(cityId),
      this.sessions.names([
        ...new Set(pushes.flatMap((push) => [push.createdBy, push.cancelledBy ?? []].flat())),
      ]),
    ]);
    const zoneNames = new Map(zones.map((zone) => [zone.id, zone.name]));
    const restaurantNames = new Map(restaurants.map((each) => [each.id, each.nameAr]));
    return {
      pushes: pushes.map((push) => ({
        id: push.id,
        title: push.title,
        body: push.body,
        audience: push.audience.kind,
        zoneId: push.audience.zoneId,
        inactiveDays: push.audience.inactiveDays,
        zoneName:
          push.audience.zoneId === null ? null : (zoneNames.get(push.audience.zoneId) ?? null),
        target: push.target,
        restaurantId: push.restaurantId,
        restaurantName:
          push.restaurantId === null ? null : (restaurantNames.get(push.restaurantId) ?? null),
        codeId: push.codeId,
        code: push.code,
        scheduled: push.scheduled,
        sendAt: push.sendAt.toISOString(),
        status: push.status,
        recipients: push.recipients,
        sent: push.sent,
        delivered: push.delivered,
        sentBy: names.get(push.createdBy) ?? '',
        createdAt: push.createdAt.toISOString(),
        cancelledBy: push.cancelledBy === null ? null : (names.get(push.cancelledBy) ?? ''),
        cancelledAt: push.cancelledAt?.toISOString() ?? null,
      })),
      restaurants: restaurants.map(({ id, nameAr }) => ({ id, name: nameAr })),
      codes,
      zones: zones.filter((zone) => zone.active).map(({ id, name }) => ({ id, name })),
      canManage: session.permissions.includes('marketing.manage'),
    };
  }
}

function audienceOf(fields: {
  audience: MassPushAudience['kind'];
  zoneId?: string | null | undefined;
  inactiveDays?: number | null | undefined;
}): MassPushAudience {
  return {
    kind: fields.audience,
    zoneId: fields.zoneId ?? null,
    inactiveDays: fields.inactiveDays ?? null,
  };
}

function changeOf(session: AdminSession, request: FastifyRequest): PromoChange {
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
    if (!(error instanceof MassPushRefusedError)) throw error;
    const body = (statusCode: number) => ({
      statusCode,
      error: error.refusal,
      message: error.message,
    });
    switch (error.refusal) {
      case 'invalid_mass_push':
        throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
      case 'unknown_city':
      case 'unknown_mass_push':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'audience_changed':
      case 'audience_empty':
      case 'not_cancellable':
        throw new ConflictException(body(HttpStatus.CONFLICT));
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException(body(HttpStatus.UNPROCESSABLE_ENTITY));
    }
  }
}
