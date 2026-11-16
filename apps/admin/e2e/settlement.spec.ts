import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const captainId = '01900000-0000-7000-8000-0000000000a1';
const sessionId = '01900000-0000-7000-8000-0000000000d1';
const statementId = '01900000-0000-7000-8000-0000000000f1';
const cashierId = '01900000-0000-7000-8000-000000000001';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};

const drawer = {
  id: sessionId,
  cityId,
  adminAccountId: cashierId,
  adminName: 'أمين الصندوق',
  kind: 'office',
  openedAt: '2026-11-12T06:00:00.000Z',
  closedAt: null,
  closeNote: null,
  currencies: [
    { currency: 'TRY', openingFloat: '50000', expected: '50000', counted: null, variance: null },
  ],
};

const balance = {
  captainId,
  name: 'سامر خالد الحسن',
  status: 'active',
  custodyInBase: '30000',
  usage: { amount: '30000', currency: 'TRY' },
  limit: { amount: '300000', currency: 'TRY' },
  closedDue: { amount: '30000', currency: 'TRY' },
  lastCutoff: '2026-11-12T03:00:00.000Z',
  currencies: [
    { currency: 'TRY', balance: '30000', closedDue: '30000', today: '0', balanceInBase: '30000' },
  ],
  blocks: [],
  handInGrace: null,
  earnings: { amount: '50000', currency: 'TRY' },
  lastHandInAt: null,
  lastPayoutAt: null,
};

const receipt = (id: string, number: string, type: string, line: object) => ({
  id,
  cityId,
  number,
  type,
  sessionId,
  cashierId,
  cashierName: 'أمين الصندوق',
  captainId,
  captainName: 'سامر خالد الحسن',
  createdAt: '2026-11-12T10:00:00.000Z',
  conversions: [],
  lines: [line],
});

const statement = {
  id: statementId,
  cityId,
  captainId,
  captainName: 'سامر خالد الحسن',
  sessionId,
  cashierId,
  periodFrom: null,
  createdAt: '2026-11-12T10:00:00.000Z',
  currency: 'TRY',
  orders: 12,
  basePay: '45000',
  distancePay: '0',
  waitingPay: '2000',
  peakBonus: '5000',
  bonuses: '0',
  charges: '2000',
  instalments: '0',
  adjustments: '0',
  carriedIn: '0',
  balance: '50000',
  paid: '50000',
  payout: { currency: 'TRY', amount: '50000' },
  collected: '0',
  carriedOut: '0',
  offCycle: false,
  reason: null,
  receiptIds: [],
};

// AP §8.5.5, §9.10.3 «تصفية الخميس»: the list, the captain's settlement with
// the custody netted against the payout (300 ₺ owed, 500 ₺ earned: the
// captain receives 200 ₺), the receipts and the statement.
test('settles a captain on Thursday and shows the statement', async ({ page }) => {
  // The permission alone (the role receives no alerts, so no sound banner).
  await fakeSession(page, ['cash_desk.record']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/cash-desk/sessions/current*', (route) =>
    route.fulfill({ json: { session: drawer, field: null, currencies: ['TRY'] } }),
  );
  await page.route('**/v1/admin/cash-desk/settlements?*', (route) =>
    route.fulfill({
      json: {
        payoutDay: true,
        payoutWeekday: 'thursday',
        policy: 'carry_forward',
        captains: [balance],
      },
    }),
  );
  await page.route('**/v1/admin/cash-desk/settlements/preview', (route) =>
    route.fulfill({
      json: {
        captainId,
        name: 'سامر خالد الحسن',
        cityId,
        payoutDay: true,
        payoutWeekday: 'thursday',
        policy: 'carry_forward',
        custody: [{ currency: 'TRY', balance: '30000', balanceInBase: '30000' }],
        earnings: { amount: '50000', currency: 'TRY' },
        payout: { currency: 'TRY', amount: '50000', rates: [], unit: null },
        collect: null,
        net: [{ currency: 'TRY', amount: '-20000' }],
      },
    }),
  );
  let settled: unknown = null;
  await page.route('**/v1/admin/cash-desk/settlements', (route) => {
    settled = route.request().postDataJSON();
    return route.fulfill({
      status: 201,
      json: {
        statement,
        receipts: [
          receipt('01900000-0000-7000-8000-0000000000e1', 'AZ-2026-000001', 'captain_hand_in', {
            currency: 'TRY',
            expected: '30000',
            amount: '30000',
            remaining: '0',
          }),
          receipt('01900000-0000-7000-8000-0000000000e2', 'AZ-2026-000002', 'captain_payout', {
            currency: 'TRY',
            expected: '-50000',
            amount: '50000',
            remaining: '0',
          }),
        ],
      },
    });
  });
  await page.route(`**/v1/admin/cash-desk/statements/${statementId}`, (route) =>
    route.fulfill({ json: statement }),
  );

  await page.goto('/cash-desk/settlements');
  await expect(page.getByText('اليوم يوم الصرف (الخميس).')).toBeVisible();
  await page.getByRole('link', { name: 'تصفية', exact: true }).click();
  await expect(page.getByText(/يستلم الكابتن/)).toBeVisible();
  await page.getByRole('button', { name: 'تأكيد التصفية' }).click();
  await expect(page.getByRole('heading', { name: 'تمت التصفية' })).toBeVisible();
  expect(settled).toEqual({
    captainId,
    custody: [{ currency: 'TRY', balance: '30000' }],
    earnings: '50000',
    payout: { currency: 'TRY', amount: '50000', rates: [] },
    reason: null,
  });
  await expect(page.getByRole('link', { name: /AZ-2026-000002: صرف المستحقات/ })).toBeVisible();
  await page.getByRole('link', { name: 'كشف الأسبوع' }).click();
  await expect(page.getByText('عدد الطلبات: 12')).toBeVisible();
  await expect(page.getByRole('button', { name: 'طباعة A4' })).toBeVisible();
});
