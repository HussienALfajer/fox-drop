import { describe, expect, it } from 'vitest';
import {
  activationMissing,
  documentStates,
  expiredRequired,
  commitmentOf,
  contractPhase,
  probationReview,
  addDays,
  addMonths,
  contractDates,
  depositInstalmentDue,
  depositSettlementOf,
  earlyExit,
  offboardingMissing,
  cityDay,
  criminalRecordExpiry,
  fileCountAllowed,
  mayUploadAgain,
  missing,
  normaliseFullName,
  normaliseIdNumber,
  normalisePlate,
  oldEnough,
  pipelineSteps,
  plateKey,
  reapplyFrom,
  requiredDocuments,
} from './applications.js';

// The application form's rules (CA §5.2–5.3, AP §9.7.1; slice 2.34a).
describe('the application rules', () => {
  it('asks the vehicle papers of a motor vehicle only (CA §5.3)', () => {
    expect(requiredDocuments('motorbike')).toContain('vehicle_papers');
    expect(requiredDocuments('car')).toContain('vehicle_papers');
    expect(requiredDocuments('bicycle')).not.toContain('vehicle_papers');
    expect(requiredDocuments('walking')).not.toContain('vehicle_papers');
    expect(requiredDocuments(null)).not.toContain('driving_licence');
  });

  it('takes the ID front and back, and one or two pages of the others', () => {
    expect([1, 2, 3].map((count) => fileCountAllowed('national_id', count))).toEqual([
      false,
      true,
      false,
    ]);
    expect([0, 1, 2, 3].map((count) => fileCountAllowed('civil_registry', count))).toEqual([
      false,
      true,
      true,
      false,
    ]);
  });

  it('lists what the application still needs, an expired criminal record included (C18)', () => {
    const today = '2026-11-19';
    expect(missing({ vehicle: null, documents: [], termsPending: true, today })).toEqual([
      'vehicle',
      'document:national_id',
      'document:personal_photo',
      'document:civil_registry',
      'document:criminal_record',
      'terms',
    ]);
    const documents = [
      { kind: 'national_id' as const, expiresOn: null },
      { kind: 'personal_photo' as const, expiresOn: null },
      { kind: 'civil_registry' as const, expiresOn: null },
      { kind: 'criminal_record' as const, expiresOn: '2027-01-01' },
    ];
    expect(missing({ vehicle: 'walking', documents, termsPending: false, today })).toEqual([]);
    expect(missing({ vehicle: 'car', documents, termsPending: false, today })).toEqual([
      'document:vehicle_papers',
    ]);
    const expired = documents.map((each) =>
      each.kind === 'criminal_record' ? { ...each, expiresOn: today } : each,
    );
    expect(missing({ vehicle: 'walking', documents: expired, termsPending: false, today })).toEqual(
      ['document:criminal_record'],
    );
  });

  it('wants a three-part name, a plate and an ID number in their forms', () => {
    expect(normaliseFullName('  محمد   أحمد العلي ')).toBe('محمد أحمد العلي');
    expect(normaliseFullName('محمد العلي')).toBeNull();
    expect(normaliseFullName(`${'أ'.repeat(40)} ${'ب'.repeat(40)} ج`)).toBeNull();
    expect(normalisePlate(' 12345  حلب ')).toBe('12345 حلب');
    expect(normalisePlate('   ')).toBeNull();
    expect(normalisePlate('x'.repeat(21))).toBeNull();
    expect(normaliseIdNumber('0123-456 789')).toBe('0123456789');
    expect(normaliseIdNumber('12a45')).toBeNull();
    expect(normaliseIdNumber('1234')).toBeNull();
  });

  it('counts the age and the criminal record by calendar months', () => {
    expect(oldEnough('2008-11-19', 18, '2026-11-19')).toBe(true);
    expect(oldEnough('2008-11-20', 18, '2026-11-19')).toBe(false);
    // Born on 29 February: of age on 28 February of a common year.
    expect(oldEnough('2008-02-29', 18, '2026-02-28')).toBe(true);
    expect(criminalRecordExpiry('2026-01-31', 12)).toBe('2027-01-31');
    expect(addMonths('2026-01-31', 1)).toBe('2026-02-28');
    expect(addMonths('2025-12-15', 2)).toBe('2026-02-15');
  });

  it("reads the day on the city's clock", () => {
    expect(cityDay(new Date('2026-11-18T21:30:00Z'), 'Asia/Damascus')).toBe('2026-11-19');
  });
});

