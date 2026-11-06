import { expect, test } from '@playwright/test';
import { fakeSession, sessionBody } from './session.js';

// AP §5.1–5.2.
test('opens the sign-in page without a session', async ({ page }) => {
  await fakeSession(page, null);
  await page.goto('/');

  await expect(page).toHaveURL(/\/sign-in$/);
  await expect(page.getByRole('heading', { name: 'تسجيل الدخول' })).toBeVisible();
});

test('signs in with the password and the TOTP code', async ({ page }) => {
  await fakeSession(page, null);
  let sent: unknown;
  await page.route('**/v1/admin/auth/sign-in', (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({ json: sessionBody() });
  });
  await page.goto('/sign-in');

  await page.getByLabel('البريد الإلكتروني أو رقم الهاتف').fill(' owner@example.com ');
  await page.getByLabel('كلمة المرور').fill('a long password');
  await page.getByLabel('رمز التحقق أو رمز احتياطي').fill('123456');
  await page.getByRole('button', { name: 'دخول' }).click();

  await expect(page).toHaveURL(/\/$/);
  await expect(page.getByRole('status')).toHaveText('الخادم يعمل');
  expect(sent).toEqual({ login: 'owner@example.com', password: 'a long password', code: '123456' });
});

test('gives one answer for every refused sign-in', async ({ page }) => {
  await fakeSession(page, null);
  await page.route('**/v1/admin/auth/sign-in', (route) =>
    route.fulfill({ status: 401, json: { statusCode: 401 } }),
  );
  await page.goto('/sign-in');

  await page.getByLabel('البريد الإلكتروني أو رقم الهاتف').fill('owner@example.com');
  await page.getByLabel('كلمة المرور').fill('wrong password');
  await page.getByLabel('رمز التحقق أو رمز احتياطي').fill('000000');
  await page.getByRole('button', { name: 'دخول' }).click();

  await expect(page.getByRole('alert')).toHaveText(
    'بيانات الدخول غير صحيحة، أو الحساب مقفل مؤقتًا.',
  );
  await expect(page).toHaveURL(/\/sign-in$/);
});

test('signs out', async ({ page }) => {
  await fakeSession(page, []);
  await page.route('**/v1/admin/auth/sign-out', (route) =>
    route.fulfill({ json: { status: 'signed_out' } }),
  );
  await page.goto('/');

  await page.getByRole('button', { name: 'تسجيل الخروج' }).click();

  await expect(page).toHaveURL(/\/sign-in$/);
});

test('forgets the cached answers on sign-out', async ({ page }) => {
  await fakeSession(page, []);
  let statusReads = 0;
  await page.route('**/v1/admin/status', (route) => {
    statusReads += 1;
    return route.fulfill({ json: { status: 'ok', serverTime: Date.now() } });
  });
  await page.route('**/v1/admin/auth/sign-out', (route) =>
    route.fulfill({ json: { status: 'signed_out' } }),
  );
  await page.route('**/v1/admin/auth/sign-in', (route) => route.fulfill({ json: sessionBody() }));
  await page.goto('/');
  await expect(page.getByRole('status')).toHaveText('الخادم يعمل');

  await page.getByRole('button', { name: 'تسجيل الخروج' }).click();
  await page.getByLabel('البريد الإلكتروني أو رقم الهاتف').fill('next@example.com');
  await page.getByLabel('كلمة المرور').fill('a long password');
  await page.getByLabel('رمز التحقق أو رمز احتياطي').fill('123456');
  await page.getByRole('button', { name: 'دخول' }).click();

  await expect(page.getByRole('status')).toHaveText('الخادم يعمل');
  expect(statusReads).toBe(2);
});

test('returns to the sign-in page when the session ends', async ({ page }) => {
  await fakeSession(page, ['sign_in.emergency_code']);
  await page.route('**/v1/admin/emergency-sign-in-codes', (route) =>
    route.fulfill({ status: 401, json: { statusCode: 401 } }),
  );
  await page.goto('/emergency-code');

  await page.getByLabel('تطبيق الكابتن').check();
  await page.getByLabel('رقم الهاتف').fill('+963912345678');
  await page.getByLabel('السبب').fill('No code arrives');
  await page.getByRole('button', { name: 'إصدار الرمز' }).click();

  await expect(page).toHaveURL(/\/sign-in$/);
});
