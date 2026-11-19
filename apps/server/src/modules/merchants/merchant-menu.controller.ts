import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpCode,
  HttpException,
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
import { FilesRefusedError, FilesService, imageTypes, MAX_IMAGE_BYTES } from '../files/index.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession, MerchantAccount } from '../identity/index.js';
import {
  ChangeRequestsService,
  changeFields,
  type OwnersMenu,
  type PendingChange,
} from './change-requests.service.js';
import {
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

// Its own component, so the generator never merges it with the menu's
// money and renames the app's models.
const pendingMoney = z
  .object({
    amount: z.string().regex(/^\d+$/).describe('Integer minor units (AP §8.6).'),
    currency: z.string().length(3),
  })
  .meta({ id: 'MerchantPendingMoney' });

// RA §9.5 (slice 2.32b): a request «بانتظار المراجعة» beside its row, with
// its pending value: each field fills only its own part.
const pendingChange = z.object({
  requestId: z.uuid(),
  field: z
    .enum(changeFields)
    .describe(
      '`created`: a new row, unseen by customers until approved; otherwise the field asked.',
    ),
  createdAt: z.iso.datetime(),
  name: z.string().nullable(),
  description: z.string().nullable(),
  photoKey: z.string().nullable().describe('A photo waiting for review, in public-media.'),
  price: pendingMoney.nullable().describe("A new item's price, a new option's delta."),
  categoryId: z.uuid().nullable(),
  groupId: z.uuid().nullable(),
  minChoices: z.int().nullable(),
  maxChoices: z.int().nullable(),
  itemIds: z.array(z.uuid()).nullable(),
  options: z
    .array(z.object({ id: z.uuid(), name: z.string(), priceDelta: pendingMoney }))
    .nullable(),
});

const pending = z
  .array(pendingChange)
  .describe('The pending requests on this row (RA §9.5): the badge «بانتظار المراجعة».');

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
            photoKey: z
              .string()
              .nullable()
              .describe('Its published photo in public-media (architecture §5.8).'),
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
            pending,
          }),
        ),
        pending,
      }),
    ),
    optionGroups: z
      .array(
        z.object({
          id: z.uuid(),
          name: z.string(),
          minChoices: z.int(),
          maxChoices: z.int(),
          itemIds: z.array(z.uuid()),
          options: z.array(
            z.object({
              id: z.uuid(),
              name: z.string(),
              priceDelta: money,
              switchedOff,
              pending,
            }),
          ),
          pending,
        }),
      )
      .describe('Every option group of the restaurant, new ones waiting for review included.'),
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

class MerchantMenuRequestParamsDto extends createZodDto(z.object({ requestId: z.uuid() })) {}
class MerchantMenuGroupParamsDto extends createZodDto(z.object({ groupId: z.uuid() })) {}

class MerchantCategoryRequestDto extends createZodDto(z.object({ name: z.string() })) {}

class MerchantNewItemRequestDto extends createZodDto(
  z.object({
    categoryId: z.uuid(),
    name: z.string(),
    description: z.string().nullable(),
    price: priceInput.describe('Above 0 (RA §9.4).'),
    uploadId: z
      .uuid()
      .nullable()
      .describe('A new photo from POST /v1/merchant/uploads/item-photo; null keeps the one asked.'),
  }),
) {}

class MerchantItemTextRequestDto extends createZodDto(
  z.object({ name: z.string(), description: z.string().nullable() }),
) {}

class MerchantItemPhotoRequestDto extends createZodDto(z.object({ uploadId: z.uuid() })) {}

class MerchantOptionGroupRequestDto extends createZodDto(
  z.object({
    name: z.string(),
    minChoices: z.int().min(0).max(50),
    maxChoices: z.int().min(1).max(50),
    itemIds: z.array(z.uuid()).describe('The items the group is linked to, as a set.'),
    options: z
      .array(
        z
          .object({
            id: z.uuid().describe('A new option takes a new id.'),
            name: z.string(),
            priceDelta: priceInput.describe(
              "0 or more; a published option's delta changes through «تعديل السعر» only.",
            ),
          })
          .meta({ id: 'MerchantRequestOption' }),
      )
      .describe('The options asked; a published option left out stays as it is.'),
  }),
) {}

class MerchantNewUploadDto extends createZodDto(
  z.object({
    contentType: z.enum(imageTypes),
    sizeBytes: z.int().min(1).max(MAX_IMAGE_BYTES),
  }),
) {}

class MerchantUploadDto extends createZodDto(
  z.object({
    uploadId: z.uuid().describe('Sent with the request once the file is uploaded.'),
    url: z.string().describe('A PUT of the exact bytes, with the same Content-Type.'),
    expiresAt: z.iso.datetime(),
  }),
) {}

class MerchantAvailabilitySavedDto extends createZodDto(z.object({ switchedOff })) {}

function moneyBody(value: Money) {
  return { amount: value.amount.toString(), currency: value.currency };
}

function switchedOffBody(value: SwitchedOff) {
  return value === null ? null : { until: value.until?.toISOString() ?? null };
}

function pendingBody(list: PendingChange[]) {
  return list.map((change) => ({
    ...change,
    createdAt: change.createdAt.toISOString(),
    price: change.price === null ? null : moneyBody(change.price),
    options:
      change.options?.map((option) => ({
        ...option,
        priceDelta: moneyBody(option.priceDelta),
      })) ?? null,
  }));
}