// The panel's pipeline (AP §9.7.1, CA §5.4; slice 2.34b).
describe('the pipeline rules', () => {
  it('moves a new application to «قيد المراجعة» at the first staff action', () => {
    expect(pipelineSteps('review_document', 'new')).toEqual(['under_review']);
    expect(pipelineSteps('note', 'new')).toEqual(['under_review']);
    expect(pipelineSteps('note', 'interview')).toEqual([]);
    expect(pipelineSteps('schedule_interview', 'new')).toEqual(['under_review', 'interview']);
    expect(pipelineSteps('reject', 'new')).toEqual(['under_review', 'rejected']);
  });

  it('records training passed from the interview only', () => {
    expect(pipelineSteps('training_passed', 'interview')).toEqual(['awaiting_kit']);
    expect(pipelineSteps('training_passed', 'under_review')).toBeNull();
    expect(pipelineSteps('training_passed', 'new')).toBeNull();
  });

  it('schedules an interview again, but not once training is passed', () => {
    expect(pipelineSteps('schedule_interview', 'interview')).toEqual(['interview']);
    expect(pipelineSteps('schedule_interview', 'awaiting_kit')).toBeNull();
  });

  it('takes a waitlisted application back to «قيد المراجعة»', () => {
    expect(pipelineSteps('waitlist', 'awaiting_kit')).toEqual(['waitlist']);
    expect(pipelineSteps('waitlist', 'waitlist')).toBeNull();
    expect(pipelineSteps('back_from_waitlist', 'waitlist')).toEqual(['under_review']);
    expect(pipelineSteps('back_from_waitlist', 'under_review')).toBeNull();
    expect(pipelineSteps('reject', 'waitlist')).toEqual(['rejected']);
  });

  it('takes nothing on a draft, a rejected or an active application', () => {
    for (const stage of ['draft', 'rejected', 'active'] as const) {
      for (const action of [
        ...(stage === 'active' ? [] : (['review_document', 'upload_document'] as const)),
        'request_document',
        'note',
        'schedule_interview',
        'reject',
        'waitlist',
      ] as const) {
        expect(pipelineSteps(action, stage)).toBeNull();
      }
    }
  });

  it('reviews and scans a captain’s documents and confirms the probation once active (slice 2.35a)', () => {
    expect(pipelineSteps('review_document', 'active')).toEqual([]);
    expect(pipelineSteps('upload_document', 'active')).toEqual([]);
    expect(pipelineSteps('confirm_probation', 'active')).toEqual([]);
    expect(pipelineSteps('confirm_probation', 'awaiting_kit')).toBeNull();
    expect(pipelineSteps('activate', 'awaiting_kit')).toEqual(['active']);
  });

  it('lets the applicant apply again 30 days after a rejection (K11)', () => {
    expect(reapplyFrom(new Date('2026-11-19T10:00:00Z'))).toEqual(new Date('2026-12-19T10:00:00Z'));
  });

  it('lets the applicant upload again only what was asked for or rejected', () => {
    expect(mayUploadAgain('under_review', { requested: true, rejected: false })).toBe(true);
    expect(mayUploadAgain('interview', { requested: false, rejected: true })).toBe(true);
    expect(mayUploadAgain('under_review', { requested: false, rejected: false })).toBe(false);
    expect(mayUploadAgain('rejected', { requested: true, rejected: true })).toBe(false);
    expect(mayUploadAgain('draft', { requested: true, rejected: false })).toBe(false);
  });

  it('compares plates without spaces in lower case', () => {
    expect(plateKey('AB 12 34')).toBe(plateKey('ab1234'));
  });
});

