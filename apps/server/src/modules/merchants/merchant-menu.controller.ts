import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
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
import type { BulkPriceChange } from './bulk-price.js';
import { accountStatuses } from './operating-state.js';
import { RestaurantMenuService } from './restaurant-menu.service.js';

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

const dailyWindow = z
  .object({ startsAt: z.int().min(0).max(1439), endsAt: z.int().min(0).max(1440) })
  .nullable()
  .describe(
    "A category's daily window, minutes after midnight on the city's clock (breakfast until 12:00 is 0 to 720); an end not after the start crosses midnight; null all day (RA §9.1).",
  );

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
        window: dailyWindow,
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

const priceInput = z.object({
  amount: z
    .string()
    .regex(/^\d{1,15}$/)
    .describe('Integer minor units of the base (AP §8.6).'),
  currency: z.string().length(3),
});

class MerchantMenuItemParamsDto extends createZodDto(z.object({ itemId: z.uuid() })) {}
class MerchantMenuOptionParamsDto extends createZodDto(z.object({ optionId: z.uuid() })) {}
class MerchantMenuCategoryParamsDto extends createZodDto(z.object({ categoryId: z.uuid() })) {}

class MerchantMenuItemPriceDto extends createZodDto(
  z.object({ price: priceInput.describe('Above 0 (RA §9.4).') }),
) {}

class MerchantMenuOptionPriceDto extends createZodDto(
  z.object({ priceDelta: priceInput.describe('0 or more (RA §9.4).') }),
) {}

class MerchantMenuHiddenDto extends createZodDto(z.object({ hidden: z.boolean() })) {}

class MerchantMenuWindowDto extends createZodDto(z.object({ window: dailyWindow })) {}

class MerchantMenuCategoryOrderDto extends createZodDto(
  z.object({ categoryIds: z.array(z.uuid()).describe('Every category once, in the new order.') }),
) {}

class MerchantMenuItemOrderDto extends createZodDto(
  z.object({ itemIds: z.array(z.uuid()).describe('Every item of the category once, in order.') }),
) {}

class MerchantMenuBulkPriceDto extends createZodDto(
  z.object({
    categoryId: z.uuid().nullable().describe('One category; null: the whole menu.'),
    kind: z.enum(['percent', 'amount']),
    direction: z.enum(['up', 'down']),
    value: z
      .string()
      .regex(/^[1-9]\d{0,14}$/)
      .describe(
        'Basis points for a percentage (1000 is 10%); minor units of the base for an amount.',
      ),
  }),
) {}

const minorUnits = z.string().regex(/^\d+$/);

class MerchantMenuBulkPreviewDto extends createZodDto(
  z.object({
    currency: z.string(),
    roundingUnit: minorUnits.describe("The base's rounding unit each new price is rounded to."),
    rows: z.array(
      z.object({
        itemId: z.uuid(),
        code: z.string(),
        name: z.string(),
        categoryId: z.uuid(),
        before: minorUnits,
        after: minorUnits.nullable().describe('null: the change would bring it to 0 (refused).'),
      }),
    ),
    changed: z.int(),
    unchanged: z.int(),
    refused: z.int().describe('Above 0, the change cannot be applied.'),
  }),
) {}

