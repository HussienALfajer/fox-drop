import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const shawarma = '01900000-0000-7000-8000-0000000000r1';
const built = (kind: string, visible = true) => ({
  key: kind,
  kind,
  title: null,
  restaurantIds: [],
  visible,
});
const defaults = ['banners', 'categories', 'nearest', 'most_ordered', 'new', 'offers'];
const answer = (sections: object[], canManage = true) => ({
  sections,
  restaurants: [{ id: shawarma, name: 'شاورما الريف' }],
  canManage,
});

// AP §9.11.3 «أقسام الرئيسية»: OWN adds a custom section, moves it to the
// top and hides «الأقرب إليك».
test('adds a custom section, moves it up and hides a section', async ({ page }) => {
  await fakeSession(page, ['marketing.read', 'marketing.manage']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let sections: object[] = defaults.map((kind) => built(kind));
  const sent: { url: string; body: unknown }[] = [];
  const custom = {
    key: '01900000-0000-7000-8000-0000000000s1',
    kind: 'custom',
    title: 'أفضل شاورما في أعزاز',
    restaurantIds: [shawarma],
    visible: true,
  };
  await page.route('**/v1/admin/home-sections**', (route) => {
    const request = route.request();
    if (request.method() === 'GET') return route.fulfill({ json: answer(sections) });
    const body = request.postDataJSON();
    sent.push({ url: new URL(request.url()).pathname, body });
    if (request.url().endsWith('/order')) {
      sections = [custom, ...defaults.map((kind) => built(kind))];
    } else if (request.url().endsWith('/visibility')) {
      sections = [custom, ...defaults.map((kind) => built(kind, kind !== 'nearest'))];
    } else {
      sections = [...defaults.map((kind) => built(kind)), custom];
      return route.fulfill({ status: 201, json: answer(sections) });
    }
    return route.fulfill({ json: answer(sections) });
  });
  await page.goto('/');

  await page.getByRole('link', { name: 'أقسام الرئيسية' }).click();
  await expect(page.getByRole('heading', { name: 'الأقرب إليك' })).toBeVisible();
  const add = page.getByRole('region', { name: 'إضافة قسم مخصص' });
  await add.getByLabel('عنوان القسم').fill('أفضل شاورما في أعزاز');
  await add.getByLabel('شاورما الريف').check();
  await add.getByRole('button', { name: 'إضافة قسم مخصص' }).click();
  const section = page.getByRole('region', { name: 'أفضل شاورما في أعزاز' });
  await expect(section).toBeVisible();
  await section.getByRole('button', { name: 'نقل القسم للأعلى' }).click();
  await expect(page.getByRole('heading', { level: 2 }).first()).toHaveText('أفضل شاورما في أعزاز');
  const nearest = page.getByRole('region', { name: 'الأقرب إليك' });
  await nearest.getByRole('button', { name: 'إخفاء' }).click();
  await expect(nearest.getByText('مخفي')).toBeVisible();

  expect(sent).toEqual([
    {
      url: '/v1/admin/home-sections',
      body: { cityId, title: 'أفضل شاورما في أعزاز', restaurantIds: [shawarma] },
    },
    {
      url: '/v1/admin/home-sections/order',
      body: {
        cityId,
        keys: ['banners', 'categories', 'nearest', 'most_ordered', 'new', custom.key, 'offers'],
      },
    },
    {
      url: '/v1/admin/home-sections/visibility',
      body: { cityId, key: 'nearest', visible: false },
    },
  ]);
});

// OPS reads the sections without the buttons.
test('OPS reads the sections only', async ({ page }) => {
  await fakeSession(page, ['marketing.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/home-sections**', (route) =>
    route.fulfill({
      json: answer(
        defaults.map((kind) => built(kind)),
        false,
      ),
    }),
  );
  await page.goto('/home-sections');
  await expect(page.getByRole('heading', { name: 'العروض' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'إخفاء' })).toHaveCount(0);
  await expect(page.getByRole('region', { name: 'إضافة قسم مخصص' })).toHaveCount(0);
});
