import { expect, type Page, test } from '@playwright/test';

// The portal's API is answered here, so the smoke test needs no server.
const session = {
  accountId: '0190f3a0-0000-7000-8000-000000000001',
  restaurantId: '0190f3a0-0000-7000-8000-000000000002',
  name: 'سامر',
  sessionId: '0190f3a0-0000-7000-8000-000000000003',
};

function boardOrder(minutesAgo: number) {
  const placedAt = new Date(Date.now() - minutesAgo * 60_000).toISOString();
  return {
    id: '0190f3a0-0000-7000-8000-000000000010',
    number: '10001',
    redeliveryOf: null,
    testOrder: false,
    status: 'placed',
    version: 1,
    placedAt,
    acceptAlertAt: new Date(Date.now() + 60_000).toISOString(),
    autoCancelAt: new Date(Date.now() + 180_000).toISOString(),
    acceptance: null,
    readyAt: null,
    customer: { firstName: 'رامي', neighbourhood: 'الحي الشمالي' },
    note: null,
    lines: [
      {
        itemId: '0190f3a0-0000-7000-8000-000000000011',
        name: 'شاورما',
        quantity: 2,
        options: [],
        note: null,
        lineTotal: '20000',
      },
    ],
    currency: 'TRY',
    itemsValue: '20000',
    owner: null,
    captainTrack: null,
    captain: null,
    captainArrival: null,
    itemReport: null,
    edits: [],
    cancellation: null,
    pickup: {
      request: null,
      pickedUpAt: null,
      readyNotPressed: false,
      disputeUntil: null,
      disputedAt: null,
    },
  };
}

async function signedOutApi(page: Page) {
  let signedIn = false;
  await page.route('**/v1/merchant/auth/portal/session', (route) =>
    signedIn ? route.fulfill({ json: session }) : route.fulfill({ status: 401, json: {} }),
  );
  await page.route('**/v1/merchant/auth/portal/code', (route) =>
    route.fulfill({
      json: { channel: 'whatsapp', resendAfterSec: 60, expiresAt: new Date().toISOString() },
    }),
  );
  await page.route('**/v1/merchant/auth/portal/sign-in', (route) => {
    signedIn = true;
    return route.fulfill({ json: { ...session, expiresAt: new Date().toISOString() } });
  });
  await page.route('**/v1/merchant/orders', (route) =>
    route.fulfill({ json: { orders: [boardOrder(2)], prepTime: {} } }),
  );
  await page.route('**/v1/merchant/terms', (route) =>
    route.fulfill({
      json: { version: 1, body: 'الشروط', publishedAt: new Date().toISOString(), pending: false },
    }),
  );
  await page.route('**/v1/merchant/emergency-stop', (route) =>
    route.fulfill({ json: { active: false, startedAt: null } }),
  );
  // Real time is down in the smoke test: the board polls.
  await page.route('**/v1/merchant/realtime/token', (route) =>
    route.fulfill({ status: 503, json: { error: 'realtime_unavailable' } }),
  );
}

test('signs an owner in and shows the live orders read-only, right to left', async ({ page }) => {
  await signedOutApi(page);
  await page.goto('/');

  await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
  await expect(page.locator('html')).toHaveAttribute('lang', 'ar');
  await expect(page).toHaveTitle('بوابة المطعم');
  await expect(page.getByRole('heading', { name: 'تسجيل الدخول' })).toBeVisible();

  await page.getByLabel('رقم الهاتف').fill('0912345678');
  await page.getByRole('button', { name: 'إرسال الرمز' }).click();
  await expect(page.getByText('أرسلنا الرمز إلى واتساب على الرقم +963912345678')).toBeVisible();
  await page.getByLabel('الرمز').fill('123456');
  await page.getByRole('button', { name: 'تأكيد' }).click();

  await expect(page.getByText('لاستقبال الطلبات استخدم تطبيق أندرويد أو ويندوز')).toBeVisible();
  await expect(page.getByRole('heading', { name: 'جديدة (1)' })).toBeVisible();
  await expect(page.getByRole('link', { name: '#10001' })).toBeVisible();
  // Nothing to press on an order (RA §17).
  await expect(page.getByRole('button', { name: /قبول/ })).toHaveCount(0);
});

test('tells a cashier the portal is for owners', async ({ page }) => {
  await page.route('**/v1/merchant/auth/portal/session', (route) =>
    route.fulfill({ status: 401, json: {} }),
  );
  await page.route('**/v1/merchant/auth/portal/code', (route) =>
    route.fulfill({ status: 403, json: { statusCode: 403, error: 'owner_only' } }),
  );
  await page.goto('/sign-in');
  await page.getByLabel('رقم الهاتف').fill('0912345678');
  await page.getByRole('button', { name: 'إرسال الرمز' }).click();
  await expect(page.getByRole('alert')).toContainText('بوابة المطعم لمالكي المطاعم');
});