class MerchantMenuBulkPriceResultDto extends createZodDto(
  z.object({ changed: z.int(), unchanged: z.int() }),
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
      window: category.window,
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
  constructor(
    private readonly merchants: MerchantsService,
    private readonly menus: RestaurantMenuService,
  ) {}

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

  // RA §9.2, §9.4, §18 (slice 2.32a): the owners' commands publish at once
  // and each answers the menu. A price, hiding, the order and a window set a
  // value, so they take no key (the same value again writes nothing); the
  // bulk change is relative and takes one. A cashier gets 403 owner_only (RA
  // §6: availability only). Refusals: 400 invalid_menu; 403 owner_only,
  // restaurant_terminated; 404 unknown_menu_row; 409 not_in_base_currency,
  // price_reaches_zero, rounding_unit_missing; 422 idempotency_key_reused.
  @Put('menu/items/:itemId/price')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async itemPrice(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuItemParamsDto,
    @Body() body: MerchantMenuItemPriceDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.menus.setItemPrice(
        owner.restaurantId,
        params.itemId,
        { amount: BigInt(body.price.amount), currency: body.price.currency },
        menuChangeOf(session, request),
      ),
    );
    return menuBody(await this.merchants.menu(owner.restaurantId));
  }

  @Put('menu/options/:optionId/price')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async optionPrice(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuOptionParamsDto,
    @Body() body: MerchantMenuOptionPriceDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.menus.setOptionDelta(
        owner.restaurantId,
        params.optionId,
        { amount: BigInt(body.priceDelta.amount), currency: body.priceDelta.currency },
        menuChangeOf(session, request),
      ),
    );
    return menuBody(await this.merchants.menu(owner.restaurantId));
  }

  @Put('menu/items/:itemId/hidden')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async itemHidden(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuItemParamsDto,
    @Body() body: MerchantMenuHiddenDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.menus.setHidden(
        owner.restaurantId,
        { type: 'item', id: params.itemId },
        body.hidden,
        menuChangeOf(session, request),
      ),
    );
    return menuBody(await this.merchants.menu(owner.restaurantId));
  }

  @Put('menu/categories/:categoryId/hidden')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async categoryHidden(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuCategoryParamsDto,
    @Body() body: MerchantMenuHiddenDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.menus.setHidden(
        owner.restaurantId,
        { type: 'category', id: params.categoryId },
        body.hidden,
        menuChangeOf(session, request),
      ),
    );
    return menuBody(await this.merchants.menu(owner.restaurantId));
  }

  @Put('menu/categories/:categoryId/window')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async categoryWindow(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuCategoryParamsDto,
    @Body() body: MerchantMenuWindowDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.menus.setCategoryWindow(
        owner.restaurantId,
        params.categoryId,
        body.window,
        menuChangeOf(session, request),
      ),
    );
    return menuBody(await this.merchants.menu(owner.restaurantId));
  }

  @Put('menu/category-order')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async categoryOrder(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantMenuCategoryOrderDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.menus.orderCategories(
        owner.restaurantId,
        body.categoryIds,
        menuChangeOf(session, request),
      ),
    );
    return menuBody(await this.merchants.menu(owner.restaurantId));
  }

  @Put('menu/categories/:categoryId/item-order')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async itemOrder(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuCategoryParamsDto,
    @Body() body: MerchantMenuItemOrderDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.menus.orderItems(
        owner.restaurantId,
        params.categoryId,
        body.itemIds,
        menuChangeOf(session, request),
      ),
    );
    return menuBody(await this.merchants.menu(owner.restaurantId));
  }

  // The bulk change's before and after (AP §9.6.6); a read, so no key.
  @Post('menu/bulk-price/preview')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuBulkPreviewDto })
  async bulkPricePreview(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantMenuBulkPriceDto,
  ) {
    const owner = ownerOf(session);
    const preview = await refused(() =>
      this.menus.bulkPreview(owner.restaurantId, { categoryId: body.categoryId }, bulkChange(body)),
    );
    return {
      ...preview,
      roundingUnit: preview.roundingUnit.toString(),
      rows: preview.rows.map((row) => ({
        ...row,
        before: row.before.toString(),
        after: row.after?.toString() ?? null,
      })),
    };
  }

  @Post('menu/bulk-price')
  @Idempotent()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuBulkPriceResultDto })
  async bulkPrice(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantMenuBulkPriceDto,
    @IdempotencyKey() key: string,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    return refused(() =>
      this.menus.bulkApply(owner.restaurantId, { categoryId: body.categoryId }, bulkChange(body), {
        ...menuChangeOf(session, request),
        accountId: owner.id,
        idempotencyKey: key,
      }),
    );
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

// RA §6: the menu's commands but availability are the owners' (MO).
function ownerOf(session: AppSession): MerchantAccount {
  const account = merchantOf(session);
  if (account.role !== 'owner') {
    throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
  }
  return account;
}

// RA §9.3, §9.4: the restaurant user, their role and the device.
function menuChangeOf(session: AppSession, request: FastifyRequest): MerchantChange {
  const account = merchantOf(session);
  return {
    actor: { type: 'merchant', id: account.id, role: account.role },
    context: { ipAddress: request.ip, device: session.deviceId },
  };
}

function bulkChange(body: MerchantMenuBulkPriceDto): BulkPriceChange {
  return body.kind === 'percent'
    ? { kind: 'percent', direction: body.direction, bp: Number(body.value) }
    : { kind: 'amount', direction: body.direction, amount: BigInt(body.value) };
}

// The menu's refusals as HTTP answers.
async function refused<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof MerchantsRefusedError)) throw error;
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_restaurant' || error.refusal === 'unknown_menu_row') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (error.refusal === 'invalid_menu') {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
    }
    if (error.refusal === 'restaurant_terminated') throw terminated();
    if (error.refusal === 'idempotency_key_reused') {
      throw new UnprocessableEntityException({
        statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
        ...body,
      });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
  }
}

function merchantOf(session: AppSession): MerchantAccount {
  if (!session.merchant) throw new Error('a merchant route without a restaurant user');
  return session.merchant;
}
