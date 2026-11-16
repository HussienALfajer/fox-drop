import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const request = {
  id: '01900000-0000-7000-8000-0000000000b1',
  orderId: '01900000-0000-7000-8000-0000000000d1',
  orderNumber: '10001',
  kind: 'fixed_amount',
  amount: '20000',
  percentBp: null,
  maxDiscount: null,
  currency: 'TRY',
  reason: { code: 'late', label: 'تأخير' },
  note: 'انتظر ساعة',
  status: 'waiting',
  requestedBy: 'سارة',
  requestedAt: '2026-11-17T10:00:00.000Z',
  decidedBy: null,
  decidedAt: null,
  code: null,
  codeValidTo: null,
};

// AP §6.4 «طلبات الموافقة» (slice 2.22a): OWN edits the value of a request
// above SUP's cap and approves it; the customer gets the code then.
test('approves a compensation request with an edited value', async ({ page }) => {
  await fakeSession(page, ['compensation.approve_above_cap']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  let sent: unknown = null;
  await page.route('**/v1/admin/compensations**', (route) => {
    const call = route.request();
    if (call.method() === 'GET') return route.fulfill({ json: { requests: [request] } });
    sent = call.postDataJSON();
    return route.fulfill({
      json: { ...request, amount: '10000', status: 'issued', code: 'K7M2PQRT' },
    });
  });
  await page.goto('/');
  await page.getByRole('link', { name: 'طلبات الموافقة: 1' }).click();
  await expect(page.getByText('الطلب #10001')).toBeVisible();
  await expect(page.getByText(/انتظر ساعة/)).toBeVisible();
  await page.getByRole('button', { name: 'تعديل القيمة' }).click();
  await page.getByLabel(/المبلغ/).fill('100');
  await page.getByRole('button', { name: 'موافقة بالقيمة الجديدة' }).click();
  await expect(page.getByText('تمت الموافقة وأُرسل الكود K7M2PQRT إلى الزبون.')).toBeVisible();
  expect(sent).toEqual({
    cityId,
    value: { kind: 'fixed_amount', amount: '10000', percentBp: null, maxDiscount: null },
  });
});
