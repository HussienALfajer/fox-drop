import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const code = {
  id: '01900000-0000-7000-8000-0000000000a1',
  code: 'FOX20',
  batchId: null,
  kind: 'percentage',
  percentBp: 2000,
  amount: null,
  maxDiscount: '5000',
  minOrder: '15000',
  validFrom: '2026-11-30T21:00:00.000Z',
  validTo: '2026-12-31T20:59:00.000Z',
  startMinute: null,
  endMinute: null,
  totalLimit: 100,
  perCustomerLimit: 1,
  audience: 'everyone',
  restaurantIds: [],
  zoneIds: [],
  funding: 'platform',
  sharedMerchantBp: null,
  dailyBudget: null,
  visibility: 'visible',
  currency: 'TRY',
  status: 'active',
  state: 'scheduled',
  uses: 0,
  costToDate: '0',
  createdAt: '2026-11-16T10:00:00.000Z',
  updatedAt: '2026-11-16T10:00:00.000Z',
};
const listOf = (codes: object[], canManage = true) => ({
  codes,
  restaurants: [],
  zones: [],
  baseCurrency: 'TRY',
  canManage,
});

// AP §9.11.1 «أكواد الخصم»: OWN creates the example code, sees it in the
// list and pauses it.
test('creates a code, lists it and pauses it', async ({ page }) => {
  await fakeSession(page, ['marketing.read', 'marketing.read_costs', 'marketing.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let codes: object[] = [];
  let sent: unknown = null;
  let key: string | undefined;
  await page.route('**/v1/admin/promo-codes**', (route) => {
    const request = route.request();
    if (request.method() === 'POST' && request.url().endsWith('/pause')) {
      codes = [{ ...code, status: 'paused', state: 'paused' }];
      return route.fulfill({ json: codes[0] });
    }
    if (request.method() === 'POST') {
      sent = request.postDataJSON();
      key = request.headers()['idempotency-key'];
      codes = [code];
      return route.fulfill({ status: 201, json: { codes } });
    }
    return route.fulfill({ json: listOf(codes) });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'أكواد الخصم' }).click();
  await expect(page.getByText('لا توجد أكواد بعد.')).toBeVisible();
  await page.getByRole('button', { name: 'كود جديد' }).click();
  await page.getByLabel('الكود (أحرف لاتينية وأرقام)').fill('fox20');
  await page.getByLabel('النسبة (%)').fill('20');
  await page.getByLabel('الحد الأقصى للخصم (TRY)').fill('50');
  await page.getByLabel('الحد الأدنى للطلب (TRY)').fill('150');
  await page.getByLabel('من', { exact: true }).fill('2026-12-01T00:00');
  await page.getByLabel('إلى', { exact: true }).fill('2026-12-31T23:59');
  await page.getByLabel('الحد الكلي').fill('100');
  await page.getByRole('button', { name: 'إنشاء' }).click();

  await expect(page.getByRole('status')).toHaveText('أُنشئ الكود FOX20.');
  expect(key).toBeTruthy();
  expect(sent).toMatchObject({
    cityId,
    code: 'fox20',
    kind: 'percentage',
    percentBp: 2000,
    maxDiscount: '5000',
    minOrder: '15000',
    validFrom: '2026-11-30T21:00:00.000Z',
    totalLimit: 100,
    perCustomerLimit: 1,
  });
  const row = page.getByRole('row', { name: /FOX20/ });
  await expect(row).toContainText('نسبة مئوية');
  await expect(row).toContainText('لم يبدأ بعد');
  await expect(row).toContainText('0 من 100');
  await row.getByRole('button', { name: 'إيقاف FOX20' }).click();
  await expect(page.getByRole('row', { name: /FOX20/ })).toContainText('موقوف');
});

test('shows OPS the codes without their cost or the form', async ({ page }) => {
  await fakeSession(page, ['marketing.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/promo-codes**', (route) =>
    route.fulfill({ json: listOf([{ ...code, costToDate: null }], false) }),
  );
  await page.goto('/promo-codes');
  await expect(page.getByRole('row', { name: /FOX20/ })).toContainText('—');
  await expect(page.getByRole('button', { name: 'كود جديد' })).toHaveCount(0);
  await expect(page.getByRole('button', { name: 'إيقاف FOX20' })).toHaveCount(0);
});

// AP §9.11.1 «Code report» (slice 2.21d): the code's name opens its report;
// OWN extends it from there.
test('opens a code report and extends the code', async ({ page }) => {
  await fakeSession(page, ['marketing.read', 'marketing.read_costs', 'marketing.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let extended: unknown = null;
  let current = { ...code, state: 'active', uses: 3, costToDate: '9000' };
  await page.route('**/v1/admin/promo-codes**', (route) => {
    const request = route.request();
    if (request.method() === 'POST' && request.url().endsWith('/extend')) {
      extended = request.postDataJSON();
      current = { ...current, validTo: '2027-01-31T20:59:00.000Z' };
      return route.fulfill({ json: current });
    }
    if (request.url().includes('/report')) {
      return route.fulfill({
        json: {
          code: current,
          report: {
            orders: 3,
            returned: 1,
            customers: 2,
            newCustomers: 1,
            cost: '9000',
            merchantShare: '3000',
          },
          canManage: true,
        },
      });
    }
    return route.fulfill({ json: listOf([current]) });
  });
  await page.goto('/promo-codes');

  await page.getByRole('link', { name: 'FOX20' }).click();
  await expect(page.getByRole('heading', { name: 'تقرير الكود' })).toBeVisible();
  await expect(page.getByText('زبائن جدد جلبهم الكود')).toBeVisible();
  await expect(page.getByRole('definition').filter({ hasText: '90.00' })).toBeVisible();

  await page.getByLabel('النهاية الجديدة').fill('2027-01-31T23:59');
  await page.getByRole('button', { name: 'تمديد FOX20' }).click();
  await expect(page.getByRole('status')).toContainText('مُدّد الكود FOX20');
  expect(extended).toEqual({ cityId, validTo: '2027-01-31T20:59:00.000Z' });
});
