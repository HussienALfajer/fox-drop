import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Post,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import {
  AppSignedIn,
  CurrentAdminSession,
  CurrentAppSession,
  Public,
  RequirePermission,
  SignedIn,
} from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import {
  AdminController,
  CaptainController,
  CustomerController,
  MerchantController,
} from '../../http/route-groups.js';
import { CaptainsService } from '../captains/index.js';
import { pointQuery } from '../customers/index.js';
import { GeoService } from '../geo/index.js';
import type { AdminSession, AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  delayNoticeText,
  type EmergencyStop,
  EmergencyStopRefusedError,
  EmergencyStops,
  type EmergencyStopView,
} from './emergency-stop.js';

// What the dialog's texts take (AP §9.1.6).
const message = z.string().trim().min(1).max(500);

const stop = z.object({
  id: z.uuid(),
  startedAt: z.iso.datetime(),
  startedBy: z.uuid(),
  internalReason: z.string(),
  browseMessage: z.string(),
  delayNotice: z.string().describe('With its {السبب} placeholder.'),
  customerReason: z.string(),
  resumeAt: z.iso.datetime().nullable().describe('The automatic resume, if set.'),
  attempts: z
    .int()
    .describe('Customers who opened checkout during the stop, each once (AP §9.1.6 item 4).'),
});

class AdminEmergencyStopQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminEmergencyStopStateDto extends createZodDto(
  z.object({
    stop: stop.nullable().describe('The open stop: the red bar (AP §7); null while running.'),
    defaults: z
      .object({ browseMessage: z.string(), delayNotice: z.string() })
      .describe('The dialog prefills (AP Appendix A).'),
  }),
) {}

class AdminStartEmergencyStopDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    internalReason: message,
    browseMessage: message,
    delayNotice: message,
    customerReason: message.describe('Fills {السبب}, such as «سوء الأحوال الجوية».'),
    resumeAt: z.iso.datetime().nullable().describe('An optional automatic resume time.'),
  }),
) {}

class AdminEmergencyStopDto extends createZodDto(z.object({ stop })) {}

class AdminResumeEmergencyStopDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    stopId: z.uuid().describe('The stop the panel shows, so a resume never ends a newer one.'),
    serviceBack: message
      .nullable()
      .describe(
        '«الخدمة عادت» (CU §14 #19), to the customers who tried to order; null sends none.',
      ),
  }),
) {}

class AdminEmergencyStopResumedDto extends createZodDto(z.object({ resumed: z.literal(true) })) {}

const appStop = z.object({
  active: z.boolean(),
  startedAt: z.iso.datetime().nullable(),
});

class CustomerEmergencyStopDto extends createZodDto(
  appStop.extend({
    browseMessage: z.string().nullable().describe('The banner while browsing (CU §4.7).'),
    delayNotice: z
      .string()
      .nullable()
      .describe('The banner on an active order (CU §11.6), its reason filled in.'),
  }),
) {}

class CustomerEmergencyStopQueryDto extends createZodDto(pointQuery) {}

class MerchantEmergencyStopDto extends createZodDto(appStop) {}

class CaptainEmergencyStopDto extends createZodDto(appStop) {}

function stopBody(view: EmergencyStopView) {
  return {
    ...view,
    startedAt: view.startedAt.toISOString(),
    resumeAt: view.resumeAt?.toISOString() ?? null,
  };
}

function appBody(active: EmergencyStop | null) {
  return { active: active !== null, startedAt: active?.startedAt.toISOString() ?? null };
}

function refusalAsHttp(error: unknown): never {
  if (!(error instanceof EmergencyStopRefusedError)) throw error;
  const body = { error: error.refusal };
  if (error.refusal === 'resume_at_past') {
    throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
  }
  if (error.refusal === 'unknown_stop') {
    throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
  }
  throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
}

// AP §9.1.6 «الإيقاف الطارئ» (D7). Every panel user sees the bar; OWN and
// OPS start and end it (emergency_stop.toggle). Starting while one is on is
// refused and resuming names the stop, so neither needs an Idempotency-Key.
@AdminController('emergency-stop')
export class AdminEmergencyStopController {
  constructor(private readonly stops: EmergencyStops) {}

  @Get()
  @SignedIn()
  @ZodResponse({ status: 200, type: AdminEmergencyStopStateDto })
  async state(@Query() query: AdminEmergencyStopQueryDto) {
    const [current, defaults] = await Promise.all([
      this.stops.current(query.cityId),
      this.stops.defaults(query.cityId),
    ]);
    return { stop: current === null ? null : stopBody(current), defaults };
  }

  // 409 already_stopped; 400 resume_at_past.
  @Post()
  @RequirePermission('emergency_stop.toggle')
  @HttpCode(201)
  @ZodResponse({ status: 201, type: AdminEmergencyStopDto })
  async start(
    @Body() body: AdminStartEmergencyStopDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      const started = await this.stops.start(
        {
          ...body,
          resumeAt: body.resumeAt === null ? null : new Date(body.resumeAt),
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
        },
        new Date(),
      );
      return { stop: stopBody(started) };
    } catch (error) {
      refusalAsHttp(error);
    }
  }

  // «استئناف». 404 unknown_stop; 409 stop_ended.
  @Post('resume')
  @RequirePermission('emergency_stop.toggle')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminEmergencyStopResumedDto })
  async resume(
    @Body() body: AdminResumeEmergencyStopDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.stops.resume(
        {
          ...body,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
        },
        new Date(),
      );
      return { resumed: true as const };
    } catch (error) {
      refusalAsHttp(error);
    }
  }
}

// CU §4.7: the stop at the selected point's city, open to guests, since the
// app knows no city (GeoService.locate). Outside every city: no stop.
@CustomerController('emergency-stop')
export class CustomerEmergencyStopController {
  constructor(
    private readonly stops: EmergencyStops,
    private readonly geo: GeoService,
  ) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: CustomerEmergencyStopDto })
  async read(@Query() query: CustomerEmergencyStopQueryDto) {
    const city = await this.geo.locate(query);
    const active = city === null ? null : await this.stops.active(city.cityId);
    return {
      ...appBody(active),
      browseMessage: active?.browseMessage ?? null,
      delayNotice: active === null ? null : delayNoticeText(active),
    };
  }
}

// RA §8.17: the stop of the restaurant's city, read again on each broadcast
// and on connecting.
@MerchantController('emergency-stop')
export class MerchantEmergencyStopController {
  constructor(
    private readonly stops: EmergencyStops,
    private readonly merchants: MerchantsService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantEmergencyStopDto })
  async read(@CurrentAppSession() session: AppSession) {
    const restaurantId = session.merchant?.restaurantId;
    const restaurant = restaurantId ? await this.merchants.restaurant(restaurantId) : null;
    return appBody(restaurant === null ? null : await this.stops.active(restaurant.cityId));
  }
}

// CA §6.3: the stop of the captain's city, read again on each broadcast and
// on connecting.
@CaptainController('emergency-stop')
export class CaptainEmergencyStopController {
  constructor(
    private readonly stops: EmergencyStops,
    private readonly captains: CaptainsService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainEmergencyStopDto })
  async read(@CurrentAppSession() session: AppSession) {
    const captainId = session.captain?.captainId;
    const captain = captainId ? await this.captains.captain(captainId, new Date()) : null;
    return appBody(captain === null ? null : await this.stops.active(captain.cityId));
  }
}
