import { lastCutoff } from '../geo/index.js';
import type { ReportOrder } from '../ordering/index.js';

// AP §9.17 (slice 2.41, owner decision 2026-11-20: every chart a table): a
// report is a list of tables the panel draws and the Excel export writes
// alike. A column's kind says how its cells read: whole counts, basis points
// (a share, 10000 is 100%), minutes to one decimal, amounts in the report's
// currency's minor units, an average of stars to one decimal, a code the
// panel names, or text as it is.
export const reportColumnKinds = [
  'count',
  'bp',
  'minutes',
  'money',
  'stars',
  'code',
  'text',
] as const;
export type ReportColumnKind = (typeof reportColumnKinds)[number];

// What names a row: nothing (a one-row summary), a code the panel names, its
// label as the data has it (`label`, not `name`, which the Dart client's
// enums cannot hold), a business day (YYYY-MM-DD) or an hour of the
// city's clock (0 to 23).
export const reportRowKinds = ['none', 'code', 'label', 'day', 'hour'] as const;
export type ReportRowKind = (typeof reportRowKinds)[number];

export interface ReportColumn {
  key: string;
  kind: ReportColumnKind;
}

export interface ReportRow {
  // The row's code, day or hour; null for `none` and `label`.
  code: string | null;
  // The row's name, for `label`, or a label as chosen beside a code (a
  // cancellation reason's); null otherwise.
  label: string | null;
  // One per column, as text; null where the value does not exist (an
  // average with nothing to average).
  cells: (string | null)[];
  // The currency of the row's `money` cells when it is not the report's
  // (the finance report's cash per currency).
  currency?: string;
}

export interface ReportTable {
  key: string;
  rowKind: ReportRowKind;
  columns: ReportColumn[];
  rows: ReportRow[];
}

// The list a table's row codes are named from (`reportLabels.code`), keyed
// `<report>.<table>`; a table not listed shows its codes as they are (a day,
// an hour, a currency).
export const ROW_CODES: Readonly<Record<string, string>> = {
  'orders.cancellations': 'cancelReason',
  'orders.outcomes': 'outcome',
  'timings.averages': 'timing',
  'customers.by_gender': 'gender',
  'customers.by_age': 'age',
  'finance.summary': 'finance',
};

export interface ReportClock {
  timeZone: string;
  cutoffMinutes: number;
}

// A share in basis points, null with nothing to share.
export function basisPoints(part: number, whole: number): number | null {
  return whole === 0 ? null : Math.round((part * 10_000) / whole);
}

const MINUTE_MS = 60_000;

// The average of some minutes, to one decimal, as text; null with none.
export function averageMinutes(values: readonly number[]): string | null {
  if (values.length === 0) return null;
  const total = values.reduce((sum, value) => sum + value, 0);
  return (Math.round((total / values.length) * 10) / 10).toFixed(1);
}

const minutesBetween = (from: Date | null, to: Date | null): number | null =>
  from === null || to === null ? null : (to.getTime() - from.getTime()) / MINUTE_MS;

const cell = (value: number | bigint | null): string | null =>
  value === null ? null : value.toString();

// The business day of a moment, YYYY-MM-DD on the city's clock.
export function businessDay(at: Date, clock: ReportClock): string {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone: clock.timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(lastCutoff(at, clock.cutoffMinutes, clock.timeZone));
}

// The hour of the city's clock a moment falls in, 0 to 23.
export function cityHour(at: Date, clock: ReportClock): number {
  return Number(
    new Intl.DateTimeFormat('en-US', {
      timeZone: clock.timeZone,
      hour: '2-digit',
      hourCycle: 'h23',
    }).format(at),
  );
}

// Hours in the order of the business day: from the cutoff's hour on.
function hourOrder(clock: ReportClock): number[] {
  const first = Math.floor(clock.cutoffMinutes / 60);
  return Array.from({ length: 24 }, (_, index) => (first + index) % 24);
}

const ENDED_AFTER_PICKUP = new Set(['delivered', 'failed']);
const ACTIVE = new Set(['placed', 'accepted', 'ready', 'picked_up', 'arrived']);

