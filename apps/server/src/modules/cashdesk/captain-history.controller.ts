import { BadRequestException, ForbiddenException, Get, HttpStatus, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import { CaptainsService } from '../captains/index.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  AppHistories,
  type CaptainHistoryRow,
  captainSteps,
  HISTORY_PAGE,
  HistoryRefusedError,
} from '../ordering/index.js';
import { orderLines } from './earnings.js';

const minor = z
  .string()
  .regex(/^-?\d{1,19}$/)
  .describe('Integer minor units of its currency.');

const lines = z.array(z.object({ currency: z.string().length(3), amount: minor }));

// A page's cursor: the placing time and id of the last order shown.
const CURSOR = /^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z)_([0-9a-f-]{36})$/;

class CaptainOrderHistoryQueryDto extends createZodDto(
  z
    .object({
      from: z.iso
        .date()
        .optional()
        .describe(
          'The first business day, YYYY-MM-DD on the city clock; with `to`. None: every order.',
        ),
      to: z.iso.date().optional().describe('The last business day, included; with `from`.'),
      cursor: z
        .string()
        .regex(CURSOR)
        .refine((cursor) => !Number.isNaN(Date.parse(cursor.split('_')[0]!)), 'a real moment')
        .optional()
        .describe('The `next` of the page before; none for the first page.'),
    })
    .refine((query) => (query.from === undefined) === (query.to === undefined), {
      message: 'from and to go together',
    }),
) {}

class CaptainOrderHistoryDto extends createZodDto(
  z.object({
    payCurrency: z.string().length(3).describe("The city's base currency, the pay's."),
    orders: z
      .array(
        z.object({
          id: z.uuid(),
          number: z.string(),
          placedAt: z.iso.datetime(),
          day: z.iso.date().describe('The business day it was placed on, for the grouping.'),
          restaurantName: z.string(),
          neighbourhood: z
            .string()
            .describe("«الحي» only: never the customer's name, phone or address (K8)."),
          status: z.enum([
            'placed',
            'accepted',
            'ready',
            'picked_up',
            'arrived',
            'delivered',
            'rejected',
            'cancelled',
            'failed',
          ]),
          outcome: z
            .enum(['normal', 'free', 'fake', 'damaged', 'wrong_refused', 'failed_other'])
            .nullable()
            .describe('How it ended (AP Appendix C); null when not delivered or failed.'),
          testOrder: z.boolean(),
          redelivery: z.boolean().describe('«إعادة توصيل مجانية».'),
          handedOver: z
            .boolean()
            .describe(
              '«سلّمته لكابتن آخر»: the captain handed it over; the order went on without them.',
            ),
          pay: minor
            .nullable()
            .describe(
              'The pay earned for it in the base (order, waiting and peak); null for none.',
            ),
          paidToRestaurant: lines.describe('«دفعت للمطعم»: the confirmed pickup payment.'),
          collected: lines.describe('«قبضت»: what the captain received at the door.'),
          change: lines.describe('«الباقي»: the change given back.'),
          steps: z
            .array(z.object({ step: z.enum(captainSteps), at: z.iso.datetime() }))
            .describe("The captain's own steps, oldest first (CA §9.13 detail)."),
        }),
      )
      .describe(`Newest first, ${HISTORY_PAGE} a page.`),
    next: z.string().nullable().describe('The cursor of the next page; null at the end.'),
  }),
) {}

const linesBody = (each: { currency: string; amount: bigint }[]) =>
  each.map((line) => ({ currency: line.currency, amount: line.amount.toString() }));

// CA §9.13 «السجل» (slice 2.40): the orders the captain ended or handed over,
// with the pay from their earnings entries (as «أرباحي», CA §10.6) and the
// custody effect. Here because the pay is the earnings' read.
@CaptainController('orders')
export class CaptainHistoryController {
  constructor(
    private readonly histories: AppHistories,
    private readonly captains: CaptainsService,
    private readonly merchants: MerchantsService,
  ) {}

  // 400 invalid_period.
  @Get('history')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainOrderHistoryDto })
  async history(
    @CurrentAppSession() session: AppSession,
    @Query() query: CaptainOrderHistoryQueryDto,
  ) {
    if (session.captain === null) throw new ForbiddenException();
    const { captainId } = session.captain;
    const match = query.cursor === undefined ? null : CURSOR.exec(query.cursor);
    let page: { rows: CaptainHistoryRow[]; more: boolean };
    try {
      page = await this.histories.captainPage(
        captainId,
        {
          ...(query.from === undefined ? {} : { fromDay: query.from, toDay: query.to! }),
          ...(match ? { after: { placedAt: new Date(match[1]!), id: match[2]! } } : {}),
        },
        new Date(),
      );
    } catch (error) {
      if (!(error instanceof HistoryRefusedError)) throw error;
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
    }
    const oldest = page.rows.at(-1)?.order.placedAt ?? new Date();
    const [earnings, names] = await Promise.all([
      this.captains.earnings(captainId, oldest),
      this.merchants.names([...new Set(page.rows.map((row) => row.order.restaurantId))]),
    ]);
    const pay = new Map(orderLines(earnings.entries).map((line) => [line.orderId, line.total]));
    const last = page.rows.at(-1)?.order;
    return {
      payCurrency: earnings.balance.currency,
      orders: page.rows.map((row) => ({
        id: row.order.id,
        number: row.order.number.toString(),
        placedAt: row.order.placedAt.toISOString(),
        day: row.day,
        restaurantName: names.get(row.order.restaurantId)?.nameAr ?? '',
        neighbourhood: row.order.address.neighbourhood,
        status: row.order.status,
        outcome: row.order.delivery?.outcome ?? row.order.outcome?.outcome ?? null,
        testOrder: row.order.testOrder,
        redelivery: row.order.redelivery !== null,
        handedOver: row.handedOver,
        pay: pay.get(row.order.id)?.toString() ?? null,
        paidToRestaurant: linesBody(row.paidToRestaurant),
        collected: linesBody(row.collected),
        change: linesBody(row.change),
        steps: row.steps.map((step) => ({ step: step.step, at: step.at.toISOString() })),
      })),
      next: page.more && last ? `${last.placedAt.toISOString()}_${last.id}` : null,
    };
  }
}
