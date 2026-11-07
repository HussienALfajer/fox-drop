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
}