// The outcome columns every orders table shares (AP §9.17 «Orders»): placed,
// delivered, cancelled, rejected, failed, still active, and the success
// rate, delivered ÷ placed (as the dashboard, slice 2.40).
const outcomeColumns: ReportColumn[] = [
  { key: 'placed', kind: 'count' },
  { key: 'delivered', kind: 'count' },
  { key: 'cancelled', kind: 'count' },
  { key: 'rejected', kind: 'count' },
  { key: 'failed', kind: 'count' },
  { key: 'active', kind: 'count' },
  { key: 'success', kind: 'bp' },
];

function outcomeCells(rows: readonly ReportOrder[]): string[] {
  const count = (status: string) => rows.filter((row) => row.status === status).length;
  const delivered = count('delivered');
  return [
    rows.length,
    delivered,
    count('cancelled'),
    count('rejected'),
    count('failed'),
    rows.filter((row) => ACTIVE.has(row.status)).length,
    basisPoints(delivered, rows.length),
  ].map((value) => (value === null ? '' : String(value)));
}

const outcomeRow = (rows: readonly ReportOrder[]) =>
  outcomeCells(rows).map((value) => (value === '' ? null : value));

function groupBy<T>(rows: readonly T[], key: (row: T) => string): Map<string, T[]> {
  const groups = new Map<string, T[]>();
  for (const row of rows) {
    const id = key(row);
    const group = groups.get(id);
    if (group) group.push(row);
    else groups.set(id, [row]);
  }
  return groups;
}

// Most first, then by name.
const byCountThenName = (a: ReportRow, b: ReportRow) =>
  Number(b.cells[0] ?? 0) - Number(a.cells[0] ?? 0) ||
  (a.label ?? a.code ?? '').localeCompare(b.label ?? b.code ?? '', 'ar');

export interface OrdersReportInput {
  orders: readonly ReportOrder[];
  clock: ReportClock;
  // Every business day of the period, in order, so a day without an order
  // shows a row of zeros.
  days: readonly string[];
  zoneNames: ReadonlyMap<string, string>;
  restaurantNames: ReadonlyMap<string, string>;
  // The customer's cancellation reasons by code (Content's
  // `customer_cancel`); operations' carry their label on the order.
  cancelLabels: ReadonlyMap<string, string>;
}

