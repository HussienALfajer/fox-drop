import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const orderId = '01900000-0000-7000-8000-0000000000d1';
const alertId = '01900000-0000-7000-8000-0000000000a1';

const open = {
  id: alertId,
  code: 'restaurant_not_accepted',
  severity: 'critical',
  subjectType: 'order',
  subjectId: orderId,
  orderNumber: '10001',
  captainName: null,
  raisedAt: new Date(Date.now() - 60_000).toISOString(),
  acknowledged: null,
  resolvedAt: null,
};

// AP §7.3, §9.1.3: an operator enables the sound, sees «مطعم لم يقبل» and
// takes it; everyone then sees who took it.
test('enables the alert sound and acknowledges an alert', async ({ page }) => {
  await fakeSession(page, ['operations.read'], ['OPS']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  let acknowledged = false;
  await page.route('**/v1/admin/alerts?**', (route) =>
    route.fulfill({
      json: {
        alerts: [
          acknowledged
            ? {
                ...open,
                acknowledged: { at: new Date().toISOString(), byId: 'u1', byName: 'ليلى' },
              }
            : open,
        ],
      },
    }),
  );
  await page.route(`**/v1/admin/alerts/${alertId}/acknowledge`, (route) => {
    acknowledged = true;
    return route.fulfill({
      json: { ...open, acknowledged: { at: new Date().toISOString(), byId: 'u1', byName: 'ليلى' } },
    });
  });
  await page.goto('/');

  // The banner covers the page until the sound is on.
  await expect(page.getByRole('heading', { name: 'لوحة الإدارة' })).toBeHidden();
  await page.getByRole('button', { name: 'اضغط لتفعيل صوت التنبيهات' }).click();
  await expect(page.getByRole('heading', { name: 'لوحة الإدارة' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'اضغط لتفعيل صوت التنبيهات' })).toBeHidden();
  await page.getByRole('link', { name: 'التنبيهات: 1' }).click();
  await expect(page.getByRole('heading', { name: 'التنبيهات' })).toBeVisible();
  await expect(page.getByText('مطعم لم يقبل')).toBeVisible();
  await expect(page.getByText('الطلب #10001')).toBeVisible();
  await page.getByRole('button', { name: 'استلام' }).click();
  await expect(page.getByText(/استلمه ليلى/)).toBeVisible();
  await expect(page.getByRole('button', { name: 'استلام' })).toBeHidden();
});

// A user whose roles receive no alert gets no banner (AP §7.3).
test('shows no sound banner to a support user', async ({ page }) => {
  await fakeSession(page, [], ['SUP']);
  await page.goto('/');
  await expect(page.getByRole('heading', { name: 'لوحة الإدارة' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'اضغط لتفعيل صوت التنبيهات' })).toBeHidden();
});
