import { deflateSync } from 'node:zlib';
import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const cities = {
  cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }],
};
const restaurantId = '01900000-0000-7000-8000-0000000000b1';
const zoneId = '01900000-0000-7000-8000-0000000000d1';
const uploadId = '01900000-0000-7000-8000-0000000000e1';
const bannerId = '01900000-0000-7000-8000-0000000000f1';

// A plain PNG of one colour, so the browser decodes a real image.
function png(width: number, height: number): Buffer {
  const crc = (bytes: Buffer) => {
    let value = ~0;
    for (const byte of bytes) {
      value ^= byte;
      for (let k = 0; k < 8; k += 1) value = (value >>> 1) ^ (0xedb88320 & -(value & 1));
    }
    return ~value >>> 0;
  };
  const chunk = (type: string, data: Buffer) => {
    const length = Buffer.alloc(4);
    length.writeUInt32BE(data.length);
    const body = Buffer.concat([Buffer.from(type, 'latin1'), data]);
    const sum = Buffer.alloc(4);
    sum.writeUInt32BE(crc(body));
    return Buffer.concat([length, body, sum]);
  };
  const header = Buffer.alloc(13);
  header.writeUInt32BE(width, 0);
  header.writeUInt32BE(height, 4);
  header.set([8, 2, 0, 0, 0], 8);
  const row = Buffer.concat([Buffer.from([0]), Buffer.alloc(width * 3, 0xc0)]);
  const pixels = Buffer.concat(Array.from({ length: height }, () => row));
  return Buffer.concat([
    Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
    chunk('IHDR', header),
    chunk('IDAT', deflateSync(pixels)),
    chunk('IEND', Buffer.alloc(0)),
  ]);
}

// A JPEG's size, from its frame header.
function jpegSize(bytes: Buffer): { width: number; height: number } | null {
  let i = 2;
  while (i + 9 <= bytes.length) {
    const marker = bytes[i + 1]!;
    if (marker >= 0xc0 && marker <= 0xc3) {
      return { width: bytes.readUInt16BE(i + 7), height: bytes.readUInt16BE(i + 5) };
    }
    i += 2 + bytes.readUInt16BE(i + 2);
  }
  return null;
}

const answer = (banners: object[], canManage = true) => ({
  banners,
  restaurants: [{ id: restaurantId, name: 'شاورما الريف' }],
  categories: [],
  codes: [],
  zones: [{ id: zoneId, name: 'المركز', active: true }],
  canManage,
});

