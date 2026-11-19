import { expect, type Page, test } from '@playwright/test';
import { fakeSession } from './session.js';

const az = {
  id: '01900000-0000-7000-8000-0000000000c1',
  code: 'AZ',
  name: 'أعزاز',
  timeZone: 'Asia/Damascus',
};
const mr = {
  id: '01900000-0000-7000-8000-0000000000c2',
  code: 'MR',
  name: 'مارع',
  timeZone: 'Asia/Damascus',
};
const orderId = '01900000-0000-7000-8000-0000000000d1';
const customerId = '01900000-0000-7000-8000-0000000000d2';

async function fakeTopBar(page: Page) {
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: { cities: [az, mr] } }));
  await page.route('**/v1/admin/settings/dispatch-mode?*', (route) => {
    const city = new URL(route.request().url()).searchParams.get('cityId');
    return route.fulfill({ json: { mode: city === mr.id ? 'mixed' : 'manual' } });
  });
  await page.route('**/v1/admin/emergency-stop?*', (route) =>
    route.fulfill({ json: { stop: null, defaults: null } }),
  );
}

// AP §7.1–7.2 (slice 2.38b): an OPS user's menu leaves Finance out, the
// city chosen in the top bar stays from page to page, and the search finds
// an order by number and a customer by phone, masked.
test("shows an OPS user's menu without Finance, keeps the city and searches", async ({ page }) => {
  await fakeSession(page, [
    'operations.read',
    'customers.read',
    'customers.reveal_phone',
    'zones.read',
    'support.read',
  ]);
  await fakeTopBar(page);
  const searched: unknown[] = [];
  await page.route('**/v1/admin/search', (route) => {
    searched.push(route.request().postDataJSON());
    return route.fulfill({
      json: {
        orders: [{ id: orderId, number: '10001', status: 'accepted' }],
        restaurants: [],
        captains: [],
        tickets: [],
        customers: [{ id: customerId, name: 'أحمد', maskedPhone: '+963 ••• 456' }],
      },
    });
  });
  await page.goto('/');

  const menu = page.getByRole('navigation', { name: 'القائمة الرئيسية' });
  // No «المالية», no «فريق الإدارة»: only the modules the roles allow.
  await expect(menu.locator('summary')).toHaveText([
    'غرفة العمليات',
    'الزبائن',
    'الدعم',
    'المناطق والتسعير',
  ]);
  await expect(page.getByText('حسابي (إدخال البيانات)')).toBeVisible();
  await expect(page.getByText('المنصة تعمل')).toBeVisible();
  await expect(page.getByText('طريقة التوزيع: يدوي')).toBeVisible();

  // The city selector: its choice stays in the address from page to page.
  await page.getByLabel('المدينة').selectOption('MR');
  await expect(page).toHaveURL(/city=MR/);
  await expect(page.getByText('طريقة التوزيع: مختلط')).toBeVisible();
  await page.route('**/v1/admin/cities/*/zones*', (route) =>
    route.fulfill({ json: { zones: [], votes: { total: 0, cells: [] } } }),
  );
  await menu.getByRole('link', { name: 'مناطق الخدمة' }).click();
  await expect(page).toHaveURL(/\/zones\?city=MR$/);
  await expect(page.getByLabel('المدينة')).toHaveValue('MR');

  // The search, in the chosen city.
  await page.getByRole('searchbox', { name: 'بحث' }).fill('0944000456');
  await page.getByRole('button', { name: 'ابحث' }).click();
  const results = page.getByRole('list', { name: 'نتائج البحث' });
  await expect(results.getByRole('link', { name: 'طلب #10001 (قيد التحضير)' })).toHaveAttribute(
    'href',
    `/orders/${orderId}?city=MR`,
  );
  await expect(results.getByRole('link', { name: 'زبون: أحمد +963 ••• 456' })).toBeVisible();
  expect(searched).toEqual([{ cityId: mr.id, q: '0944000456' }]);
});

test('shows the owner the approvals badge and every module', async ({ page }) => {
  await fakeSession(page, [
    'operations.read',
    'finance.read',
    'cash_desk.record',
    'admin_team.manage',
    'audit_log.read',
    'settings.read',
    'compensation.approve_above_cap',
  ]);
  await fakeTopBar(page);
  await page.route('**/v1/admin/compensations?*', (route) =>
    route.fulfill({ json: { requests: [] } }),
  );
  await page.goto('/');
  const menu = page.getByRole('navigation', { name: 'القائمة الرئيسية' });
  for (const module of ['المالية', 'فريق الإدارة', 'سجل التدقيق', 'الإعدادات']) {
    await expect(menu.getByText(module, { exact: true }).first()).toBeVisible();
  }
  await expect(page.getByRole('link', { name: /طلبات الموافقة/ })).toBeVisible();
  // Off the start page only the page's own module stays open.
  await menu.getByRole('link', { name: 'فريق الإدارة' }).click();
  await expect(menu.getByRole('link', { name: 'الصندوق' })).toBeHidden();
});
