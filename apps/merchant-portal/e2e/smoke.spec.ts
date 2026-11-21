import { expect, type Page, test } from '@playwright/test';

// The portal's API is answered here, so the smoke test needs no server.
const session = {
  accountId: '0190f3a0-0000-7000-8000-000000000001',
  restaurantId: '0190f3a0-0000-7000-8000-000000000002',
  name: 'سامر',
  sessionId: '0190f3a0-0000-7000-8000-000000000003',
  restaurantName: 'مطعم التجربة',
  timeZone: 'Asia/Damascus',
};

function boardOrder(minutesAgo: number) {
  const placedAt = new Date(Date.now() - minutesAgo * 60_000).toISOString();
  return {
    id: '0190f3a0-0000-7000-8000-000000000010',
    number: '10001',
    redeliveryOf: null,
    testOrder: false,
    status: 'placed',
    version: 1,
    placedAt,
    acceptAlertAt: new Date(Date.now() + 60_000).toISOString(),
    autoCancelAt: new Date(Date.now() + 180_000).toISOString(),
    acceptance: null,
    readyAt: null,
    customer: { firstName: 'رامي', neighbourhood: 'الحي الشمالي' },
    note: null,
    lines: [
      {
        itemId: '0190f3a0-0000-7000-8000-000000000011',
        name: 'شاورما',
        quantity: 2,
        options: [],
        note: null,
        lineTotal: '20000',
      },
    ],
    currency: 'TRY',
    itemsValue: '20000',
    owner: null,
    captainTrack: null,
    captain: null,
    captainArrival: null,
    itemReport: null,
    edits: [],
    cancellation: null,
    pickup: {
      request: null,
      pickedUpAt: null,
      readyNotPressed: false,
      disputeUntil: null,
      disputedAt: null,
    },
  };
}

async function signedOutApi(page: Page) {
  let signedIn = false;
  await page.route('**/v1/merchant/auth/portal/session', (route) =>
    signedIn ? route.fulfill({ json: session }) : route.fulfill({ status: 401, json: {} }),
  );
  await page.route('**/v1/merchant/auth/portal/code', (route) =>
    route.fulfill({
      json: { channel: 'whatsapp', resendAfterSec: 60, expiresAt: new Date().toISOString() },
    }),
  );
  await page.route('**/v1/merchant/auth/portal/sign-in', (route) => {
    signedIn = true;
    return route.fulfill({ json: { ...session, expiresAt: new Date().toISOString() } });
  });
  await page.route('**/v1/merchant/orders', (route) =>
    route.fulfill({ json: { orders: [boardOrder(2)], prepTime: {} } }),
  );
  await page.route('**/v1/merchant/terms', (route) =>
    route.fulfill({
      json: { version: 1, body: 'الشروط', publishedAt: new Date().toISOString(), pending: false },
    }),
  );
  await page.route('**/v1/merchant/restaurant/status', (route) =>
    route.fulfill({
      json: {
        state: 'open',
        pauseSource: null,
        stateUntil: null,
        closesAt: null,
        opensAt: null,
        busyMode: null,
        activeOrders: null,
        maxActiveOrders: null,
        holiday: null,
        pauseChoicesMin: [15, 30, 60],
        busyExtraOptionsMin: [10, 20],
        busyReminderMin: 60,
      },
    }),
  );
  await page.route('**/v1/merchant/emergency-stop', (route) =>
    route.fulfill({ json: { active: false, startedAt: null } }),
  );
  await page.route('**/v1/merchant/account/overdue', (route) =>
    route.fulfill({ json: { overdue: null } }),
  );
  // Real time is down in the smoke test: the board polls.
  await page.route('**/v1/merchant/realtime/token', (route) =>
    route.fulfill({ status: 503, json: { error: 'realtime_unavailable' } }),
  );
}

