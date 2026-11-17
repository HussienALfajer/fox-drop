import { Body, HttpCode, HttpStatus, NotFoundException, Post } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedInOrGuest, OptionalAppSession } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import type { StorefrontState } from '../merchants/index.js';
import { type Quote, QuoteRefusedError, QuoteService } from './quote.service.js';

export const minor = z
  .string()
  .regex(/^-?\d+$/)
  .describe('Integer minor units (AP §8.6).');

// Q25: a note with a run of 7 or more digits looks like a phone number.
export const noPhone = (text: string) => !/\p{Nd}{7,}/u.test(text);

export const cartLines = z
  .array(
    z.object({
      itemId: z.uuid(),
      optionIds: z.array(z.uuid()).max(50),
      quantity: z.int().min(1).max(20).describe('1 to 20 per line (fixed).'),
      note: z
        .string()
        .trim()
        .min(1)
        .max(100)
        .refine(noPhone, 'no phone numbers in a note (Q25)')
        .nullable()
        .describe('«مثلاً: بدون بصل», up to 100 characters; no phone number.'),
      knownUnitPrice: minor.describe(
        'The unit price the customer last saw, with the options; a change is price_changed.',
      ),
    }),
  )
  .min(1)
  .max(50);

export const payInCurrency = z
  .string()
  .regex(/^[A-Z]{3}$/)
  .nullable()
  .describe(
    '«سأدفع بـ»: an accepted currency, or null for «لم أحدد» (CU §10.5); one no longer accepted gives payIn null.',
  );

// CU §10.4: «أدخل الكود»; trimmed and upper-cased by the server.
export const promoCodeInput = z
  .string()
  .trim()
  .max(40)
  .nullable()
  .default(null)
  .describe('The code typed («تطبيق»), or null; validated by every rule of AP §9.11.1.');

export const appVersion = z.string().regex(/^\d+\.\d+\.\d+$/, 'expected a version such as 1.4.0');

class CustomerQuoteRequestDto extends createZodDto(
  z.object({
    restaurantId: z.uuid(),
    location: z
      .object({ latitude: z.number().min(-90).max(90), longitude: z.number().min(-180).max(180) })
      .describe('The delivery point: the address pin or the selected point.'),
    lines: cartLines,
    payIn: payInCurrency,
    appVersion,
    code: promoCodeInput,
    openedCheckout: z
      .boolean()
      .default(false)
      .describe(
        'True on the quote asked on opening checkout: a signed-in customer then counts once per emergency stop (AP §9.1.6).',
      ),
  }),
) {}

const amount = z.object({ amount: minor, currency: z.string().length(3) });

