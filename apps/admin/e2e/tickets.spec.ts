import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const restaurantId = '01900000-0000-7000-8000-0000000000a1';

function ticket(overrides: Record<string, unknown> = {}) {
  const now = Date.now();
  return {
    id: '01900000-0000-7000-8000-0000000000f1',
    number: '17',
    source: 'manual',
    party: 'restaurant',
    partyId: restaurantId,
    partyName: 'مطعم الساحة',
    orderId: null,
    orderNumber: null,
    urgent: false,
    kind: 'general',
    restaurantId: null,
    restaurantName: null,
    typeCode: 'finance_inquiry',
    typeLabel: 'استفسار مالي',
    description: 'يسأل عن الكشف',
    status: 'new',
    assigneeId: null,
    assigneeName: null,
    sla: {
      kind: 'resolution',
      startedAt: new Date(now).toISOString(),
      dueAt: new Date(now + 24 * 3_600_000).toISOString(),
      stoppedAt: null,
    },
    openedByName: 'ليلى',
    openedAt: new Date(now).toISOString(),
    updatedAt: new Date(now).toISOString(),
    resolution: null,
    closure: null,
    ...overrides,
  };
}

// AP §9.9.1–9.9.2 (slice 2.23a): support opens «تذكرة يدوية» on a restaurant
// found by name, and the list shows it with its number, type and timer.
test('opens a manual ticket on a restaurant and lists it', async ({ page }) => {
  await fakeSession(page, ['support.read', 'support.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/tickets/types', (route) =>
    route.fulfill({
      json: {
        customer: [{ code: 'missing_item', label: 'صنف ناقص' }],
        restaurant: [{ code: 'finance_inquiry', label: 'استفسار مالي' }],
        captain: [{ code: 'order_problem', label: 'مشكلة في طلب' }],
      },
    }),
  );
  await page.route('**/v1/admin/tickets/assignees', (route) =>
    route.fulfill({ json: { assignees: [] } }),
  );
  await page.route('**/v1/admin/tickets/parties/search', (route) =>
    route.fulfill({ json: { parties: [{ id: restaurantId, name: 'مطعم الساحة' }] } }),
  );
  let opened: unknown = null;
  let listed: unknown[] = [];
  await page.route('**/v1/admin/tickets?**', (route) =>
    route.fulfill({ json: { tickets: listed } }),
  );
  await page.route('**/v1/admin/tickets', (route) => {
    opened = route.request().postDataJSON();
    expect(route.request().headers()['idempotency-key']).toBeTruthy();
    listed = [ticket()];
    return route.fulfill({ json: ticket() });
  });
  await page.route('**/v1/admin/alerts**', (route) => route.fulfill({ json: { alerts: [] } }));

  await page.goto('/');
  await page.getByRole('link', { name: 'الدعم' }).click();
  await expect(page.getByText('لا تذاكر هنا.')).toBeVisible();
  const select = (name: string) => page.getByRole('combobox', { name, exact: true }).first();
  await select('الطرف').selectOption('restaurant');
  await page.getByLabel('الاسم أو الرقم').fill('الساحة');
  await page.getByRole('button', { name: 'بحث' }).click();
  await select('اختر').selectOption(restaurantId);
  await select('النوع').selectOption('finance_inquiry');
  await page.getByLabel('ما قاله الطرف').fill('يسأل عن الكشف');
  await page.getByRole('button', { name: 'فتح التذكرة' }).click();

  await expect(page.getByRole('status')).toContainText('فُتحت التذكرة');
  expect(opened).toEqual({
    cityId,
    party: 'restaurant',
    partyId: restaurantId,
    typeCode: 'finance_inquiry',
    description: 'يسأل عن الكشف',
    restaurantId: null,
  });
  await expect(page.getByRole('cell', { name: 'استفسار مالي' })).toBeVisible();
  await expect(page.getByText('مطعم: مطعم الساحة').last()).toBeVisible();
  await expect(page.getByText('الحل ضمن المهلة', { exact: false }).first()).toBeVisible();
});

// AP §9.9.3 (slice 2.23b): support resolves a ticket with its responsible
// party and a canned reply as the message, sent to the party at once.
test('resolves a ticket with a canned reply as the message', async ({ page }) => {
  await fakeSession(page, ['support.read', 'support.manage']);
  const id = '01900000-0000-7000-8000-0000000000f1';
  const message = 'راجعنا بلاغك ولم نجد ما يستدعي تعويضاً.';
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/alerts**', (route) => route.fulfill({ json: { alerts: [] } }));
  await page.route('**/v1/admin/tickets/assignees', (route) =>
    route.fulfill({ json: { assignees: [] } }),
  );
  await page.route('**/v1/admin/tickets?**', (route) => route.fulfill({ json: { tickets: [] } }));
  await page.route('**/v1/admin/content/canned-replies', (route) =>
    route.fulfill({ json: { replies: [{ title: 'لم نجد مشكلة', body: message }] } }),
  );
  const page0 = { ...ticket(), notes: [], pickupDispute: null, order: null, redeliveries: [] };
  let current: Record<string, unknown> = page0;
  let resolved: unknown = null;
  await page.route(`**/v1/admin/tickets/${id}?**`, (route) => route.fulfill({ json: current }));
  await page.route(`**/v1/admin/tickets/${id}/resolve`, (route) => {
    resolved = route.request().postDataJSON();
    current = {
      ...page0,
      status: 'resolved',
      resolution: {
        code: 'none_explained',
        responsible: 'restaurant',
        message,
        correctedLines: null,
        resolvedAt: new Date().toISOString(),
        resolvedByName: 'ليلى',
      },
    };
    return route.fulfill({ json: current });
  });

  await page.goto(`/tickets/${id}?city=AZ`);
  await page.getByRole('combobox', { name: 'الطرف المسؤول' }).selectOption('restaurant');
  const form = page.locator('form', { hasText: 'رسالة الحل' });
  await form.getByRole('combobox', { name: 'ردود جاهزة' }).selectOption('0');
  await form.getByRole('button', { name: 'إدراج' }).click();
  await form.getByRole('button', { name: 'حل التذكرة' }).click();

  await expect(page.getByText('لا شيء مع توضيح (المطعم)')).toBeVisible();
  expect(resolved).toEqual({
    cityId,
    resolution: 'none_explained',
    responsible: 'restaurant',
    message,
    receivedLines: null,
    affected: [],
    shortAmount: null,
    code: null,
    chargePay: false,
  });
  await expect(page.getByText(`الرسالة المرسلة: ${message}`)).toBeVisible();
});

// AP §8.10, §9.9.3, §6.4 (slice 2.23c): support resolves «صنف ناقص» after a
// normal delivery with the restaurant responsible: one item affected, the
// entries previewed, and a code for the customer, in minor units.
test('resolves a missing item with the restaurant responsible and a code', async ({ page }) => {
  await fakeSession(page, ['support.read', 'support.manage', 'operations.compensate']);
  const id = '01900000-0000-7000-8000-0000000000f2';
  const orderId = '01900000-0000-7000-8000-0000000000d1';
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/alerts**', (route) => route.fulfill({ json: { alerts: [] } }));
  await page.route('**/v1/admin/tickets/assignees', (route) =>
    route.fulfill({ json: { assignees: [] } }),
  );
  await page.route('**/v1/admin/tickets?**', (route) => route.fulfill({ json: { tickets: [] } }));
  await page.route('**/v1/admin/content/canned-replies', (route) =>
    route.fulfill({ json: { replies: [] } }),
  );
  await page.route(`**/v1/admin/orders/${orderId}/compensations`, (route) =>
    route.fulfill({
      json: {
        compensations: [],
        currency: 'TRY',
        capLeft: '7500',
        canCompensate: true,
        reasons: [{ code: 'missing_item', label: 'صنف ناقص' }],
      },
    }),
  );
  const page0 = {
    ...ticket({
      id,
      party: 'customer',
      partyName: 'سامر',
      orderId,
      orderNumber: '10021',
      typeCode: 'missing_item',
      typeLabel: 'صنف ناقص',
    }),
    notes: [],
    pickupDispute: null,
    order: {
      orderId,
      number: '10021',
      currency: 'TRY',
      total: '25000',
      itemsValue: '24000',
      deliveredNormally: true,
      lines: [{ position: 0, name: 'شاورما', quantity: 2, unitPrice: '12000', lineTotal: '24000' }],
      received: [{ currency: 'TRY', amount: '25000' }],
      change: [],
    },
    redeliveries: [],
  };
  let previewed: unknown = null;
  let resolved: unknown = null;
  await page.route(`**/v1/admin/tickets/${id}?**`, (route) => route.fulfill({ json: page0 }));
  await page.route(`**/v1/admin/tickets/${id}/money-preview`, (route) => {
    previewed = route.request().postDataJSON();
    return route.fulfill({
      json: {
        currency: 'TRY',
        affectedValue: '12000',
        merchantDebit: '10200',
        captainCharge: '0',
        entries: [],
        redelivery: null,
      },
    });
  });
  await page.route(`**/v1/admin/tickets/${id}/resolve`, (route) => {
    resolved = route.request().postDataJSON();
    return route.fulfill({ json: page0 });
  });

  await page.goto(`/tickets/${id}?city=AZ`);
  await expect(page.getByText('استلم الكابتن:', { exact: false })).toBeVisible();
  const form = page.locator('form', { hasText: 'رسالة الحل' });
  await expect(form.getByRole('combobox', { name: 'الحل' })).toHaveValue('compensation_code');
  await form.getByRole('combobox', { name: 'الطرف المسؤول' }).selectOption('restaurant');
  await form.getByRole('textbox', { name: 'شاورما (من 2)' }).fill('1');
  await expect(form.getByText('يُقيَّد على المطعم', { exact: false })).toBeVisible();
  await form.getByRole('textbox', { name: 'المبلغ (TRY)' }).fill('50');
  await form.getByRole('combobox', { name: 'السبب' }).selectOption('missing_item');
  await form.getByRole('textbox', { name: 'رسالة الحل' }).fill('نعتذر، أرسلنا لك كود تعويض.');
  await form.getByRole('button', { name: 'حل التذكرة' }).click();

  await expect.poll(() => resolved).not.toBeNull();
  expect(previewed).toMatchObject({
    cityId,
    responsible: 'restaurant',
    affected: [{ position: 0, quantity: 1 }],
    shortAmount: null,
    code: true,
  });
  expect(resolved).toEqual({
    cityId,
    resolution: 'compensation_code',
    responsible: 'restaurant',
    message: 'نعتذر، أرسلنا لك كود تعويض.',
    receivedLines: null,
    affected: [{ position: 0, quantity: 1 }],
    shortAmount: null,
    code: {
      value: { kind: 'fixed_amount', amount: '5000', percentBp: null, maxDiscount: null },
      reason: { code: 'missing_item', note: null },
    },
    chargePay: false,
  });
});
