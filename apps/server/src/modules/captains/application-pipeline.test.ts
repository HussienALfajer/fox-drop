import { randomInt, randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import {
  admin,
  alertOf,
  app,
  applicant,
  applicationOf,
  azaz,
  change,
  jpeg,
  pushes,
  put,
  sent,
  sql,
  zoneId,
} from './application-pipeline.fixture.js';
import { CaptainsService } from './captains.service.js';

// AP §9.7.1, CA §5.3–5.4, §14 #29 (slice 2.34b): the panel's pipeline of
// captain applications, from «إرسال الطلب» to «بانتظار العدة», with the
// documents in a real Garage's private-docs.

describe('the board and the review page (AP §9.7.1)', () => {
  it('raises «طلب انضمام كابتن» and lists the application under «جديد»', async () => {
    const who = await sent();
    const id = await applicationOf(who);
    expect(await alertOf(id)).toEqual([
      { open: true, details: { captainName: expect.stringMatching(/^محمد أحمد/) } },
    ]);
    const ops = await admin('OPS');
    const board = await ops('GET', `captain-applications?cityId=${azaz}&stage=new`);
    expect(board.statusCode).toBe(200);
    expect(board.json().counts.new).toBeGreaterThanOrEqual(1);
    expect(board.json().applications.map((each: { id: string }) => each.id)).toContain(id);

    const page = await ops('GET', `captain-applications/${id}`);
    expect(page.statusCode).toBe(200);
    expect(page.json()).toMatchObject({
      stage: 'new',
      zoneName: 'الحي الشمالي',
      vehicle: 'car',
      phone: who.phone,
      requiredDocuments: [
        'national_id',
        'personal_photo',
        'civil_registry',
        'criminal_record',
        'vehicle_papers',
      ],
      events: [expect.objectContaining({ kind: 'submitted', stage: 'new', actor: null })],
    });
    const nationalId = page
      .json()
      .documents.find((each: { kind: string }) => each.kind === 'national_id');
    expect(nationalId).toMatchObject({ status: 'pending', inForce: true, uploadedByOffice: false });
    expect(nationalId.fileUrls).toHaveLength(2);
    // Signed for the panel's origin, under captains/ (nginx's GET path).
    expect(new URL(nationalId.fileUrls[0]).pathname).toMatch(
      /^\/private-docs\/captains\/documents\//,
    );
    expect((await fetch(nationalId.fileUrls[0])).status).toBe(200);

    // SUP reads the pipeline with the number masked, and acts on nothing.
    const sup = await admin('SUP');
    const masked = await sup('GET', `captain-applications/${id}`);
    expect(masked.json().phone).toBe(`+963 ••• ${who.phone.slice(-3)}`);
    const refused = await sup('POST', `captain-applications/${id}/waitlist`);
    expect(refused.statusCode).toBe(403);
    // A draft is the applicant's.
    const draft = await applicant();
    await draft.call('PUT', '/application/personal', {
      fullName: 'خالد محمد العمر',
      birthDate: '2000-01-01',
      zoneId,
    });
    expect(
      (await ops('GET', `captain-applications/${await applicationOf(draft)}`)).statusCode,
    ).toBe(404);
  });

  it('shows another applicant or captain with the same ID number, phone or plate', async () => {
    const idNumber = `${randomInt(1e9)}77`;
    const first = await sent({ idNumber, plate: 'حلب 5555' });
    const second = await sent({ idNumber, plate: 'حلب5555' });
    await app.get(CaptainsService).createCaptain(
      azaz,
      {
        name: 'كابتن قديم',
        vehicle: 'car',
        plateNumber: 'حلب  5555',
        custodyLimit: { amount: 1_000n, currency: 'TRY' },
      },
      change,
    );
    const ops = await admin('OPS');
    const page = (await ops('GET', `captain-applications/${await applicationOf(second)}`)).json();
    const firstId = await applicationOf(first);
    expect(page.duplicates).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ field: 'id_number', applicationId: firstId }),
        expect.objectContaining({ field: 'plate', applicationId: firstId }),
        expect.objectContaining({
          field: 'plate',
          captainId: expect.any(String),
          fullName: 'كابتن قديم',
        }),
      ]),
    );
  });
});

