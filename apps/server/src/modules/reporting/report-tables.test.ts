import { describe, expect, it } from 'vitest';
import type { ReportOrder } from '../ordering/index.js';
import {
  ageBand,
  averageMinutes,
  basisPoints,
  businessDay,
  captainsReport,
  cityHour,
  codesReport,
  customersReport,
  ordersReport,
  restaurantsReport,
  timingsReport,
  topCustomerIds,
} from './report-tables.js';

const clock = { timeZone: 'Asia/Damascus', cutoffMinutes: 4 * 60 };
const at = (iso: string) => new Date(iso);

// An order placed at 12:00 Damascus (09:00 UTC) on 2026-11-18 and delivered
// normally; each test changes what it is about.
function order(overrides: Partial<ReportOrder> = {}): ReportOrder {
  return {
    id: crypto.randomUUID(),
    restaurantId: 'r1',
    zoneId: 'z1',
    captainId: 'c1',
    customerAccountId: 'a1',
    status: 'delivered',
    outcome: 'normal',
    currency: 'TRY',
    itemsValue: 10_000n,
    placedAt: at('2026-11-18T09:00:00Z'),
    acceptedAt: at('2026-11-18T09:02:00Z'),
    acceptedBy: 'restaurant',
    prepMin: 15,
    readyAt: at('2026-11-18T09:12:00Z'),
    readyByPickup: false,
    searchStartedAt: at('2026-11-18T09:05:00Z'),
    assignedAt: at('2026-11-18T09:08:00Z'),
    arrivedAtMerchantAt: at('2026-11-18T09:10:00Z'),
    pickedUpAt: at('2026-11-18T09:14:00Z'),
    deliveredAt: at('2026-11-18T09:30:00Z'),
    promisedAt: at('2026-11-18T09:35:00Z'),
    rejectedBy: null,
    rejectReason: null,
    rejectReasonLabel: null,
    cancelReason: null,
    cancelReasonLabel: null,
    cancelledBy: null,
    cancelledFrom: null,
    cancelResponsible: null,
    firstOrder: false,
    ...overrides,
  };
}

const table = (tables: ReturnType<typeof ordersReport>, key: string) =>
  tables.find((each) => each.key === key)!;

describe('the shared rules', () => {
  it('shares in basis points and averages minutes to one decimal', () => {
    expect(basisPoints(1, 3)).toBe(3333);
    expect(basisPoints(1, 0)).toBeNull();
    expect(averageMinutes([1, 2])).toBe('1.5');
    expect(averageMinutes([])).toBeNull();
  });

  it('places a moment in its business day and hour on the city clock', () => {
    // 03:30 Damascus is before the 04:00 cutoff: the day before.
    expect(businessDay(at('2026-11-18T00:30:00Z'), clock)).toBe('2026-11-17');
    expect(businessDay(at('2026-11-18T01:30:00Z'), clock)).toBe('2026-11-18');
    expect(cityHour(at('2026-11-18T09:00:00Z'), clock)).toBe(12);
  });

  it('bands an age on the period’s last day', () => {
    expect(ageBand('2008-11-21', '2026-11-20')).toBe('under_18');
    expect(ageBand('2008-11-20', '2026-11-20')).toBe('18_24');
    expect(ageBand('1990-01-01', '2026-11-20')).toBe('35_44');
    expect(ageBand(null, '2026-11-20')).toBe('unknown');
  });
});

