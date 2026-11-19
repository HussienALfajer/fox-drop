import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const {
  actionsOf,
  applicationOfAlert,
  boardSearch,
  canSeeApplications,
  commandResult,
  countOf,
  documentKindsOf,
  interviewBody,
  interviewFormOf,
  reasonOf,
  scanProblem,
} = await import('./captain-applications.js');

const session = (permissions: string[]) => ({ permissions }) as never;
const manage = session(['captains.read', 'captains.manage']);

// AP §9.7.1 «طلبات الانضمام» (slice 2.34b).
describe('canSeeApplications', () => {
  it('needs captains.read', () => {
    expect(canSeeApplications(session(['captains.read']))).toBe(true);
    expect(canSeeApplications(session(['operations.read']))).toBe(false);
    expect(canSeeApplications(null)).toBe(false);
  });
});

describe('boardSearch', () => {
  it('keeps the city and a board stage', () => {
    expect(boardSearch({ city: 'AZ', stage: 'waitlist' })).toEqual({
      city: 'AZ',
      stage: 'waitlist',
    });
    // The draft is the applicant's, never on the board.
    expect(boardSearch({ stage: 'draft' })).toEqual({});
    expect(boardSearch({ stage: 3, city: 1 })).toEqual({});
  });
});

describe('countOf', () => {
  it('counts a stage the server left out as 0', () => {
    expect(countOf({ new: 3 }, 'new')).toBe(3);
    expect(countOf({ new: 3 }, 'rejected')).toBe(0);
  });
});

// Mirrors the server's pipelineSteps (apps/server/.../captains/applications.ts).
describe('actionsOf', () => {
  const actions = (stage: Parameters<typeof actionsOf>[1]) => [...actionsOf(manage, stage)].sort();
  const documents = ['note', 'request_document', 'review_document', 'upload_document'];

  it('offers the documents, the interview, the waitlist and the rejection while new or in review', () => {
    for (const stage of ['new', 'under_review'] as const) {
      expect(actions(stage)).toEqual(
        [...documents, 'reject', 'schedule_interview', 'waitlist'].sort(),
      );
    }
  });

  it('records the training only at the interview', () => {
    expect(actions('interview')).toEqual(
      [...documents, 'reject', 'schedule_interview', 'training_passed', 'waitlist'].sort(),
    );
    expect(actions('awaiting_kit')).toEqual([...documents, 'reject', 'waitlist'].sort());
  });

  it('brings a waitlisted application back to the review', () => {
    expect(actions('waitlist')).toEqual([...documents, 'back_from_waitlist', 'reject'].sort());
  });

  it('offers nothing once active or rejected, or without captains.manage', () => {
    expect(actions('active')).toEqual([]);
    expect(actions('rejected')).toEqual([]);
    expect(actions('draft')).toEqual([]);
    expect(actionsOf(session(['captains.read']), 'new').size).toBe(0);
  });
});

describe('documentKindsOf', () => {
  it('lists the required documents and the optional driving licence in order', () => {
    expect(
      documentKindsOf({
        requiredDocuments: ['criminal_record', 'national_id', 'personal_photo', 'civil_registry'],
      }),
    ).toEqual([
      'national_id',
      'personal_photo',
      'civil_registry',
      'criminal_record',
      'driving_licence',
    ]);
  });
});

describe('applicationOfAlert', () => {
  it('opens the application of «طلب انضمام كابتن»', () => {
    const alert = (code: string, subjectType: string) =>
      ({ code, subjectType, subjectId: 'a1' }) as never;
    expect(applicationOfAlert(alert('captain_application', 'captain_application'))).toBe('a1');
    expect(applicationOfAlert(alert('urgent_ticket', 'ticket'))).toBeNull();
  });
});