// The activation's rules (AP §9.7.1–9.7.2, D24; slice 2.35a).
describe('the activation rules', () => {
  const accepted = (kind: string, expiresOn: string | null = null) => ({
    kind: kind as never,
    status: 'accepted' as const,
    expiresOn,
  });
  const ready = {
    vehicle: 'motorbike' as const,
    documents: [
      accepted('national_id'),
      accepted('personal_photo'),
      accepted('civil_registry'),
      accepted('criminal_record', '2027-05-01'),
      accepted('vehicle_papers'),
      accepted('signed_contract'),
    ],
    kitIssued: true,
    depositRecorded: true,
    contractRecorded: true,
    cashLimitSet: true,
    today: '2026-11-19',
  };

  it('needs nothing more once every record is in', () => {
    expect(activationMissing(ready)).toEqual([]);
  });

  it('names each record still missing, in the order of AP §9.7.1', () => {
    expect(
      activationMissing({
        ...ready,
        documents: [],
        kitIssued: false,
        depositRecorded: false,
        contractRecorded: false,
        cashLimitSet: false,
      }),
    ).toEqual([
      'document:national_id',
      'document:personal_photo',
      'document:civil_registry',
      'document:criminal_record',
      'document:vehicle_papers',
      'document:signed_contract',
      'kit',
      'deposit',
      'contract',
      'cash_limit',
    ]);
  });

  it('counts a document only once accepted and not expired', () => {
    const documents = ready.documents.map((document) =>
      document.kind === 'civil_registry'
        ? { ...document, status: 'pending' as const }
        : document.kind === 'criminal_record'
          ? { ...document, expiresOn: '2026-11-19' }
          : document,
    );
    expect(activationMissing({ ...ready, documents })).toEqual([
      'document:civil_registry',
      'document:criminal_record',
    ]);
  });

  it('asks no vehicle papers of a bicycle, and never the optional licence', () => {
    expect(
      activationMissing({
        ...ready,
        vehicle: 'bicycle',
        documents: ready.documents.filter((document) => document.kind !== 'vehicle_papers'),
      }),
    ).toEqual([]);
  });

  it('computes the probation end and the commitment end from the start (D24)', () => {
    expect(addDays('2026-11-20', 30)).toBe('2026-12-20');
    expect(
      contractDates({ startsOn: '2026-11-20', probationDays: 30, commitmentMonths: 3 }),
    ).toEqual({ probationEndsOn: '2026-12-20', commitmentEndsOn: '2027-03-20' });
  });

  it('deducts the instalment until the deposit is paid, the last one what is left', () => {
    expect(depositInstalmentDue({ amount: 50_000n, paid: 10_000n, instalment: 15_000n })).toBe(
      15_000n,
    );
    expect(depositInstalmentDue({ amount: 50_000n, paid: 40_000n, instalment: 15_000n })).toBe(
      10_000n,
    );
    expect(depositInstalmentDue({ amount: 50_000n, paid: 50_000n, instalment: 15_000n })).toBe(0n);
    expect(depositInstalmentDue({ amount: 50_000n, paid: 0n, instalment: null })).toBe(0n);
  });
});

// The contract's phases (AP §9.7.2, D24; slice 2.35a).
describe('the contract phases', () => {
  it('starts the commitment at the probation end when confirmed on time, else at the confirmation', () => {
    expect(
      commitmentOf({ probationEndsOn: '2026-12-20', confirmedOn: '2026-12-18', months: 3 }),
    ).toEqual({ startsOn: '2026-12-20', endsOn: '2027-03-20' });
    expect(
      commitmentOf({ probationEndsOn: '2026-12-20', confirmedOn: '2026-12-27', months: 3 }),
    ).toEqual({ startsOn: '2026-12-27', endsOn: '2027-03-27' });
  });

  it('stays in «فترة تجربة» until the commitment starts, then «مفتوح» at its end', () => {
    const confirmed = { commitmentStartsOn: '2026-12-20', commitmentEndsOn: '2027-03-20' };
    const none = { commitmentStartsOn: null, commitmentEndsOn: null };
    expect(contractPhase(none, '2027-06-01')).toBe('probation');
    expect(contractPhase(confirmed, '2026-12-19')).toBe('probation');
    expect(contractPhase(confirmed, '2026-12-20')).toBe('commitment');
    expect(contractPhase(confirmed, '2027-03-19')).toBe('commitment');
    expect(contractPhase(confirmed, '2027-03-20')).toBe('open');
  });

  it('asks the review from the notice, and warns once the probation ended without it', () => {
    const review = (today: string, confirmed = false) =>
      probationReview({ probationEndsOn: '2026-12-20', noticeDays: 3, confirmed, today });
    expect(review('2026-12-16')).toBe('none');
    expect(review('2026-12-17')).toBe('due');
    expect(review('2026-12-19')).toBe('due');
    expect(review('2026-12-20')).toBe('overdue');
    expect(review('2026-12-25', true)).toBe('none');
  });
});

