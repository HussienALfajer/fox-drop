import type { components, paths } from '@fox-drop/api-schema';
import { infiniteQueryOptions, queryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import { zonedToUtc } from './emergency-stop.js';
import { decimalOf } from './format.js';
import { type AdminSession, can } from './session.js';

// AP §9.16 «سجل التدقيق» (slice 2.38a): OWN reads every write and sensitive
// view, never changes it.
export const AUDIT_LOG_READ = 'audit_log.read';

export type AuditLogPage = components['schemas']['AdminAuditLogDto_Output'];
export type AuditEvent = AuditLogPage['events'][number];

export function canReadAuditLog(session: AdminSession | null | undefined): boolean {
  return can(session, AUDIT_LOG_READ);
}

export const actorTypes = ['admin', 'merchant', 'captain', 'customer', 'system'] as const;
export type ActorType = (typeof actorTypes)[number];

// The target types the filter offers and the log names (AP §9.16: order,
// restaurant, captain, customer, setting, and the others the server writes);
// another shows as its code.
export const targetTypes = [
  'setting',
  'order',
  'restaurant',
  'captain',
  'captain_application',
  'customer',
  'admin_account',
  'admin_session',
  'merchant_account',
  'merchant_device',
  'captain_account',
  'customer_account',
  'ticket',
  'compensation',
  'promo_code',
  'promo_code_batch',
  'receipt',
  'drawer_session',
  'manual_entry',
  'rate',
  'city',
  'city_currency',
  'zone',
  'content',
  'item',
  'category',
  'option',
  'option_group',
  'emergency_stop',
  'export',
  'otp_sender_number',
  'banner',
  'home_section',
  'mass_push',
  'menu_category',
  'menu_item',
  'menu_option_group',
  'pay_table',
  'peak_bonus',
  'statement',
] as const;
export type TargetType = (typeof targetTypes)[number];

export function targetTypeOf(type: string): TargetType | null {
  return targetTypes.find((each) => each === type) ?? null;
}

// The actions the log names in words, by their code; another shows as its
// code, so a new action is never hidden from the owner.
export const auditActions = [
  'setting.update',
  'setting.reset',
  'admin_account.create',
  'admin_account.setup',
  'admin_account.setup_link_reissue',
  'admin_account.roles_change',
  'admin_account.disable',
  'admin_account.enable',
  'admin_account.lock',
  'admin_account.force_sign_out',
  'admin_account.totp_reset',
  'admin_session.sign_in',
  'admin_session.sign_out',
  'app_sign_in_code.emergency_issue',
  'otp_sender_number.status_change',
  'otp_sender_number.disable',
  'emergency_stop.start',
  'emergency_stop.resume',
  'city.update',
  'city.office',
  'city_currency.set',
  'base_currency.set',
  'zone.create',
  'zone.update',
  'rate.set',
  'pay_table.create',
  'peak_bonus.set',
  'order.assign_captain',
  'order.manual_dispatch',
  'order.handover',
  'order.confirm_pickup',
  'order.record_arrival',
  'order.record_delivery',
  'order.record_outcome_payment',
  'order.resend_notification',
  'restaurant.create',
  'restaurant.status',
  'restaurant.visibility',
  'restaurant.sort_weight',
  'restaurant.commission',
  'restaurant.categories',
  'restaurant.hours',
  'restaurant.pause',
  'restaurant.note',
  'restaurant.menu_images_waiver',
  'restaurant.contract.view',
  'merchant_account.create',
  'merchant_account.remove',
  'merchant_accounts.view',
  'merchant_device.rename',
  'merchant_device.windows_pairing',
  'merchant_device.windows_register',
  'merchant_devices.sign_out',
  'menu.bulk_price',
  'menu.category.create',
  'menu.item.create',
  'menu.item.photo',
  'menu.option_group.create',
  'captain.create',
  'captain.status',
  'captain.custody_limit',
  'captain.force_offline',
  'captain.hand_in_grace',
  'captain.bulk_hand_in_grace',
  'captain.message',
  'captain.note',
  'captain.phone_view',
  'captain.violation',
  'captain.violation_appeal',
  'captain_account.create',
  'captain_account.release_device',
  'captain_application.phone_view',
  'customer.block',
  'customer.unblock',
  'customer.clear_strikes',
  'customer.end_review_stop',
  'customer.lift_device_block',
  'customer.trust_mark',
  'customer.test_account',
  'customer.note',
  'customer.phone.view',
  'customer_account.close',
  'customer_account.phone_change',
  'customer_account.sign_out_everywhere',
  'ticket.open',
  'ticket.assign',
  'ticket.status',
  'ticket.note',
  'ticket.resolve',
  'ticket.close',
  'ticket.reopen',
  'compensation.approve',
  'compensation.reject',
  'promo_code.edit',
  'promo_code.extend',
  'cash_desk.session_open',
  'cash_desk.session_close',
  'cash_desk.receipt',
  'cash_desk.settlement',
  'ledger.manual_adjustment',
  'ledger.reversal',
  'content.reason.create',
  'content.text.update',
  'content.terms.publish',
  'export.create',
  'export.download',
  'order.accept',
  'order.acknowledge_cancellation',
  'order.acknowledge_edit',
  'order.answer_ping',
  'order.arrive',
  'order.arrive_at_customer',
  'order.cancel',
  'order.cannot_complete',
  'order.change_outcome',
  'order.change_time',
  'order.close_item_report',
  'order.collect_outcome',
  'order.confirm_pickup_for_restaurant',
  'order.deliver',
  'order.dispute_pickup',
  'order.edit',
  'order.emergency',
  'order.no_answer_wait',
  'order.pickup_incomplete',
  'order.ping_customer',
  'order.ready',
  'order.reassign',
  'order.receive_handover',
  'order.reject',
  'order.report_item',
  'order.report_no_answer',
  'order.request_pickup',
  'order.resolve_shortfall',
  'order.set_outcome',
  'order.withdraw_cannot_complete',
  'order.withdraw_item_report',
  'captain_application.activate',
  'captain_application.back_from_waitlist',
  'captain_application.cash_limit',
  'captain_application.close',
  'captain_application.contract',
  'captain_application.deposit',
  'captain_application.document_request',
  'captain_application.document_review',
  'captain_application.document_upload',
  'captain_application.interview',
  'captain_application.issue_kit',
  'captain_application.kit_return',
  'captain_application.note',
  'captain_application.probation_confirmed',
  'captain_application.reject',
  'captain_application.terminate',
  'captain_application.training_passed',
  'captain_application.waitlist',
  'merchant_account.phone_change',
  'captain_account.phone_change',
  'admin_account.totp_enrol',
] as const;
export type AuditAction = (typeof auditActions)[number];

export function auditActionOf(action: string): AuditAction | null {
  return auditActions.find((each) => each === action) ?? null;
}

// The filters, kept in the page's search so a view of the log has its link.
// Dates are calendar days on the chosen city's clock, `to` included.
export interface AuditLogSearch {
  city?: string;
  actorType?: ActorType;
  actorId?: string;
  action?: string;
  targetType?: string;
  targetId?: string;
  from?: string;
  to?: string;
}

const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;
const dotted = /^[a-z_]+(\.[a-z_]+)*$/;
const day = /^\d{4}-\d{2}-\d{2}$/;

const text = (value: unknown, pattern: RegExp, max = 100): string | undefined =>
  typeof value === 'string' && value.length <= max && pattern.test(value) ? value : undefined;

export function auditLogSearchOf(search: Record<string, unknown>): AuditLogSearch {
  const found: Record<string, string | undefined> = {
    city: typeof search.city === 'string' ? search.city : undefined,
    actorType: actorTypes.find((each) => each === search.actorType),
    actorId: text(search.actorId, uuid),
    action: text(search.action, dotted),
    targetType: text(search.targetType, dotted),
    targetId: text(search.targetId, /^\S.*$/),
    from: text(search.from, day),
    to: text(search.to, day),
  };
  return Object.fromEntries(
    Object.entries(found).filter(([, value]) => value !== undefined),
  ) as AuditLogSearch;
}

// The day after a YYYY-MM-DD, so `to` includes its whole day.
function nextDay(date: string): string {
  const at = new Date(`${date}T00:00:00Z`);
  at.setUTCDate(at.getUTCDate() + 1);
  return at.toISOString().slice(0, 10);
}

export type AuditLogQuery = NonNullable<paths['/v1/admin/audit-log']['get']['parameters']['query']>;

// The query the server takes: each calendar day's midnight on the city's
// clock.
export function auditLogQueryOf(search: AuditLogSearch, timeZone: string): AuditLogQuery {
  const from = search.from === undefined ? null : zonedToUtc(`${search.from}T00:00`, timeZone);
  const to = search.to === undefined ? null : zonedToUtc(`${nextDay(search.to)}T00:00`, timeZone);
  const query: Record<string, string | undefined> = {
    actorType: search.actorType,
    actorId: search.actorId,
    action: search.action,
    targetType: search.targetType,
    targetId: search.targetId,
    from: from ?? undefined,
    to: to ?? undefined,
  };
  return Object.fromEntries(
    Object.entries(query).filter(([, value]) => value !== undefined),
  ) as AuditLogQuery;
}

export const auditLogQuery = (query: AuditLogQuery) =>
  infiniteQueryOptions({
    queryKey: ['audit-log', query],
    initialPageParam: null as string | null,
    queryFn: async ({ pageParam }): Promise<AuditLogPage> => {
      const { data } = await api.GET('/v1/admin/audit-log', {
        params: { query: pageParam === null ? query : { ...query, cursor: pageParam } },
      });
      if (!data) throw new Error('The audit log read failed.');
      return data;
    },
    getNextPageParam: (page) => page.nextCursor,
  });

// The admins by name, for the actor filter: «فريق الإدارة»'s list, which OWN
// reads too; without it the filter takes the actor type alone.
export const auditActorsQuery = queryOptions({
  queryKey: ['audit-log', 'actors'],
  queryFn: async (): Promise<{ id: string; name: string }[]> => {
    const { data } = await api.GET('/v1/admin/team/users');
    if (!data) throw new Error('The team read failed.');
    return data.users
      .flatMap((user) => (user.name === null ? [] : [{ id: user.id, name: user.name }]))
      .sort((a, b) => a.name.localeCompare(b.name, 'ar'));
  },
});

// A value of the diff as the log shows it: a text as written, a number as
// it is, a flag in words, an amount in major units with its currency,
// anything else as its JSON. Null is no value.
export function valueText(json: string | null, flag: { on: string; off: string }): string | null {
  if (json === null) return null;
  const value = JSON.parse(json) as unknown;
  if (value === null) return null;
  if (typeof value === 'string') return value;
  if (typeof value === 'number') return String(value);
  if (typeof value === 'boolean') return value ? flag.on : flag.off;
  const money = value as { amountMinor?: unknown; currency?: unknown };
  if (
    typeof money.amountMinor === 'number' &&
    typeof money.currency === 'string' &&
    Object.keys(value as object).length === 2
  ) {
    return `${decimalOf(String(money.amountMinor), money.currency)} ${money.currency}`;
  }
  return json;
}
