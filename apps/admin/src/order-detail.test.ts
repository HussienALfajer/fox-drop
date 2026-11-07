import { describe, expect, it, vi } from 'vitest';
import { eventReason } from './order-detail.js';

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