class CustomerQuoteDto extends createZodDto(
  z.object({
    version: z
      .string()
      .describe(
        'Changes only with a money line, an equivalent, the rates or a blocking problem; the order command carries it.',
      ),
    restaurant: z.object({
      id: z.uuid(),
      state: z.enum(['open', 'busy', 'paused', 'closed', 'holiday']),
      busyMode: z.boolean(),
      until: z.iso.datetime().nullable(),
      opensAt: z.iso.datetime().nullable(),
      message: z.string().nullable(),
    }),
    lines: z.array(
      z.object({
        itemId: z.uuid(),
        name: z.string().nullable().describe('Null for an item no longer on the menu.'),
        quantity: z.int(),
        note: z.string().nullable(),
        options: z.array(z.object({ id: z.uuid(), name: z.string(), priceDelta: minor })),
        unitPrice: minor.nullable().describe('Null for a line that cannot be ordered.'),
        lineTotal: minor.nullable(),
      }),
    ),
    currency: z.string().length(3).describe('The base currency of every money line.'),
    money: z.object({
      itemsValue: minor.describe('«قيمة الأصناف».'),
      deliveryFee: minor.describe('«رسوم التوصيل».'),
      deliveryFree: z.boolean().describe('«مجاني».'),
      discount: minor.describe('«الخصم», with the code; 0 without one.'),
      rounding: minor.describe('«تقريب», shown only when not 0.'),
      total: minor.describe('«المجموع».'),
    }),
    equivalents: z
      .array(amount)
      .describe('«أو {المبلغ} $ · {المبلغ} ل.س»: each other accepted currency, by its rounding.'),
    payIn: amount.nullable().describe('«ستدفع حوالي {المبلغ} {العملة}».'),
    estimate: z
      .object({ fromMin: z.int(), toMin: z.int() })
      .describe('«يصل خلال {fromMin}–{toMin} د».'),
    minimumOrder: z.object({
      amount: minor,
      currency: z.string().length(3),
      reached: z.boolean(),
      missing: minor.describe('«أضف {المبلغ} لتصل إلى الحد الأدنى ({الحد})».'),
    }),
    freeDelivery: z
      .object({
        threshold: minor,
        reached: z.boolean().describe('«توصيلك مجاني».'),
        missing: minor.describe('«أضف {المبلغ} لتحصل على توصيل مجاني».'),
      })
      .nullable(),
    rates: z
      .array(z.object({ currency: z.string().length(3), rateVersionId: z.uuid().nullable() }))
      .describe('The exchange-rate version: null for the base currency.'),
    promoCode: z
      .object({
        code: z.string(),
        kind: z.enum(['percentage', 'fixed_amount', 'free_delivery']),
        discount: minor,
        fixedAmountAboveItems: z
          .boolean()
          .describe('«قيمة الكود أكبر من قيمة الأصناف، ولا يُستعاد الفرق» before confirming.'),
      })
      .nullable()
      .describe('The code that applies (CU §10.4); null without one or when refused.'),
    availableCodes: z
      .array(
        z.object({
          code: z.string(),
          kind: z.enum(['percentage', 'fixed_amount', 'free_delivery']),
          percentBp: z.int().nullable().describe('A percentage in basis points (2000 is 20%).'),
          amount: minor.nullable().describe('A fixed amount.'),
          maxDiscount: minor.nullable().describe('The cap of a percentage, or null.'),
          minOrder: minor.nullable().describe('The minimum on the items value, or null.'),
          hours: z
            .object({ startMinute: z.int(), endMinute: z.int() })
            .nullable()
            .describe(
              'The hours on the city clock, minutes from midnight; an end at or before the start runs past midnight.',
            ),
          validTo: z.iso.datetime().describe('«ينتهي {التاريخ}».'),
          discount: minor
            .nullable()
            .describe('What it takes off this cart; null while below its minimum.'),
          missing: minor
            .nullable()
            .describe('«أضف {المبلغ} لاستخدام هذا الكود»; null when it applies.'),
        }),
      )
      .describe(
        '«الأكواد المتاحة لك» (CU §10.4): the visible codes that apply to this cart, largest discount first, then those below their minimum.',
      ),
    suggestedCode: z
      .object({ code: z.string(), discount: minor })
      .nullable()
      .describe(
        '«لديك كود يوفر عليك {المبلغ}: {الكود}» with «تطبيق» (Q19): the largest discount above the applied code; never applied by itself (U11).',
      ),
    problems: z
      .array(
        z.object({
          code: z.enum([
            'update_required',
            'maintenance',
            'platform_closed',
            'outside_zones',
            'not_covered',
            'restaurant_closed',
            'below_minimum_order',
            'minimum_not_in_base_currency',
            'delivery_unpriced',
            'rates_unavailable',
            'captain_pay_unset',
            'one_order_at_a_time',
            'active_order_limit',
            'no_captain_nearby',
            'terms_pending',
            'emergency_stop',
            'review_stop',
            'dues_unpaid',
            'account_blocked',
            'promo_code',
            'item_not_found',
            'item_unavailable',
            'option_not_found',
            'option_unavailable',
            'options_invalid',
            'price_not_in_base_currency',
            'price_changed',
          ]),
          line: z.int().nullable().describe('The cart line, for a line problem.'),
          opensAt: z.iso
            .datetime()
            .nullable()
            .describe('platform_closed: «FOX DROP يستقبل الطلبات من الساعة {الساعة}».'),
          message: z
            .string()
            .nullable()
            .describe(
              "emergency_stop: the browsing message (AP §9.1.6); account_blocked: the block reason's customer text (CU Appendix C).",
            ),
          amount: amount
            .nullable()
            .describe(
              'dues_unpaid: what the customer owes (CU §5.5, AP §8.8); promo_code below_minimum: «أضف {المبلغ} لاستخدام هذا الكود».',
            ),
          refusal: z
            .enum([
              'unknown_code',
              'not_valid_now',
              'below_minimum',
              'not_for_restaurant',
              'first_order_only',
              'used_before',
              'uses_ended',
              'budget_reached',
            ])
            .nullable()
            .describe('promo_code: why the code does not apply (CU Appendix C «Code refusals»).'),
          until: z.iso
            .datetime()
            .nullable()
            .describe(
              "account_blocked: the block's end («حسابك محظور حتى {التاريخ}: {السبب}»); null until further notice («حسابك محظور: {السبب}. تواصل مع الدعم.»).",
            ),
        }),
      )
      .describe('CU §10.6: every one blocks ordering; the texts are in Appendix C.'),
  }),
) {}

