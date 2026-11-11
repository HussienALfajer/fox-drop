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

  /// A sign-in on a second device refused during an active order (CA §4.9; owner decision 2026-11-11).
  ///
  /// In ar, this message translates to:
  /// **'لديك طلب نشط على جهاز آخر. اتصل بالعمليات لتحرير جهازك القديم.'**
  String get captainActiveOrderElsewhere;

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

  /// An amount with its currency's symbol or code, such as «410 ₺» or «10.50 $» (CU §4.6).
  ///
  /// In ar, this message translates to:
  /// **'{amount} {symbol}'**
  String money(String amount, String symbol);

  /// A 12-hour time before noon (CU §4.6).
  ///
  /// In ar, this message translates to:
  /// **'{clock} ص'**
  String timeMorning(String clock);

  /// A 12-hour time from noon (CU §4.6).
  ///
  /// In ar, this message translates to:
  /// **'{clock} م'**
  String timeEvening(String clock);

  /// A duration in minutes, such as «12 د» (CU §4.6).
  ///
  /// In ar, this message translates to:
  /// **'{count} د'**
  String durationMinutes(int count);

  /// A distance below 1 km, such as «850 م» (CU §4.6).
  ///
  /// In ar, this message translates to:
  /// **'{count} م'**
  String distanceMetres(int count);

  /// A distance from 1 km, such as «2.4 كم» (CU §4.6).
  ///
  /// In ar, this message translates to:
  /// **'{count} كم'**
  String distanceKilometres(String count);

  /// A weekday's name.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get weekdaySunday;

  /// A weekday's name.
  ///
  /// In ar, this message translates to:
  /// **'الاثنين'**
  String get weekdayMonday;

  /// A weekday's name.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get weekdayTuesday;

  /// A weekday's name.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get weekdayWednesday;

  /// A weekday's name.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get weekdayThursday;

  /// A weekday's name.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get weekdayFriday;

  /// A weekday's name.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get weekdaySaturday;

  /// The new account's details screen (CU §5.3).
  ///
  /// In ar, this message translates to:
  /// **'أكمل بياناتك'**
  String get customerProfileTitle;

  /// The first name field (CU §5.3).
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get customerProfileFirstName;

  /// The last name field, optional (CU §5.3).
  ///
  /// In ar, this message translates to:
  /// **'الكنية'**
  String get customerProfileLastName;

  /// Under a name that breaks CU §5.3's rule; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اكتب من 2 إلى 30 حرفاً عربياً أو لاتينياً'**
  String get customerProfileInvalidName;

  /// The gender choice (CU §5.3).
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get customerProfileGender;

  /// A gender choice (CU §5.3).
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get customerProfileMale;

  /// A gender choice (CU §5.3).
  ///
  /// In ar, this message translates to:
  /// **'أنثى'**
  String get customerProfileFemale;

  /// Shown when no gender is chosen; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اختر الجنس'**
  String get customerProfileGenderRequired;

  /// The optional birthday, from a date picker (CU §5.3).
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الميلاد'**
  String get customerProfileBirthday;

  /// The required terms checkbox (CU §5.3).
  ///
  /// In ar, this message translates to:
  /// **'أوافق على الشروط وسياسة الخصوصية'**
  String get customerProfileTerms;

  /// Shown when the terms are not ticked; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'يجب الموافقة على الشروط للمتابعة'**
  String get customerProfileTermsRequired;

  /// Saves a form.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get customerSave;

  /// A save the server refused or did not answer.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الحفظ، حاول مجدداً'**
  String get customerSaveFailed;

  /// The first open asks for the delivery point (CU §7.1).
  ///
  /// In ar, this message translates to:
  /// **'أين نوصل طلبك؟'**
  String get customerWhereToDeliver;

  /// Takes the phone's position as the delivery point (CU §7.1).
  ///
  /// In ar, this message translates to:
  /// **'استخدم موقعي الحالي'**
  String get customerUseMyLocation;

  /// Inside a zone, but no restaurant covers the point (CU §7.1).
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مطاعم توصل إلى موقعك حالياً'**
  String get customerNoRestaurantsHere;

  /// The point is outside every zone (CU §7.2).
  ///
  /// In ar, this message translates to:
  /// **'قريباً في منطقتك'**
  String get customerComingSoon;

  /// Votes for the point's area (CU §7.2).
  ///
  /// In ar, this message translates to:
  /// **'صوّت لمنطقتك'**
  String get customerVote;

  /// After a vote (CU §7.2).
  ///
  /// In ar, this message translates to:
  /// **'شكراً، سنخبرك عندما نصل إلى منطقتك'**
  String get customerVoteThanks;

  /// The phone's location service is off; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع متوقفة في هاتفك. شغّلها ثم حاول مجدداً.'**
  String get customerLocationServiceOff;

  /// The location permission was refused; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اسمح للتطبيق بالوصول إلى موقعك لنعرف أين نوصل طلبك.'**
  String get customerLocationDenied;

  /// No position came in time; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحديد موقعك الآن. حاول مجدداً.'**
  String get customerLocationFailed;

  /// Repeats what failed.
  ///
  /// In ar, this message translates to:
  /// **'حاول مجدداً'**
  String get customerTryAgain;

  /// A restaurant without ratings yet (Q16).
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get customerNew;

  /// The rating with the number of ratings (CU §9.1).
  ///
  /// In ar, this message translates to:
  /// **'{rating} ({count})'**
  String customerRating(String rating, int count);

  /// The delivery estimate as a 10-minute range (CU §8.4).
  ///
  /// In ar, this message translates to:
  /// **'{from}–{to} د'**
  String customerEstimate(int from, int to);

  /// The delivery is free for the point (CU §8.2).
  ///
  /// In ar, this message translates to:
  /// **'توصيل مجاني'**
  String get customerFreeDelivery;

  /// The delivery fee to the point (CU §8.2).
  ///
  /// In ar, this message translates to:
  /// **'رسوم التوصيل {amount}'**
  String customerDeliveryFeeValue(String amount);

  /// The restaurant's minimum order (CU §9.1); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للطلب {amount}'**
  String customerMinimumOrder(String amount);

  /// The free-delivery threshold (CU §9.1).
  ///
  /// In ar, this message translates to:
  /// **'توصيل مجاني للطلبات من {amount} فأكثر'**
  String customerFreeDeliveryFrom(String amount);

  /// Open in busy mode (CU §9.2, Q8).
  ///
  /// In ar, this message translates to:
  /// **'قد يستغرق الطلب وقتاً أطول قليلاً'**
  String get customerRestaurantBusyMode;

  /// At its maximum active orders (CU §9.2).
  ///
  /// In ar, this message translates to:
  /// **'المطعم مشغول حالياً، جرّب بعد قليل'**
  String get customerRestaurantBusy;

  /// Paused with an end time (CU §9.2).
  ///
  /// In ar, this message translates to:
  /// **'المطعم متوقف مؤقتاً، يعود خلال {duration}'**
  String customerRestaurantPausedFor(String duration);

  /// Paused without an end time (CU §9.2).
  ///
  /// In ar, this message translates to:
  /// **'المطعم متوقف مؤقتاً، يعود قريباً'**
  String get customerRestaurantPausedSoon;

  /// Closed by the schedule (CU §9.2, §8.2).
  ///
  /// In ar, this message translates to:
  /// **'مغلق — يفتح {day} {time}'**
  String customerRestaurantOpensAt(String day, String time);

  /// A holiday close (CU §9.2).
  ///
  /// In ar, this message translates to:
  /// **'مغلق حتى {date}'**
  String customerRestaurantClosedUntil(String date);

  /// Closed with no opening time known.
  ///
  /// In ar, this message translates to:
  /// **'مغلق'**
  String get customerRestaurantClosed;

  /// A busy restaurant's card badge (CU §8.2).
  ///
  /// In ar, this message translates to:
  /// **'مشغول'**
  String get customerBadgeBusy;

  /// A paused restaurant's card badge (CU §8.2).
  ///
  /// In ar, this message translates to:
  /// **'متوقف مؤقتاً'**
  String get customerBadgePaused;

  /// The point is outside the restaurant's coverage or every zone (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'هذا المطعم لا يوصل إلى هذا العنوان'**
  String get customerNotCovered;

  /// The price-parity badge (CU §9.5).
  ///
  /// In ar, this message translates to:
  /// **'نفس أسعار المحل'**
  String get customerSamePrices;

  /// The price-parity explanation (CU §9.5).
  ///
  /// In ar, this message translates to:
  /// **'أسعار هذا المطعم في التطبيق هي نفس أسعاره في المحل. إن وجدت فرقاً فأخبرنا.'**
  String get customerSamePricesExplained;

  /// Closes a message, or accepts a new price (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'موافق'**
  String get customerOk;

  /// Opens the weekly schedule (CU §9.1).
  ///
  /// In ar, this message translates to:
  /// **'أوقات العمل'**
  String get customerOpeningHours;

  /// One opening period of the schedule.
  ///
  /// In ar, this message translates to:
  /// **'{opens} – {closes}'**
  String customerHoursRange(String opens, String closes);

  /// Searches the menu (CU §9.1).
  ///
  /// In ar, this message translates to:
  /// **'ابحث في القائمة'**
  String get customerMenuSearch;

  /// An item whose required options change its price (CU §9.3).
  ///
  /// In ar, this message translates to:
  /// **'من {amount}'**
  String customerFromPrice(String amount);

  /// An item switched off until tomorrow (CU §9.3).
  ///
  /// In ar, this message translates to:
  /// **'يتوفر غداً'**
  String get customerAvailableTomorrow;

  /// An item of a category outside its window (CU §9.3).
  ///
  /// In ar, this message translates to:
  /// **'متوفر من {time}'**
  String customerAvailableFrom(String time);

  /// An unavailable item or option (CU §9.3).
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر حالياً'**
  String get customerUnavailable;

  /// Opens the cart, with its number of lines.
  ///
  /// In ar, this message translates to:
  /// **'السلة ({count})'**
  String customerCartCount(int count);

  /// A required option group (CU §9.4).
  ///
  /// In ar, this message translates to:
  /// **'إجباري'**
  String get customerRequired;

  /// A group of exactly n choices (CU §9.4).
  ///
  /// In ar, this message translates to:
  /// **'اختر {count}'**
  String customerChoose(int count);

  /// A group of up to n choices (CU §9.4).
  ///
  /// In ar, this message translates to:
  /// **'اختر حتى {count}'**
  String customerChooseUpTo(int count);

  /// A group of a to b choices (CU §9.4).
  ///
  /// In ar, this message translates to:
  /// **'اختر من {min} إلى {max}'**
  String customerChooseBetween(int min, int max);

  /// A required group left incomplete (CU §9.4).
  ///
  /// In ar, this message translates to:
  /// **'اختر {count} على الأقل'**
  String customerChooseAtLeast(int count);

  /// The item note's placeholder (CU §9.4).
  ///
  /// In ar, this message translates to:
  /// **'مثلاً: بدون بصل'**
  String get customerItemNoteHint;

  /// A note over its limit; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظة أطول من {count} حرفاً'**
  String customerNoteTooLong(int count);

  /// A note with a run of 7 or more digits (CU §10.3, Q25).
  ///
  /// In ar, this message translates to:
  /// **'لا تكتب أرقام هواتف في الملاحظة. رقم التواصل يصل إلى الكابتن تلقائياً.'**
  String get customerNoPhoneInNote;

  /// Adds the line to the cart with its live price (CU §9.4).
  ///
  /// In ar, this message translates to:
  /// **'أضف — {amount}'**
  String customerAddFor(String amount);

  /// Adding from another restaurant (CU §10.1).
  ///
  /// In ar, this message translates to:
  /// **'سلتك فيها أصناف من {current}. هل تفرغها وتبدأ سلة جديدة من {next}؟'**
  String customerCartOtherRestaurant(String current, String next);

  /// Empties the cart for the new restaurant (CU §10.1).
  ///
  /// In ar, this message translates to:
  /// **'سلة جديدة'**
  String get customerNewCart;

  /// Cancels a dialog.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get customerCancel;

  /// The cart screen (CU Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get customerCart;

  /// The cart has no lines; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'سلتك فارغة'**
  String get customerCartEmpty;

  /// The cart emptied after 24 hours (CU §10.1).
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية سلتك'**
  String get customerCartExpired;

  /// Reopens the item sheet for a cart line (CU §10.1).
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get customerEdit;

  /// Removes a cart line (CU §10.1, Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get customerRemove;

  /// Leads from the cart to checkout (CU §10.1).
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get customerContinue;

  /// Below the minimum order, with a progress bar (CU §10.2).
  ///
  /// In ar, this message translates to:
  /// **'أضف {amount} لتصل إلى الحد الأدنى ({minimum})'**
  String customerBelowMinimumProgress(String amount, String minimum);

  /// Below the free-delivery threshold (CU §10.2).
  ///
  /// In ar, this message translates to:
  /// **'أضف {amount} لتحصل على توصيل مجاني'**
  String customerFreeDeliveryProgress(String amount);

  /// At or above the free-delivery threshold (CU §10.2).
  ///
  /// In ar, this message translates to:
  /// **'توصيلك مجاني'**
  String get customerFreeDeliveryReached;

  /// The app is below the minimum version (CU §4.2); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'حدّث التطبيق لتتمكن من الطلب'**
  String get customerUpdateRequired;

  /// Maintenance is on (CU §4.7); the panel's message comes with the content slice.
  ///
  /// In ar, this message translates to:
  /// **'FOX DROP في صيانة الآن، حاول بعد قليل'**
  String get customerMaintenance;

  /// Outside the platform hours (CU §4.7, Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'FOX DROP يستقبل الطلبات من الساعة {time}'**
  String customerPlatformClosed(String time);

  /// Outside the platform hours with no opening known.
  ///
  /// In ar, this message translates to:
  /// **'FOX DROP لا يستقبل الطلبات الآن'**
  String get customerPlatformClosedNow;

  /// Below the minimum order (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'أضف {amount} لتصل إلى الحد الأدنى'**
  String customerBelowMinimum(String amount);

  /// A new account at its active-order limit (CU §5.5).
  ///
  /// In ar, this message translates to:
  /// **'يمكنك طلب واحد في كل مرة حتى يكتمل طلبك الحالي'**
  String get customerOneOrderAtATime;

  /// A trusted account at its active-order limit (CU §5.5).
  ///
  /// In ar, this message translates to:
  /// **'وصلت إلى الحد الأقصى للطلبات الجارية'**
  String get customerActiveOrderLimit;

  /// The capacity check found no captain (CU §10.6).
  ///
  /// In ar, this message translates to:
  /// **'الضغط عالٍ الآن، جرّب بعد دقائق'**
  String get customerNoCaptain;

  /// A line's price changed since it was added (CU §10.1, Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'تغيّر سعر {item} من {oldPrice} إلى {newPrice}'**
  String customerPriceChanged(String item, String oldPrice, String newPrice);

  /// An item or option no longer available (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'{item} لم يعد متوفراً'**
  String customerItemGone(String item);

  /// The restaurant's prices or the city's money settings cannot be priced; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن الطلب من هذا المطعم الآن'**
  String get customerCannotPrice;

  /// Back to the restaurant to reach the minimum (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'أضف أصنافاً'**
  String get customerAddItems;

  /// Changes the address (CU §7.5, Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'تغيير العنوان'**
  String get customerChangeAddress;

  /// Asks for the quote again after the capacity check (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get customerRetry;

  /// The checkout's address section; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'عنوان التوصيل'**
  String get customerDeliveryAddress;

  /// An address label (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'البيت'**
  String get customerLabelHome;

  /// An address label (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'العمل'**
  String get customerLabelWork;

  /// An address label with a custom name (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'آخر'**
  String get customerLabelOther;

  /// The custom name of an «آخر» address; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اسم العنوان'**
  String get customerCustomLabel;

  /// A saved address outside every active zone (CU §7.3, Q6).
  ///
  /// In ar, this message translates to:
  /// **'خارج منطقة التوصيل حالياً'**
  String get customerOutsideZoneNow;

  /// The phone's position as the address (CU §7.4).
  ///
  /// In ar, this message translates to:
  /// **'التوصيل إلى موقعي الحالي'**
  String get customerDeliverToCurrentLocation;

  /// The position is worse than 100 m (CU §7.4); the map to adjust the pin waits for Phase 2.
  ///
  /// In ar, this message translates to:
  /// **'دقة موقعك {distance}. حدّث موقعك إن لم يكن العنوان دقيقاً.'**
  String customerLowAccuracy(String distance);

  /// Asks for the phone's position again.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الموقع'**
  String get customerUpdateLocation;

  /// The zone's name, read-only (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'الحي'**
  String get customerNeighbourhood;

  /// Required, 3 to 100 characters (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'الشارع والبناء'**
  String get customerStreet;

  /// Optional (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'الطابق والشقة'**
  String get customerFloor;

  /// Required, 3 to 100 characters (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'بالقرب من'**
  String get customerLandmark;

  /// The landmark's placeholder (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'مثلاً: قرب جامع النور'**
  String get customerLandmarkHint;

  /// The contact number (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'رقم التواصل'**
  String get customerContactPhone;

  /// The contact number is the account's when empty (U5); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'رقم حسابك إن تركته فارغاً'**
  String get customerContactPhoneHint;

  /// Required when the contact number is not the account's (CU §7.3, Q5).
  ///
  /// In ar, this message translates to:
  /// **'اسم المستلم'**
  String get customerRecipientName;

  /// Optional, up to 200 characters (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'توجيهات للكابتن'**
  String get customerDirections;

  /// The directions' example (CU §7.3).
  ///
  /// In ar, this message translates to:
  /// **'مثلاً: الباب الأزرق بجانب الصيدلية'**
  String get customerDirectionsHint;

  /// Saves the unsaved address with the order (CU §7.4).
  ///
  /// In ar, this message translates to:
  /// **'احفظ هذا العنوان'**
  String get customerSaveAddress;

  /// A field outside its length; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اكتب من {min} إلى {max} حرفاً'**
  String customerLengthBetween(int min, int max);

  /// A field over its length; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'{max} حرفاً على الأكثر'**
  String customerLengthUpTo(int max);

  /// The free note of CU §10.3 item 2; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة للمطعم والكابتن'**
  String get customerOrderNote;

  /// The pay-in currency (CU §10.5).
  ///
  /// In ar, this message translates to:
  /// **'سأدفع بـ'**
  String get customerPayIn;

  /// No pay-in currency, the default (CU §10.5).
  ///
  /// In ar, this message translates to:
  /// **'لم أحدد'**
  String get customerPayInUnset;

  /// The total in the chosen currency (CU §10.5).
  ///
  /// In ar, this message translates to:
  /// **'ستدفع حوالي {amount}'**
  String customerPayAbout(String amount);

  /// The only payment in V1 (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'نقداً عند الاستلام'**
  String get customerCashOnDelivery;

  /// The checkout's estimate (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'يصل خلال {from}–{to} د'**
  String customerArrivesWithin(int from, int to);

  /// A money line (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'قيمة الأصناف'**
  String get customerItemsValue;

  /// A money line (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'رسوم التوصيل'**
  String get customerDeliveryFee;

  /// A free delivery fee (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'مجاني'**
  String get customerFree;

  /// A money line (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get customerDiscount;

  /// A money line, only when not 0 (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'تقريب'**
  String get customerRounding;

  /// The total (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get customerTotal;

  /// The total in the other accepted currencies (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'أو {amounts}'**
  String customerOrEquivalents(String amounts);

  /// Places the order before the quote is known.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب'**
  String get customerConfirm;

  /// Places the order (CU §10.3).
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب — {total}'**
  String customerConfirmFor(String total);

  /// While the order command is sent (CU §10.7).
  ///
  /// In ar, this message translates to:
  /// **'جارٍ إرسال طلبك…'**
  String get customerSending;

  /// The far-pin check (CU §7.5).
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من العنوان؟'**
  String get customerFarPinTitle;

  /// The far-pin check's distance (CU §7.5).
  ///
  /// In ar, this message translates to:
  /// **'النقطة تبعد {distance} عن موقعك الحالي.'**
  String customerFarPinBody(String distance);

  /// Keeps the far pin (CU §7.5).
  ///
  /// In ar, this message translates to:
  /// **'نعم، أرسل إلى هذا العنوان'**
  String get customerFarPinSend;

  /// 409 quote_changed (CU §10.7, Q10); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تغيّر شيء في طلبك. راجع التفاصيل ثم أكّد مجدداً.'**
  String get customerQuoteChanged;

  /// 409 order_blocked (CU §10.7); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لم نتمكن من إرسال طلبك. راجع المشكلة أعلاه.'**
  String get customerOrderBlocked;

  /// The address left every zone (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'العنوان خارج منطقة التوصيل'**
  String get customerAddressOutside;

  /// «احفظ هذا العنوان» failed; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر حفظ العنوان، ولم يُرسل الطلب.'**
  String get customerSaveAddressFailed;

  /// No answer to the order command; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إرسال طلبك، حاول مجدداً.'**
  String get customerSendFailed;

  /// An order number (CU §4.6).
  ///
  /// In ar, this message translates to:
  /// **'#{number}'**
  String customerOrderNumber(String number);

  /// The order was placed (CU §10.7).
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا طلبك إلى {restaurant}'**
  String customerOrderSent(String restaurant);

  /// Order status (CU Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'بانتظار تأكيد المطعم'**
  String get customerStatusPlaced;

  /// Order status (CU Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'المطعم يحضّر طلبك'**
  String get customerStatusAccepted;

  /// Order status (CU Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'طلبك جاهز'**
  String get customerStatusReady;

  /// Order status (CU Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'في الطريق إليك'**
  String get customerStatusPickedUp;

  /// Order status (CU Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن عند الباب'**
  String get customerStatusArrived;

  /// Order status (CU Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get customerStatusDelivered;

  /// The promised time (CU §8.4).
  ///
  /// In ar, this message translates to:
  /// **'يصل حوالي {time}'**
  String customerArrivesAbout(String time);

  /// A 400 answer to the order command; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من بيانات العنوان والملاحظة ثم أكّد مجدداً.'**
  String get customerOrderInvalid;

  /// A duration in seconds (RA §4.8).
  ///
  /// In ar, this message translates to:
  /// **'{seconds} ث'**
  String durationSeconds(int seconds);

  /// A captain's vehicle (CU §11.3).
  ///
  /// In ar, this message translates to:
  /// **'سيراً على الأقدام'**
  String get vehicleWalking;

  /// A captain's vehicle (CU §11.3).
  ///
  /// In ar, this message translates to:
  /// **'دراجة'**
  String get vehicleBicycle;

  /// A captain's vehicle (CU §11.3).
  ///
  /// In ar, this message translates to:
  /// **'دراجة نارية'**
  String get vehicleMotorbike;

  /// A captain's vehicle (CU §11.3).
  ///
  /// In ar, this message translates to:
  /// **'سيارة'**
  String get vehicleCar;

  /// Board column (RA §8.1).
  ///
  /// In ar, this message translates to:
  /// **'جديدة'**
  String get merchantColumnIncoming;

  /// Board column (RA §8.1).
  ///
  /// In ar, this message translates to:
  /// **'قيد التحضير'**
  String get merchantColumnPreparing;

  /// Board column (RA §8.1).
  ///
  /// In ar, this message translates to:
  /// **'جاهزة'**
  String get merchantColumnReady;

  /// Board column (RA §8.1).
  ///
  /// In ar, this message translates to:
  /// **'مع الكابتن'**
  String get merchantColumnWithCaptain;

  /// A column header with its count (RA §8.2).
  ///
  /// In ar, this message translates to:
  /// **'{column} ({count})'**
  String merchantColumnCount(String column, int count);

  /// A column header with its count and late orders (RA §8.2); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'{column} ({count}) — متأخرة: {late}'**
  String merchantColumnLate(String column, int count, int late);

  /// An empty column; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات الآن'**
  String get merchantBoardEmpty;

  /// Time since the order was placed (RA §8.2).
  ///
  /// In ar, this message translates to:
  /// **'منذ {minutes} د'**
  String merchantSincePlaced(int minutes);

  /// The card's item count (RA §8.2); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الأصناف: {count}'**
  String merchantItemCount(int count);

  /// Captain line (RA §8.1).
  ///
  /// In ar, this message translates to:
  /// **'بانتظار كابتن'**
  String get merchantWaitingForCaptain;

  /// Captain line (RA §8.1) until the ETA joins it: «— يصل خلال {د} د».
  ///
  /// In ar, this message translates to:
  /// **'الكابتن {name} في الطريق'**
  String merchantCaptainOnTheWay(String name);

  /// Captain line (RA §8.1).
  ///
  /// In ar, this message translates to:
  /// **'وصل الكابتن — ينتظر منذ {minutes} د'**
  String merchantCaptainWaiting(int minutes);

  /// Captain line (RA §8.1).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن يطلب تأكيد الاستلام'**
  String get merchantCaptainAsksPickup;

  /// Captain line (RA §8.1).
  ///
  /// In ar, this message translates to:
  /// **'مع الكابتن {name}'**
  String merchantWithCaptain(String name);

  /// The auto-cancel countdown (RA §8.3).
  ///
  /// In ar, this message translates to:
  /// **'يُلغى تلقائياً خلال {time}'**
  String merchantAutoCancelIn(String time);

  /// The prep countdown (RA §8.7); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'متبقٍ {time}'**
  String merchantPrepLeft(String time);

  /// A late order in preparation (RA §8.7).
  ///
  /// In ar, this message translates to:
  /// **'متأخر {minutes} د'**
  String merchantPrepLate(int minutes);

  /// Time since pickup in «مع الكابتن» (RA §8.11); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'استُلم منذ {minutes} د'**
  String merchantPickedUpSince(int minutes);

  /// The accept button (RA §8.5).
  ///
  /// In ar, this message translates to:
  /// **'قبول — {minutes} د'**
  String merchantAccept(int minutes);

  /// The ready button (RA §8.8).
  ///
  /// In ar, this message translates to:
  /// **'الطلب جاهز'**
  String get merchantReady;

  /// The ready help link (RA §8.8).
  ///
  /// In ar, this message translates to:
  /// **'لماذا أضغط «الطلب جاهز»؟'**
  String get merchantWhyReady;

  /// The ready help (RA §8.8); the spec explains it without exact wording.
  ///
  /// In ar, this message translates to:
  /// **'يُبلَّغ الكابتن فوراً، ويرى الزبون «طلبك جاهز». الضغط في الوقت يُبقي نسبة تأخر مطعمك منخفضة.'**
  String get merchantWhyReadyText;

  /// The no-extension link (RA §8.7, R7).
  ///
  /// In ar, this message translates to:
  /// **'تحتاج وقتاً أطول؟ اتصل بالعمليات'**
  String get merchantNeedMoreTime;

  /// Pickup prompt button (RA §8.10).
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الاستلام'**
  String get merchantConfirmPickup;

  /// Pickup prompt button (RA §8.10).
  ///
  /// In ar, this message translates to:
  /// **'المبلغ غير صحيح'**
  String get merchantAmountIncorrect;

  /// Pickup prompt link (RA §8.10, S17).
  ///
  /// In ar, this message translates to:
  /// **'الطلب غير مكتمل'**
  String get merchantOrderIncomplete;

  /// A command waiting for its answer (RA §4.7).
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الإرسال…'**
  String get merchantSending;

  /// The new-order prompt (RA §8.3).
  ///
  /// In ar, this message translates to:
  /// **'طلب جديد #{number}'**
  String merchantNewOrder(String number);

  /// The items value in the new-order prompt (RA §8.3).
  ///
  /// In ar, this message translates to:
  /// **'{amount} — يدفعها لك الكابتن عند الاستلام'**
  String merchantItemsValueOnPickup(String amount);

  /// The money line for everyone (RA §8.4).
  ///
  /// In ar, this message translates to:
  /// **'قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام: {amount}'**
  String merchantItemsValue(String amount);

  /// The new-order prompt after the accept alert (RA §8.3).
  ///
  /// In ar, this message translates to:
  /// **'تأخرتم في الرد — سيتصل بكم فريق العمليات'**
  String get merchantLateReply;

  /// The counter of stacked prompts (RA §4.4); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'{index} من {count}'**
  String merchantPromptCount(int index, int count);

  /// The pickup prompt (RA §8.10 item 3).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن {name} يؤكد أنه دفع لك {amount} واستلم الطلب #{number}'**
  String merchantPickupPrompt(String name, String amount, String number);

  /// The base-currency equivalent of the payment lines (RA §8.10); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'يعادل {amount}'**
  String merchantBaseEquivalent(String amount);

  /// The pickup countdown (RA §8.10).
  ///
  /// In ar, this message translates to:
  /// **'يُؤكَّد تلقائياً خلال {seconds} ث'**
  String merchantAutoConfirmIn(int seconds);

  /// The offline bar (RA §4.7).
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال'**
  String get merchantOffline;

  /// No answer (RA §8.3).
  ///
  /// In ar, this message translates to:
  /// **'أُلغي الطلب #{number} لعدم الرد'**
  String merchantAutoCancelled(String number);

  /// The customer cancelled while placed (RA §8.3, §16 #4).
  ///
  /// In ar, this message translates to:
  /// **'ألغى الزبون الطلب #{number}'**
  String merchantCustomerCancelled(String number);

  /// Another cancellation until its prompt (RA §8.14); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أُلغي الطلب #{number}'**
  String merchantCancelled(String number);

  /// Prep late chime (RA §8.7).
  ///
  /// In ar, this message translates to:
  /// **'تحضير متأخر #{number} — اضغط «الطلب جاهز» فور الانتهاء'**
  String merchantPrepLateChime(String number);

  /// Captain arrived (RA §8.9).
  ///
  /// In ar, this message translates to:
  /// **'وصل الكابتن {name} لاستلام الطلب #{number}'**
  String merchantCaptainArrived(String name, String number);

  /// Captain waiting (RA §8.9).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن ينتظر الطلب #{number} منذ {minutes} دقائق'**
  String merchantCaptainKeptWaiting(String number, int minutes);

  /// The pickup prompt closed by another user (RA §8.10).
  ///
  /// In ar, this message translates to:
  /// **'أكّد {name} الاستلام'**
  String merchantPickupConfirmedBy(String name);

  /// The pickup prompt closed by another user (RA §8.10).
  ///
  /// In ar, this message translates to:
  /// **'أبلغ {name} أن المبلغ غير صحيح'**
  String merchantPickupDisputedBy(String name);

  /// The pickup prompt closed by another user with «الطلب غير مكتمل»; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أبلغ {name} أن الطلب غير مكتمل'**
  String merchantPickupIncompleteBy(String name);

  /// The automatic confirmation (RA §8.10 item 5).
  ///
  /// In ar, this message translates to:
  /// **'تأكيد تلقائي — الطلب #{number}'**
  String merchantPickupAutoConfirmed(String number);

  /// Confirmed by operations (S9); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أكّدت العمليات الاستلام — الطلب #{number}'**
  String merchantPickupByOperations(String number);

  /// A pickup request closed another way, such as a cancellation; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أُغلق طلب الاستلام — الطلب #{number}'**
  String merchantPickupClosed(String number);

  /// 409 after accepting (RA §4.7).
  ///
  /// In ar, this message translates to:
  /// **'قُبل الطلب من جهاز {device}'**
  String merchantAcceptedOnDevice(String device);

  /// 409 after accepting, by an unnamed device or operations; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'قُبل الطلب من جهاز آخر'**
  String get merchantAcceptedElsewhere;

  /// 409 on a cancelled order (RA §4.7).
  ///
  /// In ar, this message translates to:
  /// **'أُلغي الطلب قبل وصول قبولك'**
  String get merchantCancelledFirst;

  /// 409 in another case; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تغيّرت حالة الطلب قبل وصول طلبك'**
  String get merchantStateChanged;

  /// 400 invalid_lines or 409 currency_not_accepted; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'المبالغ لا تطابق قيمة الأصناف أو بعملة لا يقبلها المطعم'**
  String get merchantLinesRefused;

  /// 409 pickup_already_disputed; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'سبق الإبلاغ عن مبلغ هذا الطلب'**
  String get merchantAlreadyDisputed;

  /// Any other refusal; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الإرسال، حاول مجدداً'**
  String get merchantCommandFailed;

  /// The customer's first name and neighbourhood (RA §8.4).
  ///
  /// In ar, this message translates to:
  /// **'{name} — {neighbourhood}'**
  String merchantCustomer(String name, String neighbourhood);

  /// The customer's note (RA §8.4).
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة الزبون: {note}'**
  String merchantCustomerNote(String note);

  /// Ready recorded at pickup (S8).
  ///
  /// In ar, this message translates to:
  /// **'لم يُضغط جاهز'**
  String get merchantReadyNotPressed;

  /// The pickup done (RA §8.10 item 4).
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام'**
  String get merchantPickedUp;

  /// Delivered (RA §8.1).
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get merchantDelivered;

  /// The dispute sheet (RA §8.10 item 6); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'ما المبلغ الذي استلمته فعلاً؟'**
  String get merchantDisputeTitle;

  /// An amount field of the dispute sheet; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ بـ {currency}'**
  String merchantDisputeAmount(String currency);

  /// Sends the dispute; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get merchantSend;

  /// Closes a sheet; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get merchantClose;

  /// Progress step (CU §11.1).
  ///
  /// In ar, this message translates to:
  /// **'تأكيد المطعم'**
  String get customerStepConfirm;

  /// Progress step (CU §11.1).
  ///
  /// In ar, this message translates to:
  /// **'التحضير'**
  String get customerStepPreparing;

  /// Progress step (CU §11.1).
  ///
  /// In ar, this message translates to:
  /// **'في الطريق'**
  String get customerStepOnTheWay;

  /// Progress step (CU §11.1).
  ///
  /// In ar, this message translates to:
  /// **'عند الباب'**
  String get customerStepAtDoor;

  /// Progress step (CU §11.1).
  ///
  /// In ar, this message translates to:
  /// **'التسليم'**
  String get customerStepDelivered;

  /// Captain assigned before pickup (CU §11.2).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن {name} في طريقه إلى المطعم'**
  String customerCaptainToRestaurant(String name);

  /// Captain at the restaurant (CU §11.2).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن {name} وصل إلى المطعم'**
  String customerCaptainAtRestaurant(String name);

  /// Ready, no captain at the restaurant (CU §11.2).
  ///
  /// In ar, this message translates to:
  /// **'ينتظر الكابتن'**
  String get customerAwaitingCaptain;

  /// Ready with the captain there (CU §11.2).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن يستلم طلبك الآن'**
  String get customerCaptainCollecting;

  /// Picked up (CU §11.2).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن {name} استلم طلبك'**
  String customerCaptainPickedUp(String name);

  /// At the door (CU §11.2).
  ///
  /// In ar, this message translates to:
  /// **'جهّز {amount}'**
  String customerPrepareAmount(String amount);

  /// Delivered (CU §11.2).
  ///
  /// In ar, this message translates to:
  /// **'بالعافية!'**
  String get customerEnjoy;

  /// Rejected by the restaurant (CU §11.9).
  ///
  /// In ar, this message translates to:
  /// **'نعتذر، لم يقبل المطعم طلبك'**
  String get customerRejected;

  /// Cancelled for no restaurant response (CU §11.9).
  ///
  /// In ar, this message translates to:
  /// **'لم يرد المطعم على طلبك، نعتذر'**
  String get customerNoRestaurantResponse;

  /// Up to 5 similar restaurants under a rejected or unanswered order (CU §11.9); the spec gives no heading.
  ///
  /// In ar, this message translates to:
  /// **'مطاعم مشابهة'**
  String get customerSimilarRestaurants;

  /// Rebuilds the cart without the unavailable items (CU §11.9, Q22).
  ///
  /// In ar, this message translates to:
  /// **'اطلب بدون الأصناف غير المتوفرة'**
  String get customerOrderWithoutUnavailable;

  /// Asked before a rebuild replaces a cart that is not empty (CU §11.9, §12.3); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'ستُستبدل سلتك الحالية من {current}. هل تتابع؟'**
  String customerReplaceCart(String current);

  /// Lines a rebuild skipped (CU §12.3).
  ///
  /// In ar, this message translates to:
  /// **'لم نضف: {items} لأنها غير متوفرة'**
  String customerNotAdded(String items);

  /// The customer cancelled their own order while placed (CU §11.9).
  ///
  /// In ar, this message translates to:
  /// **'ألغيت طلبك'**
  String get customerCancelledByYou;

  /// Opens the help sheet of an active order (CU §11.5).
  ///
  /// In ar, this message translates to:
  /// **'مساعدة'**
  String get customerHelp;

  /// Calls the support phone number (CU §11.5, AP §9.13 contact info).
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالدعم'**
  String get customerCallSupport;

  /// Opens WhatsApp with the support number (CU §11.5).
  ///
  /// In ar, this message translates to:
  /// **'واتساب الدعم'**
  String get customerWhatsappSupport;

  /// The WhatsApp message prefilled from an order's help sheet (CU §11.5).
  ///
  /// In ar, this message translates to:
  /// **'بخصوص الطلب #{number}'**
  String customerWhatsappOrderMessage(String number);

  /// Cancels the order while placed (CU §11.4); also the reason sheet's title.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get customerCancelOrder;

  /// Sends the cancellation with the chosen reason (CU §11.4).
  ///
  /// In ar, this message translates to:
  /// **'نعم، ألغِ الطلب'**
  String get customerCancelConfirm;

  /// The text of «سبب آخر» (CU §11.4); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اكتب السبب'**
  String get customerCancelReasonNote;

  /// In the help sheet after acceptance (CU §11.4).
  ///
  /// In ar, this message translates to:
  /// **'لإلغاء الطلب تواصل مع الدعم'**
  String get customerCancelViaSupport;

  /// The help sheet's warning after acceptance (CU §11.4, AP §8.8).
  ///
  /// In ar, this message translates to:
  /// **'الإلغاء بعد قبول المطعم يُحتسب عليك، وتكراره قد يوقف حسابك مؤقتاً.'**
  String get customerLateCancelWarning;

  /// The race with acceptance (CU §11.4).
  ///
  /// In ar, this message translates to:
  /// **'قبل المطعم طلبك قبل لحظات. لإلغائه تواصل مع الدعم.'**
  String get customerCancelTooLate;

  /// The panel changed the self-cancel reasons meanwhile; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تغيّرت قائمة الأسباب، اختر السبب مرة أخرى'**
  String get customerCancelReasonsChanged;

  /// The cancellation got no answer; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الإلغاء، حاول مرة أخرى'**
  String get customerCancelFailed;

  /// Cancelled by operations (CU §11.9); the customer-facing reason (CU Appendix C) shows under it.
  ///
  /// In ar, this message translates to:
  /// **'أُلغي طلبك'**
  String get customerCancelled;

  /// Failed after pickup (CU §11.9).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التسليم'**
  String get customerDeliveryFailed;

  /// The active-order bar (CU §6).
  ///
  /// In ar, this message translates to:
  /// **'طلبك من {restaurant}: {status}'**
  String customerActiveOrder(String restaurant, String status);

  /// The active-order bar with several orders (CU §6); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'طلباتك النشطة: {count}'**
  String customerActiveOrders(int count);

  /// Availability (CA §7.1).
  ///
  /// In ar, this message translates to:
  /// **'غير متصل'**
  String get captainStateOffline;

  /// Availability (CA §7.1).
  ///
  /// In ar, this message translates to:
  /// **'متصل متاح'**
  String get captainStateAvailable;

  /// Availability with an active order (CA §7.1).
  ///
  /// In ar, this message translates to:
  /// **'مشغول'**
  String get captainStateBusy;

  /// Last-order mode: no new offers, offline after the order (CA §7.1, §7.3).
  ///
  /// In ar, this message translates to:
  /// **'آخر طلب'**
  String get captainStateLastOrder;

  /// Replaces «متصل» during an active order (CA §7.3, K13).
  ///
  /// In ar, this message translates to:
  /// **'لا أريد طلبات جديدة'**
  String get captainLastOrderSwitch;

  /// Under the switch while last-order mode is on (CA §7.3); the wording is ours.
  ///
  /// In ar, this message translates to:
  /// **'ستصبح غير متصل بعد هذا الطلب.'**
  String get captainLastOrderOn;

  /// Force offline during an order (CA §7.6, K18); the wording is ours.
  ///
  /// In ar, this message translates to:
  /// **'فصلتك العمليات من الاتصال: {reason}. ستصبح غير متصل بعد هذا الطلب.'**
  String captainLastOrderForced(String reason);

  /// C3: offline after unanswered offers in a row (CA §7.4); count is captain.offer_expiry_offline_count, given as text.
  ///
  /// In ar, this message translates to:
  /// **'لم ترد على {count} عروض متتالية، فأصبحت غير متصل. اضغط «متصل» عندما تكون جاهزاً.'**
  String captainOffersExpiredOffline(String count);

  /// A suspension during an order (CA §7.6, K18); the wording is ours.
  ///
  /// In ar, this message translates to:
  /// **'حسابك موقوف: {reason}. أكمل هذا الطلب ثم تصبح غير متصل.'**
  String captainLastOrderSuspended(String reason);

  /// A contract end during an order (CA §7.2, K18); the wording is ours.
  ///
  /// In ar, this message translates to:
  /// **'انتهى تعاقدك مع FOX DROP. أكمل هذا الطلب ثم تصبح غير متصل.'**
  String get captainLastOrderTerminated;

  /// Refused cancelling a last-order mode operations set (CA §7.6); the wording is ours.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكنك إلغاء هذا الوضع: وضعته العمليات.'**
  String get captainLastOrderNotYours;

  /// Online without offers (CA §7.1); the reason follows.
  ///
  /// In ar, this message translates to:
  /// **'لا تصلك عروض'**
  String get captainStateNoOffers;

  /// Suspended (CA §7.1).
  ///
  /// In ar, this message translates to:
  /// **'موقوف'**
  String get captainStateSuspended;

  /// The home switch (CA §7.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'متصل'**
  String get captainOnlineSwitch;

  /// The cash held (CA Appendix B, Home), and the hand-in reminder after going offline (CA §7.5) until the office fields give its hours.
  ///
  /// In ar, this message translates to:
  /// **'عليك تسليم {amount}'**
  String captainOwes(String amount);

  /// At the cash limit (CA §7.2).
  ///
  /// In ar, this message translates to:
  /// **'بلغت حد العهدة ({amount}). سلّم النقد في المكتب لتصلك العروض.'**
  String captainNoOffersCashLimit(String amount);

  /// Cash from a closed day past the grace while online (CA §7.2). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لديك نقد غير مسلّم: {amount}. سلّمه في المكتب لتصلك العروض.'**
  String captainNoOffersClosedDue(String amount);

  /// A simulated location is active (CA §7.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'أوقف تطبيقات تغيير الموقع لتتمكن من الاتصال.'**
  String get captainStopMockLocation;

  /// Going online is blocked by cash from a previous business day (CA §7.2); the office hours and map come with the office fields.
  ///
  /// In ar, this message translates to:
  /// **'لديك نقد غير مسلّم من يوم {date}: {amount}. سلّمه في المكتب لتتمكن من الاتصال.'**
  String captainBlockClosedDue(String date, String amount);

  /// Suspended with an end (CA §7.2); «اعتراض» comes with appeals.
  ///
  /// In ar, this message translates to:
  /// **'حسابك موقوف حتى {date}: {reason}'**
  String captainBlockSuspendedUntil(String date, String reason);

  /// Suspended until further notice (CA §7.2). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'حسابك موقوف: {reason}'**
  String captainBlockSuspended(String reason);

  /// The app is below the minimum version (CA §7.2); the update screen comes with its slice. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'حدّث التطبيق إلى الإصدار {version} لتتمكن من الاتصال.'**
  String captainBlockVersion(String version);

  /// The foreground service notification while online (CA §4.3, owner decision 2026-11-07).
  ///
  /// In ar, this message translates to:
  /// **'أنت متصل — FOX DROP يتابع موقعك لتصلك العروض'**
  String get captainTrackingNotice;

  /// The phone location is off. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'شغّل الموقع في هاتفك لتتمكن من الاتصال.'**
  String get captainLocationOff;

  /// The location permission was refused. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اسمح لتطبيق الكابتن بالوصول إلى موقعك لتتمكن من الاتصال.'**
  String get captainLocationDenied;

  /// No position came. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحديد موقعك، حاول مرة أخرى.'**
  String get captainLocationFailed;

  /// The red bar while offline (CA §4.6).
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت — لن تصلك العروض حتى يعود الاتصال'**
  String get captainNoConnection;

  /// Closes a message.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get captainOk;

  /// A command waiting for the server (CA §4.6).
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الإرسال…'**
  String get captainSending;

  /// A command the server refused for another reason. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الإرسال، حاول مرة أخرى.'**
  String get captainCommandFailed;

  /// A command found the order changed (CA §4.6). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تغيّرت حالة الطلب قبل وصول طلبك.'**
  String get captainStateChanged;

  /// A command while the server sees the captain offline. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أنت غير متصل.'**
  String get captainNotOnline;

  /// The fix was too old for the server. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لم يتحدّد موقعك بعد، حاول بعد لحظات.'**
  String get captainStaleLocation;

  /// Going offline with an active order (K13). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكنك قطع الاتصال أثناء طلب.'**
  String get captainOfflineWithOrder;

  /// The offer sheet title (CA §8.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'عرض جديد'**
  String get captainNewOffer;

  /// A manual assignment as an offer (CA §8.4).
  ///
  /// In ar, this message translates to:
  /// **'تعيين من العمليات'**
  String get captainOfferFromOperations;

  /// The restaurant and its distance from the captain (CA §8.2).
  ///
  /// In ar, this message translates to:
  /// **'{restaurant} · {distance}'**
  String captainOfferRestaurant(String restaurant, String distance);

  /// The customer neighbourhood and the trip (CA §8.2).
  ///
  /// In ar, this message translates to:
  /// **'{neighbourhood} · {distance}'**
  String captainOfferCustomer(String neighbourhood, String distance);

  /// The pickup payment (CA §8.2, §9.2).
  ///
  /// In ar, this message translates to:
  /// **'تدفع للمطعم: {amount}'**
  String captainPayToRestaurant(String amount);

  /// The amount to collect (CA §8.2, §9.5).
  ///
  /// In ar, this message translates to:
  /// **'تقبض من الزبون: {amount}'**
  String captainCollectFromCustomer(String amount);

  /// The offer preparation state (CA §8.2).
  ///
  /// In ar, this message translates to:
  /// **'قيد التحضير — جاهز بعد {minutes} د تقريباً'**
  String captainOfferPreparing(int minutes);

  /// Step 1 preparation state (CA §9.2).
  ///
  /// In ar, this message translates to:
  /// **'قيد التحضير — جاهز بعد {minutes} د'**
  String captainPreparing(int minutes);

  /// Ready (CA §8.2, §9.2).
  ///
  /// In ar, this message translates to:
  /// **'جاهز'**
  String get captainReady;

  /// Under the offer pay (CA §8.2).
  ///
  /// In ar, this message translates to:
  /// **'قد يُضاف أجر انتظار'**
  String get captainWaitingPayMayApply;

  /// An offer without a pay table. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الأجر غير محدد'**
  String get captainOfferNoPay;

  /// Accept the offer (CA §8.3).
  ///
  /// In ar, this message translates to:
  /// **'قبول'**
  String get captainAccept;

  /// Reject the offer (CA §8.3).
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get captainDecline;

  /// The offer expired (CA §8.3).
  ///
  /// In ar, this message translates to:
  /// **'انتهى العرض'**
  String get captainOfferExpired;

  /// The offer was taken or withdrawn (CA §8.3, §14).
  ///
  /// In ar, this message translates to:
  /// **'لم يعد العرض متاحاً'**
  String get captainOfferUnavailable;

  /// Assigned by operations without an offer (CA §14 item 4).
  ///
  /// In ar, this message translates to:
  /// **'عيّنتك العمليات على طلب #{number}'**
  String captainOpsAssigned(String number);

  /// The progress bar of the active order (CA §9.1). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة {step} من 4: {name}'**
  String captainStep(int step, String name);

  /// Step 1 (CA §9.1).
  ///
  /// In ar, this message translates to:
  /// **'إلى المطعم'**
  String get captainStepToRestaurant;

  /// Step 2 (CA §9.1).
  ///
  /// In ar, this message translates to:
  /// **'عند المطعم'**
  String get captainStepAtRestaurant;

  /// Step 3 (CA §9.1).
  ///
  /// In ar, this message translates to:
  /// **'إلى الزبون'**
  String get captainStepToCustomer;

  /// Step 4 (CA §9.1).
  ///
  /// In ar, this message translates to:
  /// **'عند الزبون'**
  String get captainStepAtCustomer;

  /// The order number and item count (CA §9.2). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الطلب #{number} · الأصناف: {count}'**
  String captainOrderItems(String number, int count);

  /// Opens Google Maps (CA §4.6).
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الملاحة'**
  String get captainStartNavigation;

  /// Calls the restaurant (CA §9.2).
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالمطعم'**
  String get captainCallRestaurant;

  /// Step 1 main button (CA §9.2).
  ///
  /// In ar, this message translates to:
  /// **'وصلت إلى المطعم'**
  String get captainArrivedAtRestaurant;

  /// The banner within the radius (CA §9.2).
  ///
  /// In ar, this message translates to:
  /// **'هل وصلت إلى المطعم؟'**
  String get captainArrivedQuestion;

  /// Outside the radius (CA §9.2).
  ///
  /// In ar, this message translates to:
  /// **'اقترب من المطعم لتأكيد الوصول'**
  String get captainGetCloser;

  /// GPS worse than 100 m (K3).
  ///
  /// In ar, this message translates to:
  /// **'إشارة الموقع ضعيفة — اتصل بالعمليات لتسجيل وصولك'**
  String get captainWeakGps;

  /// The distance from the latest fix. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'على بعد {distance}'**
  String captainDistanceAway(String distance);

  /// The waiting timer from arrival (CA §9.3). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تنتظر منذ {duration}'**
  String captainWaitingSince(String duration);

  /// The restaurant pressed ready (CA §9.3).
  ///
  /// In ar, this message translates to:
  /// **'الطلب جاهز'**
  String get captainOrderReadyNow;

  /// The ready chime (CA §14 item 5).
  ///
  /// In ar, this message translates to:
  /// **'الطلب #{number} جاهز'**
  String captainOrderReadyChime(String number);

  /// Above the item check (C7).
  ///
  /// In ar, this message translates to:
  /// **'بعد تأكيد الأصناف يصبح أي نقص من مسؤوليتك'**
  String get captainItemsResponsibility;

  /// An item line of the check (C7). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'{quantity} × {name}'**
  String captainLine(int quantity, String name);

  /// The payment section (CA §9.3).
  ///
  /// In ar, this message translates to:
  /// **'ادفع للمطعم: {amount}'**
  String captainPayRestaurant(String amount);

  /// Step 2 main button (CA §9.4).
  ///
  /// In ar, this message translates to:
  /// **'دفعت للمطعم واستلمت الطلب'**
  String get captainPaidAndPickedUp;

  /// The open pickup request (CA §9.4).
  ///
  /// In ar, this message translates to:
  /// **'بانتظار تأكيد المطعم'**
  String get captainAwaitingRestaurant;

  /// The payment lines refused (CA §9.4).
  ///
  /// In ar, this message translates to:
  /// **'المبلغ لا يطابق المطلوب'**
  String get captainAmountMismatch;

  /// The restaurant answered «المبلغ غير صحيح» (CA §9.4).
  ///
  /// In ar, this message translates to:
  /// **'المطعم يفيد بأنه استلم {amount}. أكمل المبلغ ثم أعد التأكيد.'**
  String captainRestaurantReceived(String amount);

  /// The restaurant answered «الطلب غير مكتمل» (CA §9.4).
  ///
  /// In ar, this message translates to:
  /// **'المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.'**
  String get captainRestaurantIncomplete;

  /// Pickup confirmed (CA §9.4, §14 item 7).
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام — توجّه إلى الزبون'**
  String get captainPickedUp;

  /// Pickup confirmed by operations (CA §9.4).
  ///
  /// In ar, this message translates to:
  /// **'أكّدت العمليات الاستلام'**
  String get captainOpsConfirmedPickup;

  /// Dispute after pickup (CA §9.4).
  ///
  /// In ar, this message translates to:
  /// **'فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات'**
  String get captainPickupDisputed;

  /// The address floor (CA §9.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الطابق: {floor}'**
  String captainFloor(String floor);

  /// The customer note (CA §9.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة: {note}'**
  String captainNote(String note);

  /// The pay-in currency (CA §9.5, CU U10).
  ///
  /// In ar, this message translates to:
  /// **'الزبون سيدفع بـ {currency}'**
  String captainPayIn(String currency);

  /// The promised time (CA §9.5).
  ///
  /// In ar, this message translates to:
  /// **'التسليم المتوقع قبل {time}'**
  String captainPromisedBefore(String time);

  /// Calls the customer (C10).
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالزبون'**
  String get captainCallCustomer;

  /// WhatsApp to the customer (C10).
  ///
  /// In ar, this message translates to:
  /// **'واتساب الزبون'**
  String get captainWhatsAppCustomer;

  /// Step 3 main button (CA §9.6).
  ///
  /// In ar, this message translates to:
  /// **'وصلت'**
  String get captainArrivedAtCustomer;

  /// The reason sheet away from the pin (K4, C9). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أنت بعيد عن موقع الزبون. اختر السبب:'**
  String get captainAwayTitle;

  /// The problem button on every step of the active order, and the sheet's title (CA §9.11).
  ///
  /// In ar, this message translates to:
  /// **'مشكلة'**
  String get captainProblem;

  /// Inside «مشكلة»: asks operations to take the order (C5, CA §9.11).
  ///
  /// In ar, this message translates to:
  /// **'لا أستطيع إكمال الطلب'**
  String get captainCannotComplete;

  /// The reason sheet of «لا أستطيع إكمال الطلب» (CA Appendix C). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لماذا لا تستطيع إكمال الطلب؟'**
  String get captainCannotCompleteTitle;

  /// While the captain's «لا أستطيع إكمال الطلب» is open (CA §9.11, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'بانتظار العمليات'**
  String get captainAwaitingOperations;

  /// Under «بانتظار العمليات», with the reason's label. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أبلغت العمليات أنك لا تستطيع إكمال الطلب: {reason}. أكمل حتى تتصرف العمليات.'**
  String captainCannotCompleteSent(String reason);

  /// Withdraws the «لا أستطيع إكمال الطلب» request (CA §9.11, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get captainWithdrawRequest;

  /// The red emergency button on the active order (C15, CA §9.11, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'طوارئ'**
  String get captainEmergency;

  /// Under «طوارئ»: the 2-second press of K12. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اضغط مطوّلاً ثانيتين للاتصال بالعمليات وإرسال موقعك'**
  String get captainEmergencyHold;

  /// Above «طوارئ» once the emergency is open; it cannot be withdrawn. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أُبلغت العمليات بالطوارئ وموقعك. ابقَ في مكان آمن.'**
  String get captainEmergencySent;

  /// Above «طوارئ» once open, when the phone had no fix to send. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أُبلغت العمليات بالطوارئ، ولم يصل موقعك. ابقَ في مكان آمن.'**
  String get captainEmergencySentNoLocation;

  /// «طوارئ» without an operations number on the phone. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لم يصل رقم العمليات إلى هاتفك بعد، فلم يتصل. أُبلغت العمليات بالطوارئ.'**
  String get captainEmergencyNoNumber;

  /// The text of «أخرى». The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اكتب السبب'**
  String get captainOtherHint;

  /// Sends a reason. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get captainSend;

  /// Door payment (CA §9.7).
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المطلوب'**
  String get captainAmountDue;

  /// Door payment (CA §9.7).
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المقبوض'**
  String get captainAmountReceived;

  /// Door payment (CA §9.7).
  ///
  /// In ar, this message translates to:
  /// **'الباقي للزبون'**
  String get captainChange;

  /// The change the app computed (CA §9.7 item 3). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الباقي: {amount}'**
  String captainChangeDue(String amount);

  /// Collected short (CA §9.7, K16).
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المقبوض أقل من المطلوب بـ {amount}'**
  String captainShortBy(String amount);

  /// Net above due (CA §9.7).
  ///
  /// In ar, this message translates to:
  /// **'سجّل الباقي الذي أعدته للزبون'**
  String get captainOverpaid;

  /// The amount due changed (CA §9.7).
  ///
  /// In ar, this message translates to:
  /// **'تغيّر المبلغ المطلوب إلى {amount}'**
  String captainAmountDueChanged(String amount);

  /// Tips (K14).
  ///
  /// In ar, this message translates to:
  /// **'إذا ترك لك الزبون الباقي إكرامية فهو لك، سجّله كأنك أعدته'**
  String get captainTip;

  /// The captain's settings screen and its link on home (CA Appendix B, owner decision 2026-11-11).
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get captainSettings;

  /// Carried currencies (CA §10.5).
  ///
  /// In ar, this message translates to:
  /// **'العملات التي أحملها'**
  String get captainCarriedCurrencies;

  /// Under «العملات التي أحملها» (CA §10.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'يُقترح عليك دفع المطعم بعملة تحملها ويقبلها المطعم.'**
  String get captainCarriedCurrenciesExplain;

  /// The base currency's switch (CA §10.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'العملة الأساسية'**
  String get captainBaseCurrency;

  /// The maximum pickup amount on «الإعدادات» and the question at «متصل» (CA §10.5, K2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'أقصى مبلغ أحمله'**
  String get captainMaxPickup;

  /// Under «أقصى مبلغ أحمله» (CA §8.1, C4). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لن تصلك العروض الآلية التي تدفع فيها للمطعم أكثر من هذا المبلغ.'**
  String get captainMaxPickupExplain;

  /// No maximum pickup amount set (K2: empty is no limit). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'بلا حد الآن'**
  String get captainMaxPickupNone;

  /// The maximum pickup amount set (CA §10.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الحد الآن: {amount}'**
  String captainMaxPickupCurrent(String amount);

  /// The field of the maximum pickup amount, in the base currency. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get captainMaxPickupField;

  /// The typed maximum pickup amount is not an amount above zero. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اكتب مبلغاً أكبر من صفر.'**
  String get captainMaxPickupInvalid;

  /// Sets no maximum pickup amount (K2). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'بلا حد'**
  String get captainMaxPickupNoLimit;

  /// A manual offer above the captain's maximum pickup amount (CA §8.4, K2).
  ///
  /// In ar, this message translates to:
  /// **'المبلغ أكبر من الحد الذي حددته — اقبل فقط إذا كان معك ما يكفي'**
  String get captainOfferAboveMaxPickup;

  /// A settings change the server did not take. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لم يُحفظ التغيير، حاول مرة أخرى'**
  String get captainSaveFailed;

  /// Reads the settings again after a failure. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get captainRetry;

  /// Opens one field per currency the restaurant accepts (C8, CA §10.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تقسيم المبلغ أو تعديله'**
  String get captainSplitPickup;

  /// A field of the pickup's split (C8): the currency and the whole pickup payment in it. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'بـ {currency} (المطلوب كاملاً {amount})'**
  String captainPickupIn(String currency, String amount);

  /// An amount that is not a number. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أدخل مبلغاً صحيحاً'**
  String get captainInvalidAmount;

  /// Step 4 main button (CA §9.8).
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get captainDelivered;

  /// The summary (CA §9.8).
  ///
  /// In ar, this message translates to:
  /// **'ربحت من هذا الطلب: {amount}'**
  String captainEarned(String amount);

  /// The summary pay part (CA §9.8). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الأجر الأساسي: {amount}'**
  String captainPayBase(String amount);

  /// The summary pay part (CA §9.8). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أجر المسافة: {amount}'**
  String captainPayDistance(String amount);

  /// The summary pay part (CA §9.8, AP §8.4).
  ///
  /// In ar, this message translates to:
  /// **'إكمال للحد الأدنى: {amount}'**
  String captainPayTopUp(String amount);

  /// The summary pay part (CA §9.8). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أجر الانتظار: {amount}'**
  String captainPayWaiting(String amount);

  /// The summary (CA §9.8).
  ///
  /// In ar, this message translates to:
  /// **'تغيّرت عهدتك: {amount}'**
  String captainCustodyChanged(String amount);

  /// The summary (CA §9.8).
  ///
  /// In ar, this message translates to:
  /// **'عليك تسليم اليوم: {amount}'**
  String captainHandInToday(String amount);

  /// Goes offline from the summary (CA §9.8).
  ///
  /// In ar, this message translates to:
  /// **'إنهاء العمل'**
  String get captainEndWork;

  /// Closes the summary, still online (CA §9.8). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'متابعة العمل'**
  String get captainKeepWorking;

  /// «تم التسليم» pressed without the shortfall reason (K16). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اختر السبب'**
  String get captainChooseReason;

  /// The FAQ screen (AP §9.13 «الأسئلة الشائعة»).
  ///
  /// In ar, this message translates to:
  /// **'الأسئلة الشائعة'**
  String get faqTitle;

  /// An empty FAQ set. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أسئلة بعد'**
  String get faqEmpty;

  /// Content's lists or texts could not be read. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التحميل، اضغط لإعادة المحاولة'**
  String get contentFailed;

  /// The work rules page (CA §11.4). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'قواعد العمل'**
  String get captainWorkRules;

  /// The reason sent is no longer in its Content list (AP §9.13). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تغيّرت قائمة الأسباب، اختر السبب من جديد'**
  String get captainReasonChanged;

  /// The notification permission at the first order (CU §4.4, Q11).
  ///
  /// In ar, this message translates to:
  /// **'اسمح بالإشعارات لتعرف متى يصل طلبك'**
  String get customerNotificationsAsk;

  /// Allows notifications at the first order, then the phone asks (CU §4.4). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'سماح'**
  String get customerNotificationsAllow;

  /// Declines notifications at the first order; the order still goes (CU §4.4). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'ليس الآن'**
  String get customerNotificationsNotNow;

  /// The order screen's banner after notifications were refused (CU §4.4). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات متوقفة. فعّلها لتعرف متى يصل طلبك'**
  String get customerNotificationsOff;

  /// Opens the phone's settings from the notifications banner (CU §4.4). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get customerNotificationsOpenSettings;

  /// The account's notifications (CU §13, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get customerNotificationsTitle;

  /// «الإشعارات» with no push in the last 30 days (CU §13). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get customerNotificationsEmpty;

  /// The blocking update screen below app.<app>.min_version (CU §4.2, RA §4.2, CA §4.2). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'يلزم تحديث التطبيق'**
  String get platformUpdateRequiredTitle;

  /// The update screen's text while app.<app>.update_message is unset. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'هذا الإصدار لم يعد يعمل. حدّث التطبيق لتتابع.'**
  String get platformUpdateRequiredMessage;

  /// The dismissible banner below app.<app>.latest_version, while app.<app>.update_message is unset. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'يتوفر إصدار أحدث من التطبيق.'**
  String get platformUpdateSuggested;

  /// Opens the store or the download page for the update. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get platformUpdate;

  /// Dismisses the update banner for this run of the app. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لاحقاً'**
  String get platformLater;

  /// The blocking maintenance screen while app.<app>.maintenance is on (CU §4.7, RA §4.10, CA §4.8). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'التطبيق في صيانة'**
  String get platformMaintenanceTitle;

  /// The maintenance screen's text while its message is unset. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'نعمل على تحسين الخدمة ونعود قريباً.'**
  String get platformMaintenanceMessage;

  /// The terms and privacy screen (AP §9.13, CU §13 «الشروط والخصوصية»).
  ///
  /// In ar, this message translates to:
  /// **'الشروط والخصوصية'**
  String get termsTitle;

  /// Above a pending version of the terms (CU §4.7, CA §4.8, RA §4.10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'نشرت FOX DROP نسخة جديدة من الشروط وسياسة الخصوصية. اقرأها ووافق عليها لتتابع.'**
  String get termsNewVersion;

  /// Accepts the version shown (CU §15, CA §15 «Accept terms»), as the sign-up's tick reads (CU §5.3).
  ///
  /// In ar, this message translates to:
  /// **'أوافق على الشروط وسياسة الخصوصية'**
  String get termsAccept;

  /// The server answered 409 terms_outdated: a newer version replaced the one shown. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'نُشرت نسخة أحدث بينما كنت تقرأ. اقرأها ثم وافق.'**
  String get termsOutdated;

  /// Reading or accepting the terms failed. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الاتصال بالخادم، حاول مرة أخرى'**
  String get termsFailed;

  /// The customer's banner and checkout problem while a version is pending (CU §6.2 item 5, Appendix C «Terms pending»).
  ///
  /// In ar, this message translates to:
  /// **'وافق على الشروط الجديدة لتتمكن من الطلب'**
  String get customerTermsPending;

  /// Opens the terms (CU Appendix C «Terms pending» action).
  ///
  /// In ar, this message translates to:
  /// **'عرض الشروط'**
  String get customerTermsShow;

  /// The captain's home while a version is pending: going online waits for it (K7, CA §4.8). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'وافق على الشروط الجديدة لتتمكن من الاتصال'**
  String get captainTermsPendingBanner;

  /// An owner's board while a version is pending (RA §4.10, S13). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'وافق على الشروط الجديدة لتستخدم شاشات المطعم الأخرى. الطلبات تصل كالمعتاد.'**
  String get merchantTermsPendingBanner;

  /// The red banner of the restaurant and captain apps while the platform's emergency stop is on (RA §8.17, CA §6.3 item 2).
  ///
  /// In ar, this message translates to:
  /// **'المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.'**
  String get emergencyStopBanner;

  /// Checkout's emergency_stop problem when the server sends no browsing message (it always does; CU Appendix C «Emergency stop»). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن استقبال الطلبات الآن'**
  String get customerCannotOrderNow;

  /// Restaurant state «Open» (RA §7.1, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'مفتوح'**
  String get merchantStatusOpen;

  /// Busy mode on, the pill and the sheet's first busy-mode button (RA §7.1, §7.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'وضع الضغط +{minutes} د'**
  String merchantStatusBusyMode(int minutes);

  /// The status sheet's other busy-mode buttons, such as «+20 د» (RA §7.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'+{minutes} د'**
  String merchantStatusBusyExtra(int minutes);

  /// Restaurant state at the maximum active orders (RA §7.1, §7.4, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'مشغول'**
  String get merchantStatusBusy;

  /// Restaurant state paused by the restaurant (RA §7.1, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'موقوف مؤقتاً'**
  String get merchantStatusPaused;

  /// Restaurant state paused by operations (RA §7.1, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'أوقفته العمليات'**
  String get merchantStatusPausedByOperations;

  /// Restaurant state auto-paused after unanswered orders (RA §7.1, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'أُوقف تلقائياً'**
  String get merchantStatusAutoPaused;

  /// Restaurant state closed by the schedule (RA §7.1, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'مغلق'**
  String get merchantStatusClosed;

  /// Restaurant state on a holiday close (RA §7.1, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'إجازة حتى {date}'**
  String merchantStatusHoliday(String date);

  /// Restaurant state suspended (RA §7.1, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'معلّق'**
  String get merchantStatusSuspended;

  /// The pill of a draft or terminated restaurant, which takes no orders (AP §9.6.1). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'غير مفعّل'**
  String get merchantStatusInactive;

  /// The status sheet's first pause button, «إيقاف 15 د» (RA §7.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'إيقاف {minutes} د'**
  String merchantStatusPauseFirst(int minutes);

  /// The status sheet's other pause buttons, «30 د» and «60 د» (RA §7.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'{minutes} د'**
  String merchantStatusMinutes(int minutes);

  /// The pause until the end of the opening period (RA §7.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'حتى أعيد الفتح'**
  String get merchantStatusPauseUntilReopening;

  /// Turns busy mode off (RA §7.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'إلغاء وضع الضغط'**
  String get merchantStatusBusyModeOff;

  /// Ends the restaurant's own pause (RA §7.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'استئناف الاستقبال'**
  String get merchantStatusResume;

  /// Why the status sheet's buttons are off while operations or the auto-pause paused the restaurant, and its red banner (RA §7.2, §6.3 item 3).
  ///
  /// In ar, this message translates to:
  /// **'أوقفت العمليات مطعمك — اتصل بهم لإعادة التشغيل'**
  String get merchantStatusLockedByOperations;

  /// «يغلق اليوم 11:30 م» (RA §7.2).
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get merchantStatusToday;

  /// The next schedule change inside an opening period, «يغلق اليوم 11:30 م» (RA §7.2).
  ///
  /// In ar, this message translates to:
  /// **'يغلق {when}'**
  String merchantStatusClosesAt(String when);

  /// The next schedule change while closed by the schedule (RA §7.2). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'يفتح {when}'**
  String merchantStatusOpensAt(String when);

  /// When the pause ends, the status sheet's remaining time (RA §7.2). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'ينتهي الإيقاف {when}'**
  String merchantStatusPauseEnds(String when);

  /// The amber banner at the maximum active orders (RA §7.4, §6.3 item 6, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'وصلت إلى الحد الأقصى ({count} طلبات جارية). لن تصلك طلبات جديدة حتى يُستلم أحدها.'**
  String merchantStatusLimitBanner(int count);

  /// The amber banner while busy mode is on (RA §6.3 item 6, §7.3). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'وضع الضغط مفعّل: +{minutes} د على وقت الطلبات الجديدة'**
  String merchantStatusBusyModeBanner(int minutes);

  /// The server refused a pause or busy mode because the restaurant is not open (RA §18). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'المطعم ليس مفتوحاً الآن'**
  String get merchantStatusRefusedClosed;

  /// A status command failed for another reason. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التنفيذ، حاول مرة أخرى'**
  String get merchantStatusRefusedOther;

  /// The chime's notice of the auto-pause (RA §16 #3).
  ///
  /// In ar, this message translates to:
  /// **'أُوقف مطعمك تلقائياً بعد {count} طلبات دون رد. تواصل مع العمليات لإعادة التشغيل.'**
  String merchantNoticeAutoPaused(int count);

  /// The chime's notice of a pause that ended on its own (RA §16 #24).
  ///
  /// In ar, this message translates to:
  /// **'انتهى الإيقاف المؤقت — مطعمك يستقبل الطلبات'**
  String get merchantNoticePauseEnded;

  /// Busy mode's hourly reminder (RA §7.3, §16 #25).
  ///
  /// In ar, this message translates to:
  /// **'وضع الضغط ما زال مفعّلاً (+{minutes} د)'**
  String merchantNoticeBusyReminder(int minutes);

  /// The chime's notice of a pause by operations (RA §16 #23).
  ///
  /// In ar, this message translates to:
  /// **'أوقفت العمليات مطعمك مؤقتاً: {reason}'**
  String merchantNoticePausedByOperations(String reason);

  /// The chime's notice of operations resuming the restaurant (RA §16 #23).
  ///
  /// In ar, this message translates to:
  /// **'أعادت العمليات تشغيل مطعمك'**
  String get merchantNoticeResumedByOperations;

  /// The chime's notice of operations ending busy mode (RA §16 #23).
  ///
  /// In ar, this message translates to:
  /// **'أنهت العمليات وضع الضغط'**
  String get merchantNoticeBusyEndedByOperations;

  /// The status and hours screen (RA §6.1 #4, §10).
  ///
  /// In ar, this message translates to:
  /// **'الحالة والأوقات'**
  String get merchantStatusAndHours;

  /// The weekly schedule's heading (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'جدول الأسبوع'**
  String get merchantHoursSchedule;

  /// A weekday without an opening period (RA §10).
  ///
  /// In ar, this message translates to:
  /// **'مغلق طوال اليوم'**
  String get merchantHoursClosedAllDay;

  /// Adds an opening period to a weekday (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إضافة فترة'**
  String get merchantHoursAddPeriod;

  /// Between a period's opening and closing times (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إلى'**
  String get merchantHoursTo;

  /// Removes an opening period (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'حذف الفترة'**
  String get merchantHoursRemovePeriod;

  /// A save of the status and hours screen answered; it applies at once (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'حُفظ التعديل'**
  String get merchantHoursSaved;

  /// The server refused the weekly schedule (RA §10: no overlap, 30 minutes or more). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الفترات متداخلة أو أقصر من 30 دقيقة'**
  String get merchantHoursInvalidSchedule;

  /// The server refused the holiday close's moments (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اختر موعد انتهاء بعد موعد البداية'**
  String get merchantHoursInvalidHoliday;

  /// The server refused the default prep time or the maximum (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'القيمة خارج الحدود المسموحة'**
  String get merchantHoursInvalidSettings;

  /// The holiday close (RA §10).
  ///
  /// In ar, this message translates to:
  /// **'إغلاق لعدة أيام'**
  String get merchantHoursHoliday;

  /// The holiday close in force or set (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'مغلق من {from} حتى {to}'**
  String merchantHoursHolidayFromTo(String from, String to);

  /// Ends the holiday close, or cancels the one set (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إنهاء الإغلاق'**
  String get merchantHoursEndHoliday;

  /// The holiday close starts now; tap to choose a moment (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'من الآن'**
  String get merchantHoursFromNow;

  /// The holiday close's chosen start (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'من {when}'**
  String merchantHoursFrom(String when);

  /// The holiday close's end, not chosen yet (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'حتى… اختر التاريخ والساعة'**
  String get merchantHoursUntilPick;

  /// The holiday close's chosen end (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'حتى {when}'**
  String merchantHoursUntil(String when);

  /// The holiday close's optional message, up to 100 characters (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'رسالة للزبائن (اختياري)'**
  String get merchantHoursHolidayMessage;

  /// Sets the holiday close (RA §10). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق المطعم'**
  String get merchantHoursCloseHoliday;

  /// The default prep time, preselected on the accept prompt (RA §10, §8.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'وقت التحضير الافتراضي'**
  String get merchantHoursDefaultPrep;

  /// The maximum active orders (RA §7.4).
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى للطلبات الجارية'**
  String get merchantHoursMaxActiveOrders;

  /// The maximum active orders off, the default (RA §7.4). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'بلا حد'**
  String get merchantHoursNoLimit;

  /// The read-only fields an admin sets (RA §10, R13). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تحددها FOX DROP'**
  String get merchantHoursSetByFoxDrop;

  /// Read-only (RA §10, R13). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للطلب'**
  String get merchantHoursMinimumOrder;

  /// Read-only delivery coverage (RA §10, R13). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'منطقة التوصيل'**
  String get merchantHoursCoverage;

  /// Coverage by a radius (owner decision 2026-11-06). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'حتى {distance} من المطعم'**
  String merchantHoursCoverageRadius(String distance);

  /// Coverage by the city's zones (owner decision 2026-11-06). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'{count} مناطق'**
  String merchantHoursCoverageZones(int count);

  /// Read-only commission (RA §10, R13). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'العمولة'**
  String get merchantHoursCommission;

  /// A percentage, such as the commission «15%».
  ///
  /// In ar, this message translates to:
  /// **'{value}%'**
  String merchantHoursPercent(String value);

  /// Read-only settlement day (RA §10, R13). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'يوم التسوية'**
  String get merchantHoursSettlementDay;

  /// The reject button of the new-order prompt (RA §8.3, §8.6).
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get merchantReject;

  /// The reject sheet's title (RA §8.6); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'رفض الطلب #{number}'**
  String merchantRejectTitle(String number);

  /// Rejection reason (RA §8.6, R3).
  ///
  /// In ar, this message translates to:
  /// **'صنف غير متوفر'**
  String get merchantRejectItemUnavailable;

  /// Rejection reason (RA §8.6, R3).
  ///
  /// In ar, this message translates to:
  /// **'المطعم مغلق'**
  String get merchantRejectRestaurantClosed;

  /// Rejection reason (RA §8.6, R3).
  ///
  /// In ar, this message translates to:
  /// **'ضغط طلبات'**
  String get merchantRejectTooBusy;

  /// The item step of «صنف غير متوفر» (RA §8.6); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'اختر الأصناف غير المتوفرة'**
  String get merchantRejectPickItems;

  /// An item off until the next business day (RA §8.6, §9.3), the default.
  ///
  /// In ar, this message translates to:
  /// **'حتى الغد'**
  String get merchantRejectUntilTomorrow;

  /// An item off until turned back on (RA §8.6, §9.3).
  ///
  /// In ar, this message translates to:
  /// **'حتى أعيده'**
  String get merchantRejectUntilTurnedBackOn;

  /// The note of «المطعم مغلق» (RA §8.6).
  ///
  /// In ar, this message translates to:
  /// **'سيتوقف مطعمك عن استقبال الطلبات حتى تعيد الفتح'**
  String get merchantRejectClosedNote;

  /// «ضغط طلبات» without busy mode or a pause (RA §8.6: optional); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الرفض فقط'**
  String get merchantRejectNothingElse;

  /// «ضغط طلبات» with busy mode (RA §8.6, §7.3).
  ///
  /// In ar, this message translates to:
  /// **'تفعيل وضع الضغط +{minutes} د'**
  String merchantRejectBusyMode(int minutes);

  /// «ضغط طلبات» with a pause (RA §8.6: «إيقاف 30 د»).
  ///
  /// In ar, this message translates to:
  /// **'إيقاف {minutes} د'**
  String merchantRejectPause(int minutes);

  /// Sends the rejection (RA §8.6); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الرفض'**
  String get merchantRejectConfirm;

  /// 400 unknown_reason or invalid_rejection; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الرفض بهذه الاختيارات، راجعها ثم أعد المحاولة'**
  String get merchantRejectRefused;

  /// 409 on a rejected order, by another device or operations; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'رُفض الطلب قبل وصول طلبك'**
  String get merchantRejectedFirst;

  /// Accepted by operations (RA §8.15, §16 #5).
  ///
  /// In ar, this message translates to:
  /// **'قبلت العمليات الطلب #{number} نيابة عنكم — وقت التحضير {minutes} د'**
  String merchantAcceptedByOperations(String number, int minutes);

  /// Rejected by operations (RA §8.15, §16 #6).
  ///
  /// In ar, this message translates to:
  /// **'رفضت العمليات الطلب #{number}: {reason}'**
  String merchantRejectedByOperations(String number, String reason);

  /// The card's badge of an order operations accepted (RA §8.15).
  ///
  /// In ar, this message translates to:
  /// **'قبلته العمليات'**
  String get merchantBadgeByOperations;

  /// The ring prompt after operations cancelled an accepted order, until «حسناً» on any device (RA §8.14, §16 #18); {reason} is the reason's label.
  ///
  /// In ar, this message translates to:
  /// **'أوقف التحضير — أُلغي الطلب #{number}: {reason}'**
  String merchantCancelledByOperations(String number, String reason);

  /// Acknowledges operations' cancellation and stops the ring on every device (RA §8.14, §18).
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get merchantOk;

  /// The cancellation card after operations cancelled the captain's order (CA §9.10, §14 #11); {reason} is the reason's label.
  ///
  /// In ar, this message translates to:
  /// **'أُلغيت المهمة: {reason}'**
  String captainTaskCancelled(String reason);

  /// The withdrawal card after operations took the order from the captain before the pickup (CA §9.10, §14 #11, slice 2.12a); {reason} is the reassignment reason's label.
  ///
  /// In ar, this message translates to:
  /// **'سُحب منك الطلب: {reason}'**
  String captainOrderWithdrawn(String reason);

  /// The mark of a handover offer or assignment and the step's title for the second captain (CA §9.10.1, Appendix B, slice 2.12b).
  ///
  /// In ar, this message translates to:
  /// **'استلام من كابتن'**
  String get captainHandoverOffer;

  /// Shown instead of the pickup payment on a handover offer and to the second captain (CA §9.10.1, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'لا تدفع شيئاً'**
  String get captainPayNothing;

  /// The first captain on a handover offer and step (CA §9.10.1; the spec gives no wording); {distance} is formatted with formatDistance.
  ///
  /// In ar, this message translates to:
  /// **'من الكابتن {name} — {distance}'**
  String captainHandoverFrom(String name, String distance);

  /// The first captain on a handover offer or step while their position is unknown (CA §9.10.1; the spec gives no wording).
  ///
  /// In ar, this message translates to:
  /// **'من الكابتن {name}'**
  String captainHandoverFromName(String name);

  /// The second captain's button within captain.customer_radius_m of the first captain (CA §9.10.1, §15, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'استلمت الطلب من الكابتن {name}'**
  String captainReceivedFromCaptain(String name);

  /// The second captain beyond the radius of the first, or refused too_far_from_captain (CA §9.10.1; the spec gives no wording).
  ///
  /// In ar, this message translates to:
  /// **'اقترب من الكابتن لتأكيد الاستلام'**
  String get captainGetCloserToCaptain;

  /// The other captain of a handover has sent no position (CA §9.10.1; the spec gives no wording).
  ///
  /// In ar, this message translates to:
  /// **'موقع الكابتن غير متاح الآن — اتصل به'**
  String get captainCaptainLocationUnknown;

  /// The first captain's waiting screen once the second captain has the handover (CA §9.10.1, Appendix B); also its chime.
  ///
  /// In ar, this message translates to:
  /// **'سيستلم الكابتن {name} الطلب منك. انتظره في موقعك.'**
  String captainHandoverWait(String name);

  /// The first captain's waiting screen while the handover is still offered (CA §9.10.1; the spec gives no wording).
  ///
  /// In ar, this message translates to:
  /// **'تبحث العمليات عن كابتن يستلم الطلب منك. انتظر في موقعك.'**
  String get captainHandoverOffered;

  /// Dials the other captain of a handover (CA §9.10.1; the spec gives no wording).
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالكابتن'**
  String get captainCallCaptain;

  /// The second captain's live distance on the first captain's waiting screen (CA §9.10.1; the spec gives no wording); {distance} is formatted with formatDistance.
  ///
  /// In ar, this message translates to:
  /// **'الكابتن {name} على بعد {distance}'**
  String captainOtherCaptainAway(String name, String distance);

  /// The card after the second captain confirmed the receipt; the first captain is offline (CA §9.10.1, §14 #11, K17).
  ///
  /// In ar, this message translates to:
  /// **'سلّمت الطلب للكابتن {name}'**
  String captainHandedOver(String name);

  /// The cancellation card when the restaurant returned the pickup payment (CA §9.10; owner decision 2026-11-09).
  ///
  /// In ar, this message translates to:
  /// **'استرجع المبلغ من المطعم'**
  String get captainCashTakeBack;

  /// The cancellation card when the restaurant kept the pickup payment (CA §9.10; owner decision 2026-11-09).
  ///
  /// In ar, this message translates to:
  /// **'لا تسترجع المبلغ، يُخصم من المطعم في التسوية'**
  String get captainCashKeepWithRestaurant;

  /// The compensation operations granted on the cancellation card (CA §9.10, §14 #11); {amount} is formatted with formatMoney.
  ///
  /// In ar, this message translates to:
  /// **'تعويض: {amount}'**
  String captainCompensation(String amount);

  /// The checkout problem dues_unpaid: a fake order's dues block ordering until paid at the office (CU §5.5, AP §8.8, slice 2.11a); {amount} is formatted with formatMoney.
  ///
  /// In ar, this message translates to:
  /// **'عليك {amount} لـ FOX DROP. ادفعه في المكتب ليُفك الحظر تلقائياً.'**
  String customerDuesUnpaid(String amount);

  /// A free or damaged order delivered with nothing to pay (CU §11.9, slice 2.11a).
  ///
  /// In ar, this message translates to:
  /// **'لم تدفع شيئاً لهذا الطلب'**
  String get customerPaidNothing;

  /// The outcome card after operations set the outcome of the captain's order (CA §9.10, slice 2.11a); {outcome} is the outcome's label (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'أنهت العمليات الطلب: {outcome}.'**
  String captainOutcomeSet(String outcome);

  /// Operations ended the captain's order with an amount to collect (CA §9.10, K9, slice 2.11b): the payment screen opens for it; {outcome} is the outcome's label, {amount} is formatted with formatMoney.
  ///
  /// In ar, this message translates to:
  /// **'أنهت العمليات الطلب: {outcome}. اقبض {amount}.'**
  String captainOutcomeCollect(String outcome, String amount);

  /// The badge of an order waiting for the captain to record the amount operations set to collect (CA §9.10, Appendix B, slice 2.11b).
  ///
  /// In ar, this message translates to:
  /// **'بانتظار تسجيل التحصيل'**
  String get captainAwaitingCollection;

  /// The order screen after operations set an outcome with an amount to collect (CU §11.6, slice 2.11b); {amount} is formatted with formatMoney.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المطلوب الآن: {amount}'**
  String customerAmountDueNow(String amount);

  /// The outcome free (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'مجاني'**
  String get captainOutcomeFree;

  /// The outcome fake (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'وهمي'**
  String get captainOutcomeFake;

  /// The outcome damaged (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'تالف'**
  String get captainOutcomeDamaged;

  /// The outcome wrong_refused (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'خطأ ورفضه الزبون'**
  String get captainOutcomeWrongRefused;

  /// The outcome failed_other (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التسليم'**
  String get captainOutcomeFailedOther;

  /// Where a failed order's food goes: kept_by_captain «يبقى مع الكابتن» (CA §9.12, K10; the wording to the captain ours).
  ///
  /// In ar, this message translates to:
  /// **'الطعام يبقى معك'**
  String get captainFoodKept;

  /// Where a failed order's food goes: returned_to_restaurant «أُعيد إلى المطعم» (CA §9.12, K10).
  ///
  /// In ar, this message translates to:
  /// **'أعِد الطعام إلى المطعم'**
  String get captainFoodReturned;

  /// Where a failed order's food goes: destroyed «أُتلف» (CA §9.12, K10).
  ///
  /// In ar, this message translates to:
  /// **'أتلف الطعام'**
  String get captainFoodDestroyed;

  /// The pay a failed or free order still brings the captain (CA §9.12); {amount} is formatted with formatMoney.
  ///
  /// In ar, this message translates to:
  /// **'أجرك من الطلب: {amount}'**
  String captainOutcomePay(String amount);

  /// The charge on the earnings with the captain responsible for the outcome (CA §10.6, §14 #14); {amount} formatted with formatMoney, {reason} the outcome's label.
  ///
  /// In ar, this message translates to:
  /// **'خُصم من مستحقاتك {amount}: {reason}'**
  String captainOutcomeCharge(String amount, String reason);

  /// The checkout problem review_stop: late cancellations stopped ordering until support reviews the account (docs/domain/08; owner decision 2026-11-09).
  ///
  /// In ar, this message translates to:
  /// **'حسابك موقوف حتى مراجعة فريق الدعم'**
  String get customerReviewStop;

  /// The detail's button on an accepted or ready order before pickup, hidden while a pickup request or a report is open (RA §8.12, §8.10).
  ///
  /// In ar, this message translates to:
  /// **'صنف غير متوفر — اتصلوا بالزبون'**
  String get merchantItemReportButton;

  /// The item-unavailable report sheet's title (RA §8.12); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'صنف غير متوفر في الطلب #{number}'**
  String merchantItemReportTitle(String number);

  /// The heading of the report's optional note (RA §8.12); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة (اختياري)'**
  String get merchantItemReportNote;

  /// The report's optional note similar_alternative (RA §8.12), the built-in label used when Content's item_unavailable_note list could not be read.
  ///
  /// In ar, this message translates to:
  /// **'يوجد بديل مشابه'**
  String get merchantItemReportSimilar;

  /// The report's optional note insufficient_quantity (RA §8.12), the built-in label used when Content's item_unavailable_note list could not be read.
  ///
  /// In ar, this message translates to:
  /// **'الكمية غير كافية'**
  String get merchantItemReportNotEnough;

  /// Sends the item-unavailable report (RA §8.12); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إرسال البلاغ'**
  String get merchantItemReportSend;

  /// The card's and the detail's badge while the item-unavailable report is open (RA §8.12).
  ///
  /// In ar, this message translates to:
  /// **'صنف نفد — بانتظار العمليات'**
  String get merchantItemReportBadge;

  /// The line under the badge while the item-unavailable report is open (RA §8.12).
  ///
  /// In ar, this message translates to:
  /// **'العمليات تتواصل مع الزبون'**
  String get merchantItemReportOperationsCalling;

  /// Withdraws the open item-unavailable report before operations act; the items come back on (RA §8.12).
  ///
  /// In ar, this message translates to:
  /// **'تراجع — الصنف متوفر'**
  String get merchantItemReportWithdraw;

  /// 400 invalid_item_report, or unknown_reason when the note left Content's list (it is read again); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إرسال البلاغ بهذه الاختيارات، راجعها ثم أعد المحاولة'**
  String get merchantItemReportRefused;

  /// 409 on a report while the captain's pickup request is open (RA §8.10: the button is hidden then); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'الكابتن يطلب تأكيد الاستلام، أجب على طلبه أولاً'**
  String get merchantItemReportPickupOpen;

  /// 409 on a report while another device's report is open; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أُبلغ عن صنف غير متوفر في هذا الطلب من جهاز آخر'**
  String get merchantItemReportOpenFirst;

  /// 409 on «تراجع — الصنف متوفر» after the report closed (operations, or another device); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أُغلق بلاغ الصنف قبل وصول تراجعك'**
  String get merchantItemReportClosedFirst;

  /// Chime when operations changed the prep time (RA §8.7, §16 #12).
  ///
  /// In ar, this message translates to:
  /// **'عدّلت العمليات وقت تحضير #{number} إلى {minutes} د'**
  String merchantPrepTimeChanged(String number, int minutes);

  /// Chime when operations closed the item-unavailable report without an edit (RA §8.12, §16 #37); {reason} is operations' text.
  ///
  /// In ar, this message translates to:
  /// **'أغلقت العمليات بلاغ الصنف في الطلب #{number}: {reason}'**
  String merchantItemReportClosed(String number, String reason);

  /// At the restaurant while the restaurant's item-unavailable report is open, and for 409 item_report_open: the pickup waits (CA §9 step 2, RA §8.12).
  ///
  /// In ar, this message translates to:
  /// **'بانتظار تعديل الطلب من العمليات'**
  String get captainWaitingForOrderEdit;

  /// The order screen's banner while the restaurant's item-unavailable report is open (CU §11.6, RA §8.12).
  ///
  /// In ar, this message translates to:
  /// **'المطعم أبلغ أن صنفاً في طلبك غير متوفر. سيتصل بك فريق FOX DROP الآن.'**
  String get customerItemReportBanner;

  /// The ring prompt of an edit by operations that added items, until «اطلعت على التعديل» on any device (RA §8.13, §16 #16).
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل الطلب #{number} — أُضيفت أصناف'**
  String merchantOrderEditedItemsAdded(String number);

  /// The chime and the card's note of an edit by operations that added nothing, until acknowledged (RA §8.13, §16 #17).
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل الطلب #{number}'**
  String merchantOrderEdited(String number);

  /// Acknowledges operations' edits on every device and frees the pickup (RA §8.13, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'اطلعت على التعديل'**
  String get merchantAcknowledgeEdit;

  /// The edit prompt's new items value, which the captain pays at pickup (RA §8.13); {amount} is formatted with formatMoney; the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'قيمة الأصناف الجديدة: {amount}'**
  String merchantEditItemsValue(String amount);

  /// The edit prompt when items were added to a ready order (RA §8.13); the spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'عاد الطلب إلى «قيد التحضير»: {minutes} د إضافية'**
  String merchantEditBackToPreparing(int minutes);

  /// A line an edit by operations added (RA §8.13, CU §11.6).
  ///
  /// In ar, this message translates to:
  /// **'أُضيف: {quantity} × {name}'**
  String orderEditAdded(int quantity, String name);

  /// A line an edit by operations removed (RA §8.13, CU §11.6).
  ///
  /// In ar, this message translates to:
  /// **'حُذف: {quantity} × {name}'**
  String orderEditRemoved(int quantity, String name);

  /// A quantity an edit by operations changed, before then after (RA §8.13, CU §11.6).
  ///
  /// In ar, this message translates to:
  /// **'{name}: {before} ← {after}'**
  String orderEditQuantity(String name, int before, int after);

  /// At the restaurant while an edit that added items is not acknowledged, and for 409 edit_unacknowledged: the pickup waits (CA §9 step 2, RA §8.13).
  ///
  /// In ar, this message translates to:
  /// **'بانتظار تأكيد المطعم للتعديل'**
  String get captainWaitingForEditAcknowledgement;

  /// The chime after operations edited the order before pickup (CA §9.10); both amounts formatted with formatMoney.
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل الطلب — المبلغ الجديد للمطعم {pay}، للتحصيل {collect}'**
  String captainOrderEdited(String pay, String collect);

  /// The chime after operations removed items after the pickup (CA §9.10); the captain does not deliver them. The amount formatted with formatMoney.
  ///
  /// In ar, this message translates to:
  /// **'حُذفت أصناف من الطلب — المبلغ الجديد للتحصيل {collect}'**
  String captainItemsRemovedAfterPickup(String collect);

  /// The chime after operations lowered the delivery fee after the pickup (CA §9.10: the new amount to collect; the wording ours, to confirm with the owner). The amount formatted with formatMoney.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ الجديد للتحصيل: {collect}'**
  String captainCollectLowered(String collect);

  /// The mark of a line FOX DROP added (CU §11.6).
  ///
  /// In ar, this message translates to:
  /// **'أُضيف'**
  String get customerLineAdded;

  /// The mark of a line FOX DROP removed, shown struck through (CU §11.6).
  ///
  /// In ar, this message translates to:
  /// **'حُذف'**
  String get customerLineRemoved;

  /// The order screen's banner after an edit by operations (CU §11.6, §14 #11); {amount} is formatted with formatMoney.
  ///
  /// In ar, this message translates to:
  /// **'عدّلت FOX DROP طلبك. المجموع الجديد: {amount}'**
  String customerOrderEditedBanner(String amount);

  /// The door ping's full-screen ring while the app is open (CU §11.7, §14 #5).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن عند الباب ويحاول الوصول إليك'**
  String get customerDoorRing;

  /// The door ping's ring for an order for someone else (CU §11.7, Q5).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن عند الباب ويحاول الوصول إلى {recipient}'**
  String customerDoorRingRecipient(String recipient);

  /// Answers the captain's door ping (CU §11.7, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'أنا قادم'**
  String get customerComing;

  /// Answers the door ping of an order for someone else (CU §11.7, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'سأتصل بالمستلم'**
  String get customerCallingRecipient;

  /// Dials the captain from the door ping's ring (CU §11.3, §11.7, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالكابتن'**
  String get customerCallCaptain;

  /// Rings the customer's app from the door (CA §9.9, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'تنبيه الزبون'**
  String get captainPingCustomer;

  /// The «تنبيه الزبون» presses left (CA §9.9; the spec gives no wording); {count} is the number as Western digits.
  ///
  /// In ar, this message translates to:
  /// **'التنبيهات المتبقية: {count}'**
  String captainPingsLeft(String count);

  /// When «تنبيه الزبون» is allowed next (CA §9.9 «the next allowed time»; the spec gives no wording); {time} is formatted with formatTime.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك التنبيه مرة أخرى الساعة {time}'**
  String captainNextPingAt(String time);

  /// The customer answered «أنا قادم» (CA §9.9, §14 #13a).
  ///
  /// In ar, this message translates to:
  /// **'الزبون رأى التنبيه وهو قادم'**
  String get captainCustomerComing;

  /// The customer answered «سأتصل بالمستلم» (CA §9.9, §14 #13a).
  ///
  /// In ar, this message translates to:
  /// **'الزبون يتواصل مع المستلم'**
  String get captainCustomerContactingRecipient;

  /// Tells operations the customer does not answer, after every ping and 15 minutes (CA §9.9, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'الزبون لا يستجيب'**
  String get captainCustomerNotAnswering;

  /// When «الزبون لا يستجيب» becomes available (CA §9.9; the spec gives no wording); {time} is formatted with formatTime.
  ///
  /// In ar, this message translates to:
  /// **'يظهر «الزبون لا يستجيب» الساعة {time}'**
  String captainNoAnswerAt(String time);

  /// After «الزبون لا يستجيب», until operations answer (CA §9.9).
  ///
  /// In ar, this message translates to:
  /// **'العمليات تراجع الطلب — انتظر تعليماتهم'**
  String get captainOperationsReviewing;

  /// Operations' «انتظر» with their message (CA §9.9, §14 #13; owner decision 2026-11-11: the wording ours).
  ///
  /// In ar, this message translates to:
  /// **'العمليات: انتظر الزبون. {message}'**
  String captainOperationsWait(String message);

  /// The restaurant's settings screen and its button on the board, owners only (RA §14.3; owner decision 2026-11-11).
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get merchantSettings;

  /// Pickup currencies (RA §12.7).
  ///
  /// In ar, this message translates to:
  /// **'العملات التي تقبلها من الكابتن'**
  String get merchantPickupCurrencies;

  /// Under «العملات التي تقبلها من الكابتن» (RA §12.7: changes apply to pickups requested after the change). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'يُطبَّق التغيير على طلبات الاستلام بعده.'**
  String get merchantPickupCurrenciesExplain;

  /// Under the base currency, whose switch is fixed on (RA §12.7). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'العملة الأساسية، مقبولة دائماً'**
  String get merchantBaseCurrencyAlways;

  /// When the city has no currency besides the base (RA §12.7). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لا عملات أخرى مفعّلة في المدينة.'**
  String get merchantNoOtherCurrencies;

  /// A settings change the server did not take. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لم يُحفظ التغيير، حاول مرة أخرى'**
  String get merchantSaveFailed;

  /// The settings could not be read (no answer, a server error). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل الإعدادات، حاول مرة أخرى'**
  String get merchantSettingsFailed;

  /// The server refused the settings to this account (403: a cashier, or a terminated restaurant). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'هذه الإعدادات لمالكي المطعم فقط.'**
  String get merchantSettingsNotAllowed;

  /// Reads the settings again after a failure. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get merchantRetry;

  /// The offer's peak bonus line (CA §8.2, AP §9.12.5).
  ///
  /// In ar, this message translates to:
  /// **'يشمل مكافأة الذروة +{amount}'**
  String captainOfferPeakBonus(String amount);

  /// The summary's peak bonus (CA §9.8, AP §8.4). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'مكافأة الذروة: {amount}'**
  String captainPayPeak(String amount);

  /// The home screen during a peak window (CA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'مكافأة الذروة الآن: +{amount} لكل طلب حتى {time}'**
  String captainPeakNow(String amount, String time);

  /// The peak windows screen and its link on home (CA §12.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'أوقات مكافأة الذروة'**
  String get captainPeakWindows;

  /// The peak windows screen (CA §12.5, AP §9.12.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'يُضاف المبلغ إلى أجرك عن كل طلب تسلّمه داخل النافذة، بحسب منطقة المطعم.'**
  String get captainPeakExplain;

  /// The peak windows screen while the bonus is off. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'لا مكافأة ذروة الآن.'**
  String get captainPeakOff;

  /// One peak window (CA §12.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'{days} من {start} إلى {end}: +{amount} لكل طلب'**
  String captainPeakWindow(
    String days,
    String start,
    String end,
    String amount,
  );

  /// A peak window that runs past midnight. The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'(تنتهي في اليوم التالي)'**
  String get captainPeakNextDay;

  /// A peak window for every zone (CA §12.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'كل المناطق'**
  String get captainPeakAllZones;

  /// A peak window limited to zones (CA §12.5). The spec gives no wording.
  ///
  /// In ar, this message translates to:
  /// **'في: {zones}'**
  String captainPeakZones(String zones);

  /// A day of a peak window (CA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'الإثنين'**
  String get captainPeakDayMonday;

  /// A day of a peak window (CA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get captainPeakDayTuesday;

  /// A day of a peak window (CA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get captainPeakDayWednesday;

  /// A day of a peak window (CA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get captainPeakDayThursday;

  /// A day of a peak window (CA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get captainPeakDayFriday;

  /// A day of a peak window (CA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get captainPeakDaySaturday;

  /// A day of a peak window (CA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get captainPeakDaySunday;
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
