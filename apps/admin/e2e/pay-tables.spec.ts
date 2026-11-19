import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const vehicles = ['walking', 'bicycle', 'motorbike', 'car'] as const;
const rates = (basePay: string) =>
  vehicles.map((vehicle) => ({
    vehicle,
    basePay,
    includedMetres: 3000,
    perExtraKm: '500',
    waitingPerMinute: '0',
    minimumPay: '2500',
  }));
const inForce = {
  id: '01900000-0000-7000-8000-0000000000f1',
  state: 'in_force',
  currency: 'TRY',
  effectiveFrom: '2026-11-01T08:00:00.000Z',
  rates: rates('2500'),
  editorName: null,
  reason: null,
  createdAt: '2026-11-01T08:00:00.000Z',
};
const earliestStart = new Date(Date.now() + 7 * 86_400_000).toISOString();
const screen = (versions: object[]) => ({
  baseCurrency: 'TRY',
  waitingThresholdMin: 10,
  noticeDays: 7,
  earliestStart,
  maxDistanceKm: [
    { vehicle: 'walking', km: 1.5 },
    { vehicle: 'bicycle', km: 4 },
    { vehicle: 'motorbike', km: 10 },
    { vehicle: 'car', km: 15 },
  ],
  versions,
});
const money = (amount: string) => ({ amount, currency: 'TRY' });

// AP §9.12.5: the owner publishes a new pay table 7 days ahead and previews
// a sample trip by it (the roadmap's 2.37b acceptance).
test('publishes a new pay table and previews a trip by it', async ({ page }) => {
  await fakeSession(page, ['zones.read', 'pricing.edit_pay_tables']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let sent: { effectiveFrom: string; rates: { basePay: string }[] } | null = null;
  await page.route('**/v1/admin/pay-tables?*', (route) =>
    route.fulfill({ json: screen([inForce]) }),
  );
  await page.route('**/v1/admin/pay-tables', (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({
      json: screen([
        {
          ...inForce,
          id: '01900000-0000-7000-8000-0000000000f2',
          state: 'announced',
          effectiveFrom: sent!.effectiveFrom,
          rates: rates('3000'),
          editorName: 'المالك',
          reason: 'رفع الأجر',
          createdAt: new Date().toISOString(),
        },
        inForce,
      ]),
    });
  });
  let asked = '';
  await page.route('**/v1/admin/pay-tables/preview?*', (route) => {
    asked = route.request().url();
    const parts = { base: money('3000'), distance: money('1000'), topUp: money('0') };
    return route.fulfill({
      json: {
        waitingThresholdMin: 10,
        inForce: {
          effectiveFrom: inForce.effectiveFrom,
          base: money('2500'),
          distance: money('1000'),
          topUp: money('0'),
          orderPay: money('3500'),
          waiting: money('0'),
          total: money('3500'),
        },
        announced: [],
        draft: { ...parts, orderPay: money('4000'), waiting: money('0'), total: money('4000') },
      },
    });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'أجور الكباتن' }).click();
  await expect(page.getByRole('link', { name: 'مكافأة ساعة الذروة' })).toBeVisible();
  await expect(page.getByText(/يشمل أول 3 كم/).first()).toBeVisible();
  for (const vehicle of ['مشياً', 'دراجة هوائية أو كهربائية', 'دراجة نارية', 'سيارة']) {
    await page.getByRole('group', { name: vehicle }).getByLabel('الأجر الأساسي (TRY)').fill('30');
  }
  await page.getByRole('button', { name: 'جرّب دراجة نارية في الحاسبة' }).click();
  await page.getByLabel('السبب', { exact: true }).fill('رفع الأجر');
  await page.getByRole('button', { name: 'نشر الجدول' }).click();

  await expect(page.getByText(/نُشر الجدول ويبدأ في /)).toBeVisible();
  expect(sent!.rates.map((rate) => rate.basePay)).toEqual(['3000', '3000', '3000', '3000']);
  expect(new Date(sent!.effectiveFrom).getTime()).toBeGreaterThan(
    new Date(earliestStart).getTime(),
  );
  await expect(page.getByText(/^معلن يبدأ في .* بواسطة المالك/)).toBeVisible();

  await page.getByLabel('مسافة الرحلة (كم)').fill('5');
  await page.getByRole('button', { name: 'احسب الأجر' }).click();
  await expect(page.getByText(/المجموع: .*35\.00/)).toBeVisible();
  await expect(page.getByText(/المجموع: .*40\.00/)).toBeVisible();
  expect(asked).toContain('vehicle=motorbike');
  expect(asked).toContain('metres=5000');
  expect(asked).toContain('draftBasePay=3000');
});

// OPS reads the table and the calculator, without the forms.
test('shows operations the table without the forms', async ({ page }) => {
  await fakeSession(page, ['zones.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/pay-tables?*', (route) =>
    route.fulfill({ json: screen([inForce]) }),
  );
  await page.goto('/pay-tables');
  await expect(page.getByRole('heading', { name: 'الجدول الساري' })).toBeVisible();
  await expect(page.getByText(/دراجة نارية: 10 كم/)).toBeVisible();
  await expect(page.getByRole('button', { name: 'نشر الجدول' })).toHaveCount(0);
  await expect(page.getByRole('button', { name: 'احسب الأجر' })).toBeVisible();
});
