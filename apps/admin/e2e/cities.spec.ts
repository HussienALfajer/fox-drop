import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const city = { id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus', status: 'active' };
const profile = {
  city,
  currencies: [
    { code: 'TRY', name: 'ليرة تركية', symbol: '₺', displayOrder: 1, enabled: true, isBase: true },
  ],
  otherCurrencies: [{ code: 'USD', name: 'دولار أمريكي', symbol: '$' }],
  baseLocked: true,
};

// AP §9.12.1 «المدن» (slice 2.37c): OWN changes the city's clock and adds
// an accepted currency; the base stays locked after the first order.
test('changes the time zone and adds a currency', async ({ page }) => {
  await fakeSession(page, ['zones.read', 'zones.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: { cities: [city] } }));
  await page.route('**/v1/admin/cities/all', (route) =>
    route.fulfill({ json: { cities: [city] } }),
  );
  await page.route('**/v1/admin/settings?*', (route) => route.fulfill({ json: { settings: [] } }));
  let sentCity: unknown = null;
  await page.route(`**/v1/admin/cities/${cityId}`, (route) => {
    if (route.request().method() === 'PUT') {
      sentCity = route.request().postDataJSON();
      return route.fulfill({
        json: { ...profile, city: { ...city, timeZone: 'Europe/Istanbul' } },
      });
    }
    return route.fulfill({ json: profile });
  });
  let sentCurrency: unknown = null;
  await page.route(`**/v1/admin/cities/${cityId}/currencies/USD`, (route) => {
    sentCurrency = route.request().postDataJSON();
    return route.fulfill({
      json: {
        ...profile,
        currencies: [
          ...profile.currencies,
          {
            code: 'USD',
            name: 'دولار أمريكي',
            symbol: '$',
            displayOrder: 2,
            enabled: false,
            isBase: false,
          },
        ],
        otherCurrencies: [],
      },
    });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'المدن' }).click();
  await expect(page.getByText('المنطقة الزمنية: Asia/Damascus')).toBeVisible();
  await expect(page.getByText('عملة الأساس مقفلة منذ أول طلب.', { exact: false })).toBeVisible();
  await expect(page.getByRole('button', { name: /جعل .* عملة الأساس/ })).toHaveCount(0);
  await page.getByLabel('المنطقة الزمنية', { exact: true }).fill('Europe/Istanbul');
  await page.getByRole('button', { name: 'حفظ بيانات المدينة' }).click();
  await expect(page.getByText('حُفظت بيانات المدينة.')).toBeVisible();
  expect(sentCity).toEqual({
    name: 'أعزاز',
    code: 'AZ',
    timeZone: 'Europe/Istanbul',
    status: 'active',
    reason: null,
  });

  await page.getByRole('button', { name: 'إضافة', exact: true }).click();
  await expect(page.getByText('دولار أمريكي (USD): غير مقبولة')).toBeVisible();
  expect(sentCurrency).toEqual({ displayOrder: 2, enabled: false });
});
