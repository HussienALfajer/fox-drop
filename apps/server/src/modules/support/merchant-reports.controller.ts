import { ForbiddenException, Get, HttpStatus } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { merchantTicketBody, merchantTicketOut } from './ticket-body.js';
import { SupportService } from './support.service.js';

class MerchantReportsDto extends createZodDto(
  z.object({
    tickets: z
      .array(merchantTicketBody)
      .describe(
        "Newest first, the latest 100: an owner's every ticket of the restaurant, a cashier's own.",
      ),
  }),
) {}

// RA §15 «بلاغاتي» (slice 2.24b, owner decision 2026-11-17): the
// restaurant's tickets with their status and resolution message, for owners
// and cashiers; a terminated restaurant's owners keep only the money
// section (RA §5.5).
@MerchantController('reports')
export class MerchantReportsController {
  constructor(
    private readonly support: SupportService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get()
  @AppSignedIn({ portal: true })
  @ZodResponse({ status: 200, type: MerchantReportsDto })
  async list(@CurrentAppSession() session: AppSession) {
    const merchant = session.merchant;
    if (!merchant) throw new Error('a merchant route without a restaurant user');
    if ((await this.merchants.accountStatus(merchant.restaurantId)) === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    const tickets = await this.support.merchantTickets({
      accountId: session.accountId,
      restaurantId: merchant.restaurantId,
      role: merchant.role,
    });
    return { tickets: tickets.map(merchantTicketOut) };
  }
}
