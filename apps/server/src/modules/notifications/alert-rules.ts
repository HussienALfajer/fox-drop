// AP §9.1.3: the alert rules built so far, each with its severity and its
// recipient roles (AP §7.3: only a signed-in user holding one sees the alert,
// hears it and can acknowledge it). Each later alert joins with its slice.
export const alertSeverities = ['critical', 'warning', 'information'] as const;
export type AlertSeverity = (typeof alertSeverities)[number];

// What an alert is about: an order, a captain, the WhatsApp code senders
// (the pool as a whole, or one number), a restaurant, or one currency of a
// city (`<cityId>:<code>`), a compensation request (slice 2.22a), or a
// ticket (slice 2.23a).
export const alertSubjects = [
  'order',
  'captain',
  'otp_pool',
  'otp_number',
  'restaurant',
  'currency',
  'compensation',
  'ticket',
] as const;
export type AlertSubject = (typeof alertSubjects)[number];

export const alertCodes = [
  // «مطعم لم يقبل»: placed past order.merchant_accept_alert_min.
  'restaurant_not_accepted',
  // «طلب بلا كابتن»: dispatch.no_captain_alert_min after the search started.
  'no_captain',
  // «جاهز بلا كابتن»: dispatch.no_captain_after_ready_min after ready.
  'no_captain_after_ready',
  // «انقطع اتصال كابتن أثناء طلب»: no GPS for captain.gps_stale_alert_min.
  'captain_gps_lost',
  // «خلاف على مبلغ الاستلام»: the restaurant disputed a pickup request.
  'pickup_disputed',
  // «تحضير متأخر»: order.prep_late_ops_alert_min past the prep time.
  'prep_late',
  // «كابتن ينتظر عند المطعم»: captain.waiting_threshold_min at the restaurant.
  'captain_waiting',
  // «توصيل متأخر»: order.delivery_late_alert_min past the promised time.
  'delivery_late',
  // «نقص في التحصيل»: collected less than due beyond rounding (AP §8.6).
  'collection_shortfall',
  // «كابتن بلغ حد العهدة»: 100% of the cash limit.
  'captain_cash_limit',
  // «لا يمكن إرسال رموز الدخول»: no WhatsApp sending number can send.
  'codes_cannot_send',
  // «رقم إرسال الرموز متوقف»: a sending number disconnected, throttled or
  // banned.
  'code_number_stopped',
  // «تسليم بعيد عن العنوان»: arrival or delivery beyond
  // captain.customer_radius_m of the pin, with a reason.
  'away_from_address',
  // «صنف نفد بعد القبول»: the restaurant's open item-unavailable report (RA
  // §8.12), until it is withdrawn, closed or the order cancelled.
  'item_unavailable',
  // «المطعم لم يؤكد التعديل»: an edit that added items, not acknowledged by
  // the restaurant within order.merchant_accept_alert_min (AP §9.3.3, RA
  // §8.13), until it is acknowledged, the order is picked up or ends.
  'edit_unacknowledged',
  // «كابتن لا يستطيع إكمال الطلب»: the captain's open «لا أستطيع إكمال
  // الطلب» (CA §9.11, slice 2.13b), until they withdraw it, operations
  // reassign or hand over the order, or it ends.
  'captain_cannot_complete',
  // «طوارئ كابتن»: the captain's open «طوارئ» (CA §9.11, slice 2.13c), with
  // the location sent, until the order leaves them or ends (no withdrawal,
  // owner decision 2026-11-11).
  'captain_emergency',
  // «زبون لا يرد»: the captain's «الزبون لا يستجيب» after every ping (CA
  // §9.9, slice 2.13d), until operations answer «انتظر» or the order leaves
  // the door.
  'customer_not_answering',
  // «مطعم أوقف تلقائياً»: merchant.auto_pause_unanswered_count unanswered
  // orders in a business day (AP §9.6.5), until operations resume it.
  'restaurant_auto_paused',
  // «مطعم متأخر في التسوية»: a statement not fully paid
  // merchant.settlement_overdue_days after the settlement day (AP §8.7,
  // slice 2.19f), until it is paid.
  'restaurant_settlement_overdue',
  // «سعر صرف قديم»: an enabled currency's current rate older than
  // fx.stale_alert_hours (AP §8.6, slice 2.20a), until a new rate is set or
  // the currency is disabled.
  'rate_stale',
  // «طلب موافقة تعويض»: SUP or OPS asked for a compensation above their cap
  // (AP §6.4, slice 2.22a), until OWN approves or rejects it.
  'compensation_approval',
  // «تذكرة عاجلة»: an open ticket on an active order (AP §9.9.2, slice
  // 2.23a), until the ticket is resolved or its order ends (owner decision
  // 2026-11-17).
  'urgent_ticket',
  // «تذكرة عاجلة» on a pickup-dispute ticket (AP §9.1.3, §9.9.2; slice
  // 2.23b): for FIN too, who resolves it, until it is resolved or closed.
  'urgent_dispute_ticket',
] as const;
export type AlertCode = (typeof alertCodes)[number];

