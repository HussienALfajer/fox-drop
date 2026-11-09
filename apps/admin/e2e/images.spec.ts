import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const restaurantId = '01900000-0000-7000-8000-0000000000a1';
const itemId = '01900000-0000-7000-8000-0000000000b1';
const uploadId = '01900000-0000-7000-8000-0000000000d1';
const key = 'menu/items/01900000-0000-7000-8000-0000000000e1.png';

// A PNG's signature is enough: the fake server never reads it.
const png = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 0]);

// «الصور» (slice 2.5): a menu editor uploads an item photo; the file goes to
// the signed URL, then the photo is linked and shown through /media.
test('uploads an item photo and shows it', async ({ page }) => {
  await fakeSession(page, ['restaurants.menus']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/restaurants?*', (route) =>
    route.fulfill({ json: { restaurants: [{ id: restaurantId, nameAr: 'مطعم الشام' }] } }),
  );
  let photoKey: string | null = null;
  await page.route(`**/v1/admin/restaurants/${restaurantId}/images`, (route) =>
    route.fulfill({
      json: {
        logoKey: null,
        coverKey: null,
        categories: [
          {
            id: '01900000-0000-7000-8000-0000000000f1',
            name: 'وجبات',
            items: [{ id: itemId, name: 'شاورما', photoKey }],
          },
        ],
      },
    }),
  );
  let asked: unknown;
  await page.route('**/v1/admin/uploads', (route) => {
    asked = route.request().postDataJSON();
    return route.fulfill({
      status: 201,
      json: {
        uploadId,
        key,
        url: `${new URL(page.url()).origin}/public-media/${key}?X-Amz-Signature=fake`,
        expiresAt: '2026-11-09T10:10:00.000Z',
      },
    });
  });
  let stored: { type: string | undefined; size: number } | undefined;
  await page.route('**/public-media/**', (route) => {
    stored = {
      type: route.request().headers()['content-type'],
      size: route.request().postDataBuffer()?.length ?? 0,
    };
    return route.fulfill({ status: 200, body: '' });
  });
  let linked: unknown;
  await page.route(`**/v1/admin/restaurants/${restaurantId}/items/${itemId}/photo`, (route) => {
    linked = route.request().postDataJSON();
    photoKey = key;
    return route.fulfill({ json: { key } });
  });
  await page.route('**/media/**', (route) =>
    route.fulfill({ status: 200, contentType: 'image/png', body: png }),
  );
  await page.goto('/');

  await page.getByRole('link', { name: 'الصور' }).click();
  await page.getByLabel('المطعم').selectOption({ label: 'مطعم الشام' });
  const item = page.getByRole('region', { name: 'شاورما' });
  await expect(item.getByText('لا توجد صورة')).toBeVisible();
  // A menu editor sets photos only (AP §6.2).
  await expect(page.getByRole('region', { name: 'الشعار' }).getByLabel('رفع صورة')).toHaveCount(0);

  await item
    .getByLabel('رفع صورة')
    .setInputFiles({ name: 'shawarma.png', mimeType: 'image/png', buffer: png });

  await expect(item.getByRole('status')).toHaveText('حُفظت الصورة');
  expect(asked).toEqual({ purpose: 'item_photo', contentType: 'image/png', sizeBytes: png.length });
  expect(stored).toEqual({ type: 'image/png', size: png.length });
  expect(linked).toEqual({ uploadId });
  await expect(item.getByRole('img', { name: 'شاورما' })).toHaveAttribute(
    'src',
    `/media/_/w160/plain/${key}`,
  );
});

test('refuses a file that is not an image before uploading', async ({ page }) => {
  await fakeSession(page, ['restaurants.read', 'restaurants.manage']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route(`**/v1/admin/restaurants/${restaurantId}/images`, (route) =>
    route.fulfill({ json: { logoKey: null, coverKey: null, categories: [] } }),
  );
  await page.route('**/v1/admin/restaurants?*', (route) =>
    route.fulfill({ json: { restaurants: [{ id: restaurantId, nameAr: 'مطعم الشام' }] } }),
  );
  let uploads = 0;
  await page.route('**/v1/admin/uploads', (route) => {
    uploads += 1;
    return route.fulfill({ status: 500 });
  });
  await page.goto(`/images?restaurant=${restaurantId}`);

  const logo = page.getByRole('region', { name: 'الشعار' });
  await logo
    .getByLabel('رفع صورة')
    .setInputFiles({ name: 'menu.pdf', mimeType: 'application/pdf', buffer: Buffer.from('%PDF') });

  await expect(logo.getByRole('alert')).toHaveText('اختر صورة بصيغة JPEG أو PNG أو WebP.');
  expect(uploads).toBe(0);
});
