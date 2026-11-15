import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const statementId = '01900000-0000-7000-8000-0000000000f2';
const lateId = '01900000-0000-7000-8000-0000000000b1';
const paidId = '01900000-0000-7000-8000-0000000000b2';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};

const statement = {
  id: statementId,
  cityId,
  restaurantId: lateId,
  restaurantName: 'مطعم الشام',
  cutoff: '2026-11-14T03:00:00.000Z',
  periodFrom: '2026-11-07T03:00:00.000Z',
  createdAt: '2026-11-14T03:00:30.000Z',
  currency: 'TRY',
  orders: 1,
  itemsValue: '40000',
  commission: '6000',
  discountShare: '0',
  exceptions: '40000',
  weekTotal: '46000',
  previousDue: '1000',
  paid: '1000',
  earlierUnpaid: '0',
  totalDue: '46000',
  lines: [
    {
      position: 0,
      kind: 'order',
      at: '2026-11-10T09:00:00.000Z',
      orderId: '01900000-0000-7000-8000-0000000000a1',
      orderNumber: '10001',
      itemsValue: '40000',
      pickupLines: [
        { currency: 'TRY', amount: '20000' },
        { currency: 'USD', amount: '500' },
      ],
      commission: '6000',
      discountShare: '0',
      cause: null,
      amount: null,
      reason: null,
    },
    {
      position: 1,
      kind: 'exception',
      at: '2026-11-11T09:00:00.000Z',
      orderId: '01900000-0000-7000-8000-0000000000a2',
      orderNumber: '10002',
      itemsValue: null,
      pickupLines: null,
      commission: null,
      discountShare: null,
      cause: 'pickup_refund',
      amount: '40000',
      reason: 'استرداد مبلغ الاستلام',
    },
  ],
};

// AP §9.10.3 «تسوية المطاعم», AP §8.7 (slice 2.19a): the restaurants with a
// balance, the overdue first, and the weekly statement entry by entry.
test('lists the restaurants and shows a weekly statement', async ({ page }) => {
  await fakeSession(page, ['cash_desk.record']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/cash-desk/restaurants?*', (route) =>
    route.fulfill({
      json: {
        currency: 'TRY',
        settlementWeekday: 'saturday',
        nextCutoff: '2026-11-21T03:00:00.000Z',
        restaurants: [
          {
            restaurantId: lateId,
            restaurantName: 'مطعم الشام',
            currency: 'TRY',
            balance: '46000',
            latest: {
              id: statementId,
              cutoff: '2026-11-14T03:00:00.000Z',
              commission: '6000',
              discountShare: '0',
              exceptions: '40000',
              totalDue: '46000',
            },
            unpaid: '46000',
            overdueSince: '2026-11-16T03:00:00.000Z',
          },
          {
            restaurantId: paidId,
            restaurantName: 'مطعم حلب',
            currency: 'TRY',
            balance: '-3400',
            latest: null,
            unpaid: '0',
            overdueSince: null,
          },
        ],
      },
    }),
  );
  await page.route(`**/v1/admin/cash-desk/merchant-statements/${statementId}`, (route) =>
    route.fulfill({ json: statement }),
  );

  await page.goto('/cash-desk/restaurants');
  await expect(page.getByRole('heading', { name: 'تسوية المطاعم' })).toBeVisible();
  const rows = page.getByRole('row');
  await expect(rows.nth(1)).toContainText('مطعم الشام');
  await expect(rows.nth(1)).toContainText(/متأخر منذ/);
  await expect(rows.nth(2)).toContainText(/له/);
  await page.getByRole('link', { name: /كشف .*: المستحق/ }).click();
  await expect(page.getByRole('heading', { name: 'كشف الأسبوع' })).toBeVisible();
  await expect(page.getByRole('cell', { name: 'استرداد مبلغ الاستلام' }).first()).toBeVisible();
  await expect(page.getByRole('rowheader', { name: '#10001' })).toBeVisible();
  await expect(page.getByRole('row', { name: /المجموع المستحق/ })).toBeVisible();
  await expect(page.getByRole('button', { name: 'طباعة A4' })).toBeVisible();
});