test('signs an owner in and shows the live orders read-only, right to left', async ({ page }) => {
  await signedOutApi(page);
  await page.goto('/');

  await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
  await expect(page.locator('html')).toHaveAttribute('lang', 'ar');
  await expect(page).toHaveTitle('بوابة المطعم');
  await expect(page.getByRole('heading', { name: 'تسجيل الدخول' })).toBeVisible();

  await page.getByLabel('رقم الهاتف').fill('0912345678');
  await page.getByRole('button', { name: 'إرسال الرمز' }).click();
  await expect(page.getByText('أرسلنا الرمز إلى واتساب على الرقم +963912345678')).toBeVisible();
  await page.getByLabel('الرمز').fill('123456');
  await page.getByRole('button', { name: 'تأكيد' }).click();

  await expect(page.getByText('لاستقبال الطلبات استخدم تطبيق أندرويد أو ويندوز')).toBeVisible();
  await expect(page.getByRole('heading', { name: 'جديدة (1)' })).toBeVisible();
  await expect(page.getByRole('link', { name: '#10001' })).toBeVisible();
  // Nothing to press on an order (RA §17).
  await expect(page.getByRole('button', { name: /قبول/ })).toHaveCount(0);
});

test('tells a cashier the portal is for owners', async ({ page }) => {
  await page.route('**/v1/merchant/auth/portal/session', (route) =>
    route.fulfill({ status: 401, json: {} }),
  );
  await page.route('**/v1/merchant/auth/portal/code', (route) =>
    route.fulfill({ status: 403, json: { statusCode: 403, error: 'owner_only' } }),
  );
  await page.goto('/sign-in');
  await page.getByLabel('رقم الهاتف').fill('0912345678');
  await page.getByRole('button', { name: 'إرسال الرمز' }).click();
  await expect(page.getByRole('alert')).toContainText('بوابة المطعم لمالكي المطاعم');
});

// RA §9.4, §17 (slice 2.45b): the owner changes a price from a browser.
test('changes an item price from the portal', async ({ page }) => {
  await signedOutApi(page);
  await page.route('**/v1/merchant/auth/portal/session', (route) =>
    route.fulfill({ json: session }),
  );
  const item = (price: string, id = '0190f3a0-0000-7000-8000-000000000011', name = 'شاورما') => ({
    id,
    code: id.slice(-4),
    name,
    description: null,
    photoKey: null,
    price: { amount: price, currency: 'TRY' },
    available: true,
    switchedOff: null,
    hidden: false,
    optionGroups: [],
    pending: [],
  });
  const menu = (price: string) => ({
    categories: [
      {
        id: '0190f3a0-0000-7000-8000-000000000012',
        name: 'وجبات',
        hidden: false,
        available: true,
        switchedOff: null,
        window: null,
        pending: [],
        items: [item(price), item('8000', '0190f3a0-0000-7000-8000-000000000013', 'كباب')],
      },
    ],
    optionGroups: [],
  });
  await page.route('**/v1/merchant/menu', (route) => route.fulfill({ json: menu('10000') }));
  await page.route('**/v1/merchant/menu/items/*/price', (route) =>
    route.fulfill({ json: menu('12500') }),
  );

  await page.goto('/menu');
  await expect(page.getByRole('heading', { name: 'وجبات' })).toBeVisible();
  const row = page.getByRole('listitem', { name: 'شاورما' });
  // A second item's form starts from its own price, never the first's.
  await page
    .getByRole('listitem', { name: 'كباب' })
    .getByRole('button', { name: 'تعديل السعر' })
    .click();
  await page.getByLabel('السعر').fill('99');
  await row.getByRole('button', { name: 'تعديل السعر' }).click();
  await expect(page.getByLabel('السعر')).toHaveValue('100.00');
  await expect(page.getByText('تذكير: سعر التطبيق يجب ألا يزيد على سعر المحل')).toBeVisible();
  await page.getByLabel('السعر').fill('125');
  const sent = page.waitForRequest('**/v1/merchant/menu/items/*/price');
  await page.getByRole('button', { name: 'حفظ' }).click();

  const request = await sent;
  expect(request.url()).toContain('0190f3a0-0000-7000-8000-000000000011');
  expect(request.postDataJSON()).toEqual({ price: { amount: '12500', currency: 'TRY' } });
  await expect(row).toContainText('125.00');
  await expect(page.getByLabel('السعر')).toHaveCount(0);
});

