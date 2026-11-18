import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const drafts = await import('./restaurant-drafts.js');
const {
  accountBody,
  basicsBody,
  basisPointsOf,
  canSaveStep,
  commissionBody,
  commissionFormOf,
  contractProblem,
  localStyle,
  locationBody,
  operationsBody,
  operationsFormOf,
  phoneOf,
  stepsDone,
} = drafts;

const session = (permissions: string[]) =>
  ({ permissions }) as unknown as Parameters<typeof canSaveStep>[0];

const choices = {
  categories: [],
  categoriesMax: 5,
  zones: [],
  baseCurrency: 'TRY',
  centre: null,
  prepFloorMin: 5,
  prepCeilingMin: 90,
  defaultPrepMin: 20,
  defaultMinimumOrder: { amount: '10000', currency: 'TRY' },
  defaultCommissionBp: 1500,
  nameMax: 80,
  descriptionMax: 300,
  addressMax: 200,
};

const emptyDays = { 6: [], 0: [], 1: [], 2: [], 3: [], 4: [], 5: [] };

describe('who saves each step (AP §9.6.3)', () => {
  it('gives steps 1–3 and 5 to restaurants.create, 4 to OWN, 6 to OPS and OWN', () => {
    const data = session(['restaurants.create']);
    expect(canSaveStep(data, 'basics')).toBe(true);
    expect(canSaveStep(data, 'contract')).toBe(true);
    expect(canSaveStep(data, 'commission')).toBe(false);
    expect(canSaveStep(data, 'accounts')).toBe(false);
    expect(canSaveStep(session(['restaurants.commission']), 'commission')).toBe(true);
    expect(canSaveStep(session(['restaurants.owner_accounts']), 'accounts')).toBe(true);
  });

  it('counts step 6 done with an owner account', () => {
    expect(stepsDone(null, []).accounts).toBe(false);
    expect(
      stepsDone(null, [{ id: 'a', role: 'cashier', name: 'كاشير', phone: '+963944000001' }])
        .accounts,
    ).toBe(false);
    expect(
      stepsDone(null, [{ id: 'a', role: 'owner', name: 'مالك', phone: '+963944000001' }]).accounts,
    ).toBe(true);
  });
});

