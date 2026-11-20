import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';

const report = {
  report: 'orders',
  cityId,
  fromDay: '2026-11-14',
  toDay: '2026-11-20',
  from: '2026-11-14T01:00:00.000Z',
  to: '2026-11-20T09:00:00.000Z',
  currency: 'TRY',
  tables: [
    {
      key: 'summary',
      rowKind: 'none',
      rowCodes: null,
      columns: [
        { key: 'placed', kind: 'count' },
        { key: 'success', kind: 'bp' },
      ],
      rows: [{ code: null, label: null, currency: null, cells: ['12', '7500'] }],
    },
    {
      key: 'outcomes',
      rowKind: 'code',
      rowCodes: 'outcome',
      columns: [{ key: 'orders', kind: 'count' }],
      rows: [{ code: 'fake', label: null, currency: null, cells: ['2'] }],
    },
  ],
};

// «التقارير» (slice 2.41; AP §9.17, §6.2): a report of the session's, its
// tables, and «تصدير Excel».
test('shows a report as tables and exports it', async ({ page }) => {
  await fakeSession(page, ['reports.operations']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/reports/orders?*', (route) => {
    expect(new URL(route.request().url()).searchParams.get('cityId')).toBe(cityId);
    return route.fulfill({ json: report });
  });
  let exported: unknown = null;
  await page.route('**/v1/admin/reports/orders/exports', (route) => {
    exported = route.request().postDataJSON();
    return route.fulfill({
      status: 202,
      json: {
        id: '01900000-0000-7000-8000-0000000000e1',
        kind: 'report',
        status: 'pending',
        fileName: 'تقرير الطلبات 2026-11-14 - 2026-11-20.xlsx',
        createdAt: '2026-11-20T09:00:00.000Z',
        expiresAt: null,
        url: null,
      },
    });
  });
  await page.route('**/v1/admin/exports/*', (route) =>
    route.fulfill({
      json: {
        id: '01900000-0000-7000-8000-0000000000e1',
        kind: 'report',
        status: 'pending',
        fileName: 'تقرير الطلبات 2026-11-14 - 2026-11-20.xlsx',
        createdAt: '2026-11-20T09:00:00.000Z',
        expiresAt: null,
        url: null,
      },
    }),
  );
  await page.goto('/');

  await page.getByRole('link', { name: 'التقارير', exact: true }).click();
  const main = page.getByRole('main');
  await expect(main.getByRole('link', { name: 'تقرير الطلبات' })).toBeVisible();
  await expect(main.getByRole('link', { name: 'التقرير المالي' })).toHaveCount(0);
  const summary = main.getByRole('region', { name: 'الملخص' });
  await expect(summary.getByRole('row', { name: '12 75.0%' })).toBeVisible();
  const outcomes = main.getByRole('region', { name: 'نتائج الطلبات بعد الاستلام' });
  await expect(outcomes.getByRole('row', { name: 'وهمي 2' })).toBeVisible();

  await main.getByRole('button', { name: 'تصدير Excel' }).click();
  await expect(main.getByRole('status')).toBeVisible();
  expect(exported).toEqual({ cityId, from: '2026-11-14', to: '2026-11-20' });
});

test('is not offered without a report permission', async ({ page }) => {
  await fakeSession(page, ['operations.read']);
  await page.goto('/');
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  await expect(page.getByRole('link', { name: 'التقارير', exact: true })).toHaveCount(0);
});
