import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { menuOf, moduleOfPath, MODULES } = await import('./layout.js');
const sessionBody = (permissions: string[]) => ({
  accountId: '01900000-0000-7000-8000-000000000001',
  roles: ['OPS'],
  permissions,
  signedInAt: '2026-11-19T08:00:00.000Z',
  expiresAt: '2026-11-19T08:30:00.000Z',
});

// OPS's permissions as migrated (identity.admin_role_permissions).
const OPS = [
  'captains.manage',
  'captains.read',
  'captains.release_device',
  'captains.suspend',
  'content.read',
  'customers.block',
  'customers.clear_strikes',
  'customers.close_account',
  'customers.compensate',
  'customers.manage',
  'customers.read',
  'customers.reveal_phone',
  'customers.sign_out_everywhere',
  'dashboard.manage',
  'dashboard.read',
  'dispatch.switch_mode',
  'emergency_stop.toggle',
  'exports.phone_numbers',
  'live_map.manage',
  'live_map.read',
  'marketing.read',
  'menus.edit_prices',
  'menus.review_change_requests',
  'operations.compensate',
  'operations.manage',
  'operations.read',
  'order_history.manage',
  'order_history.read',
  'orders.act_for_captain',
  'orders.confirm_pickup',
  'orders.handover_after_pickup',
  'reports.operations',
  'restaurants.activate',
  'restaurants.create',
  'restaurants.manage',
  'restaurants.menus',
  'restaurants.owner_accounts',
  'restaurants.read',
  'sign_in.emergency_code',
  'support.manage',
  'support.read',
  'support.resolve_pickup_dispute',
  'zones.read',
];

const modules = (permissions: string[]) => menuOf(sessionBody(permissions)).map((m) => m.module);

describe('the side menu (AP §7.1)', () => {
  it("leaves Finance out of an OPS user's menu, and OWN's own modules", () => {
    expect(modules(OPS)).toEqual([
      'operations',
      'liveMap',
      'orderHistory',
      'restaurants',
      'captains',
      'customers',
      'support',
      'marketing',
      'zones',
      'content',
      'reports',
    ]);
    const zones = menuOf(sessionBody(OPS)).find((m) => m.module === 'zones');
    expect(zones?.links).toEqual([
      'zones',
      'cities',
      'office',
      'deliveryFees',
      'payTables',
      'peakBonus',
      'dispatchRules',
    ]);
  });

  it('shows FIN its finance pages and every module to one holding everything', () => {
    const fin = menuOf(sessionBody(['finance.read', 'cash_desk.record'])).find(
      (m) => m.module === 'finance',
    );
    expect(fin?.links).toEqual([
      'cashDesk',
      'captainBalances',
      'dailyReport',
      'costReport',
      'exchangeRates',
    ]);
    const everything = [
      ...OPS,
      'finance.read',
      'cash_desk.record',
      'ledger.manual_adjustment',
      'restaurants.statements',
      'marketing.manage',
      'content.manage',
      'settings.read',
      'settings.manage',
      'admin_team.manage',
      'audit_log.read',
      'reports.all',
    ];
    expect(modules(everything)).toEqual(MODULES);
  });

  it('finds the module of the page open', () => {
    expect(moduleOfPath('/')).toBeNull();
    expect(moduleOfPath('/settings/apps')).toBe('settings');
    expect(moduleOfPath('/settings/otp-senders')).toBe('settings');
    expect(moduleOfPath('/cash-desk/sessions')).toBe('finance');
    expect(moduleOfPath('/orders/0190/assign')).toBe('operations');
    expect(moduleOfPath('/live-map')).toBe('liveMap');
    expect(moduleOfPath('/order-history')).toBe('orderHistory');
    expect(moduleOfPath('/restaurants-x')).toBeNull();
  });
});