describe('the orders report (AP §9.17)', () => {
  const orders = [
    order(),
    order({ status: 'cancelled', cancelReason: 'changed_mind', cancelledBy: 'customer' }),
    order({
      status: 'cancelled',
      cancelReason: 'merchant_auto_cancel',
      cancelledBy: 'system',
      restaurantId: 'r2',
      zoneId: 'z2',
    }),
    order({
      status: 'rejected',
      rejectReason: 'closed',
      rejectReasonLabel: 'المطعم مغلق',
      rejectedBy: 'admin',
      placedAt: at('2026-11-19T09:00:00Z'),
    }),
    order({ status: 'failed', outcome: 'fake' }),
  ];
  const tables = ordersReport({
    orders,
    clock,
    days: ['2026-11-18', '2026-11-19', '2026-11-20'],
    zoneNames: new Map([
      ['z1', 'الحي الأول'],
      ['z2', 'الحي الثاني'],
    ]),
    restaurantNames: new Map([
      ['r1', 'مطعم أ'],
      ['r2', 'مطعم ب'],
    ]),
    cancelLabels: new Map([['changed_mind', 'غيّرت رأيي']]),
  });

  it('counts the outcomes and the success rate', () => {
    expect(table(tables, 'summary').rows[0]!.cells).toEqual(['5', '1', '2', '1', '1', '0', '2000']);
  });

  it('lists every day of the period, a day without an order in zeros', () => {
    const days = table(tables, 'by_day').rows;
    expect(days.map((row) => [row.code, row.cells[0]])).toEqual([
      ['2026-11-18', '4'],
      ['2026-11-19', '1'],
      ['2026-11-20', '0'],
    ]);
  });

  it('lists the 24 hours from the cutoff’s', () => {
    const hours = table(tables, 'by_hour').rows;
    expect(hours).toHaveLength(24);
    expect(hours[0]!.code).toBe('4');
    expect(hours.find((row) => row.code === '12')!.cells[0]).toBe('5');
  });

  it('names zones and restaurants, the most orders first', () => {
    expect(table(tables, 'by_zone').rows.map((row) => row.label)).toEqual([
      'الحي الأول',
      'الحي الثاني',
    ]);
  });

  it('splits the cancellations by reason and who cancelled', () => {
    expect(
      table(tables, 'cancellations').rows.map((row) => [row.code, row.label, ...row.cells]),
    ).toEqual(
      expect.arrayContaining([
        ['changed_mind', 'غيّرت رأيي', '1', 'customer', null],
        ['merchant_auto_cancel', null, '1', 'system', null],
      ]),
    );
  });

  it('splits the rejections by reason and party, and counts the outcomes', () => {
    expect(table(tables, 'rejections').rows[0]).toMatchObject({
      label: 'المطعم مغلق',
      cells: ['1', 'admin'],
    });
    expect(table(tables, 'outcomes').rows.map((row) => [row.code, row.cells[0]])).toEqual([
      ['fake', '1'],
      ['normal', '1'],
    ]);
  });
});

describe('the timings report (AP §9.17)', () => {
  it('averages each leg and rates the late deliveries', () => {
    const tables = timingsReport([
      order(),
      order({ deliveredAt: at('2026-11-18T09:40:00Z'), readyAt: at('2026-11-18T09:20:00Z') }),
      // Accepted on the restaurant's behalf: no acceptance time of its own.
      order({ acceptedBy: 'admin', status: 'accepted', deliveredAt: null, pickedUpAt: null }),
    ]);
    const averages = Object.fromEntries(tables[0]!.rows.map((row) => [row.code, row.cells]));
    expect(averages.acceptance).toEqual(['2.0', '2']);
    expect(averages.prepActual).toEqual(['12.7', '3']);
    expect(averages.prepChosen).toEqual(['15.0', '3']);
    expect(averages.findCaptain).toEqual(['3.0', '3']);
    expect(averages.deliveryLeg).toEqual(['21.0', '2']);
    expect(averages.total).toEqual(['35.0', '2']);
    // One of two delivered after its promised time; one of three ready late.
    expect(tables[1]!.rows[0]!.cells).toEqual(['2', '1', '5000', '3333']);
  });
});

describe('the restaurants report (AP §9.17)', () => {
  it('ranks the restaurants by orders with their figures', () => {
    const [ranking] = restaurantsReport({
      orders: [
        order(),
        order({ status: 'rejected', acceptedAt: null }),
        order({ status: 'cancelled', cancelReason: 'merchant_auto_cancel', acceptedAt: null }),
        order({ currency: 'USD' }),
      ],
      restaurants: [
        { id: 'r1', name: 'مطعم أ' },
        { id: 'r2', name: 'مطعم ب' },
      ],
      ratings: new Map([['r1', { count: 2, total: 9 }]]),
      pauses: new Map([['r1', 45]]),
      currency: 'TRY',
    });
    expect(ranking!.rows[0]).toEqual({
      code: null,
      label: 'مطعم أ',
      // Sales in TRY only; 2 accepted of 4 answered.
      cells: ['4', '10000', '5000', '1', '0', '4.5', '2', '1', '45'],
    });
    expect(ranking!.rows[1]!.cells).toEqual(['0', '0', null, '0', null, null, '0', '0', '0']);
  });
});

