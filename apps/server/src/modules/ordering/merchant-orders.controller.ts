import { ForbiddenException, Get, HttpStatus } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import { CustomersService } from '../customers/index.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { minor } from './customer-quote.controller.js';
import type { OrderView } from './order-views.js';
import { OrdersService } from './orders.service.js';
import { orderStatuses } from './schema.js';

class MerchantOrdersDto extends createZodDto(
  z.object({
    orders: z
      .array(
        z.object({
          id: z.uuid(),
          number: z.string().describe('Shown as #10423 (AP §4.8).'),
          status: z.enum(orderStatuses).describe('AP §8.1; the board column (RA §8.1–8.2).'),
          version: z
            .int()
            .describe(
              'Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).',
            ),
          placedAt: z.iso.datetime(),
          autoCancelAt: z.iso
            .datetime()
            .nullable()
            .describe('«يُلغى تلقائياً خلال {د:ث}» counts down to it while placed (RA §8.3).'),
          customer: z
            .object({
              firstName: z
                .string()
                .nullable()
                .describe('Null while the customer has not completed the account (CU §5.3).'),
              neighbourhood: z.string(),
            })
            .describe('Never the phone number, the last name or the full address (RA §8.4).'),
          note: z.string().nullable().describe("The customer's note."),
          lines: z.array(
            z.object({
              name: z.string(),
              quantity: z.int(),
              options: z.array(z.object({ name: z.string() })),
              note: z.string().nullable(),
              lineTotal: minor,
            }),
          ),
          currency: z.string().length(3),
          itemsValue: minor.describe(
            '«قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام» (RA §8.4); the delivery fee and the customer total are never shown (R11).',
          ),
        }),
      )
      .describe('Every order until it is delivered or ends, oldest first (RA §8.2).'),
  }),
) {}

// RA §8.2–8.4, §4.3: the board's orders, which the restaurant app fetches on
// opening and after every reconnect before it shows them, for owners and
// cashiers alike. A terminated restaurant's owners keep only the money
// section (RA §5.5).
@MerchantController()
export class MerchantOrdersController {
  constructor(
    private readonly orders: OrdersService,
    private readonly merchants: MerchantsService,
    private readonly customers: CustomersService,
  ) {}

  @Get('orders')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantOrdersDto })
  async board(@CurrentAppSession() session: AppSession) {
    if (!session.merchant) throw new Error('a merchant route without a restaurant user');
    const { restaurantId } = session.merchant;
    if ((await this.merchants.accountStatus(restaurantId)) === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    const orders = await this.orders.restaurantActiveOrders(restaurantId);
    return { orders: await Promise.all(orders.map((order) => this.orderBody(order))) };
  }

  private async orderBody(order: OrderView) {
    const profile = await this.customers.profile(order.customerAccountId);
    return {
      id: order.id,
      number: order.number.toString(),
      status: order.status,
      version: order.version,
      placedAt: order.placedAt.toISOString(),
      autoCancelAt: order.autoCancelAt?.toISOString() ?? null,
      customer: {
        firstName: profile?.firstName ?? null,
        neighbourhood: order.address.neighbourhood,
      },
      note: order.note,
      lines: order.lines.map((line) => ({
        name: line.name,
        quantity: line.quantity,
        options: line.options.map((option) => ({ name: option.name })),
        note: line.note,
        lineTotal: line.lineTotal.toString(),
      })),
      currency: order.currency,
      itemsValue: order.money.itemsValue.toString(),
    };
  }
}
