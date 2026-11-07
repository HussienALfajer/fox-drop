import {
  BadRequestException,
  Body,
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
import { CurrentAdminSession, RequirePermission, SignedIn } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { ContactSchema } from './contact.js';
import { ContentRefusedError, ContentService, type ContentEdit } from './content.service.js';
import {
  ANSWER_MAX,
  CUSTOMER_TEXT_MAX,
  FAQ_MAX_ITEMS,
  faqAudiences,
  LABEL_MAX,
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
  needsText: z.boolean(),
  fixed: z.boolean().describe('The code acts on it: it cannot be removed.'),
  active: z.boolean().describe('False once removed: hidden from new choices, kept on orders.'),
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
  needsText: z.boolean().describe('«أخرى»: the choice needs its text.'),
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

function contentError(error: unknown): unknown {
  if (!(error instanceof ContentRefusedError)) return error;
  if (error.refusal === 'unknown_list' || error.refusal === 'unknown_reason') {
    return new NotFoundException({ statusCode: 404, error: error.refusal, message: error.message });
  }
  return new BadRequestException({
    statusCode: HttpStatus.BAD_REQUEST,
    error: error.refusal,
    message: error.message,
  });
}

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
  constructor(private readonly content: ContentService) {}

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
}

function mayAny(session: AdminSession, permissions: AdminSession['permissions']): void {
  if (!permissions.some((permission) => session.permissions.includes(permission))) {
    throw new ForbiddenException();
  }
}
