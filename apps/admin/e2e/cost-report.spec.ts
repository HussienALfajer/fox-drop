import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};

const report = {
  cityId,
  fromDay: '2026-11-11',
  toDay: '2026-11-17',
  from: '2026-11-11T03:00:00.000Z',
  to: '2026-11-18T03:00:00.000Z',
  currency: 'TRY',
  totals: { discounts: '9000', compensation: '6500', operating: '36500', total: '52000' },
  compensationReasons: [
    { reason: 'late', label: 'تأخير', orders: 2, amount: '4000' },
    { reason: 'late_delivery', label: null, orders: 1, amount: '2500' },
  ],
  operatingReasons: [
    { reason: 'cancelled_prepared', orders: 1, amount: '34000' },
    { reason: 'captain_compensation', orders: 1, amount: '2500' },
  ],
  codes: [
    { codeId: '01900000-0000-7000-8000-0000000000d1', code: 'FOX10', orders: 3, amount: '9000' },
  ],
  parties: [{ party: 'customer', orders: 1, amount: '36500' }],
  restaurants: [
    {
      restaurantId: '01900000-0000-7000-8000-0000000000a1',
      name: 'مطعم الشام',
      discounts: '9000',
      compensation: '6500',
      operating: '36500',
      total: '52000',
    },
  ],
};

const exported = {
  id: '01900000-0000-7000-8000-0000000000e2',
  kind: 'cost_report',
  status: 'ready',
  fileName: 'كلفة التعويضات والخصومات 2026-11-11 - 2026-11-17.xlsx',
  createdAt: '2026-11-17T08:00:00.000Z',
  expiresAt: '2026-11-18T08:00:00.000Z',
  url: null,
};

// AP §9.10.6: the owner reads a week's compensation by reason, the other
// splits, and asks the Excel file.
test('shows the cost report of the last week and exports it', async ({ page }) => {
  await fakeSession(page, ['finance.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  const read: string[] = [];
  await page.route('**/v1/admin/cost-report?*', (route) => {
    read.push(new URL(route.request().url()).search);
    return route.fulfill({ json: report });
  });
  const asked: unknown[] = [];
  await page.route('**/v1/admin/cost-report/exports', (route) => {
    asked.push(route.request().postDataJSON());
    return route.fulfill({ status: 202, json: exported });
  });
  await page.route('**/v1/admin/exports/*', (route) => route.fulfill({ json: exported }));

  await page.goto('/');
  await page.getByRole('link', { name: 'كلفة التعويضات والخصومات' }).click();
  await expect(page.getByRole('heading', { name: 'كلفة التعويضات والخصومات' })).toBeVisible();
  // No period asked: the server answers the last 7 business days.
  expect(read).toEqual([`?cityId=${cityId}`]);
  await expect(page.getByLabel('من')).toHaveValue('2026-11-11');
  await expect(page.getByLabel('إلى')).toHaveValue('2026-11-17');

  await expect(page.getByRole('row', { name: /^كلفة التعويضات/ })).toContainText('65');
  await expect(page.getByRole('row', { name: /^المجموع/ })).toContainText('520');
  const byReason = page.getByRole('table').nth(1);
  await expect(byReason.getByRole('row', { name: /^تأخير التوصيل/ })).toContainText('25');
  await expect(byReason.getByRole('row', { name: /^تأخير 2/ })).toContainText('40');
  await expect(page.getByRole('row', { name: /طعام حُضّر لطلب أُلغي/ })).toContainText('340');
  await expect(page.getByRole('row', { name: /^الزبون/ })).toContainText('365');
  await expect(page.getByRole('row', { name: /FOX10/ })).toContainText('90');
  await expect(page.getByRole('row', { name: /مطعم الشام/ })).toContainText('520');

  await page.getByRole('button', { name: 'تصدير Excel' }).click();
  await expect(page.getByRole('button', { name: `تنزيل ${exported.fileName}` })).toBeVisible();
  expect(asked).toEqual([{ cityId, from: '2026-11-11', to: '2026-11-17' }]);

  // Another period goes into the link and is asked.
  await page.getByLabel('من').fill('2026-11-01');
  await page.getByRole('button', { name: 'عرض التقرير' }).click();
  await expect(page).toHaveURL(/from=2026-11-01&to=2026-11-17/);
  expect(read.at(-1)).toBe(`?cityId=${cityId}&from=2026-11-01&to=2026-11-17`);
});

test('keeps the cost report from a session without finance.read', async ({ page }) => {
  await fakeSession(page, ['operations.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.goto('/cost-report');
  await expect(page).toHaveURL(/\/$/);
  await expect(page.getByRole('link', { name: 'كلفة التعويضات والخصومات' })).toHaveCount(0);
});
