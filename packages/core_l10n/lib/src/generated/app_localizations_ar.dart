// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get customerAppName => 'تطبيق الزبون';

  @override
  String get captainAppName => 'تطبيق الكابتن';

  @override
  String get merchantAppName => 'تطبيق المطعم';

  @override
  String get statusLoading => 'جارٍ الاتصال بالخادم…';

  @override
  String get statusOk => 'الخادم يعمل';

  @override
  String get statusError => 'تعذّر الاتصال بالخادم';

  @override
  String get notFound => 'الصفحة غير موجودة';

  @override
  String get signInTitle => 'تسجيل الدخول';

  @override
  String get signInCountrySyria => 'سوريا +963';

  @override
  String get signInCountryTurkey => 'تركيا +90';

  @override
  String get signInPhoneLabel => 'رقم الهاتف';

  @override
  String get signInInvalidPhone => 'رقم الهاتف غير صحيح';

  @override
  String get signInSendCode => 'إرسال الرمز';

  @override
  String signInCodeSent(String phone) {
    return 'أرسلنا الرمز إلى واتساب على الرقم $phone';
  }

  @override
  String signInOperationsCodeHint(String phone) {
    return 'أدخل رمز الدخول الذي أعطتك إياه العمليات للرقم $phone';
  }

  @override
  String get signInCodeLabel => 'الرمز';

  @override
  String get signInConfirm => 'تأكيد';

  @override
  String get signInPasteCode => 'لصق الرمز';

  @override
  String get signInResend => 'إعادة الإرسال';

  @override
  String signInResendIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String get signInEditPhone => 'تعديل الرقم';

  @override
  String get signInNotOnWhatsapp => 'هذا الرقم غير مسجّل على واتساب';

  @override
  String get signInDailyLimit =>
      'تجاوزت عدد المحاولات المسموح، حاول غداً أو تواصل مع الدعم';

  @override
  String signInTryLater(int minutes) {
    return 'طلبات كثيرة، حاول بعد $minutes دقيقة';
  }

  @override
  String signInResendWait(int seconds) {
    return 'انتظر $seconds ث قبل طلب رمز جديد';
  }

  @override
  String get signInUnavailable => 'تعذّر إرسال الرمز الآن، حاول بعد قليل.';

  @override
  String get signInUnavailableOperations =>
      'تعذّر إرسال الرمز الآن. اتصل بالعمليات ليعطوك رمز دخول، أو حاول بعد قليل.';

  @override
  String get signInOperationsCode => 'لديّ رمز من العمليات';

  @override
  String get signInCallOperations => 'اتصال بالعمليات';

  @override
  String get signInWhatsappOperations => 'واتساب العمليات';

  @override
  String signInWrongCode(int attempts) {
    return 'الرمز غير صحيح. المحاولات المتبقية: $attempts';
  }

  @override
  String get signInCodeExpired => 'انتهت صلاحية الرمز، اطلب رمزاً جديداً';

  @override
  String get signInError => 'تعذّر الاتصال بالخادم، حاول مرة أخرى';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signedIn => 'تم تسجيل الدخول';

  @override
  String get save => 'حفظ';

  @override
  String get merchantNotRegistered =>
      'هذا الرقم غير مسجّل لدى أي مطعم في FOX DROP';

  @override
  String get merchantRestaurantDraft =>
      'حساب مطعمك قيد الإعداد. سنتواصل معك عند جاهزيته.';

  @override
  String get merchantRestaurantTerminated =>
      'انتهى تعاقد مطعمك مع FOX DROP، ولا يمكن للكاشير الدخول.';

  @override
  String get merchantDeviceNameTitle => 'سمِّ هذا الجهاز';

  @override
  String get merchantDeviceNameHint => 'مثل «كاشير 1» أو «تابلت المطبخ»';

  @override
  String get captainSignedInElsewhere => 'سُجّل دخولك من جهاز آخر';

  @override
  String get captainContractEnded => 'انتهى تعاقدك مع FOX DROP.';

  @override
  String get captainNotRegistered => 'هذا الرقم غير مسجّل ككابتن في FOX DROP';

  @override
  String money(String amount, String symbol) {
    return '$amount $symbol';
  }

  @override
  String timeMorning(String clock) {
    return '$clock ص';
  }

  @override
  String timeEvening(String clock) {
    return '$clock م';
  }

  @override
  String durationMinutes(int count) {
    return '$count د';
  }

  @override
  String distanceMetres(int count) {
    return '$count م';
  }

  @override
  String distanceKilometres(String count) {
    return '$count كم';
  }

  @override
  String get weekdaySunday => 'الأحد';

  @override
  String get weekdayMonday => 'الاثنين';

  @override
  String get weekdayTuesday => 'الثلاثاء';

  @override
  String get weekdayWednesday => 'الأربعاء';

  @override
  String get weekdayThursday => 'الخميس';

  @override
  String get weekdayFriday => 'الجمعة';

  @override
  String get weekdaySaturday => 'السبت';

  @override
  String get customerProfileTitle => 'أكمل بياناتك';

  @override
  String get customerProfileFirstName => 'الاسم';

  @override
  String get customerProfileLastName => 'الكنية';

  @override
  String get customerProfileInvalidName =>
      'اكتب من 2 إلى 30 حرفاً عربياً أو لاتينياً';

  @override
  String get customerProfileGender => 'الجنس';

  @override
  String get customerProfileMale => 'ذكر';

  @override
  String get customerProfileFemale => 'أنثى';

  @override
  String get customerProfileGenderRequired => 'اختر الجنس';

  @override
  String get customerProfileBirthday => 'تاريخ الميلاد';

  @override
  String get customerProfileTerms => 'أوافق على الشروط وسياسة الخصوصية';

  @override
  String get customerProfileTermsRequired => 'يجب الموافقة على الشروط للمتابعة';

  @override
  String get customerSave => 'حفظ';

  @override
  String get customerSaveFailed => 'تعذّر الحفظ، حاول مجدداً';

  @override
  String get customerWhereToDeliver => 'أين نوصل طلبك؟';

  @override
  String get customerUseMyLocation => 'استخدم موقعي الحالي';

  @override
  String get customerNoRestaurantsHere => 'لا توجد مطاعم توصل إلى موقعك حالياً';

  @override
  String get customerComingSoon => 'قريباً في منطقتك';

  @override
  String get customerVote => 'صوّت لمنطقتك';

  @override
  String get customerVoteThanks => 'شكراً، سنخبرك عندما نصل إلى منطقتك';

  @override
  String get customerLocationServiceOff =>
      'خدمة الموقع متوقفة في هاتفك. شغّلها ثم حاول مجدداً.';

  @override
  String get customerLocationDenied =>
      'اسمح للتطبيق بالوصول إلى موقعك لنعرف أين نوصل طلبك.';

  @override
  String get customerLocationFailed => 'تعذّر تحديد موقعك الآن. حاول مجدداً.';

  @override
  String get customerTryAgain => 'حاول مجدداً';

  @override
  String get customerNew => 'جديد';

  @override
  String customerRating(String rating, int count) {
    return '$rating ($count)';
  }

  @override
  String customerEstimate(int from, int to) {
    return '$from–$to د';
  }

  @override
  String get customerFreeDelivery => 'توصيل مجاني';

  @override
  String customerDeliveryFeeValue(String amount) {
    return 'رسوم التوصيل $amount';
  }

  @override
  String customerMinimumOrder(String amount) {
    return 'الحد الأدنى للطلب $amount';
  }

  @override
  String customerFreeDeliveryFrom(String amount) {
    return 'توصيل مجاني للطلبات من $amount فأكثر';
  }

  @override
  String get customerRestaurantBusyMode => 'قد يستغرق الطلب وقتاً أطول قليلاً';

  @override
  String get customerRestaurantBusy => 'المطعم مشغول حالياً، جرّب بعد قليل';

  @override
  String customerRestaurantPausedFor(String duration) {
    return 'المطعم متوقف مؤقتاً، يعود خلال $duration';
  }

  @override
  String get customerRestaurantPausedSoon => 'المطعم متوقف مؤقتاً، يعود قريباً';

  @override
  String customerRestaurantOpensAt(String day, String time) {
    return 'مغلق — يفتح $day $time';
  }

  @override
  String customerRestaurantClosedUntil(String date) {
    return 'مغلق حتى $date';
  }

  @override
  String get customerRestaurantClosed => 'مغلق';

  @override
  String get customerBadgeBusy => 'مشغول';

  @override
  String get customerBadgePaused => 'متوقف مؤقتاً';

  @override
  String get customerNotCovered => 'هذا المطعم لا يوصل إلى هذا العنوان';

  @override
  String get customerSamePrices => 'نفس أسعار المحل';

  @override
  String get customerSamePricesExplained =>
      'أسعار هذا المطعم في التطبيق هي نفس أسعاره في المحل. إن وجدت فرقاً فأخبرنا.';

  @override
  String get customerOk => 'موافق';

  @override
  String get customerOpeningHours => 'أوقات العمل';

  @override
  String customerHoursRange(String opens, String closes) {
    return '$opens – $closes';
  }

  @override
  String get customerMenuSearch => 'ابحث في القائمة';

  @override
  String customerFromPrice(String amount) {
    return 'من $amount';
  }

  @override
  String get customerAvailableTomorrow => 'يتوفر غداً';

  @override
  String customerAvailableFrom(String time) {
    return 'متوفر من $time';
  }

  @override
  String get customerUnavailable => 'غير متوفر حالياً';

  @override
  String customerCartCount(int count) {
    return 'السلة ($count)';
  }

  @override
  String get customerRequired => 'إجباري';

  @override
  String customerChoose(int count) {
    return 'اختر $count';
  }

  @override
  String customerChooseUpTo(int count) {
    return 'اختر حتى $count';
  }

  @override
  String customerChooseBetween(int min, int max) {
    return 'اختر من $min إلى $max';
  }

  @override
  String customerChooseAtLeast(int count) {
    return 'اختر $count على الأقل';
  }

  @override
  String get customerItemNoteHint => 'مثلاً: بدون بصل';

  @override
  String customerNoteTooLong(int count) {
    return 'الملاحظة أطول من $count حرفاً';
  }

  @override
  String get customerNoPhoneInNote =>
      'لا تكتب أرقام هواتف في الملاحظة. رقم التواصل يصل إلى الكابتن تلقائياً.';

  @override
  String customerAddFor(String amount) {
    return 'أضف — $amount';
  }

  @override
  String customerCartOtherRestaurant(String current, String next) {
    return 'سلتك فيها أصناف من $current. هل تفرغها وتبدأ سلة جديدة من $next؟';
  }

  @override
  String get customerNewCart => 'سلة جديدة';

  @override
  String get customerCancel => 'إلغاء';

  @override
  String get customerCart => 'السلة';

  @override
  String get customerCartEmpty => 'سلتك فارغة';

  @override
  String get customerCartExpired => 'انتهت صلاحية سلتك';

  @override
  String get customerEdit => 'تعديل';

  @override
  String get customerRemove => 'حذف';

  @override
  String get customerContinue => 'متابعة';

  @override
  String customerBelowMinimumProgress(String amount, String minimum) {
    return 'أضف $amount لتصل إلى الحد الأدنى ($minimum)';
  }

  @override
  String customerFreeDeliveryProgress(String amount) {
    return 'أضف $amount لتحصل على توصيل مجاني';
  }

  @override
  String get customerFreeDeliveryReached => 'توصيلك مجاني';
}
