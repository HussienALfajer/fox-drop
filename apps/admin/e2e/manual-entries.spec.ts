import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const captainId = '01900000-0000-7000-8000-0000000000a1';
const adminId = '01900000-0000-7000-8000-0000000000f1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const summary = (journalId: string, amount: string, manualEntryId: string | null) => ({
  journalId,
  type: 'earn.adjustment',
  reason: 'مكافأة نُسيت',
  createdAt: '2026-11-16T09:00:00.000Z',
  lines: [{ purpose: 'captain.earnings', currency: 'TRY', amount }],
  orderId: null,
  orderNumber: null,
  manualEntryId,
});

const adjustmentId = '01900000-0000-7000-8000-0000000000e1';
const reversalId = '01900000-0000-7000-8000-0000000000e2';
const adjustmentJournal = '01900000-0000-7000-8000-0000000000d1';
const reversalJournal = '01900000-0000-7000-8000-0000000000d2';

const entry = (reversed: boolean) => ({
  id: adjustmentId,
  kind: 'adjustment',
  partyKind: 'captain',
  partyId: captainId,
  partyName: 'أحمد الكابتن',
  reason: 'مكافأة نُسيت',
  adminId,
  adminName: 'سارة',
  createdAt: '2026-11-16T09:00:00.000Z',
  journal: summary(adjustmentJournal, '50000', adjustmentId),
  corrects: null,
  reversedBy: reversed
    ? { journalId: reversalJournal, manualEntryId: reversalId, at: '2026-11-16T10:00:00.000Z' }
    : null,
  reversible: !reversed,
});

const reversal = {
  id: reversalId,
  kind: 'reversal',
  partyKind: 'captain',
  partyId: captainId,
  partyName: 'أحمد الكابتن',
  reason: 'صُرفت سابقاً',
  adminId,
  adminName: 'سارة',
  createdAt: '2026-11-16T10:00:00.000Z',
  journal: { ...summary(reversalJournal, '-50000', reversalId), reason: 'صُرفت سابقاً' },
  corrects: summary(adjustmentJournal, '50000', adjustmentId),
  reversedBy: null,
  reversible: false,
};

// AP §9.10.7: the owner adjusts a captain's earnings, reverses it, and sees
// both linked in the list.
test('adjusts a captain’s earnings, reverses it and lists both linked', async ({ page }) => {
  await fakeSession(page, ['ledger.manual_adjustment']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let state: 'none' | 'adjusted' | 'reversed' = 'none';
  const sent: { url: string; body: unknown; key: string | undefined }[] = [];
  await page.route('**/v1/admin/manual-entries**', (route) => {
    const request = route.request();
    const url = new URL(request.url());
    if (url.pathname.endsWith('/parties/search')) {
      return route.fulfill({ json: { parties: [{ id: captainId, name: 'أحمد الكابتن' }] } });
    }
    if (url.pathname.endsWith('/account')) {
      return route.fulfill({
        json: {
          partyId: captainId,
          partyName: 'أحمد الكابتن',
          balances: [{ currency: 'TRY', amount: state === 'adjusted' ? '50000' : '0' }],
          entries: [],
          currencies: ['TRY'],
        },
      });
    }
    if (request.method() === 'POST') {
      sent.push({
        url: url.pathname,
        body: request.postDataJSON(),
        key: request.headers()['idempotency-key'],
      });
      if (url.pathname.endsWith('/reversals')) {
        state = 'reversed';
        return route.fulfill({ status: 201, json: reversal });
      }
      state = 'adjusted';
      return route.fulfill({ status: 201, json: entry(false) });
    }
    const entries =
      state === 'none' ? [] : state === 'adjusted' ? [entry(false)] : [reversal, entry(true)];
    return route.fulfill({ json: { entries } });
  });

  await page.goto('/manual-entries');
  await expect(page.getByRole('heading', { name: 'القيود التصحيحية', level: 1 })).toBeVisible();
  await expect(page.getByText('لا قيود تصحيحية بعد.')).toBeVisible();

  await page.getByLabel('ابحث بالاسم أو الرقم').fill('أحمد');
  await page.getByRole('button', { name: 'اختيار أحمد الكابتن' }).click();
  await page.getByLabel('الحساب').selectOption('captain.earnings');
  await page.getByLabel('يزيد مستحقات الكابتن').check();
  await page.getByLabel('المبلغ').fill('500');
  await page.getByLabel('السبب', { exact: true }).fill('مكافأة نُسيت');
  await page.getByRole('button', { name: 'مراجعة' }).click();
  await expect(page.getByText('سيُسجَّل قيد: يزيد مستحقات الكابتن')).toBeVisible();
  await page.getByRole('button', { name: 'تأكيد القيد' }).click();
  await expect(page.getByText('سُجّل القيد.')).toBeVisible();

  const list = page.locator('section', { hasText: 'سجل القيود التصحيحية' });
  await expect(list.getByText('بواسطة سارة')).toBeVisible();
  await list.getByRole('button', { name: 'عكس القيد' }).click();
  await list.getByLabel('سبب العكس').fill('صُرفت سابقاً');
  await list.getByRole('button', { name: 'تأكيد العكس' }).click();

  await expect(list.getByRole('heading', { name: /عكس قيد/ })).toBeVisible();
  await expect(list.getByRole('link', { name: 'القيد الأصلي' })).toHaveAttribute(
    'href',
    `#entry-${adjustmentId}`,
  );
  await expect(list.getByRole('link', { name: 'قيد العكس' })).toHaveAttribute(
    'href',
    `#entry-${reversalId}`,
  );
  expect(sent.map(({ url, body }) => [url, body])).toEqual([
    [
      '/v1/admin/manual-entries',
      {
        cityId,
        party: 'captain',
        partyId: captainId,
        account: 'captain.earnings',
        currency: 'TRY',
        amount: '50000',
        reason: 'مكافأة نُسيت',
      },
    ],
    [
      '/v1/admin/manual-entries/reversals',
      { cityId, journalId: adjustmentJournal, reason: 'صُرفت سابقاً' },
    ],
  ]);
  expect(sent.every(({ key }) => typeof key === 'string' && key.length > 0)).toBe(true);
});
