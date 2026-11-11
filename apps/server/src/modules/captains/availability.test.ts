import { describe, expect, it } from 'vitest';
import { availability, type AvailabilityInput, onlineBlocks } from './availability.js';

// CA §7.1–7.2, AP §8.5.3–8.5.4: what stops a captain going online, and the
// state of a captain at a moment. Amounts are minor units of the base
// currency.
const now = new Date('2026-11-07T12:00:00+03:00');
const cutoff = new Date('2026-11-07T06:00:00+03:00');
const hours = (count: number) => count * 3_600_000;

const ready: AvailabilityInput = {
  status: 'active',
  suspension: null,
  onlineSince: null,
  custodyUsage: 0n,
  custodyLimit: 300_000n,
  closedDue: 0n,
  remitTolerance: 0n,
  lastCutoff: cutoff,
  remitOnlineGraceHours: 4,
  appVersion: '1.2.0',
  minVersion: '1.2.0',
  simulatedLocation: false,
  termsPending: false,
  activeOrder: false,
  lastOrder: null,
};

describe('onlineBlocks', () => {
  it('lets an active captain with no cash due go online', () => {
    expect(onlineBlocks(ready, now)).toEqual([]);
  });

  it('waits for the terms in force (K7)', () => {
    expect(onlineBlocks({ ...ready, termsPending: true }, now)).toEqual([
      { kind: 'terms_not_accepted' },
    ]);
  });

  it('refuses a suspended captain until the suspension ends', () => {
    const until = new Date(now.getTime() + hours(24));
    const suspended: AvailabilityInput = {
      ...ready,
      status: 'suspended',
      suspension: { reason: 'تأخر متكرر', until },
    };
    expect(onlineBlocks(suspended, now)).toEqual([
      { kind: 'suspended', reason: 'تأخر متكرر', until },
    ]);
    expect(onlineBlocks(suspended, until)).toEqual([]);
    const openEnded = { ...suspended, suspension: { reason: 'تحقيق', until: null } };
    expect(onlineBlocks(openEnded, new Date(now.getTime() + hours(24 * 365)))).toEqual([
      { kind: 'suspended', reason: 'تحقيق', until: null },
    ]);
  });

  it('refuses a captain whose contract ended', () => {
    expect(onlineBlocks({ ...ready, status: 'terminated' }, now)).toEqual([
      { kind: 'contract_ended' },
    ]);
  });

  it('refuses cash from a closed day above the tolerance', () => {
    expect(onlineBlocks({ ...ready, closedDue: 1n }, now)).toEqual([
      { kind: 'closed_due', amount: 1n, cutoff },
    ]);
    expect(onlineBlocks({ ...ready, closedDue: 1_000n, remitTolerance: 1_000n }, now)).toEqual([]);
    // Positive and negative currencies net in closed_due (AP §8.5.4).
    expect(onlineBlocks({ ...ready, closedDue: -40_000n }, now)).toEqual([]);
  });

  it('refuses a captain at the cash limit, and lets one just below it', () => {
    expect(onlineBlocks({ ...ready, custodyUsage: 300_000n }, now)).toEqual([
      { kind: 'cash_limit', limit: 300_000n },
    ]);
    expect(onlineBlocks({ ...ready, custodyUsage: 299_999n }, now)).toEqual([]);
  });

  it('refuses an app below the minimum version, compared part by part', () => {
    expect(onlineBlocks({ ...ready, appVersion: '1.1.9' }, now)).toEqual([
      { kind: 'version_below_minimum', minVersion: '1.2.0' },
    ]);
    expect(onlineBlocks({ ...ready, appVersion: '1.10.0' }, now)).toEqual([]);
    for (const appVersion of ['1.3.0-beta', 'abc', '', null]) {
      expect(onlineBlocks({ ...ready, appVersion }, now)).toEqual([
        { kind: 'version_below_minimum', minVersion: '1.2.0' },
      ]);
    }
    expect(onlineBlocks({ ...ready, appVersion: '0.1.0', minVersion: null }, now)).toEqual([]);
  });

  it('refuses a simulated location', () => {
    expect(onlineBlocks({ ...ready, simulatedLocation: true }, now)).toEqual([
      { kind: 'simulated_location' },
    ]);
  });

  it('lists every block at once, so the app can show each', () => {
    const blocks = onlineBlocks(
      { ...ready, closedDue: 5_000n, custodyUsage: 400_000n, simulatedLocation: true },
      now,
    );
    expect(blocks.map((block) => block.kind)).toEqual([
      'closed_due',
      'cash_limit',
      'simulated_location',
    ]);
  });
});

