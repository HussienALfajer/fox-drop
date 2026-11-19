import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};

function setting(key: string, type: string, value: unknown, unit: string | null = null) {
  return {
    key,
    template: key,
    parameter: null,
    group: 'dispatch',
    type,
    unit,
    scope: 'city',
    cityId,
    editRoles: ['OWN', 'OPS'],
    reasonRequired: false,
    beforeLaunch: false,
    default: value,
    value,
    isDefault: true,
  };
}

// AP §9.12.6 «قواعد التوزيع» (slice 2.37c): OPS sees and switches the mode
// only, which the server's list gives OPS alone (the session's role stays
// the helper's, so the alerts' banner does not cover the page).
test('lets operations switch the dispatch mode', async ({ page }) => {
  await fakeSession(page, ['zones.read', 'dispatch.switch_mode']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/settings?*', (route) =>
    route.fulfill({ json: { settings: [setting('dispatch.mode', 'enum', 'manual')] } }),
  );
  let sent: unknown = null;
  await page.route('**/v1/admin/settings/dispatch.mode', (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({ json: setting('dispatch.mode', 'enum', 'auto') });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'قواعد التوزيع' }).click();
  await expect(page.getByText('طريقة التوزيع: يدوي (القيمة الافتراضية)')).toBeVisible();
  await expect(page.getByText('مدة العرض على الكابتن', { exact: false })).toHaveCount(0);
  await page.getByRole('combobox', { name: 'طريقة التوزيع' }).selectOption('auto');
  await page.getByRole('button', { name: 'حفظ طريقة التوزيع' }).click();
  await expect(page.getByText('حُفظ. يسري الآن.')).toBeVisible();
  expect(sent).toEqual({ cityId, value: 'auto', reason: null });
});
