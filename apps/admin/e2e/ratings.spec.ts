import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const restaurantId = '01900000-0000-7000-8000-0000000000a1';
const captainId = '01900000-0000-7000-8000-0000000000b1';
const asOf = '2026-11-18T10:00:00.000Z';

const rating = (orderNumber: string, stars: number, comment: string | null) => ({
  orderId: `01900000-0000-7000-8000-0000000${orderNumber.padStart(5, '0')}`,
  orderNumber,
  stars,
  reasons: stars <= 2 ? [{ code: 'late', label: 'تأخر' }] : [],
  comment,
  at: '2026-11-18T09:00:00.000Z',
});

const distribution = [5, 4, 3, 2, 1].map((stars) => ({ stars, count: stars === 2 ? 1 : 0 }));

// «التقييمات» (slice 2.26c; AP §9.6.4, §9.7.4): a captain's ratings with
// the comments and the order, filtered and paged; never the customer's name.
test('reads a captain’s ratings with the comments, filters and reads more', async ({ page }) => {
  await fakeSession(page, ['restaurants.read', 'captains.read']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/restaurants?*', (route) =>
    route.fulfill({ json: { restaurants: [{ id: restaurantId, nameAr: 'مطعم الشام' }] } }),
  );
  await page.route('**/v1/admin/ratings/captains?*', (route) =>
    route.fulfill({
      json: { captains: [{ id: captainId, name: 'أحمد', count: 21, average: 2.5 }] },
    }),
  );
  const asked: URLSearchParams[] = [];
  await page.route(`**/v1/admin/ratings/captains/${captainId}?*`, (route) => {
    const query = new URL(route.request().url()).searchParams;
    asked.push(query);
    const second = query.get('page') === '1';
    return route.fulfill({
      json: {
        asOf,
        count: 21,
        average: 2.5,
        distribution,
        ratings: second ? [rating('20', 1, null)] : [rating('17', 2, 'تأخر كثيراً')],
        more: !second,
      },
    });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'التقييمات' }).click();
  await page.getByLabel('الكابتن').selectOption({ label: 'أحمد (2.5 من 5، 21 تقييم)' });
  await expect(page.getByText('2.5 من 5', { exact: true })).toBeVisible();
  await expect(page.getByText('عدد التقييمات: 21')).toBeVisible();
  const list = page.getByRole('list', { name: 'التقييمات' });
  await expect(list.getByText('«تأخر كثيراً»')).toBeVisible();
  await expect(list.getByText('الأسباب: تأخر').first()).toBeVisible();
  // Without operations.read the order is its number, not a link.
  await expect(list.getByText(/الطلب #17/)).toBeVisible();
  await expect(list.getByRole('link')).toHaveCount(0);

  await page.getByRole('button', { name: 'عرض المزيد' }).click();
  await expect(list.getByText(/الطلب #20/)).toBeVisible();
  await expect(page.getByRole('button', { name: 'عرض المزيد' })).toHaveCount(0);
  expect(asked[1]?.get('asOf')).toBe(asOf);

  await page.getByRole('combobox', { name: /^النجوم/ }).selectOption({ label: '2 ★' });
  await expect.poll(() => asked.at(-1)?.get('stars')).toBe('2');
  await expect(page).toHaveURL(/stars=2/);
});