describe('commandResult', () => {
  const answer = (status: number, error?: unknown) => ({
    error,
    response: new Response(null, { status }),
  });

  it('answers the review page', () => {
    const application = { id: 'a1' } as never;
    expect(commandResult({ data: application, response: new Response() })).toEqual({
      status: 'done',
      application,
    });
  });

  it('maps the refusals, with the stage the application is in', () => {
    expect(commandResult(answer(409, { error: 'wrong_stage', stage: 'rejected' }))).toEqual({
      status: 'refused',
      refusal: 'wrong_stage',
      stage: 'rejected',
    });
    expect(commandResult(answer(404, { error: 'unknown_document' }))).toEqual({
      status: 'refused',
      refusal: 'unknown_document',
    });
    expect(commandResult(answer(400, { error: 'interview_in_past' }))).toEqual({
      status: 'refused',
      refusal: 'interview_in_past',
    });
    expect(commandResult(answer(409, { error: 'already_requested' })).status).toBe('refused');
  });

  it('maps the uploads’ refusals', () => {
    expect(commandResult(answer(400, { error: 'upload_invalid' }))).toEqual({
      status: 'refused',
      refusal: 'not_image',
    });
    expect(commandResult(answer(409, { error: 'upload_used' }))).toEqual({
      status: 'refused',
      refusal: 'upload_failed',
    });
  });

  it('throws on anything else', () => {
    expect(() => commandResult(answer(500))).toThrow();
    expect(() => commandResult(answer(409, { error: 'something_new' }))).toThrow();
  });
});

describe('reasonOf', () => {
  it('requires a reason of up to 500 characters, trimmed', () => {
    expect(reasonOf(' الصورة غير واضحة ')).toBe('الصورة غير واضحة');
    expect(reasonOf('  ')).toBeNull();
    expect(reasonOf('x'.repeat(501))).toBeNull();
  });
});

describe('interviewBody', () => {
  const timeZone = 'Asia/Damascus';
  const now = Date.parse('2026-11-19T09:00:00.000Z');
  const form = {
    at: '2026-11-20T10:30',
    place: 'مكتب أعزاز',
    latitude: '36.5',
    longitude: '37.05',
  };

  it('sends the time on the city’s clock as an instant', () => {
    expect(interviewBody(form, timeZone, now)).toEqual({
      body: {
        at: '2026-11-20T07:30:00.000Z',
        place: 'مكتب أعزاز',
        latitude: 36.5,
        longitude: 37.05,
      },
    });
  });

  it('names the first problem', () => {
    expect(interviewBody({ ...form, at: '' }, timeZone, now)).toEqual({ problem: 'at' });
    expect(interviewBody({ ...form, at: '2026-11-19T11:00' }, timeZone, now)).toEqual({
      problem: 'in_past',
    });
    expect(interviewBody({ ...form, place: ' ' }, timeZone, now)).toEqual({ problem: 'place' });
    expect(interviewBody({ ...form, latitude: '95' }, timeZone, now)).toEqual({
      problem: 'point',
    });
  });

  it('starts from the interview set', () => {
    expect(
      interviewFormOf(
        { at: '2026-11-20T07:30:00.000Z', place: 'المكتب', latitude: 36.5, longitude: 37.05 },
        timeZone,
      ),
    ).toEqual({ at: '2026-11-20T10:30', place: 'المكتب', latitude: '36.5', longitude: '37.05' });
    expect(interviewFormOf(null, timeZone)).toEqual({
      at: '',
      place: '',
      latitude: '',
      longitude: '',
    });
  });
});

describe('scanProblem', () => {
  const file = new File(['x'], 'scan.jpg', { type: 'image/jpeg' });

  it('takes the ID’s two sides with its number', () => {
    const id = { kind: 'national_id' as const, number: '', issueDate: '' };
    expect(scanProblem({ ...id, files: [file] })).toBe('files');
    expect(scanProblem({ ...id, files: [file, file] })).toBe('number');
    expect(scanProblem({ ...id, files: [file, file], number: '01234567' })).toBeNull();
  });

  it('takes one or two pages of the others, and the criminal record’s issue date', () => {
    const record = { kind: 'criminal_record' as const, number: '', issueDate: '' };
    expect(scanProblem({ ...record, files: [] })).toBe('files');
    expect(scanProblem({ ...record, files: [file, file, file] })).toBe('files');
    expect(scanProblem({ ...record, files: [file] })).toBe('issue_date');
    expect(scanProblem({ ...record, files: [file], issueDate: '2026-10-01' })).toBeNull();
    expect(
      scanProblem({ kind: 'personal_photo', files: [file], number: '', issueDate: '' }),
    ).toBeNull();
  });
});
