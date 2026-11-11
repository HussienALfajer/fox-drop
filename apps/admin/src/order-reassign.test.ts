import { describe, expect, it, vi } from 'vitest';
import { canReassign, chooseReason, type ReassignForm, reassignBody } from './order-reassign.js';

vi.mock('./api.js', () => ({ api: {} }));

const choices = {
  reasons: [
    { code: 'captain_late', label: 'تأخر الكابتن', captainFault: true },
    { code: 'accident', label: 'حادث', captainFault: false },
  ],
};
const empty: ReassignForm = {
  reassignment: null,
  captainFault: null,
  cash: null,
  next: 'dispatch',
  reason: ' ملاحظة ',
};

// AP §9.3.2 «سحب وإعادة تعيين»: OWN and OPS, while the detail offers it.
describe('canReassign', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs operations.manage and the dialog choices', () => {
    expect(canReassign(session(['operations.manage']), { reassignChoices: choices })).toBe(true);
    expect(canReassign(session(['operations.read']), { reassignChoices: choices })).toBe(false);
    expect(canReassign(session(['operations.manage']), { reassignChoices: null })).toBe(false);
  });
});

// AP Appendix B, owner decision 2026-11-10: the reason prefills its fault,
// which the admin may change.
describe('chooseReason', () => {
  it("prefills each reason's default fault", () => {
    const late = chooseReason(empty, choices, 'captain_late');
    expect(late).toMatchObject({ reassignment: 'captain_late', captainFault: true });
    expect(chooseReason({ ...late, captainFault: false }, choices, 'accident')).toMatchObject({
      reassignment: 'accident',
      captainFault: false,
    });
  });

  it('prefills the captain fault while they could not complete the order (AP §9.7.6)', () => {
    expect(chooseReason(empty, choices, 'accident', true)).toMatchObject({
      reassignment: 'accident',
      captainFault: true,
    });
    expect(chooseReason(empty, choices, 'unknown', true).captainFault).toBeNull();
  });

  it('prefills «دون خطأ» after the captain’s «طوارئ» (owner decision 2026-11-11)', () => {
    expect(chooseReason(empty, choices, 'captain_late', false, true).captainFault).toBe(false);
    expect(chooseReason(empty, choices, 'captain_late', true, true).captainFault).toBe(false);
  });
});

describe('reassignBody', () => {
  const form = { ...chooseReason(empty, choices, 'captain_late') };
  it('needs the reason, the fault, the note and the preview', () => {
    expect(reassignBody(form, { cashAsked: false })).toEqual({
      reassignment: 'captain_late',
      captainFault: true,
      cash: null,
      reason: 'ملاحظة',
    });
    expect(reassignBody(empty, { cashAsked: false })).toBeNull();
    expect(reassignBody({ ...form, reason: ' ' }, { cashAsked: false })).toBeNull();
    expect(reassignBody(form, undefined)).toBeNull();
  });

  it('needs the cash answer exactly when the preview asks it', () => {
    expect(reassignBody(form, { cashAsked: true })).toBeNull();
    expect(reassignBody({ ...form, cash: 'returned' }, { cashAsked: true })).toMatchObject({
      cash: 'returned',
    });
    expect(reassignBody({ ...form, cash: 'returned' }, { cashAsked: false })).toMatchObject({
      cash: null,
    });
  });
});
