import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';

const choices = {
  categories: [{ id: '01900000-0000-7000-8000-0000000000f1', name: 'شاورما' }],
  categoriesMax: 5,
  zones: [],
  baseCurrency: 'TRY',
  centre: null,
  prepFloorMin: 5,
  prepCeilingMin: 90,
  defaultPrepMin: 20,
  defaultMinimumOrder: null,
  defaultCommissionBp: 1500,
  nameMax: 80,
  descriptionMax: 300,
  addressMax: 200,
};

function draftOf(
  id: string,
  nameAr: string,
  location: { latitude: number; longitude: number } | null,
) {
  return {
    id,
    cityId,
    accountStatus: 'draft',
    basics: {
      nameAr,
      nameEn: null,
      categoryIds: [],
      description: null,
      logoKey: null,
      coverKey: null,
    },
    location: { location, address: null, phone: null, ownerName: null },
    operations: { periods: [], defaultPrepMin: null, minimumOrder: null, coverage: null },
    commission: null,
    contract: null,
    steps: {
      basics: true,
      location: location !== null,
      operations: false,
      commission: false,
      contract: false,
    },
  };
}

function checklistOf(
  accountStatus: 'draft' | 'test' | 'active',
  menu: 'met' | 'missing',
  canStartTest: boolean,
) {
  return {
    accountStatus,
    items: [
      { code: 'record', state: 'met' },
      { code: 'menu', state: menu },
      { code: 'device_check', state: 'not_available' },
      { code: 'test_order', state: 'missing' },
    ],
    canStartTest,
    canActivate: false,
    images: { withPhoto: 0, total: 1, requiredPct: 80 },
    imagesWaiver: null,
  };
}

// «إضافة مطعم» (AP §9.6.3; slice 2.30a): DATA starts a draft, saves step 1,
// lands on step 2 and saves the pin typed by hand (the map needs WebGL and
// the map's files, which the smoke test has neither of).
test('starts a draft, saves its basics, then its pin', async ({ page }) => {
  await fakeSession(page, ['restaurants.create']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/restaurant-drafts?*', (route) =>
    route.fulfill({ json: { drafts: [] } }),
  );
  await page.route('**/v1/admin/restaurant-drafts/choices?*', (route) =>
    route.fulfill({ json: choices }),
  );
  let draft: ReturnType<typeof draftOf> | null = null;
  const bodies: Record<string, unknown> = {};
  await page.route(/\/v1\/admin\/restaurant-drafts\/[0-9a-f-]{36}(\/\w+)?(\?.*)?$/, (route) => {
    const url = new URL(route.request().url());
    const [, , , , id, step] = url.pathname.split('/');
    if (route.request().method() === 'GET') {
      return draft === null
        ? route.fulfill({ status: 404, json: { statusCode: 404, error: 'unknown_restaurant' } })
        : route.fulfill({ json: draft });
    }
    const body = route.request().postDataJSON() as Record<string, unknown>;
    bodies[step!] = body;
    draft =
      step === 'basics'
        ? draftOf(id!, body.nameAr as string, null)
        : draftOf(
            id!,
            draft!.basics.nameAr,
            body.location as { latitude: number; longitude: number },
          );
    return route.fulfill({ json: draft });
  });
  await page.route('**/v1/admin/restaurants/*/accounts', (route) =>
    route.fulfill({ json: { accounts: [] } }),
  );
  await page.route('**/v1/admin/restaurant-drafts/*/checklist', (route) =>
    route.fulfill({ json: checklistOf('draft', 'missing', false) }),
  );

  await page.goto('/restaurant-drafts');
  await expect(page.getByText('لا مسودات في هذه المدينة.')).toBeVisible();
  await page.getByRole('button', { name: 'مطعم جديد' }).click();
  await page.getByLabel('الاسم بالعربية').fill('مطعم الضيعة');
  await page.getByLabel('شاورما').check();
  await page.getByRole('button', { name: 'حفظ' }).click();
  await expect(page.getByRole('heading', { name: '2. الموقع والتواصل' })).toBeVisible();
  expect(bodies.basics).toEqual({
    cityId,
    nameAr: 'مطعم الضيعة',
    nameEn: null,
    categoryIds: ['01900000-0000-7000-8000-0000000000f1'],
    description: null,
  });
  await page.getByLabel('خط العرض').fill('36.5862');
  await page.getByLabel('خط الطول').fill('37.0471');
  await page.getByRole('button', { name: 'حفظ' }).click();
  await expect(page.getByRole('status').filter({ hasText: 'تم الحفظ.' })).toBeVisible();
  expect(bodies.location).toMatchObject({ location: { latitude: 36.5862, longitude: 37.0471 } });
});

