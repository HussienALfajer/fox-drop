// AP §9.13 «نصوص الإشعارات»: the text of every push of CU §14, RA §16 and
// CA §14 that has one, per audience, with the variables it takes. The texts
// here are the specs' defaults; an admin's edit is stored in content.texts
// under `notification.<key>` and replaces it. The level is the sound the app
// plays (RA §4.4, CA §4.4; architecture §8.2), which is the Android channel
// the app created for it; the priority wakes the phone (architecture §8.1:
// new orders, pickup requests, offers, cancellations and arrival are high).
// Neither is editable. A push whose event is not built yet keeps its
// template here for the panel; its slice sends it.

export const notificationAudiences = ['customer', 'merchant', 'captain'] as const;
export type NotificationAudience = (typeof notificationAudiences)[number];

export const notificationLevels = [
  'default',
  'ring',
  'chime',
  'offer',
  'cancellation',
  'silent',
] as const;
export type NotificationLevel = (typeof notificationLevels)[number];

export type NotificationPriority = 'high' | 'normal';

export interface NotificationTemplate {
  key: string;
  audience: NotificationAudience;
  // The spec row it comes from, such as «CU §14 #1».
  row: string;
  text: string;
  variables: string[];
  level: NotificationLevel;
  priority: NotificationPriority;
}

type Entry = [key: string, row: string, text: string, level: NotificationLevel, high?: boolean];

const customer: Entry[] = [
  ['accepted', '1', 'المطعم يحضّر طلبك. يصل حوالي {الساعة}', 'default'],
  ['captain_assigned', '2', 'الكابتن {الاسم} في طريقه إلى المطعم', 'default'],
  ['picked_up', '3', 'طلبك في الطريق إليك مع {الاسم}', 'default'],
  ['captain_arrived', '4', 'الكابتن عند الباب. جهّز {المبلغ}', 'default', true],
  // CU §11.7, Q5: an order for someone else.
  [
    'captain_arrived_recipient',
    '4',
    'الكابتن عند باب {المستلم}. المبلغ المطلوب {المبلغ}',
    'default',
    true,
  ],
  ['door_ping', '5', 'الكابتن عند الباب ويحاول الوصول إليك', 'ring', true],
  ['door_ping_recipient', '5', 'الكابتن عند الباب ويحاول الوصول إلى {المستلم}', 'ring', true],
  ['delivered', '6', 'تم التسليم. قيّم طلبك', 'default'],
  ['rejected', '7', 'نعتذر، لم يقبل {المطعم} طلبك: {السبب}', 'default', true],
  // AP §8.3: the apology of the automatic cancellation is this row, with the
  // customer text of its reason.
  ['cancelled', '8', 'أُلغي طلبك: {السبب}', 'default', true],
  ['failed', '9', 'تعذّر تسليم طلبك: {السبب}', 'default'],
  // AP §8.9 «تغيير النتيجة» (slice 2.11c): the texts ours, beside CU §14 #9
  // (to confirm with the owner).
  ['outcome_changed', '9', 'راجعنا طلبك #{رقم} وتغيّرت نتيجته: {السبب}', 'default'],
  ['outcome_changed_delivered', '9', 'راجعنا طلبك #{رقم}: تم التسليم', 'default'],
  ['outcome_dues_cancelled', '9', 'راجعنا طلبك #{رقم}: لم يعد عليك شيء لـ FOX DROP عنه', 'default'],
  ['item_unavailable', '10', 'صنف في طلبك غير متوفر. سيتصل بك فريق FOX DROP الآن', 'default'],
  ['order_edited', '11', 'عدّلت FOX DROP طلبك. المجموع الجديد: {المبلغ}', 'default'],
  ['time_changed', '12', 'تغيّر موعد وصول طلبك إلى {الساعة}', 'default'],
  ['captain_changed', '13', 'تغيّر الكابتن: {الاسم} يكمل طلبك', 'default'],
  ['late_apology', '14', 'نعتذر، طلبك متأخر قليلاً. نتابعه الآن', 'default'],
  ['late_code', '15', 'تأخر طلبك، وهذا كود خصم لطلبك القادم: {الكود}', 'default'],
  ['compensation_code', '16', 'لك كود تعويض {القيمة}: {الكود}', 'default'],
  ['ticket_resolved', '17', 'تم الرد على بلاغك T-{رقم}', 'default'],
  ['dues_paid', '21', 'تم استلام {المبلغ}. حسابك فعّال من جديد', 'default'],
];

