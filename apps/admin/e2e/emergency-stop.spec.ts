import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const stopId = '01900000-0000-7000-8000-0000000000e1';

const defaults = {
  browseMessage: 'نعتذر، توقفنا مؤقتاً عن استقبال الطلبات. نعود قريباً.',
  delayNotice: 'قد يتأخر طلبك قليلاً بسبب {السبب}. نعتذر عن الانتظار.',
};

// AP §9.1.6 «الإيقاف الطارئ»: OPS starts the stop from the top bar, the bar
// turns to «إيقاف طارئ» with its attempts, and «استئناف» ends it with
// «الخدمة عادت».
test('starts the emergency stop and resumes it with the service-back push', async ({ page }) => {
  await fakeSession(page, ['emergency_stop.toggle']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  let stop: Record<string, unknown> | null = null;
  await page.route('**/v1/admin/emergency-stop?*', (route) =>
    route.fulfill({ json: { stop, defaults } }),
  );
  let started: Record<string, unknown> | undefined;
  await page.route('**/v1/admin/emergency-stop', (route) => {
    started = route.request().postDataJSON();
    stop = {
      id: stopId,
      startedAt: new Date().toISOString(),
      startedBy: '01900000-0000-7000-8000-000000000001',
      internalReason: started!.internalReason,
      browseMessage: started!.browseMessage,
      delayNotice: started!.delayNotice,
      customerReason: started!.customerReason,
      resumeAt: started!.resumeAt,
      attempts: 3,
    };
    return route.fulfill({ status: 201, json: { stop } });
  });
  let resumed: Record<string, unknown> | undefined;
  await page.route('**/v1/admin/emergency-stop/resume', (route) => {
    resumed = route.request().postDataJSON();
    stop = null;
    return route.fulfill({ json: { resumed: true } });
  });
  await page.goto('/');

  await expect(page.getByText('المنصة تعمل')).toBeVisible();
  await page.getByRole('link', { name: 'الإيقاف الطارئ' }).click();
  await expect(page.getByLabel('رسالة الزبائن أثناء التصفح')).toHaveValue(defaults.browseMessage);
  await page.getByLabel('السبب الداخلي').fill('عاصفة');
  await page.getByLabel('السبب كما يراه الزبون').fill('سوء الأحوال الجوية');
  await expect(
    page.getByText('قد يتأخر طلبك قليلاً بسبب سوء الأحوال الجوية. نعتذر عن الانتظار.', {
      exact: false,
    }),
  ).toBeVisible();
  await page.getByLabel('الاستئناف التلقائي (اختياري)').fill('2030-01-01T18:30');
  await page.getByRole('button', { name: 'إيقاف الطلبات الجديدة' }).click();

  await expect(page.getByRole('alert')).toHaveText('إيقاف طارئ — منذ 0 د — محاولات الطلب: 3');
  expect(started).toEqual({
    cityId,
    internalReason: 'عاصفة',
    browseMessage: defaults.browseMessage,
    delayNotice: defaults.delayNotice,
    customerReason: 'سوء الأحوال الجوية',
    // 18:30 on the city's clock, UTC+3.
    resumeAt: '2030-01-01T15:30:00.000Z',
  });

  await page.getByLabel('إرسال إشعار «الخدمة عادت» للزبائن الذين حاولوا الطلب').check();
  await page.getByLabel('نص الإشعار').fill('عادت الخدمة، اطلب الآن');
  await page.getByRole('button', { name: 'استئناف' }).click();

  await expect(page.getByText('المنصة تعمل')).toBeVisible();
  expect(resumed).toEqual({ cityId, stopId, serviceBack: 'عادت الخدمة، اطلب الآن' });
});