// AP §9.17 «Orders»: by day, hour, zone and restaurant; the success rate;
// the cancellations by reason and party; the rejections by reason and party;
// the outcomes.
export function ordersReport(input: OrdersReportInput): ReportTable[] {
  const { orders, clock } = input;
  const byDay = groupBy(orders, (row) => businessDay(row.placedAt, clock));
  const byHour = groupBy(orders, (row) => String(cityHour(row.placedAt, clock)));
  const byZone = groupBy(orders, (row) => row.zoneId);
  const byRestaurant = groupBy(orders, (row) => row.restaurantId);
  const cancelled = orders.filter((row) => row.status === 'cancelled');
  const rejected = orders.filter((row) => row.status === 'rejected');
  const outcomes = orders.filter((row) => ENDED_AFTER_PICKUP.has(row.status));
  const named = (groups: Map<string, ReportOrder[]>, names: ReadonlyMap<string, string>) =>
    [...groups].map(([id, rows]): ReportRow => ({
      code: null,
      label: names.get(id) ?? '—',
      cells: outcomeRow(rows),
    }));
  return [
    {
      key: 'summary',
      rowKind: 'none',
      columns: outcomeColumns,
      rows: [{ code: null, label: null, cells: outcomeRow(orders) }],
    },
    {
      key: 'by_day',
      rowKind: 'day',
      columns: outcomeColumns,
      rows: input.days.map((day) => ({
        code: day,
        label: null,
        cells: outcomeRow(byDay.get(day) ?? []),
      })),
    },
    {
      key: 'by_hour',
      rowKind: 'hour',
      columns: outcomeColumns,
      rows: hourOrder(clock).map((hour) => ({
        code: String(hour),
        label: null,
        cells: outcomeRow(byHour.get(String(hour)) ?? []),
      })),
    },
    {
      key: 'by_zone',
      rowKind: 'label',
      columns: outcomeColumns,
      rows: named(byZone, input.zoneNames).sort(byCountThenName),
    },
    {
      key: 'by_restaurant',
      rowKind: 'label',
      columns: outcomeColumns,
      rows: named(byRestaurant, input.restaurantNames).sort(byCountThenName),
    },
    {
      // Who cancelled (the event's actor: the customer, operations, the
      // system's timer) and the party operations named responsible.
      key: 'cancellations',
      rowKind: 'code',
      columns: [
        { key: 'orders', kind: 'count' },
        { key: 'by', kind: 'code' },
        { key: 'responsible', kind: 'code' },
      ],
      rows: [
        ...groupBy(
          cancelled,
          (row) =>
            `${row.cancelReason ?? ''}|${row.cancelReasonLabel ?? ''}|${row.cancelledBy ?? ''}|${row.cancelResponsible ?? ''}`,
        ).values(),
      ]
        .map((rows) => {
          const first = rows[0]!;
          return {
            code: first.cancelReason,
            label:
              first.cancelReasonLabel ??
              (first.cancelReason === null
                ? null
                : (input.cancelLabels.get(first.cancelReason) ?? null)),
            cells: [String(rows.length), first.cancelledBy, first.cancelResponsible],
          };
        })
        .sort(byCountThenName),
    },
    {
      // By the reason's label as chosen, and whether the restaurant or
      // operations on its behalf rejected it.
      key: 'rejections',
      rowKind: 'label',
      columns: [
        { key: 'orders', kind: 'count' },
        { key: 'by', kind: 'code' },
      ],
      rows: [
        ...groupBy(
          rejected,
          (row) => `${row.rejectReasonLabel ?? row.rejectReason ?? ''}|${row.rejectedBy ?? ''}`,
        ).values(),
      ]
        .map((rows) => {
          const first = rows[0]!;
          return {
            code: null,
            label: first.rejectReasonLabel ?? first.rejectReason,
            cells: [String(rows.length), first.rejectedBy],
          };
        })
        .sort(byCountThenName),
    },
    {
      // The outcome in force of the orders that ended after the pickup.
      key: 'outcomes',
      rowKind: 'code',
      columns: [{ key: 'orders', kind: 'count' }],
      rows: [...groupBy(outcomes, (row) => row.outcome ?? 'normal')]
        .map(([outcome, rows]) => ({ code: outcome, label: null, cells: [String(rows.length)] }))
        .sort(byCountThenName),
    },
  ];
}

// AP §9.17 «Timings», each from the order's own moments: the restaurant's
// acceptance (placed to accepted, by the restaurant only); the actual
// preparation (accepted to ready, or to the pickup when ready was not
// pressed) against the time chosen; finding a captain (the search's start to
// the assignment); the captain's wait at the restaurant (arrival to pickup);
// the delivery leg (pickup to delivery); the total (placed to delivered);
// and the late rate (delivered after the promised time ÷ delivered).
export interface Timings {
  acceptance: number[];
  prepActual: number[];
  prepChosen: number[];
  findCaptain: number[];
  captainWait: number[];
  deliveryLeg: number[];
  total: number[];
  // Delivered, and of them late.
  delivered: number;
  late: number;
  // Ready (or picked up when not pressed) after the prep time chosen, of
  // the orders that reached it (RA §11 «Late rate»).
  prepared: number;
  prepLate: number;
  readyNotPressed: number;
}

export function timingsOf(orders: readonly ReportOrder[]): Timings {
  const timings: Timings = {
    acceptance: [],
    prepActual: [],
    prepChosen: [],
    findCaptain: [],
    captainWait: [],
    deliveryLeg: [],
    total: [],
    delivered: 0,
    late: 0,
    prepared: 0,
    prepLate: 0,
    readyNotPressed: 0,
  };
  const push = (list: number[], value: number | null) => {
    if (value !== null && value >= 0) list.push(value);
  };
  for (const order of orders) {
    if (order.acceptedBy === 'restaurant') {
      push(timings.acceptance, minutesBetween(order.placedAt, order.acceptedAt));
    }
    if (order.acceptedAt !== null && order.readyAt !== null && order.prepMin !== null) {
      const actual = minutesBetween(order.acceptedAt, order.readyAt)!;
      push(timings.prepActual, actual);
      timings.prepChosen.push(order.prepMin);
      timings.prepared += 1;
      if (actual > order.prepMin) timings.prepLate += 1;
      if (order.readyByPickup) timings.readyNotPressed += 1;
    }
    push(timings.findCaptain, minutesBetween(order.searchStartedAt, order.assignedAt));
    push(timings.captainWait, minutesBetween(order.arrivedAtMerchantAt, order.pickedUpAt));
    if (order.status === 'delivered') {
      push(timings.deliveryLeg, minutesBetween(order.pickedUpAt, order.deliveredAt));
      push(timings.total, minutesBetween(order.placedAt, order.deliveredAt));
      timings.delivered += 1;
      if (
        order.promisedAt !== null &&
        order.deliveredAt !== null &&
        order.deliveredAt > order.promisedAt
      ) {
        timings.late += 1;
      }
    }
  }
  return timings;
}

