import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const city = { id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' };

const minimum = {
  key: 'merchant.default_min_order',
  template: 'merchant.default_min_order',
  parameter: null,
  group: 'restaurants',
  type: 'money',
  unit: null,
  scope: 'city',
  cityId,
  editRoles: ['OWN'],
  reasonRequired: true,
  beforeLaunch: true,
  default: null,
  value: null,
  isDefault: true,
};

// AP §9.12.4 «الإعدادات الافتراضية» (slice 2.37c): OWN enters the default
// minimum order in the city's base currency, with the reason a money
// setting needs.
test('sets the default minimum order in the base currency', async ({ page }) => {
  await fakeSession(page, ['zones.read', 'settings.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: { cities: [city] } }));
  await page.route(`**/v1/admin/cities/${cityId}`, (route) =>
    route.fulfill({
      json: {
        city: { ...city, status: 'active' },
        currencies: [
          {
            code: 'TRY',
            name: 'ليرة تركية',
            symbol: '₺',
            displayOrder: 1,
            enabled: true,
            isBase: true,
          },
        ],
        otherCurrencies: [],
        baseLocked: false,
      },
    }),
  );
  await page.route('**/v1/admin/settings?*', (route) =>
    route.fulfill({ json: { settings: [minimum] } }),
  );
  const sent: unknown[] = [];
  await page.route('**/v1/admin/settings/merchant.default_min_order', (route) => {
    sent.push(route.request().postDataJSON());
    if (sent.length === 1) {
      return route.fulfill({ status: 400, json: { statusCode: 400, error: 'reason_required' } });
    }
    return route.fulfill({ json: { ...minimum, value: { amountMinor: 15000, currency: 'TRY' } } });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'الإعدادات الافتراضية' }).click();
  await expect(
    page.getByText('الحد الأدنى للطلب الافتراضي: لم تُحدَّد بعد (القيمة الافتراضية)'),
  ).toBeVisible();
  const form = page.getByRole('form', { name: 'الحد الأدنى للطلب الافتراضي' });
  await form.getByLabel('الحد الأدنى للطلب الافتراضي').fill('150');
  await form.getByRole('button').click();
  await expect(form.getByRole('alert')).toHaveText('اكتب السبب: هذا الإعداد يؤثر في المال.');
  await form.getByLabel('السبب').fill('قبل الإطلاق');
  await form.getByRole('button').click();
  await expect(form.getByRole('status')).toHaveText('حُفظ. يسري الآن.');
  expect(sent[1]).toEqual({
    cityId,
    value: { amountMinor: 15000, currency: 'TRY' },
    reason: 'قبل الإطلاق',
  });
});
