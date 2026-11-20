import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const restaurantId = '01900000-0000-7000-8000-0000000000a1';

function period(from: string, placed: number, gmv: string, onTimeBp: number) {
  return {
    from,
    until: from.replace('T01:00', 'T09:30'),
    orders: {
      placed,
      delivered: placed - 2,
      inProgress: 1,
      cancelled: 1,
      rejected: 0,
      failed: 0,
      deliveryMinutes: 34.5,
      onTimeBp,
      successBp: 8000,
      firstOrders: 3,
    },
    money: {
      currency: 'TRY',
      gmv,
      itemsValue: '100000',
      deliveryFees: '10000',
      commission: '15000',
      margin: '12000',
    },
    newCustomers: 4,
  };
}

const dashboard = {
  cityId,
  day: '2026-11-20',
  lastWeekDay: '2026-11-13',
  status: {
    captains: { online: 7, available: 4, busy: 3, cashBlocked: 1 },
    restaurants: { open: 12, busy: 1, paused: 2, closed: 5, holiday: 0, suspended: 1 },
    withoutDevice: null,
  },
  today: period('2026-11-20T01:00:00.000Z', 12, '150000', 9000),
  lastWeek: period('2026-11-13T01:00:00.000Z', 10, '120000', 9250),
  tasks: [
    { key: 'menuChanges', count: 2 },
    { key: 'cashBlocked', count: 1 },
  ],
  hours: [
    { hour: '04:00', today: 0, lastWeek: 1 },
    { hour: '05:00', today: 3, lastWeek: 2 },
  ],
  topRestaurants: [{ restaurantId, name: 'مطعم الشام', orders: 6 }],
  troubledRestaurants: [{ restaurantId, name: 'مطعم الشام', rejected: 1, late: 2 }],
};

// AP §9.1 (slice 2.40): the dashboard opens first and compares today with
// the same weekday last week; the tasks link their pages.
test('opens the dashboard and compares today with last week', async ({ page }) => {
  await fakeSession(page, [
    'dashboard.read',
    'dispatch.switch_mode',
    'menus.review_change_requests',
  ]);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/settings/dispatch-mode?*', (route) =>
    route.fulfill({ json: { mode: 'manual' } }),
  );
  await page.route('**/v1/admin/emergency-stop?*', (route) =>
    route.fulfill({ json: { stop: null, defaults: null } }),
  );
  await page.route('**/v1/admin/alerts?**', (route) => route.fulfill({ json: { alerts: [] } }));
  await page.route('**/v1/admin/dashboard?*', (route) => route.fulfill({ json: dashboard }));

  await page.goto('/');
  const main = page.getByRole('main');
  await expect(main.getByRole('heading', { name: 'لوحة التحكم' })).toBeVisible();
  await expect(page).toHaveURL(/\/dashboard/);

  await expect(main.getByText('متصلون: 7')).toBeVisible();
  await expect(main.getByText('مشغولة (بلغت أقصى عدد طلبات): 1')).toBeVisible();
  await expect(main.getByText('مفتوحة بلا جهاز استقبال متصل: غير متاح بعد')).toBeVisible();
  await expect(main.getByRole('link', { name: 'تغيير طريقة التوزيع' })).toBeVisible();

  const orders = main.getByRole('row', { name: /^الطلبات/ });
  await expect(orders).toContainText('12');
  await expect(orders).toContainText('10');
  await expect(orders).toContainText('+2');
  const gmv = main.getByRole('row', { name: /إجمالي ما دفعه الزبائن/ });
  await expect(gmv).toContainText('1,500');
  await expect(gmv).toContainText('+');
  await expect(main.getByRole('row', { name: /نسبة التوصيل في الوقت/ })).toContainText('-2.5');

  await expect(main.getByText('لا توجد تنبيهات مفتوحة')).toBeVisible();
  await expect(main.getByRole('row', { name: /05:00/ })).toContainText('3');
  await expect(main.getByRole('row', { name: /مطعم الشام/ }).first()).toContainText('6');

  await main.getByRole('link', { name: 'طلبات تعديل القائمة: 2' }).click();
  await expect(page).toHaveURL(/\/menu-change-requests\?city=AZ/);
});
