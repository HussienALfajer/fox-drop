import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';

const choices = {
  categories: [{ id: '01900000-0000-7000-8000-0000000000f1', name: 'شاورما' }],
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
};

function draftOf(
  id: string,
  nameAr: string,
  location: { latitude: number; longitude: number } | null,
) {
  return {
    id,
    cityId,
    accountStatus: 'draft',
    basics: {
      nameAr,
      nameEn: null,
      categoryIds: [],
      description: null,
      logoKey: null,
      coverKey: null,
    },
    location: { location, address: null, phone: null, ownerName: null },
    operations: { periods: [], defaultPrepMin: null, minimumOrder: null, coverage: null },
    commission: null,
    contract: null,
    steps: {
      basics: true,
      location: location !== null,
      operations: false,
      commission: false,
      contract: false,
    },
  };
}

// «إضافة مطعم» (AP §9.6.3; slice 2.30a): DATA starts a draft, saves step 1,
// lands on step 2 and saves the pin typed by hand (the map needs WebGL and
// the map's files, which the smoke test has neither of).
test('starts a draft, saves its basics, then its pin', async ({ page }) => {
  await fakeSession(page, ['restaurants.create']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/restaurant-drafts?*', (route) =>
    route.fulfill({ json: { drafts: [] } }),
  );
  await page.route('**/v1/admin/restaurant-drafts/choices?*', (route) =>
    route.fulfill({ json: choices }),
  );
  let draft: ReturnType<typeof draftOf> | null = null;
  const bodies: Record<string, unknown> = {};
  await page.route(/\/v1\/admin\/restaurant-drafts\/[0-9a-f-]{36}(\/\w+)?$/, (route) => {
    const url = new URL(route.request().url());
    const [, , , , id, step] = url.pathname.split('/');
    if (route.request().method() === 'GET') {
      return draft === null
        ? route.fulfill({ status: 404, json: { statusCode: 404, error: 'unknown_restaurant' } })
        : route.fulfill({ json: draft });
    }
    const body = route.request().postDataJSON() as Record<string, unknown>;
    bodies[step!] = body;
    draft =
      step === 'basics'
        ? draftOf(id!, body.nameAr as string, null)
        : draftOf(
            id!,
            draft!.basics.nameAr,
            body.location as { latitude: number; longitude: number },
          );
    return route.fulfill({ json: draft });
  });
  await page.route('**/v1/admin/restaurants/*/accounts', (route) =>
    route.fulfill({ json: { accounts: [] } }),
  );

  await page.goto('/restaurant-drafts');
  await expect(page.getByText('لا مسودات في هذه المدينة.')).toBeVisible();
  await page.getByRole('button', { name: 'مطعم جديد' }).click();
  await page.getByLabel('الاسم بالعربية').fill('مطعم الضيعة');
  await page.getByLabel('شاورما').check();
  await page.getByRole('button', { name: 'حفظ' }).click();
  await expect(page.getByRole('heading', { name: '2. الموقع والتواصل' })).toBeVisible();
  expect(bodies.basics).toEqual({
    cityId,
    nameAr: 'مطعم الضيعة',
    nameEn: null,
    categoryIds: ['01900000-0000-7000-8000-0000000000f1'],
    description: null,
  });
  await page.getByLabel('خط العرض').fill('36.5862');
  await page.getByLabel('خط الطول').fill('37.0471');
  await page.getByRole('button', { name: 'حفظ' }).click();
  await expect(page.getByRole('status').filter({ hasText: 'تم الحفظ.' })).toBeVisible();
  expect(bodies.location).toMatchObject({ location: { latitude: 36.5862, longitude: 37.0471 } });
});
