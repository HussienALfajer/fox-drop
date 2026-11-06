import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const permission = 'sign_in.emergency_code';

// Architecture §8.3.5 (W4).
test('issues a code for a captain and shows it once', async ({ page }) => {
  await fakeSession(page, [permission]);
  let sent: unknown;
  await page.route('**/v1/admin/emergency-sign-in-codes', (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({
      json: {
        code: '482913',
        expiresAt: '2026-11-07T08:10:00.000Z',
        accountId: '01900000-0000-7000-8000-000000000002',
      },
    });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'رمز دخول طارئ' }).click();
  await page.getByLabel('تطبيق الكابتن').check();
  await page.getByLabel('رقم الهاتف').fill('+963 912 345 678');
  await page.getByLabel('السبب').fill(' No code arrives on WhatsApp ');
  await page.getByRole('button', { name: 'إصدار الرمز' }).click();

  await expect(page.getByRole('status')).toHaveText('482913');
  expect(sent).toEqual({
    party: 'captain',
    phone: '+963912345678',
    reason: 'No code arrives on WhatsApp',
  });

  await page.getByRole('button', { name: 'إصدار رمز آخر' }).click();
  await expect(page.getByText('482913')).toHaveCount(0);
});

test('reads Arabic-Indic digits and the 00 prefix', async ({ page }) => {
  await fakeSession(page, [permission]);
  let sent: { phone?: string } = {};
  await page.route('**/v1/admin/emergency-sign-in-codes', (route) => {
    sent = route.request().postDataJSON() as { phone?: string };
    return route.fulfill({ status: 409, json: { statusCode: 409, error: 'not_registered' } });
  });
  await page.goto('/emergency-code');

  await page.getByLabel('تطبيق الكابتن').check();
  await page.getByLabel('رقم الهاتف').fill('00٩٦٣ ٩١٢-٣٤٥-٦٧٨');
  await page.getByLabel('السبب').fill('No code arrives');
  await page.getByRole('button', { name: 'إصدار الرمز' }).click();

  await expect(page.getByRole('alert')).toBeVisible();
  expect(sent.phone).toBe('+963912345678');
});

test('asks for a reason made of more than spaces', async ({ page }) => {
  await fakeSession(page, [permission]);
  await page.goto('/emergency-code');

  await page.getByLabel('تطبيق الكابتن').check();
  await page.getByLabel('رقم الهاتف').fill('+963912345678');
  await page.getByLabel('السبب').fill('   ');
  await page.getByRole('button', { name: 'إصدار الرمز' }).click();

  await expect(page.getByRole('alert')).toHaveText('اكتب سبب إصدار الرمز.');
});

test('says why a number cannot sign in', async ({ page }) => {
  await fakeSession(page, [permission]);
  await page.route('**/v1/admin/emergency-sign-in-codes', (route) =>
    route.fulfill({ status: 409, json: { statusCode: 409, error: 'not_registered' } }),
  );
  await page.goto('/emergency-code');

  await page.getByLabel('تطبيق المطعم').check();
  await page.getByLabel('رقم الهاتف').fill('+905321234567');
  await page.getByLabel('السبب').fill('No code arrives');
  await page.getByRole('button', { name: 'إصدار الرمز' }).click();

  await expect(page.getByRole('alert')).toHaveText('لا يوجد حساب بهذا الرقم في هذا التطبيق.');
});

test('is hidden and closed without the permission', async ({ page }) => {
  await fakeSession(page, []);
  await page.goto('/');
  await expect(page.getByRole('status')).toHaveText('الخادم يعمل');
  await expect(page.getByRole('link', { name: 'رمز دخول طارئ' })).toHaveCount(0);

  await page.goto('/emergency-code');
  await expect(page).toHaveURL(/\/$/);
});