export function timingsReport(orders: readonly ReportOrder[]): ReportTable[] {
  const timings = timingsOf(orders);
  const row = (code: keyof Timings & string, values: number[]): ReportRow => ({
    code,
    label: null,
    cells: [averageMinutes(values), String(values.length)],
  });
  return [
    {
      key: 'averages',
      rowKind: 'code',
      columns: [
        { key: 'average', kind: 'minutes' },
        { key: 'orders', kind: 'count' },
      ],
      rows: [
        row('acceptance', timings.acceptance),
        row('prepActual', timings.prepActual),
        row('prepChosen', timings.prepChosen),
        row('findCaptain', timings.findCaptain),
        row('captainWait', timings.captainWait),
        row('deliveryLeg', timings.deliveryLeg),
        row('total', timings.total),
      ],
    },
    {
      key: 'late',
      rowKind: 'none',
      columns: [
        { key: 'delivered', kind: 'count' },
        { key: 'late', kind: 'count' },
        { key: 'late_rate', kind: 'bp' },
        { key: 'prep_late_rate', kind: 'bp' },
      ],
      rows: [
        {
          code: null,
          label: null,
          cells: [
            String(timings.delivered),
            String(timings.late),
            cell(basisPoints(timings.late, timings.delivered)),
            cell(basisPoints(timings.prepLate, timings.prepared)),
          ],
        },
      ],
    },
  ];
}

// What the restaurants report reads beside the orders.
export interface RestaurantsReportInput {
  orders: readonly ReportOrder[];
  // The city's restaurants that had an order or a pause in the period, and
  // every active one, by name.
  restaurants: readonly { id: string; name: string }[];
  ratings: ReadonlyMap<string, { count: number; total: number }>;
  // Minutes paused in the period, by source.
  pauses: ReadonlyMap<string, number>;
  currency: string;
}

// A restaurant's answers: accepted (by it or on its behalf) against those
// accepted, rejected or never answered (as the list's acceptance, slice
// 2.30c); unanswered is the automatic cancellation.
export function restaurantAnswers(orders: readonly ReportOrder[]) {
  const accepted = orders.filter((row) => row.acceptedAt !== null).length;
  const rejected = orders.filter((row) => row.status === 'rejected').length;
  const unanswered = orders.filter((row) => row.cancelReason === 'merchant_auto_cancel').length;
  return { accepted, rejected, unanswered, answered: accepted + rejected + unanswered };
}

// The items value of the delivered orders in the report's currency.
export function salesOf(orders: readonly ReportOrder[], currency: string): bigint {
  return orders
    .filter((row) => row.status === 'delivered' && row.currency === currency)
    .reduce((total, row) => total + row.itemsValue, 0n);
}

const stars = (rating: { count: number; total: number } | undefined) =>
  rating === undefined || rating.count === 0 ? null : (rating.total / rating.count).toFixed(1);

