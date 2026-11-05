import { describe, expect, it } from 'vitest';
import { commissionAt } from './commission.js';
import { operatingState, type OperatingInput, takesOrders } from './operating-state.js';

// The restaurant's state of RA §7.1 and AP §9.6.1: the first that applies of
// the account status, holiday close, schedule, pause and the active-orders
// limit; busy mode is a flag on open.
const now = new Date('2026-11-06T12:00:00+03:00');
const later = new Date('2026-11-06T13:00:00+03:00');
const earlier = new Date('2026-11-06T11:00:00+03:00');

const open: OperatingInput = {
  accountStatus: 'active',
  holiday: null,
  period: { endsAt: new Date('2026-11-06T14:00:00+03:00') },
  pause: null,
  busyMode: null,
  activeOrders: 0,
  maxActiveOrders: null,
};

describe('operatingState', () => {
  it('is open inside an opening period with nothing else in the way', () => {
    expect(operatingState(open, now)).toEqual({ state: 'open', busyExtraMin: null });
    expect(operatingState({ ...open, accountStatus: 'test' }, now).state).toBe('open');
  });

  it('puts the account status first: draft, suspended and terminated take no orders', () => {
    for (const accountStatus of ['draft', 'suspended', 'terminated'] as const) {
      const state = operatingState(
        { ...open, accountStatus, holiday: { endsAt: later }, period: null },
        now,
      );
      expect(state).toEqual({ state: accountStatus });
      expect(takesOrders(state)).toBe(false);
    }
  });

  it('puts a holiday close before the schedule, until its end', () => {
    expect(operatingState({ ...open, holiday: { endsAt: later } }, now)).toEqual({
      state: 'holiday',
      until: later,
    });
    expect(operatingState({ ...open, holiday: { endsAt: now } }, now).state).toBe('open');
  });

  it('is closed outside every opening period, whatever the pause or limit', () => {
    expect(
      operatingState(
        {
          ...open,
          period: null,
          pause: { source: 'ops', endsAt: null },
          activeOrders: 5,
          maxActiveOrders: 5,
        },
        now,
      ),
    ).toEqual({ state: 'closed' });
  });

  it('is paused by any source until the pause ends', () => {
    for (const source of ['restaurant', 'ops', 'auto'] as const) {
      expect(operatingState({ ...open, pause: { source, endsAt: later } }, now)).toEqual({
        state: 'paused',
        source,
        until: later,
      });
    }
    expect(operatingState({ ...open, pause: { source: 'ops', endsAt: null } }, now)).toEqual({
      state: 'paused',
      source: 'ops',
      until: null,
    });
    expect(operatingState({ ...open, pause: { source: 'ops', endsAt: earlier } }, now).state).toBe(
      'open',
    );
  });

  it('puts a pause before the active-orders limit', () => {
    expect(
      operatingState(
        {
          ...open,
          pause: { source: 'restaurant', endsAt: later },
          activeOrders: 3,
          maxActiveOrders: 3,
        },
        now,
      ).state,
    ).toBe('paused');
  });

  it('is busy at the active-orders limit and open again below it', () => {
    const busy = operatingState({ ...open, activeOrders: 3, maxActiveOrders: 3 }, now);
    expect(busy).toEqual({ state: 'busy' });
    expect(takesOrders(busy)).toBe(false);
    expect(operatingState({ ...open, activeOrders: 2, maxActiveOrders: 3 }, now).state).toBe(
      'open',
    );
    expect(operatingState({ ...open, activeOrders: 40, maxActiveOrders: null }, now).state).toBe(
      'open',
    );
  });

  it('carries busy mode as a flag on open, until it ends', () => {
    const state = operatingState({ ...open, busyMode: { extraMin: 20, endsAt: later } }, now);
    expect(state).toEqual({ state: 'open', busyExtraMin: 20 });
    expect(takesOrders(state)).toBe(true);
    expect(operatingState({ ...open, busyMode: { extraMin: 20, endsAt: earlier } }, now)).toEqual({
      state: 'open',
      busyExtraMin: null,
    });
  });
});

// AP §9.6.5, D16: a commission change applies to new orders, at once or from
// a set time, such as a launch commission until a date and then the standard.
describe('commissionAt', () => {
  const versions = [
    { id: '01', rateBp: 1500, effectiveFrom: new Date('2026-10-01T00:00:00Z') },
    { id: '02', rateBp: 1000, effectiveFrom: new Date('2026-11-01T00:00:00Z') },
    { id: '03', rateBp: 1500, effectiveFrom: new Date('2027-02-01T00:00:00Z') },
  ];

  it('takes the newest version already in effect', () => {
    expect(commissionAt(versions, new Date('2026-11-06T00:00:00Z'))?.rateBp).toBe(1000);
    expect(commissionAt(versions, new Date('2027-02-01T00:00:00Z'))?.rateBp).toBe(1500);
    expect(commissionAt(versions, new Date('2026-09-01T00:00:00Z'))).toBeNull();
  });

  it('takes the later version of two with the same start', () => {
    const replaced = [
      ...versions,
      { id: '04', rateBp: 1200, effectiveFrom: versions[1]!.effectiveFrom },
    ];
    expect(commissionAt(replaced, new Date('2026-11-06T00:00:00Z'))?.rateBp).toBe(1200);
  });
});
