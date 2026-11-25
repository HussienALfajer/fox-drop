import 'package:core_ui/core_ui.dart';

// The phone field's test data (D.11b): a few regions in Arabic order, as
// core_l10n's `foxCountryNames` lists them, and the field's words.

/// Iceland, Germany, Turkey and Syria, in Arabic order.
const testCountries = <FoxCountryOption>[
  (iso: 'IS', code: '354', ar: 'آيسلندا', en: 'Iceland'),
  (iso: 'DE', code: '49', ar: 'ألمانيا', en: 'Germany'),
  (iso: 'TR', code: '90', ar: 'تركيا', en: 'Türkiye'),
  (iso: 'SY', code: '963', ar: 'سوريا', en: 'Syria'),
];

/// The words of core_l10n, in short.
final testPhoneStrings = FoxPhoneStrings(
  chip: (name, code) => 'الدولة: $name، $code. اضغط لتغييرها',
  valid: 'الرقم صحيح',
  clear: 'مسح الرقم',
  empty: 'أدخل رقم هاتفك.',
  missingDigits: (n) => 'ينقص $n أرقام.',
  tooLong: 'الرقم أطول من المعتاد. تأكّد منه.',
  landline: 'هذا رقم أرضي. أدخل رقم جوال عليه واتساب.',
  notMobilePrefix: (p) => 'أدخل رقم جوال يبدأ بـ $p.',
  unknownCode: 'رمز الدولة غير معروف.',
  switched: (name) => 'عرفنا الدولة من رمزها: $name.',
  sheet: const FoxCountrySheetStrings(
    title: 'اختر الدولة',
    close: 'إغلاق',
    search: 'ابحث باسم الدولة أو رمزها',
    clearSearch: 'مسح',
    pinned: 'الأكثر استعمالاً',
    lastUsed: 'آخر ما استعملته',
    all: 'كل الدول',
    none: 'لا دولة بهذا الاسم أو الرمز',
  ),
);
