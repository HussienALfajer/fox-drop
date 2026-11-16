import { describe, expect, it, vi } from 'vitest';
import {
  canResolveShortfall,
  resolveBody,
  type ShortfallPreview,
  shortfallLines,
} from './order-shortfall.js';

vi.mock('./api.js', () => ({ api: {} }));

const TRY = (amount: string) => ({ amount, currency: 'TRY' });
const shortfall = {
  amount: TRY('3000'),
  reason: 'customer_short',
  label: 'الزبون لا يملك المبلغ كاملاً',
  note: null,
  resolution: null,
};
const delivery = (short: typeof shortfall | null | { resolution: object }) =>
  ({ delivery: { shortfall: short } }) as never;

// AP §8.6 «حلّ النقص» (slice 2.20b): OWN and OPS, while a shortfall is open.
describe('canResolveShortfall', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs operations.manage and an open shortfall', () => {
    const manage = session(['operations.manage']);
    expect(canResolveShortfall(manage, delivery(shortfall))).toBe(true);
    expect(canResolveShortfall(session(['operations.read']), delivery(shortfall))).toBe(false);
    expect(canResolveShortfall(manage, delivery(null))).toBe(false);
    expect(
      canResolveShortfall(
        manage,
        delivery({ ...shortfall, resolution: { responsible: 'captain' } } as never),
      ),
    ).toBe(false);
    expect(canResolveShortfall(manage, { delivery: null })).toBe(false);
  });
});

describe('resolveBody', () => {
  it('needs a party and the note', () => {
    expect(resolveBody(null, 'ملاحظة')).toBeNull();
    expect(resolveBody('customer', '  ')).toBeNull();
    expect(resolveBody('customer', ' اتفقنا ')).toEqual({
      responsible: 'customer',
      reason: 'اتفقنا',
    });
  });
});

const entry = (
  type: string,
  account: string,
  kind: 'captain' | 'customer' | 'platform',
  amount: string,
  name: string | null = null,
) => ({
  type,
  reason: 'نقص في التحصيل',
  account,
  party: { kind, id: kind === 'platform' ? null : `${kind}-1`, name },
  amount: TRY(amount),
});

const preview = (entries: ShortfallPreview['entries']): ShortfallPreview => ({
  shortfall: TRY('3000'),
  dues: null,
  captainCharge: null,
  entries,
});

describe('shortfallLines', () => {
  it('names each party in the outcome dialog sentences', () => {
    expect(
      shortfallLines(
        preview([
          entry('earn.charge', 'captain.earnings', 'captain', '3000', 'سامر'),
          entry('earn.charge', 'platform.order_clearing', 'platform', '-3000'),
        ]),
      ),
    ).toEqual([
      { key: 'captainCharge', name: 'سامر', amount: TRY('3000'), reason: 'نقص في التحصيل' },
    ]);
    expect(
      shortfallLines(
        preview([
          entry('dues.charge', 'customer.dues', 'customer', '3000', 'أحمد'),
          entry('dues.charge', 'platform.order_clearing', 'platform', '-3000'),
        ]),
      ),
    ).toEqual([{ key: 'dues', name: 'أحمد', amount: TRY('3000') }]);
    expect(
      shortfallLines(
        preview([
          entry('platform.operating_cost', 'platform.operating_cost', 'platform', '3000'),
          entry('platform.operating_cost', 'platform.order_clearing', 'platform', '-3000'),
        ]),
      ),
    ).toEqual([{ key: 'platformCost', amount: TRY('3000'), test: false }]);
  });

  it('marks an entry it cannot name as unknown, which blocks the confirm', () => {
    expect(
      shortfallLines(preview([entry('merchant.debit', 'merchant.account', 'platform', '3000')])),
    ).toEqual([{ key: 'unknown' }]);
  });
});
