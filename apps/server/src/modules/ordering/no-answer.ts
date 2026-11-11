import { and, asc, desc, eq, gte, inArray, isNull } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import {
  doorPings,
  type noAnswerCloseHows,
  noAnswerReports,
  orders,
  type pingAnswers,
} from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;

const MINUTE_MS = 60_000;

// CU §11.7: «أنا قادم», or «سأتصل بالمستلم» for an order with a recipient.
export type PingAnswer = (typeof pingAnswers)[number];

export interface DoorPing {
  at: Date;
  answer: PingAnswer | null;
  answeredAt: Date | null;
}

export interface NoAnswerReport {
  at: Date;
  waitedAt: Date | null;
  waitMessage: string | null;
}

// What the captain at the door has done since their arrival at the customer:
// their pings and their «الزبون لا يستجيب», oldest first.
export interface NoAnswerFacts {
  arrivedAt: Date;
  pings: DoorPing[];
  reports: NoAnswerReport[];
}

// customer.no_answer_pings and customer.no_answer_ping_interval_min.
export interface NoAnswerRule {
  pings: number;
  intervalMin: number;
}

export interface NoAnswerState {
  pingsLeft: number;
  // When «تنبيه الزبون» is allowed next (the screen shows it); null with none
  // left.
  nextPingAt: Date | null;
  // The customer's latest answer.
  answer: { answer: PingAnswer; at: Date } | null;
  // When «الزبون لا يستجيب» appears; null while pings are left or a report
  // waits for operations.
  reportableAt: Date | null;
  // The latest report, and operations' «انتظر» once given.
  report: NoAnswerReport | null;
}

// CA §9.9, docs/domain/03 (owner decisions 2026-11-11): up to the rule's
// pings, each at least the interval after the one before; «الزبون لا
// يستجيب» once every ping was sent and pings × interval passed since the
// arrival at the customer, or since operations' latest «انتظر». The
// customer's answer stops neither.
export function noAnswerState(facts: NoAnswerFacts, rule: NoAnswerRule): NoAnswerState {
  const pingsLeft = Math.max(0, rule.pings - facts.pings.length);
  const last = facts.pings.at(-1);
  const nextPingAt =
    pingsLeft === 0
      ? null
      : last === undefined
        ? facts.arrivedAt
        : new Date(last.at.getTime() + rule.intervalMin * MINUTE_MS);
  const answered = facts.pings.filter((ping) => ping.answer !== null && ping.answeredAt !== null);
  const latestAnswer = answered.reduce<DoorPing | null>(
    (latest, ping) => (latest === null || ping.answeredAt! > latest.answeredAt! ? ping : latest),
    null,
  );
  const report = facts.reports.at(-1) ?? null;
  const waiting = report !== null && report.waitedAt === null;
  const base = report?.waitedAt ?? facts.arrivedAt;
  return {
    pingsLeft,
    nextPingAt,
    answer: latestAnswer && { answer: latestAnswer.answer!, at: latestAnswer.answeredAt! },
    reportableAt:
      pingsLeft > 0 || waiting
        ? null
        : new Date(base.getTime() + rule.pings * rule.intervalMin * MINUTE_MS),
    report,
  };
}

export function canPing(state: NoAnswerState, now: Date): boolean {
  return state.nextPingAt !== null && now >= state.nextPingAt;
}

export function canReport(state: NoAnswerState, now: Date): boolean {
  return state.reportableAt !== null && now >= state.reportableAt;
}

