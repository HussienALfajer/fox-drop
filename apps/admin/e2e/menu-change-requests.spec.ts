import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const requestId = '01900000-0000-7000-8000-0000000000e1';
const restaurantId = '01900000-0000-7000-8000-0000000000e2';
const values = {
  name: null,
  description: null,
  photoKey: null,
  price: null,
  categoryId: null,
  groupId: null,
  minChoices: null,
  maxChoices: null,
  itemIds: null,
  options: null,
};
const row = {
  id: requestId,
  restaurantId,
  restaurantName: 'مطعم الشام',
  targetType: 'item',
  targetId: '01900000-0000-7000-8000-0000000000e3',
  field: 'created',
  targetName: 'كنافه',
  createdAt: '2026-11-18T08:00:00.000Z',
};

// «طلبات تعديل القائمة» (slice 2.32b; AP §9.6.7, RA §9.5): the queue oldest
// first with the age, a request's before and after with the item as
// customers will see it, and «قبول» with a corrected name.
test('reviews a new item and approves it with a corrected name', async ({ page }) => {
  await fakeSession(page, ['menus.review_change_requests', 'restaurants.read']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/menu-change-requests?*', (route) => {
    expect(new URL(route.request().url()).searchParams.get('cityId')).toBe(cityId);
    return route.fulfill({ json: { requests: [row] } });
  });
  let approved: unknown = null;
  await page.route(`**/v1/admin/menu-change-requests/${requestId}`, (route) =>
    route.fulfill({
      json: {
        ...row,
        status: approved === null ? 'pending' : 'approved',
        updatedAt: '2026-11-18T08:05:00.000Z',
        before: null,
        after: {
          ...values,
          name: 'كنافه',
          description: 'بالجبنة',
          price: { amount: '7500', currency: 'TRY' },
          categoryId: '01900000-0000-7000-8000-0000000000e4',
        },
        parentName: 'حلويات',
        item: null,
        itemNames: [],
      },
    }),
  );
  await page.route(`**/v1/admin/menu-change-requests/${requestId}/approve`, async (route) => {
    approved = route.request().postDataJSON();
    await route.fulfill({ json: { status: 'approved' } });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'طلبات تعديل القائمة' }).click();
  await expect(page.getByRole('row', { name: /مطعم الشام كنافه صنف جديد/ })).toBeVisible();
  await page.getByRole('link', { name: 'كنافه' }).click();
  await expect(page.getByText('كنافه · حلويات')).toBeVisible();
  const preview = page.getByRole('region', { name: 'الصنف كما سيراه الزبون' });
  await page.getByLabel('تصحيح الاسم (اختياري)').fill('كنافة');
  await expect(preview.getByText(/^كنافة · /)).toBeVisible();
  await page.getByRole('button', { name: 'قبول' }).click();
  await expect(page.getByText('تم القرار، وأُبلغ المطعم.')).toBeVisible();
  expect(approved).toEqual({ seen: '2026-11-18T08:05:00.000Z', name: 'كنافة' });
});

test('is not offered without menus.review_change_requests', async ({ page }) => {
  await fakeSession(page, ['restaurants.menus']);
  await page.goto('/');
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  await expect(page.getByRole('link', { name: 'طلبات تعديل القائمة' })).toHaveCount(0);
});
