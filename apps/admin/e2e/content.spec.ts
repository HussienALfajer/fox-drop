import { expect, test, type Page } from '@playwright/test';
import { fakeSession } from './session.js';

const reasons = {
  lists: [
    {
      list: 'captain_away',
      apps: ['captain'],
      customerText: false,
      closed: false,
      fault: false,
      reasons: [
        {
          code: 'pin_inaccurate',
          label: 'موقع الزبون على الخريطة غير دقيق',
          customerText: null,
          note: 'none',
          fixed: false,
          active: true,
          captainFault: null,
        },
      ],
    },
  ],
};

const accepted = {
  key: 'customer.accepted',
  audience: 'customer',
  row: 'CU §14 #1',
  variables: ['الساعة'],
  level: 'default',
  priority: 'normal',
  text: 'المطعم يحضّر طلبك. يصل حوالي {الساعة}',
  current: 'المطعم يحضّر طلبك. يصل حوالي {الساعة}',
};

const terms = (version: number, body: string) => ({
  version,
  body,
  publishedAt: '2026-11-08T09:00:00.000Z',
});

async function fakeContent(page: Page) {
  await page.route('**/v1/admin/content/terms', (route) =>
    route.fulfill({
      json: {
        customer: terms(1, 'شروط الزبائن'),
        captain: terms(1, 'شروط الكباتن'),
        merchant: terms(1, 'شروط المطاعم'),
      },
    }),
  );
  await page.route('**/v1/admin/content/notifications', (route) =>
    route.fulfill({ json: { templates: [accepted] } }),
  );
  await page.route('**/v1/admin/content/reasons', (route) => route.fulfill({ json: reasons }));
  await page.route('**/v1/admin/content/faqs', (route) =>
    route.fulfill({ json: { customer: [], captain: [], merchant: [] } }),
  );
  await page.route('**/v1/admin/content/texts', (route) =>
    route.fulfill({ json: { workRules: 'الخوذة إلزامية', contact: {} } }),
  );
}

// AP §9.13: the owner renames a reason, which the apps then show.
test('edits a reason of a list', async ({ page }) => {
  await fakeSession(page, ['content.read', 'content.manage', 'content.faqs']);
  await fakeContent(page);
  let sent: unknown;
  await page.route('**/v1/admin/content/reasons/captain_away/pin_inaccurate', (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({ json: { ...reasons.lists[0]!.reasons[0], label: 'الدبوس بعيد' } });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'المحتوى' }).click();
  await expect(page.getByRole('heading', { name: 'وصول أو تسليم بعيد عن الدبوس' })).toBeVisible();
  await page.getByLabel('النص', { exact: true }).first().fill('الدبوس بعيد');
  await page.getByRole('button', { name: 'حفظ' }).first().click();

  await expect(page.getByRole('status').filter({ hasText: 'حُفظ' })).toBeVisible();
  expect(sent).toEqual({
    label: 'الدبوس بعيد',
    customerText: null,
    note: 'none',
    captainFault: null,
    active: true,
  });
});

// AP §6.2: operations read the content without editing it.
test('shows the content read-only without content.manage', async ({ page }) => {
  await fakeSession(page, ['content.read']);
  await fakeContent(page);
  await page.goto('/content');

  await expect(page.getByLabel('النص', { exact: true })).toHaveCount(1);
  await expect(page.getByLabel('النص', { exact: true })).toBeDisabled();
  await expect(page.getByRole('button', { name: 'إضافة سبب' })).toHaveCount(0);
});

// AP §9.13 «نصوص الإشعارات»: the owner rewrites a push's text.
test('edits a notification text', async ({ page }) => {
  await fakeSession(page, ['content.read', 'content.manage', 'content.faqs']);
  await fakeContent(page);
  let sent: unknown;
  await page.route('**/v1/admin/content/notifications/customer.accepted', (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({ json: { ...accepted, current: 'قبل المطعم طلبك، يصل {الساعة}' } });
  });
  await page.goto('/content');

  await expect(page.getByRole('heading', { name: 'نصوص الإشعارات' })).toBeVisible();
  await page.getByLabel('قبول المطعم للطلب').fill('قبل المطعم طلبك، يصل {الساعة}');
  await page
    .getByRole('group')
    .filter({ has: page.getByLabel('قبول المطعم للطلب') })
    .getByRole('button', { name: 'حفظ' })
    .click();

  await expect(page.getByRole('status').filter({ hasText: 'حُفظ' })).toBeVisible();
  expect(sent).toEqual({ text: 'قبل المطعم طلبك، يصل {الساعة}' });
});

// AP §9.13: publishing a new version of the customer terms, after a
// confirmation, since every customer accepts it again.
test('publishes a new version of the terms', async ({ page }) => {
  await fakeSession(page, ['content.read', 'content.manage', 'content.faqs']);
  await fakeContent(page);
  let sent: unknown;
  await page.route('**/v1/admin/content/terms/customer', (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({ status: 201, json: terms(2, 'الشروط الجديدة') });
  });
  await page.goto('/content');

  await expect(page.getByRole('heading', { name: 'الشروط والخصوصية' })).toBeVisible();
  await page.getByLabel('نص الشروط').first().fill('الشروط الجديدة');
  await page.getByRole('button', { name: 'نشر نسخة جديدة' }).first().click();
  await expect(page.getByRole('alert').filter({ hasText: 'تأكيد النشر؟' })).toBeVisible();
  expect(sent).toBeUndefined();
  await page.getByRole('button', { name: 'تأكيد النشر' }).click();

  await expect(page.getByRole('status').filter({ hasText: 'حُفظ' })).toBeVisible();
  expect(sent).toEqual({ body: 'الشروط الجديدة' });
});