// RA §14.2, §4.3, §17 (slice 2.45c): the owner pairs a Windows PC from a
// browser, and signs out a lost laptop's portal session.
test('pairs a Windows PC and signs another browser out from the portal', async ({ page }) => {
  await signedOutApi(page);
  await page.route('**/v1/merchant/auth/portal/session', (route) =>
    route.fulfill({ json: session }),
  );
  await page.route('**/v1/merchant/devices', (route) =>
    route.fulfill({
      json: {
        withoutDevice: true,
        devices: [
          {
            deviceId: 'tablet-1',
            name: 'تابلت المطبخ',
            platform: 'android',
            appVersion: '1.0.0',
            user: { name: 'كاشير 1', role: 'cashier' },
            signedIn: false,
            lastSeenAt: null,
            ringing: true,
            connected: false,
            deviceCheck: null,
            thisDevice: false,
          },
        ],
      },
    }),
  );
  const lostLaptop = {
    sessionId: '0190f3a0-0000-7000-8000-000000000021',
    ownerName: 'سامر',
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/130.0 Safari/537.36',
    signedInAt: new Date().toISOString(),
    expiresAt: new Date(Date.now() + 86_400_000).toISOString(),
    thisSession: false,
  };
  const thisBrowser = {
    ...lostLaptop,
    sessionId: session.sessionId,
    userAgent: null,
    thisSession: true,
  };
  await page.route('**/v1/merchant/portal-sessions', (route) =>
    route.fulfill({ json: { sessions: [lostLaptop, thisBrowser] } }),
  );
  await page.route('**/v1/merchant/portal-sessions/*/sign-out', (route) =>
    route.fulfill({ json: { sessions: [thisBrowser] } }),
  );
  await page.route('**/v1/merchant/devices/windows-pairing', (route) =>
    route.fulfill({
      json: { code: '12345678', expiresAt: new Date(Date.now() + 600_000).toISOString() },
    }),
  );

  await page.goto('/devices');
  await expect(page.getByText('لا يوجد جهاز يستقبل الطلبات في مطعمك الآن')).toBeVisible();
  await expect(page.getByText('تابلت المطبخ')).toBeVisible();
  await page.getByRole('button', { name: 'ربط كمبيوتر بويندوز' }).click();
  await expect(page.getByLabel('رمز الربط')).toHaveText('12345678');

  await expect(page.getByText('Chrome على Windows')).toBeVisible();
  page.once('dialog', (dialog) => void dialog.accept());
  const sent = page.waitForRequest('**/v1/merchant/portal-sessions/*/sign-out');
  await page.getByRole('button', { name: 'تسجيل خروج المتصفح' }).click();
  expect((await sent).url()).toContain(lostLaptop.sessionId);
  await expect(page.getByText('Chrome على Windows')).toHaveCount(0);
  await expect(page.getByText('هذا المتصفح')).toBeVisible();
});

