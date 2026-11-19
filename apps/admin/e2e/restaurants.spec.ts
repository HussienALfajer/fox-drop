import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const restaurantId = '01900000-0000-7000-8000-0000000000a1';
const zoneId = '01900000-0000-7000-8000-0000000000d1';

const listed = {
  id: restaurantId,
  nameAr: 'مطعم الشام',
  nameEn: null,
  categories: [{ id: '01900000-0000-7000-8000-0000000000e1', name: 'مشاوي' }],
  accountStatus: 'active',
  state: 'open',
  visible: true,
  sortWeight: 0,
  zoneName: 'المركز',
  ratingAverage: 4.3,
  ratingCount: 12,
  ordersToday: 7,
  acceptanceBp7d: 9500,
  commissionBp: 1500,
  balance: '36000',
  lastOrderAt: '2026-11-18T09:00:00.000Z',
};

const account = (fields: Record<string, unknown> = {}) => ({
  nameAr: 'مطعم الشام',
  accountStatus: 'active',
  suspensionReason: null,
  visible: true,
  sortWeight: 0,
  sortWeightMax: 1000,
  commissionBp: 1500,
  nextCommission: null,
  commissionHistory: [
    {
      id: '01900000-0000-7000-8000-0000000000f1',
      rateBp: 1500,
      from: '2026-11-01T09:00:00.000Z',
      reason: null,
      setAt: '2026-11-01T09:00:00.000Z',
      byAdmin: true,
    },
  ],
  ...fields,
});

const status = {
  state: 'open',
  pauseSource: null,
  stateUntil: null,
  opensAt: null,
  closesAt: null,
  busyMode: null,
  activeOrders: 0,
  maxActiveOrders: null,
  holiday: null,
  pauseChoicesMin: [15, 30, 60],
  nameAr: 'مطعم الشام',
  accountStatus: 'active',
  heldPauseSource: null,
  heldPauseUntil: null,
  pauseMessage: null,
  pauseReason: null,
  pickupBaseCurrency: null,
  pickupCurrencies: [],
  pickupCurrencyChoices: [],
};

// «المطاعم» (slice 2.30c; AP §9.6.2, §9.6.5, D16): the list with its
// columns and filters, then a restaurant's suspension and a commission
// changed for new orders from a set time.
test('lists the restaurants, filters them, suspends one and changes its commission', async ({
  page,
}) => {
  await fakeSession(page, ['restaurants.read', 'restaurants.manage', 'restaurants.commission']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/restaurant-drafts/choices?*', (route) =>
    route.fulfill({
      json: {
        categories: listed.categories,
        categoriesMax: 5,
        zones: [{ id: zoneId, name: 'المركز' }],
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
  const asked: Record<string, unknown>[] = [];
  await page.route('**/v1/admin/restaurant-list', (route) => {
    asked.push(route.request().postDataJSON() as Record<string, unknown>);
    return route.fulfill({ json: { currency: 'TRY', restaurants: [listed] } });
  });
  await page.route('**/v1/admin/restaurants?*', (route) =>
    route.fulfill({ json: { restaurants: [{ id: restaurantId, nameAr: 'مطعم الشام' }] } }),
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
        location: { location: null, address: null, phone: null, ownerName: null },
        operations: { periods: [], defaultPrepMin: 20, minimumOrder: null, coverage: null },
        commission: null,
        contract: null,
        steps: { basics: true, location: true, operations: true, commission: true, contract: true },
      },
    }),
  );
  await page.route(`**/v1/admin/restaurants/${restaurantId}/overview?*`, (route) =>
    route.fulfill({ status: 503, json: { statusCode: 503 } }),
  );
  await page.route(`**/v1/admin/restaurants/${restaurantId}/status`, (route) =>
    route.fulfill({ json: status }),
  );
  let current = account();
  await page.route(`**/v1/admin/restaurants/${restaurantId}/account`, (route) =>
    route.fulfill({ json: current }),
  );
  const commands: { url: string; body: unknown }[] = [];
  await page.route(`**/v1/admin/restaurants/${restaurantId}/suspend`, (route) => {
    commands.push({ url: 'suspend', body: route.request().postDataJSON() });
    current = account({ accountStatus: 'suspended', suspensionReason: 'مخالفة الأسعار' });
    return route.fulfill({ json: current });
  });
  await page.route(`**/v1/admin/restaurants/${restaurantId}/commission`, (route) => {
    commands.push({ url: 'commission', body: route.request().postDataJSON() });
    current = account({
      accountStatus: 'suspended',
      suspensionReason: 'مخالفة الأسعار',
      nextCommission: { rateBp: 1250, from: '2026-11-19T21:00:00.000Z' },
    });
    return route.fulfill({ json: current });
  });
  await page.route('**/v1/admin/realtime/token', (route) =>
    route.fulfill({ status: 503, json: { statusCode: 503 } }),
  );
  await page.goto('/');

  await page.getByRole('link', { name: 'المطاعم', exact: true }).click();
  const table = page.getByRole('table', { name: 'المطاعم' });
  await expect(table.getByRole('link', { name: 'مطعم الشام' })).toBeVisible();
  await expect(table.getByText('مشاوي')).toBeVisible();
  await expect(table.getByText('95%')).toBeVisible();
  await expect(table.getByText('15%')).toBeVisible();
  await page.getByLabel('حالة الحساب').selectOption({ label: 'معلّق' });
  await expect.poll(() => asked.at(-1)?.status).toBe('suspended');
  await expect(page).toHaveURL(/status=suspended/);
  // A number searched goes in the body only, never in the URL.
  await page.getByLabel('بحث بالاسم أو الرقم').fill('0944 000 111');
  await page.getByRole('button', { name: 'بحث' }).click();
  await expect.poll(() => asked.at(-1)?.q).toBe('0944 000 111');
  expect(page.url()).not.toContain('0944');

  await table.getByRole('link', { name: 'مطعم الشام' }).click();
  // The name opens the profile (slice 2.30d), whose «الحالة والحساب» holds the actions.
  await page.getByRole('link', { name: 'الحالة والحساب' }).click();
  const section = page.getByRole('region', { name: 'الحساب والعمولة' });
  await expect(section.getByText('حالة الحساب: فعّال')).toBeVisible();
  const suspend = section.getByRole('form', { name: 'تعليق' });
  await suspend.getByLabel('السبب').fill('مخالفة الأسعار');
  await suspend.getByRole('button', { name: 'تعليق' }).click();
  await expect(section.getByText('سبب التعليق: مخالفة الأسعار')).toBeVisible();
  expect(commands[0]).toEqual({ url: 'suspend', body: { reason: 'مخالفة الأسعار' } });

  const commission = section.getByRole('form', { name: 'تغيير العمولة' });
  await commission.getByLabel('النسبة %').fill('12.5');
  await commission.getByLabel('من وقت محدد').check();
  await commission.getByLabel('يبدأ في').fill('2026-11-20T00:00');
  await commission.getByLabel('السبب').fill('اتفاق جديد');
  await commission.getByRole('button', { name: 'تغيير العمولة' }).click();
  await expect(section.getByText(/تتغيّر إلى 12.5% اعتباراً من/)).toBeVisible();
  expect(commands[1]).toEqual({
    url: 'commission',
    body: { rateBp: 1250, effectiveFrom: '2026-11-19T21:00:00.000Z', reason: 'اتفاق جديد' },
  });
});