// AP §9.11.2 «البانرات» (slice 2.27c): DATA cuts an image to 1200×500,
// writes the banner for one zone, previews it and publishes.
test('cuts the image, previews the banner and publishes it', async ({ page }) => {
  await fakeSession(page, ['marketing.banners']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  let banners: object[] = [];
  let sent: Record<string, unknown> | null = null;
  let uploaded: { type: string; size: { width: number; height: number } | null } | null = null;
  await page.route('**/v1/admin/uploads', (route) => {
    expect(route.request().postDataJSON()).toMatchObject({
      purpose: 'banner_image',
      contentType: 'image/jpeg',
    });
    return route.fulfill({
      status: 201,
      json: {
        uploadId,
        url: `${new URL(page.url()).origin}/public-media/incoming/x.jpg?X-Amz-Signature=fake`,
        expiresAt: new Date(Date.now() + 600_000).toISOString(),
      },
    });
  });
  await page.route('**/public-media/**', (route) => {
    const body = route.request().postDataBuffer()!;
    uploaded = { type: route.request().headers()['content-type']!, size: jpegSize(body) };
    return route.fulfill({ status: 200 });
  });
  await page.route('**/media/**', (route) => route.fulfill({ status: 200, body: png(4, 4) }));
  await page.route('**/v1/admin/banners**', (route) => {
    const request = route.request();
    if (request.method() === 'GET') return route.fulfill({ json: answer(banners) });
    expect(request.headers()['idempotency-key']).toMatch(/^[0-9a-f-]{36}$/);
    sent = request.postDataJSON();
    banners = [
      {
        id: bannerId,
        title: 'شاورما الشتاء',
        imageKey: 'marketing/banners/01900000-0000-7000-8000-0000000000a9.jpg',
        target: 'restaurant',
        restaurantIds: [restaurantId],
        categoryId: null,
        codeId: null,
        code: null,
        zoneIds: [zoneId],
        startsAt: '2030-01-01T09:00:00.000Z',
        endsAt: '2030-01-08T09:00:00.000Z',
      },
    ];
    return route.fulfill({ status: 201, json: answer(banners) });
  });
  await page.goto('/');
  await page.getByRole('link', { name: 'البانرات' }).click();
  await expect(page.getByText('لا بانرات بعد.')).toBeVisible();

  const form = page.getByRole('region', { name: 'بانر جديد' });
  await form.getByLabel('اختر صورة').setInputFiles({
    name: 'wide.png',
    mimeType: 'image/png',
    buffer: png(1800, 900),
  });
  await expect(form.getByLabel('معاينة القص')).toBeVisible();
  await form.getByLabel('التكبير').fill('1.5');
  await form.getByLabel('عنوان البانر').fill('شاورما الشتاء');
  await form.getByLabel('مطعم', { exact: true }).check();
  await form.getByRole('combobox', { name: /^المطعم/ }).selectOption(restaurantId);
  await form.getByLabel('البداية').fill('2030-01-01T12:00');
  await form.getByLabel('النهاية').fill('2030-01-08T12:00');
  await form.getByLabel('المركز').check();
  await expect(form.getByRole('button', { name: 'نشر' })).toHaveCount(0);
  await form.getByRole('button', { name: 'معاينة' }).click();
  const preview = form.getByRole('region', { name: 'معاينة' });
  await expect(preview.getByText('يفتح صفحة شاورما الريف')).toBeVisible();
  await expect(preview.getByText('المناطق: المركز')).toBeVisible();
  await preview.getByRole('button', { name: 'نشر' }).click();
  await expect(page.getByRole('region', { name: 'شاورما الشتاء' })).toBeVisible();

  expect(uploaded).toEqual({ type: 'image/jpeg', size: { width: 1200, height: 500 } });
  expect(sent).toEqual({
    cityId,
    title: 'شاورما الشتاء',
    target: 'restaurant',
    restaurantIds: [restaurantId],
    categoryId: null,
    codeId: null,
    zoneIds: [zoneId],
    startsAt: '2030-01-01T09:00:00.000Z',
    endsAt: '2030-01-08T09:00:00.000Z',
    uploadId,
  });
});

test('refuses an image smaller than 1200×500 before cutting it', async ({ page }) => {
  await fakeSession(page, ['marketing.banners']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/v1/admin/banners**', (route) => route.fulfill({ json: answer([]) }));
  await page.goto('/banners');
  await page.getByLabel('اختر صورة').setInputFiles({
    name: 'small.png',
    mimeType: 'image/png',
    buffer: png(800, 400),
  });
  await expect(page.getByText('الصورة أصغر من 1200×500. اختر صورة أكبر.')).toBeVisible();
  await expect(page.getByLabel('معاينة القص')).toHaveCount(0);
});

// OPS reads the banners without the form or the buttons.
test('OPS reads the banners only', async ({ page }) => {
  await fakeSession(page, ['marketing.read']);
  await page.route('**/v1/admin/cities', (route) => route.fulfill({ json: cities }));
  await page.route('**/media/**', (route) => route.fulfill({ status: 200, body: png(4, 4) }));
  await page.route('**/v1/admin/banners**', (route) =>
    route.fulfill({
      json: answer(
        [
          {
            id: bannerId,
            title: 'شاورما الشتاء',
            imageKey: 'marketing/banners/01900000-0000-7000-8000-0000000000a9.jpg',
            target: 'restaurant',
            restaurantIds: [restaurantId],
            categoryId: null,
            codeId: null,
            code: null,
            zoneIds: [],
            startsAt: '2030-01-01T09:00:00.000Z',
            endsAt: '2030-01-08T09:00:00.000Z',
          },
        ],
        false,
      ),
    }),
  );
  await page.goto('/banners');
  await expect(page.getByRole('heading', { name: 'شاورما الشتاء' })).toBeVisible();
  await expect(page.getByText('لم يبدأ بعد')).toBeVisible();
  await expect(page.getByText('كل المناطق')).toBeVisible();
  await expect(page.getByRole('main').getByRole('button')).toHaveCount(0);
  await expect(page.getByRole('region', { name: 'بانر جديد' })).toHaveCount(0);
});
