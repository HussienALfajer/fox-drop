import { expect, test } from '@playwright/test';
import {
  fakeMenuRestaurant,
  juice,
  meals,
  menuOf,
  restaurantId,
  shawarma,
} from './menu-fixture.js';
import { fakeSession } from './session.js';

// AP §9.6.6 (slice 2.31): the menu editor past test mode, its bulk price
// change with the before and after, and «سجل الأسعار».
test('previews a bulk raise, applies it and reads it in the price log', async ({ page }) => {
  await fakeSession(page, ['restaurants.read', 'restaurants.menus', 'menus.edit_prices']);
  await fakeMenuRestaurant(page);
  let menu = menuOf(['12000', '9950']);
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu`, (route) =>
    route.fulfill({ json: menu }),
  );
  let previewed: unknown;
  await page.route(
    `**/v1/admin/restaurant-drafts/${restaurantId}/menu/bulk-price/preview`,
    (route) => {
      previewed = route.request().postDataJSON();
      return route.fulfill({
        json: {
          currency: 'TRY',
          roundingUnit: '100',
          rows: [
            {
              itemId: shawarma,
              code: 'I0001',
              name: 'شاورما',
              categoryId: meals,
              before: '12000',
              after: '13200',
            },
            {
              itemId: juice,
              code: 'I0002',
              name: 'عصير',
              categoryId: meals,
              before: '9950',
              after: '10900',
            },
          ],
          changed: 2,
          unchanged: 0,
          refused: 0,
        },
      });
    },
  );
  let key: string | undefined;
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu/bulk-price`, (route) => {
    key = route.request().headers()['idempotency-key'];
    menu = menuOf(['13200', '10900']);
    return route.fulfill({ json: { changed: 2, unchanged: 0 } });
  });
  let logged = false;
  await page.route(`**/v1/admin/restaurants/${restaurantId}/menu/price-log`, (route) =>
    route.fulfill({
      json: {
        entries: logged
          ? [
              {
                id: '01900000-0000-7000-8000-0000000000e1',
                targetType: 'item',
                targetId: shawarma,
                name: 'شاورما',
                groupName: null,
                oldPrice: { amount: '12000', currency: 'TRY' },
                newPrice: { amount: '13200', currency: 'TRY' },
                byType: 'admin',
                byName: 'سارة',
                at: '2026-11-19T09:00:00.000Z',
              },
            ]
          : [],
      },
    }),
  );
  await page.goto(`/restaurants/${restaurantId}?tab=menu`);

  const bulk = page.getByRole('region', { name: 'تعديل جماعي للأسعار' });
  await bulk.getByLabel('القيمة').fill('10');
  await bulk.getByRole('button', { name: 'معاينة قبل وبعد' }).click();
  expect(previewed).toEqual({ categoryId: null, kind: 'percent', direction: 'up', value: '1000' });
  const table = bulk.getByRole('table', { name: 'الأسعار قبل التعديل وبعده' });
  await expect(table.getByRole('row', { name: /شاورما/ })).toContainText('132');
  logged = true;
  await bulk.getByRole('button', { name: 'تأكيد التعديل (2)' }).click();
  await expect(bulk.getByRole('status')).toHaveText('عُدّلت أسعار 2 صنفاً وأُبلغ مالك المطعم.');
  expect(key).toMatch(/^[A-Za-z0-9_-]{16,128}$/);
  const log = page.getByRole('region', { name: 'سجل الأسعار' });
  await expect(log.getByRole('row', { name: /شاورما/ })).toContainText('سارة');
});

test('keeps the prices read only without menus.edit_prices past test mode', async ({ page }) => {
  await fakeSession(page, ['restaurants.read', 'restaurants.menus']);
  await fakeMenuRestaurant(page);
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu`, (route) =>
    route.fulfill({ json: menuOf(['12000', '9950'], true) }),
  );
  await page.route(`**/v1/admin/restaurants/${restaurantId}/menu/price-log`, (route) =>
    route.fulfill({ json: { entries: [] } }),
  );
  await page.goto(`/restaurants/${restaurantId}?tab=menu`);
  await expect(page.getByText(/بعد التفعيل يعدّل الأسعار/)).toBeVisible();
  await expect(page.getByRole('region', { name: 'تعديل جماعي للأسعار' })).toHaveCount(0);
  await expect(page.getByRole('button', { name: 'إضافة صنف' })).toHaveCount(0);
  await page.getByRole('button', { name: 'تعديل الصنف' }).first().click();
  await expect(page.getByLabel('السعر (TRY)')).toHaveAttribute('readonly', '');
});
