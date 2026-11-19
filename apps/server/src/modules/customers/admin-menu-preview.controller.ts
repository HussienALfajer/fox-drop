import { Get, HttpStatus, NotFoundException, Param } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequireAnyPermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { BrowsingService } from './browsing.service.js';
import { itemBody, storefrontItem } from './customer-browsing.controller.js';

class AdminMenuPreviewParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminMenuPreviewDto extends createZodDto(
  z.object({
    menu: z
      .array(
        z.object({
          id: z.uuid(),
          name: z.string(),
          window: z
            .object({ startsAt: z.int(), endsAt: z.int() })
            .nullable()
            .describe('Minutes after midnight on the city clock; «متوفر من {الساعة}» outside it.'),
          items: z.array(storefrontItem),
        }),
      )
      .describe("The restaurant page's menu (CU §9.3): hidden rows left out."),
  }),
) {}

// AP §9.6.6 «معاينة كما يراها الزبون» (slice 2.31): the menu exactly as the
// customer app shows it, read only, whatever the restaurant's status (a
// draft's too, before customers see it).
@AdminController('restaurants')
export class AdminMenuPreviewController {
  constructor(private readonly browsing: BrowsingService) {}

  @Get(':restaurantId/menu/customer-preview')
  @RequireAnyPermission('restaurants.read', 'restaurants.menus')
  @ZodResponse({ status: 200, type: AdminMenuPreviewDto })
  async preview(@Param() params: AdminMenuPreviewParamsDto) {
    const menu = await this.browsing.previewMenu(params.restaurantId, new Date());
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
