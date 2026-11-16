// The Arabic words of the Excel exports (architecture §5.9), written by the
// server, so the panel's translations cannot reach them. Slice 2.19g: a
// restaurant's statement for a period (AP §9.10.5), in the panel's words
// (apps/admin/src/locales/ar.json: `restaurantStatements` and RA §12.5's
// exceptions under `restaurantSettlement.cause`; export-labels.test.ts keeps
// the causes equal).
export const restaurantStatementLabels = {
  sheet: 'كشف المطعم',
  title: 'كشف حساب المطعم',
  restaurant: 'المطعم',
  period: 'الفترة',
  from: 'من',
  to: 'إلى',
  currency: 'العملة',
  sign: 'المبالغ من جهة المطعم: الموجب عليه، والسالب له.',
  opening: 'الرصيد الافتتاحي',
  orders: 'عدد الطلبات',
  itemsValue: 'قيمة الأصناف المقبوضة من الكباتن',
  commission: 'العمولة',
  discountShare: 'خصم يموّله المطعم',
  exceptions: 'صافي الاستثناءات',
  paid: 'المدفوع في الفترة',
  closing: 'الرصيد الختامي',
  columns: {
    at: 'الوقت',
    entry: 'البند',
    order: 'الطلب',
    itemsValue: 'قيمة الأصناف',
    pickupLines: 'المدفوع بالعملات',
    commission: 'العمولة',
    discountShare: 'خصم يموّله المطعم',
    amount: 'المبلغ',
    reason: 'السبب',
    receipt: 'الإيصال',
  },
  entries: {
    order: 'طلب',
    payment: 'دفعة',
    payout: 'صرف للمطعم',
  },
  causes: {
    food_credit: 'تعويض عن طلب أُلغي بعد التحضير',
    credit: 'تصحيح مبلغ الاستلام',
    pickup_refund: 'استرداد مبلغ الاستلام',
    pickup_kept: 'مبلغ استلام لطلب لم يكتمل',
    items_removed: 'أصناف حُذفت بعد الاستلام',
    fee_lowered: 'خُفّضت أجرة التوصيل بعد الاستلام',
    fee_cut_returned: 'إلغاء خصم أجرة التوصيل',
    debit: 'مشكلة بعد التسليم',
    commission_reversal: 'إلغاء عمولة',
    commission_restored: 'إلغاء استرداد العمولة',
    discount_reversal: 'إلغاء خصم يموّله المطعم',
    outcome_changed: 'تغيير النتيجة',
    adjustment: 'تسوية يدوية',
  },
} as const;