// The captain's pings and reports on the order since they arrived at the
// customer, oldest first.
export async function noAnswerFacts(
  executor: Executor,
  order: { id: string; placedAt: Date },
  captainId: string,
  arrivedAt: Date,
): Promise<NoAnswerFacts> {
  const [pings, reports] = await Promise.all([
    executor
      .select({ at: doorPings.sentAt, answer: doorPings.answer, answeredAt: doorPings.answeredAt })
      .from(doorPings)
      .where(
        and(
          eq(doorPings.orderId, order.id),
          eq(doorPings.orderPlacedAt, order.placedAt),
          eq(doorPings.captainId, captainId),
          gte(doorPings.sentAt, arrivedAt),
        ),
      )
      .orderBy(asc(doorPings.sentAt), asc(doorPings.id)),
    executor
      .select({
        at: noAnswerReports.reportedAt,
        waitedAt: noAnswerReports.waitedAt,
        waitMessage: noAnswerReports.waitMessage,
      })
      .from(noAnswerReports)
      .where(
        and(
          eq(noAnswerReports.orderId, order.id),
          eq(noAnswerReports.orderPlacedAt, order.placedAt),
          eq(noAnswerReports.captainId, captainId),
          gte(noAnswerReports.reportedAt, arrivedAt),
        ),
      )
      .orderBy(asc(noAnswerReports.reportedAt), asc(noAnswerReports.id)),
  ]);
  return { arrivedAt, pings, reports };
}

// A report waiting for operations' «انتظر», as the alert and the detail
// read it.
export interface OpenNoAnswerReport {
  orderId: string;
  captainId: string;
  at: Date;
}

export async function openNoAnswerReports(
  executor: Executor,
  keys: { id: string; placedAt: Date }[],
): Promise<Map<string, OpenNoAnswerReport>> {
  if (keys.length === 0) return new Map();
  const rows = await executor
    .select({
      orderId: noAnswerReports.orderId,
      captainId: noAnswerReports.captainId,
      at: noAnswerReports.reportedAt,
    })
    .from(noAnswerReports)
    .where(
      and(
        inArray(
          noAnswerReports.orderId,
          keys.map((key) => key.id),
        ),
        inArray(
          noAnswerReports.orderPlacedAt,
          keys.map((key) => key.placedAt),
        ),
        isNull(noAnswerReports.waitedAt),
        isNull(noAnswerReports.closedAt),
      ),
    );
  return new Map(rows.map((row) => [row.orderId, row]));
}

export async function openNoAnswerReport(
  executor: Executor,
  key: { id: string; placedAt: Date },
): Promise<OpenNoAnswerReport | null> {
  return (await openNoAnswerReports(executor, [key])).get(key.id) ?? null;
}

// Operations' detail (AP §9.3.1): every ping and report of the order, oldest
// first, whichever captain sent them.
export async function noAnswerHistory(
  executor: Executor,
  key: { id: string; placedAt: Date },
): Promise<{
  pings: (DoorPing & { captainId: string })[];
  reports: (NoAnswerReport & {
    captainId: string;
    closedHow: (typeof noAnswerCloseHows)[number] | null;
  })[];
}> {
  const [pings, reports] = await Promise.all([
    executor
      .select({
        captainId: doorPings.captainId,
        at: doorPings.sentAt,
        answer: doorPings.answer,
        answeredAt: doorPings.answeredAt,
      })
      .from(doorPings)
      .where(and(eq(doorPings.orderId, key.id), eq(doorPings.orderPlacedAt, key.placedAt)))
      .orderBy(asc(doorPings.sentAt), asc(doorPings.id)),
    executor
      .select({
        captainId: noAnswerReports.captainId,
        at: noAnswerReports.reportedAt,
        waitedAt: noAnswerReports.waitedAt,
        waitMessage: noAnswerReports.waitMessage,
        closedHow: noAnswerReports.closedHow,
      })
      .from(noAnswerReports)
      .where(
        and(eq(noAnswerReports.orderId, key.id), eq(noAnswerReports.orderPlacedAt, key.placedAt)),
      )
      .orderBy(asc(noAnswerReports.reportedAt), asc(noAnswerReports.id)),
  ]);
  return { pings, reports };
}