// AP §9.17 «Restaurants»: a ranking by orders, sales, acceptance,
// rejections, late rate, rating, unanswered orders and pause minutes; the
// panel sorts by any column, the most orders first.
export function restaurantsReport(input: RestaurantsReportInput): ReportTable[] {
  const byRestaurant = groupBy(input.orders, (row) => row.restaurantId);
  return [
    {
      key: 'ranking',
      rowKind: 'label',
      columns: [
        { key: 'orders', kind: 'count' },
        { key: 'sales', kind: 'money' },
        { key: 'acceptance', kind: 'bp' },
        { key: 'rejections', kind: 'count' },
        { key: 'late_rate', kind: 'bp' },
        { key: 'rating', kind: 'stars' },
        { key: 'ratings', kind: 'count' },
        { key: 'unanswered', kind: 'count' },
        { key: 'pause_minutes', kind: 'count' },
      ],
      rows: input.restaurants
        .map((restaurant) => {
          const orders = byRestaurant.get(restaurant.id) ?? [];
          const answers = restaurantAnswers(orders);
          const timings = timingsOf(orders);
          const rating = input.ratings.get(restaurant.id);
          return {
            code: null,
            label: restaurant.name,
            cells: [
              String(orders.length),
              salesOf(orders, input.currency).toString(),
              cell(basisPoints(answers.accepted, answers.answered)),
              String(answers.rejected),
              cell(basisPoints(timings.prepLate, timings.prepared)),
              stars(rating),
              String(rating?.count ?? 0),
              String(answers.unanswered),
              String(input.pauses.get(restaurant.id) ?? 0),
            ],
          };
        })
        .sort(byCountThenName),
    },
  ];
}

export interface CaptainsReportInput {
  captains: readonly { id: string; name: string }[];
  // Delivered by the captain who delivered it (the order's captain).
  orders: readonly ReportOrder[];
  offers: ReadonlyMap<string, { accepted: number; answered: number }>;
  faults: ReadonlyMap<string, number>;
  earnings: ReadonlyMap<string, bigint>;
  onlineMinutes: ReadonlyMap<string, number>;
  ratings: ReadonlyMap<string, { count: number; total: number }>;
}

// AP §9.17 «Captains»: orders delivered, acceptance of the offers answered,
// cancellations by fault, the on-time rate (delivered at or before the
// promised time ÷ delivered), the earnings booked in the period, the hours
// online and the rating. Every captain of the city not terminated, and any
// other with an order, earnings or time online in the period.
export function captainsReport(input: CaptainsReportInput): ReportTable[] {
  const delivered = groupBy(
    input.orders.filter((row) => row.status === 'delivered' && row.captainId !== null),
    (row) => row.captainId!,
  );
  return [
    {
      key: 'ranking',
      rowKind: 'label',
      columns: [
        { key: 'delivered', kind: 'count' },
        { key: 'acceptance', kind: 'bp' },
        { key: 'offers', kind: 'count' },
        { key: 'cancellations', kind: 'count' },
        { key: 'on_time', kind: 'bp' },
        { key: 'earnings', kind: 'money' },
        { key: 'online_minutes', kind: 'count' },
        { key: 'rating', kind: 'stars' },
        { key: 'ratings', kind: 'count' },
      ],
      rows: input.captains
        .map((captain) => {
          const orders = delivered.get(captain.id) ?? [];
          const onTime = orders.filter(
            (row) =>
              row.promisedAt !== null &&
              row.deliveredAt !== null &&
              row.deliveredAt <= row.promisedAt,
          ).length;
          const offers = input.offers.get(captain.id);
          const rating = input.ratings.get(captain.id);
          return {
            code: null,
            label: captain.name,
            cells: [
              String(orders.length),
              cell(offers === undefined ? null : basisPoints(offers.accepted, offers.answered)),
              String(offers?.answered ?? 0),
              String(input.faults.get(captain.id) ?? 0),
              cell(basisPoints(onTime, orders.length)),
              (input.earnings.get(captain.id) ?? 0n).toString(),
              String(input.onlineMinutes.get(captain.id) ?? 0),
              stars(rating),
              String(rating?.count ?? 0),
            ],
          };
        })
        .sort(byCountThenName),
    },
  ];
}

export const AGE_BANDS = ['under_18', '18_24', '25_34', '35_44', '45_plus', 'unknown'] as const;

// The age on a day (YYYY-MM-DD) of a birthday, in its band.
export function ageBand(birthday: string | null, on: string): (typeof AGE_BANDS)[number] {
  if (birthday === null) return 'unknown';
  const [by, bm, bd] = birthday.split('-').map(Number) as [number, number, number];
  const [y, m, d] = on.split('-').map(Number) as [number, number, number];
  const age = y - by - (m < bm || (m === bm && d < bd) ? 1 : 0);
  if (age < 18) return 'under_18';
  if (age < 25) return '18_24';
  if (age < 35) return '25_34';
  if (age < 45) return '35_44';
  return '45_plus';
}