// Steps 7 and 8 (AP §9.6.3, §9.6.6; slice 2.30b): OPS adds a category and an
// item, then starts test mode from the checklist.
test('builds the menu, then starts test mode', async ({ page }) => {
  const id = '01900000-0000-7000-8000-0000000000d1';
  await fakeSession(page, ['restaurants.read', 'restaurants.menus', 'restaurants.activate']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/restaurant-drafts/choices?*', (route) =>
    route.fulfill({ json: choices }),
  );
  await page.route(`**/v1/admin/restaurant-drafts/${id}?*`, (route) =>
    route.fulfill({ json: draftOf(id, 'مطعم الضيعة', { latitude: 36.58, longitude: 37.04 }) }),
  );
  await page.route('**/v1/admin/restaurants/*/accounts', (route) =>
    route.fulfill({ json: { accounts: [] } }),
  );
  type Category = {
    id: string;
    name: string;
    hidden: boolean;
    switchedOff: null;
    window: { startsAt: number; endsAt: number } | null;
    items: unknown[];
  };
  const menu = {
    accountStatus: 'draft',
    editable: true,
    pricesLocked: false,
    nameMax: 80,
    descriptionMax: 300,
    codeMax: 20,
    categories: [] as Category[],
    optionGroups: [],
  };
  const sent: Record<string, unknown>[] = [];
  await page.route(`**/v1/admin/restaurant-drafts/${id}/menu**`, (route) => {
    if (route.request().method() === 'GET') return route.fulfill({ json: menu });
    const body = route.request().postDataJSON() as Record<string, unknown>;
    sent.push(body);
    const parts = new URL(route.request().url()).pathname.split('/');
    if (parts.includes('categories')) {
      menu.categories.push({
        id: parts.at(-1)!,
        ...(body as Omit<Category, 'id'>),
        switchedOff: null,
        items: [],
      });
    } else if (parts.includes('items')) {
      menu.categories[0]!.items.push({
        id: parts.at(-1)!,
        ...body,
        code: 'I0001',
        photoKey: null,
        switchedOff: null,
        optionGroupIds: [],
      });
    }
    return route.fulfill({ json: menu });
  });
  let status: 'draft' | 'test' = 'draft';
  await page.route(`**/v1/admin/restaurant-drafts/${id}/checklist`, (route) =>
    route.fulfill({ json: checklistOf(status, 'met', true) }),
  );
  await page.route(`**/v1/admin/restaurant-drafts/${id}/test-mode`, (route) => {
    status = 'test';
    return route.fulfill({ json: checklistOf(status, 'met', true) });
  });

  await page.goto(`/restaurant-drafts/${id}?step=menu`);
  await expect(page.getByText('لا فئات بعد. أضف الفئة الأولى.')).toBeVisible();
  await page.getByRole('button', { name: 'إضافة فئة' }).click();
  await page.getByLabel('اسم الفئة').fill('فطور');
  await page.getByLabel('متوفرة في ساعات محددة فقط').check();
  await page.getByLabel('من', { exact: true }).fill('06:00');
  await page.getByLabel('إلى', { exact: true }).fill('12:00');
  await page.getByRole('button', { name: 'حفظ' }).click();
  await expect(page.getByText('متوفرة من 06:00 إلى 12:00')).toBeVisible();
  expect(sent[0]).toEqual({ name: 'فطور', hidden: false, window: { startsAt: 360, endsAt: 720 } });
  await page.getByRole('button', { name: 'إضافة صنف' }).click();
  await page.getByLabel('اسم الصنف').fill('فول');
  await page.getByLabel('السعر (TRY)').fill('45');
  await page.getByLabel('الشارة').selectOption('new');
  await page.getByRole('button', { name: 'حفظ' }).click();
  await expect(page.getByText(/I0001 · فول/)).toBeVisible();
  expect(sent[1]).toMatchObject({
    code: null,
    name: 'فول',
    price: { amount: '4500', currency: 'TRY' },
    badge: 'new',
  });

  await page.getByRole('link', { name: '8. المراجعة والتفعيل' }).click();
  await expect(page.getByText('فحص الجهاز: غير متاح بعد', { exact: false })).toBeVisible();
  await page.getByRole('button', { name: 'تشغيل الوضع التجريبي' }).click();
  await expect(page.getByText('المطعم في الوضع التجريبي', { exact: false })).toBeVisible();
});