const merchant: Entry[] = [
  ['new_order', '1', 'طلب جديد #{رقم}', 'ring', true],
  ['auto_cancelled', '2', 'أُلغي الطلب #{رقم} لعدم الرد ({العدد} من {الحد} اليوم)', 'chime', true],
  [
    'auto_paused',
    '3',
    'أُوقف مطعمك تلقائياً بعد {العدد} طلبات دون رد. تواصل مع العمليات لإعادة التشغيل.',
    'chime',
  ],
  ['customer_cancelled', '4', 'ألغى الزبون الطلب #{رقم}', 'chime', true],
  [
    'accepted_by_operations',
    '5',
    'قبلت العمليات الطلب #{رقم} نيابة عنكم — وقت التحضير {د} د',
    'chime',
  ],
  ['rejected_by_operations', '6', 'رفضت العمليات الطلب #{رقم}: {السبب}', 'chime', true],
  ['captain_changed', '8', 'تغيّر كابتن الطلب #{رقم}: {الاسم}', 'chime'],
  ['captain_arrived', '9', 'وصل الكابتن {الاسم} لاستلام الطلب #{رقم}', 'chime'],
  ['captain_waiting', '10', 'الكابتن ينتظر الطلب #{رقم} منذ {د} دقائق', 'chime'],
  ['prep_late', '11', 'تحضير متأخر #{رقم} — اضغط «الطلب جاهز» فور الانتهاء', 'chime'],
  ['prep_time_changed', '12', 'عدّلت العمليات وقت تحضير #{رقم} إلى {د} د', 'chime'],
  [
    'pickup_requested',
    '13',
    'الكابتن {الاسم} يؤكد أنه دفع لك {المبلغ} واستلم الطلب #{رقم}',
    'ring',
    true,
  ],
  ['picked_up', '14', 'تم استلام الطلب #{رقم}', 'silent'],
  ['pickup_confirmed_by_operations', '15', 'أكّدت العمليات استلام الكابتن للطلب #{رقم}', 'chime'],
  ['edited_items_added', '16', 'تم تعديل الطلب #{رقم} — أُضيفت أصناف', 'ring'],
  ['edited', '17', 'تم تعديل الطلب #{رقم}', 'chime'],
  // RA §8.13, §12.5 give no text: the owners' silent push of an edit after
  // the pickup with the restaurant responsible (slice 2.10b, to confirm with
  // the owner); filed under the money-effect row.
  [
    'debited_after_pickup',
    '19',
    'عُدّل الطلب #{رقم} بعد الاستلام — يُقيَّد عليكم {المبلغ} في كشف السبت',
    'silent',
  ],
  // RA §16 #19 (slice 2.11a): a failed order, or an outcome the restaurant
  // is responsible for, with the money effect (the debit's wording ours, as
  // the edit's above; to confirm with the owner).
  ['order_failed', '19', 'لم يُسلَّم الطلب #{رقم}: {النتيجة}', 'silent'],
  [
    'order_failed_debited',
    '19',
    'لم يُسلَّم الطلب #{رقم}: {النتيجة} — يُقيَّد عليكم {المبلغ} في كشف السبت',
    'silent',
  ],
  [
    'outcome_debited',
    '19',
    'انتهى الطلب #{رقم}: {النتيجة} — يُقيَّد عليكم {المبلغ} في كشف السبت',
    'silent',
  ],
  // AP §8.9 «تغيير النتيجة» (slice 2.11c): what the restaurant now owes for
  // the order changed (the texts ours, to confirm with the owner).
  ['outcome_changed', '19', 'تغيّرت نتيجة الطلب #{رقم}: {النتيجة} — أُلغي القيد عليكم', 'silent'],
  [
    'outcome_changed_debited',
    '19',
    'تغيّرت نتيجة الطلب #{رقم}: {النتيجة} — يُقيَّد عليكم {المبلغ} في كشف السبت',
    'silent',
  ],
  ['cancelled_after_acceptance', '18', 'أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}', 'ring', true],
  ['admin_price_change', '21', 'عدّلت FOX DROP سعر {الصنف}: {القديم} ← {الجديد}', 'chime'],
  ['menu_change_approved', '22', 'قُبل تعديلك على {الصنف}', 'silent'],
  ['menu_change_rejected', '22', 'رُفض تعديلك على {الصنف}: {السبب}', 'silent'],
  ['paused_by_operations', '23', 'أوقفت العمليات مطعمك مؤقتاً: {السبب}', 'chime'],
  ['resumed_by_operations', '23', 'أعادت العمليات تشغيل مطعمك', 'chime'],
  ['busy_ended_by_operations', '23', 'أنهت العمليات وضع الضغط', 'chime'],
  ['pause_ended', '24', 'انتهى الإيقاف المؤقت — مطعمك يستقبل الطلبات', 'chime'],
  ['busy_reminder', '25', 'وضع الضغط ما زال مفعّلاً (+{د} د)', 'chime'],
  ['no_receiving_device', '27', 'لا يوجد جهاز يستقبل الطلبات في مطعمك الآن', 'chime'],
  ['ticket_resolved', '29', 'تم حل بلاغك T-{رقم}: {الرد}', 'silent'],
  ['settlement_receipt', '31', 'إيصال {رقم}: استلمنا منك {المبلغ}', 'silent'],
  ['commission_change', '33', 'تتغيّر عمولتك إلى {النسبة}% اعتباراً من {التاريخ}', 'silent'],
  ['item_report_closed', '37', 'أغلقت العمليات بلاغ الصنف في الطلب #{رقم}: {السبب}', 'chime'],
];