describe('the pipeline actions (AP §9.7.1, CA §5.4)', () => {
  it('moves the application to «بانتظار العدة», telling the applicant each step', async () => {
    const who = await sent();
    const id = await applicationOf(who);
    const ops = await admin('OPS');
    const page = (await ops('GET', `captain-applications/${id}`)).json();
    const photo = page.documents.find((each: { kind: string }) => each.kind === 'personal_photo');

    // The first action moves «جديد» to «قيد المراجعة» and closes the alert.
    const accepted = await ops('POST', `captain-applications/${id}/documents/${photo.id}/review`, {
      status: 'accepted',
    });
    expect(accepted.statusCode).toBe(200);
    expect(accepted.json().stage).toBe('under_review');
    expect(
      accepted.json().documents.find((each: { id: string }) => each.id === photo.id),
    ).toMatchObject({ status: 'accepted', reviewedBy: expect.stringMatching(/^Operator/) });
    expect(await alertOf(id)).toEqual([expect.objectContaining({ open: false })]);
    // The same review again changes nothing.
    await ops('POST', `captain-applications/${id}/documents/${photo.id}/review`, {
      status: 'accepted',
    });

    // A rejection takes a reason; the applicant uploads that document again.
    const civil = page.documents.find((each: { kind: string }) => each.kind === 'civil_registry');
    const noReason = await ops('POST', `captain-applications/${id}/documents/${civil.id}/review`, {
      status: 'rejected',
    });
    expect(noReason.statusCode).toBe(400);
    await ops('POST', `captain-applications/${id}/documents/${civil.id}/review`, {
      status: 'rejected',
      reason: 'الصورة غير واضحة',
    });
    const notAsked = await who.document('personal_photo');
    expect([notAsked.statusCode, notAsked.json().error]).toEqual([409, 'application_submitted']);
    const again = await who.document('civil_registry');
    expect(again.statusCode).toBe(200);
    expect(
      again
        .json()
        .application.documents.find((each: { kind: string }) => each.kind === 'civil_registry'),
    ).toMatchObject({ status: 'pending' });
    // The old upload is replaced: reviewing it now is refused.
    const stale = await ops('POST', `captain-applications/${id}/documents/${civil.id}/review`, {
      status: 'accepted',
    });
    expect([stale.statusCode, stale.json().error]).toEqual([409, 'document_replaced']);

    // «طلب مستند», answered by the applicant's upload.
    const asked = await ops('POST', `captain-applications/${id}/document-requests`, {
      kind: 'driving_licence',
      reason: 'نحتاج شهادة القيادة',
    });
    expect(asked.json().requests).toEqual([
      expect.objectContaining({ kind: 'driving_licence', reason: 'نحتاج شهادة القيادة' }),
    ]);
    const twice = await ops('POST', `captain-applications/${id}/document-requests`, {
      kind: 'driving_licence',
      reason: 'مرة أخرى',
    });
    expect([twice.statusCode, twice.json().error]).toEqual([409, 'already_requested']);
    expect((await who.call('GET', '/application')).json().application.requests).toEqual([
      expect.objectContaining({ kind: 'driving_licence', reason: 'نحتاج شهادة القيادة' }),
    ]);
    expect((await who.document('driving_licence')).json().application.requests).toEqual([]);

    // A note, once per Idempotency-Key.
    const key = { 'idempotency-key': randomUUID() };
    await ops('POST', `captain-applications/${id}/notes`, { note: 'اتصلت به' }, key);
    const noted = await ops('POST', `captain-applications/${id}/notes`, { note: 'اتصلت به' }, key);
    expect(noted.json().events.filter((each: { kind: string }) => each.kind === 'note')).toEqual([
      expect.objectContaining({ note: 'اتصلت به', actor: expect.stringMatching(/^Operator/) }),
    ]);

    // Training before the interview is refused; then «تحديد مقابلة».
    const early = await ops('POST', `captain-applications/${id}/training-passed`);
    expect(early.statusCode).toBe(409);
    expect(early.json()).toMatchObject({ error: 'wrong_stage', stage: 'under_review' });
    const interview = {
      at: '2099-01-05T07:00:00.000Z',
      place: 'مكتب أعزاز',
      latitude: 36.586,
      longitude: 37.046,
    };
    const past = await ops('PUT', `captain-applications/${id}/interview`, {
      ...interview,
      at: '2020-01-01T07:00:00.000Z',
    });
    expect([past.statusCode, past.json().error]).toEqual([400, 'interview_in_past']);
    const scheduled = await ops('PUT', `captain-applications/${id}/interview`, interview);
    expect(scheduled.json()).toMatchObject({ stage: 'interview', interview });
    expect((await who.call('GET', '/application')).json().application).toMatchObject({
      stage: 'interview',
      interview,
    });
    const passed = await ops('POST', `captain-applications/${id}/training-passed`);
    expect(passed.json().stage).toBe('awaiting_kit');
    const history = (await who.call('GET', '/application')).json().application.history;
    expect(history.map((each: { stage: string }) => each.stage)).toEqual([
      'new',
      'under_review',
      'interview',
      'awaiting_kit',
    ]);

    // Every change the applicant hears, silently, on their account's devices.
    expect(await pushes(who)).toEqual([
      { template_key: 'captain.application_under_review', body: 'طلبك قيد المراجعة.' },
      { template_key: 'captain.document_rejected', body: 'رُفض إخراج قيد: الصورة غير واضحة' },
      {
        template_key: 'captain.application_document_requested',
        body: 'يرجى رفع شهادة قيادة: نحتاج شهادة القيادة',
      },
      {
        template_key: 'captain.application_interview',
        body: 'موعد المقابلة والتدريب: الإثنين 05/01/2099 10:00 ص في مكتب أعزاز',
      },
      {
        template_key: 'captain.application_awaiting_kit',
        body: 'اجتزت التدريب. استلم العدة ووقّع العقد في المكتب.',
      },
    ]);
    const { rows: audited } = await sql.query(
      `SELECT action FROM audit.events
       WHERE target_id = $1 AND action <> 'captain_application.phone_view'
       ORDER BY occurred_at, id`,
      [id],
    );
    expect(audited.map((row: { action: string }) => row.action)).toEqual([
      'captain_application.document_review',
      'captain_application.document_review',
      'captain_application.document_request',
      'captain_application.note',
      'captain_application.interview',
      'captain_application.training_passed',
    ]);
  });

  it('takes the office’s scan of a document', async () => {
    const who = await sent();
    const id = await applicationOf(who);
    const ops = await admin('OPS');
    const asked = await ops('POST', 'uploads', {
      purpose: 'captain_document',
      contentType: 'image/jpeg',
      sizeBytes: jpeg.length,
    });
    expect(asked.statusCode).toBe(201);
    await put(asked.json().url);
    const scanned = await ops('PUT', `captain-applications/${id}/documents/civil_registry`, {
      uploadIds: [asked.json().uploadId],
    });
    expect(scanned.statusCode).toBe(200);
    expect(scanned.json().stage).toBe('under_review');
    expect(
      scanned
        .json()
        .documents.filter((each: { kind: string }) => each.kind === 'civil_registry')
        .map((each: { inForce: boolean; uploadedByOffice: boolean }) => [
          each.inForce,
          each.uploadedByOffice,
        ]),
    ).toEqual([
      [true, true],
      [false, false],
    ]);
    // The same files again (a retry) change nothing.
    const repeated = await ops('PUT', `captain-applications/${id}/documents/civil_registry`, {
      uploadIds: [asked.json().uploadId],
    });
    expect(repeated.statusCode).toBe(200);
    expect(
      repeated.json().documents.filter((each: { kind: string }) => each.kind === 'civil_registry'),
    ).toHaveLength(2);
    expect(
      repeated.json().events.filter((each: { kind: string }) => each.kind === 'document_upload'),
    ).toHaveLength(1);
  });

  it('tells the stage at a note on «جديد», and both the stage and a request', async () => {
    const noted = await sent();
    const ops = await admin('OPS');
    await ops(
      'POST',
      `captain-applications/${await applicationOf(noted)}/notes`,
      { note: 'أول ملاحظة' },
      { 'idempotency-key': randomUUID() },
    );
    expect((await pushes(noted)).map((each) => each.template_key)).toEqual([
      'captain.application_under_review',
    ]);
    const asked = await sent();
    await ops('POST', `captain-applications/${await applicationOf(asked)}/document-requests`, {
      kind: 'driving_licence',
      reason: 'نحتاجها',
    });
    expect((await pushes(asked)).map((each) => each.template_key)).toEqual([
      'captain.application_under_review',
      'captain.application_document_requested',
    ]);
  });

  it('audits each view of the number in full', async () => {
    const who = await sent();
    const id = await applicationOf(who);
    await (
      await admin('OPS')
    )('GET', `captain-applications/${id}`);
    await (
      await admin('SUP')
    )('GET', `captain-applications/${id}`);
    const { rows } = await sql.query(
      `SELECT count(*)::int AS n FROM audit.events
       WHERE target_id = $1 AND action = 'captain_application.phone_view'`,
      [id],
    );
    expect(rows).toEqual([{ n: 1 }]);
  });

  it('waitlists, brings back, rejects, and lets the applicant apply again after 30 days', async () => {
    const who = await sent();
    const id = await applicationOf(who);
    const ops = await admin('OPS');
    expect((await ops('POST', `captain-applications/${id}/waitlist`)).json().stage).toBe(
      'waitlist',
    );
    expect((await ops('POST', `captain-applications/${id}/back-from-waitlist`)).json().stage).toBe(
      'under_review',
    );
    await ops('POST', `captain-applications/${id}/document-requests`, {
      kind: 'driving_licence',
      reason: 'نحتاجها',
    });
    const rejected = await ops('POST', `captain-applications/${id}/reject`, {
      reason: 'لا تتوفر الشروط',
    });
    // Its open requests close with it.
    expect(rejected.json().requests).toEqual([]);
    expect(rejected.json()).toMatchObject({
      stage: 'rejected',
      rejection: { reason: 'لا تتوفر الشروط' },
    });
    const again = await ops('POST', `captain-applications/${id}/reject`, { reason: 'x' });
    expect([again.statusCode, again.json().error]).toEqual([409, 'wrong_stage']);
    const seen = (await who.call('GET', '/application')).json().application;
    expect(seen).toMatchObject({ stage: 'rejected', rejection: { reason: 'لا تتوفر الشروط' } });
    expect(
      new Date(seen.rejection.reapplyFrom).getTime() - new Date(seen.rejection.at).getTime(),
    ).toBe(30 * 24 * 60 * 60 * 1000);
    expect((await pushes(who)).map((each) => each.template_key)).toEqual([
      'captain.application_waitlist',
      'captain.application_under_review',
      'captain.application_document_requested',
      'captain.application_rejected',
    ]);

    const personal = { fullName: 'محمد أحمد العلي', birthDate: '2000-05-01', zoneId };
    const early = await who.call('PUT', '/application/personal', personal);
    expect(early.statusCode).toBe(409);
    expect(early.json()).toMatchObject({
      error: 'reapply_wait',
      reapplyFrom: seen.rejection.reapplyFrom,
    });
    await sql.query(
      "UPDATE captains.applications SET rejected_at = rejected_at - interval '30 days' WHERE id = $1",
      [id],
    );
    const fresh = await who.call('PUT', '/application/personal', personal);
    expect(fresh.json().application).toMatchObject({ stage: 'draft', rejection: null });
    expect(fresh.json().application.id).not.toBe(id);
    // The phone finds the earlier application.
    await who.call('PUT', '/application/vehicle', { vehicle: 'walking' });
    const page = (await ops('GET', `captain-applications/${id}`)).json();
    expect(page.duplicates).toEqual([
      expect.objectContaining({ field: 'phone', applicationId: fresh.json().application.id }),
    ]);
  });
});
