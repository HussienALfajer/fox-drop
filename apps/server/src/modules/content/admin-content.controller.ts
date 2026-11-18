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
import {
  CurrentAdminSession,
  RequireAnyPermission,
  RequirePermission,
  SignedIn,
} from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { FilesRefusedError } from '../files/index.js';
import { CATEGORIES_MAX, CATEGORY_NAME_MAX, CategoriesService } from './categories.service.js';
import { ContactSchema } from './contact.js';
import { ContentRefusedError, ContentService, type ContentEdit } from './content.service.js';
import {
  NOTIFICATION_TEXT_MAX,
  notificationAudiences,
  notificationLevels,
} from './notification-templates.js';
import { NotificationTexts } from './notification-texts.service.js';
import {
  ANSWER_MAX,
  CANNED_BODY_MAX,
  CANNED_REPLIES_MAX,
  CANNED_TITLE_MAX,
  CUSTOMER_TEXT_MAX,
  FAQ_MAX_ITEMS,
  faqAudiences,
  LABEL_MAX,
  noteModes,
  QUESTION_MAX,
  reasonListNames,
  reasonLists,
  WORK_RULES_MAX,
} from './lists.js';

// AP §9.13 «المحتوى». Who (AP §6.2): OWN edits everything (content.manage),
// OPS reads (content.read), SUP edits the FAQs (content.faqs).

const reason = z.object({
  code: z.string(),
  label: z.string(),
  customerText: z.string().nullable(),
  note: z.enum(noteModes).describe('Whether the choice takes a note: none, optional, required.'),
  fixed: z.boolean().describe('The code acts on it: it cannot be removed.'),
  active: z.boolean().describe('False once removed: hidden from new choices, kept on orders.'),
  captainFault: z
    .boolean()
    .nullable()
    .describe(
      "The reassignment list's default fault («بخطأ من الكابتن»), which the dialog prefills; null in the other lists.",
    ),
});

class AdminReasonDto extends createZodDto(reason) {}

class AdminReasonListsDto extends createZodDto(
  z.object({
    lists: z.array(
      z.object({
        list: z.enum(reasonListNames),
        apps: z.array(z.enum(['merchant', 'captain', 'customer'])),
        customerText: z.boolean().describe('Its reasons may carry «نص للزبون».'),
        closed: z.boolean().describe('No reason can be added.'),
        fault: z.boolean().describe('Its reasons carry their default fault (reassignment).'),
        reasons: z.array(reason),
      }),
    ),
  }),
) {}

class ListParamsDto extends createZodDto(z.object({ list: z.string().max(40) })) {}

class ReasonParamsDto extends createZodDto(
  z.object({ list: z.string().max(40), code: z.string().max(40) }),
) {}

const reasonFields = {
  label: z.string().min(1).max(LABEL_MAX),
  customerText: z
    .string()
    .max(CUSTOMER_TEXT_MAX)
    .nullable()
    .describe('Only in the lists with customer texts; null shows the generic apology.'),
  note: z
    .enum(noteModes)
    .describe('none, optional or required («أخرى» with its text); none in a closed list.'),
  captainFault: z
    .boolean()
    .nullable()
    .default(null)
    .describe('Required in the reassignment list (its default fault), null in the others.'),
};

class AddReasonDto extends createZodDto(z.object(reasonFields)) {}

class UpdateReasonDto extends createZodDto(
  z.object({ ...reasonFields, active: z.boolean().describe('False removes it from the list.') }),
) {}

class ReorderDto extends createZodDto(
  z.object({ codes: z.array(z.string().max(40)).max(100).describe('Every code of the list.') }),
) {}

class AdminReasonOrderDto extends createZodDto(z.object({ reasons: z.array(reason) })) {}

const faqItems = z
  .array(
    z.object({
      question: z.string().min(1).max(QUESTION_MAX),
      answer: z.string().min(1).max(ANSWER_MAX),
    }),
  )
  .max(FAQ_MAX_ITEMS);

class AdminFaqsDto extends createZodDto(
  z.object({ customer: faqItems, captain: faqItems, merchant: faqItems }),
) {}

class FaqParamsDto extends createZodDto(z.object({ audience: z.enum(faqAudiences) })) {}

class AdminFaqDto extends createZodDto(z.object({ items: faqItems })) {}

