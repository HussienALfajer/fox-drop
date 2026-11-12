import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};

// AP §9.12.1, CA C13 «المكتب» (owner decision 2026-11-12): OWN types the
// office's point and the desk hours per weekday.
test('saves the office with its hours on Saturday', async ({ page }) => {
  await fakeSession(page, ['zones.read', 'zones.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let sent: unknown = null;
  await page.route(`**/v1/admin/cities/${cityId}/office`, (route) => {
    if (route.request().method() === 'PUT') {
      sent = route.request().postDataJSON();
      return route.fulfill({
        json: {
          office: {
            location: { latitude: 36.5862, longitude: 37.0471 },
            hours: [{ weekday: 6, opensAt: 540, closesAt: 1380 }],
            open: true,
            closesAt: '2026-11-14T20:00:00.000Z',
            opensAt: null,
          },
        },
      });
    }
    return route.fulfill({ json: { office: null } });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'المكتب' }).click();
  await expect(page.getByText('لم يُحدَّد المكتب بعد.')).toBeVisible();
  await page.getByLabel('خط العرض').fill('36.5862');
  await page.getByLabel('خط الطول').fill('37.0471');
  const saturday = page.getByRole('group', { name: 'السبت' });
  await saturday.getByLabel('مفتوح').check();
  await saturday.getByLabel('من').fill('09:00');
  await saturday.getByLabel('إلى').fill('23:00');
  await page.getByRole('button', { name: 'حفظ' }).click();

  await expect(page.getByRole('status')).toHaveText('حُفظ المكتب.');
  expect(sent).toEqual({
    location: { latitude: 36.5862, longitude: 37.0471 },
    hours: [{ weekday: 6, opensAt: 540, closesAt: 1380 }],
  });
  await expect(page.getByText('السبت: من 09:00 إلى 23:00')).toBeVisible();
  await expect(page.getByText('الجمعة: مغلق')).toBeVisible();
});

test('shows the office without the form to a role that only reads it', async ({ page }) => {
  await fakeSession(page, ['zones.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route(`**/v1/admin/cities/${cityId}/office`, (route) =>
    route.fulfill({ json: { office: null } }),
  );
  await page.goto('/office');
  await expect(page.getByText('لم يُحدَّد المكتب بعد.')).toBeVisible();
  await expect(page.getByRole('button', { name: 'حفظ' })).toHaveCount(0);
});
