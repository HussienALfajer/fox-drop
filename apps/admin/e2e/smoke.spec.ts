import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

test('shows the Arabic home page, right to left, when signed in', async ({ page }) => {
  await fakeSession(page, []);
  await page.goto('/');

  await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
  await expect(page.locator('html')).toHaveAttribute('lang', 'ar');
  await expect(page).toHaveTitle('لوحة الإدارة');
  await expect(page.getByRole('status')).toHaveText('الخادم يعمل');
});

test('says so when the server does not answer', async ({ page }) => {
  await fakeSession(page, []);
  await page.route('**/v1/admin/status', (route) => route.fulfill({ status: 503 }));
  await page.goto('/');

  await expect(page.getByRole('status')).toHaveText('تعذّر الاتصال بالخادم', {
    // TanStack Query retries a failed request three times first.
    timeout: 15_000,
  });
});

test('says so in Arabic when the session cannot be read', async ({ page }) => {
  await page.route('**/v1/admin/auth/session', (route) => route.fulfill({ status: 503 }));
  await page.goto('/');

  await expect(page.getByRole('alert')).toHaveText('تعذّر الاتصال بالخادم', { timeout: 15_000 });
});
