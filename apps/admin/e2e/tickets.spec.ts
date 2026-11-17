import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const restaurantId = '01900000-0000-7000-8000-0000000000a1';

function ticket(overrides: Record<string, unknown> = {}) {
  const now = Date.now();
  return {
    id: '01900000-0000-7000-8000-0000000000f1',
    number: '17',
    source: 'manual',
    party: 'restaurant',
    partyId: restaurantId,
    partyName: 'مطعم الساحة',
    orderId: null,
    orderNumber: null,
    urgent: false,
    typeCode: 'finance_inquiry',
    typeLabel: 'استفسار مالي',
    description: 'يسأل عن الكشف',
    status: 'new',
    assigneeId: null,
    assigneeName: null,
    sla: {
      kind: 'resolution',
      startedAt: new Date(now).toISOString(),
      dueAt: new Date(now + 24 * 3_600_000).toISOString(),
      stoppedAt: null,
    },
    openedByName: 'ليلى',
    openedAt: new Date(now).toISOString(),
    updatedAt: new Date(now).toISOString(),
    ...overrides,
  };
}

// AP §9.9.1–9.9.2 (slice 2.23a): support opens «تذكرة يدوية» on a restaurant
// found by name, and the list shows it with its number, type and timer.
test('opens a manual ticket on a restaurant and lists it', async ({ page }) => {
  await fakeSession(page, ['support.read', 'support.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/tickets/types', (route) =>
    route.fulfill({
      json: {
        customer: [{ code: 'missing_item', label: 'صنف ناقص' }],
        restaurant: [{ code: 'finance_inquiry', label: 'استفسار مالي' }],
        captain: [{ code: 'order_problem', label: 'مشكلة في طلب' }],
      },
    }),
  );
  await page.route('**/v1/admin/tickets/assignees', (route) =>
    route.fulfill({ json: { assignees: [] } }),
  );
  await page.route('**/v1/admin/tickets/parties/search', (route) =>
    route.fulfill({ json: { parties: [{ id: restaurantId, name: 'مطعم الساحة' }] } }),
  );
  let opened: unknown = null;
  let listed: unknown[] = [];
  await page.route('**/v1/admin/tickets?**', (route) =>
    route.fulfill({ json: { tickets: listed } }),
  );
  await page.route('**/v1/admin/tickets', (route) => {
    opened = route.request().postDataJSON();
    expect(route.request().headers()['idempotency-key']).toBeTruthy();
    listed = [ticket()];
    return route.fulfill({ json: ticket() });
  });
  await page.route('**/v1/admin/alerts**', (route) => route.fulfill({ json: { alerts: [] } }));

  await page.goto('/');
  await page.getByRole('link', { name: 'الدعم' }).click();
  await expect(page.getByText('لا تذاكر هنا.')).toBeVisible();
  const select = (name: string) => page.getByRole('combobox', { name, exact: true }).first();
  await select('الطرف').selectOption('restaurant');
  await page.getByLabel('الاسم أو الرقم').fill('الساحة');
  await page.getByRole('button', { name: 'بحث' }).click();
  await select('اختر').selectOption(restaurantId);
  await select('النوع').selectOption('finance_inquiry');
  await page.getByLabel('ما قاله الطرف').fill('يسأل عن الكشف');
  await page.getByRole('button', { name: 'فتح التذكرة' }).click();

  await expect(page.getByRole('status')).toContainText('فُتحت التذكرة');
  expect(opened).toEqual({
    cityId,
    party: 'restaurant',
    partyId: restaurantId,
    typeCode: 'finance_inquiry',
    description: 'يسأل عن الكشف',
  });
  await expect(page.getByRole('cell', { name: 'استفسار مالي' })).toBeVisible();
  await expect(page.getByText('مطعم: مطعم الساحة').last()).toBeVisible();
  await expect(page.getByText('الحل ضمن المهلة', { exact: false }).first()).toBeVisible();
});
