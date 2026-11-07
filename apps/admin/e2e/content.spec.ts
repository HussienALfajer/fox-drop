import { expect, test, type Page } from '@playwright/test';
import { fakeSession } from './session.js';

const reasons = {
  lists: [
    {
      list: 'captain_away',
      apps: ['captain'],
      customerText: false,
      closed: false,
      reasons: [
        {
          code: 'pin_inaccurate',
          label: 'موقع الزبون على الخريطة غير دقيق',
          customerText: null,
          needsText: false,
          fixed: false,
          active: true,
        },
      ],
    },
  ],
};

async function fakeContent(page: Page) {
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
    needsText: false,
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
