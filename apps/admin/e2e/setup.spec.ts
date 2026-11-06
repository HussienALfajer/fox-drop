import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const otpauthUri = 'otpauth://totp/FOX%20DROP:owner%40example.com?secret=JBSWY3DPEHPK3PXP';
const backupCodes = Array.from({ length: 10 }, (_, index) => `code-${index}`);

// AP §5.1 item 3.
test('sets the password, enrols TOTP and shows the backup codes once', async ({ page }) => {
  await fakeSession(page, null);
  const sent: unknown[] = [];
  await page.route('**/v1/admin/auth/setup/totp', (route) => {
    sent.push(route.request().postDataJSON());
    return route.fulfill({ json: { secret: 'JBSWY3DPEHPK3PXP', otpauthUri } });
  });
  await page.route('**/v1/admin/auth/setup/complete', (route) => {
    sent.push(route.request().postDataJSON());
    return route.fulfill({ json: { backupCodes } });
  });
  await page.goto('/setup#token=the-token');

  await page.getByRole('button', { name: 'ابدأ' }).click();
  await expect(page.getByRole('img', { name: 'رمز QR لتطبيق المصادقة' })).toBeVisible();
  await expect(page.getByText('JBSWY3DPEHPK3PXP')).toBeVisible();
  await page.getByLabel('كلمة المرور', { exact: true }).fill('a long password');
  await page.getByLabel('أعد كتابة كلمة المرور').fill('a long password');
  await page.getByLabel('الرمز من تطبيق المصادقة').fill('123456');
  await page.getByRole('button', { name: 'إكمال الإعداد' }).click();

  await expect(page.getByRole('heading', { name: 'الرموز الاحتياطية' })).toBeVisible();
  await expect(page.getByRole('listitem')).toHaveText(backupCodes);
  expect(sent).toEqual([
    { token: 'the-token' },
    { token: 'the-token', password: 'a long password', code: '123456' },
  ]);
  await page.getByRole('link', { name: 'انتقل إلى تسجيل الدخول' }).click();
  await expect(page).toHaveURL(/\/sign-in$/);
});

test('names the minimum length of a short password', async ({ page }) => {
  await page.route('**/v1/admin/auth/setup/totp', (route) =>
    route.fulfill({ json: { secret: 'JBSWY3DPEHPK3PXP', otpauthUri } }),
  );
  await page.route('**/v1/admin/auth/setup/complete', (route) =>
    route.fulfill({
      status: 400,
      json: { statusCode: 400, error: 'password_too_short', passwordMinLength: 10 },
    }),
  );
  await page.goto('/setup#token=the-token');

  await page.getByRole('button', { name: 'ابدأ' }).click();
  await page.getByLabel('كلمة المرور', { exact: true }).fill('short');
  await page.getByLabel('أعد كتابة كلمة المرور').fill('short');
  await page.getByLabel('الرمز من تطبيق المصادقة').fill('123456');
  await page.getByRole('button', { name: 'إكمال الإعداد' }).click();

  await expect(page.getByRole('alert')).toHaveText('كلمة المرور قصيرة: 10 أحرف على الأقل.');
});

test('refuses two different passwords before asking the server', async ({ page }) => {
  let completed = false;
  await page.route('**/v1/admin/auth/setup/totp', (route) =>
    route.fulfill({ json: { secret: 'JBSWY3DPEHPK3PXP', otpauthUri } }),
  );
  await page.route('**/v1/admin/auth/setup/complete', (route) => {
    completed = true;
    return route.fulfill({ json: { backupCodes } });
  });
  await page.goto('/setup#token=the-token');

  await page.getByRole('button', { name: 'ابدأ' }).click();
  await page.getByLabel('كلمة المرور', { exact: true }).fill('a long password');
  await page.getByLabel('أعد كتابة كلمة المرور').fill('a long passw0rd');
  await page.getByLabel('الرمز من تطبيق المصادقة').fill('123456');
  await page.getByRole('button', { name: 'إكمال الإعداد' }).click();

  await expect(page.getByRole('alert')).toHaveText('كلمتا المرور غير متطابقتين.');
  expect(completed).toBe(false);
});

test('offers to start again when the enrolment is gone', async ({ page }) => {
  let offers = 0;
  await page.route('**/v1/admin/auth/setup/totp', (route) => {
    offers += 1;
    return route.fulfill({ json: { secret: 'JBSWY3DPEHPK3PXP', otpauthUri } });
  });
  await page.route('**/v1/admin/auth/setup/complete', (route) =>
    route.fulfill({ status: 400, json: { statusCode: 400, error: 'enrolment_not_started' } }),
  );
  await page.goto('/setup#token=the-token');

  await page.getByRole('button', { name: 'ابدأ' }).click();
  await page.getByLabel('كلمة المرور', { exact: true }).fill('a long password');
  await page.getByLabel('أعد كتابة كلمة المرور').fill('a long password');
  await page.getByLabel('الرمز من تطبيق المصادقة').fill('123456');
  await page.getByRole('button', { name: 'إكمال الإعداد' }).click();
  await expect(page.getByRole('alert')).toHaveText('ابدأ الإعداد من جديد لعرض رمز QR.');

  await page.getByRole('button', { name: 'ابدأ' }).click();
  await expect(page.getByRole('img', { name: 'رمز QR لتطبيق المصادقة' })).toBeVisible();
  expect(offers).toBe(2);
});

test('refuses a used or expired link', async ({ page }) => {
  await page.route('**/v1/admin/auth/setup/totp', (route) =>
    route.fulfill({ status: 400, json: { statusCode: 400, error: 'link_invalid' } }),
  );
  await page.goto('/setup#token=used');

  await page.getByRole('button', { name: 'ابدأ' }).click();

  await expect(page.getByRole('alert')).toHaveText(
    'رابط الإعداد غير صالح أو منتهي. اطلب رابطًا جديدًا من المالك.',
  );
});

test('refuses a link without a token', async ({ page }) => {
  await page.goto('/setup');

  await expect(page.getByRole('alert')).toHaveText(
    'رابط الإعداد غير صالح أو منتهي. اطلب رابطًا جديدًا من المالك.',
  );
});