export type AlertRole = 'OWN' | 'OPS' | 'FIN' | 'SUP';

export interface AlertRule {
  severity: AlertSeverity;
  recipients: readonly AlertRole[];
  subject: AlertSubject;
  // AP §7.3: an alert closes itself when its condition clears. A rule whose
  // condition never clears (an information that something happened) closes
  // with its acknowledgment instead, and is raised once per subject.
  resolvesItself: boolean;
}

const OPERATIONS = ['OWN', 'OPS'] as const;
const WITH_FINANCE = ['OWN', 'OPS', 'FIN'] as const;

export const ALERT_RULES: Record<AlertCode, AlertRule> = {
  restaurant_not_accepted: rule('critical', OPERATIONS, 'order'),
  no_captain: rule('critical', OPERATIONS, 'order'),
  no_captain_after_ready: rule('critical', OPERATIONS, 'order'),
  captain_gps_lost: rule('critical', OPERATIONS, 'order'),
  pickup_disputed: rule('critical', OPERATIONS, 'order'),
  prep_late: rule('warning', OPERATIONS, 'order'),
  captain_waiting: rule('warning', OPERATIONS, 'order'),
  delivery_late: rule('warning', OPERATIONS, 'order'),
  collection_shortfall: rule('warning', WITH_FINANCE, 'order'),
  captain_cash_limit: rule('warning', WITH_FINANCE, 'captain'),
  codes_cannot_send: rule('critical', OPERATIONS, 'otp_pool'),
  code_number_stopped: rule('warning', ['OWN'], 'otp_number'),
  away_from_address: { ...rule('information', OPERATIONS, 'order'), resolvesItself: false },
  item_unavailable: rule('critical', OPERATIONS, 'order'),
  edit_unacknowledged: rule('critical', OPERATIONS, 'order'),
  captain_cannot_complete: rule('critical', OPERATIONS, 'order'),
  captain_emergency: rule('critical', OPERATIONS, 'order'),
  customer_not_answering: rule('warning', OPERATIONS, 'order'),
  restaurant_auto_paused: rule('warning', OPERATIONS, 'restaurant'),
  restaurant_settlement_overdue: rule('warning', ['OWN', 'FIN'], 'restaurant'),
  rate_stale: rule('information', ['OWN', 'FIN'], 'currency'),
  compensation_approval: rule('information', ['OWN'], 'compensation'),
  urgent_ticket: rule('critical', ['OWN', 'OPS', 'SUP'], 'ticket'),
  urgent_dispute_ticket: rule('critical', ['OWN', 'OPS', 'SUP', 'FIN'], 'ticket'),
};

function rule(
  severity: AlertSeverity,
  recipients: readonly AlertRole[],
  subject: AlertSubject,
): AlertRule {
  return { severity, recipients, subject, resolvesItself: true };
}

// Whether the roles receive any alert (AP §7.3): OWN, OPS, FIN and SUP so far.
export function receivesAlerts(roles: readonly string[]): boolean {
  return receivedCodes(roles).length > 0;
}

// The rules a session's roles receive.
export function receivedCodes(roles: readonly string[]): AlertCode[] {
  return alertCodes.filter((code) =>
    ALERT_RULES[code].recipients.some((role) => roles.includes(role)),
  );
}

const SEVERITY_ORDER: Record<AlertSeverity, number> = { critical: 0, warning: 1, information: 2 };

// AP §9.1.3: by severity, then by age, oldest first.
export function bySeverityThenAge(
  a: { severity: AlertSeverity; raisedAt: Date },
  b: { severity: AlertSeverity; raisedAt: Date },
): number {
  return (
    SEVERITY_ORDER[a.severity] - SEVERITY_ORDER[b.severity] ||
    a.raisedAt.getTime() - b.raisedAt.getTime()
  );
}
