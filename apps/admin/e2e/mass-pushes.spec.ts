import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const pushId = '01900000-0000-7000-8000-0000000000p1';
const answer = (pushes: object[], canManage = true) => ({
  pushes,
  restaurants: [{ id: '01900000-0000-7000-8000-0000000000r1', name: 'شاورما الريف' }],
  codes: [],
  zones: [{ id: '01900000-0000-7000-8000-0000000000z1', name: 'المركز' }],
  canManage,
});
const scheduled = (status: string) => ({
  id: pushId,
  title: 'عرض الشتاء',
  body: 'توصيل مجاني على طلبك الأول',
  audience: 'never_ordered',
  zoneId: null,
  inactiveDays: null,
  zoneName: null,
  target: 'home',
  restaurantId: null,
  restaurantName: null,
  codeId: null,
  code: null,
  scheduled: true,
  sendAt: '2026-12-01T15:00:00.000Z',
  status,
  recipients: 42,
  sent: 0,
  delivered: 0,
  sentBy: 'المالك',
  createdAt: '2026-11-18T10:00:00.000Z',
  cancelledBy: status === 'cancelled' ? 'المالك' : null,
  cancelledAt: status === 'cancelled' ? '2026-11-18T11:00:00.000Z' : null,
});

// AP §9.11.4: OWN counts the customers who never ordered, confirms a
// scheduled push to them, sees it in the history and cancels it.
test('schedules a push to those who never ordered after the confirmation', async ({ page }) => {
  await fakeSession(page, ['marketing.read', 'marketing.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let pushes: object[] = [];
  const sent: unknown[] = [];
  await page.route('**/v1/admin/mass-pushes**', (route) => {
    const request = route.request();
    const url = new URL(request.url());
    if (url.pathname.endsWith('/audience')) {
      expect(url.searchParams.get('audience')).toBe('never_ordered');
      return route.fulfill({ json: { size: 42 } });
    }
    if (request.method() === 'GET') return route.fulfill({ json: answer(pushes) });
    sent.push(request.postDataJSON());
    if (url.pathname.endsWith('/cancel')) {
      pushes = [scheduled('cancelled')];
      return route.fulfill({ json: answer(pushes) });
    }
    expect(request.headers()['idempotency-key']).toMatch(/^[0-9a-f-]{36}$/);
    pushes = [scheduled('scheduled')];
    return route.fulfill({ status: 201, json: answer(pushes) });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'الإشعارات الجماعية' }).click();
  const form = page.getByRole('region', { name: 'إشعار جديد' });
  await form.getByLabel('العنوان (حتى 50 حرفاً)').fill('عرض الشتاء');
  await form.getByLabel('النص (حتى 200 حرف)').fill('توصيل مجاني على طلبك الأول');
  await form.getByLabel('سجّل ولم يطلب').check();
  await form.getByLabel('في وقت محدد').check();
  await form.getByLabel('الوقت (خلال 30 يوماً)').fill('2026-12-01T18:00');
  await form.getByRole('button', { name: 'عدد المستلمين' }).click();
  await expect(form.getByText('سيصل الإشعار إلى 42 زبون')).toBeVisible();
  await form.getByRole('button', { name: 'تأكيد الجدولة إلى 42 زبون' }).click();

  const item = page.getByRole('region', { name: 'عرض الشتاء' });
  await expect(item.getByText('مجدول', { exact: true })).toBeVisible();
  await expect(item.getByText('المرسل: المالك')).toBeVisible();
  await expect(item.getByText('المستلمون 42 · أُرسل 0 · وصل 0')).toBeVisible();
  await item.getByRole('button', { name: 'إلغاء الإرسال' }).click();
  await item.getByRole('button', { name: 'تأكيد إلغاء الإرسال' }).click();
  await expect(item.getByText('أُلغي', { exact: true })).toBeVisible();

  expect(sent).toEqual([
    {
      cityId,
      title: 'عرض الشتاء',
      body: 'توصيل مجاني على طلبك الأول',
      audience: 'never_ordered',
      zoneId: null,
      inactiveDays: null,
      target: 'home',
      restaurantId: null,
      codeId: null,
      sendAt: '2026-12-01T15:00:00.000Z',
      audienceSize: 42,
    },
    { cityId },
  ]);
});

// OPS reads the history only.
test('OPS reads the history without the form', async ({ page }) => {
  await fakeSession(page, ['marketing.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/mass-pushes**', (route) =>
    route.fulfill({ json: answer([scheduled('scheduled')], false) }),
  );
  await page.goto('/mass-pushes');
  await expect(page.getByRole('heading', { name: 'عرض الشتاء' })).toBeVisible();
  await expect(page.getByRole('region', { name: 'إشعار جديد' })).toHaveCount(0);
  await expect(page.getByRole('button', { name: 'إلغاء الإرسال' })).toHaveCount(0);
});
