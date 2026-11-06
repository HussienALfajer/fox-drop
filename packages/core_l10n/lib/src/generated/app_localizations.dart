import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// The customer app's name (CU README); a placeholder until the design.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق الزبون'**
  String get customerAppName;

  /// The captain app's name (CA README); a placeholder until the design.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق الكابتن'**
  String get captainAppName;

  /// The restaurant app's name (RA README); a placeholder until the design.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق المطعم'**
  String get merchantAppName;

  /// Shown while the app asks the server for its status.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الاتصال بالخادم…'**
  String get statusLoading;

  /// Shown when the server answered its status.
  ///
  /// In ar, this message translates to:
  /// **'الخادم يعمل'**
  String get statusOk;

  /// Shown when the status request failed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الاتصال بالخادم'**
  String get statusError;

  /// Shown for a route the app does not know.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة غير موجودة'**
  String get notFound;

  /// The sign-in screen's title (CA Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get signInTitle;

  /// The Syrian choice of the number's country picker (CU §5.2 item 1).
  ///
  /// In ar, this message translates to:
  /// **'سوريا +963'**
  String get signInCountrySyria;

  /// The Turkish choice of the number's country picker (CU §5.2 item 1).
  ///
  /// In ar, this message translates to:
  /// **'تركيا +90'**
  String get signInCountryTurkey;

  /// The phone number field (CU Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get signInPhoneLabel;

  /// Shown under the number when it is not a mobile of the chosen country.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف غير صحيح'**
  String get signInInvalidPhone;

  /// Asks the server to send the code over WhatsApp.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرمز'**
  String get signInSendCode;

  /// Says where the code went (CU §5.2 item 2).
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا الرمز إلى واتساب على الرقم {phone}'**
  String signInCodeSent(String phone);

  /// The code step opened from «لديّ رمز من العمليات», with no code sent (architecture §8.3.5).
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز الدخول الذي أعطتك إياه العمليات للرقم {phone}'**
  String signInOperationsCodeHint(String phone);

  /// The 6-digit code field.
  ///
  /// In ar, this message translates to:
  /// **'الرمز'**
  String get signInCodeLabel;

  /// Signs in with the code.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get signInConfirm;

  /// Pastes a 6-digit code from the clipboard (CU §5.2 item 2).
  ///
  /// In ar, this message translates to:
  /// **'لصق الرمز'**
  String get signInPasteCode;

  /// Sends a new code (CU §5.2 item 2).
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال'**
  String get signInResend;

  /// The wait before «إعادة الإرسال».
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال بعد {seconds} ث'**
  String signInResendIn(int seconds);

  /// Back to the number (CU §5.2 item 2).
  ///
  /// In ar, this message translates to:
  /// **'تعديل الرقم'**
  String get signInEditPhone;

  /// The number has no WhatsApp (CU §5.2, CA §4.9).
  ///
  /// In ar, this message translates to:
  /// **'هذا الرقم غير مسجّل على واتساب'**
  String get signInNotOnWhatsapp;

  /// Past the daily limit of codes (CU §5.2 item 2).
  ///
  /// In ar, this message translates to:
  /// **'تجاوزت عدد المحاولات المسموح، حاول غداً أو تواصل مع الدعم'**
  String get signInDailyLimit;

  /// Past the hourly limit of the number or the network.
  ///
  /// In ar, this message translates to:
  /// **'طلبات كثيرة، حاول بعد {minutes} دقيقة'**
  String signInTryLater(int minutes);

  /// A code is still open for the number.
  ///
  /// In ar, this message translates to:
  /// **'انتظر {seconds} ث قبل طلب رمز جديد'**
  String signInResendWait(int seconds);

  /// No code can be sent now (customer app).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إرسال الرمز الآن، حاول بعد قليل.'**
  String get signInUnavailable;

  /// No code can be sent now, in the captain and restaurant apps (owner decision 2026-11-07).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إرسال الرمز الآن. اتصل بالعمليات ليعطوك رمز دخول، أو حاول بعد قليل.'**
  String get signInUnavailableOperations;

  /// Opens the code step for an emergency code from operations (RA §5.2, CA §4.9).
  ///
  /// In ar, this message translates to:
  /// **'لديّ رمز من العمليات'**
  String get signInOperationsCode;

  /// Calls the support phone number (AP §9.13 contact info).
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالعمليات'**
  String get signInCallOperations;

  /// Opens WhatsApp with the support number (AP §9.13 contact info).
  ///
  /// In ar, this message translates to:
  /// **'واتساب العمليات'**
  String get signInWhatsappOperations;

  /// A wrong code, with the tries left.
  ///
  /// In ar, this message translates to:
  /// **'الرمز غير صحيح. المحاولات المتبقية: {attempts}'**
  String signInWrongCode(int attempts);

  /// No usable code: expired, used up or replaced.
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية الرمز، اطلب رمزاً جديداً'**
  String get signInCodeExpired;

  /// Any other failure of a sign-in call.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الاتصال بالخادم، حاول مرة أخرى'**
  String get signInError;

  /// Ends the session on this device.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get signOut;

  /// Shown on the placeholder home screen while signed in.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدخول'**
  String get signedIn;

  /// Saves a form.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// The number belongs to no restaurant (RA §5.2 item 3).
  ///
  /// In ar, this message translates to:
  /// **'هذا الرقم غير مسجّل لدى أي مطعم في FOX DROP'**
  String get merchantNotRegistered;

  /// The restaurant is still a draft (RA §5.2 item 4).
  ///
  /// In ar, this message translates to:
  /// **'حساب مطعمك قيد الإعداد. سنتواصل معك عند جاهزيته.'**
  String get merchantRestaurantDraft;

  /// A cashier of a terminated restaurant (RA §5.5).
  ///
  /// In ar, this message translates to:
  /// **'انتهى تعاقد مطعمك مع FOX DROP، ولا يمكن للكاشير الدخول.'**
  String get merchantRestaurantTerminated;

  /// The first sign-in of a device names it (RA §5.2 item 5).
  ///
  /// In ar, this message translates to:
  /// **'سمِّ هذا الجهاز'**
  String get merchantDeviceNameTitle;

  /// Examples of a device name (RA §5.2 item 5).
  ///
  /// In ar, this message translates to:
  /// **'مثل «كاشير 1» أو «تابلت المطبخ»'**
  String get merchantDeviceNameHint;

  /// The captain signed in on another device (CA §4.9, CA Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'سُجّل دخولك من جهاز آخر'**
  String get captainSignedInElsewhere;

  /// The captain's contract ended (CA §4.9).
  ///
  /// In ar, this message translates to:
  /// **'انتهى تعاقدك مع FOX DROP.'**
  String get captainContractEnded;

  /// The number stopped belonging to a captain since the code was sent.
  ///
  /// In ar, this message translates to:
  /// **'هذا الرقم غير مسجّل ككابتن في FOX DROP'**
  String get captainNotRegistered;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
