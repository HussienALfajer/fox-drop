import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const editor = '01900000-0000-7000-8000-0000000000f1';

function board(numerator: string, denominator: string, stale: boolean) {
  return {
    baseCurrency: 'TRY',
    staleAlertHours: 24,
    largeChangePct: 10,
    currencies: [
      {
        currency: 'TRY',
        nameAr: 'ليرة تركية',
        symbol: '₺',
        decimals: 2,
        displayOrder: 1,
        enabled: true,
        isBase: true,
        rate: null,
        stale: false,
        roundingUnitMinor: '500',
        roundingMode: 'nearest',
      },
      {
        currency: 'USD',
        nameAr: 'دولار أمريكي',
        symbol: '$',
        decimals: 2,
        displayOrder: 2,
        enabled: true,
        isBase: false,
        rate: {
          versionId: '7',
          baseCurrency: 'TRY',
          numerator,
          denominator,
          editorId: editor,
          editorName: 'سارة',
          reason: null,
          setAt: '2026-11-15T06:00:00.000Z',
        },
        stale,
        roundingUnitMinor: '50',
        roundingMode: 'nearest',
      },
    ],
  };
}

// AP §9.10.4, §8.6: FIN sees the dollar's rate is stale, enters a new one
// more than 10% away, and confirms it a second time.
test('edits a rate with the large-change confirmation', async ({ page }) => {
  await fakeSession(page, ['finance.read', 'fx.edit_rates']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  const sent: { value: string; confirmLargeChange: boolean }[] = [];
  await page.route('**/v1/admin/exchange-rates*', (route) => {
    if (route.request().method() !== 'PUT') {
      return route.fulfill({ json: board('206', '5', true) });
    }
    const body = route.request().postDataJSON();
    sent.push(body);
    if (!body.confirmLargeChange) {
      return route.fulfill({
        status: 409,
        json: { statusCode: 409, error: 'large_change_unconfirmed' },
      });
    }
    return route.fulfill({ json: board('50', '1', false) });
  });

  await page.goto('/exchange-rates');
  await expect(page.getByRole('heading', { name: 'أسعار الصرف' })).toBeVisible();
  await expect(page.getByText('1 USD = 41.2 TRY')).toBeVisible();
  await expect(page.getByText('سعر قديم')).toBeVisible();

  const usd = page.locator('section', { hasText: 'دولار أمريكي' });
  await usd.getByLabel('القيمة').fill('50');
  await usd.getByRole('button', { name: 'حفظ السعر' }).click();
  await expect(usd.getByText('التغيير أكبر من 10%')).toBeVisible();
  await usd.getByRole('button', { name: 'تأكيد التغيير' }).click();
  await expect(page.getByText('1 USD = 50 TRY')).toBeVisible();
  expect(sent.map((body) => [body.value, body.confirmLargeChange])).toEqual([
    ['50', false],
    ['50', true],
  ]);
});
