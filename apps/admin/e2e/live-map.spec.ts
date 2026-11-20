import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const restaurantId = '01900000-0000-7000-8000-0000000000e1';
const captainId = '01900000-0000-7000-8000-0000000000f1';
const orderId = '01900000-0000-7000-8000-0000000000a1';
const money = (amount: string) => ({ amount, currency: 'TRY' });
const view = {
  zones: [
    {
      id: '01900000-0000-7000-8000-0000000000d1',
      name: 'المركز',
      active: true,
      area: [
        { latitude: 36.58, longitude: 37.04 },
        { latitude: 36.58, longitude: 37.05 },
        { latitude: 36.59, longitude: 37.05 },
      ],
    },
  ],
  restaurants: [
    {
      id: restaurantId,
      name: 'مطعم الساحة',
      location: { latitude: 36.585, longitude: 37.045 },
      state: 'paused',
    },
  ],
  captains: [
    {
      captainId,
      name: 'أحمد',
      vehicle: 'motorbike',
      state: 'online_available',
      blocks: [],
      custody: { usage: money('5000'), limit: money('300000') },
      position: { latitude: 36.586, longitude: 37.046, recordedAt: '2026-11-19T09:00:00.000Z' },
      order: null,
    },
    {
      captainId: '01900000-0000-7000-8000-0000000000f2',
      name: 'سامر',
      vehicle: 'car',
      state: 'offline',
      blocks: ['cash_limit'],
      custody: { usage: money('300000'), limit: money('300000') },
      position: null,
      order: null,
    },
  ],
  orders: [
    {
      id: orderId,
      number: '10001',
      status: 'accepted',
      restaurantId,
      restaurantName: 'مطعم الساحة',
      from: { latitude: 36.585, longitude: 37.045 },
      to: { latitude: 36.59, longitude: 37.046 },
      captainId: null,
      assignable: true,
    },
  ],
};

// AP §9.4 «الخريطة الحية» (slice 2.39): the layers as lists (the smoke tests
// have no map), the filters, a captain's card and «عيّنه لطلب».
test('assigns a captain to an order from the live map', async ({ page }) => {
  await fakeSession(page, ['live_map.read', 'operations.manage', 'operations.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/live-map?*', (route) => route.fulfill({ json: view }));
  const assigned: unknown[] = [];
  await page.route(`**/v1/admin/orders/${orderId}/assign`, (route) => {
    assigned.push({
      key: route.request().headers()['idempotency-key'],
      body: route.request().postDataJSON(),
    });
    return route.fulfill({
      json: {
        order: {
          id: orderId,
          number: '10001',
          status: 'accepted',
          version: 3,
          captainTrack: 'assigned',
          captainId,
          offer: null,
        },
      },
    });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'الخريطة الحية' }).click();
  const main = page.getByRole('main');
  await expect(main.getByRole('heading', { name: 'الخريطة الحية' })).toBeVisible();
  await expect(
    main.getByRole('button', { name: 'مطعم الساحة — كهرماني: متوقف مؤقتاً' }),
  ).toBeVisible();
  await expect(main.getByText('سامر — رمادي: غير متصل')).toBeVisible();
  await expect(main.getByText('(محجوب: حد أحمر)')).toBeVisible();
  await expect(main.getByText('بلا كابتن')).toBeVisible();

  await main.getByLabel('المتاحون فقط').check();
  await expect(main.getByText('سامر — رمادي: غير متصل')).toBeHidden();

  await main.getByRole('button', { name: 'أحمد — أخضر: متاح' }).click();
  await expect(main.getByRole('heading', { name: 'أحمد' })).toBeVisible();
  await expect(main.getByText('3,000.00 TRY', { exact: false })).toBeVisible();
  await main.getByRole('button', { name: 'عيّنه لطلب' }).click();
  await main.getByRole('button', { name: 'طلب #10001 من مطعم الساحة' }).click();
  await expect(main.getByText('تم تعيين الكابتن.')).toBeVisible();
  expect(assigned).toEqual([{ key: expect.any(String), body: { captainId } }]);
});

test('shows a restaurant’s active orders and leaves out the assignment for SUP', async ({
  page,
}) => {
  await fakeSession(page, ['live_map.read', 'operations.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/live-map?*', (route) => route.fulfill({ json: view }));
  await page.goto('/live-map');
  const main = page.getByRole('main');
  await main.getByRole('button', { name: 'مطعم الساحة — كهرماني: متوقف مؤقتاً' }).click();
  await expect(main.getByRole('heading', { name: 'الطلبات النشطة: 1' })).toBeVisible();
  await main.getByRole('button', { name: 'أحمد — أخضر: متاح' }).click();
  await expect(main.getByRole('heading', { name: 'أحمد' })).toBeVisible();
  await expect(main.getByRole('button', { name: 'عيّنه لطلب' })).toBeHidden();
});