class AdminCannedRepliesDto extends createZodDto(
  z.object({
    replies: z
      .array(
        z.object({
          title: z.string().trim().min(1).max(CANNED_TITLE_MAX),
          body: z.string().trim().min(1).max(CANNED_BODY_MAX),
        }),
      )
      .max(CANNED_REPLIES_MAX),
  }),
) {}

class AdminTextsDto extends createZodDto(
  z.object({
    workRules: z.string().describe('CA §11.4, plain text with one rule per line.'),
    contact: ContactSchema,
  }),
) {}

class AdminWorkRulesDto extends createZodDto(
  z.object({ workRules: z.string().max(WORK_RULES_MAX) }),
) {}

class AdminUpdateContactDto extends createZodDto(
  z.object({
    phone: z.string().nullable().describe('E.164, or null to hide «اتصال بالدعم».'),
    whatsapp: z.string().nullable().describe('E.164, or null to hide «واتساب الدعم».'),
  }),
) {}

class AdminContactDto extends createZodDto(ContactSchema) {}

const notificationText = z.object({
  key: z.string().describe('The template, such as customer.accepted.'),
  audience: z.enum(notificationAudiences),
  row: z.string().describe('The spec row it comes from, such as «CU §14 #1».'),
  variables: z.array(z.string()).describe('The placeholders it takes, without braces.'),
  level: z.enum(notificationLevels).describe("The app's sound level; not editable."),
  priority: z.enum(['high', 'normal']).describe('Not editable.'),
  text: z.string().describe('The default text.'),
  current: z.string().describe("The text in use: the admin's edit, else the default."),
});

class AdminNotificationTextsDto extends createZodDto(
  z.object({ templates: z.array(notificationText) }),
) {}

class AdminNotificationTextDto extends createZodDto(notificationText) {}

class NotificationParamsDto extends createZodDto(z.object({ key: z.string().max(80) })) {}

class AdminUpdateNotificationTextDto extends createZodDto(
  z.object({
    text: z
      .string()
      .min(1)
      .max(NOTIFICATION_TEXT_MAX)
      .describe('Only the placeholders the template takes, as {name}.'),
  }),
) {}

function contentError(error: unknown): unknown {
  if (error instanceof FilesRefusedError) {
    if (error.refusal === 'upload_not_found') {
      return new NotFoundException({ statusCode: 404, error: error.refusal });
    }
    if (error.refusal === 'upload_wrong_purpose' || error.refusal === 'upload_invalid') {
      return new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
    }
    return new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
  }
  if (!(error instanceof ContentRefusedError)) return error;
  if (
    error.refusal === 'unknown_list' ||
    error.refusal === 'unknown_reason' ||
    error.refusal === 'unknown_template' ||
    error.refusal === 'unknown_category'
  ) {
    return new NotFoundException({ statusCode: 404, error: error.refusal, message: error.message });
  }
  if (error.refusal === 'upload_used') {
    return new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
  }
  return new BadRequestException({
    statusCode: HttpStatus.BAD_REQUEST,
    error: error.refusal,
    message: error.message,
  });
}

const category = z.object({
  id: z.uuid(),
  name: z.string(),
  imageKey: z
    .string()
    .nullable()
    .describe(
      'Its key in public-media, shown through /media/ (architecture §5.8); null without one.',
    ),
  active: z
    .boolean()
    .describe('False once removed: off the cards and the list, kept on its restaurants.'),
});

class AdminCategoryDto extends createZodDto(category) {}

class AdminCategoriesDto extends createZodDto(
  z.object({ categories: z.array(category).describe('In their order, removed ones included.') }),
) {}

class CategoryParamsDto extends createZodDto(z.object({ categoryId: z.uuid() })) {}

const categoryName = z.string().trim().min(1).max(CATEGORY_NAME_MAX);

class AdminNewCategoryDto extends createZodDto(z.object({ name: categoryName })) {}

class AdminUpdateCategoryDto extends createZodDto(
  z.object({ name: categoryName, active: z.boolean().describe('False removes it.') }),
) {}

class AdminCategoryImageDto extends createZodDto(
  z.object({ uploadId: z.uuid().describe('From POST /v1/admin/uploads (category_image).') }),
) {}

