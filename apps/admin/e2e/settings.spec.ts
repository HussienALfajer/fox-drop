import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const city = { id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' };

function setting(fields: { key: string } & Record<string, unknown>) {
  return {
    template: fields.key,
    parameter: null,
    unit: null,
    scope: 'city',
    cityId,
    editRoles: ['OWN'],
    reasonRequired: false,
    beforeLaunch: false,
    isDefault: true,
    ...fields,
  };
}

const buffer = setting({
  key: 'order.eta_buffer_min',
  group: 'timers_limits',
  type: 'duration',
  unit: 'min',
  default: 10,
  value: 10,
});
const lockout = setting({
  key: 'admin.lockout_min',
  group: 'security',
  type: 'duration',
  unit: 'min',
  scope: 'global',
  cityId: null,
  default: 15,
  value: 20,
  isDefault: false,
});
const caps = setting({
  key: 'otp.sender_warmup_caps',
  group: 'security',
  type: 'count',
  scope: 'global',
  cityId: null,
  default: [50, 100, 'full'],
  value: [50, 100, 'full'],
});
const policy = setting({
  key: 'captain.negative_earnings_policy',
  group: 'captains',
  type: 'enum',
  reasonRequired: true,
  default: 'carry_forward',
  value: 'carry_forward',
});

// AP §9.14 «الإعدادات» (slice 2.38a): OWN changes a timer of the city, then
// restores a global setting's default, and a setting with money impact asks
// its reason.
test('edits a setting of each group and restores a default', async ({ page }) => {
  await fakeSession(page, ['settings.read', 'settings.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: { cities: [city] } }));
  let current = [buffer, lockout, caps, policy];
  await page.route('**/v1/admin/settings?*', (route) =>
    route.fulfill({ json: { settings: current } }),
  );
  const sent: { url: string; body: unknown }[] = [];
  await page.route('**/v1/admin/settings/**', (route) => {
    // The top bar's dispatch mode (AP §7.2).
    if (route.request().method() === 'GET') return route.fulfill({ json: { mode: 'manual' } });
    const url = new URL(route.request().url()).pathname;
    const body = route.request().postDataJSON() as { value?: unknown; reason?: string | null };
    sent.push({ url, body });
    if (url.endsWith('/order.eta_buffer_min')) {
      current = current.map((each) =>
        each.key === buffer.key ? { ...buffer, value: 12, isDefault: false } : each,
      );
      return route.fulfill({ json: current[0] });
    }
    if (url.endsWith('/admin.lockout_min/reset')) {
      current = current.map((each) =>
        each.key === lockout.key ? { ...lockout, value: 15, isDefault: true } : each,
      );
      return route.fulfill({ json: current[1] });
    }
    if (url.endsWith('/captain.negative_earnings_policy') && body.reason === null) {
      return route.fulfill({ status: 400, json: { statusCode: 400, error: 'reason_required' } });
    }
    return route.fulfill({ json: { ...policy, value: 'collect_at_desk', isDefault: false } });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'الإعدادات', exact: true }).click();
  await expect(page.getByRole('heading', { level: 2, name: 'المؤقتات والحدود' })).toBeVisible();
  const timer = page.getByRole('form', { name: 'هامش الوقت المتوقع' });
  await expect(timer).toContainText('دقائق تُضاف إلى التحضير والرحلة');
  await expect(timer).toContainText('القيمة الحالية: 10 دقيقة (القيمة الافتراضية)');
  await expect(timer).toContainText('القيمة الافتراضية: 10 دقيقة');
  await expect(timer).toContainText('يخص المدينة: أعزاز');
  await expect(timer.getByRole('button', { name: 'استعادة الافتراضي' })).toHaveCount(0);
  await timer.getByLabel('القيمة (دقيقة)').fill('12');
  await timer.getByRole('button', { name: 'حفظ' }).click();
  const saved = page.getByRole('form', { name: 'هامش الوقت المتوقع' });
  await expect(saved).toContainText('القيمة الحالية: 12 دقيقة');
  await expect(saved.getByRole('status')).toHaveText('حُفظ. يسري الآن.');
  expect(sent[0]).toEqual({
    url: '/v1/admin/settings/order.eta_buffer_min',
    body: { cityId, value: 12, reason: null },
  });

  await page.getByRole('link', { name: 'الأمان' }).click();
  await expect(page.getByRole('link', { name: 'أرقام إرسال الرموز' })).toBeVisible();
  await expect(page.getByRole('form', { name: 'حدود الإحماء اليومية' })).toContainText(
    'القيمة الحالية: 50، 100، كامل',
  );
  const lock = page.getByRole('form', { name: 'مدة القفل' });
  await expect(lock).toContainText('يخص كل المدن');
  await lock.getByRole('button', { name: 'استعادة الافتراضي' }).click();
  const restored = page.getByRole('form', { name: 'مدة القفل' });
  await expect(restored).toContainText('القيمة الحالية: 15 دقيقة (القيمة الافتراضية)');
  await expect(restored.getByRole('status')).toHaveText('استُعيدت القيمة الافتراضية.');
  expect(sent[1]).toEqual({
    url: '/v1/admin/settings/admin.lockout_min/reset',
    body: { cityId: null, reason: null },
  });

  await page.getByRole('link', { name: 'الكباتن' }).click();
  const negative = page.getByRole('form', { name: 'الرصيد السالب للكابتن' });
  await negative.getByLabel('القيمة').selectOption({ label: 'يُحصَّل في المكتب' });
  await negative.getByRole('button', { name: 'حفظ' }).click();
  await expect(negative.getByRole('alert')).toHaveText('اكتب السبب: هذا الإعداد يؤثر في المال.');
  await negative.getByLabel('السبب').fill('تحصيل أسبوعي');
  await negative.getByRole('button', { name: 'حفظ' }).click();
  await expect(negative.getByRole('status')).toHaveText('حُفظ. يسري الآن.');
  expect(sent.at(-1)?.body).toEqual({ cityId, value: 'collect_at_desk', reason: 'تحصيل أسبوعي' });
});

// «أرقام إرسال الرموز» (slice 2.38a; architecture §8.3.3 item 13).
test('sets a sending number standby and disables another', async ({ page }) => {
  await fakeSession(page, ['settings.read', 'settings.manage']);
  const number = (id: string, status: string, fields: object = {}) => ({
    id,
    phone: `+96399000000${id.slice(-1)}`,
    status,
    connected: status !== 'disconnected',
    pairedAt: '2026-11-10T08:00:00.000Z',
    stoppedAt: null,
    throttledUntil: null,
    warmup: null,
    dailyCap: 1500,
    today: { sent: 40, failed: 1, delivered: 38, read: 30 },
    ...fields,
  });
  const first = number('01900000-0000-7000-8000-0000000000a1', 'active');
  const second = number('01900000-0000-7000-8000-0000000000a2', 'disconnected', {
    stoppedAt: '2026-11-19T07:00:00.000Z',
  });
  const alerts = [{ type: 'number_stopped', severity: 'warning', numberIds: [second.id] }];
  await page.route('**/v1/admin/otp-sender-numbers', (route) =>
    route.fulfill({ json: { numbers: [first, second], alerts } }),
  );
  const asked: { url: string; body: unknown }[] = [];
  await page.route('**/v1/admin/otp-sender-numbers/*/*', (route) => {
    const url = new URL(route.request().url()).pathname;
    asked.push({ url, body: route.request().postDataJSON() });
    if (url.endsWith('/status')) {
      return route.fulfill({
        json: { numbers: [{ ...first, status: 'standby' }, second], alerts },
      });
    }
    return route.fulfill({ json: { numbers: [{ ...first, status: 'standby' }], alerts: [] } });
  });
  await page.goto('/settings/otp-senders');

  await expect(page.getByRole('alert').first()).toHaveText('رقم إرسال الرموز متوقف');
  await expect(page.getByText(/أمر الربط على الخادم/)).toBeVisible();
  const active = page.getByRole('region', { name: first.phone });
  await expect(active).toContainText('الحالة: نشط');
  await expect(active).toContainText('اليوم: أُرسل 40، فشل 1، وصل 38، قُرئ 30 من حد 1500');
  await active.getByRole('button', { name: 'جعله احتياطياً' }).click();
  await expect(active).toContainText('الحالة: احتياطي');
  expect(asked[0]).toEqual({
    url: `/v1/admin/otp-sender-numbers/${first.id}/status`,
    body: { status: 'standby' },
  });

  const stopped = page.getByRole('region', { name: second.phone });
  await expect(stopped).toContainText('الحالة: مفصول');
  await expect(stopped).toContainText('يحتاج إلى إعادة الربط');
  await expect(stopped.getByRole('button', { name: /جعله/ })).toHaveCount(0);
  await stopped.getByRole('button', { name: 'تعطيل الرقم' }).click();
  await stopped.getByRole('button', { name: /تأكيد تعطيل الرقم/ }).click();
  await expect(page.getByRole('region', { name: second.phone })).toHaveCount(0);
  expect(asked[1]?.url).toBe(`/v1/admin/otp-sender-numbers/${second.id}/disable`);
});

test('is not offered without settings.read', async ({ page }) => {
  await fakeSession(page, ['zones.read']);
  await page.goto('/');
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  await expect(page.getByRole('link', { name: 'الإعدادات', exact: true })).toHaveCount(0);
  await page.goto('/settings');
  await expect(page).toHaveURL(/\/$/);
});
