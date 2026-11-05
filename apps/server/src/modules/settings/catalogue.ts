import { z } from 'zod';

// The five admin roles of AP §6.1, the codes of identity.admin_roles
// (identity's admin-team.test.ts keeps the two equal).
export const adminRoles = ['OWN', 'OPS', 'SUP', 'FIN', 'DATA'] as const;
export type AdminRole = (typeof adminRoles)[number];

// AP §4.4 names eight types. Appendix A also holds distances, a speed and a
// time of day, which none of the eight describes, so they are types too.
export type SettingType =
  | 'duration'
  | 'percentage'
  | 'money'
  | 'count'
  | 'enum'
  | 'boolean'
  | 'text'
  | 'schedule'
  | 'distance'
  | 'speed'
  | 'time_of_day';

export type SettingUnit =
  'sec' | 'min' | 'hours' | 'days' | 'months' | 'years' | 'km' | 'm' | 'km/h';

export interface SettingDefinition<Value = unknown> {
  type: SettingType;
  unit?: SettingUnit;
  // G or C in Appendix A.
  scope: 'global' | 'city';
  editRoles: readonly AdminRole[];
  // Parses a value an editor sets.
  schema: z.ZodType<Value>;
  // Null with beforeLaunch: the owner enters the value before going live.
  default: Value | null;
  beforeLaunch?: true;
  // Owner decision 2026-11-05: settings with money impact need a reason
  // (AP §9.14).
  reasonRequired?: true;
}

// The parameters of the keys written with <...> in Appendix A.
export const vehicles = ['walking', 'bicycle', 'motorbike', 'car'] as const;
export const apps = ['customer', 'merchant', 'captain'] as const;
export const keyParameters = {
  vehicle: z.enum(vehicles),
  app: z.enum(apps),
  // A currency code; currencies are data (domain §6).
  code: z.string().regex(/^[A-Z]{3}$/),
} as const;

const weekdays = [
  'saturday',
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
] as const;

const time = z.string().regex(/^([01]\d|2[0-3]):[0-5]\d$/, 'expected HH:MM');
const nonNegativeInt = z.int().min(0);
const positiveInt = z.int().min(1);
const percentage = z.number().min(0).max(100);
const currencyCode = keyParameters.code;
// Integer minor units with the currency code (CLAUDE.md, money). Zero is the
// same in every currency, so a zero default needs none.
const money = z
  .object({
    amountMinor: z.int().min(0).max(Number.MAX_SAFE_INTEGER),
    currency: currencyCode.nullable(),
  })
  .refine((value) => value.currency !== null || value.amountMinor === 0, {
    message: 'a non-zero amount needs its currency',
  });
const text = z.string().trim().min(1).max(500);
const version = z.string().regex(/^\d+\.\d+\.\d+$/, 'expected a version such as 1.4.0');
// A weekly schedule: the open intervals of each weekday, in order and apart,
// each closing after it opens; close 24:00 is the end of the day. Hours past
// midnight belong to the next day. HH:MM strings compare in time order.
const schedule = z.record(
  z.enum(weekdays),
  z
    .array(z.object({ open: time, close: z.union([time, z.literal('24:00')]) }))
    .refine(
      (intervals) =>
        intervals.every(
          (interval, i) =>
            interval.open < interval.close && (i === 0 || intervals[i - 1]!.close <= interval.open),
        ),
      { message: 'intervals must close after they open, in order, without overlapping' },
    ),
);
const allDay = Object.fromEntries(
  weekdays.map((day) => [day, [{ open: '00:00', close: '24:00' }]]),
) as z.output<typeof schedule>;

function define<Value>(
  definition: Omit<SettingDefinition<Value>, 'editRoles' | 'beforeLaunch'> & {
    editRoles?: readonly AdminRole[];
  },
): SettingDefinition<Value> {
  return { editRoles: ['OWN'], ...definition };
}

// A setting without a default, entered by the owner before going live.
function beforeLaunch<Value>(
  definition: Omit<Parameters<typeof define<Value>>[0], 'default'>,
): SettingDefinition<Value> & { beforeLaunch: true } {
  return { ...define({ ...definition, default: null }), beforeLaunch: true };
}

