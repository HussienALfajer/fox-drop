import { expect, test } from '@playwright/test';
import { fakeSession } from './session.js';

const cityId = '01900000-0000-7000-8000-0000000000c1';
const applicationId = '01900000-0000-7000-8000-0000000000f1';
const documentId = '01900000-0000-7000-8000-0000000000f2';
const zoneId = '01900000-0000-7000-8000-0000000000f3';

const document = {
  id: documentId,
  kind: 'personal_photo',
  status: 'pending',
  reason: null,
  number: null,
  issueDate: null,
  expiresOn: null,
  uploadedAt: '2026-11-18T08:00:00.000Z',
  uploadedByOffice: false,
  uploadedBy: null,
  reviewedBy: null,
  reviewedAt: null,
  inForce: true,
  fileUrls: [],
};

const review = (status: 'pending' | 'accepted') => ({
  id: applicationId,
  stage: status === 'pending' ? 'new' : 'under_review',
  cityId,
  fullName: 'خالد أحمد العلي',
  birthDate: '2000-05-01',
  zoneId,
  zoneName: 'حي النصر',
  vehicle: 'motorbike',
  plate: '12345',
  phone: '+963944123456',
  submittedAt: '2026-11-18T08:00:00.000Z',
  updatedAt: '2026-11-18T08:00:00.000Z',
  requiredDocuments: [
    'national_id',
    'personal_photo',
    'civil_registry',
    'criminal_record',
    'vehicle_papers',
  ],
  documents: [
    status === 'pending'
      ? document
      : { ...document, status, reviewedBy: 'سارة', reviewedAt: '2026-11-19T08:00:00.000Z' },
  ],
  requests: [],
  interview: null,
  rejection: null,
  duplicates: [
    {
      field: 'plate',
      applicationId: null,
      captainId: '01900000-0000-7000-8000-0000000000f4',
      fullName: 'محمد سالم',
      stage: null,
    },
  ],
  events: [
    {
      id: '01900000-0000-7000-8000-0000000000f5',
      at: '2026-11-18T08:00:00.000Z',
      actor: null,
      kind: 'submitted',
      stage: 'new',
      documentKind: null,
      documentStatus: null,
      note: null,
    },
  ],
});

// «طلبات الانضمام» (slice 2.34b; AP §9.7.1): the board by stage with its
// counts, the review page with the duplicate warning, and «قبول» of a
// document.
test('reviews an application from the board and accepts a document', async ({ page }) => {
  await fakeSession(page, ['captains.read', 'captains.manage']);
  await page.route('**/v1/admin/cities', (route) =>
    route.fulfill({
      json: { cities: [{ id: cityId, code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' }] },
    }),
  );
  await page.route('**/v1/admin/captain-applications?*', (route) => {
    const query = new URL(route.request().url()).searchParams;
    expect(query.get('cityId')).toBe(cityId);
    expect(query.get('stage')).toBe('new');
    return route.fulfill({
      json: {
        counts: { new: 1, waitlist: 2 },
        applications: [
          {
            id: applicationId,
            fullName: 'خالد أحمد العلي',
            vehicle: 'motorbike',
            zoneId,
            stage: 'new',
            submittedAt: '2026-11-18T08:00:00.000Z',
            updatedAt: '2026-11-18T08:00:00.000Z',
          },
        ],
      },
    });
  });
  let reviewed: unknown = null;
  await page.route(`**/v1/admin/captain-applications/${applicationId}`, (route) =>
    route.fulfill({ json: review(reviewed === null ? 'pending' : 'accepted') }),
  );
  await page.route(
    `**/v1/admin/captain-applications/${applicationId}/documents/${documentId}/review`,
    async (route) => {
      reviewed = route.request().postDataJSON();
      await route.fulfill({ json: review('accepted') });
    },
  );
  await page.goto('/');

  await page.getByRole('link', { name: 'طلبات الانضمام' }).click();
  await expect(page.getByRole('link', { name: 'جديد (1)' })).toBeVisible();
  await expect(page.getByRole('link', { name: 'قائمة انتظار (2)' })).toBeVisible();
  await expect(page.getByRole('link', { name: 'مرفوض (0)' })).toBeVisible();
  await page.getByRole('link', { name: 'خالد أحمد العلي' }).click();

  await expect(page.getByRole('heading', { name: 'خالد أحمد العلي' })).toBeVisible();
  const duplicates = page.getByRole('region', {
    name: 'تحذير: بيانات مكررة مع متقدّم أو كابتن آخر',
  });
  await expect(duplicates.getByText('رقم اللوحة مسجّل باسم محمد سالم')).toBeVisible();
  const photo = page.getByRole('region', { name: 'صورة شخصية' });
  await expect(photo.getByText('بانتظار التحقق')).toBeVisible();
  await expect(page.getByRole('button', { name: 'اجتاز التدريب والاختبار' })).toHaveCount(0);
  await photo.getByRole('button', { name: 'قبول' }).click();
  await expect(photo.getByText('مقبول', { exact: true })).toBeVisible();
  await expect(page.getByText('المرحلة: قيد المراجعة')).toBeVisible();
  expect(reviewed).toEqual({ status: 'accepted' });
});

test('is not offered without captains.read', async ({ page }) => {
  await fakeSession(page, ['operations.read']);
  await page.goto('/');
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  await expect(page.getByRole('link', { name: 'طلبات الانضمام' })).toHaveCount(0);
});
