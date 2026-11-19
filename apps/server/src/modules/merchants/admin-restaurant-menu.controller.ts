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
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import {
  ITEM_CODE_MAX,
  itemBadges,
  MENU_DESCRIPTION_MAX,
  MENU_NAME_MAX,
  type MenuChange,
  MenuEditorService,
} from './menu-editor.service.js';
import { MerchantsRefusedError, MerchantsService, type SwitchedOff } from './merchants.service.js';
import type { BulkPriceChange } from './bulk-price.js';
import { MenuBulkService } from './menu-bulk.service.js';
import { OptionGroupsService } from './option-groups.service.js';

const minorUnits = z
  .string()
  .regex(/^\d{1,15}$/)
  .describe('Integer minor units of the currency, as a string.');

// Named in the OpenAPI document, so the clients' generator never merges them
// with another route's alike shape.
const money = z
  .object({ amount: minorUnits, currency: z.string().length(3) })
  .meta({ id: 'AdminMenuMoney' });

const window = z
  .object({
    startsAt: z.int().min(0).max(1439).describe("Minutes after midnight on the city's clock."),
    endsAt: z
      .int()
      .min(0)
      .max(1440)
      .describe('Not after the start: the window crosses midnight (1440 is midnight).'),
  })
  .meta({ id: 'AdminMenuWindow' });

const switchedOff = z
  .object({
    until: z.iso
      .datetime()
      .nullable()
      .describe('«حتى الغد» ends at the next business-day cutoff; null is «حتى أعيده».'),
  })
  .nullable()
  .meta({ id: 'AdminMenuSwitchedOff' })
  .describe('Its own switch off (RA §9.3); null while on.');

const badge = z.enum(itemBadges).nullable().describe('«جديد», «الأكثر طلباً» or «حار».');

class AdminMenuDto extends createZodDto(
  z.object({
    accountStatus: z.enum(['draft', 'test', 'active', 'suspended', 'terminated']),
    editable: z.boolean().describe('Whether the editor edits it: any status but terminated.'),
    pricesLocked: z
      .boolean()
      .describe('Past test mode, prices need menus.edit_prices: true when this session lacks it.'),
    nameMax: z.int(),
    descriptionMax: z.int(),
    codeMax: z.int(),
    categories: z.array(
      z.object({
        id: z.uuid(),
        name: z.string(),
        hidden: z.boolean(),
        switchedOff,
        window: window.nullable().describe('null: all day.'),
        items: z.array(
          z.object({
            id: z.uuid(),
            code: z.string(),
            name: z.string(),
            description: z.string().nullable(),
            photoKey: z
              .string()
              .nullable()
              .describe('Its key in public-media, shown through /media/; null without a photo.'),
            price: money,
            hidden: z.boolean(),
            badge,
            switchedOff,
            optionGroupIds: z.array(z.uuid()).describe('Its option groups, in order.'),
          }),
        ),
      }),
    ),
    optionGroups: z
      .array(
        z.object({
          id: z.uuid(),
          name: z.string(),
          minChoices: z.int().describe('0: an add-on group; 1 or more: required.'),
          maxChoices: z.int(),
          options: z.array(
            z.object({
              id: z.uuid(),
              name: z.string(),
              priceDelta: money,
              switchedOff,
            }),
          ),
          itemIds: z.array(z.uuid()).describe('The items it is linked to, in menu order.'),
        }),
      )
      .describe('Every option group of the restaurant, by name.'),
  }),
) {}

class AdminMenuParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminMenuCategoryParamsDto extends createZodDto(
  z.object({ restaurantId: z.uuid(), categoryId: z.uuid() }),
) {}

class AdminMenuItemParamsDto extends createZodDto(
  z.object({ restaurantId: z.uuid(), itemId: z.uuid() }),
) {}

class AdminMenuCategoryDto extends createZodDto(
  z.object({
    name: z.string(),
    hidden: z.boolean(),
    window: window.nullable().describe('«متوفر من … إلى …»; null all day.'),
  }),
) {}

