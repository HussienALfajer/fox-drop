import type { Page } from '@playwright/test';

// The fake server's restaurant and menu for the menu editor's tests
// (slice 2.31).
export const cityId = '01900000-0000-7000-8000-0000000000c1';
export const restaurantId = '01900000-0000-7000-8000-0000000000a1';
export const meals = '01900000-0000-7000-8000-0000000000f1';
export const shawarma = '01900000-0000-7000-8000-0000000000b1';
export const juice = '01900000-0000-7000-8000-0000000000b2';

const item = (id: string, code: string, name: string, amount: string) => ({
  id,
  code,
  name,
  description: null,
  price: { amount, currency: 'TRY' },
  hidden: false,
  badge: null,
  photoKey: null,
  switchedOff: null,
  optionGroupIds: [],
});

export const menuOf = (prices: [string, string], pricesLocked = false) => ({
  accountStatus: 'active',
  editable: true,
  pricesLocked,
  nameMax: 80,
  descriptionMax: 300,
  codeMax: 20,
  categories: [
    {
      id: meals,
      name: 'وجبات',
      hidden: false,
      switchedOff: null,
      window: null,
      items: [
        item(shawarma, 'I0001', 'شاورما', prices[0]),
        item(juice, 'I0002', 'عصير', prices[1]),
      ],
    },
  ],
  optionGroups: [],
});

export async function fakeMenuRestaurant(page: Page) {
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/restaurant-drafts/choices?*', (route) =>
    route.fulfill({
      json: {
        categories: [],
        categoriesMax: 5,
        zones: [],
        baseCurrency: 'TRY',
        centre: null,
        prepFloorMin: 5,
        prepCeilingMin: 90,
        defaultPrepMin: 20,
        defaultMinimumOrder: null,
        defaultCommissionBp: 1500,
        nameMax: 80,
        descriptionMax: 300,
        addressMax: 200,
      },
    }),
  );
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}?*`, (route) =>
    route.fulfill({
      json: {
        id: restaurantId,
        cityId,
        accountStatus: 'active',
        basics: {
          nameAr: 'مطعم الشام',
          nameEn: null,
          categoryIds: [],
          description: null,
          logoKey: null,
          coverKey: null,
        },
        location: null,
        operations: null,
        commission: null,
        contract: null,
        steps: { basics: true, location: true, operations: true, commission: true, contract: true },
      },
    }),
  );
}
