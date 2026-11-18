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
  Put,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import {
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  SORT_WEIGHT_MAX,
} from './merchants.service.js';

const instant = z.iso.datetime();
const reason = z.string().trim().min(1).max(500).describe('Why, for the change log (AP §9.6.5).');

const adminRestaurantAccountSchema = z.object({
  nameAr: z.string(),
  accountStatus: z.enum(['draft', 'test', 'active', 'suspended', 'terminated']),
  suspensionReason: z.string().nullable().describe('The latest suspension’s, while suspended.'),
  visible: z
    .boolean()
    .describe('«إخفاء أو إظهار»: customers see an active restaurant only while visible.'),
  sortWeight: z.int().describe('«تثبيت»: the higher first in the customers’ lists.'),
  sortWeightMax: z.int(),
  commissionBp: z.int().nullable().describe('The commission in force now, in basis points.'),
  nextCommission: z
    .object({ rateBp: z.int(), from: instant })
    .nullable()
    .describe('The next version, scheduled after now.'),
  commissionHistory: z
    .array(
      z.object({
        id: z.uuid(),
        rateBp: z.int(),
        from: instant,
        reason: z.string().nullable(),
        setAt: instant,
        byAdmin: z.boolean().describe('Set from the panel; false for the system or the seed.'),
      }),
    )
    .describe('Every version not withdrawn, the latest start first (D16).'),
});

class AdminRestaurantActionsDto extends createZodDto(adminRestaurantAccountSchema) {}

class AdminRestaurantActionParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminRestaurantReasonDto extends createZodDto(z.object({ reason })) {}

class AdminRestaurantVisibilityDto extends createZodDto(z.object({ visible: z.boolean() })) {}

class AdminRestaurantSortWeightDto extends createZodDto(
  z.object({ sortWeight: z.int().describe(`0 to ${SORT_WEIGHT_MAX}, the higher first.`) }),
) {}

class AdminRestaurantCommissionDto extends createZodDto(
  z.object({
    rateBp: z.int().describe('Basis points of the items value: 1500 is 15%.'),
    effectiveFrom: instant.nullable().describe('A later moment; null for the new orders from now.'),
    reason,
  }),
) {}

function adminChange(
  session: AdminSession,
  request: FastifyRequest,
  why: string | null = null,
): MerchantChange {
  return {
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
    reason: why,
  };
}

async function answer(run: () => Promise<void>): Promise<void> {
  try {
    await run();
  } catch (error) {
    if (!(error instanceof MerchantsRefusedError)) throw error;
    const body = (status: number) => ({ statusCode: status, error: error.refusal });
    switch (error.refusal) {
      case 'unknown_restaurant':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'restaurant_terminated':
        throw new ForbiddenException(body(HttpStatus.FORBIDDEN));
      case 'status_change_not_allowed':
      case 'not_a_draft':
        throw new ConflictException(body(HttpStatus.CONFLICT));
      case 'reason_required':
      case 'invalid_sort_weight':
      case 'invalid_commission':
        throw new BadRequestException({ ...body(HttpStatus.BAD_REQUEST), message: error.message });
      default:
        throw error;
    }
  }
}

// AP §9.6.5, the panel's actions on a restaurant's account (slice 2.30c):
// «تعليق» and «إعادة التفعيل» with a reason (OWN, OPS: restaurants.manage),
// «إخفاء أو إظهار» and «تثبيت» (restaurants.manage), and «تغيير العمولة»
// for new orders only, now or from a later moment, with a reason (OWN:
// restaurants.commission, D16). The termination at a zero balance is
// cashdesk's. None takes an Idempotency-Key: each sets a state to a value,
// and the same commission again is a repeat that changes nothing. Each
// answers the account after it.
@AdminController('restaurants')
export class AdminRestaurantAccountController {
  constructor(private readonly merchants: MerchantsService) {}

  @Get(':restaurantId/account')
  @RequirePermission('restaurants.read')
  @ZodResponse({ status: 200, type: AdminRestaurantActionsDto })
  async read(@Param() params: AdminRestaurantActionParamsDto) {
    return this.body(params.restaurantId);
  }

  @Post(':restaurantId/suspend')
  @RequirePermission('restaurants.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminRestaurantActionsDto })
  async suspend(
    @Param() params: AdminRestaurantActionParamsDto,
    @Body() body: AdminRestaurantReasonDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.merchants.changeAccountStatusFrom(
        params.restaurantId,
        'active',
        'suspended',
        adminChange(session, request, body.reason),
      ),
    );
    return this.body(params.restaurantId);
  }

  @Post(':restaurantId/reactivate')
  @RequirePermission('restaurants.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminRestaurantActionsDto })
  async reactivate(
    @Param() params: AdminRestaurantActionParamsDto,
    @Body() body: AdminRestaurantReasonDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.merchants.changeAccountStatusFrom(
        params.restaurantId,
        'suspended',
        'active',
        adminChange(session, request, body.reason),
      ),
    );
    return this.body(params.restaurantId);
  }

  @Put(':restaurantId/visibility')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantActionsDto })
  async setVisibility(
    @Param() params: AdminRestaurantActionParamsDto,
    @Body() body: AdminRestaurantVisibilityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.merchants.setVisibility(
        params.restaurantId,
        body.visible,
        adminChange(session, request),
      ),
    );
    return this.body(params.restaurantId);
  }

  @Put(':restaurantId/sort-weight')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantActionsDto })
  async setSortWeight(
    @Param() params: AdminRestaurantActionParamsDto,
    @Body() body: AdminRestaurantSortWeightDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.merchants.setSortWeight(
        params.restaurantId,
        body.sortWeight,
        adminChange(session, request),
      ),
    );
    return this.body(params.restaurantId);
  }

  @Post(':restaurantId/commission')
  @RequirePermission('restaurants.commission')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminRestaurantActionsDto })
  async setCommission(
    @Param() params: AdminRestaurantActionParamsDto,
    @Body() body: AdminRestaurantCommissionDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.merchants.setCommission(
        params.restaurantId,
        {
          rateBp: body.rateBp,
          ...(body.effectiveFrom === null ? {} : { effectiveFrom: new Date(body.effectiveFrom) }),
        },
        adminChange(session, request, body.reason),
      ),
    );
    return this.body(params.restaurantId);
  }

  private async body(restaurantId: string): Promise<z.infer<typeof adminRestaurantAccountSchema>> {
    const settings = await this.merchants.accountSettings(restaurantId);
    if (settings === null) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    const [schedule, versions] = await Promise.all([
      this.merchants.commissionSchedule(restaurantId, new Date()),
      this.merchants.commissionVersions(restaurantId),
    ]);
    return {
      nameAr: settings.nameAr,
      accountStatus: settings.accountStatus,
      suspensionReason: settings.accountStatus === 'suspended' ? settings.suspensionReason : null,
      visible: settings.visible,
      sortWeight: settings.sortWeight,
      sortWeightMax: SORT_WEIGHT_MAX,
      commissionBp: schedule.rateBp,
      nextCommission: schedule.next && {
        rateBp: schedule.next.rateBp,
        from: schedule.next.from.toISOString(),
      },
      commissionHistory: versions.map((version) => ({
        id: version.id,
        rateBp: version.rateBp,
        from: version.effectiveFrom.toISOString(),
        reason: version.reason,
        setAt: version.createdAt.toISOString(),
        byAdmin: version.changedByType === 'admin',
      })),
    };
  }
}
