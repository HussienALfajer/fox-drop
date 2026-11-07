import { Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { Public } from '../../http/access.js';
import {
  CaptainController,
  CustomerController,
  MerchantController,
} from '../../http/route-groups.js';
import { ContentService } from './content.service.js';
import { type ContentApp, noteModes, type ReasonList } from './lists.js';

// AP §9.13, CA §4.10, CA §11.4, CU §10.2, RA §15: what each app reads from
// Content, public like the contact (the work rules are shown before sign-in,
// CA §5): its reason lists (the active reasons in order), its FAQ set and,
// for the captain, the work rules page.

const reasonChoice = z.object({
  code: z.string().describe('Stable: sent back with a choice, kept by the order.'),
  label: z.string(),
  note: z
    .enum(noteModes)
    .describe('Whether the choice takes a note: none, optional or required («أخرى»).'),
});

const faqItem = z.object({ question: z.string(), answer: z.string() });

function lists<const Names extends readonly ReasonList[]>(names: Names) {
  return z.object(
    Object.fromEntries(names.map((name) => [name, z.array(reasonChoice)])) as {
      [Name in Names[number]]: z.ZodArray<typeof reasonChoice>;
    },
  );
}

export const merchantLists = [
  'merchant_rejection',
  'merchant_problem',
  'item_unavailable_note',
  'merchant_ticket_type',
] as const;

export const captainLists = [
  'captain_cannot_complete',
  'captain_away',
  'shortfall',
  'food_after_failed',
  'captain_ticket_type',
  'captain_problem',
] as const;

export const customerLists = [
  'customer_cancel',
  'customer_problem',
  'order_note',
  'restaurant_rating_low',
  'restaurant_rating_mid',
  'restaurant_rating_high',
  'captain_rating_low',
  'captain_rating_mid',
  'captain_rating_high',
] as const;

class MerchantContentDto extends createZodDto(
  z.object({ reasons: lists(merchantLists), faq: z.array(faqItem) }),
) {}

class CaptainContentDto extends createZodDto(
  z.object({
    reasons: lists(captainLists),
    faq: z.array(faqItem),
    workRules: z.string().describe('CA §11.4, plain text with one rule per line.'),
  }),
) {}

class CustomerContentDto extends createZodDto(
  z.object({
    reasons: lists(customerLists).describe(
      'order_note: «الملاحظات الجاهزة» at checkout; the rating lists by stars (1–2, 3, 4–5).',
    ),
    faq: z.array(faqItem),
  }),
) {}

async function read(content: ContentService, app: ContentApp) {
  const [reasons, faq] = await Promise.all([content.listsFor(app), content.faq(app)]);
  return { reasons, faq };
}

@MerchantController('content')
export class MerchantContentController {
  constructor(private readonly content: ContentService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: MerchantContentDto })
  get() {
    return read(this.content, 'merchant') as Promise<MerchantContentDto>;
  }
}

@CaptainController('content')
export class CaptainContentController {
  constructor(private readonly content: ContentService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: CaptainContentDto })
  async get() {
    const [body, workRules] = await Promise.all([
      read(this.content, 'captain'),
      this.content.workRules(),
    ]);
    return { ...body, workRules } as CaptainContentDto;
  }
}

@CustomerController('content')
export class CustomerContentController {
  constructor(private readonly content: ContentService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: CustomerContentDto })
  get() {
    return read(this.content, 'customer') as Promise<CustomerContentDto>;
  }
}
