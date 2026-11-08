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
      discount: minor.describe('«الخصم»; 0 until codes arrive.'),
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
            .describe('emergency_stop: the browsing message (AP §9.1.6).'),
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
    problems: quote.problems.map((entry) => ({
      ...entry,
      opensAt: entry.opensAt?.toISOString() ?? null,
    })),
  };
}
