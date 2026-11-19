import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const city = { id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' };
const ownerId = '01900000-0000-7000-8000-000000000001';
const opsId = '01900000-0000-7000-8000-0000000000a2';
const newId = '01900000-0000-7000-8000-0000000000a3';

const owner = {
  id: ownerId,
  name: 'حسين',
  email: 'owner@example.test',
  phone: null,
  roles: ['OWN'],
  status: 'active',
  totpEnrolled: true,
  lastSignInAt: '2026-11-19T07:00:00.000Z',
  openSessions: [],
};
const ops = {
  id: opsId,
  name: 'سامر',
  email: null,
  phone: '+963944000111',
  roles: ['OPS', 'FIN'],
  status: 'active',
  totpEnrolled: true,
  lastSignInAt: '2026-11-19T08:00:00.000Z',
  openSessions: [
    {
      id: '01900000-0000-7000-8000-0000000000b1',
      userAgent: 'Firefox',
      ipAddress: '203.0.113.7',
      signedInAt: '2026-11-19T08:00:00.000Z',
      lastActivityAt: '2026-11-19T08:10:00.000Z',
    },
  ],
};

const cap = (role: string) => ({
  key: `support.compensation_cap_pct.${role}`,
  template: `support.compensation_cap_pct.${role}`,
  parameter: null,
  group: 'support',
  type: 'percentage',
  unit: null,
  scope: 'city',
  cityId,
  editRoles: ['OWN'],
  reasonRequired: true,
  beforeLaunch: false,
  isDefault: true,
  default: 30,
  value: 30,
});

// AP §9.15 «فريق الإدارة» (slice 2.38b): the owner creates a user and gets
// the setup link, changes a user's roles, disables them after a second
// press, and reads the role matrix with each role's compensation cap.
test('creates a user with a setup link and manages the team', async ({ page }) => {
  await fakeSession(page, ['admin_team.manage', 'settings.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: { cities: [city] } }));
  await page.route('**/v1/admin/settings?*', (route) =>
    route.fulfill({ json: { settings: [cap('OPS'), cap('SUP')] } }),
  );
  await page.route('**/v1/admin/team/roles', (route) =>
    route.fulfill({
      json: {
        roles: [
          { role: 'OWN', permissions: ['admin_team.manage', 'zones.read'] },
          { role: 'OPS', permissions: ['zones.read'] },
          { role: 'FIN', permissions: ['zones.read'] },
        ],
      },
    }),
  );
  let users: object[] = [owner, ops];
  await page.route('**/v1/admin/team/users', (route) => {
    if (route.request().method() === 'GET') return route.fulfill({ json: { users } });
    const body = route.request().postDataJSON() as { name: string; email: string | null };
    if (body.email === 'taken@example.test') {
      return route.fulfill({ status: 409, json: { statusCode: 409, error: 'name_taken' } });
    }
    users = [
      ...users,
      {
        ...owner,
        id: newId,
        name: body.name,
        status: 'pending',
        totpEnrolled: false,
        lastSignInAt: null,
        roles: ['SUP'],
        email: body.email,
      },
    ];
    return route.fulfill({
      status: 201,
      json: { accountId: newId, setupToken: 'tok123', setupExpiresAt: '2026-11-20T09:00:00.000Z' },
    });
  });
  const sent: { url: string; body: unknown }[] = [];
  await page.route('**/v1/admin/team/users/*/*', (route) => {
    const url = new URL(route.request().url()).pathname;
    sent.push({ url, body: route.request().postDataJSON() });
    return route.fulfill({ json: { status: 'done' } });
  });
  await page.goto('/team?city=AZ');

  await expect(page.getByRole('heading', { level: 1, name: 'فريق الإدارة' })).toBeVisible();
  const samer = page.getByRole('article').filter({ hasText: 'سامر' });
  await expect(samer).toContainText('العمليات والتوزيع، المالية');
  await expect(samer).toContainText('+963944000111');
  await expect(samer).toContainText('الجلسات المفتوحة: 1');
  await expect(samer).toContainText('Firefox — 203.0.113.7');
  // The owner never acts on their own account but for the roles.
  const own = page.getByRole('article').filter({ hasText: 'حسين' });
  await expect(own.getByRole('button', { name: 'تعطيل' })).toHaveCount(0);

  // «مستخدم جديد»: a refusal, then the link shown once.
  const form = page
    .locator('section')
    .filter({ has: page.getByRole('heading', { name: 'مستخدم جديد' }) });
  await form.getByRole('button', { name: 'إنشاء ورابط الإعداد' }).click();
  await expect(form.getByRole('alert')).toHaveText('اكتب الاسم.');
  await form.getByLabel('الاسم').fill('ليلى');
  await form.getByLabel('البريد الإلكتروني').fill('taken@example.test');
  await form.getByLabel('الدعم').check();
  await form.getByRole('button', { name: 'إنشاء ورابط الإعداد' }).click();
  await expect(form.getByRole('alert')).toHaveText('البريد أو الهاتف مستخدم لحساب آخر.');
  await form.getByLabel('البريد الإلكتروني').fill('layla@example.test');
  await form.getByRole('button', { name: 'إنشاء ورابط الإعداد' }).click();
  await expect(form.getByLabel('رابط الإعداد')).toHaveValue(/\/setup#token=tok123$/);
  await expect(page.getByRole('article').filter({ hasText: 'ليلى' })).toContainText(
    'بانتظار الإعداد',
  );

  // Roles, then «تعطيل» after a second press.
  await samer.getByLabel('المالية').uncheck();
  await samer.getByRole('button', { name: 'حفظ الأدوار' }).click();
  await expect(samer.getByRole('status')).toHaveText('تم.');
  await samer.getByRole('button', { name: 'تعطيل' }).click();
  expect(sent).toHaveLength(1);
  await samer.getByRole('button', { name: 'تأكيد التعطيل: تنتهي كل جلساته الآن' }).click();
  await expect.poll(() => sent.length).toBe(2);
  expect(sent).toEqual([
    { url: `/v1/admin/team/users/${opsId}/roles`, body: { roles: ['OPS'] } },
    { url: `/v1/admin/team/users/${opsId}/disable`, body: null },
  ]);

  // The role matrix, read only, with the caps.
  const matrix = page.getByRole('table');
  await expect(matrix.getByRole('row', { name: /فريق الإدارة/ })).toContainText('نعم');
  await expect(matrix.getByRole('row', { name: /المناطق والتسعير: عرض/ })).toBeVisible();
  await expect(page.getByText('المالك: بلا سقف.')).toBeVisible();
  await expect(page.getByRole('form', { name: 'سقف تعويض العمليات' })).toBeVisible();
  await expect(page.getByRole('form', { name: 'سقف تعويض الدعم' })).toBeVisible();
});
