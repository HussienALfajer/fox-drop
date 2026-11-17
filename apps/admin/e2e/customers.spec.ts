import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const customerId = '01900000-0000-7000-8000-0000000000b1';
const blockId = '01900000-0000-7000-8000-0000000000b2';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};

const profile = (blocked: boolean) => ({
  id: customerId,
  firstName: 'سامر',
  lastName: 'الحلبي',
  gender: 'male',
  birthday: null,
  maskedPhone: '+963 ••• 456',
  status: blocked ? 'blocked' : 'active',
  block: blocked
    ? {
        id: blockId,
        kind: 'indefinite',
        until: null,
        reason: 'abuse',
        reasonLabel: 'إساءة',
        customerText: 'مخالفة شروط الاستخدام',
        note: 'أساء للكابتن',
        startedAt: '2026-11-17T09:00:00.000Z',
      }
    : null,
  reviewStop: null,
  closed: null as null | { at: string; byName: string | null; reason: string | null },
  linkedAccounts: [] as {
    id: string;
    status: 'active' | 'closed';
    createdAt: string;
    closedAt: string | null;
  }[],
  trusted: false,
  delivered: 1,
  trustedAfter: 3,
  trustMark: null,
  lateCancels: { inWindow: 0, total: 0, limit: 2, windowDays: 30, cleared: null },
  fakeOrders: 0,
  dues: { amount: '0', currency: 'TRY' },
  blocks: blocked
    ? [
        {
          id: blockId,
          kind: 'indefinite',
          reason: 'abuse',
          reasonLabel: 'إساءة',
          note: 'أساء للكابتن',
          until: null,
          duesAmount: null,
          duesCurrency: null,
          startedAt: '2026-11-17T09:00:00.000Z',
          startedByName: 'سارة',
          endedAt: null,
          endedByName: null,
          endNote: null,
          inForce: true,
        },
      ]
    : [],
  blockReasons: [
    { code: 'fake_order', label: 'طلب وهمي' },
    { code: 'abuse', label: 'إساءة' },
  ],
  testAccount: false,
  orders: { count: 0, spent: [], last: null },
  tickets: [],
  codes: [],
  addresses: [],
  notes: [],
});

// AP §9.8 (slice 2.25a): the owner finds a customer by the number and blocks
// them until further notice.
test('finds a customer and blocks them until further notice', async ({ page }) => {
  await fakeSession(page, ['customers.read', 'customers.block']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let blocked = false;
  const sent: { body: unknown; key: string | undefined }[] = [];
  await page.route('**/v1/admin/customers/**', (route) => {
    const request = route.request();
    const url = new URL(request.url());
    if (url.pathname.endsWith('/search')) {
      return route.fulfill({
        json: {
          customers: [
            { id: customerId, name: 'سامر الحلبي', maskedPhone: '+963 ••• 456', status: 'active' },
          ],
        },
      });
    }
    if (url.pathname.endsWith('/block')) {
      sent.push({ body: request.postDataJSON(), key: request.headers()['idempotency-key'] });
      blocked = true;
      return route.fulfill({ status: 201, json: profile(true) });
    }
    return route.fulfill({ json: profile(blocked) });
  });

  await page.goto('/customers');
  await page.getByLabel('بحث بالرقم أو الاسم').fill('0933123456');
  await page.getByRole('link', { name: 'سامر الحلبي' }).click();
  await expect(page.getByRole('heading', { name: 'سامر الحلبي' })).toBeVisible();
  await expect(page.getByText('جديد: 1 من 3 طلبات مسلّمة')).toBeVisible();

  await page.getByLabel('حتى إشعار آخر').check();
  await page.getByRole('combobox').selectOption('abuse');
  await page.getByLabel('السبب الداخلي').fill('أساء للكابتن');
  await page.getByRole('button', { name: 'حظر' }).click();

  await expect(page.getByText('محظور حتى إشعار آخر: إساءة.')).toBeVisible();
  await expect(page.getByText('يرى الزبون: «مخالفة شروط الاستخدام»')).toBeVisible();
  await expect(page.getByRole('heading', { name: 'فك الحظر' })).toBeVisible();
  expect(sent).toHaveLength(1);
  expect(sent[0]!.key).toBeTruthy();
  expect(sent[0]!.body).toEqual({
    cityId,
    kind: 'indefinite',
    until: null,
    amount: null,
    reason: 'abuse',
    note: 'أساء للكابتن',
  });
});

// AP §9.8, CU §5.4 (slice 2.25b): the owner changes a customer's number.
test("changes a customer's number with a reason", async ({ page }) => {
  await fakeSession(page, ['customers.read', 'customers.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  const sent: unknown[] = [];
  let changed = false;
  await page.route('**/v1/admin/customers/**', (route) => {
    const request = route.request();
    if (new URL(request.url()).pathname.endsWith('/change-phone')) {
      sent.push(request.postDataJSON());
      changed = true;
    }
    return route.fulfill({
      json: changed ? { ...profile(false), maskedPhone: '+963 ••• 789' } : profile(false),
    });
  });
  await page.goto(`/customers/${customerId}`);
  await expect(page.getByRole('heading', { name: 'سامر الحلبي' })).toBeVisible();
  const form = page.locator('form', { has: page.getByRole('heading', { name: 'تغيير الرقم' }) });
  await form.getByLabel('الرقم الجديد').fill('0991234789');
  await form.getByLabel('السبب').fill('طلب الزبون عبر الدعم');
  await form.getByRole('button', { name: 'تغيير الرقم' }).click();
  await expect(page.getByText('تغيّر الرقم وسُجّل خروج الزبون من كل الأجهزة.')).toBeVisible();
  await expect(page.getByText('+963 ••• 789')).toBeVisible();
  expect(sent).toEqual([{ cityId, phone: '0991234789', note: 'طلب الزبون عبر الدعم' }]);
});

// AP §9.8, D19 (slice 2.25c): support closes the account on the customer's
// request; the profile shows «مغلق» and the account that continues it.
test("closes a customer's account with a reason", async ({ page }) => {
  await fakeSession(page, ['customers.read', 'customers.close_account']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  const sent: unknown[] = [];
  let closed = false;
  await page.route('**/v1/admin/customers/**', (route) => {
    const request = route.request();
    if (new URL(request.url()).pathname.endsWith('/close')) {
      sent.push(request.postDataJSON());
      closed = true;
    }
    return route.fulfill({
      json: closed
        ? {
            ...profile(false),
            status: 'closed',
            closed: { at: '2026-11-17T10:00:00.000Z', byName: 'سارة', reason: 'طلب الزبون' },
            linkedAccounts: [
              {
                id: blockId,
                status: 'active',
                createdAt: '2026-11-17T11:00:00.000Z',
                closedAt: null,
              },
            ],
          }
        : profile(false),
    });
  });
  await page.goto(`/customers/${customerId}`);
  const form = page.locator('form', { has: page.getByRole('heading', { name: 'إغلاق الحساب' }) });
  await form.getByLabel('السبب').fill('طلب الزبون');
  await form.getByRole('button', { name: 'إغلاق الحساب' }).click();
  await expect(page.getByText('مغلق', { exact: true })).toBeVisible();
  await expect(page.getByText(/أُغلق في .*: سارة/)).toBeVisible();
  await expect(page.getByRole('link', { name: /الحساب الحالي بالرقم نفسه/ })).toBeVisible();
  await expect(page.getByRole('heading', { name: 'إغلاق الحساب' })).toHaveCount(0);
  expect(sent).toEqual([{ cityId, note: 'طلب الزبون' }]);
});
