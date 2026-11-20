import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const orderId = '01900000-0000-7000-8000-0000000000b1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const row = {
  id: orderId,
  number: '10042',
  placedAt: '2026-11-16T09:00:00.000Z',
  restaurantId: '01900000-0000-7000-8000-0000000000a1',
  restaurantName: 'مطعم الشام',
  neighbourhood: 'المركز',
  captainId: null,
  captainName: null,
  status: 'cancelled',
  outcome: null,
  responsible: 'customer',
  total: { amount: '16000', currency: 'TRY' },
  deliveryMinutes: null,
  code: null,
  testOrder: false,
  redelivery: false,
};

// AP §9.5 «سجل الطلبات» (slice 2.40): the filters, the phone kept out of the
// URL, the table and the export once a period is chosen.
test('filters the history by the customer’s phone without putting it in the URL', async ({
  page,
}) => {
  await fakeSession(page, ['order_history.read', 'customers.reveal_phone', 'operations.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  const bodies: Record<string, unknown>[] = [];
  await page.route('**/v1/admin/order-history', (route) => {
    const body = route.request().postDataJSON() as Record<string, unknown>;
    bodies.push(body);
    return route.fulfill({ json: { orders: body.customerPhone ? [row] : [], next: null } });
  });
  await page.goto('/order-history');
  const main = page.getByRole('main');
  await expect(main.getByText('لا طلبات بهذه الشروط.')).toBeVisible();
  await expect(main.getByText('اختر يوماً للبداية وآخر للنهاية لتصدير Excel.')).toBeVisible();

  await main.getByLabel('رقم هاتف الزبون').fill('0912345678');
  await main.getByLabel('الحالة').selectOption('cancelled');
  await main.getByRole('button', { name: 'عرض', exact: true }).click();
  await expect(main.getByRole('link', { name: '#10042' })).toBeVisible();
  await expect(main.getByRole('cell', { name: 'مطعم الشام' })).toBeVisible();
  await expect(main.getByRole('cell', { name: 'ملغى' })).toBeVisible();
  expect(page.url()).toContain('status=cancelled');
  expect(page.url()).not.toContain('0912345678');
  expect(bodies.at(-1)).toMatchObject({
    cityId,
    customerPhone: '0912345678',
    status: 'cancelled',
    kind: 'all',
    cursor: null,
  });

  await main.getByLabel('من يوم').fill('2026-11-01');
  await main.getByLabel('إلى يوم').fill('2026-11-30');
  await main.getByRole('button', { name: 'عرض', exact: true }).click();
  await expect(main.getByRole('button', { name: 'تصدير Excel' })).toBeVisible();
});

test('hides the phone filter from a role that cannot see phones', async ({ page }) => {
  await fakeSession(page, ['order_history.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/order-history', (route) =>
    route.fulfill({ json: { orders: [], next: null } }),
  );
  await page.goto('/order-history');
  const main = page.getByRole('main');
  await expect(main.getByText('لا طلبات بهذه الشروط.')).toBeVisible();
  await expect(main.getByLabel('رقم هاتف الزبون')).toHaveCount(0);
});