describe('availability', () => {
  const online = { ...ready, onlineSince: new Date(now.getTime() - hours(1)) };

  it('is offline without an online period', () => {
    expect(availability(ready, now)).toEqual({ state: 'offline' });
  });

  it('is online and available with nothing in the way', () => {
    expect(availability(online, now)).toEqual({
      state: 'online_available',
      since: online.onlineSince,
    });
  });

  it('stops offers at the cash limit, while staying online', () => {
    expect(availability({ ...online, custodyUsage: 300_000n }, now)).toEqual({
      state: 'not_receiving_offers',
      since: online.onlineSince,
      reasons: ['cash_limit'],
    });
  });

  it('keeps offers for the grace hours after a cutoff passed while online', () => {
    const acrossCutoff = {
      ...online,
      onlineSince: new Date(cutoff.getTime() - hours(1)),
      closedDue: 5_000n,
    };
    const withinGrace = new Date(cutoff.getTime() + hours(4) - 1);
    expect(availability(acrossCutoff, withinGrace).state).toBe('online_available');
    expect(availability(acrossCutoff, new Date(cutoff.getTime() + hours(4)))).toEqual({
      state: 'not_receiving_offers',
      since: acrossCutoff.onlineSince,
      reasons: ['closed_due'],
    });
  });

  it('stops offers for cash due that appears after going online past the cutoff', () => {
    expect(availability({ ...online, closedDue: 5_000n }, now)).toEqual({
      state: 'not_receiving_offers',
      since: online.onlineSince,
      reasons: ['closed_due'],
    });
  });

  it('stops offers while a simulated location is reported', () => {
    expect(availability({ ...online, simulatedLocation: true }, now).state).toBe(
      'not_receiving_offers',
    );
  });

  it('is busy with an active order, whatever else stops offers (CA §7.1)', () => {
    expect(availability({ ...online, activeOrder: true }, now)).toEqual({
      state: 'busy',
      since: online.onlineSince,
    });
    expect(availability({ ...online, activeOrder: true, custodyUsage: 400_000n }, now).state).toBe(
      'busy',
    );
  });

  it('shows a suspension, and a contract end as offline', () => {
    const until = new Date(now.getTime() + hours(2));
    expect(
      availability(
        { ...ready, status: 'suspended', suspension: { reason: 'تأخر متكرر', until } },
        now,
      ),
    ).toEqual({ state: 'suspended', reason: 'تأخر متكرر', until });
    expect(availability({ ...ready, status: 'terminated' }, now)).toEqual({ state: 'offline' });
  });

  // CA §7.3, §7.6, K13, K18: last-order mode, asked by the captain or set by
  // operations' force offline, a suspension or a termination during an order.
  it('is in last-order mode while an order runs, whoever asked', () => {
    const busy = { ...online, activeOrder: true };
    expect(availability({ ...busy, lastOrder: { by: 'captain', reason: null } }, now)).toEqual({
      state: 'last_order',
      since: online.onlineSince,
      by: 'captain',
      reason: null,
    });
    expect(
      availability({ ...busy, lastOrder: { by: 'forced', reason: 'Late hand-in' } }, now),
    ).toEqual({ state: 'last_order', since: online.onlineSince, by: 'forced', reason: 'Late hand-in' });
  });

  it('keeps a captain suspended or terminated during an order in last-order mode (K18)', () => {
    const until = new Date(now.getTime() + hours(24));
    const suspended: AvailabilityInput = {
      ...online,
      activeOrder: true,
      status: 'suspended',
      suspension: { reason: 'Repeated delays', until },
      lastOrder: { by: 'suspended', reason: null },
    };
    expect(availability(suspended, now)).toEqual({
      state: 'last_order',
      since: online.onlineSince,
      by: 'suspended',
      reason: 'Repeated delays',
    });
    expect(
      availability(
        { ...online, activeOrder: true, status: 'terminated', lastOrder: { by: 'terminated', reason: null } },
        now,
      ),
    ).toEqual({ state: 'last_order', since: online.onlineSince, by: 'terminated', reason: null });
  });

  it('never offers a captain in last-order mode once the order left them', () => {
    // Until the job ends the online period, the state stays last-order, which
    // dispatch never offers (it offers online_available only).
    expect(
      availability({ ...online, lastOrder: { by: 'captain', reason: null } }, now).state,
    ).toBe('last_order');
    expect(
      availability(
        {
          ...online,
          status: 'suspended',
          suspension: { reason: 'Repeated delays', until: null },
          lastOrder: { by: 'suspended', reason: null },
        },
        now,
      ).state,
    ).toBe('suspended');
  });
});