export const TOP_CUSTOMERS = 20;

// The top customers: the most delivered orders in the period, then the
// highest items value of them in the report's currency, then the account.
export function topCustomerIds(orders: readonly ReportOrder[], currency: string): string[] {
  const counts = new Map<string, { delivered: number; value: bigint }>();
  for (const row of orders) {
    if (row.status !== 'delivered') continue;
    const count = counts.get(row.customerAccountId) ?? { delivered: 0, value: 0n };
    count.delivered += 1;
    if (row.currency === currency) count.value += row.itemsValue;
    counts.set(row.customerAccountId, count);
  }
  return [...counts]
    .sort(
      ([idA, a], [idB, b]) =>
        b.delivered - a.delivered ||
        (b.value > a.value ? 1 : b.value < a.value ? -1 : idA.localeCompare(idB)),
    )
    .slice(0, TOP_CUSTOMERS)
    .map(([id]) => id);
}

export interface CustomersReportInput {
  orders: readonly ReportOrder[];
  // Each ordering customer's profile; a customer without one is unknown.
  profiles: ReadonlyMap<
    string,
    { firstName: string; lastName: string | null; gender: string; birthday: string | null }
  >;
  // The number shown for each top customer: masked, or in full for an
  // export with `exports.phone_numbers`.
  phones: ReadonlyMap<string, string>;
  blocks: { started: { label: string; count: number }[]; inForce: number };
  // The period's last day, the ages' day.
  lastDay: string;
  currency: string;
}

// AP §9.17 «Customers», CU U4: the customers who placed an order in the
// period, new (their first order ever is in it) or returning; the repeat
// rate (those with two delivered orders or more ÷ those with one or more);
// the top customers by delivered orders; the blocks of the panel; and the
// split by gender and age band where the profile has them.
export function customersReport(input: CustomersReportInput): ReportTable[] {
  const byCustomer = groupBy(input.orders, (row) => row.customerAccountId);
  const customers = [...byCustomer];
  const isNew = new Set(
    customers
      .filter(([, rows]) => rows.some((row) => row.firstOrder))
      .map(([accountId]) => accountId),
  );
  const deliveredOf = (rows: readonly ReportOrder[]) =>
    rows.filter((row) => row.status === 'delivered');
  const withDelivery = customers.filter(([, rows]) => deliveredOf(rows).length > 0);
  const repeat = withDelivery.filter(([, rows]) => deliveredOf(rows).length > 1);
  const split = (key: (accountId: string) => string, codes: readonly string[]): ReportRow[] =>
    codes.map((code) => {
      const ids = customers.map(([id]) => id).filter((id) => key(id) === code);
      return {
        code,
        label: null,
        cells: [
          String(ids.length),
          String(ids.filter((id) => isNew.has(id)).length),
          String(ids.filter((id) => !isNew.has(id)).length),
        ],
      };
    });
  const splitColumns: ReportColumn[] = [
    { key: 'customers', kind: 'count' },
    { key: 'new', kind: 'count' },
    { key: 'returning', kind: 'count' },
  ];
  return [
    {
      key: 'summary',
      rowKind: 'none',
      columns: [
        { key: 'customers', kind: 'count' },
        { key: 'new', kind: 'count' },
        { key: 'returning', kind: 'count' },
        { key: 'repeat_rate', kind: 'bp' },
        { key: 'blocked_now', kind: 'count' },
      ],
      rows: [
        {
          code: null,
          label: null,
          cells: [
            String(customers.length),
            String(isNew.size),
            String(customers.length - isNew.size),
            cell(basisPoints(repeat.length, withDelivery.length)),
            String(input.blocks.inForce),
          ],
        },
      ],
    },
    {
      key: 'top',
      rowKind: 'label',
      columns: [
        { key: 'phone', kind: 'text' },
        { key: 'delivered', kind: 'count' },
        { key: 'items_value', kind: 'money' },
        { key: 'status', kind: 'code' },
      ],
      rows: topCustomerIds(input.orders, input.currency).map((accountId) => {
        const done = deliveredOf(byCustomer.get(accountId)!);
        const profile = input.profiles.get(accountId);
        return {
          code: null,
          label: profile ? [profile.firstName, profile.lastName].filter(Boolean).join(' ') : '—',
          cells: [
            input.phones.get(accountId) ?? null,
            String(done.length),
            salesOf(done, input.currency).toString(),
            isNew.has(accountId) ? 'new' : 'returning',
          ],
        };
      }),
    },
    {
      key: 'by_gender',
      rowKind: 'code',
      columns: splitColumns,
      rows: split(
        (id) => input.profiles.get(id)?.gender ?? 'unknown',
        ['male', 'female', 'unknown'],
      ),
    },
    {
      key: 'by_age',
      rowKind: 'code',
      columns: splitColumns,
      rows: split(
        (id) => ageBand(input.profiles.get(id)?.birthday ?? null, input.lastDay),
        AGE_BANDS,
      ),
    },
    {
      key: 'blocks',
      rowKind: 'label',
      columns: [{ key: 'started', kind: 'count' }],
      rows: input.blocks.started.map((row) => ({
        code: null,
        label: row.label,
        cells: [String(row.count)],
      })),
    },
  ];
}