const captain: Entry[] = [
  ['new_offer', '1', 'عرض جديد: {الأجر} — {المطعم}', 'offer', true],
  // AP §10 gives the full text of the row.
  ['auto_offline', '3', 'لم ترد على 3 عروض متتالية، فأصبحت غير متصل', 'chime'],
  ['assigned_by_operations', '4', 'عيّنتك العمليات على طلب #{رقم}', 'chime'],
  ['order_ready', '5', 'الطلب #{رقم} جاهز', 'chime'],
  ['picked_up', '7', 'تم الاستلام — توجّه إلى الزبون', 'chime'],
  // CA §9.4 item 4: the restaurant's two answers to a pickup request.
  [
    'pickup_amount_incorrect',
    '8',
    'المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.',
    'chime',
  ],
  ['pickup_incomplete', '8', 'المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.', 'chime'],
  ['pickup_disputed', '9', 'فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات', 'chime'],
  // CA §9.10 gives the text; the variable names are ours (two amounts).
  [
    'order_edited',
    '10',
    'تم تعديل الطلب #{رقم} — المبلغ الجديد للمطعم {للمطعم}، للتحصيل {للتحصيل}',
    'chime',
  ],
  // CA §9.10: items removed after the pickup; a lower fee alone shows the
  // new amount to collect (the text ours, to confirm with the owner).
  [
    'items_removed_after_pickup',
    '10',
    'حُذفت أصناف من الطلب — المبلغ الجديد للتحصيل {المبلغ}',
    'chime',
  ],
  ['collect_lowered', '10', 'المبلغ الجديد للتحصيل للطلب #{رقم}: {المبلغ}', 'chime'],
  // CA §9.10 «Outcome set by OPS» with nothing to collect: its text without
  // «اقبض {المبلغ}» (slice 2.11a).
  ['outcome_set', '10', 'أنهت العمليات الطلب: {النتيجة}.', 'chime'],
  // CA §9.10 «Outcome set by OPS with an amount to collect» (K9, slice 2.11b).
  ['outcome_collect', '10', 'أنهت العمليات الطلب: {النتيجة}. اقبض {المبلغ}.', 'chime'],
  // AP §8.9 «تغيير النتيجة» (slice 2.11c): the captain's pay or charge moved
  // (the text ours, to confirm with the owner).
  ['outcome_changed', '10', 'غيّرت العمليات نتيجة الطلب #{رقم}: {النتيجة}.', 'chime'],
  // CA §9.10.
  ['withdrawn', '11', 'سُحب منك الطلب: {السبب}', 'cancellation', true],
  ['cancelled', '11', 'أُلغيت المهمة: {السبب}', 'cancellation', true],
  ['handed_over', '11', 'سلّمت الطلب للكابتن {الاسم}', 'cancellation', true],
  ['cancelled_before_acceptance', '12', 'أُلغي الطلب #{رقم}', 'cancellation', true],
  ['customer_coming', '13a', 'الزبون رأى التنبيه وهو قادم', 'chime'],
  ['customer_contacting_recipient', '13a', 'الزبون يتواصل مع المستلم', 'chime'],
  ['charge', '14', 'خُصم من مستحقاتك {المبلغ}: {السبب}', 'silent'],
  ['hand_in_reminder', '16', 'عليك تسليم {المبلغ} اليوم. المكتب مفتوح حتى {الساعة}.', 'chime'],
  ['cutoff_passed', '17', 'سلّم نقد أمس قبل {الساعة} لتستمر العروض', 'chime'],
  ['hand_in_grace', '18', 'مُنحت مهلة حتى {الساعة}', 'silent'],
  ['desk_receipt', '19', 'إيصال {رقم}: {النوع} {المبلغ}', 'silent'],
  ['weekly_statement', '20', 'كشف الأسبوع جاهز: قبضت {المبلغ}', 'silent'],
  ['bonus', '21', 'مكافأة {المبلغ}: {السبب}', 'silent'],
  ['pay_table_change', '22', 'جدول أجور جديد يبدأ في {التاريخ}', 'silent'],
  ['violation', '25', 'سُجّلت عليك مخالفة: {النوع} — {النتيجة}', 'silent'],
  // CA §14 #26 «With the reason» (slice 2.13a): a force offline at once, or
  // during an order (K18); the wording is ours.
  ['forced_offline', '26', 'فصلتك العمليات من الاتصال: {السبب}', 'chime'],
  ['forced_last_order', '26', 'ستصبح غير متصل بعد هذا الطلب: {السبب}', 'chime'],
  ['document_expiring', '27', 'تنتهي صلاحية {المستند} في {التاريخ}', 'silent'],
  ['document_rejected', '27', 'رُفض {المستند}: {السبب}', 'silent'],
  ['contract_phase', '28', 'بدأت {المرحلة} من {التاريخ}', 'silent'],
  ['ticket_resolved', '30', 'تم الرد على بلاغك T-{رقم}', 'silent'],
];

