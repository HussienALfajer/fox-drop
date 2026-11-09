import { expect, type Page, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const orderId = '01900000-0000-7000-8000-0000000000d1';
const captainId = '01900000-0000-7000-8000-0000000000e1';
const later = (minutes: number) => new Date(Date.now() + minutes * 60_000).toISOString();

const card = {
  id: orderId,
  number: '10001',
  status: 'ready',
  version: 4,
  placedAt: later(-20),
  restaurant: { id: '01900000-0000-7000-8000-0000000000f1', name: 'مطعم الشام' },
  neighbourhood: 'الحي الأول',
  statusSince: later(-16),
  limitAt: later(-1),
  captainTrack: 'searching',
  captain: null,
  total: { amount: '1250', currency: 'USD' },
  badges: { needsAssignment: true, note: false, newCustomer: true, pickupPending: false },
  moments: {
    acceptAlertAt: null,
    prepLateAlertAt: null,
    searchStartedAt: later(-10),
    searchAlertAt: later(-5),
    noCaptainAlertAt: later(-1),
    captainArrivedAt: null,
    captainWaitingAlertAt: null,
  },
  alerts: ['no_captain', 'no_captain_after_ready'],
};

const detail = {
  ...card,
  promisedAt: later(20),
  acceptance: { at: later(-30), prepMin: 15, prepDueAt: later(-15) },
  readyAt: later(-16),
  cancellation: null,
  rejection: null,
  onBehalf: null,
  cancelChoices: null,
  customer: {
    name: 'أحمد',
    address: {
      location: { latitude: 36.58, longitude: 37.04 },
      neighbourhood: 'الحي الأول',
      street: 'شارع السوق',
      floor: null,
      landmark: 'قرب الجامع',
      directions: null,
    },
    recipientName: null,
    payIn: null,
    arrival: null,
  },
  note: null,
  lines: [
    {
      itemId: '01900000-0000-7000-8000-0000000000b1',
      name: 'شاورما',
      quantity: 2,
      options: [],
      note: null,
      unitPrice: '500',
      lineTotal: '1000',
    },
  ],
  money: {
    currency: 'USD',
    itemsValue: '1000',
    deliveryFee: '250',
    discount: '0',
    rounding: '0',
    total: '1250',
    pickupPayment: '1000',
  },
  pickup: { at: null, readyNotPressed: false, requests: [], dispute: null },
  delivery: null,
  timeline: [
    {
      version: 1,
      at: later(-20),
      type: 'order.placed',
      from: null,
      to: 'placed',
      actor: { type: 'customer', id: null },
      captainId: null,
      reason: null,
    },
  ],
};

const picker = {
  captains: [
    {
      captainId,
      name: 'سامر',
      vehicle: 'motorbike',
      eligible: true,
      reasons: [],
      distanceMetres: 850,
      etaMin: 3,
      ordersToday: 2,
      custody: {
        usage: { amount: '2000', currency: 'USD' },
        limit: { amount: '10000', currency: 'USD' },
      },
      acceptanceRate: 90,
    },
    {
      captainId: '01900000-0000-7000-8000-0000000000e2',
      name: 'خالد',
      vehicle: 'car',
      eligible: false,
      reasons: ['busy'],
      distanceMetres: 1200,
      etaMin: 4,
      ordersToday: 5,
      custody: {
        usage: { amount: '0', currency: 'USD' },
        limit: { amount: '10000', currency: 'USD' },
      },
      acceptanceRate: null,
    },
  ],
};

async function fakeOperations(page: Page) {
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/orders?*', (route) => route.fulfill({ json: { orders: [card] } }));
  await page.route(`**/v1/admin/orders/${orderId}`, (route) =>
    route.fulfill({ json: { order: detail } }),
  );
  await page.route(`**/v1/admin/orders/${orderId}/captains`, (route) =>
    route.fulfill({ json: picker }),
  );
}

// AP §9.2, §9.3.2: the owner assigns a captain from the panel.
test('opens a late order from the board and offers it to a captain', async ({ page }) => {
  await fakeSession(page, ['operations.read', 'operations.manage']);
  await fakeOperations(page);
  let boardCity: string | null = null;
  await page.route('**/v1/admin/orders?*', (route) => {
    boardCity = new URL(route.request().url()).searchParams.get('cityId');
    return route.fulfill({ json: { orders: [card] } });
  });
  let sent: { body: unknown; key: string | undefined } | undefined;
  await page.route(`**/v1/admin/orders/${orderId}/assign`, (route) => {
    sent = {
      body: route.request().postDataJSON(),
      key: route.request().headers()['idempotency-key'],
    };
    return route.fulfill({
      json: {
        order: {
          id: orderId,
          number: '10001',
          status: 'ready',
          version: 5,
          captainTrack: 'offered',
          captainId: null,
          offer: { id: '01900000-0000-7000-8000-0000000000a9', captainId, expiresAt: later(1) },
        },
      },
    });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'غرفة العمليات' }).click();
  const ready = page.getByRole('region', { name: 'جاهز' });
  await expect(ready.getByRole('heading', { level: 2 })).toHaveText('جاهز: 1 (متأخر 1)');
  await expect(ready.getByText('تجاوز الحد')).toBeVisible();
  await expect(ready.getByText('جاهز بلا كابتن')).toBeVisible();
  await expect(ready.getByText('بحاجة لتعيين')).toBeVisible();
  expect(boardCity).toBe(cityId);

  await page.getByRole('link', { name: '#10001' }).click();
  const panel = page.getByRole('complementary', { name: 'تفاصيل الطلب' });
  await expect(panel.getByRole('heading', { name: '#10001' })).toBeVisible();
  await expect(panel.getByText('أُنشئ الطلب')).toBeVisible();
  await expect(ready).toBeVisible();
  await expect(page).toHaveURL(`/orders/${orderId}?city=AZ`);

  await panel.getByRole('link', { name: 'تعيين كابتن' }).click();
  await expect(panel.getByText('مشغول')).toBeVisible();
  await expect(panel.getByRole('button', { name: 'تعيين خالد' })).toHaveCount(0);
  await panel.getByRole('button', { name: 'تعيين سامر' }).click();

  await expect(page.getByRole('status')).toContainText('أُرسل العرض إلى الكابتن');
  expect(sent?.body).toEqual({ captainId });
  expect(sent?.key).toMatch(/^[\w-]{16,128}$/);
});

// Architecture §5.3: a retry after a lost answer replays the same command.
test('sends the same Idempotency-Key again after a lost answer', async ({ page }) => {
  await fakeSession(page, ['operations.read', 'operations.manage']);
  await fakeOperations(page);
  const keys: (string | undefined)[] = [];
  await page.route(`**/v1/admin/orders/${orderId}/assign`, (route) => {
    keys.push(route.request().headers()['idempotency-key']);
    if (keys.length === 1) return route.abort('failed');
    return route.fulfill({
      json: {
        order: {
          id: orderId,
          number: '10001',
          status: 'ready',
          version: 5,
          captainTrack: 'assigned',
          captainId,
          offer: null,
        },
      },
    });
  });
  await page.goto(`/orders/${orderId}/assign`);

  await page.getByRole('button', { name: 'تعيين سامر' }).click();
  await expect(page.getByRole('alert')).toHaveText('تعذّر إكمال الطلب. حاول مرة أخرى.');
  await page.getByRole('button', { name: 'تعيين سامر' }).click();

  await expect(page.getByRole('status')).toHaveText('تم تعيين الكابتن.');
  expect(keys).toHaveLength(2);
  expect(keys[1]).toBe(keys[0]);
});

test('says why a captain can no longer take the order', async ({ page }) => {
  await fakeSession(page, ['operations.read', 'operations.manage']);
  await fakeOperations(page);
  await page.route(`**/v1/admin/orders/${orderId}/assign`, (route) =>
    route.fulfill({
      status: 409,
      json: { statusCode: 409, error: 'captain_not_eligible', reasons: ['cash_limit'] },
    }),
  );
  await page.goto(`/orders/${orderId}/assign`);

  await page.getByRole('button', { name: 'تعيين سامر' }).click();
  await expect(page.getByRole('alert')).toHaveText('هذا الكابتن لم يعد متاحًا: تجاوز حد النقد');
});

test('shows the board without «تعيين كابتن» to a role that only reads', async ({ page }) => {
  await fakeSession(page, ['operations.read']);
  await fakeOperations(page);
  await page.goto(`/orders/${orderId}`);
  await expect(
    page.getByRole('complementary').getByRole('heading', { name: '#10001' }),
  ).toBeVisible();
  await expect(page.getByRole('link', { name: 'تعيين كابتن' })).toHaveCount(0);

  await page.goto(`/orders/${orderId}/assign`);
  await expect(page).toHaveURL(/\/$/);
});

test('is hidden and closed without operations', async ({ page }) => {
  await fakeSession(page, []);
  await page.goto('/');
  await expect(page.getByRole('status')).toHaveText('الخادم يعمل');
  await expect(page.getByRole('link', { name: 'غرفة العمليات' })).toHaveCount(0);

  await page.goto('/orders');
  await expect(page).toHaveURL(/\/$/);
});

// AP §9.3.2 «رفض نيابة عن المطعم»: a placed order, rejected with an item the
// restaurant says is out, and operations' note.
test('rejects a placed order for the restaurant with its items and a reason', async ({ page }) => {
  await fakeSession(page, ['operations.read', 'operations.manage']);
  await fakeOperations(page);
  const placed = {
    ...detail,
    status: 'placed',
    captainTrack: null,
    promisedAt: null,
    acceptance: null,
    readyAt: null,
    onBehalf: {
      prepTime: { options: [10, 15, 20], stepMin: 5, floorMin: 5, ceilingMin: 90, defaultMin: 20 },
      rejectionReasons: [
        { code: 'item_unavailable', label: 'صنف غير متوفر' },
        { code: 'restaurant_closed', label: 'المطعم مغلق' },
        { code: 'too_busy', label: 'ضغط طلبات' },
      ],
      busyExtraOptionsMin: [10, 20],
    },
  };
  await page.route(`**/v1/admin/orders/${orderId}`, (route) =>
    route.fulfill({ json: { order: placed } }),
  );
  let sent: unknown;
  await page.route(`**/v1/admin/orders/${orderId}/reject`, (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({ status: 409, json: { statusCode: 409, error: 'order_state_changed' } });
  });
  await page.goto(`/orders/${orderId}`);

  const reject = page.getByRole('form', { name: 'رفض نيابة عن المطعم' });
  const confirm = reject.getByRole('button', { name: 'تأكيد الرفض' });
  await reject.getByRole('radio', { name: 'صنف غير متوفر' }).check();
  await reject.getByRole('checkbox', { name: 'شاورما' }).check();
  await reject.getByRole('combobox').selectOption('turned_back_on');
  await expect(confirm).toBeDisabled();
  await reject.getByRole('textbox', { name: 'السبب (للسجل الداخلي)' }).fill('اتصل المطعم');
  await confirm.click();

  await expect(page.getByRole('alert')).toHaveText('تغيّرت حالة الطلب قبل وصول قرارك');
  expect(sent).toEqual({
    rejection: 'item_unavailable',
    items: [{ itemId: '01900000-0000-7000-8000-0000000000b1', until: 'turned_back_on' }],
    busyExtraMin: null,
    pauseMin: null,
    reason: 'اتصل المطعم',
  });
});

// AP §9.3.2 «قبول نيابة عن المطعم»: any whole minute within the limits, then
// the detail read again shows the order accepted.
test('accepts a placed order for the restaurant with a typed prep time', async ({ page }) => {
  await fakeSession(page, ['operations.read', 'operations.manage']);
  await fakeOperations(page);
  const placed = {
    ...detail,
    status: 'placed',
    captainTrack: null,
    promisedAt: null,
    acceptance: null,
    readyAt: null,
    onBehalf: {
      prepTime: { options: [10, 15, 20], stepMin: 5, floorMin: 5, ceilingMin: 90, defaultMin: 20 },
      rejectionReasons: [{ code: 'too_busy', label: 'ضغط طلبات' }],
      busyExtraOptionsMin: [10, 20],
    },
  };
  let accepted = false;
  await page.route(`**/v1/admin/orders/${orderId}`, (route) =>
    route.fulfill({ json: { order: accepted ? detail : placed } }),
  );
  let sent: unknown;
  await page.route(`**/v1/admin/orders/${orderId}/accept`, (route) => {
    sent = route.request().postDataJSON();
    accepted = true;
    return route.fulfill({ json: { order: card } });
  });
  await page.goto(`/orders/${orderId}`);

  const accept = page.getByRole('form', { name: 'قبول نيابة عن المطعم' });
  await accept.getByRole('spinbutton', { name: 'وقت التحضير (دقائق)' }).fill('23');
  await accept.getByRole('textbox', { name: 'السبب (للسجل الداخلي)' }).fill('المطعم لا يرد');
  await accept.getByRole('button', { name: 'تأكيد القبول' }).click();

  await expect(page.getByRole('form', { name: 'قبول نيابة عن المطعم' })).toHaveCount(0);
  expect(sent).toEqual({ prepMin: 23, reason: 'المطعم لا يرد' });
});

// AP §9.3.1: a rejected order shows its reason, the items and what the
// customer sees.
test('shows a rejection by operations in the detail', async ({ page }) => {
  await fakeSession(page, ['operations.read', 'operations.manage']);
  await fakeOperations(page);
  await page.route(`**/v1/admin/orders/${orderId}`, (route) =>
    route.fulfill({
      json: {
        order: {
          ...detail,
          status: 'rejected',
          captainTrack: null,
          promisedAt: null,
          acceptance: null,
          readyAt: null,
          rejection: {
            at: later(-5),
            reason: 'item_unavailable',
            label: 'صنف غير متوفر',
            customerText: 'بعض الأصناف غير متوفرة: شاورما',
            itemIds: ['01900000-0000-7000-8000-0000000000b1'],
            byOperations: true,
          },
        },
      },
    }),
  );
  await page.goto(`/orders/${orderId}`);
  const panel = page.getByRole('complementary', { name: 'تفاصيل الطلب' });
  await expect(panel.getByText('سبب الرفض: صنف غير متوفر')).toBeVisible();
  await expect(panel.getByText('رفضته العمليات نيابة عن المطعم')).toBeVisible();
  await expect(panel.getByText('الأصناف غير المتوفرة: شاورما')).toBeVisible();
  await expect(panel.getByText('ما يراه الزبون: «بعض الأصناف غير متوفرة: شاورما»')).toBeVisible();
  await expect(panel.getByRole('form', { name: 'رفض نيابة عن المطعم' })).toHaveCount(0);
});

// AP §9.3.2 «إلغاء الطلب», docs/domain/09: the captain at the restaurant, so
// the cash question and «تعويض الكابتن» appear, and the preview names every
// entry before the confirm.
test('cancels a ready order with the cash question and the preview of its entries', async ({
  page,
}) => {
  await fakeSession(page, ['operations.read', 'operations.manage']);
  await fakeOperations(page);
  const ready = {
    ...detail,
    cancelChoices: {
      reasons: [
        { code: 'customer_request', label: 'طلب الزبون' },
        { code: 'emergency', label: 'ظرف طارئ' },
      ],
    },
  };
  await page.route(`**/v1/admin/orders/${orderId}`, (route) =>
    route.fulfill({ json: { order: ready } }),
  );
  const restaurant = { kind: 'merchant', id: card.restaurant.id, name: 'مطعم الشام' };
  const platform = { kind: 'platform', id: null, name: null };
  const captain = { kind: 'captain', id: captainId, name: 'سامر' };
  const entry = (type: string, account: string, party: object, amount: string) => ({
    type,
    account,
    party,
    amount: { amount, currency: 'USD' },
  });
  await page.route(`**/v1/admin/orders/${orderId}/cancel-preview`, (route) => {
    const body = route.request().postDataJSON();
    const entries = [];
    if (body.foodPrepared && body.responsible !== 'restaurant') {
      entries.push(
        entry('merchant.credit', 'merchant.account', restaurant, '-850'),
        entry('merchant.credit', 'platform.order_clearing', platform, '850'),
        entry('platform.operating_cost', 'platform.operating_cost', platform, '850'),
        entry('platform.operating_cost', 'platform.order_clearing', platform, '-850'),
      );
    }
    if (body.compensateCaptain) {
      entries.push(
        entry('earn.order_pay', 'captain.earnings', captain, '-150'),
        entry('earn.order_pay', 'platform.operating_cost', platform, '150'),
      );
    }
    if (body.cash === 'not_returned') {
      entries.push(
        entry('custody.pay_merchant', 'captain.custody', captain, '-1000'),
        entry('custody.pay_merchant', 'platform.order_clearing', platform, '1000'),
        entry('merchant.debit', 'merchant.account', restaurant, '1000'),
        entry('merchant.debit', 'platform.order_clearing', platform, '-1000'),
      );
    }
    return route.fulfill({
      json: {
        entries,
        cashAsked: true,
        compensationAllowed: true,
        cashLines: [{ amount: '1000', currency: 'USD' }],
        strike: body.responsible === 'customer',
      },
    });
  });
  let sent: unknown;
  await page.route(`**/v1/admin/orders/${orderId}/cancel`, (route) => {
    sent = route.request().postDataJSON();
    return route.fulfill({ json: { order: card } });
  });
  await page.goto(`/orders/${orderId}`);

  const cancel = page.getByRole('form', { name: 'إلغاء الطلب' });
  const confirm = cancel.getByRole('button', { name: 'تأكيد الإلغاء' });
  await expect(cancel.getByText('اختر المسؤول لتظهر القيود')).toBeVisible();
  await cancel.getByRole('radio', { name: 'طلب الزبون' }).check();
  await cancel.getByRole('radio', { name: 'الزبون', exact: true }).check();
  await expect(cancel.getByText('تُسجَّل على الزبون مخالفة إلغاء متأخر.')).toBeVisible();
  await cancel.getByRole('checkbox', { name: 'تم تحضير الطعام؟' }).check();
  await cancel.getByRole('checkbox', { name: 'تعويض الكابتن' }).check();
  await expect(cancel.getByText(/دفع الكابتن للمطعم: .*10\.00.*/)).toBeVisible();
  await cancel.getByRole('radio', { name: 'لا', exact: true }).check();
  await expect(
    cancel.getByText(
      /يُقيَّد للمطعم «مطعم الشام» .*8\.50.* \(حساب المطعم\): تعويض عن طلب أُلغي بعد التحضير\./,
    ),
  ).toBeVisible();
  await expect(cancel.getByText(/تتحمّل المنصة .*8\.50.* \(كلفة تشغيلية\)\./)).toBeVisible();
  await expect(
    cancel.getByText(
      /يُقيَّد للكابتن «سامر» أجر .*1\.50.* \(مستحقات\) على المنصة \(كلفة تشغيلية\)\./,
    ),
  ).toBeVisible();
  await expect(cancel.getByText(/يُعاد للكابتن «سامر» .*10\.00.* \(عهدة\)\./)).toBeVisible();
  await expect(
    cancel.getByText(
      /يُسجَّل على المطعم «مطعم الشام» .*10\.00.* \(حساب المطعم\): دفعة الاستلام التي لم يُعِدها\./,
    ),
  ).toBeVisible();
  await expect(confirm).toBeDisabled();
  await cancel.getByRole('textbox', { name: 'السبب (للسجل الداخلي)' }).fill('اتصل الزبون');
  await confirm.click();

  await expect
    .poll(() => sent)
    .toEqual({
      cancellation: 'customer_request',
      responsible: 'customer',
      foodPrepared: true,
      compensateCaptain: true,
      cash: 'not_returned',
      reason: 'اتصل الزبون',
    });
});

// AP §9.3.1 «cancellation (reason and party)».
test('shows a cancellation by operations in the detail and its timeline', async ({ page }) => {
  await fakeSession(page, ['operations.read']);
  await fakeOperations(page);
  const adminId = '01900000-0000-7000-8000-0000000000a9';
  await page.route(`**/v1/admin/orders/${orderId}`, (route) =>
    route.fulfill({
      json: {
        order: {
          ...detail,
          status: 'cancelled',
          cancellation: {
            at: later(-2),
            reason: 'emergency',
            label: 'ظرف طارئ',
            note: 'انقطاع الكهرباء',
            customerText: 'ظرف طارئ منعنا من إكمال طلبك',
            by: { type: 'admin', id: adminId },
            responsible: 'platform',
            foodPrepared: true,
            cash: 'returned',
            merchantCredit: { amount: '850', currency: 'USD' },
            captainCompensation: { amount: '150', currency: 'USD' },
            acknowledgedAt: later(-1),
            captainSeenAt: null,
          },
          timeline: [
            ...detail.timeline,
            {
              version: 2,
              at: later(-2),
              type: 'order.cancelled',
              from: 'ready',
              to: 'cancelled',
              actor: { type: 'admin', id: adminId },
              captainId: null,
              reason: 'انقطاع الكهرباء',
            },
          ],
        },
      },
    }),
  );
  await page.goto(`/orders/${orderId}`);
  const panel = page.getByRole('complementary', { name: 'تفاصيل الطلب' });
  await expect(panel.getByText('سبب الإلغاء: ظرف طارئ')).toBeVisible();
  await expect(panel.getByText('ألغاه: الإدارة')).toBeVisible();
  await expect(panel.getByText('ملاحظة العمليات: انقطاع الكهرباء')).toBeVisible();
  await expect(panel.getByText('ما يراه الزبون: «ظرف طارئ منعنا من إكمال طلبك»')).toBeVisible();
  await expect(panel.getByText('هل أعاد المطعم المبلغ للكابتن؟ نعم')).toBeVisible();
  await expect(panel.getByText(/تعويض المطعم: .*8\.50.*/)).toBeVisible();
  await expect(panel.getByText(/تعويض الكابتن: .*1\.50.*/)).toBeVisible();
  const cancelled = panel.getByRole('listitem').filter({ hasText: 'المسؤول: المنصة' });
  await expect(cancelled).toContainText('ظرف طارئ');
  await expect(cancelled).toContainText('انقطاع الكهرباء');
  await expect(panel.getByRole('form', { name: 'إلغاء الطلب' })).toHaveCount(0);
});
