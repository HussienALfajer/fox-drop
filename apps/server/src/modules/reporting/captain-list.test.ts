import { describe, expect, it } from 'vitest';
import { expiredInRow, listedStatus } from './captain-list.service.js';

// AP §9.7.3 (slice 2.36a): the listed status's order of precedence.
describe('listedStatus', () => {
  const balance = (blocks: ('closed_due' | 'cash_limit')[] = [], status = 'active' as const) => ({
    status,
    blocks,
  });

  it('puts a suspension, then an order, then a hand-in block', () => {
    expect(listedStatus(balance(['closed_due']), 'suspended')).toBe('suspended');
    expect(listedStatus(balance(['cash_limit']), 'busy')).toBe('busy');
    expect(listedStatus(balance(['cash_limit']), 'last_order')).toBe('busy');
    expect(listedStatus(balance(['closed_due']), 'not_receiving_offers')).toBe('cash_blocked');
    expect(listedStatus(balance(['cash_limit']), 'offline')).toBe('cash_blocked');
    expect(listedStatus(balance(), 'online_available')).toBe('online');
    expect(listedStatus(balance(), 'not_receiving_offers')).toBe('online');
    expect(listedStatus(balance(), 'offline')).toBe('offline');
  });

  it('says terminated whatever the rest', () => {
    expect(listedStatus({ status: 'terminated', blocks: ['closed_due'] }, null)).toBe('terminated');
  });
});

// AP §9.7.4 «التطبيق»: the expired offers in a row, newest first.
describe('expiredInRow', () => {
  it('counts the answered offers that expired from the newest', () => {
    const offers = ['open', 'expired', 'withdrawn', 'expired', 'declined', 'expired'].map(
      (status) => ({ status }),
    );
    expect(expiredInRow(offers)).toBe(2);
    expect(expiredInRow([{ status: 'expired' }, { status: 'expired' }])).toBe(2);
    expect(expiredInRow([{ status: 'accepted' }, { status: 'expired' }])).toBe(0);
    expect(expiredInRow([])).toBe(0);
  });
});