class AdminMenuItemDto extends createZodDto(
  z.object({
    categoryId: z.uuid(),
    code: z
      .string()
      .nullable()
      .describe('Unique in the restaurant; empty or null: generated on creation, kept on edit.'),
    name: z.string(),
    description: z.string().nullable(),
    price: money.describe("Above 0, in the city's base currency."),
    hidden: z.boolean(),
    badge,
  }),
) {}

class AdminMenuGroupParamsDto extends createZodDto(
  z.object({ restaurantId: z.uuid(), groupId: z.uuid() }),
) {}

class AdminMenuOptionParamsDto extends createZodDto(
  z.object({ restaurantId: z.uuid(), groupId: z.uuid(), optionId: z.uuid() }),
) {}

class AdminMenuOptionGroupDto extends createZodDto(
  z.object({
    name: z.string(),
    minChoices: z.int().min(0).max(50).describe('0: an add-on group; 1 or more: required.'),
    maxChoices: z
      .int()
      .min(1)
      .max(50)
      .describe('At least the minimum; once it has options, at most their count.'),
  }),
) {}

class AdminMenuOptionDto extends createZodDto(
  z.object({
    name: z.string(),
    priceDelta: money.describe("0 or more, in the city's base currency."),
    removed: z.boolean().describe('true removes the option for good.'),
  }),
) {}

class AdminMenuOptionOrderDto extends createZodDto(
  z.object({ optionIds: z.array(z.uuid()).describe('Every option of the group once, in order.') }),
) {}

class AdminMenuGroupItemsDto extends createZodDto(
  z.object({ itemIds: z.array(z.uuid()).describe('Every item the group is linked to.') }),
) {}

class AdminMenuItemGroupsDto extends createZodDto(
  z.object({ groupIds: z.array(z.uuid()).describe("The item's groups, in order.") }),
) {}

class AdminMenuBulkPriceDto extends createZodDto(
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

class AdminMenuBulkPreviewDto extends createZodDto(
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

class AdminMenuBulkPriceResultDto extends createZodDto(
  z.object({ changed: z.int(), unchanged: z.int() }),
) {}

class AdminMenuBulkAvailabilityDto extends createZodDto(
  z.object({
    itemIds: z.array(z.uuid()).min(1).max(500),
    available: z.boolean(),
    until: z
      .enum(['tomorrow', 'turned_back_on'])
      .optional()
      .describe('When switching off: «حتى الغد» or «حتى أعيده» (the default).'),
  }),
) {}

class AdminMenuCategoryOrderDto extends createZodDto(
  z.object({ categoryIds: z.array(z.uuid()).describe('Every category once, in the new order.') }),
) {}

class AdminMenuItemOrderDto extends createZodDto(
  z.object({ itemIds: z.array(z.uuid()).describe('Every item of the category once, in order.') }),
) {}

class AdminMenuAvailabilityDto extends createZodDto(
  z.object({
    type: z.enum(['category', 'item', 'option']),
    id: z.uuid(),
    available: z.boolean(),
    until: z
      .enum(['tomorrow', 'turned_back_on'])
      .optional()
      .describe('When switching off: «حتى الغد» or «حتى أعيده» (the default).'),
  }),
) {}

function refusalAsHttp(error: unknown): never {
  if (error instanceof MerchantsRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_restaurant' || error.refusal === 'unknown_menu_row') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (error.refusal === 'invalid_menu') {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
    }
    if (error.refusal === 'restaurant_terminated' || error.refusal === 'price_edit_not_allowed') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, ...body });
    }
    if (error.refusal === 'idempotency_key_reused') {
      throw new UnprocessableEntityException({
        statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
        ...body,
      });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
  }
  throw error;
}

function bulkChange(body: AdminMenuBulkPriceDto): BulkPriceChange {
  return body.kind === 'percent'
    ? { kind: 'percent', direction: body.direction, bp: Number(body.value) }
    : { kind: 'amount', direction: body.direction, amount: BigInt(body.value) };
}

function adminChange(session: AdminSession, request: FastifyRequest): MenuChange {
  return {
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
    mayEditPrices: session.permissions.includes('menus.edit_prices'),
  };
}

const offJson = (off: SwitchedOff) =>
  off === null ? null : { until: off.until?.toISOString() ?? null };

