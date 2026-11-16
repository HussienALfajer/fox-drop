import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};

function day(date: string, margin: string) {
  return {
    day: date,
    from: `${date}T03:00:00.000Z`,
    to: `${date}T03:00:00.000Z`,
    currency: 'TRY',
    orders: { count: 2, gmv: '82000', itemsValue: '80000' },
    deliveryFees: '8000',
    discounts: { platform: '0', restaurant: '0' },
    commission: '12000',
    captainPay: {
      base: '4000',
      distance: '1000',
      waiting: '0',
      peak: '0',
      bonuses: '0',
      total: '5000',
    },
    compensation: '0',
    operatingCost: '0',
    testCost: '0',
    fxRounding: '0',
    adjustments: '0',
    margin,
    cash: [
      {
        currency: 'TRY',
        custodyCreated: '2000',
        handedIn: '1500',
        reimbursed: '0',
        openCustody: '500',
        owedToCaptains: '0',
        captainPayouts: '0',
        restaurantPayments: '0',
      },
    ],
    restaurants: {
      commission: '12000',
      discountShare: '0',
      owedByRestaurants: '12000',
      owedToRestaurants: '0',
    },
  };
}

// AP §9.10.1: FIN opens today's report, sees the margin beside the days
// before, the cash and today's state, and asks the Excel file.
test('shows the daily report and exports it', async ({ page }) => {
  await fakeSession(page, ['finance.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/daily-report?*', (route) =>
    route.fulfill({
      json: {
        ...day('2026-11-16', '15000'),
        cityId,
        today: true,
        now: {
          captainsBlocked: 1,
          overdueRestaurants: [
            {
              restaurantId: '01900000-0000-7000-8000-0000000000a1',
              name: 'مطعم الشام',
              balance: '30000',
              overdueSince: '2026-11-16T03:00:00.000Z',
            },
          ],
        },
        previous: [day('2026-11-15', '9000')],
      },
    }),
  );
  const asked: unknown[] = [];
  await page.route('**/v1/admin/daily-report/exports', (route) => {
    asked.push(route.request().postDataJSON());
    return route.fulfill({
      status: 202,
      json: {
        id: '01900000-0000-7000-8000-0000000000e1',
        kind: 'daily_report',
        status: 'ready',
        fileName: 'التقرير اليومي 2026-11-16.xlsx',
        createdAt: '2026-11-16T08:00:00.000Z',
        expiresAt: '2026-11-17T08:00:00.000Z',
        url: null,
      },
    });
  });
  await page.route('**/v1/admin/exports/*', (route) =>
    route.fulfill({
      json: {
        id: '01900000-0000-7000-8000-0000000000e1',
        kind: 'daily_report',
        status: 'ready',
        fileName: 'التقرير اليومي 2026-11-16.xlsx',
        createdAt: '2026-11-16T08:00:00.000Z',
        expiresAt: '2026-11-17T08:00:00.000Z',
        url: null,
      },
    }),
  );

  await page.goto('/daily-report');
  await expect(page.getByRole('heading', { name: 'التقرير اليومي' })).toBeVisible();
  const margin = page.getByRole('row', { name: /هامش المنصة/ });
  await expect(margin).toContainText('150');
  await expect(margin).toContainText('90');
  await expect(page.getByRole('columnheader', { name: '2026-11-15' })).toBeVisible();
  await expect(page.getByRole('row', { name: /سُلّم اليوم/ })).toContainText('15');
  await expect(page.getByText('كباتن محظورون بسبب النقد: 1')).toBeVisible();
  await expect(page.getByRole('row', { name: /مطعم الشام/ })).toBeVisible();

  await page.getByRole('button', { name: 'تصدير Excel' }).click();
  await expect(
    page.getByRole('button', { name: 'تنزيل التقرير اليومي 2026-11-16.xlsx' }),
  ).toBeVisible();
  expect(asked).toEqual([{ cityId, day: '2026-11-16' }]);
});
