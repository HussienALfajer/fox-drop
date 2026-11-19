import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const restaurantId = '01900000-0000-7000-8000-0000000000d1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const flat = {
  rule: {
    id: '01900000-0000-7000-8000-0000000000f1',
    kind: 'flat',
    flatFee: '4000',
    currency: 'TRY',
    minimumFee: null,
    freeDeliveryFrom: null,
  },
  editorName: null,
  reason: null,
  createdAt: '2026-11-01T08:00:00.000Z',
};
const banded = {
  rule: {
    id: '01900000-0000-7000-8000-0000000000f2',
    kind: 'distance_bands',
    bands: [
      { upToMetres: 2000, fee: '3000' },
      { upToMetres: null, fee: '5000' },
    ],
    currency: 'TRY',
    minimumFee: null,
    freeDeliveryFrom: '50000',
  },
  editorName: 'المالك',
  reason: 'شرائح الإطلاق',
  createdAt: '2026-11-19T08:00:00.000Z',
};
const screen = (versions: object[]) => ({
  baseCurrency: 'TRY',
  distanceMethod: 'road',
  versions,
  restaurants: [
    {
      id: restaurantId,
      nameAr: 'مطعم الشام',
      location: { latitude: 36.587, longitude: 37.046 },
      ownRule: null,
    },
  ],
});

// AP §9.12.3: the owner changes the city's fee to distance bands and
// previews a restaurant's fee at a point (the roadmap's 2.37 acceptance).
test('changes the fee to distance bands and previews it', async ({ page }) => {
  await fakeSession(page, ['zones.read', 'pricing.edit_pay_tables']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let sent: unknown = null;
  await page.route('**/v1/admin/delivery-fees?*', (route) =>
    route.fulfill({ json: screen([flat]) }),
  );
  await page.route('**/v1/admin/delivery-fees', (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({ json: screen([banded, flat]) });
  });
  let asked = '';
  await page.route('**/v1/admin/delivery-fees/preview?*', (route) => {
    asked = route.request().url();
    return route.fulfill({
      json: {
        fee: '3000',
        currency: 'TRY',
        free: false,
        scope: 'city',
        ruleId: banded.rule.id,
        freeDeliveryFrom: '50000',
        distance: { metres: 1400, method: 'road' },
        covers: true,
        zoneName: 'المركز',
      },
    });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'رسوم التوصيل' }).click();
  await expect(page.getByText(/رسم ثابت: .*40\.00/).first()).toBeVisible();
  await page.getByLabel('شرائح مسافة').check();
  const first = page.getByRole('group', { name: 'الشريحة 1' });
  await first.getByLabel('حتى (كم)').fill('2');
  await first.getByLabel('الرسم (TRY)').fill('30');
  await page.getByRole('group', { name: 'الشريحة 2' }).getByLabel('الرسم (TRY)').fill('50');
  await page.getByLabel('توصيل مجاني ابتداءً من قيمة أصناف (TRY)').fill('500');
  await page.getByLabel('السبب (اختياري)').first().fill('شرائح الإطلاق');
  await page.getByRole('button', { name: 'حفظ الرسوم' }).click();

  await expect(page.getByText('حُفظت الرسوم وسرت على الطلبات الجديدة.')).toBeVisible();
  expect(sent).toEqual({
    cityId,
    rule: {
      kind: 'distance_bands',
      currency: 'TRY',
      bands: [
        { upToMetres: 2000, fee: '3000' },
        { upToMetres: null, fee: '5000' },
      ],
      minimumFee: null,
      freeDeliveryFrom: '50000',
    },
    reason: 'شرائح الإطلاق',
  });

  const calculator = page.getByRole('region', { name: 'حاسبة المعاينة' });
  await calculator.getByLabel('المطعم').selectOption({ label: 'مطعم الشام' });
  await calculator.getByLabel('خط العرض').fill('36.59');
  await calculator.getByLabel('خط الطول').fill('37.046');
  await calculator.getByRole('button', { name: 'احسب الرسوم' }).click();
  const result = page.getByRole('list', { name: 'نتيجة المعاينة' });
  await expect(result).toContainText(/يدفع الزبون: .*30\.00/);
  await expect(result).toContainText('بحسب رسوم المدينة');
  await expect(result).toContainText('المنطقة: المركز');
  expect(asked).toContain(`restaurantId=${restaurantId}`);
  expect(asked).toContain('latitude=36.59');
  expect(asked).toContain('itemsValue=0');
});

test('shows the fees and the calculator without the forms to a reader', async ({ page }) => {
  await fakeSession(page, ['zones.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/delivery-fees?*', (route) =>
    route.fulfill({ json: screen([flat]) }),
  );
  await page.goto('/delivery-fees');
  await expect(page.getByRole('heading', { name: 'الرسوم السارية الآن' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'حفظ الرسوم' })).toHaveCount(0);
  await expect(page.getByRole('heading', { name: 'حاسبة المعاينة' })).toBeVisible();
});
