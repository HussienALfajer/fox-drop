import { readFileSync } from 'node:fs';
import { expect, test } from '@playwright/test';
import { fakeMenuRestaurant, menuOf, restaurantId, shawarma } from './menu-fixture.js';
import { fakeSession } from './session.js';

// AP §9.6.6 «استيراد من Excel» (slice 2.31): the owner downloads the template,
// uploads a workbook, reads the report and the dry run, and imports it.
const uploadId = '01900000-0000-7000-8000-0000000000d1';
const workbook = readFileSync(new URL('fixtures/menu-import.xlsx', import.meta.url));

test('imports a menu from Excel after its dry run', async ({ page }) => {
  await fakeSession(page, ['restaurants.read', 'restaurants.menus', 'menus.edit_prices']);
  await fakeMenuRestaurant(page);
  let menu = menuOf(['12000', '9950']);
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu`, (route) =>
    route.fulfill({ json: menu }),
  );
  await page.route(`**/v1/admin/restaurants/${restaurantId}/menu/price-log`, (route) =>
    route.fulfill({ json: { entries: [] } }),
  );
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu/import-template`, (route) =>
    route.fulfill({
      json: { fileName: 'menu.xlsx', contentBase64: workbook.toString('base64') },
    }),
  );
  let asked: unknown;
  await page.route('**/v1/admin/uploads', (route) => {
    asked = route.request().postDataJSON();
    return route.fulfill({
      status: 201,
      json: {
        uploadId,
        url: `${new URL(page.url()).origin}/private-docs/incoming/menu.xlsx?X-Amz-Signature=fake`,
        expiresAt: '2026-11-19T10:10:00.000Z',
      },
    });
  });
  await page.route('**/private-docs/**', (route) => route.fulfill({ status: 200, body: '' }));
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu/import/dry-run`, (route) =>
    route.fulfill({
      json: {
        fileError: null,
        errors: [],
        categoriesAdded: ['حلويات'],
        added: [
          {
            row: 3,
            code: null,
            categoryName: 'حلويات',
            name: 'كنافة',
            description: null,
            price: '8000',
            groupIds: [],
          },
        ],
        changed: [
          {
            row: 2,
            itemId: shawarma,
            code: 'I0001',
            fields: ['price'],
            categoryName: 'وجبات',
            name: 'شاورما',
            description: null,
            price: '13000',
            groupIds: [],
            oldPrice: '12000',
          },
        ],
        unchanged: 1,
      },
    }),
  );
  let key: string | undefined;
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu/import`, (route) => {
    key = route.request().headers()['idempotency-key'];
    menu = menuOf(['13000', '9950']);
    return route.fulfill({ json: { added: 1, changed: 1, unchanged: 1, categoriesAdded: 1 } });
  });
  await page.goto(`/restaurants/${restaurantId}?tab=menu`);

  const section = page.getByRole('region', { name: 'استيراد من Excel' });
  const download = page.waitForEvent('download');
  await section.getByRole('button', { name: 'تنزيل النموذج' }).click();
  expect((await download).suggestedFilename()).toBe('menu.xlsx');

  await section.getByLabel('رفع ملف Excel').setInputFiles({
    name: 'menu.xlsx',
    mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    buffer: workbook,
  });
  await expect(section.getByText('سيُضاف 1 صنفاً، ويتغيّر 1، ويبقى 1 كما هو.')).toBeVisible();
  expect(asked).toEqual({
    purpose: 'menu_import',
    contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    sizeBytes: workbook.length,
  });
  await expect(section.getByText('فئات جديدة تُضاف في آخر القائمة: حلويات')).toBeVisible();
  await expect(
    section.getByRole('table', { name: 'أصناف تتغيّر' }).getByRole('row', { name: /شاورما/ }),
  ).toContainText('←');
  await section.getByRole('button', { name: 'تنفيذ الاستيراد' }).click();
  await expect(section.getByRole('status')).toHaveText(
    'تم الاستيراد: أُضيف 1 صنفاً، وتغيّر 1، وبقي 1 كما هو، وأُضيفت 1 فئة.',
  );
  expect(key).toMatch(/^[A-Za-z0-9_-]{16,128}$/);
});

test('shows every row error and offers no import', async ({ page }) => {
  await fakeSession(page, ['restaurants.read', 'restaurants.menus']);
  await fakeMenuRestaurant(page);
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu`, (route) =>
    route.fulfill({ json: menuOf(['12000', '9950']) }),
  );
  await page.route(`**/v1/admin/restaurants/${restaurantId}/menu/price-log`, (route) =>
    route.fulfill({ json: { entries: [] } }),
  );
  await page.route('**/v1/admin/uploads', (route) =>
    route.fulfill({
      status: 201,
      json: {
        uploadId,
        url: `${new URL(page.url()).origin}/private-docs/incoming/menu.xlsx?X-Amz-Signature=fake`,
        expiresAt: '2026-11-19T10:10:00.000Z',
      },
    }),
  );
  await page.route('**/private-docs/**', (route) => route.fulfill({ status: 200, body: '' }));
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu/import/dry-run`, (route) =>
    route.fulfill({
      json: {
        fileError: null,
        errors: [
          { row: 3, column: 'price', error: 'invalid_price' },
          { row: 4, column: 'groups', error: 'unknown_group' },
        ],
        categoriesAdded: [],
        added: [],
        changed: [],
        unchanged: 1,
      },
    }),
  );
  await page.goto(`/restaurants/${restaurantId}?tab=menu`);
  const section = page.getByRole('region', { name: 'استيراد من Excel' });
  await section.getByLabel('رفع ملف Excel').setInputFiles({
    name: 'menu.xlsx',
    mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    buffer: workbook,
  });
  const errors = section.getByRole('table', { name: 'أخطاء الملف' });
  await expect(errors.getByRole('row', { name: /مجموعات الخيارات/ })).toContainText(
    'مجموعة غير موجودة أو مكررة',
  );
  await expect(section.getByRole('button', { name: 'تنفيذ الاستيراد' })).toHaveCount(0);
  // A file that is not a workbook is refused before any upload.
  await section
    .getByLabel('رفع ملف Excel')
    .setInputFiles({ name: 'menu.csv', mimeType: 'text/csv', buffer: Buffer.from('a,b') });
  await expect(section.getByRole('alert')).toHaveText('اختر ملف Excel بصيغة xlsx.');
});
