import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const centre = {
  id: '01900000-0000-7000-8000-0000000000d1',
  name: 'المركز',
  active: true,
  area: [
    { latitude: 36.58, longitude: 37.04 },
    { latitude: 36.58, longitude: 37.05 },
    { latitude: 36.59, longitude: 37.05 },
  ],
};
const votes = [{ latitude: 36.61, longitude: 37.07, votes: 3 }];

// AP §9.12.2 «مناطق الخدمة» (slice 2.37c): OWN draws a neighbourhood by its
// corners (typed here: the smoke tests have no map), names it and activates
// it; the votes from outside the zones are listed.
test('draws a neighbourhood, names it and activates it', async ({ page }) => {
  await fakeSession(page, ['zones.read', 'zones.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route(`**/v1/admin/cities/${cityId}/zones`, (route) =>
    route.fulfill({ json: { zones: [centre], votes } }),
  );
  const sent: { url: string; body: unknown }[] = [];
  await page.route(`**/v1/admin/cities/${cityId}/zones/*`, (route) => {
    const body = route.request().postDataJSON() as { name: string; area: unknown; active: boolean };
    sent.push({ url: route.request().url(), body });
    if (sent.length === 1) {
      return route.fulfill({
        status: 409,
        json: { statusCode: 409, error: 'zones_overlap' },
      });
    }
    const id = route.request().url().split('/').pop()!;
    return route.fulfill({ json: { zones: [centre, { id, ...body }], votes } });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'مناطق الخدمة' }).click();
  await expect(page.getByText('المركز (نشطة، 3 نقاط)')).toBeVisible();
  await expect(page.getByText('36.61، 37.07: 3 أصوات')).toBeVisible();
  await page.getByRole('button', { name: 'رسم منطقة جديدة' }).click();
  await page.getByLabel('اسم الحي').fill('الحي الشمالي');
  await page
    .getByLabel('نقاط الحدود (خط العرض، خط الطول في كل سطر)')
    .fill('36.6, 37.04\n36.6, 37.05\n36.61, 37.05');
  await page.getByLabel('منطقة نشطة').check();
  await page.getByRole('button', { name: 'حفظ المنطقة' }).click();
  await expect(page.getByRole('alert')).toHaveText(
    'المنطقة تتداخل مع منطقة نشطة. اجعلها غير نشطة أو عدّل حدودها.',
  );

  await page.getByRole('button', { name: 'حفظ المنطقة' }).click();
  await expect(page.getByText('الحي الشمالي (نشطة، 3 نقاط)')).toBeVisible();
  expect(sent[1]!.body).toEqual({
    name: 'الحي الشمالي',
    area: [
      { latitude: 36.6, longitude: 37.04 },
      { latitude: 36.6, longitude: 37.05 },
      { latitude: 36.61, longitude: 37.05 },
    ],
    active: true,
    reason: null,
  });
  // Saved again under the same id the panel chose.
  expect(sent[1]!.url).toBe(sent[0]!.url);
});

test('shows the zones without editing to a role that only reads them', async ({ page }) => {
  await fakeSession(page, ['zones.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route(`**/v1/admin/cities/${cityId}/zones`, (route) =>
    route.fulfill({ json: { zones: [centre], votes: [] } }),
  );
  await page.goto('/zones');
  await expect(page.getByText('المركز (نشطة، 3 نقاط)')).toBeVisible();
  await expect(page.getByText('لا تصويتات بعد.')).toBeVisible();
  await expect(page.getByRole('button', { name: 'رسم منطقة جديدة' })).toHaveCount(0);
});
