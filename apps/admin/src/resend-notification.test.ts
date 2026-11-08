import { describe, expect, it, vi } from 'vitest';
import { canResend, resendTargets } from './resend-notification.js';

vi.mock('./api.js', () => ({ api: {} }));

const captain = { name: 'أحمد', vehicle: 'motorbike' } as const;

// AP §9.3.2 «إعادة إرسال الإشعار»: active orders, OWN, OPS and SUP.
describe('resendTargets', () => {
  it('offers the captain only once one is assigned, and nothing once the order ended', () => {
    expect(resendTargets({ status: 'placed', captain: null })).toEqual(['customer', 'merchant']);
    expect(resendTargets({ status: 'picked_up', captain } as never)).toEqual([
      'customer',
      'merchant',
      'captain',
    ]);
    expect(resendTargets({ status: 'delivered', captain } as never)).toEqual([]);
    expect(resendTargets({ status: 'cancelled', captain: null })).toEqual([]);
  });
});

describe('canResend', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('lets operations and support resend', () => {
    expect(canResend(session(['operations.manage']))).toBe(true);
    expect(canResend(session(['operations.read', 'operations.compensate']))).toBe(true);
    expect(canResend(session(['operations.read']))).toBe(false);
  });
});
