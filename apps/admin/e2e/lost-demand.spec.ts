import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';

// «الطلب الضائع» (slice 2.28a; AP §9.17, CU §8.3): the searches that found
// nothing and the restaurants customers asked for.
test('lists the searches with no result and the suggested restaurants', async ({ page }) => {
  await fakeSession(page, ['reports.operations']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/lost-demand?*', (route) => {
    expect(new URL(route.request().url()).searchParams.get('cityId')).toBe(cityId);
    return route.fulfill({
      json: {
        since: '2026-10-19T10:00:00.000Z',
        searches: [{ query: 'سوشي', count: 7, lastAt: '2026-11-18T09:00:00.000Z' }],
        suggestions: [
          {
            id: '01900000-0000-7000-8000-0000000000d1',
            restaurantName: 'مطعم السوشي',
            note: 'في الشارع العام',
            query: 'سوشي',
            at: '2026-11-18T09:05:00.000Z',
          },
        ],
      },
    });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'الطلب الضائع' }).click();
  const searches = page.getByRole('region', { name: 'بحث بلا نتائج' });
  await expect(searches.getByRole('row', { name: /سوشي 7/ })).toBeVisible();
  const suggestions = page.getByRole('region', { name: 'مطاعم مقترحة' });
  await expect(suggestions.getByText('مطعم السوشي')).toBeVisible();
  await expect(suggestions.getByText('في الشارع العام')).toBeVisible();
});

test('is not offered without an operations report permission', async ({ page }) => {
  await fakeSession(page, ['reports.financial']);
  await page.goto('/');
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  await expect(page.getByRole('link', { name: 'الطلب الضائع' })).toHaveCount(0);
});