describe('the steps’ bodies', () => {
  it('needs an Arabic name at step 1 and sends empty texts as null', () => {
    expect(
      basicsBody({ nameAr: ' ', nameEn: '', categoryIds: [], description: '' }, 'city'),
    ).toBeNull();
    expect(
      basicsBody({ nameAr: ' مطعم ', nameEn: ' ', categoryIds: ['c'], description: '' }, 'city'),
    ).toEqual({
      cityId: 'city',
      nameAr: 'مطعم',
      nameEn: null,
      categoryIds: ['c'],
      description: null,
    });
  });

  it('reads the pin and the restaurant’s number at step 2', () => {
    const form = {
      latitude: '36.5862',
      longitude: '37.0471',
      address: '',
      phone: '021 123 4567',
      ownerName: 'أبو أحمد',
    };
    expect(locationBody(form)).toEqual({
      body: {
        location: { latitude: 36.5862, longitude: 37.0471 },
        address: null,
        phone: '+963211234567',
        ownerName: 'أبو أحمد',
      },
    });
    expect(locationBody({ ...form, latitude: '91' })).toEqual({ problem: 'pin' });
    expect(locationBody({ ...form, phone: '12' })).toEqual({ problem: 'phone' });
  });

  it('turns typed Syrian numbers into E.164', () => {
    expect(phoneOf('0944 123 456')).toBe('+963944123456');
    expect(phoneOf('+905321234567')).toBe('+905321234567');
    expect(phoneOf('944')).toBeNull();
  });

  it('builds step 3 with several periods a day, past midnight, in the base currency', () => {
    const form = {
      ...operationsFormOf(null, choices),
      days: {
        ...emptyDays,
        5: [
          { from: '10:00', to: '15:00' },
          { from: '18:00', to: '02:00' },
        ],
      },
      radiusKm: '2.5',
    };
    expect(form.minimumOrder).toBe('100.00');
    expect(operationsBody(form, 'TRY')).toEqual({
      body: {
        periods: [
          { weekday: 5, opensAt: 600, closesAt: 900 },
          { weekday: 5, opensAt: 1080, closesAt: 120 },
        ],
        defaultPrepMin: 20,
        minimumOrder: { amount: '10000', currency: 'TRY' },
        coverage: { kind: 'radius', radiusMetres: 2500, zoneIds: [] },
      },
    });
    expect(operationsBody({ ...form, days: emptyDays }, 'TRY')).toEqual({ problem: 'no_hours' });
    expect(
      operationsBody({ ...form, days: { ...emptyDays, 1: [{ from: '10:00', to: '' }] } }, 'TRY'),
    ).toEqual({ problem: 'hours', day: 1 });
    expect(operationsBody({ ...form, coverage: 'zones' }, 'TRY')).toEqual({ problem: 'zones' });
    expect(operationsBody(form, null)).toEqual({ problem: 'no_base' });
  });

  it('reads step 4’s percentages, and a launch rate until a date on the city’s clock', () => {
    expect(basisPointsOf('12.5')).toBe(1250);
    expect(basisPointsOf('101')).toBeNull();
    expect(commissionFormOf(null, choices, 'Asia/Damascus').rate).toBe('15');
    const form = { rate: '15', launch: true, launchRate: '10', standardFrom: '2027-02-01' };
    expect(commissionBody(form, 'Asia/Damascus')).toEqual({
      body: { rateBp: 1500, launch: { rateBp: 1000, until: '2027-01-31T21:00:00.000Z' } },
    });
    expect(commissionBody({ ...form, standardFrom: '' }, 'Asia/Damascus')).toEqual({
      problem: 'standard_from',
    });
    expect(commissionBody({ ...form, launch: false }, 'Asia/Damascus')).toEqual({
      body: { rateBp: 1500, launch: null },
    });
  });

  it('checks step 5’s date, duration and scans before uploading', () => {
    const form = {
      signedOn: '2026-11-15',
      durationMonths: '12',
      contractFile: null,
      licenceFile: null,
    };
    expect(contractProblem(form)).toBeNull();
    expect(contractProblem({ ...form, durationMonths: '0' })).toBe('duration');
    expect(contractProblem({ ...form, signedOn: '' })).toBe('signed_on');
    const gif = new File(['x'], 'scan.gif', { type: 'image/gif' });
    expect(contractProblem({ ...form, contractFile: gif })).toBe('scan');
  });

  it('takes a Syrian or Turkish mobile for an account', () => {
    expect(accountBody({ role: 'owner', name: ' مالك ', phone: '0944123456' })).toEqual({
      role: 'owner',
      name: 'مالك',
      phone: '+963944123456',
    });
    expect(accountBody({ role: 'owner', name: 'مالك', phone: '0211234567' })).toBeNull();
    expect(accountBody({ role: 'cashier', name: ' ', phone: '0944123456' })).toBeNull();
  });
});

describe('localStyle', () => {
  it('moves every map file of the style to the panel’s own /maps/', () => {
    const api = 'https://api.example.test/maps';
    const style = {
      version: 8,
      glyphs: `${api}/b1/fonts/{fontstack}/{range}.pbf`,
      sprite: `${api}/b1/sprites/light`,
      sources: { protomaps: { type: 'vector', url: `pmtiles://${api}/b1/region.pmtiles` } },
      layers: [{ id: 'water' }],
    };
    expect(localStyle(style, 'https://panel.example.test')).toEqual({
      ...style,
      glyphs: 'https://panel.example.test/maps/b1/fonts/{fontstack}/{range}.pbf',
      sprite: 'https://panel.example.test/maps/b1/sprites/light',
      sources: {
        protomaps: {
          type: 'vector',
          url: 'pmtiles://https://panel.example.test/maps/b1/region.pmtiles',
        },
      },
    });
  });
});

describe('phoneOf with Turkish numbers', () => {
  it('reads a Turkish mobile typed from 0', () => {
    expect(phoneOf('0532 111 2233')).toBe('+905321112233');
  });
});
