import { describe, expect, it } from 'vitest';
import { type OrderAlertInput, orderAlerts } from './order-alerts.js';

// AP §9.1.3: each order alert from its condition, and the next moment one
// may open (the timer the sync sends).
const now = new Date('2026-11-08T10:00:00Z');
const at = (minutes: number) => new Date(now.getTime() + minutes * 60_000);

const placed: OrderAlertInput = {
  status: 'placed',
  captainId: null,
  captainTrack: null,
  acceptAlertAt: at(3),
  prepLateAlertAt: null,
  searchAlertAt: null,
  noCaptainAlertAt: null,
  captainWaitingAlertAt: null,
  deliveryLateAt: null,
  assignedAt: null,
  lastFixAt: null,
  gpsStaleMin: 2,
  amountDisputed: false,
  away: false,
  shortfall: false,
};

describe('orderAlerts (AP §9.1.3)', () => {
  it('raises «مطعم لم يقبل» once the acceptance alert passed, and times it before', () => {
    expect(orderAlerts(placed, now)).toEqual({ open: [], next: at(3) });
    expect(orderAlerts(placed, at(3))).toEqual({ open: ['restaurant_not_accepted'], next: null });
  });

  it('drops «مطعم لم يقبل» once the order is no longer placed', () => {
    const accepted = { ...placed, status: 'accepted' as const, prepLateAlertAt: at(30) };
    expect(orderAlerts(accepted, at(5))).toEqual({ open: [], next: at(30) });
  });

  it('raises the no-captain alerts only while no captain is assigned', () => {
    const ready = {
      ...placed,
      status: 'ready' as const,
      searchAlertAt: at(-1),
      noCaptainAlertAt: at(-1),
    };
    expect(orderAlerts(ready, now).open).toEqual(['no_captain', 'no_captain_after_ready']);
    const assigned = {
      ...ready,
      captainId: 'c',
      captainTrack: 'assigned' as const,
      assignedAt: now,
    };
    expect(orderAlerts(assigned, now).open).toEqual([]);
  });

  it('raises «تحضير متأخر» while accepted and «كابتن ينتظر عند المطعم» before the pickup', () => {
    const accepted = {
      ...placed,
      status: 'accepted' as const,
      prepLateAlertAt: at(-1),
      captainId: 'c',
      captainTrack: 'at_merchant' as const,
      assignedAt: now,
      lastFixAt: now,
      captainWaitingAlertAt: at(-1),
    };
    expect(orderAlerts(accepted, now).open).toEqual(['prep_late', 'captain_waiting']);
    const pickedUp = {
      ...accepted,
      status: 'picked_up' as const,
      captainTrack: 'picked_up' as const,
    };
    expect(orderAlerts(pickedUp, now).open).toEqual([]);
  });

  it('raises «انقطع اتصال كابتن أثناء طلب» after the stale minutes, never as a timer', () => {
    const onTheWay = {
      ...placed,
      status: 'picked_up' as const,
      captainId: 'c',
      captainTrack: 'picked_up' as const,
      assignedAt: at(-30),
      lastFixAt: at(-1),
    };
    expect(orderAlerts(onTheWay, now)).toEqual({ open: [], next: null });
    expect(orderAlerts({ ...onTheWay, lastFixAt: at(-2) }, now).open).toEqual(['captain_gps_lost']);
    // No point since the assignment counts from the assignment.
    expect(orderAlerts({ ...onTheWay, lastFixAt: null, assignedAt: at(-1) }, now).open).toEqual([]);
    expect(orderAlerts({ ...onTheWay, lastFixAt: null }, now).open).toEqual(['captain_gps_lost']);
    // Not once the order ended.
    const delivered = { ...onTheWay, status: 'delivered' as const, captainTrack: 'done' as const };
    expect(orderAlerts({ ...delivered, lastFixAt: null }, now).open).toEqual([]);
  });

  it('raises «توصيل متأخر» past the promised time until the order ends', () => {
    const late = {
      ...placed,
      status: 'arrived' as const,
      captainId: 'c',
      captainTrack: 'at_customer' as const,
      assignedAt: now,
      lastFixAt: now,
      deliveryLateAt: at(-1),
    };
    expect(orderAlerts(late, now).open).toEqual(['delivery_late']);
    expect(orderAlerts({ ...late, status: 'delivered' }, now).open).toEqual([]);
  });

  it('keeps «خلاف على مبلغ الاستلام» until the pickup, and the shortfall and away alerts', () => {
    const disputed = { ...placed, status: 'ready' as const, amountDisputed: true };
    expect(orderAlerts(disputed, now).open).toEqual(['pickup_disputed']);
    expect(orderAlerts({ ...disputed, status: 'picked_up' }, now).open).toEqual([]);
    const delivered = { ...placed, status: 'delivered' as const, shortfall: true, away: true };
    expect(orderAlerts(delivered, now).open).toEqual(['collection_shortfall', 'away_from_address']);
  });

  it('times the soonest moment still ahead', () => {
    const accepted = {
      ...placed,
      status: 'accepted' as const,
      prepLateAlertAt: at(25),
      searchAlertAt: at(12),
      deliveryLateAt: at(60),
    };
    expect(orderAlerts(accepted, now).next).toEqual(at(12));
  });
});