class AdminCategoryOrderDto extends createZodDto(
  z.object({
    ids: z.array(z.uuid()).max(CATEGORIES_MAX).describe('Every category once, removed ones too.'),
  }),
) {}

async function refusalsAsHttp<T>(action: () => Promise<T>): Promise<T> {
  try {
    return await action();
  } catch (error) {
    throw contentError(error);
  }
}

function editBy(session: AdminSession, request: FastifyRequest): ContentEdit {
  return {
    admin: { accountId: session.accountId, roles: session.roles },
    context: requestContext(request),
  };
}

@AdminController('content')
export class AdminContentController {
  constructor(
    private readonly content: ContentService,
    private readonly categories: CategoriesService,
    private readonly notifications: NotificationTexts,
  ) {}

  // «التصنيفات» (AP §9.13, slice 2.27a): read by OWN and OPS (content.read)
  // and DATA (content.categories), edited by OWN and DATA (AP §6.2). An edit
  // sets a state to a value, so none takes an Idempotency-Key; adding twice
  // is refused as duplicate_label.
  @Get('categories')
  @RequireAnyPermission('content.read', 'content.categories')
  @ZodResponse({ status: 200, type: AdminCategoriesDto })
  async categoryList() {
    return { categories: await this.categories.all() };
  }

  // 400 duplicate_label, invalid_value (more than CATEGORIES_MAX).
  @Post('categories')
  @RequirePermission('content.categories')
  @ZodResponse({ status: 201, type: AdminCategoryDto })
  addCategory(
    @Body() body: AdminNewCategoryDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(() => this.categories.create(body.name, editBy(session, request)));
  }

