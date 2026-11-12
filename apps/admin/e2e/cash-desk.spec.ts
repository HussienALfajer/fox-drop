import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const captainId = '01900000-0000-7000-8000-0000000000a1';
const sessionId = '01900000-0000-7000-8000-0000000000d1';
const receiptId = '01900000-0000-7000-8000-0000000000e1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};

const drawer = {
  id: sessionId,
  cityId,
  adminAccountId: '01900000-0000-7000-8000-000000000001',
  adminName: 'أمين الصندوق',
  kind: 'office',
  openedAt: '2026-11-12T06:00:00.000Z',
  closedAt: null,
  closeNote: null,
  currencies: [
    { currency: 'TRY', openingFloat: '50000', expected: '50000', counted: null, variance: null },
  ],
};

const receipt = {
  id: receiptId,
  cityId,
  number: 'AZ-2026-000001',
  type: 'captain_hand_in',
  sessionId,
  cashierId: drawer.adminAccountId,
  cashierName: 'أمين الصندوق',
  captainId,
  captainName: 'سامر خالد الحسن',
  createdAt: '2026-11-12T07:00:00.000Z',
  lines: [{ currency: 'TRY', expected: '41000', amount: '40000', remaining: '1000' }],
};

// AP §9.10.3 «الصندوق»: open the drawer with a float, find a captain, hand
// in part of their custody, and open the receipt to print.
test('opens the drawer, records a hand-in and shows the receipt', async ({ page }) => {
  // The permission alone: a role that receives no alerts keeps the sound
  // banner off the page.
  await fakeSession(page, ['cash_desk.record']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let open = false;
  let opened: unknown = null;
  await page.route('**/v1/admin/cash-desk/sessions/current*', (route) =>
    route.fulfill({ json: { session: open ? drawer : null, currencies: ['TRY'] } }),
  );
  await page.route('**/v1/admin/cash-desk/sessions', (route) => {
    opened = route.request().postDataJSON();
    open = true;
    return route.fulfill({ status: 201, json: drawer });
  });
  await page.route('**/v1/admin/cash-desk/captains?*', (route) =>
    route.fulfill({
      json: { captains: [{ id: captainId, name: 'سامر خالد الحسن', status: 'active' }] },
    }),
  );
  await page.route(`**/v1/admin/cash-desk/captains/${captainId}`, (route) =>
    route.fulfill({
      json: {
        id: captainId,
        name: 'سامر خالد الحسن',
        status: 'active',
        usage: { amount: '41000', currency: 'TRY' },
        limit: { amount: '300000', currency: 'TRY' },
        closedDue: { amount: '41000', currency: 'TRY' },
        lastCutoff: '2026-11-12T03:00:00.000Z',
        currencies: [
          {
            currency: 'TRY',
            balance: '41000',
            closedDue: '41000',
            today: '0',
            balanceInBase: '41000',
          },
        ],
      },
    }),
  );
  let handIn: { body: unknown; key: string | undefined } | null = null;
  await page.route('**/v1/admin/cash-desk/hand-ins', (route) => {
    handIn = {
      body: route.request().postDataJSON(),
      key: route.request().headers()['idempotency-key'],
    };
    return route.fulfill({ status: 201, json: { receipts: [receipt] } });
  });
  await page.route(`**/v1/admin/cash-desk/receipts/${receiptId}`, (route) =>
    route.fulfill({ json: receipt }),
  );
  await page.goto('/');

  await page.getByRole('link', { name: 'الصندوق' }).click();
  await page.getByLabel('المبلغ الافتتاحي (TRY)').fill('500');
  await page.getByRole('button', { name: 'فتح الصندوق' }).click();
  expect(opened).toEqual({ cityId, floats: [{ currency: 'TRY', amount: '50000' }] });

  await page.getByLabel('ابحث عن الكابتن بالاسم أو الرقم').fill('سامر');
  await page.getByRole('button', { name: 'سامر خالد الحسن' }).click();
  await page.getByLabel('المستلَم من الكابتن (TRY)').fill('400');
  await page.getByRole('button', { name: 'مراجعة' }).click();
  await expect(page.getByText('استلام')).toBeVisible();
  await page.getByRole('button', { name: 'تأكيد وإصدار الإيصال' }).click();
  await expect(page.getByRole('link', { name: 'صدر الإيصال AZ-2026-000001' })).toBeVisible();
  expect(handIn!.body).toEqual({ captainId, lines: [{ currency: 'TRY', amount: '40000' }] });
  expect(handIn!.key).toBeTruthy();

  await page.getByRole('link', { name: 'صدر الإيصال AZ-2026-000001' }).click();
  await expect(page.getByRole('heading', { name: 'إيصال AZ-2026-000001' })).toBeVisible();
  await expect(page.getByText('تسليم نقد')).toBeVisible();
  await expect(page.getByRole('button', { name: 'طباعة 80 مم' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'طباعة A4' })).toBeVisible();
});

test('keeps the desk from a role that does not record at it', async ({ page }) => {
  await fakeSession(page, ['operations.read']);
  await page.goto('/cash-desk');
  await expect(page).toHaveURL(/\/$/);
  await expect(page.getByRole('link', { name: 'الصندوق' })).toHaveCount(0);
});
