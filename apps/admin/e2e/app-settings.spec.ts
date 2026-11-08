import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';

const setting = (key: string, value: unknown) => ({
  key,
  template: key.replace(/^app\.\w+\./, 'app.<app>.'),
  parameter: key.split('.')[1],
  group: 'apps',
  type: 'text',
  unit: null,
  scope: 'global',
  cityId: null,
  editRoles: ['OWN'],
  reasonRequired: false,
  beforeLaunch: false,
  default: null,
  value,
  isDefault: value === null,
});

// AP §9.14 «التطبيقات»: OWN sets an app's minimum version and maintenance.
test("saves an app's minimum version and maintenance", async ({ page }) => {
  await fakeSession(page, ['settings.read', 'settings.manage']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  const settings = ['customer', 'merchant', 'captain'].flatMap((app) => [
    setting(`app.${app}.min_version`, null),
    setting(`app.${app}.latest_version`, null),
    setting(`app.${app}.update_message`, null),
    setting(`app.${app}.maintenance`, { enabled: false, message: null }),
  ]);
  await page.route('**/v1/admin/settings?*', (route) => route.fulfill({ json: { settings } }));
  const sent: Record<string, unknown> = {};
  await page.route('**/v1/admin/settings/app.captain.*', (route) => {
    const key = new URL(route.request().url()).pathname.split('/').at(-1)!;
    sent[key] = route.request().postDataJSON();
    return route.fulfill({ json: setting(key, sent[key]) });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'التطبيقات' }).click();
  const captain = page.getByRole('region', { name: 'تطبيق الكابتن' });
  await captain.getByLabel('الإصدار الأدنى').fill('1.4.0');
  await captain.getByLabel('وضع الصيانة').check();
  await captain.getByRole('button', { name: 'حفظ' }).click();

  await expect(captain.getByRole('status')).toHaveText('حُفظ');
  expect(sent).toEqual({
    'app.captain.min_version': { value: '1.4.0', reason: null },
    'app.captain.maintenance': { value: { enabled: true, message: null }, reason: null },
  });
});
