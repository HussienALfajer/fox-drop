import {
  BadRequestException,
  Body,
  ForbiddenException,
  Get,
  HttpStatus,
  NotFoundException,
  Put,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession, MerchantAccount } from '../identity/index.js';
import {
  type Menu,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  type Money,
  type SwitchedOff,
} from './merchants.service.js';
import { accountStatuses } from './operating-state.js';

const money = z.object({
  amount: z.string().regex(/^\d+$/).describe('Integer minor units (AP §8.6).'),
  currency: z.string().length(3),
});

const switchedOff = z
  .object({
    until: z.iso
      .datetime()
      .nullable()
      .describe('«حتى الغد»: on again at this time; null: «حتى أعيده».'),
  })
  .nullable()
  .describe("The row's own switch (RA §9.3): null while on.");

class MerchantRestaurantDto extends createZodDto(
  z.object({
    id: z.uuid(),
    nameAr: z.string(),
    nameEn: z.string().nullable(),
    accountStatus: z.enum(accountStatuses),
    suspensionReason: z
      .string()
      .nullable()
      .describe('«حساب مطعمك معلّق: {السبب}…» while suspended (RA §5.5).'),
    state: z
      .enum(['draft', 'suspended', 'terminated', 'holiday', 'closed', 'paused', 'busy', 'open'])
      .describe('The operating state now (RA §7.1).'),
    stateUntil: z.iso.datetime().nullable().describe('When a holiday close or a pause ends.'),
  }),
) {}

const menuOption = z.object({
  id: z.uuid(),
  name: z.string(),
  priceDelta: money,
  available: z.boolean(),
  switchedOff,
});

class MerchantMenuDto extends createZodDto(
  z.object({
    categories: z.array(
      z.object({
        id: z.uuid(),
        name: z.string(),
        hidden: z.boolean(),
        available: z.boolean(),
        switchedOff,
        items: z.array(
          z.object({
            id: z.uuid(),
            code: z.string(),
            name: z.string(),
            description: z.string().nullable(),
            price: money,
            available: z
              .boolean()
              .describe(
                'Whether customers can order it: its switch, its category and its required groups (RA §9.3).',
              ),
            switchedOff,
            hidden: z.boolean(),
            optionGroups: z.array(
              z.object({
                id: z.uuid(),
                name: z.string(),
                minChoices: z.int(),
                maxChoices: z.int(),
                options: z.array(menuOption),
              }),
            ),
          }),
        ),
      }),
    ),
  }),
) {}

class MerchantAvailabilityDto extends createZodDto(
  z.object({
    type: z.enum(['category', 'item', 'option']),
    id: z.uuid(),
    available: z.boolean(),
    until: z
      .enum(['tomorrow', 'turned_back_on'])
      .optional()
      .describe(
        'Needed to switch off: «حتى الغد» (the default in the app) or «حتى أعيده» (RA §9.3).',
      ),
  }),
) {}

class MerchantAvailabilitySavedDto extends createZodDto(z.object({ switchedOff })) {}

function moneyBody(value: Money) {
  return { amount: value.amount.toString(), currency: value.currency };
}

function switchedOffBody(value: SwitchedOff) {
  return value === null ? null : { until: value.until?.toISOString() ?? null };
}

function menuBody(menu: Menu) {
  return {
    categories: menu.categories.map((category) => ({
      ...category,
      switchedOff: switchedOffBody(category.switchedOff),
      items: category.items.map((item) => ({
        ...item,
        price: moneyBody(item.price),
        switchedOff: switchedOffBody(item.switchedOff),
        optionGroups: item.optionGroups.map((group) => ({
          ...group,
          options: group.options.map((option) => ({
            ...option,
            priceDelta: moneyBody(option.priceDelta),
            switchedOff: switchedOffBody(option.switchedOff),
          })),
        })),
      })),
    })),
  };
}

// The restaurant app's restaurant and menu (RA §5.4, §5.5, §9.3), for owners
// and cashiers alike. A terminated restaurant's owners keep only the money
// section (RA §5.5), so these routes refuse it.
@MerchantController()
export class MerchantMenuController {
  constructor(private readonly merchants: MerchantsService) {}

  @Get('restaurant')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantRestaurantDto })
  async restaurant(@CurrentAppSession() session: AppSession) {
    const { restaurantId } = merchantOf(session);
    const restaurant = await this.merchants.restaurant(restaurantId);
    if (!restaurant) throw new NotFoundException();
    const state = await this.merchants.operatingState(restaurantId);
    return {
      id: restaurant.id,
      nameAr: restaurant.nameAr,
      nameEn: restaurant.nameEn,
      accountStatus: restaurant.accountStatus,
      suspensionReason: restaurant.suspensionReason,
      state: state.state,
      stateUntil: 'until' in state ? (state.until?.toISOString() ?? null) : null,
    };
  }

  @Get('menu')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async menu(@CurrentAppSession() session: AppSession) {
    const { restaurantId } = await this.notTerminated(session);
    return menuBody(await this.merchants.menu(restaurantId));
  }

  // RA §9.3: owners and cashiers switch a category, an item or an option.
  @Put('menu/availability')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantAvailabilitySavedDto })
  async setAvailability(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantAvailabilityDto,
    @Req() request: FastifyRequest,
  ) {
    const account = merchantOf(session);
    if (!body.available && body.until === undefined) {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: 'until_needed' });
    }
    // RA §9.3: every change records the user, the device and the time.
    const change: MerchantChange = {
      actor: { type: 'merchant', id: account.id, role: account.role },
      context: { ipAddress: request.ip, device: session.deviceId },
    };
    try {
      const switched = await this.merchants.setAvailability(
        account.restaurantId,
        { type: body.type, id: body.id },
        body.available ? { available: true } : { available: false, until: body.until! },
        change,
      );
      return { switchedOff: switchedOffBody(switched) };
    } catch (error) {
      if (error instanceof MerchantsRefusedError && error.refusal === 'unknown_menu_row') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      // Checked under the restaurant's lock, so a termination is never raced.
      if (error instanceof MerchantsRefusedError && error.refusal === 'restaurant_terminated') {
        throw terminated();
      }
      throw error;
    }
  }

  private async notTerminated(session: AppSession): Promise<MerchantAccount> {
    const account = merchantOf(session);
    if ((await this.merchants.accountStatus(account.restaurantId)) === 'terminated') {
      throw terminated();
    }
    return account;
  }
}

// RA §5.5: a terminated restaurant's owners keep only the money section.
function terminated(): ForbiddenException {
  return new ForbiddenException({
    statusCode: HttpStatus.FORBIDDEN,
    error: 'restaurant_terminated',
  });
}

function merchantOf(session: AppSession): MerchantAccount {
  if (!session.merchant) throw new Error('a merchant route without a restaurant user');
  return session.merchant;
}