// RA §12.3, §17 (slice 2.45d): the owner opens the week's statement in a
// browser, prints it to PDF and downloads it as Excel.
test('opens the statement, prints it and exports it to Excel', async ({ page }) => {
  await signedOutApi(page);
  await page.route('**/v1/merchant/auth/portal/session', (route) =>
    route.fulfill({ json: session }),
  );
  const statementId = '0190f3a0-0000-7000-8000-000000000031';
  const exportId = '0190f3a0-0000-7000-8000-000000000032';
  const cutoff = '2026-11-21T03:00:00.000Z';
  await page.route('**/v1/merchant/statements', (route) =>
    route.fulfill({
      json: {
        statements: [
          {
            id: statementId,
            cutoff,
            periodFrom: '2026-11-14T03:00:00.000Z',
            currency: 'TRY',
            weekTotal: '4600',
            totalDue: '4600',
            status: 'unpaid',
            unpaid: '4600',
          },
        ],
      },
    }),
  );
  await page.route(`**/v1/merchant/statements/${statementId}`, (route) =>
    route.fulfill({
      json: {
        id: statementId,
        restaurantName: session.restaurantName,
        cutoff,
        periodFrom: '2026-11-14T03:00:00.000Z',
        currency: 'TRY',
        orders: 1,
        itemsValue: '24000',
        commission: '3600',
        discountShare: '0',
        exceptions: '1000',
        weekTotal: '4600',
        previousDue: '0',
        paid: '0',
        earlierUnpaid: '0',
        totalDue: '4600',
        status: 'unpaid',
        unpaid: '4600',
        lines: [
          {
            kind: 'order',
            at: '2026-11-20T10:30:00.000Z',
            orderId: '0190f3a0-0000-7000-8000-000000000033',
            orderNumber: '10001',
            itemsValue: '24000',
            pickupLines: [{ currency: 'TRY', amount: '24000' }],
            commission: '3600',
            discountShare: '0',
            cause: null,
            amount: null,
            reason: null,
            decidedBy: null,
            decidedByName: null,
          },
          {
            kind: 'exception',
            at: '2026-11-20T11:00:00.000Z',
            orderId: null,
            orderNumber: null,
            itemsValue: null,
            pickupLines: null,
            commission: null,
            discountShare: null,
            cause: 'adjustment',
            amount: '1000',
            reason: 'فرق جرد',
            decidedBy: 'admin',
            decidedByName: null,
          },
        ],
      },
    }),
  );
  const exported = {
    id: exportId,
    kind: 'merchant_statement',
    fileName: 'كشف الأسبوع 2026-11-21.xlsx',
    createdAt: new Date().toISOString(),
    expiresAt: null,
    url: null,
  };
  await page.route('**/v1/merchant/exports/statement', (route) =>
    route.fulfill({ status: 202, json: { ...exported, status: 'pending' } }),
  );
  await page.route(`**/v1/merchant/exports/${exportId}*`, (route) =>
    route.fulfill({
      json: {
        ...exported,
        status: 'ready',
        expiresAt: new Date(Date.now() + 86_400_000).toISOString(),
        url: route.request().url().includes('download=true')
          ? `${new URL(page.url()).origin}/private-docs/exports/${exportId}.xlsx`
          : null,
      },
    }),
  );
  await page.route('**/private-docs/exports/*', (route) =>
    route.fulfill({
      body: 'xlsx',
      headers: { 'content-disposition': 'attachment; filename="download.xlsx"' },
    }),
  );

  await page.goto('/statements');
  await page.getByRole('link', { name: /المستحق/ }).click();
  await expect(page.getByRole('heading', { name: 'كشف الأسبوع — مطعم التجربة' })).toBeVisible();
  await expect(page.getByText('الحالة: غير مسدّد')).toBeVisible();
  await expect(page.getByText(/تسوية يدوية: فرق جرد/)).toContainText('من قرّر: FOX DROP');

  // «طباعة / حفظ PDF» opens the browser's print, without the portal's bar.
  // The page's window, typed here without the DOM's types (tsconfig.node.json).
  type Printing = { print: () => void; printed: boolean };
  await page.evaluate(() => {
    const page = globalThis as unknown as Printing;
    page.printed = false;
    page.print = () => {
      page.printed = true;
    };
  });
  await page.getByRole('button', { name: 'طباعة / حفظ PDF' }).click();
  expect(await page.evaluate(() => (globalThis as unknown as Printing).printed)).toBe(true);
  await page.emulateMedia({ media: 'print' });
  await expect(page.getByRole('button', { name: 'تصدير Excel' })).toBeHidden();
  await expect(page.getByRole('heading', { name: 'كشف الأسبوع — مطعم التجربة' })).toBeVisible();
  await page.emulateMedia({ media: 'screen' });

  await page.getByRole('button', { name: 'تصدير Excel' }).click();
  const download = page.waitForEvent('download');
  await page.getByRole('button', { name: /تنزيل/ }).click();
  expect((await download).url()).toContain(`/private-docs/exports/${exportId}.xlsx`);
});

// RA R11 (RA-23): the delivery fee and the customer total are in the stubs'
// answers on purpose, so a page that rendered them would show them.
const FEE = '3500';
const CUSTOMER_TOTAL = '23500';

async function expectNoFeeOrCustomerTotal(page: Page) {
  const text = await page.getByRole('main').innerText();
  expect(text).not.toMatch(/رسوم التوصيل|أجرة التوصيل|إجمالي|الإجمالي|المجموع/);
  expect(text).not.toContain('35.00');
  expect(text).not.toContain('235.00');
}

