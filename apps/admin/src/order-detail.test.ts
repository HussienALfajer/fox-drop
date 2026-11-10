import { describe, expect, it, vi } from 'vitest';
import { eventKey, eventReason } from './order-detail.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §4.7: the timeline names the server's reason codes in Arabic and shows
// an operator's own reason as written; another code never shows in English.
describe('eventReason', () => {
  const system = { type: 'system' };
  it('names a coded reason by its event type', () => {
    expect(eventReason({ type: 'order.offer_closed', actor: system, reason: 'expired' })).toEqual({
      key: 'order.reason.expired',
    });
    expect(
      eventReason({
        type: 'order.pickup_rejected',
        actor: { type: 'restaurant' },
        reason: 'incomplete',
      }),
    ).toEqual({ key: 'order.reason.incomplete' });
  });

  it("shows an operator's reason as written and hides an unknown code", () => {
    expect(
      eventReason({ type: 'order.captain_arrived', actor: { type: 'admin' }, reason: 'GPS down' }),
    ).toEqual({ text: 'GPS down' });
    expect(
      eventReason({ type: 'order.offer_closed', actor: system, reason: 'new_code' }),
    ).toBeNull();
    expect(eventReason({ type: 'order.placed', actor: system, reason: null })).toBeNull();
  });
});

// AP §9.3.1 «item reported unavailable, and how the report was closed» and
// «ETA changes».
describe('eventKey', () => {
  it('names the item report and time change events', () => {
    expect(eventKey('order.time_changed')).toBe('order.event.timeChanged');
    expect(eventKey('order.item_reported')).toBe('order.event.itemReported');
    expect(eventKey('order.item_report_withdrawn')).toBe('order.event.itemReportWithdrawn');
    expect(eventKey('order.item_report_closed')).toBe('order.event.itemReportClosed');
    expect(eventKey('order.unknown')).toBeNull();
  });

  it("shows operations' reason for closing a report and changing the time", () => {
    const admin = { type: 'admin' };
    expect(
      eventReason({ type: 'order.item_report_closed', actor: admin, reason: 'وجد الصنف' }),
    ).toEqual({ text: 'وجد الصنف' });
    expect(eventReason({ type: 'order.time_changed', actor: admin, reason: null })).toBeNull();
  });
});
