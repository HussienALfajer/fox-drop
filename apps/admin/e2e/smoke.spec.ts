import { expect, test } from '@playwright/test';

test('shows the Arabic status page, right to left', async ({ page }) => {
  await page.route('**/v1/admin/status', (route) =>
    route.fulfill({ json: { status: 'ok', serverTime: Date.now() } }),
  );
  await page.goto('/');

  await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
  await expect(page.locator('html')).toHaveAttribute('lang', 'ar');
  await expect(page).toHaveTitle('لوحة الإدارة');
  await expect(page.getByRole('status')).toHaveText('الخادم يعمل');
});

test('says so when the server does not answer', async ({ page }) => {
  await page.route('**/v1/admin/status', (route) => route.fulfill({ status: 503 }));
  await page.goto('/');

  await expect(page.getByRole('status')).toHaveText('تعذّر الاتصال بالخادم', {
    // TanStack Query retries a failed request three times first.
    timeout: 15_000,
  });
});