// The menu editor «القائمة» (AP §9.6.3, §9.6.6): the wizard's step 7 (slice
// 2.30b) and the profile's tab past it (slice 2.31), for any status but
// terminated; past test mode a price needs menus.edit_prices. The panel names each new
// category's and item's id, so a PUT creates it the first time and sets its
// fields after: every route sets a state to a value and takes no
// Idempotency-Key. Each answers the menu. The photo is
// PUT /v1/admin/restaurants/{id}/items/{itemId}/photo. Refusals: 400
// invalid_menu; 403 restaurant_terminated, price_edit_not_allowed; 404
// unknown_restaurant, unknown_menu_row; 409 item_code_taken,
// not_in_base_currency.
@AdminController('restaurant-drafts')
export class AdminRestaurantMenuController {
  constructor(
    private readonly merchants: MerchantsService,
    private readonly editor: MenuEditorService,
    private readonly groups: OptionGroupsService,
    private readonly bulk: MenuBulkService,
  ) {}

  // AP §9.6.6 «تعديل جماعي» (slice 2.31): the before and after of every item
  // in scope; a read, so no key.
  @Post(':restaurantId/menu/bulk-price/preview')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuBulkPreviewDto })
  async bulkPricePreview(@Param() params: AdminMenuParamsDto, @Body() body: AdminMenuBulkPriceDto) {
    try {
      const preview = await this.bulk.preview(
        params.restaurantId,
        { categoryId: body.categoryId },
        bulkChange(body),
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
    } catch (error) {
      refusalAsHttp(error);
    }
  }

  // Applies it: the same input recomputed under the restaurant's lock, past
  // test mode with menus.edit_prices; one summary to the owners.
  @Post(':restaurantId/menu/bulk-price')
  @Idempotent()
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuBulkPriceResultDto })
  async bulkPrice(
    @Param() params: AdminMenuParamsDto,
    @Body() body: AdminMenuBulkPriceDto,
    @IdempotencyKey() key: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      return await this.bulk.apply(
        params.restaurantId,
        { categoryId: body.categoryId },
        bulkChange(body),
        {
          ...adminChange(session, request),
          accountId: session.accountId,
          idempotencyKey: key,
        },
      );
    } catch (error) {
      refusalAsHttp(error);
    }
  }

  // «توفر جماعي»: many items switched at once; it sets a value, so no key.
  @Put(':restaurantId/menu/bulk-availability')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async bulkAvailability(
    @Param() params: AdminMenuParamsDto,
    @Body() body: AdminMenuBulkAvailabilityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.bulk.setItemsAvailability(
        params.restaurantId,
        body.itemIds,
        body.available
          ? { available: true }
          : { available: false, until: body.until ?? 'turned_back_on' },
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  @Get(':restaurantId/menu')
  @RequireAnyPermission('restaurants.read', 'restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async read(@Param() params: AdminMenuParamsDto, @CurrentAdminSession() session: AdminSession) {
    return this.answer(params.restaurantId, session);
  }

  @Put(':restaurantId/menu/categories/:categoryId')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async category(
    @Param() params: AdminMenuCategoryParamsDto,
    @Body() body: AdminMenuCategoryDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.editor.saveCategory(
        params.restaurantId,
        params.categoryId,
        body,
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  @Put(':restaurantId/menu/items/:itemId')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async item(
    @Param() params: AdminMenuItemParamsDto,
    @Body() body: AdminMenuItemDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.editor.saveItem(
        params.restaurantId,
        params.itemId,
        {
          ...body,
          price: { amount: BigInt(body.price.amount), currency: body.price.currency },
        },
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  @Put(':restaurantId/menu/category-order')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async categoryOrder(
    @Param() params: AdminMenuParamsDto,
    @Body() body: AdminMenuCategoryOrderDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.editor.orderCategories(
        params.restaurantId,
        body.categoryIds,
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  @Put(':restaurantId/menu/categories/:categoryId/item-order')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async itemOrder(
    @Param() params: AdminMenuCategoryParamsDto,
    @Body() body: AdminMenuItemOrderDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.editor.orderItems(
        params.restaurantId,
        params.categoryId,
        body.itemIds,
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  // RA §9.3: «متوفر» or «غير متوفر» «حتى الغد» or «حتى أعيده», as the
  // restaurant app switches it.
  @Put(':restaurantId/menu/availability')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async availability(
    @Param() params: AdminMenuParamsDto,
    @Body() body: AdminMenuAvailabilityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.editor.setAvailability(
        params.restaurantId,
        { type: body.type, id: body.id },
        body.available
          ? { available: true }
          : { available: false, until: body.until ?? 'turned_back_on' },
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  // AP §9.6.6 «مجموعات الخيارات» and «الإضافات» (slice 2.31).
  @Put(':restaurantId/menu/option-groups/:groupId')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async optionGroup(
    @Param() params: AdminMenuGroupParamsDto,
    @Body() body: AdminMenuOptionGroupDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.groups.saveGroup(
        params.restaurantId,
        params.groupId,
        body,
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  @Put(':restaurantId/menu/option-groups/:groupId/options/:optionId')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async option(
    @Param() params: AdminMenuOptionParamsDto,
    @Body() body: AdminMenuOptionDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.groups.saveOption(
        params.restaurantId,
        params.groupId,
        params.optionId,
        {
          name: body.name,
          priceDelta: {
            amount: BigInt(body.priceDelta.amount),
            currency: body.priceDelta.currency,
          },
          removed: body.removed,
        },
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  @Put(':restaurantId/menu/option-groups/:groupId/option-order')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async optionOrder(
    @Param() params: AdminMenuGroupParamsDto,
    @Body() body: AdminMenuOptionOrderDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.groups.orderOptions(
        params.restaurantId,
        params.groupId,
        body.optionIds,
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  // «ربط بعدة أصناف»: one group linked to many items at once.
  @Put(':restaurantId/menu/option-groups/:groupId/items')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async groupItems(
    @Param() params: AdminMenuGroupParamsDto,
    @Body() body: AdminMenuGroupItemsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.groups.linkItems(
        params.restaurantId,
        params.groupId,
        body.itemIds,
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  @Put(':restaurantId/menu/items/:itemId/option-groups')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuDto })
  async itemGroups(
    @Param() params: AdminMenuItemParamsDto,
    @Body() body: AdminMenuItemGroupsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.groups.setItemGroups(
        params.restaurantId,
        params.itemId,
        body.groupIds,
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session);
  }

  private async answer(restaurantId: string, session: AdminSession) {
    const found = await this.merchants.cityAndStatus(restaurantId);
    if (found === null) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    const now = new Date();
    const [menu, groups] = await Promise.all([
      this.merchants.menu(restaurantId, now),
      this.groups.groups(restaurantId, now),
    ]);
    return {
      accountStatus: found.accountStatus,
      editable: MenuEditorService.editable(found.accountStatus),
      pricesLocked:
        MenuEditorService.pricesNeedPermission(found.accountStatus) &&
        !session.permissions.includes('menus.edit_prices'),
      nameMax: MENU_NAME_MAX,
      descriptionMax: MENU_DESCRIPTION_MAX,
      codeMax: ITEM_CODE_MAX,
      categories: menu.categories.map((category) => ({
        id: category.id,
        name: category.name,
        hidden: category.hidden,
        switchedOff: offJson(category.switchedOff),
        window: category.window,
        items: category.items.map((item) => ({
          id: item.id,
          code: item.code,
          name: item.name,
          description: item.description,
          photoKey: item.photoKey,
          price: { amount: item.price.amount.toString(), currency: item.price.currency },
          hidden: item.hidden,
          badge: item.badge,
          switchedOff: offJson(item.switchedOff),
          optionGroupIds: item.optionGroups.map((group) => group.id),
        })),
      })),
      optionGroups: groups.map((group) => ({
        id: group.id,
        name: group.name,
        minChoices: group.minChoices,
        maxChoices: group.maxChoices,
        options: group.options.map((option) => ({
          id: option.id,
          name: option.name,
          priceDelta: {
            amount: option.priceDelta.amount.toString(),
            currency: option.priceDelta.currency,
          },
          switchedOff: offJson(option.switchedOff),
        })),
        itemIds: group.itemIds,
      })),
    };
  }
}
