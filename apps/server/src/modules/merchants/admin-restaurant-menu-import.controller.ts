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
import { FilesRefusedError } from '../files/index.js';
import type { AdminSession } from '../identity/index.js';
import { IMPORT_COLUMNS, IMPORT_MAX_ROWS, type ImportPlan } from './menu-import.js';
import { MenuImportService } from './menu-import.service.js';
import { MerchantsRefusedError } from './merchants.service.js';

const minorUnits = z.string().regex(/^\d{1,15}$/);

class AdminMenuImportParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminMenuImportTemplateDto extends createZodDto(
  z.object({
    fileName: z.string(),
    contentBase64: z.string().describe('The .xlsx workbook, filled with the current menu.'),
  }),
) {}

class AdminMenuImportUploadDto extends createZodDto(
  z.object({ uploadId: z.uuid().describe('A menu_import upload of POST /v1/admin/uploads.') }),
) {}

const importItem = {
  categoryName: z.string(),
  name: z.string(),
  description: z.string().nullable(),
  price: minorUnits.describe("In the city's base currency."),
  groupIds: z.array(z.uuid()),
};

class AdminMenuImportPlanDto extends createZodDto(
  z.object({
    fileError: z
      .enum(['missing_headers', 'no_rows', 'too_many_rows'])
      .nullable()
      .describe(`The file cannot be read as the template (${IMPORT_MAX_ROWS} rows at most).`),
    errors: z
      .array(
        z.object({
          row: z.int().describe("The sheet's row number, the header being 1."),
          column: z.enum(IMPORT_COLUMNS),
          error: z.enum([
            'required',
            'too_long',
            'invalid_price',
            'repeated_code',
            'unknown_group',
            'ambiguous_name',
          ]),
        }),
      )
      .describe('Every row error; the import runs only without any.'),
    categoriesAdded: z.array(z.string()),
    added: z.array(
      z.object({
        row: z.int(),
        code: z.string().nullable().describe('null: generated.'),
        ...importItem,
      }),
    ),
    changed: z.array(
      z.object({
        row: z.int(),
        itemId: z.uuid(),
        code: z.string(),
        fields: z.array(z.enum(['category', 'name', 'description', 'price', 'groups'])),
        ...importItem,
        oldPrice: minorUnits,
      }),
    ),
    unchanged: z.int(),
  }),
) {}

class AdminMenuImportResultDto extends createZodDto(
  z.object({
    added: z.int(),
    changed: z.int(),
    unchanged: z.int(),
    categoriesAdded: z.int(),
  }),
) {}

function planJson(plan: ImportPlan) {
  return {
    fileError: plan.fileError,
    errors: plan.errors,
    categoriesAdded: plan.categoriesAdded,
    added: plan.added.map((each) => ({ ...each, price: each.price.toString() })),
    changed: plan.changed.map((each) => ({
      row: each.row,
      itemId: each.itemId,
      code: each.code,
      fields: each.fields,
      ...each.next,
      price: each.next.price.toString(),
      oldPrice: each.oldPrice.toString(),
    })),
    unchanged: plan.unchanged,
  };
}

function refusalAsHttp(error: unknown): never {
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
  if (error instanceof MerchantsRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_restaurant') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (error.refusal === 'import_unreadable') {
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

// AP §9.6.6 «استيراد من Excel» (slice 2.31): download the template, upload it
// (POST /v1/admin/uploads, purpose menu_import), read the validation report
// and the dry run, then import. Refusals: 400 import_unreadable,
// upload_invalid, upload_wrong_purpose; 403 restaurant_terminated,
// price_edit_not_allowed; 404 unknown_restaurant, upload_not_found; 409
// import_invalid (a row errs), upload_used, upload_expired, upload_missing,
// not_in_base_currency; 422 idempotency_key_reused.
@AdminController('restaurant-drafts')
export class AdminRestaurantMenuImportController {
  constructor(private readonly imports: MenuImportService) {}

  // The workbook travels in the answer: it is small and holds the menu only.
  @Get(':restaurantId/menu/import-template')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuImportTemplateDto })
  async template(@Param() params: AdminMenuImportParamsDto) {
    try {
      const file = await this.imports.template(params.restaurantId);
      return { fileName: 'menu.xlsx', contentBase64: file.toString('base64') };
    } catch (error) {
      refusalAsHttp(error);
    }
  }

  // The validation report and what would be added, changed or left alone; a
  // read, so no key.
  @Post(':restaurantId/menu/import/dry-run')
  @HttpCode(200)
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuImportPlanDto })
  async dryRun(@Param() params: AdminMenuImportParamsDto, @Body() body: AdminMenuImportUploadDto) {
    try {
      return planJson(await this.imports.dryRun(params.restaurantId, body.uploadId));
    } catch (error) {
      refusalAsHttp(error);
    }
  }

  @Post(':restaurantId/menu/import')
  @HttpCode(200)
  @Idempotent()
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuImportResultDto })
  async commit(
    @Param() params: AdminMenuImportParamsDto,
    @Body() body: AdminMenuImportUploadDto,
    @IdempotencyKey() key: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      return await this.imports.commit(params.restaurantId, body.uploadId, {
        actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
        context: requestContext(request),
        mayEditPrices: session.permissions.includes('menus.edit_prices'),
        accountId: session.accountId,
        idempotencyKey: key,
      });
    } catch (error) {
      refusalAsHttp(error);
    }
  }
}