function menuBody(menu: OwnersMenu) {
  return {
    categories: menu.categories.map((category) => ({
      ...category,
      window: category.window,
      switchedOff: switchedOffBody(category.switchedOff),
      pending: pendingBody(category.pending),
      items: category.items.map((item) => ({
        ...item,
        price: moneyBody(item.price),
        switchedOff: switchedOffBody(item.switchedOff),
        pending: pendingBody(item.pending),
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
    optionGroups: menu.optionGroups.map((group) => ({
      ...group,
      pending: pendingBody(group.pending),
      options: group.options.map((option) => ({
        ...option,
        priceDelta: moneyBody(option.priceDelta),
        switchedOff: switchedOffBody(option.switchedOff),
        pending: pendingBody(option.pending),
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
    private readonly requests: ChangeRequestsService,
    private readonly files: FilesService,
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
    return this.answer(restaurantId);
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
    return this.answer(owner.restaurantId);
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
    return this.answer(owner.restaurantId);
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
    return this.answer(owner.restaurantId);
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
    return this.answer(owner.restaurantId);
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
    return this.answer(owner.restaurantId);
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
    return this.answer(owner.restaurantId);
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
    return this.answer(owner.restaurantId);
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

  // RA §9.2 «After admin review», §9.5, §18 (slice 2.32b): the owners' change
  // requests, each answering the menu with its pending values. The app names
  // a new row's id, so each sets a value and takes no key; the same value
  // again writes nothing, the published one withdraws its request. Refusals
  // as above, and 404 upload_not_found, unknown_change_request; 409
  // already_published, not_published, request_not_pending, upload_used,
  // upload_expired, upload_missing; 400 upload_invalid, upload_wrong_purpose.
  @Put('menu/requests/categories/:categoryId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async requestCategory(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuCategoryParamsDto,
    @Body() body: MerchantCategoryRequestDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.requests.requestCategory(
        owner.restaurantId,
        params.categoryId,
        body.name,
        menuChangeOf(session, request),
      ),
    );
    return this.answer(owner.restaurantId);
  }

  @Put('menu/requests/items/:itemId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async requestNewItem(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuItemParamsDto,
    @Body() body: MerchantNewItemRequestDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.requests.requestNewItem(
        owner.restaurantId,
        params.itemId,
        {
          categoryId: body.categoryId,
          name: body.name,
          description: body.description,
          price: { amount: BigInt(body.price.amount), currency: body.price.currency },
          uploadId: body.uploadId,
        },
        menuChangeOf(session, request),
      ),
    );
    return this.answer(owner.restaurantId);
  }

  @Put('menu/requests/items/:itemId/text')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async requestItemText(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuItemParamsDto,
    @Body() body: MerchantItemTextRequestDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.requests.requestItemText(
        owner.restaurantId,
        params.itemId,
        body,
        menuChangeOf(session, request),
      ),
    );
    return this.answer(owner.restaurantId);
  }

  @Put('menu/requests/items/:itemId/photo')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async requestItemPhoto(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuItemParamsDto,
    @Body() body: MerchantItemPhotoRequestDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.requests.requestItemPhoto(
        owner.restaurantId,
        params.itemId,
        body.uploadId,
        menuChangeOf(session, request),
      ),
    );
    return this.answer(owner.restaurantId);
  }

  @Put('menu/requests/option-groups/:groupId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async requestOptionGroup(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuGroupParamsDto,
    @Body() body: MerchantOptionGroupRequestDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.requests.requestOptionGroup(
        owner.restaurantId,
        params.groupId,
        {
          ...body,
          options: body.options.map((option) => ({
            ...option,
            priceDelta: {
              amount: BigInt(option.priceDelta.amount),
              currency: option.priceDelta.currency,
            },
          })),
        },
        menuChangeOf(session, request),
      ),
    );
    return this.answer(owner.restaurantId);
  }

  // RA §9.5: withdraws a pending request. Its repeat is refused (409
  // request_not_pending), so it takes no key.
  @Post('menu/requests/:requestId/withdraw')
  @HttpCode(200)
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuDto })
  async withdraw(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantMenuRequestParamsDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = ownerOf(session);
    await refused(() =>
      this.requests.withdraw(owner.restaurantId, params.requestId, menuChangeOf(session, request)),
    );
    return this.answer(owner.restaurantId);
  }

  // RA §9.2 (slice 2.32b): an owner's item photo, a pre-signed PUT into
  // public-media's incoming/ on the apps' host. No key: the answer is a URL
  // to upload with, and only the photo a request links is used. 429
  // too_many_uploads past REPORT_UPLOADS_PER_HOUR.
  @Post('uploads/item-photo')
  @HttpCode(201)
  @AppSignedIn()
  @ZodResponse({ status: 201, type: MerchantUploadDto })
  async itemPhotoUpload(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantNewUploadDto,
  ) {
    const owner = ownerOf(session);
    await this.notTerminated(session);
    try {
      const upload = await this.files.createUpload(
        { ...body, purpose: 'item_photo' },
        owner.id,
        new Date(),
        'app',
      );
      return { ...upload, expiresAt: upload.expiresAt.toISOString() };
    } catch (error) {
      if (error instanceof FilesRefusedError && error.refusal === 'too_many_uploads') {
        throw new HttpException(
          { statusCode: HttpStatus.TOO_MANY_REQUESTS, error: error.refusal },
          HttpStatus.TOO_MANY_REQUESTS,
        );
      }
      throw error;
    }
  }

  private async answer(restaurantId: string) {
    return menuBody(await this.requests.ownersMenu(restaurantId));
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
    if (error instanceof FilesRefusedError) {
      const body = { error: error.refusal };
      if (error.refusal === 'upload_not_found') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
      }
      if (error.refusal === 'upload_wrong_purpose' || error.refusal === 'upload_invalid') {
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
      }
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
    }
    if (!(error instanceof MerchantsRefusedError)) throw error;
    const body = { error: error.refusal };
    if (
      error.refusal === 'unknown_restaurant' ||
      error.refusal === 'unknown_menu_row' ||
      error.refusal === 'unknown_change_request'
    ) {
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
