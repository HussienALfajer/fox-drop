import { expect, type Page, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const restaurantId = '01900000-0000-7000-8000-0000000000a1';
const itemId = '01900000-0000-7000-8000-0000000000b1';
const uploadId = '01900000-0000-7000-8000-0000000000d1';
const key = 'menu/items/01900000-0000-7000-8000-0000000000e1.png';

// A PNG's signature is enough: the fake server never reads it.
const png = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 0]);

const everyDay = (opensAt: number) =>
  [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt, closesAt: 1380 }));

const restaurant = (opensAt: number) => ({
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
  location: {
    location: { latitude: 36.587, longitude: 37.046 },
    address: 'الساحة',
    phone: null,
    ownerName: null,
  },
  operations: {
    periods: everyDay(opensAt),
    defaultPrepMin: 20,
    minimumOrder: { amount: '10000', currency: 'TRY' },
    coverage: { kind: 'radius', radiusMetres: 3000, zoneIds: [] },
  },
  commission: { rateBp: 1500, launch: null },
  contract: null,
  steps: { basics: true, location: true, operations: true, commission: true, contract: true },
});

async function fakeRestaurant(page: Page) {
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
  await page.route(`**/v1/admin/restaurants/${restaurantId}/overview?*`, (route) =>
    route.fulfill({
      json: {
        from: '2026-11-18T03:00:00.000Z',
        orders: 7,
        sales: [{ currency: 'TRY', amount: '84000' }],
        acceptanceBp: 9500,
        rejectionBp: 500,
        rejectionReasons: [{ label: 'المطعم مغلق', count: 1 }],
        unanswered: 0,
        prepActualMin: 22.5,
        prepChosenMin: 20,
        lateBp: 2500,
        ratingCount: 3,
        ratingAverage: 4.3,
      },
    }),
  );
}

// AP §9.6.4 (slice 2.30d): the owner opens a restaurant, reads its overview,
// edits its hours and reads the change in its log.
test('opens the profile, edits the hours and reads the change in the log', async ({ page }) => {
  await fakeSession(page, ['restaurants.read', 'restaurants.manage']);
  await fakeRestaurant(page);
  let current = restaurant(600);
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}`, (route) =>
    route.fulfill({ json: current }),
  );
  let sent: { periods: unknown[] } | undefined;
  await page.route(`**/v1/admin/restaurants/${restaurantId}/profile/operations`, (route) => {
    sent = route.request().postDataJSON() as { periods: unknown[] };
    current = restaurant(540);
    return route.fulfill({ json: current });
  });
  let logged = false;
  await page.route(`**/v1/admin/restaurants/${restaurantId}/change-log`, (route) =>
    route.fulfill({
      json: {
        entries: logged
          ? [
              {
                id: '01900000-0000-7000-8000-0000000000f2',
                at: '2026-11-18T09:00:00.000Z',
                action: 'restaurant.operations',
                actorType: 'admin',
                actorName: 'سارة',
                actorRole: 'OPS',
                account: null,
                changes: [
                  {
                    field: 'periods',
                    before: JSON.stringify(everyDay(600)),
                    after: JSON.stringify(everyDay(540)),
                  },
                ],
                reason: null,
              },
            ]
          : [],
      },
    }),
  );
  await page.goto(`/restaurants/${restaurantId}`);

  await expect(page.getByRole('heading', { name: 'مطعم الشام' })).toBeVisible();
  const overview = page.getByRole('region', { name: 'نظرة عامة' });
  await expect(overview.getByText('95%')).toBeVisible();
  await expect(overview.getByText('22.5 د مقابل 20 د')).toBeVisible();
  await expect(overview.getByText('المطعم مغلق: 1')).toBeVisible();

  await page.getByRole('link', { name: 'الأوقات' }).click();
  await page.getByLabel('من').first().fill('09:00');
  await page.getByRole('button', { name: 'حفظ' }).click();
  await expect(page.getByRole('status')).toHaveText('تم الحفظ.');
  expect(sent?.periods).toContainEqual({ weekday: 6, opensAt: 540, closesAt: 1380 });

  logged = true;
  await page.getByRole('link', { name: 'سجل التغييرات' }).click();
  await expect(page.getByText(/تعديل الأوقات والتشغيل · بواسطة سارة/)).toBeVisible();
  await expect(page.getByText('الأوقات تغيّرت')).toBeVisible();
});

// «الصور» moved into the profile's «القائمة» (slice 2.30d): a menu editor
// uploads an item photo past test mode; the file goes to the signed URL, then
// the photo is linked and shown through /media.
test('uploads an item photo from the menu tab', async ({ page }) => {
  await fakeSession(page, ['restaurants.read', 'restaurants.menus']);
  await fakeRestaurant(page);
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}`, (route) =>
    route.fulfill({ json: restaurant(600) }),
  );
  let photoKey: string | null = null;
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}/menu`, (route) =>
    route.fulfill({
      json: {
        accountStatus: 'active',
        editable: false,
        nameMax: 80,
        descriptionMax: 300,
        codeMax: 20,
        categories: [
          {
            id: '01900000-0000-7000-8000-0000000000f1',
            name: 'وجبات',
            hidden: false,
            switchedOff: null,
            window: null,
            items: [
              {
                id: itemId,
                code: 'I0001',
                name: 'شاورما',
                description: null,
                price: { amount: '12000', currency: 'TRY' },
                hidden: false,
                badge: null,
                photoKey,
                switchedOff: null,
              },
            ],
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
  await page.route('**/public-media/**', (route) => route.fulfill({ status: 200, body: '' }));
  let linked: unknown;
  await page.route(`**/v1/admin/restaurants/${restaurantId}/items/${itemId}/photo`, (route) => {
    linked = route.request().postDataJSON();
    photoKey = key;
    return route.fulfill({ json: { key } });
  });
  await page.route('**/media/**', (route) =>
    route.fulfill({ status: 200, contentType: 'image/png', body: png }),
  );
  await page.goto(`/restaurants/${restaurantId}?tab=menu`);

  const item = page.getByRole('region', { name: 'صورة شاورما' });
  await item
    .getByLabel('رفع صورة')
    .setInputFiles({ name: 'shawarma.png', mimeType: 'image/png', buffer: png });
  await expect(item.getByRole('status')).toHaveText('حُفظت الصورة');
  expect(asked).toEqual({ purpose: 'item_photo', contentType: 'image/png', sizeBytes: png.length });
  expect(linked).toEqual({ uploadId });
});

test('refuses a logo that is not an image before uploading', async ({ page }) => {
  await fakeSession(page, ['restaurants.read', 'restaurants.manage']);
  await fakeRestaurant(page);
  await page.route(`**/v1/admin/restaurant-drafts/${restaurantId}`, (route) =>
    route.fulfill({ json: restaurant(600) }),
  );
  let uploads = 0;
  await page.route('**/v1/admin/uploads', (route) => {
    uploads += 1;
    return route.fulfill({ status: 500 });
  });
  await page.goto(`/restaurants/${restaurantId}?tab=data`);

  const logo = page.getByRole('region', { name: 'الشعار' });
  await logo
    .getByLabel('رفع صورة')
    .setInputFiles({ name: 'menu.pdf', mimeType: 'application/pdf', buffer: Buffer.from('%PDF') });
  await expect(logo.getByRole('alert')).toHaveText('اختر صورة بصيغة JPEG أو PNG أو WebP.');
  expect(uploads).toBe(0);
});
