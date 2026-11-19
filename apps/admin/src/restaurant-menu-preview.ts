import { queryOptions } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';

// AP §9.6.6 «معاينة كما يراها الزبون» (slice 2.31): the server answers the
// menu as the restaurant page shows it to customers (hidden rows left out,
// each unavailable item with its reason); read only.
export type PreviewMenu = components['schemas']['AdminMenuPreviewDto_Output']['menu'];

export const menuPreviewQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: ['restaurant-menu-preview', restaurantId] as const,
    queryFn: async (): Promise<PreviewMenu> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/menu/customer-preview', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The menu preview read failed.');
      return data.menu;
    },
    // Read again each time it opens, so it follows the edits.
    staleTime: 0,
  });
