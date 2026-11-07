import { expect, type Page, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const orderId = '01900000-0000-7000-8000-0000000000d1';
const captainId = '01900000-0000-7000-8000-0000000000e1';
const later = (minutes: number) => new Date(Date.now() + minutes * 60_000).toISOString();

const card = {
  id: orderId,
  number: '10001',
  status: 'ready',
  version: 4,
  placedAt: later(-20),
  restaurant: { id: '01900000-0000-7000-8000-0000000000f1', name: 'مطعم الشام' },
  neighbourhood: 'الحي الأول',
  statusSince: later(-16),
  limitAt: later(-1),
  captainTrack: 'searching',
  captain: null,
  total: { amount: '1250', currency: 'USD' },
  badges: { needsAssignment: true, note: false, newCustomer: true, pickupPending: false },
  moments: {
    acceptAlertAt: null,
    prepLateAlertAt: null,
    searchStartedAt: later(-10),
    searchAlertAt: later(-5),
    noCaptainAlertAt: later(-1),
    captainArrivedAt: null,
    captainWaitingAlertAt: null,
  },
  alerts: ['no_captain', 'no_captain_after_ready'],
};

const detail = {
  ...card,
  promisedAt: later(20),
  acceptance: { at: later(-30), prepMin: 15, prepDueAt: later(-15) },
  readyAt: later(-16),
  cancellation: null,
  customer: {
    name: 'أحمد',
    address: {
      location: { latitude: 36.58, longitude: 37.04 },
      neighbourhood: 'الحي الأول',
      street: 'شارع السوق',
      floor: null,
      landmark: 'قرب الجامع',
      directions: null,
    },
    recipientName: null,
    payIn: null,
    arrival: null,
  },
  note: null,
  lines: [
    { name: 'شاورما', quantity: 2, options: [], note: null, unitPrice: '500', lineTotal: '1000' },
  ],
  money: {
    currency: 'USD',
    itemsValue: '1000',
    deliveryFee: '250',
    discount: '0',
    rounding: '0',
    total: '1250',
    pickupPayment: '1000',
  },
  pickup: { at: null, readyNotPressed: false, requests: [], dispute: null },
  delivery: null,
  timeline: [
    {
      version: 1,
      at: later(-20),
      type: 'order.placed',
      from: null,
      to: 'placed',
      actor: { type: 'customer', id: null },
      captainId: null,
      reason: null,
    },
  ],
};

const picker = {
  captains: [
    {
      captainId,
      name: 'سامر',
      vehicle: 'motorbike',
      eligible: true,
      reasons: [],
      distanceMetres: 850,
      etaMin: 3,
      ordersToday: 2,
      custody: {
        usage: { amount: '2000', currency: 'USD' },
        limit: { amount: '10000', currency: 'USD' },
      },
      acceptanceRate: 90,
    },
    {
      captainId: '01900000-0000-7000-8000-0000000000e2',
      name: 'خالد',
      vehicle: 'car',
      eligible: false,
      reasons: ['busy'],
      distanceMetres: 1200,
      etaMin: 4,
      ordersToday: 5,
      custody: {
        usage: { amount: '0', currency: 'USD' },
        limit: { amount: '10000', currency: 'USD' },
      },
      acceptanceRate: null,
    },
  ],
};

async function fakeOperations(page: Page) {
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/orders?*', (route) => route.fulfill({ json: { orders: [card] } }));
  await page.route(`**/v1/admin/orders/${orderId}`, (route) =>
    route.fulfill({ json: { order: detail } }),
  );
  await page.route(`**/v1/admin/orders/${orderId}/captains`, (route) =>
    route.fulfill({ json: picker }),
  );
}

// AP §9.2, §9.3.2: the owner assigns a captain from the panel.
test('opens a late order from the board and offers it to a captain', async ({ page }) => {
  await fakeSession(page, ['operations.read', 'operations.manage']);
  await fakeOperations(page);
  let boardCity: string | null = null;
  await page.route('**/v1/admin/orders?*', (route) => {
    boardCity = new URL(route.request().url()).searchParams.get('cityId');
    return route.fulfill({ json: { orders: [card] } });
  });
  let sent: { body: unknown; key: string | undefined } | undefined;
  await page.route(`**/v1/admin/orders/${orderId}/assign`, (route) => {
    sent = {
      body: route.request().postDataJSON(),
      key: route.request().headers()['idempotency-key'],
    };
    return route.fulfill({
      json: {
        order: {
          id: orderId,
          number: '10001',
          status: 'ready',
          version: 5,
          captainTrack: 'offered',
          captainId: null,
          offer: { id: '01900000-0000-7000-8000-0000000000a9', captainId, expiresAt: later(1) },
        },
      },
    });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'غرفة العمليات' }).click();
  const ready = page.getByRole('region', { name: 'جاهز' });
  await expect(ready.getByRole('heading', { level: 2 })).toHaveText('جاهز: 1 (متأخر 1)');
  await expect(ready.getByText('تجاوز الحد')).toBeVisible();
  await expect(ready.getByText('جاهز بلا كابتن')).toBeVisible();
  await expect(ready.getByText('بحاجة لتعيين')).toBeVisible();
  expect(boardCity).toBe(cityId);

  await page.getByRole('link', { name: '#10001' }).click();
  await expect(page.getByRole('heading', { name: '#10001' })).toBeVisible();
  await expect(page.getByText('أُنشئ الطلب')).toBeVisible();

  await page.getByRole('link', { name: 'تعيين كابتن' }).click();
  await expect(page.getByText('مشغول')).toBeVisible();
  await expect(page.getByRole('button', { name: 'تعيين خالد' })).toHaveCount(0);
  await page.getByRole('button', { name: 'تعيين سامر' }).click();

  await expect(page.getByRole('status')).toContainText('أُرسل العرض إلى الكابتن');
  expect(sent?.body).toEqual({ captainId });
  expect(sent?.key).toMatch(/^[\w-]{16,128}$/);
});

test('says why a captain can no longer take the order', async ({ page }) => {
  await fakeSession(page, ['operations.read', 'operations.manage']);
  await fakeOperations(page);
  await page.route(`**/v1/admin/orders/${orderId}/assign`, (route) =>
    route.fulfill({
      status: 409,
      json: { statusCode: 409, error: 'captain_not_eligible', reasons: ['cash_limit'] },
    }),
  );
  await page.goto(`/orders/${orderId}/assign`);

  await page.getByRole('button', { name: 'تعيين سامر' }).click();
  await expect(page.getByRole('alert')).toHaveText('هذا الكابتن لم يعد متاحًا: تجاوز حد النقد');
});

test('shows the board without «تعيين كابتن» to a role that only reads', async ({ page }) => {
  await fakeSession(page, ['operations.read']);
  await fakeOperations(page);
  await page.goto(`/orders/${orderId}`);
  await expect(page.getByRole('heading', { name: '#10001' })).toBeVisible();
  await expect(page.getByRole('link', { name: 'تعيين كابتن' })).toHaveCount(0);

  await page.goto(`/orders/${orderId}/assign`);
  await expect(page).toHaveURL(/\/$/);
});

test('is hidden and closed without operations', async ({ page }) => {
  await fakeSession(page, []);
  await page.goto('/');
  await expect(page.getByRole('status')).toHaveText('الخادم يعمل');
  await expect(page.getByRole('link', { name: 'غرفة العمليات' })).toHaveCount(0);

  await page.goto('/orders');
  await expect(page).toHaveURL(/\/$/);
});
