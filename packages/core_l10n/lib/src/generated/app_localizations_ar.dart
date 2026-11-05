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
}