function minutes(value: number, min = 0) {
  return define({
    type: 'duration',
    unit: 'min',
    scope: 'city',
    schema: z.int().min(min),
    default: value,
  });
}

function count(value: number, scope: 'global' | 'city' = 'city') {
  return define({ type: 'count', scope, schema: positiveInt, default: value });
}

function percent(value: number) {
  return define({ type: 'percentage', scope: 'city', schema: percentage, default: value });
}

// Every key of AP Appendix A, in its order. Keys with <vehicle>, <app> or
// <code> stand for one setting per value of that parameter.
export const catalogue = {
  'platform.hours': define({ type: 'schedule', scope: 'city', schema: schedule, default: allDay }),
  'platform.emergency_default_message_browse': define({
    type: 'text',
    scope: 'city',
    schema: text,
    default: 'نعتذر، توقفنا مؤقتاً عن استقبال الطلبات. نعود قريباً.',
  }),
  'platform.emergency_default_message_active': define({
    type: 'text',
    scope: 'city',
    schema: text,
    default: 'قد يتأخر طلبك قليلاً بسبب {السبب}. نعتذر عن الانتظار.',
  }),
  'order.merchant_accept_alert_min': minutes(3, 1),
  'order.merchant_auto_cancel_min': minutes(7, 1),
  'order.prep_late_ops_alert_min': minutes(10),
  'order.delivery_late_alert_min': minutes(20),
  'order.delivery_late_compensation_min': minutes(45),
  // An amount or a percentage of the order (AP Appendix A).
  'order.late_compensation_value': beforeLaunch({
    type: 'money',
    scope: 'city',
    schema: z.discriminatedUnion('kind', [
      z.object({ kind: z.literal('amount'), amountMinor: positiveInt, currency: currencyCode }),
      z.object({ kind: z.literal('percent'), percent: percentage }),
    ]),
    reasonRequired: true,
  }),
  'order.outcome_change_days': define({
    type: 'duration',
    unit: 'days',
    scope: 'city',
    schema: nonNegativeInt,
    default: 7,
  }),
  'order.pickup_confirm_timeout_sec': define({
    type: 'duration',
    unit: 'sec',
    scope: 'city',
    schema: positiveInt,
    default: 60,
  }),
  'order.pickup_dispute_window_min': minutes(10),
  'order.eta_buffer_min': minutes(10),
  'order.eta_speed_kmh': define({
    type: 'speed',
    unit: 'km/h',
    scope: 'city',
    schema: z.number().positive(),
    default: 20,
  }),
  'merchant.auto_pause_unanswered_count': count(3),
  'merchant.settlement_weekday': define({
    type: 'enum',
    scope: 'city',
    schema: z.enum(weekdays),
    default: 'saturday',
  }),
  'merchant.settlement_overdue_days': define({
    type: 'duration',
    unit: 'days',
    scope: 'city',
    schema: nonNegativeInt,
    default: 2,
  }),
  'merchant.default_commission_pct': { ...percent(15), reasonRequired: true },
  'merchant.default_prep_min': minutes(20, 1),
  'merchant.default_min_order': beforeLaunch({
    type: 'money',
    scope: 'city',
    schema: money,
    reasonRequired: true,
  }),
  'merchant.prep_time_options': define({
    type: 'duration',
    unit: 'min',
    scope: 'city',
    schema: z.array(positiveInt).min(1),
    default: [10, 15, 20, 30, 45],
  }),
  'merchant.prep_time_step_min': minutes(5, 1),
  'merchant.prep_time_floor_min': minutes(5, 1),
  'merchant.prep_time_ceiling_min': minutes(90, 1),
  'merchant.busy_extra_options_min': define({
    type: 'duration',
    unit: 'min',
    scope: 'city',
    schema: z.array(positiveInt).min(1),
    default: [10, 20],
  }),
  'merchant.busy_mode_reminder_min': minutes(60, 1),
  'merchant.no_device_alert_min': minutes(5),
  'merchant.price_change_alert_pct': percent(30),
  'merchant.web_session_days': define({
    type: 'duration',
    unit: 'days',
    scope: 'global',
    schema: positiveInt,
    default: 30,
  }),
  'dispatch.mode': define({
    type: 'enum',
    scope: 'city',
    editRoles: ['OWN', 'OPS'],
    schema: z.enum(['manual', 'auto', 'mixed']),
    default: 'manual',
  }),
  'dispatch.offer_timeout_sec': define({
    type: 'duration',
    unit: 'sec',
    scope: 'city',
    schema: positiveInt,
    default: 45,
  }),
  'dispatch.search_radius_km': define({
    type: 'distance',
    unit: 'km',
    scope: 'city',
    schema: z.number().positive(),
    default: 3,
  }),
  'dispatch.ranking': define({
    type: 'enum',
    scope: 'city',
    schema: z.enum(['nearest_then_fewest_today']),
    default: 'nearest_then_fewest_today',
  }),
  'dispatch.max_offers_before_manual': count(5),
  'dispatch.no_captain_alert_min': minutes(5),
  'dispatch.no_captain_after_ready_min': minutes(15),
  'dispatch.search_start_buffer_min': minutes(5),
  'dispatch.manual_assign_requires_accept': define({
    type: 'boolean',
    scope: 'city',
    schema: z.boolean(),
    default: true,
  }),
  'dispatch.capacity_check': define({
    type: 'boolean',
    scope: 'city',
    schema: z.boolean(),
    default: true,
  }),
  'dispatch.max_distance_km.walking': define({
    type: 'distance',
    unit: 'km',
    scope: 'city',
    schema: z.number().positive(),
    default: 1.5,
  }),
  'dispatch.max_distance_km.bicycle': define({
    type: 'distance',
    unit: 'km',
    scope: 'city',
    schema: z.number().positive(),
    default: 4,
  }),
  'dispatch.max_distance_km.motorbike': define({
    type: 'distance',
    unit: 'km',
    scope: 'city',
    schema: z.number().positive(),
    default: 10,
  }),
  'dispatch.max_distance_km.car': define({
    type: 'distance',
    unit: 'km',
    scope: 'city',
    schema: z.number().positive(),
    default: 15,
  }),
  'pricing.distance_method': define({
    type: 'enum',
    scope: 'global',
    schema: z.enum(['road', 'straight_line']),
    default: 'road',
  }),
  'captain.waiting_threshold_min': minutes(10),
  'captain.custody_warn_pct': percent(80),
  'captain.custody_limit_suggested.<vehicle>': beforeLaunch({
    type: 'money',
    scope: 'city',
    schema: money,
    reasonRequired: true,
  }),
  // In the city's base currency (domain §5).
  'captain.remit_tolerance': define({
    type: 'money',
    scope: 'city',
    schema: money,
    default: { amountMinor: 0, currency: null },
    reasonRequired: true,
  }),
  'captain.remit_online_grace_hours': define({
    type: 'duration',
    unit: 'hours',
    scope: 'city',
    schema: nonNegativeInt,
    default: 4,
  }),
  'captain.payout_weekday': define({
    type: 'enum',
    scope: 'city',
    schema: z.enum(weekdays),
    default: 'thursday',
  }),
  'captain.negative_earnings_policy': define({
    type: 'enum',
    scope: 'city',
    schema: z.enum(['carry_forward', 'collect_at_desk']),
    default: 'carry_forward',
    reasonRequired: true,
  }),
  'captain.acceptance_window_offers': count(50),
  'captain.acceptance_alert_pct': percent(70),
  'captain.acceptance_review_pct': percent(50),
  'captain.probation_days': define({
    type: 'duration',
    unit: 'days',
    scope: 'city',
    schema: nonNegativeInt,
    default: 30,
  }),
  'captain.min_commitment_months': define({
    type: 'duration',
    unit: 'months',
    scope: 'city',
    schema: nonNegativeInt,
    default: 3,
  }),
  'captain.probation_review_notice_days': define({
    type: 'duration',
    unit: 'days',
    scope: 'city',
    schema: nonNegativeInt,
    default: 3,
  }),
  'captain.document_expiry_notice_days': define({
    type: 'duration',
    unit: 'days',
    scope: 'city',
    schema: nonNegativeInt,
    default: 30,
  }),
  'captain.violation_window_days': define({
    type: 'duration',
    unit: 'days',
    scope: 'city',
    schema: positiveInt,
    default: 90,
  }),
  'captain.min_age': define({
    type: 'duration',
    unit: 'years',
    scope: 'global',
    schema: positiveInt,
    default: 18,
  }),
  'captain.gps_stale_alert_min': minutes(2, 1),
  'captain.offer_expiry_offline_count': count(3),
  'captain.merchant_arrival_radius_m': define({
    type: 'distance',
    unit: 'm',
    scope: 'city',
    schema: positiveInt,
    default: 150,
  }),
  'captain.customer_radius_m': define({
    type: 'distance',
    unit: 'm',
    scope: 'city',
    schema: positiveInt,
    default: 200,
  }),
  'captain.criminal_record_validity_months': define({
    type: 'duration',
    unit: 'months',
    scope: 'city',
    schema: positiveInt,
    default: 12,
  }),
  'customer.no_answer_pings': count(3),
  'customer.no_answer_ping_interval_min': minutes(5, 1),
  'customer.new_max_active_orders': count(1),
  'customer.trusted_after_delivered_orders': count(3),
  'customer.trusted_max_active_orders': count(3),
  'customer.late_cancel_strikes': count(2),
  'customer.late_cancel_window_days': define({
    type: 'duration',
    unit: 'days',
    scope: 'city',
    schema: positiveInt,
    default: 30,
  }),
  'customer.fake_order_dues_rule': define({
    type: 'enum',
    scope: 'city',
    schema: z.enum(['fee_plus_merchant_net', 'fee_plus_items_value', 'fixed']),
    default: 'fee_plus_merchant_net',
    reasonRequired: true,
  }),
  // Used when the rule is fixed; empty until the owner sets it.
  'customer.fake_order_dues_fixed': define({
    type: 'money',
    scope: 'city',
    schema: money.nullable(),
    default: null,
    reasonRequired: true,
  }),
  'customer.phone_default_country': beforeLaunch({
    type: 'enum',
    scope: 'city',
    schema: z.enum(['SY', 'TR']),
  }),
  'customer.far_pin_warn_m': define({
    type: 'distance',
    unit: 'm',
    scope: 'city',
    schema: positiveInt,
    default: 1000,
  }),
  'customer.rating_window_days': define({
    type: 'duration',
    unit: 'days',
    scope: 'city',
    schema: positiveInt,
    default: 3,
  }),
  'customer.report_problem_window_hours': define({
    type: 'duration',
    unit: 'hours',
    scope: 'city',
    schema: positiveInt,
    default: 24,
  }),
  'otp.validity_min': define({
    type: 'duration',
    unit: 'min',
    scope: 'global',
    schema: positiveInt,
    default: 5,
  }),
  'otp.max_attempts': count(5, 'global'),
  'otp.resend_after_sec': define({
    type: 'duration',
    unit: 'sec',
    scope: 'global',
    schema: positiveInt,
    default: 60,
  }),
  // WhatsApp is the only channel in V1; sms and voice join later (T5).
  'otp.channel_order': define({
    type: 'enum',
    scope: 'global',
    schema: z.array(z.enum(['whatsapp'])).min(1),
    default: ['whatsapp'],
  }),
  'otp.number_hourly_max': count(3, 'global'),
  'otp.number_daily_max': count(6, 'global'),
  'otp.device_daily_max': count(6, 'global'),
  'otp.ip_hourly_max': count(30, 'global'),
  'otp.sender_per_minute_max': count(12, 'global'),
  'otp.sender_daily_max': count(1500, 'global'),
  // A random delay between min and max seconds.
  'otp.send_jitter_sec': define({
    type: 'duration',
    unit: 'sec',
    scope: 'global',
    schema: z
      .object({ min: nonNegativeInt, max: nonNegativeInt })
      .refine((range) => range.min <= range.max, { message: 'min is above max' }),
    default: { min: 1, max: 4 },
  }),
  // One daily cap per warm-up step; full lifts the cap.
  'otp.sender_warmup_caps': define({
    type: 'count',
    scope: 'global',
    schema: z.array(z.union([positiveInt, z.literal('full')])).min(1),
    default: [50, 100, 200, 400, 800, 'full'],
  }),
  'support.first_response_active_min': minutes(15, 1),
  'support.resolution_post_delivery_hours': define({
    type: 'duration',
    unit: 'hours',
    scope: 'city',
    schema: positiveInt,
    default: 24,
  }),
  'support.compensation_cap_pct.SUP': { ...percent(30), reasonRequired: true },
  'support.compensation_cap_pct.OPS': { ...percent(30), reasonRequired: true },
  'finance.business_day_cutoff': define({
    type: 'time_of_day',
    scope: 'city',
    schema: time,
    default: '06:00',
  }),
  'fx.stale_alert_hours': define({
    type: 'duration',
    unit: 'hours',
    scope: 'city',
    schema: positiveInt,
    default: 24,
  }),
  'fx.large_change_confirm_pct': percent(10),
  // In minor units of the key's currency, such as 50 for 0.5 USD.
  'currency.<code>.rounding_unit': beforeLaunch({
    type: 'money',
    scope: 'city',
    editRoles: ['OWN', 'FIN'],
    schema: z.object({ amountMinor: positiveInt }),
    reasonRequired: true,
  }),
  'currency.<code>.rounding_mode': define({
    type: 'enum',
    scope: 'city',
    editRoles: ['OWN', 'FIN'],
    schema: z.enum(['nearest', 'up', 'down']),
    default: 'nearest',
    reasonRequired: true,
  }),
  // Null is no limit (D20).
  'push.daily_limit': define({
    type: 'count',
    scope: 'city',
    schema: positiveInt.nullable(),
    default: null,
  }),
  'admin.password_min_length': count(10, 'global'),
  'admin.login_max_attempts': count(5, 'global'),
  'admin.lockout_min': define({
    type: 'duration',
    unit: 'min',
    scope: 'global',
    schema: positiveInt,
    default: 15,
  }),
  'admin.session_idle_min': define({
    type: 'duration',
    unit: 'min',
    scope: 'global',
    schema: positiveInt,
    default: 30,
  }),
  'admin.session_max_hours': define({
    type: 'duration',
    unit: 'hours',
    scope: 'global',
    schema: positiveInt,
    default: 12,
  }),
  'app.<app>.min_version': define({
    type: 'text',
    scope: 'global',
    schema: version.nullable(),
    default: null,
  }),
  'app.<app>.latest_version': define({
    type: 'text',
    scope: 'global',
    schema: version.nullable(),
    default: null,
  }),
  'app.<app>.update_message': define({
    type: 'text',
    scope: 'global',
    schema: text.nullable(),
    default: null,
  }),
  'app.<app>.maintenance': define({
    type: 'boolean',
    scope: 'global',
    schema: z.object({ enabled: z.boolean(), message: text.nullable() }),
    default: { enabled: false, message: null },
  }),
} as const satisfies Record<string, SettingDefinition>;