const SPEC: Record<NotificationAudience, string> = {
  customer: 'CU §14',
  merchant: 'RA §16',
  captain: 'CA §14',
};

const VARIABLE = /\{([^{}]+)\}/g;

// The variables a text uses, in order, each once.
export function variablesOf(text: string): string[] {
  return [...new Set([...text.matchAll(VARIABLE)].map((match) => match[1]!))];
}

function templates(audience: NotificationAudience, entries: Entry[]): NotificationTemplate[] {
  return entries.map(([key, row, text, level, high]) => ({
    key: `${audience}.${key}`,
    audience,
    row: `${SPEC[audience]} #${row}`,
    text,
    variables: variablesOf(text),
    level,
    priority: high ? 'high' : 'normal',
  }));
}

export const NOTIFICATION_TEMPLATES: readonly NotificationTemplate[] = [
  ...templates('customer', customer),
  ...templates('merchant', merchant),
  ...templates('captain', captain),
];

const BY_KEY = new Map(NOTIFICATION_TEMPLATES.map((template) => [template.key, template]));

export function notificationTemplate(key: string): NotificationTemplate | undefined {
  return BY_KEY.get(key);
}

export const NOTIFICATION_TEXT_MAX = 300;

// Fills a text's variables; one without a value stays as it is written, so a
// missing value shows rather than vanishes.
export function renderNotification(text: string, values: Record<string, string>): string {
  return text.replace(VARIABLE, (whole, name: string) => values[name] ?? whole);
}
