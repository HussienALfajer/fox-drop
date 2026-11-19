import { ForbiddenException, Get, HttpStatus, NotFoundException } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { BrowsingService } from './browsing.service.js';
import { itemBody, storefrontItem } from './customer-browsing.controller.js';

class MerchantMenuPreviewDto extends createZodDto(
  z.object({
    menu: z
      .array(
        z
          .object({
            id: z.uuid(),
            name: z.string(),
            window: z
              .object({ startsAt: z.int(), endsAt: z.int() })
              .nullable()
              .describe(
                'Minutes after midnight on the city clock; «متوفر من {الساعة}» outside it.',
              ),
            items: z.array(storefrontItem),
          })
          // Its own name, so the generator never ties the restaurant app's
          // model to the panel's alike shape.
          .meta({ id: 'MerchantMenuPreviewCategory' }),
      )
      .describe("The restaurant page's menu (CU §9.3): hidden rows left out."),
  }),
) {}

// RA §9.7 «معاينة كما يراها الزبون» (slice 2.32a), the owners' (RA §6): the
// menu exactly as the customer app shows it, as the panel's preview.
@MerchantController()
export class MerchantMenuPreviewController {
  constructor(
    private readonly browsing: BrowsingService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get('menu/customer-preview')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantMenuPreviewDto })
  async preview(@CurrentAppSession() session: AppSession) {
    const account = session.merchant;
    if (!account) throw new Error('a merchant route without a restaurant user');
    if (account.role !== 'owner') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
    }
    // RA §5.5: a terminated restaurant's owners keep the money section only.
    if ((await this.merchants.accountStatus(account.restaurantId)) === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    const menu = await this.browsing.previewMenu(account.restaurantId, new Date());
    if (menu === null) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    return {
      menu: menu.map((category) => ({
        id: category.id,
        name: category.name,
        window: category.window,
        items: category.items.map(itemBody),
      })),
    };
  }
}