  // 400 invalid_order.
  @Post('categories/order')
  @HttpCode(200)
  @RequirePermission('content.categories')
  @ZodResponse({ status: 200, type: AdminCategoriesDto })
  reorderCategories(
    @Body() body: AdminCategoryOrderDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => ({
      categories: await this.categories.reorder(body.ids, editBy(session, request)),
    }));
  }

  // 404 unknown_category; 400 duplicate_label.
  @Put('categories/:categoryId')
  @RequirePermission('content.categories')
  @ZodResponse({ status: 200, type: AdminCategoryDto })
  updateCategory(
    @Param() params: CategoryParamsDto,
    @Body() body: AdminUpdateCategoryDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(() =>
      this.categories.update(params.categoryId, body, editBy(session, request)),
    );
  }

  // 404 unknown_category, upload_not_found; 400 upload_wrong_purpose,
  // upload_invalid; 409 upload_missing, upload_expired, upload_used.
  @Put('categories/:categoryId/image')
  @RequirePermission('content.categories')
  @ZodResponse({ status: 200, type: AdminCategoryDto })
  setCategoryImage(
    @Param() params: CategoryParamsDto,
    @Body() body: AdminCategoryImageDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(() =>
      this.categories.setImage(params.categoryId, body.uploadId, editBy(session, request)),
    );
  }

  // «قوائم الأسباب», «الملاحظات الجاهزة» and «نصوص الأسباب للزبون».
  @Get('reasons')
  @RequirePermission('content.read')
  @ZodResponse({ status: 200, type: AdminReasonListsDto })
  async lists() {
    const lists = await this.content.allLists();
    return {
      lists: lists.map(({ list, reasons }) => {
        const definition: { apps: readonly string[]; customerText?: true; closed?: true } =
          reasonLists[list];
        return {
          list,
          apps: [...definition.apps],
          customerText: definition.customerText ?? false,
          closed: definition.closed ?? false,
          fault: list === 'reassignment',
          reasons,
        };
      }),
    } as AdminReasonListsDto;
  }

  // 400 list_closed, duplicate_label, customer_text_not_allowed; 404 unknown_list.
  @Post('reasons/:list')
  @RequirePermission('content.manage')
  @ZodResponse({ status: 201, type: AdminReasonDto })
  add(
    @Param() params: ListParamsDto,
    @Body() body: AddReasonDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(() =>
      this.content.addReason(params.list, body, editBy(session, request)),
    );
  }

  // 400 reason_fixed (a fixed reason stays active), duplicate_label,
  // customer_text_not_allowed; 404 unknown_list, unknown_reason.
  @Put('reasons/:list/:code')
  @RequirePermission('content.manage')
  @ZodResponse({ status: 200, type: AdminReasonDto })
  update(
    @Param() params: ReasonParamsDto,
    @Body() body: UpdateReasonDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(() =>
      this.content.updateReason(params.list, params.code, body, editBy(session, request)),
    );
  }

  // 400 invalid_order; 404 unknown_list.
  @Post('reasons/:list/order')
  @HttpCode(200)
  @RequirePermission('content.manage')
  @ZodResponse({ status: 200, type: AdminReasonOrderDto })
  async reorder(
    @Param() params: ListParamsDto,
    @Body() body: ReorderDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => ({
      reasons: await this.content.reorder(params.list, body.codes, editBy(session, request)),
    }));
  }

  // The three FAQ sets: read with content.read or content.faqs (SUP).
  @Get('faqs')
  @SignedIn()
  @ZodResponse({ status: 200, type: AdminFaqsDto })
  async faqs(@CurrentAdminSession() session: AdminSession) {
    mayAny(session, ['content.read', 'content.faqs']);
    const [customer, captain, merchant] = await Promise.all(
      faqAudiences.map((audience) => this.content.faq(audience)),
    );
    return { customer, captain, merchant } as AdminFaqsDto;
  }

  @Put('faqs/:audience')
  @RequirePermission('content.faqs')
  @ZodResponse({ status: 200, type: AdminFaqDto })
  updateFaq(
    @Param() params: FaqParamsDto,
    @Body() body: AdminFaqDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => ({
      items: await this.content.updateFaq(params.audience, body.items, editBy(session, request)),
    }));
  }

  // AP §9.13 «الردود الجاهزة» (slice 2.23b): read by «المحتوى» and by the
  // ticket page (support.read), edited by OWN and SUP (content.faqs: AP §6
  // «FAQs and canned replies»).
  @Get('canned-replies')
  @RequireAnyPermission('content.read', 'content.faqs', 'support.read')
  @ZodResponse({ status: 200, type: AdminCannedRepliesDto })
  async cannedReplies() {
    return { replies: await this.content.cannedReplies() } as AdminCannedRepliesDto;
  }

  @Put('canned-replies')
  @RequirePermission('content.faqs')
  @ZodResponse({ status: 200, type: AdminCannedRepliesDto })
  updateCannedReplies(
    @Body() body: AdminCannedRepliesDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => ({
      replies: await this.content.updateCannedReplies(body.replies, editBy(session, request)),
    }));
  }

  // The captain work rules page and the contact info.
  @Get('texts')
  @RequirePermission('content.read')
  @ZodResponse({ status: 200, type: AdminTextsDto })
  async texts() {
    const [workRules, contact] = await Promise.all([
      this.content.workRules(),
      this.content.contact(),
    ]);
    return { workRules, contact };
  }

  @Put('work-rules')
  @RequirePermission('content.manage')
  @ZodResponse({ status: 200, type: AdminWorkRulesDto })
  updateWorkRules(
    @Body() body: AdminWorkRulesDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => ({
      workRules: await this.content.updateWorkRules(body.workRules, editBy(session, request)),
    }));
  }

  // 400 invalid_value: a number not in E.164.
  @Put('contact')
  @RequirePermission('content.manage')
  @ZodResponse({ status: 200, type: AdminContactDto })
  updateContact(
    @Body() body: AdminUpdateContactDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(() => this.content.updateContact(body, editBy(session, request)));
  }

  // «نصوص الإشعارات» (AP §9.13): every push's text, read by OWN and OPS.
  @Get('notifications')
  @RequirePermission('content.read')
  @ZodResponse({ status: 200, type: AdminNotificationTextsDto })
  async notificationTexts() {
    return { templates: await this.notifications.all() };
  }

  // 404 unknown_template; 400 invalid_value, unknown_variable.
  @Put('notifications/:key')
  @RequirePermission('content.manage')
  @ZodResponse({ status: 200, type: AdminNotificationTextDto })
  updateNotificationText(
    @Param() params: NotificationParamsDto,
    @Body() body: AdminUpdateNotificationTextDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(() =>
      this.notifications.update(params.key, body.text, editBy(session, request)),
    );
  }
}

function mayAny(session: AdminSession, permissions: AdminSession['permissions']): void {
  if (!permissions.some((permission) => session.permissions.includes(permission))) {
    throw new ForbiddenException();
  }
}