export interface LostDemandReportInput {
  votes: number;
  searches: readonly { query: string; count: number; lastAt: Date }[];
  suggestions: readonly { restaurantName: string; note: string | null; query: string | null }[];
  emergency: { stops: number; attempts: number };
}

// AP §9.17 «Lost demand»: the votes from outside the zones, the searches
// with no result, the suggested restaurants and the customers who opened
// checkout during an emergency stop. The orders the capacity check refused
// are not recorded yet (ordering's «Not yet»).
export function lostDemandReport(input: LostDemandReportInput): ReportTable[] {
  return [
    {
      key: 'summary',
      rowKind: 'none',
      columns: [
        { key: 'votes', kind: 'count' },
        { key: 'searches', kind: 'count' },
        { key: 'suggestions', kind: 'count' },
        { key: 'emergency_stops', kind: 'count' },
        { key: 'emergency_attempts', kind: 'count' },
      ],
      rows: [
        {
          code: null,
          label: null,
          cells: [
            String(input.votes),
            String(input.searches.reduce((total, row) => total + row.count, 0)),
            String(input.suggestions.length),
            String(input.emergency.stops),
            String(input.emergency.attempts),
          ],
        },
      ],
    },
    {
      key: 'searches',
      rowKind: 'label',
      columns: [{ key: 'count', kind: 'count' }],
      rows: input.searches.map((row) => ({
        code: null,
        label: row.query,
        cells: [String(row.count)],
      })),
    },
    {
      key: 'suggestions',
      rowKind: 'label',
      columns: [
        { key: 'note', kind: 'text' },
        { key: 'query', kind: 'text' },
      ],
      rows: input.suggestions.map((row) => ({
        code: null,
        label: row.restaurantName,
        cells: [row.note, row.query],
      })),
    },
  ];
}

export interface CodesReportInput {
  codes: readonly {
    code: string;
    currency: string;
    orders: number;
    returned: number;
    customers: number;
    cost: bigint;
    merchantShare: bigint;
    newCustomers: number;
  }[];
  currency: string;
}

// AP §9.17 «Codes»: each code's use (uses not given back, given back,
// customers), cost (the discounts, the restaurants' share apart) and the new
// customers it brought, of the uses held in the period, in the report's
// currency (a use in an earlier base is left out).
export function codesReport(input: CodesReportInput): ReportTable[] {
  return [
    {
      key: 'codes',
      rowKind: 'label',
      columns: [
        { key: 'uses', kind: 'count' },
        { key: 'returned', kind: 'count' },
        { key: 'customers', kind: 'count' },
        { key: 'cost', kind: 'money' },
        { key: 'merchant_share', kind: 'money' },
        { key: 'new_customers', kind: 'count' },
      ],
      rows: input.codes
        .filter((row) => row.currency === input.currency)
        .map((row) => ({
          code: null,
          label: row.code,
          cells: [
            String(row.orders),
            String(row.returned),
            String(row.customers),
            row.cost.toString(),
            row.merchantShare.toString(),
            String(row.newCustomers),
          ],
        })),
    },
  ];
}
