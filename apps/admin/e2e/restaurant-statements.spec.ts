import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const restaurantId = '01900000-0000-7000-8000-0000000000b1';
const exportId = '01900000-0000-7000-8000-0000000000e7';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};

const statement = {
  restaurantId,
  restaurantName: 'مطعم الشام',
  cityId,
  currency: 'TRY',
  fromDay: '2026-11-01',
  toDay: '2026-11-30',
  from: '2026-11-01T03:00:00.000Z',
  to: '2026-12-01T03:00:00.000Z',
  opening: '100000',
  orders: 1,
  itemsValue: '40000',
  commission: '6000',
  discountShare: '500',
  exceptions: '-2000',
  paid: '90000',
  closing: '14500',
  lines: [
    {
      kind: 'order',
      at: '2026-11-05T10:30:00.000Z',
      orderId: '01900000-0000-7000-8000-0000000000a1',
      orderNumber: '10001',
      itemsValue: '40000',
      pickupLines: [{ currency: 'TRY', amount: '40000' }],
      commission: '6000',
      discountShare: '500',
      cause: null,
      amount: null,
      reason: null,
      receiptId: null,
      receiptNumber: null,
    },
    {
      kind: 'exception',
      at: '2026-11-06T09:00:00.000Z',
      orderId: null,
      orderNumber: null,
      itemsValue: null,
      pickupLines: null,
      commission: null,
      discountShare: null,
      cause: 'adjustment',
      amount: '-2000',
      reason: 'تصحيح',
      receiptId: null,
      receiptNumber: null,
    },
    {
      kind: 'payment',
      at: '2026-11-08T12:00:00.000Z',
      orderId: null,
      orderNumber: null,
      itemsValue: null,
      pickupLines: null,
      commission: null,
      discountShare: null,
      cause: null,
      amount: '-90000',
      reason: null,
      receiptId: '01900000-0000-7000-8000-0000000000e1',
      receiptNumber: 'AZ-2026-000042',
    },
  ],
};

// AP §9.10.5 «كشوف المطاعم» (slice 2.19g): a restaurant's month on screen,
// printable, and exported to Excel.
test("shows a restaurant's statement for a period and exports it", async ({ page }) => {
  await fakeSession(page, ['restaurants.statements']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/restaurant-statements/restaurants?*', (route) =>
    route.fulfill({ json: { restaurants: [{ id: restaurantId, name: 'مطعم الشام' }] } }),
  );
  let asked: URLSearchParams | null = null;
  await page.route('**/v1/admin/restaurant-statements?*', (route) => {
    asked = new URL(route.request().url()).searchParams;
    return route.fulfill({ json: statement });
  });
  let exportBody: unknown = null;
  await page.route('**/v1/admin/restaurant-statements/exports', (route) => {
    exportBody = route.request().postDataJSON();
    return route.fulfill({
      status: 202,
      json: {
        id: exportId,
        kind: 'restaurant_statement',
        status: 'pending',
        fileName: 'كشف مطعم الشام 2026-11-01 - 2026-11-30.xlsx',
        createdAt: '2026-11-16T09:00:00.000Z',
        expiresAt: null,
        url: null,
      },
    });
  });
  let downloads = 0;
  await page.route('**/private-docs/exports/**', (route) => {
    downloads += 1;
    return route.fulfill({ status: 200, body: 'xlsx' });
  });
  await page.route(`**/v1/admin/exports/${exportId}*`, (route) =>
    route.fulfill({
      json: {
        id: exportId,
        kind: 'restaurant_statement',
        status: 'ready',
        fileName: 'كشف مطعم الشام 2026-11-01 - 2026-11-30.xlsx',
        createdAt: '2026-11-16T09:00:00.000Z',
        expiresAt: '2026-11-17T09:00:05.000Z',
        url: new URL(route.request().url()).searchParams.get('download')
          ? '/private-docs/exports/file.xlsx?X-Amz-Signature=fake'
          : null,
      },
    }),
  );

  await page.goto('/restaurant-statements');
  await expect(page.getByRole('heading', { name: 'كشوف المطاعم' })).toBeVisible();
  await page.getByLabel('المطعم').selectOption({ label: 'مطعم الشام' });
  await page.getByLabel('من').fill('2026-11-01');
  await page.getByLabel('إلى').fill('2026-11-30');
  await page.getByRole('button', { name: 'عرض الكشف' }).click();

  await expect(page.getByRole('heading', { name: 'كشف حساب المطعم' })).toBeVisible();
  expect(Object.fromEntries(asked!)).toEqual({
    restaurantId,
    from: '2026-11-01',
    to: '2026-11-30',
  });
  await expect(page.getByRole('row', { name: /الرصيد الافتتاحي/ })).toBeVisible();
  await expect(page.getByRole('row', { name: /الرصيد الختامي/ })).toBeVisible();
  await expect(page.getByRole('cell', { name: 'تسوية يدوية' })).toBeVisible();
  await expect(page.getByRole('cell', { name: 'AZ-2026-000042' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'طباعة A4' })).toBeVisible();

  await page.getByRole('button', { name: 'تصدير Excel' }).click();
  await page.getByRole('button', { name: /تنزيل كشف مطعم الشام/ }).click();
  await expect.poll(() => downloads).toBe(1);
  expect(exportBody).toEqual({ restaurantId, from: '2026-11-01', to: '2026-11-30' });
});