// The order left the door with a report open (slice 2.13d): another captain
// received it, or it ended. In that transaction, so the next captain's door
// starts clean and the history tells it from operations' «انتظر».
export async function closeNoAnswer(
  tx: Pick<NodePgDatabase, 'update'>,
  key: { id: string; placedAt: Date },
  how: (typeof noAnswerCloseHows)[number],
  now: Date,
): Promise<void> {
  await tx
    .update(noAnswerReports)
    .set({ closedAt: now, closedHow: how })
    .where(
      and(
        eq(noAnswerReports.orderId, key.id),
        eq(noAnswerReports.orderPlacedAt, key.placedAt),
        isNull(noAnswerReports.waitedAt),
        isNull(noAnswerReports.closedAt),
      ),
    );
}

// When the order's captain arrived at the customer (null before).
export async function arrivedAtCustomer(
  executor: Executor,
  key: { id: string; placedAt: Date },
): Promise<Date | null> {
  const [row] = await executor
    .select({ at: orders.arrivedAtCustomerAt })
    .from(orders)
    .where(and(eq(orders.id, key.id), eq(orders.placedAt, key.placedAt)));
  return row?.at ?? null;
}

// CU §11.7: the latest ping of the order's captain at the door, whether the
// order is for someone else (its answer is then «سأتصل بالمستلم»), and the
// ping's id; null without a ping since the arrival.
export async function latestPing(
  executor: Executor,
  key: { id: string; placedAt: Date },
): Promise<{
  id: string;
  answer: PingAnswer | null;
  forRecipient: boolean;
} | null> {
  const [order] = await executor
    .select({
      captainId: orders.captainId,
      arrivedAt: orders.arrivedAtCustomerAt,
      recipientName: orders.recipientName,
    })
    .from(orders)
    .where(and(eq(orders.id, key.id), eq(orders.placedAt, key.placedAt)));
  if (!order?.captainId || !order.arrivedAt) return null;
  const [ping] = await executor
    .select({ id: doorPings.id, answer: doorPings.answer })
    .from(doorPings)
    .where(
      and(
        eq(doorPings.orderId, key.id),
        eq(doorPings.orderPlacedAt, key.placedAt),
        eq(doorPings.captainId, order.captainId),
        gte(doorPings.sentAt, order.arrivedAt),
      ),
    )
    .orderBy(desc(doorPings.sentAt), desc(doorPings.id))
    .limit(1);
  return ping ? { ...ping, forRecipient: order.recipientName !== null } : null;
}

// CU §11.7: the latest ping of each order's captain since their arrival at
// the customer, for the customer's order screen (the ring and its answer).
export async function latestPings(
  executor: Executor,
  rows: {
    id: string;
    placedAt: Date;
    captainId: string | null;
    arrivedAtCustomerAt: Date | null;
  }[],
): Promise<Map<string, DoorPing>> {
  const atDoor = rows.filter((row) => row.captainId !== null && row.arrivedAtCustomerAt !== null);
  if (atDoor.length === 0) return new Map();
  const pings = await executor
    .select({
      orderId: doorPings.orderId,
      captainId: doorPings.captainId,
      at: doorPings.sentAt,
      answer: doorPings.answer,
      answeredAt: doorPings.answeredAt,
    })
    .from(doorPings)
    .where(
      and(
        inArray(
          doorPings.orderId,
          atDoor.map((row) => row.id),
        ),
        inArray(
          doorPings.orderPlacedAt,
          atDoor.map((row) => row.placedAt),
        ),
      ),
    )
    .orderBy(asc(doorPings.sentAt), asc(doorPings.id));
  const latest = new Map<string, DoorPing>();
  for (const row of atDoor) {
    for (const ping of pings) {
      if (
        ping.orderId === row.id &&
        ping.captainId === row.captainId &&
        ping.at >= row.arrivedAtCustomerAt!
      ) {
        latest.set(row.id, { at: ping.at, answer: ping.answer, answeredAt: ping.answeredAt });
      }
    }
  }
  return latest;
}