// A captain's documents after activation (CA §12.2, AP §9.7.4, K6; slice
// 2.35a): the newest accepted upload of a kind is the one in force until it
// expires, a replacement waiting beside it.
describe('the documents of a captain', () => {
  const at = (day: number) => new Date(Date.UTC(2026, 10, day));
  const upload = (
    id: string,
    kind: string,
    status: 'pending' | 'accepted' | 'rejected',
    expiresOn: string | null,
    day: number,
  ) => ({ id, kind: kind as never, status, expiresOn, createdAt: at(day) });

  it('keeps the old document valid while its replacement waits', () => {
    const states = documentStates(
      [
        upload('old', 'criminal_record', 'accepted', '2026-12-10', 1),
        upload('new', 'criminal_record', 'pending', '2027-11-15', 15),
      ],
      '2026-11-19',
      30,
    );
    expect(states.get('criminal_record')).toEqual({
      valid: expect.objectContaining({ id: 'old' }),
      pending: expect.objectContaining({ id: 'new' }),
      state: 'expiring',
    });
  });

  it('says valid, expiring from the notice, expired on the day, missing without one', () => {
    const state = (expiresOn: string | null, today: string) =>
      documentStates([upload('d', 'criminal_record', 'accepted', expiresOn, 1)], today, 30).get(
        'criminal_record',
      )?.state;
    expect(state(null, '2030-01-01')).toBe('valid');
    expect(state('2026-12-30', '2026-11-29')).toBe('valid');
    expect(state('2026-12-30', '2026-11-30')).toBe('expiring');
    expect(state('2026-12-30', '2026-12-30')).toBe('expired');
    expect(
      documentStates([upload('d', 'civil_registry', 'rejected', null, 1)], '2026-11-19', 30).get(
        'civil_registry',
      )?.state,
    ).toBe('missing');
  });

  it('blocks going online for an expired required document only (K6)', () => {
    const states = documentStates(
      [
        upload('a', 'criminal_record', 'accepted', '2026-11-10', 1),
        upload('b', 'driving_licence', 'accepted', '2026-11-10', 1),
        upload('c', 'national_id', 'accepted', null, 1),
      ],
      '2026-11-19',
      30,
    );
    expect(expiredRequired(states, 'bicycle')).toEqual(['criminal_record']);
  });
});

// The offboarding checklist (AP §9.7.5, §9.7.2, C17; slice 2.35b).
describe('the offboarding', () => {
  const contract = { commitmentStartsOn: '2026-12-01', commitmentEndsOn: '2027-03-01' };

  it('flags «خروج مبكر» only when the contract ends in «فترة التزام» (owner decision 2026-11-19)', () => {
    expect(earlyExit(contract, '2026-11-30')).toBe(false);
    expect(earlyExit(contract, '2026-12-01')).toBe(true);
    expect(earlyExit(contract, '2027-02-28')).toBe(true);
    expect(earlyExit(contract, '2027-03-01')).toBe(false);
    expect(earlyExit({ commitmentStartsOn: null, commitmentEndsOn: null }, '2027-06-01')).toBe(
      false,
    );
  });

  it('refunds the deposit when the kit came back and withholds it otherwise (C17)', () => {
    expect(depositSettlementOf(true)).toBe('refunded');
    expect(depositSettlementOf(false)).toBe('withheld');
  });

  it("lists every step left before the account closes, in the checklist's order", () => {
    expect(
      offboardingMissing({
        kitReturned: null,
        custodyZero: false,
        earningsZero: false,
        depositHeld: 50000n,
      }),
    ).toEqual(['kit', 'custody', 'earnings', 'deposit']);
    expect(
      offboardingMissing({
        kitReturned: false,
        custodyZero: true,
        earningsZero: true,
        depositHeld: 0n,
      }),
    ).toEqual([]);
    expect(
      offboardingMissing({
        kitReturned: true,
        custodyZero: true,
        earningsZero: false,
        depositHeld: 1n,
      }),
    ).toEqual(['earnings', 'deposit']);
  });
});