export type SettingKey = keyof typeof catalogue;

// The value a key reads: its type, or null for a value still to be entered
// before launch.
export type SettingValue<Key extends SettingKey> =
  (typeof catalogue)[Key] extends SettingDefinition<infer Value>
    ? Value | ((typeof catalogue)[Key] extends { beforeLaunch: true } ? null : never)
    : never;

// The parameter of a key written with <...>, such as vehicle for
// captain.custody_limit_suggested.<vehicle>.
export function keyParameter(key: SettingKey): keyof typeof keyParameters | null {
  const match = /<(\w+)>/.exec(key);
  return match ? (match[1] as keyof typeof keyParameters) : null;
}

// The group screens of AP §9.14, in their order. Owner decision 2026-11-05:
// each key's group follows its prefix, as settingGroupOf maps it.
export const settingGroups = [
  'timers_limits',
  'dispatch',
  'customers',
  'captains',
  'restaurants',
  'support',
  'finance',
  'security',
  'apps',
] as const;
export type SettingGroup = (typeof settingGroups)[number];

const groupByPrefix: Record<string, SettingGroup> = {
  platform: 'timers_limits',
  order: 'timers_limits',
  dispatch: 'dispatch',
  pricing: 'dispatch',
  customer: 'customers',
  push: 'customers',
  captain: 'captains',
  merchant: 'restaurants',
  support: 'support',
  finance: 'finance',
  fx: 'finance',
  currency: 'finance',
  admin: 'security',
  otp: 'security',
  app: 'apps',
};

export function settingGroupOf(key: SettingKey): SettingGroup {
  const group = groupByPrefix[key.slice(0, key.indexOf('.'))];
  if (!group) throw new Error(`${key} has no settings group`);
  return group;
}
