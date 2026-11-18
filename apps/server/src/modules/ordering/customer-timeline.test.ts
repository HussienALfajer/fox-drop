import { describe, expect, it } from 'vitest';
import { timeline } from './customer-timeline.js';

// CU §12.3 (slice 2.28b): the order detail's short timeline, the steps the
// order reached from its own moments, oldest first.
const at = (minute: number) => new Date(Date.UTC(2026, 10, 18, 12, minute));
const base = {
  placedAt: at(0),
  acceptance: null,
  pickup: null,
  customerArrival: null,
  delivery: null,
  outcome: null,
  rejection: null,
  cancellation: null,
};
type Order = Parameters<typeof timeline>[0];
const steps = (order: Partial<Order>) =>
  timeline({ ...base, status: 'placed', ...order } as Order).map(
    (step) => `${step.step}@${step.at.slice(11, 16)}`,
  );

describe('the customer timeline (CU §12.3)', () => {
  it('lists the steps of a normal delivery', () => {
    expect(
      steps({
        status: 'delivered',
        acceptance: { at: at(2) } as Order['acceptance'],
        pickup: { at: at(20), readyByPickup: false },
        customerArrival: { at: at(35) },
        delivery: { at: at(38) } as Order['delivery'],
      }),
    ).toEqual([
      'placed@12:00',
      'accepted@12:02',
      'picked_up@12:20',
      'arrived@12:35',
      'delivered@12:38',
    ]);
  });

  it('dates a delivery set by an outcome at its collection, else at the outcome', () => {
    const outcome = { at: at(40), collectedAt: at(45) } as Order['outcome'];
    expect(steps({ status: 'delivered', outcome })).toEqual(['placed@12:00', 'delivered@12:45']);
    expect(steps({ status: 'delivered', outcome: { ...outcome!, collectedAt: null } })).toEqual([
      'placed@12:00',
      'delivered@12:40',
    ]);
  });

  it('ends a failed, rejected or cancelled order with its step', () => {
    expect(
      steps({ status: 'failed', outcome: { at: at(50), collectedAt: null } as Order['outcome'] }),
    ).toEqual(['placed@12:00', 'failed@12:50']);
    expect(steps({ status: 'rejected', rejection: { at: at(3) } as Order['rejection'] })).toEqual([
      'placed@12:00',
      'rejected@12:03',
    ]);
    expect(
      steps({ status: 'cancelled', cancellation: { at: at(4) } as Order['cancellation'] }),
    ).toEqual(['placed@12:00', 'cancelled@12:04']);
    // An outcome still waiting for its amount ends nothing.
    expect(
      steps({
        status: 'picked_up',
        outcome: { at: at(50), collectedAt: null } as Order['outcome'],
      }),
    ).toEqual(['placed@12:00']);
  });
});