// CU §10.6: the quote of the cart, asked for on every change of the cart,
// the address or the code, and on opening checkout. Open to guests, who see
// the full quote (CU §5.1); a signed-in customer's also checks their
// active-order limit (CU §5.5).
@CustomerController()
export class CustomerQuoteController {
  constructor(private readonly quotes: QuoteService) {}

  // 404 unknown_restaurant for a restaurant customers do not see.
  @Post('quote')
  @AppSignedInOrGuest()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerQuoteDto })
  async quote(
    @OptionalAppSession() session: AppSession | null,
    @Body() body: CustomerQuoteRequestDto,
  ) {
    try {
      const quote = await this.quotes.quote(
        {
          ...body,
          lines: body.lines.map((line) => ({
            ...line,
            knownUnitPrice: BigInt(line.knownUnitPrice),
          })),
          customerAccountId: session?.accountId ?? null,
          deviceId: session?.deviceId ?? null,
        },
        new Date(),
      );
      return quoteBody(quote);
    } catch (error) {
      if (!(error instanceof QuoteRefusedError)) throw error;
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
    }
  }
}

function stateBody({ state, message, opensAt }: StorefrontState) {
  const until = state.state === 'paused' || state.state === 'holiday' ? state.until : null;
  return {
    state: state.state as 'open' | 'busy' | 'paused' | 'closed' | 'holiday',
    busyMode: state.state === 'open' && state.busyExtraMin !== null,
    until: until?.toISOString() ?? null,
    opensAt: opensAt?.toISOString() ?? null,
    message,
  };
}

const text = (value: bigint) => value.toString();
const textOrNull = (value: bigint | null) => (value === null ? null : value.toString());

export function quoteBody(quote: Quote) {
  return {
    version: quote.version,
    restaurant: { id: quote.restaurant.id, ...stateBody(quote.restaurant.state) },
    lines: quote.lines.map((line) => ({
      itemId: line.itemId,
      name: line.name,
      quantity: line.quantity,
      note: line.note,
      options: line.options.map((option) => ({ ...option, priceDelta: text(option.priceDelta) })),
      unitPrice: textOrNull(line.unitPrice),
      lineTotal: textOrNull(line.lineTotal),
    })),
    currency: quote.currency,
    money: {
      itemsValue: text(quote.money.itemsValue),
      deliveryFee: text(quote.money.deliveryFee),
      deliveryFree: quote.deliveryFree,
      discount: text(quote.money.discount),
      rounding: text(quote.money.rounding),
      total: text(quote.money.total),
    },
    equivalents: quote.equivalents.map((entry) => ({ ...entry, amount: text(entry.amount) })),
    payIn: quote.payIn === null ? null : { ...quote.payIn, amount: text(quote.payIn.amount) },
    estimate: quote.estimate,
    minimumOrder: {
      amount: text(quote.minimumOrder.amount),
      currency: quote.minimumOrder.currency,
      reached: quote.minimumOrder.reached,
      missing: text(quote.minimumOrder.missing),
    },
    freeDelivery:
      quote.freeDelivery === null
        ? null
        : {
            threshold: text(quote.freeDelivery.threshold),
            reached: quote.freeDelivery.reached,
            missing: text(quote.freeDelivery.missing),
          },
    rates: quote.rates,
    promoCode: quote.promoCode && {
      ...quote.promoCode,
      discount: text(quote.promoCode.discount),
    },
    availableCodes: quote.availableCodes.map((entry) => ({
      code: entry.code,
      kind: entry.kind,
      percentBp: entry.percentBp,
      amount: textOrNull(entry.amount),
      maxDiscount: textOrNull(entry.maxDiscount),
      minOrder: textOrNull(entry.minOrder),
      hours:
        entry.startMinute === null || entry.endMinute === null
          ? null
          : { startMinute: entry.startMinute, endMinute: entry.endMinute },
      validTo: entry.validTo.toISOString(),
      discount: textOrNull(entry.discount?.total ?? null),
      missing: textOrNull(entry.missing),
    })),
    suggestedCode: quote.suggestedCode && {
      code: quote.suggestedCode.code,
      discount: text(quote.suggestedCode.discount),
    },
    problems: quote.problems.map((entry) => ({
      ...entry,
      opensAt: entry.opensAt?.toISOString() ?? null,
      until: entry.until?.toISOString() ?? null,
      amount: entry.amount && {
        amount: entry.amount.amount.toString(),
        currency: entry.amount.currency,
      },
    })),
  };
}
