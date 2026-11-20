import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const richId = '01900000-0000-7000-8000-0000000000b1';
const poorId = '01900000-0000-7000-8000-0000000000b2';
const money = (amount: string) => ({ amount, currency: 'TRY' });

const listed = (id: string, name: string, usage: string) => ({
  id,
  name,
  maskedPhone: '+963 ••• 123',
  vehicle: 'motorbike',
  plateNumber: '12345',
  status: 'online',
  applicationId: null,
  contractPhase: 'commitment',
  custody: { usage: money(usage), limit: money('300000'), closedDue: money('0') },
  earnings: money('45000'),
  ordersToday: 4,
  acceptance: { accepted: 45, answered: 50 },
  ratingAverage: 4.6,
  ratingCount: 20,
});

const window = (from: string, earnings: string, orders: number) => ({
  from,
  earnings,
  orders,
  onlineMinutes: 330,
});

const profile = {
  id: richId,
  cityId,
  name: 'أحمد الكابتن',
  maskedPhone: '+963 ••• 123',
  vehicle: 'motorbike',
  plateNumber: '12345',
  status: 'online',
  suspension: null,
  applicationId: null,
  contractPhase: 'commitment',
  custody: {
    usage: money('250000'),
    limit: money('300000'),
    closedDue: money('0'),
    currencies: [],
    blocks: [],
    handInGraceUntil: null,
  },
  earnings: {
    currency: 'TRY',
    balance: '45000',
    today: window('2026-11-19T03:00:00.000Z', '5000', 4),
    week: window('2026-11-19T03:00:00.000Z', '5000', 4),
    month: window('2026-11-01T03:00:00.000Z', '120000', 60),
  },
  ordersToday: 4,
  delivered: 210,
  onTime: { onTime: 45, counted: 50 },
  cancellations: 1,
  acceptance: { accepted: 45, answered: 50 },
  rating: { count: 20, average: 4.6 },
  app: {
    maxPickup: null,
    maxPickupAnswered: true,
    carriedCurrencies: ['TRY'],
    expiredInRow: 0,
    deviceCheck: { at: '2026-11-20T09:00:00.000Z', passed: false, failed: ['test_offer'] },
  },
};

// AP §9.7.3–9.7.5 «الكباتن» (slice 2.36a): the list sorted by the highest
// custody, the overview, and a suspension with its reason.
test('sorts the captains by custody, opens one and suspends it', async ({ page }) => {
  await fakeSession(page, ['captains.read', 'captains.manage', 'captains.suspend']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  const asked: Record<string, unknown>[] = [];
  await page.route('**/v1/admin/captain-list', (route) => {
    asked.push(route.request().postDataJSON() as Record<string, unknown>);
    return route.fulfill({
      json: {
        captains: [
          listed(richId, 'أحمد الكابتن', '250000'),
          listed(poorId, 'باسل الكابتن', '1000'),
        ],
      },
    });
  });
  let current: Record<string, unknown> = profile;
  await page.route(`**/v1/admin/captains/${richId}/profile`, (route) =>
    route.fulfill({ json: current }),
  );
  const commands: unknown[] = [];
  await page.route(`**/v1/admin/captains/${richId}/status`, (route) => {
    commands.push(route.request().postDataJSON());
    current = {
      ...profile,
      status: 'suspended',
      suspension: { reason: 'شكاوى متكررة', until: null },
    };
    return route.fulfill({ json: { state: 'suspended', lastOrderBy: null } });
  });
  await page.route(`**/v1/admin/captains/${richId}/change-log`, (route) =>
    route.fulfill({ json: { entries: [] } }),
  );
  await page.route('**/v1/admin/realtime/token', (route) =>
    route.fulfill({ status: 503, json: { statusCode: 503 } }),
  );
  await page.goto('/');

  await page.getByRole('link', { name: 'الكباتن', exact: true }).click();
  const table = page.getByRole('table', { name: 'الكباتن' });
  await expect(table.getByRole('link', { name: 'أحمد الكابتن' })).toBeVisible();
  await expect(table.getByText('90% من آخر 50 عرضاً').first()).toBeVisible();
  // By name first; the custody header sorts from the highest.
  await expect(table.getByRole('link').first()).toHaveText('أحمد الكابتن');
  await table.getByRole('button', { name: 'العهدة' }).click();
  await expect(page).toHaveURL(/sort=custody&dir=desc/);
  await expect(table.getByRole('link').first()).toHaveText('أحمد الكابتن');
  await table.getByRole('button', { name: 'العهدة' }).click();
  await expect(table.getByRole('link').first()).toHaveText('باسل الكابتن');
  await page.getByLabel('الحالة').selectOption({ label: 'مشغول' });
  await expect.poll(() => asked.at(-1)?.status).toBe('busy');

  await table.getByRole('link', { name: 'أحمد الكابتن' }).click();
  const overview = page.getByRole('region', { name: 'نظرة عامة' });
  await expect(overview.getByText('90% من آخر 50 عرضاً')).toBeVisible();
  await expect(overview.getByText('90% من آخر 50 طلباً مسلّماً')).toBeVisible();
  await expect(overview.getByText('5.5 ساعة').first()).toBeVisible();

  // AP §9.7.4 «التطبيق» (slice 2.43): the last device check.
  await page.getByRole('link', { name: 'التطبيق', exact: true }).click();
  await expect(
    page
      .getByRole('region', { name: 'التطبيق' })
      .getByText(/^لم ينجح في .+: لم يُسمع صوت العرض التجريبي$/),
  ).toBeVisible();

  await page.getByRole('link', { name: 'المخالفات والإيقافات' }).click();
  const form = page.getByRole('form', { name: 'الإيقاف وإعادة التفعيل' });
  await form.getByLabel('السبب (يراه الكابتن)').fill('شكاوى متكررة');
  await form.getByRole('button', { name: 'إيقاف الكابتن' }).click();
  await expect(page.getByText('موقوف حتى إشعار آخر: شكاوى متكررة').first()).toBeVisible();
  expect(commands[0]).toEqual({ status: 'suspended', until: null, reason: 'شكاوى متكررة' });
});
