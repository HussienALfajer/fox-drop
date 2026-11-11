import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const zone = '01900000-0000-7000-8000-0000000000e1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const zones = [{ id: zone, name: 'الشمال', active: true }];

// AP §9.12.5 «مكافأة ساعة الذروة» (D15): off until OWN turns it on; a
// window with its days, hours, amount and zones.
test('turns the peak bonus on with a window for one zone', async ({ page }) => {
  await fakeSession(page, ['zones.read', 'pricing.edit_pay_tables']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let sent: unknown = null;
  await page.route('**/v1/admin/peak-bonus*', (route) => {
    if (route.request().method() === 'PUT') {
      sent = route.request().postDataJSON();
      return route.fulfill({
        json: {
          inForce: {
            id: '01900000-0000-7000-8000-0000000000f1',
            enabled: true,
            currency: 'TRY',
            effectiveFrom: '2026-11-12T17:00:00.000Z',
            windows: [
              {
                days: [4, 5],
                startMinute: 1200,
                endMinute: 1320,
                amount: '500',
                zones: [{ id: zone, name: 'الشمال' }],
              },
            ],
          },
          pending: null,
          zones,
          baseCurrency: 'TRY',
        },
      });
    }
    return route.fulfill({ json: { inForce: null, pending: null, zones, baseCurrency: 'TRY' } });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'مكافأة ساعة الذروة' }).click();
  await expect(page.getByText('المكافأة متوقفة.')).toBeVisible();
  await page.getByLabel('تشغيل مكافأة الذروة').check();
  await page.getByRole('button', { name: 'إضافة نافذة' }).click();
  const window = page.getByRole('group', { name: 'النافذة 1' });
  await window.getByLabel('الخميس').check();
  await window.getByLabel('الجمعة').check();
  await window.getByLabel('من').fill('20:00');
  await window.getByLabel('إلى').fill('22:00');
  await window.getByLabel('المبلغ لكل طلب (TRY)').fill('5');
  await window.getByLabel('الشمال').check();
  await page.getByRole('button', { name: 'حفظ' }).click();

  await expect(page.getByRole('status')).toHaveText('حُفظت المكافأة وسرت الآن.');
  expect(sent).toEqual({
    cityId,
    enabled: true,
    windows: [{ days: [4, 5], startMinute: 1200, endMinute: 1320, amount: '500', zoneIds: [zone] }],
  });
  await expect(page.getByText('الخميس، الجمعة من 20:00 إلى 22:00')).toBeVisible();
});

test('shows the bonus without the form to a role that only reads it', async ({ page }) => {
  await fakeSession(page, ['zones.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/peak-bonus*', (route) =>
    route.fulfill({ json: { inForce: null, pending: null, zones, baseCurrency: 'TRY' } }),
  );
  await page.goto('/peak-bonus');
  await expect(page.getByText('المكافأة متوقفة.')).toBeVisible();
  await expect(page.getByRole('button', { name: 'حفظ' })).toHaveCount(0);
});
