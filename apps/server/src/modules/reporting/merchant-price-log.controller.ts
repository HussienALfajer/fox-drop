import { ForbiddenException, Get, HttpStatus } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import { type AppSession, MerchantAccountsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PRICE_LOG_LIMIT } from './admin-restaurant-profile.controller.js';

const money = z.object({
  amount: z.string().regex(/^\d+$/).describe('Integer minor units (AP §8.6).'),
  currency: z.string().length(3),
});

class MerchantPriceLogDto extends createZodDto(
  z.object({
    entries: z
      .array(
        z.object({
          id: z.uuid(),
          targetType: z.enum(['item', 'option']),
          targetId: z.uuid(),
          name: z.string().describe("The item's name, or the option's."),
          groupName: z.string().nullable().describe("An option's group; null for an item."),
          oldPrice: money,
          newPrice: money,
          byType: z
            .enum(['admin', 'merchant', 'system'])
            .describe('admin and system are «FOX DROP» (RA §9.4).'),
          byName: z
            .string()
            .nullable()
            .describe("The restaurant user's name; null for FOX DROP or when unknown."),
          at: z.iso.datetime(),
        }),
      )
      .describe(`The latest ${PRICE_LOG_LIMIT}, newest first.`),
  }),
) {}

// RA §9.4 «سجل الأسعار» in the restaurant app (slice 2.32a), the owners'
// (RA §6): the panel's log (AP §9.6.6) with the restaurant user's name, or
// «FOX DROP» for an admin, whose name stays in the panel.
@MerchantController()
export class MerchantPriceLogController {
  constructor(
    private readonly merchants: MerchantsService,
    private readonly accounts: MerchantAccountsService,
  ) {}

  @Get('menu/price-log')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantPriceLogDto })
  async priceLog(@CurrentAppSession() session: AppSession) {
    const account = session.merchant;
    if (!account) throw new Error('a merchant route without a restaurant user');
    if (account.role !== 'owner') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
    }
    if ((await this.merchants.accountStatus(account.restaurantId)) === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    const entries = await this.merchants.priceLog(account.restaurantId, PRICE_LOG_LIMIT);
    const users = entries.some((entry) => entry.changedByType === 'merchant')
      ? await this.accounts.everyAccount(account.restaurantId)
      : new Map<string, string>();
    return {
      entries: entries.map((entry) => ({
        id: entry.id,
        targetType: entry.target.type,
        targetId: entry.target.id,
        name: entry.target.name,
        groupName: entry.target.type === 'option' ? entry.target.groupName : null,
        oldPrice: { amount: entry.oldPrice.amount.toString(), currency: entry.oldPrice.currency },
        newPrice: { amount: entry.newPrice.amount.toString(), currency: entry.newPrice.currency },
        byType: entry.changedByType,
        byName:
          entry.changedByType === 'merchant' && entry.changedById !== null
            ? (users.get(entry.changedById) ?? null)
            : null,
        at: entry.at.toISOString(),
      })),
    };
  }
}