// RA §17 (RA-29): every owner feature but receiving opens from a browser.
test('opens every owner page of the portal and shows its key content', async ({ page }) => {
  await signedOutApi(page);
  await page.route('**/v1/merchant/auth/portal/session', (route) =>
    route.fulfill({ json: session }),
  );
  const orderId = '0190f3a0-0000-7000-8000-000000000010';
  const owner = {
    testOrder: false,
    commissionBp: 1500,
    commission: '3000',
    discountShare: '0',
    discountOnDelivery: false,
    merchantNet: '17000',
  };
  const now = new Date().toISOString();
  await page.route('**/v1/merchant/orders', (route) =>
    route.fulfill({
      json: {
        orders: [{ ...boardOrder(2), deliveryFee: FEE, total: CUSTOMER_TOTAL }],
        prepTime: {},
      },
    }),
  );
  await page.route(`**/v1/merchant/orders/${orderId}`, (route) =>
    route.fulfill({
      json: {
        order: { ...boardOrder(2), owner, deliveryFee: FEE, total: CUSTOMER_TOTAL },
        timeline: [{ step: 'placed', at: now }],
      },
    }),
  );
  await page.route('**/v1/merchant/orders/history*', (route) =>
    route.fulfill({
      json: {
        owner: true,
        fromDay: '2026-11-14',
        toDay: '2026-11-21',
        orders: [
          {
            id: orderId,
            number: '10001',
            placedAt: now,
            day: '2026-11-21',
            status: 'delivered',
            testOrder: false,
            redelivery: false,
            itemCount: 2,
            currency: 'TRY',
            itemsValue: '20000',
            owner,
            deliveryFee: FEE,
            total: CUSTOMER_TOTAL,
          },
        ],
        next: null,
      },
    }),
  );
  const figures = (received: number) => ({
    received,
    acceptedByYou: received,
    acceptedByOperations: 0,
    rejected: 0,
    rejections: [],
    unanswered: 0,
    acceptanceBp: 10000,
    delivered: received,
    sales: '20000',
    averageOrder: '20000',
    commission: '3000',
    discounts: '0',
    net: '17000',
    acceptMinutes: 2,
    prepActualMinutes: 12,
    prepChosenMinutes: 15,
    lateBp: 0,
    readyNotPressed: 0,
    captainWaitMinutes: 3,
    rating: { count: 1, average: 4 },
    topByQuantity: [
      {
        itemId: '0190f3a0-0000-7000-8000-000000000011',
        name: 'شاورما',
        quantity: 2,
        sales: '20000',
      },
    ],
    topBySales: [],
    hours: [{ hour: 13, delivered: received }],
    pauseMinutes: { restaurant: 0, ops: 0, auto: 0 },
    deliveryFee: FEE,
    total: CUSTOMER_TOTAL,
  });
  await page.route('**/v1/merchant/figures*', (route) =>
    route.fulfill({
      json: { from: now, to: now, currency: 'TRY', current: figures(7), previous: figures(5) },
    }),
  );
  await page.route('**/v1/merchant/ratings*', (route) =>
    route.fulfill({
      json: {
        asOf: now,
        count: 1,
        average: 4,
        distribution: [5, 4, 3, 2, 1].map((stars) => ({ stars, count: stars === 4 ? 1 : 0 })),
        ratings: [
          {
            stars: 4,
            reasons: [{ code: 'taste', label: 'الطعم' }],
            comment: 'وجبة ممتازة',
            day: '2026-11-20',
            customerName: 'خالد المحمد',
            orderNumber: '10001',
          },
        ],
        more: false,
      },
    }),
  );
  await page.route('**/v1/merchant/contact', (route) =>
    route.fulfill({ json: { phone: '+905550001122', whatsapp: '+905550001122' } }),
  );
  await page.route('**/v1/merchant/content', (route) =>
    route.fulfill({
      json: {
        reasons: {
          merchant_ticket_type: [{ code: 'other', label: 'مشكلة أخرى', note: 'optional' }],
        },
        faq: [{ question: 'كيف أغيّر سعراً؟', answer: 'من القائمة.' }],
      },
    }),
  );
  await page.route('**/v1/merchant/reports', (route) => route.fulfill({ json: { tickets: [] } }));
  const menu = {
    categories: [
      {
        id: '0190f3a0-0000-7000-8000-000000000012',
        name: 'وجبات',
        hidden: false,
        available: true,
        switchedOff: null,
        window: null,
        pending: [],
        items: [
          {
            id: '0190f3a0-0000-7000-8000-000000000011',
            code: '0011',
            name: 'شاورما',
            description: null,
            photoKey: null,
            price: { amount: '10000', currency: 'TRY' },
            available: true,
            switchedOff: null,
            hidden: false,
            optionGroups: [],
            pending: [],
          },
        ],
      },
    ],
    optionGroups: [],
  };
  await page.route('**/v1/merchant/menu', (route) => route.fulfill({ json: menu }));
  await page.route('**/v1/merchant/menu/price-log', (route) =>
    route.fulfill({ json: { entries: [] } }),
  );
  await page.route('**/v1/merchant/menu/customer-preview', (route) =>
    route.fulfill({ json: { menu: [] } }),
  );
  await page.route('**/v1/merchant/account', (route) =>
    route.fulfill({
      json: {
        currency: 'TRY',
        balance: '4600',
        settlementDate: '2026-11-21',
        commissionBp: 1500,
        nextCommission: null,
        todayFrom: now,
        pickups: [],
        weekFrom: null,
        weekLines: [],
      },
    }),
  );
  await page.route('**/v1/merchant/statements', (route) =>
    route.fulfill({
      json: {
        statements: [
          {
            id: '0190f3a0-0000-7000-8000-000000000031',
            cutoff: now,
            periodFrom: now,
            currency: 'TRY',
            weekTotal: '4600',
            totalDue: '4600',
            status: 'unpaid',
            unpaid: '4600',
          },
        ],
      },
    }),
  );
  await page.route('**/v1/merchant/receipts', (route) => route.fulfill({ json: { receipts: [] } }));
  await page.route('**/v1/merchant/staff', (route) =>
    route.fulfill({
      json: {
        staff: [
          {
            accountId: session.accountId,
            role: 'owner',
            name: 'سامر',
            phone: '+963912345678',
            devices: 1,
            lastActiveAt: null,
          },
        ],
      },
    }),
  );
  await page.route('**/v1/merchant/devices', (route) =>
    route.fulfill({ json: { withoutDevice: false, devices: [] } }),
  );
  await page.route('**/v1/merchant/portal-sessions', (route) =>
    route.fulfill({ json: { sessions: [] } }),
  );
  await page.route('**/v1/merchant/restaurant/hours', (route) =>
    route.fulfill({
      json: {
        periods: [{ weekday: 1, opensAt: 540, closesAt: 1380 }],
        holiday: null,
        defaultPrepMin: 20,
        prepFloorMin: 5,
        prepCeilingMin: 90,
        maxActiveOrders: null,
        minimumOrder: { amount: '5000', currency: 'TRY' },
        coverage: { kind: 'radius', radiusMetres: 5000, zoneCount: null },
        commissionBp: 1500,
        settlementWeekday: 'saturday',
      },
    }),
  );
  await page.route('**/v1/merchant/settings/pickup-currencies', (route) =>
    route.fulfill({
      json: {
        baseCurrency: { currency: 'TRY', name: 'الليرة التركية' },
        accepted: [],
        choices: [],
      },
    }),
  );
  const main = page.getByRole('main');

  await test.step('board, read only', async () => {
    await page.goto('/orders');
    await expect(page.getByRole('heading', { name: 'جديدة (1)' })).toBeVisible();
    await expect(page.getByRole('link', { name: '#10001' })).toBeVisible();
    await expect(page.getByRole('button', { name: /قبول|رفض|جاهز/ })).toHaveCount(0);
    await expectNoFeeOrCustomerTotal(page);
  });

  await test.step('order', async () => {
    await page.goto(`/orders/${orderId}`);
    await expect(main.getByRole('heading', { name: 'الطلب #10001' })).toBeVisible();
    await expect(main.getByText(/قيمة الأصناف.*200\.00/)).toBeVisible();
    await expect(main.getByText('صافيك من الطلب', { exact: false })).toBeVisible();
    await expect(main.getByText('وصل الطلب', { exact: false })).toBeVisible();
    await expectNoFeeOrCustomerTotal(page);
  });

  await test.step('history', async () => {
    await page.goto('/history');
    await expect(main.getByRole('heading', { name: 'السجل' })).toBeVisible();
    await expect(main.getByRole('link', { name: '#10001' })).toBeVisible();
    await expect(main.getByText('200.00', { exact: false }).first()).toBeVisible();
    await expectNoFeeOrCustomerTotal(page);
  });

  await test.step('reports', async () => {
    await page.goto('/reports');
    await expect(main.getByRole('heading', { name: 'التقارير' })).toBeVisible();
    await expect(main.getByText('الطلبات المستلمة', { exact: true })).toBeVisible();
    await expect(main.getByText('الأكثر طلباً بالكمية')).toBeVisible();
    await expectNoFeeOrCustomerTotal(page);
  });

  // RA-24 (RA §13, R16): no customer, no order, no reply.
  await test.step('ratings, without a customer name or a reply', async () => {
    await page.goto('/ratings');
    await expect(main.getByRole('heading', { name: 'التقييمات' })).toBeVisible();
    await expect(main.getByText('وجبة ممتازة')).toBeVisible();
    await expect(main.getByText('الطعم')).toBeVisible();
    await expect(main.getByText('خالد المحمد')).toHaveCount(0);
    await expect(main.getByText('10001')).toHaveCount(0);
    await expect(main.getByRole('button', { name: /رد|reply/i })).toHaveCount(0);
    // The period's date fields are textboxes; a reply would be a text area.
    await expect(main.locator('textarea')).toHaveCount(0);
  });

  await test.step('status', async () => {
    await page.goto('/status');
    await expect(main.getByRole('heading', { name: 'الحالة' })).toBeVisible();
    await expect(main.getByText('إيقاف مؤقت', { exact: true })).toBeVisible();
  });

  await test.step('menu', async () => {
    await page.goto('/menu');
    await expect(main.getByRole('heading', { name: 'وجبات' })).toBeVisible();
  });

  await test.step('menu tools', async () => {
    await page.goto('/menu/quick-edit');
    await expect(main.getByRole('heading', { name: 'تعديل سريع' })).toBeVisible();
    await page.goto('/menu/bulk-price');
    await expect(main.getByRole('heading', { name: 'تعديل جماعي للأسعار' })).toBeVisible();
    await page.goto('/menu/price-log');
    await expect(main.getByRole('heading', { name: 'سجل الأسعار' })).toBeVisible();
    await expect(main.getByText('لا تغييرات في الأسعار بعد.')).toBeVisible();
    await page.goto('/menu/preview');
    await expect(main.getByRole('heading', { name: 'معاينة كما يراها الزبون' })).toBeVisible();
  });

  await test.step('money: account, statements and receipts', async () => {
    await page.goto('/account');
    await expect(main.getByRole('heading', { name: 'الحساب' })).toBeVisible();
    await expect(main.getByText(/المستحق عليك حتى الآن.*46\.00/)).toBeVisible();
    await page.goto('/statements');
    await expect(main.getByRole('heading', { name: 'الكشوف' })).toBeVisible();
    await expect(main.getByRole('link', { name: /46\.00/ })).toBeVisible();
    await page.goto('/receipts');
    await expect(main.getByRole('heading', { name: 'الإيصالات' })).toBeVisible();
  });

  await test.step('team: staff and devices', async () => {
    await page.goto('/staff');
    await expect(main.getByRole('heading', { name: 'الموظفون' })).toBeVisible();
    await expect(main.getByText('سامر')).toBeVisible();
    await page.goto('/devices');
    await expect(main.getByRole('heading', { name: 'الأجهزة' })).toBeVisible();
    await expect(main.getByRole('button', { name: 'ربط كمبيوتر بويندوز' })).toBeVisible();
  });

  await test.step('settings', async () => {
    await page.goto('/settings');
    await expect(main.getByRole('heading', { name: 'الأوقات والإعدادات' })).toBeVisible();
    await expect(main.getByText('جدول الأسبوع')).toBeVisible();
    await expect(main.getByText('حتى 5 كم من المطعم')).toBeVisible();
  });

  // RA-26 (RA §15): the team's call and WhatsApp.
  await test.step('support, with the call and WhatsApp links to the team', async () => {
    await page.goto('/support');
    await expect(main.getByRole('heading', { name: 'الدعم' })).toBeVisible();
    await expect(main.getByRole('link', { name: 'اتصال بالعمليات' })).toHaveAttribute(
      'href',
      'tel:+905550001122',
    );
    await expect(main.getByRole('link', { name: 'واتساب العمليات' })).toHaveAttribute(
      'href',
      'https://wa.me/905550001122',
    );
    await expect(main.getByText('كيف أغيّر سعراً؟')).toBeVisible();
  });

  await test.step('terms', async () => {
    await page.goto('/terms');
    await expect(main.getByRole('heading', { name: 'الشروط والخصوصية' })).toBeVisible();
    await expect(main.getByText('الشروط', { exact: true })).toBeVisible();
  });
});
