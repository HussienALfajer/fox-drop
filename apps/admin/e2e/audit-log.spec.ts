import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const ownerId = '01900000-0000-7000-8000-000000000001';

const event = (id: string, overrides: object = {}) => ({
  id,
  at: '2026-11-19T09:30:00.000Z',
  kind: 'write',
  cityId,
  actorType: 'admin',
  actorId: ownerId,
  actorName: 'حسين',
  actorRole: 'OWN',
  action: 'setting.update',
  targetType: 'setting',
  targetId: 'order.eta_buffer_min',
  changes: [{ field: 'value', before: '10', after: '12' }],
  reason: 'زحام المساء',
  ipAddress: '203.0.113.7',
  device: 'Firefox 140 on Windows',
  ...overrides,
});

// «سجل التدقيق» (slice 2.38a; AP §9.16): the owner finds a setting it edited,
// with the diff, reason, IP and device, filters the log and reads the next page.
test('shows the events with their diff and filters them', async ({ page }) => {
  await fakeSession(page, ['audit_log.read', 'admin_team.manage']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/team/users', (route) =>
    route.fulfill({
      json: {
        users: [
          {
            id: ownerId,
            name: 'حسين',
            email: null,
            phone: null,
            roles: ['OWN'],
            status: 'active',
            totpEnrolled: true,
            lastSignInAt: null,
            openSessions: [],
          },
        ],
      },
    }),
  );
  const asked: URLSearchParams[] = [];
  await page.route('**/v1/admin/audit-log*', (route) => {
    const query = new URL(route.request().url()).searchParams;
    asked.push(query);
    if (query.get('cursor') !== null) {
      return route.fulfill({
        json: {
          events: [
            event('01900000-0000-7000-8000-0000000000e3', {
              kind: 'view',
              cityId: null,
              action: 'customer.phone.view',
              actorName: null,
              targetType: 'customer',
              targetId: '01900000-0000-7000-8000-0000000000f1',
              changes: [],
              reason: null,
            }),
          ],
          nextCursor: null,
        },
      });
    }
    return route.fulfill({
      json: {
        events: [
          event('01900000-0000-7000-8000-0000000000e1'),
          event('01900000-0000-7000-8000-0000000000e2', {
            actorType: 'system',
            actorId: null,
            actorName: null,
            actorRole: null,
            action: 'order.timeout',
            targetType: 'order',
            changes: [],
            reason: null,
            ipAddress: null,
            device: null,
          }),
        ],
        nextCursor: '2026-11-19T09:30:00.000Z_01900000-0000-7000-8000-0000000000e2',
      },
    });
  });
  await page.goto('/');
  await page.getByRole('link', { name: 'سجل التدقيق' }).click();

  const events = page.getByRole('region', { name: 'الأحداث' });
  const edited = events.getByRole('row', { name: /تعديل إعداد/ });
  await expect(edited).toContainText('حسين');
  await expect(edited).toContainText('أعزاز');
  await expect(edited).toContainText('order.eta_buffer_min');
  await expect(edited).toContainText('value: من 10 إلى 12');
  await expect(edited).toContainText('زحام المساء');
  await expect(edited).toContainText('203.0.113.7');
  // An action the panel does not name shows its code; the system acts too.
  await expect(events.getByRole('row', { name: /order\.timeout/ })).toContainText('النظام');

  await events.getByRole('button', { name: 'عرض المزيد' }).click();
  const viewed = events.getByRole('row', { name: /إظهار رقم الزبون/ });
  await expect(viewed).toContainText('(عرض بيانات حساسة)');
  await expect(viewed).toContainText('المنصة كلها');
  await expect(viewed).toContainText(`مستخدم إدارة ${ownerId}`);
  expect(asked.at(-1)?.get('cursor')).toBe(
    '2026-11-19T09:30:00.000Z_01900000-0000-7000-8000-0000000000e2',
  );

  const filters = page.getByRole('form', { name: 'تصفية السجل' });
  await filters
    .getByRole('combobox', { name: 'المنفّذ', exact: true })
    .selectOption({ label: 'حسين' });
  await filters.getByRole('combobox', { name: 'الإجراء' }).selectOption({ label: 'تعديل إعداد' });
  await filters.getByLabel('أو رمز هدف آخر').fill('pay_table');
  await filters.getByLabel('من تاريخ').fill('2026-11-01');
  await filters.getByLabel('إلى تاريخ').fill('2026-11-19');
  await filters.getByRole('button', { name: 'عرض' }).click();
  await expect(page).toHaveURL(/action=setting\.update/);
  await expect.poll(() => asked.at(-1)?.get('from')).toBe('2026-10-31T21:00:00.000Z');
  const last = asked.at(-1)!;
  expect(last.get('to')).toBe('2026-11-19T21:00:00.000Z');
  expect(last.get('actorId')).toBe(ownerId);
  expect(last.get('action')).toBe('setting.update');
  expect(last.get('targetType')).toBe('pay_table');
  expect(last.get('cursor')).toBeNull();
});

test('is not offered without audit_log.read', async ({ page }) => {
  await fakeSession(page, ['settings.read']);
  await page.goto('/');
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  await expect(page.getByRole('link', { name: 'سجل التدقيق' })).toHaveCount(0);
  await page.goto('/audit-log');
  await expect(page).toHaveURL(/\/$/);
});
