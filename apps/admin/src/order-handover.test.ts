import { describe, expect, it, vi } from 'vitest';
import { canHandOver, type Handover, handoverNote, handoverState } from './order-handover.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.3.2 «تسليم لكابتن آخر» (slice 2.12b).
describe('canHandOver', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  const allowed = { handover: { allowed: true, handovers: [] } };
  it('needs operations.manage and the server allowing it', () => {
    expect(canHandOver(session(['operations.manage']), allowed)).toBe(true);
    expect(canHandOver(session(['operations.read']), allowed)).toBe(false);
    expect(
      canHandOver(session(['operations.manage']), { handover: { allowed: false, handovers: [] } }),
    ).toBe(false);
  });
});

describe('handoverNote', () => {
  it('is required: a blank note is none', () => {
    expect(handoverNote('   ')).toBeNull();
    expect(handoverNote(' حادث ')).toBe('حادث');
  });
});

describe('handoverState', () => {
  const base: Handover = {
    openedAt: '2026-11-11T10:00:00.000Z',
    fromCaptainId: 'a',
    fromCaptainName: 'سامر',
    toCaptainId: 'b',
    toCaptainName: 'باسل',
    offered: true,
    assignedAt: null,
    receivedAt: null,
    closedAt: null,
    closeReason: null,
    note: 'حادث',
    adminId: 'c',
    captainFault: null,
  };
  it('tells an offer, a wait, a receipt and a close apart', () => {
    expect(handoverState(base)).toEqual({ kind: 'offered' });
    expect(handoverState({ ...base, assignedAt: base.openedAt })).toEqual({ kind: 'waiting' });
    expect(
      handoverState({ ...base, assignedAt: base.openedAt, receivedAt: '2026-11-11T10:09:00Z' }),
    ).toEqual({ kind: 'received', at: '2026-11-11T10:09:00Z' });
    expect(handoverState({ ...base, closedAt: base.openedAt, closeReason: 'expired' })).toEqual({
      kind: 'closed',
      reason: 'expired',
    });
  });
});
