import { describe, expect, it, vi } from 'vitest';
import {
  canCancel,
  type CancelForm,
  type CancelPreview,
  cancelBody,
  previewBody,
  previewLines,
} from './order-cancel.js';

vi.mock('./api.js', () => ({ api: {} }));

const choices = { reasons: [{ code: 'emergency', label: 'ظرف طارئ' }] };
const form: CancelForm = {
  cancellation: 'emergency',
  responsible: 'platform',
  foodPrepared: true,
  compensateCaptain: true,
  cash: null,
  reason: ' ملاحظة ',
};
const notAsked = { cashAsked: false, compensationAllowed: false };

// AP §9.3.2: OWN and OPS cancel while the order is placed, accepted or ready.
describe('canCancel', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs operations.manage and the dialog choices', () => {
    expect(canCancel(session(['operations.manage']), { cancelChoices: choices })).toBe(true);
    expect(canCancel(session(['operations.read']), { cancelChoices: choices })).toBe(false);
    expect(canCancel(session(['operations.manage']), { cancelChoices: null })).toBe(false);
  });
});

describe('previewBody', () => {
  it('waits for a responsible party and never sends food or compensation on a placed order', () => {
    expect(previewBody({ ...form, responsible: null }, false)).toBeNull();
    expect(previewBody(form, true)).toMatchObject({
      foodPrepared: false,
      compensateCaptain: false,
    });
    expect(previewBody({ ...form, cancellation: null }, false)).toMatchObject({
      cancellation: null,
      foodPrepared: true,
    });
  });
});

describe('cancelBody', () => {
  it('needs the reason, the party, the note and the preview', () => {
    expect(cancelBody(form, false, notAsked)).toEqual({
      cancellation: 'emergency',
      responsible: 'platform',
      foodPrepared: true,
      compensateCaptain: false,
      cash: null,
      reason: 'ملاحظة',
    });
    expect(cancelBody({ ...form, reason: '  ' }, false, notAsked)).toBeNull();
    expect(cancelBody({ ...form, cancellation: null }, false, notAsked)).toBeNull();
    expect(cancelBody(form, false, undefined)).toBeNull();
  });

  it('needs the cash answer once asked, and drops answers the order no longer allows', () => {
    const asked = { cashAsked: true, compensationAllowed: true };
    expect(cancelBody(form, false, asked)).toBeNull();
    expect(cancelBody({ ...form, cash: 'not_returned' }, false, asked)).toMatchObject({
      cash: 'not_returned',
      compensateCaptain: true,
    });
    expect(cancelBody({ ...form, cash: 'returned' }, false, notAsked)).toMatchObject({
      cash: null,
    });
  });
});

const merchant = { kind: 'merchant', id: 'm', name: 'مطعم الريم' } as const;
const captain = { kind: 'captain', id: 'c', name: 'أحمد' } as const;
const platform = { kind: 'platform', id: null, name: null } as const;
const try_ = (amount: string) => ({ amount, currency: 'TRY' });

// docs/domain/09: every entry with its amount, account and party, one
// sentence per journal (owner decision 2026-11-10).
describe('previewLines', () => {
  it('names each journal and the strike, without the clearing account', () => {
    const preview: CancelPreview = {
      cashAsked: true,
      compensationAllowed: true,
      cashLines: [try_('40000')],
      strike: true,
      entries: [
        {
          type: 'merchant.credit',
          account: 'merchant.account',
          party: merchant,
          amount: try_('-34000'),
        },
        {
          type: 'merchant.credit',
          account: 'platform.order_clearing',
          party: platform,
          amount: try_('34000'),
        },
        {
          type: 'platform.operating_cost',
          account: 'platform.operating_cost',
          party: platform,
          amount: try_('34000'),
        },
        {
          type: 'platform.operating_cost',
          account: 'platform.order_clearing',
          party: platform,
          amount: try_('-34000'),
        },
        {
          type: 'earn.order_pay',
          account: 'captain.earnings',
          party: captain,
          amount: try_('-3500'),
        },
        {
          type: 'earn.order_pay',
          account: 'platform.test_cost',
          party: platform,
          amount: try_('3500'),
        },
        {
          type: 'custody.pay_merchant',
          account: 'captain.custody',
          party: captain,
          amount: try_('-40000'),
        },
        {
          type: 'custody.pay_merchant',
          account: 'platform.order_clearing',
          party: platform,
          amount: try_('40000'),
        },
        {
          type: 'merchant.debit',
          account: 'merchant.account',
          party: merchant,
          amount: try_('40000'),
        },
        {
          type: 'merchant.debit',
          account: 'platform.order_clearing',
          party: platform,
          amount: try_('-40000'),
        },
      ],
    };
    expect(previewLines(preview)).toEqual([
      { key: 'merchantCredit', name: 'مطعم الريم', amount: try_('34000') },
      { key: 'platformCost', amount: try_('34000') },
      { key: 'captainPay', name: 'أحمد', amount: try_('3500'), testCost: true },
      { key: 'captainCustody', name: 'أحمد', amounts: [try_('40000')] },
      { key: 'merchantDebit', name: 'مطعم الريم', amount: try_('40000') },
      { key: 'strike' },
    ]);
  });

  it('says when nothing is posted, and flags a journal it cannot name', () => {
    const none = {
      cashAsked: false,
      compensationAllowed: false,
      cashLines: null,
      strike: false,
      entries: [],
    };
    expect(previewLines(none)).toEqual([{ key: 'nothing' }]);
    expect(
      previewLines({
        ...none,
        entries: [{ type: 'other.kind', account: 'x', party: platform, amount: try_('1') }],
      }),
    ).toEqual([{ key: 'unknown' }]);
  });
});