describe('the captains report (AP §9.17)', () => {
  it('gives each captain its deliveries, acceptance, earnings and time online', () => {
    const [ranking] = captainsReport({
      captains: [{ id: 'c1', name: 'كابتن' }],
      orders: [order(), order({ deliveredAt: at('2026-11-18T10:00:00Z') })],
      offers: new Map([['c1', { accepted: 3, answered: 4 }]]),
      faults: new Map([['c1', 1]]),
      earnings: new Map([['c1', 12_345n]]),
      onlineMinutes: new Map([['c1', 300]]),
      ratings: new Map(),
    });
    expect(ranking!.rows[0]!.cells).toEqual([
      '2',
      '7500',
      '4',
      '1',
      '5000',
      '12345',
      '300',
      null,
      '0',
    ]);
  });
});

describe('the captains report without the money (AP §6.2)', () => {
  it('leaves the earnings empty', () => {
    const [ranking] = captainsReport({
      captains: [{ id: 'c1', name: 'كابتن' }],
      orders: [],
      offers: new Map(),
      faults: new Map(),
      earnings: null,
      onlineMinutes: new Map(),
      ratings: new Map(),
    });
    expect(ranking!.rows[0]!.cells[5]).toBeNull();
  });
});

describe('the customers report (AP §9.17, CU U4)', () => {
  const orders = [
    order({ customerAccountId: 'a1', firstOrder: true }),
    order({ customerAccountId: 'a1' }),
    order({ customerAccountId: 'a2' }),
    order({ customerAccountId: 'a3', status: 'cancelled' }),
  ];
  const tables = customersReport({
    orders,
    profiles: new Map([
      ['a1', { firstName: 'سارة', lastName: 'أحمد', gender: 'female', birthday: '2000-05-01' }],
      ['a2', { firstName: 'علي', lastName: null, gender: 'male', birthday: null }],
    ]),
    phones: new Map([['a1', '+90 *** 123']]),
    blocks: { started: [{ label: 'إساءة', count: 2 }], inForce: 3 },
    lastDay: '2026-11-20',
    currency: 'TRY',
  });

  it('counts new and returning customers and the repeat rate', () => {
    // a1 new; a2 and a3 returning; a1 of the two with a delivery repeats.
    expect(tables[0]!.rows[0]!.cells).toEqual(['3', '1', '2', '5000', '3']);
  });

  it('lists the top customers with the number it was given', () => {
    expect(tables[1]!.rows.map((row) => [row.label, ...row.cells])).toEqual([
      ['سارة أحمد', '+90 *** 123', '2', '20000', 'new'],
      ['علي', null, '1', '10000', 'returning'],
    ]);
    expect(topCustomerIds(orders, 'TRY')).toEqual(['a1', 'a2']);
  });

  it('splits by gender and age band where the profile has them', () => {
    expect(tables[2]!.rows.map((row) => [row.code, row.cells[0]])).toEqual([
      ['male', '1'],
      ['female', '1'],
      ['unknown', '1'],
    ]);
    expect(tables[3]!.rows.find((row) => row.code === '25_34')!.cells[0]).toBe('1');
    expect(tables[3]!.rows.find((row) => row.code === 'unknown')!.cells[0]).toBe('2');
    expect(tables[4]!.rows).toEqual([{ code: null, label: 'إساءة', cells: ['2'] }]);
  });
});

describe('the codes report (AP §9.17)', () => {
  it('lists each code’s use, cost and new customers in the base only', () => {
    const [codes] = codesReport({
      codes: [
        {
          code: 'FOX10',
          currency: 'TRY',
          orders: 4,
          returned: 1,
          customers: 3,
          cost: 4_000n,
          merchantShare: 1_000n,
          newCustomers: 2,
        },
        {
          code: 'OLD',
          currency: 'USD',
          orders: 1,
          returned: 0,
          customers: 1,
          cost: 100n,
          merchantShare: 0n,
          newCustomers: 0,
        },
      ],
      currency: 'TRY',
    });
    expect(codes!.rows).toEqual([
      { code: null, label: 'FOX10', cells: ['4', '1', '3', '4000', '1000', '2'] },
    ]);
  });
});
