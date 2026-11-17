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

  /// The discount line with its code, in checkout and the order (CU §10.3, §10.4).
  ///
  /// In ar, this message translates to:
  /// **'الخصم ({code})'**
  String customerDiscountWithCode(String code);

  /// The code field (CU §10.4, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'أدخل الكود'**
  String get customerCodeEnter;

  /// Applies the typed code (CU §10.4, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get customerCodeApply;

  /// Removes the order's code (CU §10.4, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get customerCodeRemove;

  /// A fixed-amount code larger than the items value, before confirming (CU §10.4).
  ///
  /// In ar, this message translates to:
  /// **'قيمة الكود أكبر من قيمة الأصناف، ولا يُستعاد الفرق'**
  String get customerCodeAboveItems;

  /// Code refusal unknown_code (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'الكود غير صحيح'**
  String get customerCodeUnknown;

  /// Code refusal not_valid_now (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'الكود غير صالح الآن'**
  String get customerCodeNotValidNow;

  /// Code refusal below_minimum, with the missing amount (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'أضف {amount} لاستخدام هذا الكود'**
  String customerCodeBelowMinimum(String amount);

  /// Code refusal not_for_restaurant (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'هذا الكود لا يعمل مع هذا المطعم'**
  String get customerCodeNotForRestaurant;

  /// Code refusal first_order_only (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'هذا الكود للطلب الأول فقط'**
  String get customerCodeFirstOrderOnly;

  /// Code refusal used_before (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'استخدمت هذا الكود من قبل'**
  String get customerCodeUsedBefore;

  /// Code refusal uses_ended (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'انتهت استخدامات هذا الكود'**
  String get customerCodeUsesEnded;

  /// Code refusal budget_reached (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'الكود غير متاح اليوم'**
  String get customerCodeBudgetReached;

  /// The visible codes that apply to the cart, at checkout (CU §10.4).
  ///
  /// In ar, this message translates to:
  /// **'الأكواد المتاحة لك'**
  String get customerCodesAvailable;

  /// The suggested code with the largest discount, with «تطبيق»; never applied by itself (CU §10.4, Q19, U11).
  ///
  /// In ar, this message translates to:
  /// **'لديك كود يوفر عليك {amount}: {code}'**
  String customerCodeSuggestion(String amount, String code);

  /// What an available code takes off this cart (CU §10.4; our words, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'يوفر عليك {amount}'**
  String customerCodeSaves(String amount);

  /// A percentage code's value (CU §10.4, §12.4; our words). The percentage has Western digits, such as 12.5.
  ///
  /// In ar, this message translates to:
  /// **'خصم {percent}%'**
  String customerCodePercent(String percent);

  /// A percentage code with its cap (CU §10.4, §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'خصم {percent}% بحد أقصى {amount}'**
  String customerCodePercentCapped(String percent, String amount);

  /// A fixed-amount code's value (CU §10.4, §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'خصم {amount}'**
  String customerCodeFixed(String amount);

  /// A free-delivery code's value (CU §10.4, §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'توصيل مجاني'**
  String get customerCodeFreeDelivery;

  /// A code's minimum order on the items value (CU §10.4, §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'للطلبات من {amount}'**
  String customerCodeMinimum(String amount);

  /// A code's expiry (CU §12.4).
  ///
  /// In ar, this message translates to:
  /// **'ينتهي {date}'**
  String customerCodeExpires(String date);

  /// The compensation code given with a cancellation, on «أُلغي طلبك» (CU §11.9), in the words of its push (CU §14 #16).
  ///
  /// In ar, this message translates to:
  /// **'لك كود تعويض {value}: {code}'**
  String customerCompensationCode(String value, String code);

  /// A percentage compensation with its maximum, as the push «لك كود تعويض {القيمة}» says it (CU §11.9; our words, as the panel's).
  ///
  /// In ar, this message translates to:
  /// **'{percent}% بحد أقصى {amount}'**
  String customerCompensationPercent(String percent, String amount);

  /// A personal code's percentage without a maximum, the late code's (CU §11.6).
  ///
  /// In ar, this message translates to:
  /// **'{percent}%'**
  String customerPersonalPercent(String percent);

  /// The late code on the order screen (CU §11.6, the 45-minute row), with its value; the push (CU §14 #15) says it without the value.
  ///
  /// In ar, this message translates to:
  /// **'تأخر طلبك، وهذا كود خصم {value} لطلبك القادم: {code}'**
  String customerLateCode(String value, String code);

  /// Asked before another code replaces the applied one: one code per order (CU §10.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'طلبك يحمل الكود {current}. هل تستبدله بالكود {code}؟'**
  String customerCodeReplaceAsk(String current, String code);

  /// Between the items of a list written in a line, such as a code's restaurants (CU §12.4).
  ///
  /// In ar, this message translates to:
  /// **'، '**
  String get listSeparator;

  /// «أكوادي» (CU §12.4, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'أكوادي'**
  String get customerMyCodesTitle;

  /// The codes the customer can use (CU §12.4, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'متاحة'**
  String get customerCodesTabAvailable;

  /// The codes used or expired in the last 30 days (CU §12.4, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'منتهية'**
  String get customerCodesTabEnded;

  /// An empty tab of «أكوادي» (our words, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أكواد هنا الآن'**
  String get customerCodesEmpty;

  /// «أكوادي» before a delivery point is known: the codes are the city's (our words).
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك لعرض أكوادك'**
  String get customerCodesNoPoint;

  /// The restaurants a code works with (CU §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'في: {names}'**
  String customerCodeRestaurants(String names);

  /// The zones a code works in (CU §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'في مناطق: {names}'**
  String customerCodeZones(String names);

  /// A code's hours of the day on the city clock (CU §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'من {from} إلى {to}'**
  String customerCodeHours(String from, String to);

  /// The uses left of a code (CU §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'متبقٍ لك: {count}'**
  String customerCodeUsesLeft(int count);

  /// Opens the code's restaurant, or home (CU §12.4).
  ///
  /// In ar, this message translates to:
  /// **'استخدم'**
  String get customerCodeUse;

  /// A code used up, in «منتهية» (CU §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'استُخدم {date}'**
  String customerCodeUsedOn(String date);

  /// A code that ended, in «منتهية» (CU §12.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'انتهى {date}'**
  String customerCodeExpiredOn(String date);

  /// Confirms replacing the applied code (CU §10.4; our words).
  ///
  /// In ar, this message translates to:
  /// **'استبدال'**
  String get customerCodeReplace;

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

  /// The amber banner on home at captain.custody_warn_pct of the cash limit (CA §10.4).
  ///
  /// In ar, this message translates to:
  /// **'اقتربت من حد العهدة. سلّم النقد قريباً.'**
  String get captainCustodyWarning;

  /// Home line while online across the cutoff with cash due, until the offers stop (CA §10.3).
  ///
  /// In ar, this message translates to:
  /// **'سلّم نقد أمس قبل {time} لتستمر العروض'**
  String captainRemitBy(String time);

  /// Home line while a hand-in grace runs and cash from a closed day is due (CA §10.3).
  ///
  /// In ar, this message translates to:
  /// **'مُنحت مهلة حتى {time}'**
  String captainHandInGrace(String time);

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

  /// The banner and checkout problem of a block for a duration (CU §5.5, AP §9.8, slice 2.25a); {date} is formatDate and formatTime on the city's clock, {reason} the block reason's customer text (CU Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'حسابك محظور حتى {date}: {reason}'**
  String customerBlockedUntil(String date, String reason);

  /// The banner and checkout problem of a block until further notice (CU §5.5, AP §9.8, slice 2.25a).
  ///
  /// In ar, this message translates to:
  /// **'حسابك محظور: {reason}. تواصل مع الدعم.'**
  String customerBlockedIndefinite(String reason);

  /// Opens the office sheet from the dues banner (CU §5.5, AP §9.12.1, slice 2.25a; our wording).
  ///
  /// In ar, this message translates to:
  /// **'موقع المكتب وساعاته'**
  String get customerOfficeShow;

  /// The office sheet's title (CU §5.5, AP §9.12.1).
  ///
  /// In ar, this message translates to:
  /// **'المكتب'**
  String get customerOfficeTitle;

  /// The desk is open now (CU §5.5's office sheet).
  ///
  /// In ar, this message translates to:
  /// **'المكتب مفتوح حتى {time}'**
  String customerOfficeOpenUntil(String time);

  /// The desk is closed now and when it opens (CU §5.5's office sheet).
  ///
  /// In ar, this message translates to:
  /// **'المكتب مغلق الآن، يفتح {day} {time}.'**
  String customerOfficeClosed(String day, String time);

  /// The desk is closed and no day is open (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'المكتب مغلق الآن.'**
  String get customerOfficeClosedAlways;

  /// The office is not set yet in the city (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم يُحدَّد موقع المكتب بعد. تواصل مع الدعم.'**
  String get customerOfficeUnset;

  /// One weekday's desk hours in the office sheet.
  ///
  /// In ar, this message translates to:
  /// **'{day}: من {from} إلى {to}'**
  String customerOfficeDay(String day, String from, String to);

  /// A weekday the desk is closed in the office sheet.
  ///
  /// In ar, this message translates to:
  /// **'{day}: مغلق'**
  String customerOfficeDayClosed(String day);

  /// Opens the office on the map from the office sheet (CU §5.5).
  ///
  /// In ar, this message translates to:
  /// **'موقع المكتب على الخريطة'**
  String get customerOfficeMap;

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

  /// A free re-delivery's badge in the three apps: the order whose items support re-delivers at no charge to the customer (AP §9.9.3, CU §11.2; owner decision 2026-11-17).
  ///
  /// In ar, this message translates to:
  /// **'إعادة توصيل مجانية لطلب #{number}'**
  String redeliveryOf(String number);

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

  /// The custody screen, its link on home and its tab (CA §10.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'عهدتي'**
  String get captainCustodyTitle;

  /// The office owes the captain (CA §10.2, Appendix B, Home).
  ///
  /// In ar, this message translates to:
  /// **'لك عند المكتب {amount}'**
  String captainCustodyOwed(String amount);

  /// No custody in any currency (CA §10.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا نقد معك للمنصة الآن.'**
  String get captainCustodyNothing;

  /// One currency held with its base equivalent (CA §10.2, AP §8.6).
  ///
  /// In ar, this message translates to:
  /// **'{amount} (بالعملة الأساسية {base})'**
  String captainCustodyCurrency(String amount, String base);

  /// The part due from closed days, which blocks going online (CA §10.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'من أيام سابقة: {amount}'**
  String captainCustodyPrevious(String amount);

  /// Today's part (CA §10.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'من اليوم: {amount}'**
  String captainCustodyToday(String amount);

  /// The cash limit and its usage, over its bar, on «عهدتي» and home (CA §10.2, §10.4, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'حد العهدة: {usage} من {limit}'**
  String captainCustodyLimit(String usage, String limit);

  /// The custody's entries (CA §10.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'الحركات'**
  String get captainCustodyEntries;

  /// No custody entry yet (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا حركات بعد.'**
  String get captainCustodyNoEntries;

  /// An entry: the pickup payment (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'دفع للمطعم'**
  String get captainCustodyEntryPayMerchant;

  /// An entry: the collection (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'تحصيل من الزبون'**
  String get captainCustodyEntryCollect;

  /// An entry: the change given (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'باقٍ للزبون'**
  String get captainCustodyEntryChange;

  /// An entry: a hand-in at the desk (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'تسليم نقد'**
  String get captainCustodyEntryHandIn;

  /// An entry: the office paid the captain back (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'صرف للكابتن'**
  String get captainCustodyEntryReimburse;

  /// An entry: a cross-currency settlement (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'تحويل عملة'**
  String get captainCustodyEntryConversion;

  /// An entry: a correction (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'تصحيح'**
  String get captainCustodyEntryCorrection;

  /// An entry of a kind the app does not name.
  ///
  /// In ar, this message translates to:
  /// **'حركة'**
  String get captainCustodyEntryOther;

  /// An order's entry with its number (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'{kind} — الطلب #{number}: {amount}'**
  String captainCustodyEntryOrder(String kind, String number, String amount);

  /// A desk entry with its receipt's number (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'{kind} — {receipt}: {amount}'**
  String captainCustodyEntryReceipt(String kind, String receipt, String amount);

  /// An entry with no order or receipt (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'{kind}: {amount}'**
  String captainCustodyEntryPlain(String kind, String amount);

  /// The desk receipts (CA §10.2, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'الإيصالات'**
  String get captainCustodyReceipts;

  /// No receipt yet (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا إيصالات بعد.'**
  String get captainCustodyNoReceipts;

  /// A receipt's number, type and time (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'{number} — {type} — {date} {time}'**
  String captainCustodyReceipt(
    String number,
    String type,
    String date,
    String time,
  );

  /// The receipt's cashier (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'أمين الصندوق: {name}'**
  String captainCustodyReceiptCashier(String name);

  /// A receipt's conversion, as the panel prints it (AP §9.10.3).
  ///
  /// In ar, this message translates to:
  /// **'تحويل {amount} من العهدة إلى {converted}'**
  String captainCustodyReceiptConversion(String amount, String converted);

  /// The office section of «عهدتي» (CA §10.2, C13).
  ///
  /// In ar, this message translates to:
  /// **'المكتب'**
  String get captainOffice;

  /// The desk is open now (CA Appendix B, Custody).
  ///
  /// In ar, this message translates to:
  /// **'المكتب مفتوح حتى {time}'**
  String captainOfficeOpenUntil(String time);

  /// The desk is closed now and when it opens (CA §7.5).
  ///
  /// In ar, this message translates to:
  /// **'المكتب مغلق الآن، يفتح {day} {time}.'**
  String captainOfficeClosed(String day, String time);

  /// The desk is closed and no day is open (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'المكتب مغلق الآن.'**
  String get captainOfficeClosedAlways;

  /// The office is not set yet (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم يُحدَّد موقع المكتب بعد.'**
  String get captainOfficeUnset;

  /// One weekday's desk hours (CA §10.2, C13).
  ///
  /// In ar, this message translates to:
  /// **'{day}: من {from} إلى {to}'**
  String captainOfficeDay(String day, String from, String to);

  /// A weekday the desk is closed (CA §10.2).
  ///
  /// In ar, this message translates to:
  /// **'{day}: مغلق'**
  String captainOfficeDayClosed(String day);

  /// The map button of the office (CA §7.5, §10.2, C13).
  ///
  /// In ar, this message translates to:
  /// **'موقع المكتب على الخريطة'**
  String get captainOfficeMap;

  /// The hand-in reminder while the desk is open (CA §7.5).
  ///
  /// In ar, this message translates to:
  /// **'عليك تسليم {amount}. المكتب مفتوح حتى {time}.'**
  String captainHandInOpen(String amount, String time);

  /// The hand-in reminder while the desk is closed (CA §7.5).
  ///
  /// In ar, this message translates to:
  /// **'عليك تسليم {amount}. المكتب مغلق الآن، يفتح {day} {time}.'**
  String captainHandInClosed(String amount, String day, String time);

  /// The hand-in reminder while no day of the desk is open (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'عليك تسليم {amount}. المكتب مغلق الآن.'**
  String captainHandInClosedAlways(String amount);

  /// The bottom navigation's home tab (CA §6.2).
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get captainHomeTab;

  /// The earnings screen and its tab (CA §6.2, §10.6, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'أرباحي'**
  String get captainEarningsTitle;

  /// The bottom navigation's tab that holds the other screens (CA §6.2).
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get captainMoreTab;

  /// The bar on every tab that returns to the active order (CA §6.2).
  ///
  /// In ar, this message translates to:
  /// **'الطلب الجاري'**
  String get captainActiveOrderBar;

  /// The business day now on «أرباحي» (CA §10.6; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get captainEarningsToday;

  /// The payout cycle since the latest payout weekday on «أرباحي» (CA §10.6; owner decision 2026-11-15).
  ///
  /// In ar, this message translates to:
  /// **'هذا الأسبوع'**
  String get captainEarningsWeek;

  /// The earnings so far of today or this week (CA §10.6; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'الأرباح: {amount}'**
  String captainEarningsSoFar(String amount);

  /// The orders of today or this week (CA §10.6; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'الطلبات: {count}'**
  String captainEarningsOrderCount(int count);

  /// The time online of today or this week (CA §10.6; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'ساعات الاتصال: {hours} س {minutes} د'**
  String captainEarningsOnline(int hours, int minutes);

  /// The earnings balance (CA §10.6, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'رصيدك المستحق: {amount}'**
  String captainEarningsBalance(String amount);

  /// The next payout day and date, «الخميس» by default (CA §10.6, Appendix B: «موعد القبض: الخميس {التاريخ}»).
  ///
  /// In ar, this message translates to:
  /// **'موعد القبض: {day} {date}'**
  String captainEarningsPayoutDate(String day, String date);

  /// A negative balance under carry_forward (CA §10.7: the app explains it; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'رصيدك سالب، ويُخصم من أرباحك في الأسبوع القادم.'**
  String get captainEarningsNegativeCarry;

  /// A negative balance under collect_at_desk (CA §10.7; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'رصيدك سالب، وتسدّده نقداً في المكتب يوم القبض.'**
  String get captainEarningsNegativeCollect;

  /// The heading of this week's orders (CA §10.6; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'طلبات هذا الأسبوع'**
  String get captainEarningsOrders;

  /// One order and its total pay (CA §10.6).
  ///
  /// In ar, this message translates to:
  /// **'الطلب #{number}: {amount}'**
  String captainEarningsOrder(String number, String amount);

  /// An order whose number was not read, and its total pay (CA §10.6).
  ///
  /// In ar, this message translates to:
  /// **'طلب: {amount}'**
  String captainEarningsOrderUnnumbered(String amount);

  /// The heading of the bonuses, charges, instalments and payouts (CA §10.6; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'حركات أخرى'**
  String get captainEarningsOther;

  /// No order and no other line this week (CA §10.6; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا حركات هذا الأسبوع بعد.'**
  String get captainEarningsNothing;

  /// A bonus line, earn.bonus (CA §10.6).
  ///
  /// In ar, this message translates to:
  /// **'مكافأة'**
  String get captainEarningsBonus;

  /// A charge line, earn.charge (CA §10.6).
  ///
  /// In ar, this message translates to:
  /// **'خصم'**
  String get captainEarningsCharge;

  /// A kit deposit instalment line, earn.deposit_instalment (CA §10.6; no wording in the spec: the domain's «التأمين», to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'قسط تأمين العدة'**
  String get captainEarningsInstalment;

  /// A payout line, earn.payout paid to the captain (CA §10.6; the receipt's label).
  ///
  /// In ar, this message translates to:
  /// **'صرف المستحقات'**
  String get captainEarningsPayout;

  /// A negative balance collected at the desk (CA §10.7; the receipt's label, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'تحصيل رصيد سالب'**
  String get captainEarningsCollection;

  /// A correction line, earn.adjustment (AP §8.5.2).
  ///
  /// In ar, this message translates to:
  /// **'تصحيح'**
  String get captainEarningsAdjustment;

  /// One other line: its kind and amount (CA §10.6).
  ///
  /// In ar, this message translates to:
  /// **'{kind}: {amount}'**
  String captainEarningsLine(String kind, String amount);

  /// The order of a charge (CA §10.6).
  ///
  /// In ar, this message translates to:
  /// **'الطلب #{number}'**
  String captainEarningsLineOrder(String number);

  /// The receipt of a payout (CA §10.6).
  ///
  /// In ar, this message translates to:
  /// **'إيصال {number}'**
  String captainEarningsLineReceipt(String number);

  /// The weekly statement screen and its link on «أرباحي» (CA §10.7, Appendix B).
  ///
  /// In ar, this message translates to:
  /// **'كشف الأسبوع'**
  String get captainStatementTitle;

  /// The list of weekly statements (CA §10.7; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'كشوف الأسبوع'**
  String get captainStatementsTitle;

  /// No statement yet (CA §10.7; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا كشوف بعد.'**
  String get captainStatementsNone;

  /// A statement in the list that paid (CA §10.7, as the push «كشف الأسبوع جاهز: قبضت {المبلغ}», CA §14 #20).
  ///
  /// In ar, this message translates to:
  /// **'قبضت {amount}'**
  String captainStatementPaid(String amount);

  /// A statement in the list that paid nothing (CA §10.7; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم تقبض شيئاً، يُرحَّل {amount}'**
  String captainStatementCarried(String amount);

  /// The captain on the statement, as on the printed one (CA §10.7).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن: {name}'**
  String captainStatementCaptain(String name);

  /// The period since the previous payout, as on the printed statement (CA §10.7).
  ///
  /// In ar, this message translates to:
  /// **'من {from} إلى {to}'**
  String captainStatementPeriod(String from, String to);

  /// The period of the first statement, as on the printed one (CA §10.7).
  ///
  /// In ar, this message translates to:
  /// **'حتى {to}'**
  String captainStatementPeriodFirst(String to);

  /// The number of orders (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'عدد الطلبات: {count}'**
  String captainStatementOrders(int count);

  /// The balance the period started from, as on the printed statement (CA §10.7).
  ///
  /// In ar, this message translates to:
  /// **'رصيد مُرحَّل'**
  String get captainStatementCarriedIn;

  /// Pay by part (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'الأجر الأساسي'**
  String get captainStatementBasePay;

  /// Pay by part (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'أجر المسافة'**
  String get captainStatementDistancePay;

  /// Pay by part (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'أجر الانتظار'**
  String get captainStatementWaitingPay;

  /// Pay by part (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'مكافأة الذروة'**
  String get captainStatementPeakBonus;

  /// The bonuses (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'المكافآت'**
  String get captainStatementBonuses;

  /// The charges taken off (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'الخصومات'**
  String get captainStatementCharges;

  /// The deposit instalments taken off (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'أقساط التأمين'**
  String get captainStatementInstalments;

  /// The corrections (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'قيود تصحيحية'**
  String get captainStatementAdjustments;

  /// The balance before the payout, as on the printed statement (CA §10.7).
  ///
  /// In ar, this message translates to:
  /// **'الرصيد قبل الصرف'**
  String get captainStatementBalance;

  /// The net amount paid (CA §10.7), as on the printed statement.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المصروف'**
  String get captainStatementPaidLine;

  /// A negative balance collected at the desk, as on the printed statement (CA §10.7).
  ///
  /// In ar, this message translates to:
  /// **'المحصَّل من رصيد سالب'**
  String get captainStatementCollected;

  /// Carried to the next week, as on the printed statement (CA §10.7).
  ///
  /// In ar, this message translates to:
  /// **'يُرحَّل إلى الأسبوع التالي'**
  String get captainStatementCarriedOut;

  /// One line of the statement and its amount (CA §10.7).
  ///
  /// In ar, this message translates to:
  /// **'{label}: {amount}'**
  String captainStatementLine(String label, String amount);

  /// Shares the statement as an image (CA §10.7).
  ///
  /// In ar, this message translates to:
  /// **'مشاركة كصورة'**
  String get captainStatementShare;

  /// The statement could not be shared (CA §10.7; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّرت مشاركة الكشف.'**
  String get captainStatementShareFailed;

  /// A statement in the list where the desk collected a negative balance (CA §10.7; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'سدّدت {amount} من رصيد سالب'**
  String captainStatementCollectedSummary(String amount);

  /// A statement that is not this captain's or no longer exists (CA §10.7; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم يُعثر على هذا الكشف.'**
  String get captainStatementNotFound;

  /// The owners' account screen (RA §12.2).
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get merchantAccount;

  /// The balance card when the restaurant owes (RA §12.2).
  ///
  /// In ar, this message translates to:
  /// **'المستحق عليك حتى الآن: {amount}'**
  String merchantAccountOwed(String amount);

  /// The balance card when the platform owes the restaurant (RA §12.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لك عند FOX DROP: {amount}'**
  String merchantAccountCredit(String amount);

  /// The balance card at zero (RA §12.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا مستحقات عليك الآن.'**
  String get merchantAccountSettled;

  /// The settlement day (RA §12.2).
  ///
  /// In ar, this message translates to:
  /// **'موعد التسوية: {weekday} {date}'**
  String merchantAccountSettlement(String weekday, String date);

  /// The red line of the balance card when a statement is overdue (RA §12.2, §12.6).
  ///
  /// In ar, this message translates to:
  /// **'متأخر: {amount} من كشف {date}'**
  String merchantAccountOverdue(String amount, String date);

  /// The owners' amber banner when a statement is overdue (RA §6.3 item 7, §12.6).
  ///
  /// In ar, this message translates to:
  /// **'لديك مبلغ متأخر: {amount}. يرجى التسوية في أقرب وقت.'**
  String merchantOverdueBanner(String amount);

  /// The current commission rate (RA §12.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'عمولتك الحالية: {rate}%'**
  String merchantAccountCommission(String rate);

  /// A scheduled commission change (RA §12.2, S15).
  ///
  /// In ar, this message translates to:
  /// **'تتغيّر عمولتك إلى {rate}% اعتباراً من {date}'**
  String merchantAccountCommissionChange(String rate, String date);

  /// Today's pickups (RA §12.2).
  ///
  /// In ar, this message translates to:
  /// **'قبضت اليوم من الكباتن: {amount} ({count} طلباً)'**
  String merchantAccountToday(String amount, String count);

  /// One pickup today: the order, the time and the captain (RA §12.2).
  ///
  /// In ar, this message translates to:
  /// **'#{number} · {time} · {captain}'**
  String merchantAccountPickup(String number, String time, String captain);

  /// The entries since the last statement, by day (RA §12.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'هذا الأسبوع'**
  String get merchantAccountWeek;

  /// No entry since the last statement (RA §12.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا قيود منذ آخر كشف.'**
  String get merchantAccountWeekEmpty;

  /// An order's commission in the week (RA §12.2).
  ///
  /// In ar, this message translates to:
  /// **'#{number}: العمولة {amount}'**
  String merchantAccountOrder(String number, String amount);

  /// An order's restaurant-funded discount in the week (RA §12.2).
  ///
  /// In ar, this message translates to:
  /// **'خصم يموّله المطعم: {amount}'**
  String merchantAccountOrderDiscount(String amount);

  /// A payment in the week (RA §12.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'دفعة مسدّدة: {amount}'**
  String merchantAccountPayment(String amount);

  /// A payout to the restaurant in the week (RA §12.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'صُرف لك: {amount}'**
  String merchantAccountPayout(String amount);

  /// An exception in the week with its amount (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'{label}: {amount}'**
  String merchantAccountException(String label, String amount);

  /// The order of an exception (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'الطلب #{number}'**
  String merchantAccountExceptionOrder(String number);

  /// An exception that raises what the restaurant owes (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'يزيد المستحق عليك'**
  String get merchantAccountRaises;

  /// An exception that lowers what the restaurant owes (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'يُنقص المستحق عليك'**
  String get merchantAccountLowers;

  /// The account could not be read (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل الحساب.'**
  String get merchantAccountFailed;

  /// A cashier or another refusal (R10; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'الحساب للمالكين فقط.'**
  String get merchantAccountNotAllowed;

  /// An exception (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'تعويض عن طلب أُلغي بعد التحضير'**
  String get merchantCauseFoodCredit;

  /// An exception (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'تصحيح مبلغ الاستلام'**
  String get merchantCauseCredit;

  /// An exception (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'استرداد مبلغ الاستلام'**
  String get merchantCausePickupRefund;

  /// An exception: the pickup payment kept on a cancelled order (the panel's label, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'مبلغ استلام لطلب لم يكتمل'**
  String get merchantCausePickupKept;

  /// An exception (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'أصناف حُذفت بعد الاستلام'**
  String get merchantCauseItemsRemoved;

  /// An exception (the panel's label, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'خُفّضت أجرة التوصيل بعد الاستلام'**
  String get merchantCauseFeeLowered;

  /// An exception (the panel's label, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'إلغاء خصم أجرة التوصيل'**
  String get merchantCauseFeeCutReturned;

  /// An exception (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'مشكلة بعد التسليم'**
  String get merchantCauseDebit;

  /// An exception (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'إلغاء عمولة'**
  String get merchantCauseCommissionReversal;

  /// An exception (the panel's label, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'إلغاء استرداد العمولة'**
  String get merchantCauseCommissionRestored;

  /// An exception (the panel's label, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'إلغاء خصم يموّله المطعم'**
  String get merchantCauseDiscountReversal;

  /// An exception (the panel's label, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'تغيير النتيجة'**
  String get merchantCauseOutcomeChanged;

  /// A manual correction with its reason (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'تسوية يدوية: {reason}'**
  String merchantCauseAdjustment(String reason);

  /// The owners' commission line of an order (RA §8.4).
  ///
  /// In ar, this message translates to:
  /// **'العمولة {rate}% — تُسدَّد يوم السبت: {amount}'**
  String merchantOrderCommission(String rate, String amount);

  /// The owners' net line of an order (RA §8.4).
  ///
  /// In ar, this message translates to:
  /// **'صافيك من الطلب: {amount}'**
  String merchantOrderNet(String amount);

  /// A test order instead of the commission lines (RA §8.4).
  ///
  /// In ar, this message translates to:
  /// **'طلب تجريبي — لا عمولة'**
  String get merchantOrderTestNoCommission;

  /// The owners' weekly statements (RA §12.2–12.3).
  ///
  /// In ar, this message translates to:
  /// **'الكشوف'**
  String get merchantStatements;

  /// No statement yet (RA §12.3; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا كشوف بعد.'**
  String get merchantStatementsNone;

  /// A statement in the list: its settlement day and total due (the panel's wording).
  ///
  /// In ar, this message translates to:
  /// **'كشف {date}: المستحق {amount}'**
  String merchantStatementSummary(String date, String amount);

  /// A statement's status (RA §12.3).
  ///
  /// In ar, this message translates to:
  /// **'غير مسدّد'**
  String get merchantStatementUnpaid;

  /// A statement's status (RA §12.3).
  ///
  /// In ar, this message translates to:
  /// **'مسدّد جزئياً'**
  String get merchantStatementPartlyPaid;

  /// A statement's status (RA §12.3).
  ///
  /// In ar, this message translates to:
  /// **'مسدّد'**
  String get merchantStatementPaid;

  /// The weekly statement (RA §12.3), as printed.
  ///
  /// In ar, this message translates to:
  /// **'كشف الأسبوع'**
  String get merchantStatementTitle;

  /// The period since the previous statement, as printed.
  ///
  /// In ar, this message translates to:
  /// **'من {from} إلى {to}'**
  String merchantStatementPeriod(String from, String to);

  /// The period of the first statement, as printed.
  ///
  /// In ar, this message translates to:
  /// **'حتى {to}'**
  String merchantStatementPeriodFirst(String to);

  /// The number of orders, as printed.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات: {count}'**
  String merchantStatementOrders(int count);

  /// An order of the statement and its commission (RA §12.3).
  ///
  /// In ar, this message translates to:
  /// **'#{number}: العمولة {commission}'**
  String merchantStatementOrderLine(String number, String commission);

  /// An order's items value received from the captain with the currency lines (RA §12.3, §12.7).
  ///
  /// In ar, this message translates to:
  /// **'قيمة الأصناف {amount} ({lines})'**
  String merchantStatementPickup(String amount, String lines);

  /// The statement's exceptions (RA §12.5), as printed.
  ///
  /// In ar, this message translates to:
  /// **'الاستثناءات'**
  String get merchantStatementExceptionsTitle;

  /// A statement without exceptions, as printed.
  ///
  /// In ar, this message translates to:
  /// **'لا استثناءات.'**
  String get merchantStatementNoExceptions;

  /// Who decided an exception (RA §12.5).
  ///
  /// In ar, this message translates to:
  /// **'من قرّر: {who}'**
  String merchantStatementDecidedBy(String who);

  /// An exception a staff member without a name decided (RA §12.5; ours).
  ///
  /// In ar, this message translates to:
  /// **'FOX DROP'**
  String get merchantDeciderPlatform;

  /// An exception the system posted (RA §12.5; ours, to confirm with the owner).
  ///
  /// In ar, this message translates to:
  /// **'تلقائياً'**
  String get merchantDeciderSystem;

  /// An exception the restaurant's own action posted (RA §12.5; ours).
  ///
  /// In ar, this message translates to:
  /// **'المطعم'**
  String get merchantDeciderRestaurant;

  /// An exception a captain's action posted (RA §12.5; ours).
  ///
  /// In ar, this message translates to:
  /// **'الكابتن'**
  String get merchantDeciderCaptain;

  /// An exception a customer's action posted (RA §12.5; ours).
  ///
  /// In ar, this message translates to:
  /// **'الزبون'**
  String get merchantDeciderCustomer;

  /// The payments the statement counts, as printed.
  ///
  /// In ar, this message translates to:
  /// **'الدفعات منذ الكشف السابق'**
  String get merchantStatementPaymentsTitle;

  /// A total of the statement, as printed.
  ///
  /// In ar, this message translates to:
  /// **'قيمة الأصناف المقبوضة من الكباتن'**
  String get merchantStatementItemsValue;

  /// A total of the statement, as printed.
  ///
  /// In ar, this message translates to:
  /// **'العمولة'**
  String get merchantStatementCommission;

  /// A total of the statement, as printed.
  ///
  /// In ar, this message translates to:
  /// **'خصم يموّله المطعم'**
  String get merchantStatementDiscountShare;

  /// A total of the statement, as printed.
  ///
  /// In ar, this message translates to:
  /// **'صافي الاستثناءات'**
  String get merchantStatementExceptions;

  /// A total of the statement, as printed.
  ///
  /// In ar, this message translates to:
  /// **'مستحق هذا الأسبوع'**
  String get merchantStatementWeekTotal;

  /// A total of the statement, as printed.
  ///
  /// In ar, this message translates to:
  /// **'المستحق في الكشف السابق'**
  String get merchantStatementPreviousDue;

  /// A total of the statement, as printed.
  ///
  /// In ar, this message translates to:
  /// **'المدفوع منذ الكشف السابق'**
  String get merchantStatementPaidSince;

  /// The earlier unpaid balance (RA §12.3), as printed.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد السابق غير المسدّد'**
  String get merchantStatementEarlierUnpaid;

  /// The total due (RA §12.3), as printed.
  ///
  /// In ar, this message translates to:
  /// **'المجموع المستحق'**
  String get merchantStatementTotalDue;

  /// A total of the statement and its amount.
  ///
  /// In ar, this message translates to:
  /// **'{label}: {amount}'**
  String merchantStatementLine(String label, String amount);

  /// The statement's status (RA §12.3), as printed.
  ///
  /// In ar, this message translates to:
  /// **'الحالة: {status}'**
  String merchantStatementStatus(String status);

  /// What of the total due is still unpaid, as printed.
  ///
  /// In ar, this message translates to:
  /// **'غير المسدّد منه: {amount}'**
  String merchantStatementUnpaidPart(String amount);

  /// Shares the statement as an image (RA §12.3; owner decision 2026-11-16).
  ///
  /// In ar, this message translates to:
  /// **'مشاركة كصورة'**
  String get merchantStatementShare;

  /// The statement could not be shared (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّرت مشاركة الكشف.'**
  String get merchantStatementShareFailed;

  /// A statement that is not this restaurant's (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم يُعثر على هذا الكشف.'**
  String get merchantStatementNotFound;

  /// A receipt that is not this restaurant's (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم يُعثر على هذا الإيصال.'**
  String get merchantReceiptNotFound;

  /// The owners' settlement receipts (RA §12.2, §12.4).
  ///
  /// In ar, this message translates to:
  /// **'الإيصالات'**
  String get merchantReceipts;

  /// No receipt yet (RA §12.4; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا إيصالات بعد.'**
  String get merchantReceiptsNone;

  /// The safety note of the receipts (RA §12.4).
  ///
  /// In ar, this message translates to:
  /// **'لا تسلّم المبلغ إلا لموظف FOX DROP معروف لديك، وتأكد من وصول الإيصال إلى التطبيق.'**
  String get merchantReceiptsSafety;

  /// A payment's receipt in the list, as its push (RA §16 #31).
  ///
  /// In ar, this message translates to:
  /// **'إيصال {number}: استلمنا منك {amount}'**
  String merchantReceiptPayment(String number, String amount);

  /// A receipt of FOX DROP paying the restaurant (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'إيصال {number}: صُرف لك {amount}'**
  String merchantReceiptPayout(String number, String amount);

  /// A settlement receipt (RA §12.4).
  ///
  /// In ar, this message translates to:
  /// **'الإيصال'**
  String get merchantReceiptTitle;

  /// The receipt's number (RA §12.4).
  ///
  /// In ar, this message translates to:
  /// **'إيصال {number}'**
  String merchantReceiptNumber(String number);

  /// The receipt's method (RA §12.4), as printed.
  ///
  /// In ar, this message translates to:
  /// **'طريقة التسوية: {method}'**
  String merchantReceiptMethod(String method);

  /// Settled at the office (RA §12.4).
  ///
  /// In ar, this message translates to:
  /// **'في المكتب'**
  String get merchantReceiptMethodOffice;

  /// Settled on a staff member's visit (RA §12.4).
  ///
  /// In ar, this message translates to:
  /// **'زيارة ميدانية'**
  String get merchantReceiptMethodField;

  /// The staff member who took or paid the money (RA §12.4).
  ///
  /// In ar, this message translates to:
  /// **'الموظف: {name}'**
  String merchantReceiptStaff(String name);

  /// A currency line in another currency than the base, with its base value.
  ///
  /// In ar, this message translates to:
  /// **'{amount} (القيمة بالعملة الأساسية {base})'**
  String merchantReceiptLineBase(String amount, String base);

  /// The receipt's total in the base, as printed.
  ///
  /// In ar, this message translates to:
  /// **'المجموع: {amount}'**
  String merchantReceiptTotal(String amount);

  /// What was owed before the receipt, as printed.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد قبل: {due}'**
  String merchantReceiptDueBefore(String due);

  /// What is owed after the receipt, as printed.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد بعد: {due}'**
  String merchantReceiptDueAfter(String due);

  /// What the restaurant owes.
  ///
  /// In ar, this message translates to:
  /// **'عليك {amount}'**
  String merchantReceiptDueOwed(String amount);

  /// Nothing owed either way.
  ///
  /// In ar, this message translates to:
  /// **'لا رصيد'**
  String get merchantReceiptDueNone;

  /// A cashier opened the statements or receipts (R10; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'الكشوف والإيصالات للمالكين فقط.'**
  String get merchantRecordsNotAllowed;

  /// The statements or receipts could not be read (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التحميل.'**
  String get merchantRecordsFailed;

  /// Opens the problem report on a delivered order (CU §12.2).
  ///
  /// In ar, this message translates to:
  /// **'الإبلاغ عن مشكلة'**
  String get customerReportProblem;

  /// The report's type, from Content's customer_problem list (CU §12.2).
  ///
  /// In ar, this message translates to:
  /// **'نوع المشكلة'**
  String get customerReportType;

  /// The order's lines the report names, required for «صنف ناقص», «صنف خطأ» and «الطلب تالف» (CU §12.2).
  ///
  /// In ar, this message translates to:
  /// **'الأصناف المتأثرة'**
  String get customerReportItems;

  /// The report's optional note, up to 300 characters (CU §12.2).
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة (اختياري)'**
  String get customerReportNote;

  /// The report's note when the type («أخرى») requires it (CU §12.2).
  ///
  /// In ar, this message translates to:
  /// **'اكتب المشكلة'**
  String get customerReportNoteRequired;

  /// The report's optional photos, up to 3 (CU §12.2).
  ///
  /// In ar, this message translates to:
  /// **'الصور (حتى 3)'**
  String get customerReportPhotos;

  /// The price report's one optional photo (CU §9.5).
  ///
  /// In ar, this message translates to:
  /// **'صورة (اختياري)'**
  String get customerReportPhoto;

  /// Takes a photo with the camera for a report (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'التقاط صورة'**
  String get photoCamera;

  /// Picks a photo from the phone for a report (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'من المعرض'**
  String get photoGallery;

  /// Removes a photo from a report before sending (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'حذف الصورة'**
  String get photoRemove;

  /// A photo above 8 MB (architecture §5.8; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'الصورة كبيرة جداً، اختر صورة أصغر.'**
  String get photoTooLarge;

  /// Sends a report (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'إرسال البلاغ'**
  String get customerReportSend;

  /// The report's window ended meanwhile (CU §12.2; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة الإبلاغ عن هذا الطلب. تواصل مع الدعم.'**
  String get customerReportClosed;

  /// One report per order (CU §12.2, Q17; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'أرسلت بلاغاً عن هذا الطلب من قبل.'**
  String get customerReportAlready;

  /// A photo could not be uploaded or was refused (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر رفع الصورة. حاول مجدداً.'**
  String get customerReportPhotoFailed;

  /// Outside the report's window, or on a failed or cancelled order: call and WhatsApp (CU §12.2).
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع الدعم'**
  String get customerContactSupport;

  /// Opens the price report on a restaurant page (CU §9.5).
  ///
  /// In ar, this message translates to:
  /// **'أبلغ عن سعر مختلف'**
  String get customerReportPrice;

  /// The price report's optional item, from the menu (CU §9.5).
  ///
  /// In ar, this message translates to:
  /// **'الصنف (اختياري)'**
  String get customerPriceItem;

  /// No item chosen in the price report (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'بدون تحديد صنف'**
  String get customerPriceNoItem;

  /// The price report's optional shop price, in the base currency (CU §9.5).
  ///
  /// In ar, this message translates to:
  /// **'السعر في المحل (اختياري)'**
  String get customerShopPrice;

  /// A shop price that is not a number above zero (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'اكتب السعر بالأرقام'**
  String get customerShopPriceInvalid;

  /// The price report's answer (CU §9.5).
  ///
  /// In ar, this message translates to:
  /// **'شكراً، سنتحقق من السعر'**
  String get customerPriceThanks;

  /// One price report per restaurant per business day (CU §9.5).
  ///
  /// In ar, this message translates to:
  /// **'أرسلت بلاغاً عن هذا المطعم اليوم'**
  String get customerPriceToday;

  /// A report's status (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'جديدة'**
  String get ticketNew;

  /// A report's status (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'قيد المعالجة'**
  String get ticketInProgress;

  /// A report's status (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'بانتظار رد'**
  String get ticketWaiting;

  /// A report's status (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'محلولة'**
  String get ticketResolved;

  /// A report's status (AP Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'مغلقة'**
  String get ticketClosed;

  /// The report's answer (CU §12.2): the ticket's number and its timer («24 ساعة», support.resolution_post_delivery_hours; owner decision 2026-11-17).
  ///
  /// In ar, this message translates to:
  /// **'استلمنا بلاغك T-{number}. سنرد عليك خلال {within}.'**
  String customerReportSent(String number, String within);

  /// The order's report and its status (CU §12.2).
  ///
  /// In ar, this message translates to:
  /// **'بلاغك T-{number}: {status}'**
  String customerReportStatus(String number, String status);

  /// A line of the order in the report's items: its name and how many are affected.
  ///
  /// In ar, this message translates to:
  /// **'{name} × {quantity}'**
  String customerReportLine(String name, String quantity);

  /// The link to a free re-delivery placed for this order (CU §12.3).
  ///
  /// In ar, this message translates to:
  /// **'إعادة التوصيل: الطلب #{number}'**
  String customerRedeliveryOrder(String number);

  /// A ticket's timer in whole hours, in «سنرد عليك خلال …».
  ///
  /// In ar, this message translates to:
  /// **'{count} ساعة'**
  String replyWithinHours(int count);

  /// A ticket's timer in minutes, in «سنرد عليك خلال …».
  ///
  /// In ar, this message translates to:
  /// **'{count} دقيقة'**
  String replyWithinMinutes(int count);

  /// The support screen (RA §15).
  ///
  /// In ar, this message translates to:
  /// **'الدعم'**
  String get merchantSupport;

  /// RA §15: calls operations with the number from Content.
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالعمليات'**
  String get merchantCallOperations;

  /// RA §15: WhatsApp to operations with the number from Content.
  ///
  /// In ar, this message translates to:
  /// **'واتساب العمليات'**
  String get merchantWhatsappOperations;

  /// RA §15: opens the report form.
  ///
  /// In ar, this message translates to:
  /// **'إبلاغ عن مشكلة'**
  String get merchantReportProblem;

  /// RA §15: the restaurant's tickets.
  ///
  /// In ar, this message translates to:
  /// **'بلاغاتي'**
  String get merchantMyReports;

  /// «بلاغاتي» with none (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا بلاغات بعد.'**
  String get merchantMyReportsEmpty;

  /// «بلاغاتي» could not be read (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل البلاغات.'**
  String get merchantReportsFailed;

  /// Reads «بلاغاتي» again.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get merchantReportsRetry;

  /// The report's type (RA Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'نوع المشكلة'**
  String get merchantReportType;

  /// Content's lists could not be read (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل أنواع البلاغات.'**
  String get merchantReportTypesFailed;

  /// RA §15: optionally an order of the board.
  ///
  /// In ar, this message translates to:
  /// **'الطلب (اختياري)'**
  String get merchantReportOrder;

  /// No order linked to the report.
  ///
  /// In ar, this message translates to:
  /// **'بدون طلب'**
  String get merchantReportNoOrder;

  /// «طلب تعديل بيانات»: what it asks to change (owner decision 2026-11-17).
  ///
  /// In ar, this message translates to:
  /// **'المطلوب تعديله'**
  String get merchantReportSubject;

  /// RA §15: a data change of the minimum order.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للطلب'**
  String get merchantSubjectMinOrder;

  /// RA §15: a data change of the delivery coverage.
  ///
  /// In ar, this message translates to:
  /// **'منطقة التوصيل'**
  String get merchantSubjectCoverage;

  /// RA §15: adding or removing an owner.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مالك أو إزالته'**
  String get merchantSubjectOwners;

  /// RA §15: changing the owner's phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف المالك'**
  String get merchantSubjectOwnerPhone;

  /// The report's note.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة'**
  String get merchantReportNote;

  /// Sends the report.
  ///
  /// In ar, this message translates to:
  /// **'إرسال البلاغ'**
  String get merchantReportSend;

  /// No answer or a refusal (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم يُرسل البلاغ، حاول مرة أخرى.'**
  String get merchantReportFailed;

  /// Content changed the types meanwhile (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تغيّرت أنواع البلاغات، اختر مرة أخرى.'**
  String get merchantReportTypeChanged;

  /// The photo could not be uploaded or was refused (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر رفع الصورة، حاول مرة أخرى.'**
  String get merchantReportPhotoFailed;

  /// The order is not the restaurant's any more (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم يُعثر على الطلب.'**
  String get merchantReportOrderGone;

  /// An owner's «بلاغاتي»: a ticket another user of the restaurant opened.
  ///
  /// In ar, this message translates to:
  /// **'من مستخدم آخر'**
  String get merchantReportBy;

  /// RA §8.19: the order's problem options.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة في الطلب'**
  String get merchantOrderProblem;

  /// RA §8.19: the quick reasons below the call and WhatsApp (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'أو أبلغ العمليات بسبب سريع:'**
  String get merchantOrderProblemHint;

  /// RA §15: the ticket opened, with its timer.
  ///
  /// In ar, this message translates to:
  /// **'استلمنا بلاغك T-{number}. سنرد عليك خلال {within}.'**
  String merchantReportSent(String number, String within);

  /// A ticket in «بلاغاتي»: its number and type.
  ///
  /// In ar, this message translates to:
  /// **'T-{number} · {type}'**
  String merchantReportTitle(String number, String type);

  /// A ticket's order in «بلاغاتي».
  ///
  /// In ar, this message translates to:
  /// **'الطلب #{number}'**
  String merchantReportOrderLine(String number);

  /// The resolution message in «بلاغاتي».
  ///
  /// In ar, this message translates to:
  /// **'الرد: {message}'**
  String merchantReportReply(String message);

  /// The WhatsApp text of «مشكلة في الطلب».
  ///
  /// In ar, this message translates to:
  /// **'بخصوص الطلب #{number}'**
  String merchantWhatsappOrderMessage(String number);

  /// An owner's «بلاغاتي»: a ticket operations opened on the restaurant (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'من العمليات'**
  String get merchantReportByOperations;

  /// CA §13: the support screen, from «المزيد».
  ///
  /// In ar, this message translates to:
  /// **'الدعم'**
  String get captainSupport;

  /// CA §13: report a problem.
  ///
  /// In ar, this message translates to:
  /// **'إبلاغ عن مشكلة'**
  String get captainReportProblem;

  /// CA §13: the captain's tickets.
  ///
  /// In ar, this message translates to:
  /// **'بلاغاتي'**
  String get captainMyReports;

  /// «بلاغاتي» with no ticket (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لا بلاغات بعد.'**
  String get captainMyReportsEmpty;

  /// «بلاغاتي» could not be read.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل البلاغات.'**
  String get captainReportsFailed;

  /// Read «بلاغاتي» or the types again.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get captainReportsRetry;

  /// CA §13: the report's type (Appendix C).
  ///
  /// In ar, this message translates to:
  /// **'نوع المشكلة'**
  String get captainReportType;

  /// The types could not be read.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل أنواع البلاغات.'**
  String get captainReportTypesFailed;

  /// CA §13: the report names the active order (optional).
  ///
  /// In ar, this message translates to:
  /// **'عن الطلب الجاري #{number}'**
  String captainReportAboutOrder(String number);

  /// The report's note, up to 300 characters.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة'**
  String get captainReportNote;

  /// Send the report.
  ///
  /// In ar, this message translates to:
  /// **'إرسال البلاغ'**
  String get captainReportSend;

  /// No answer or a refusal: send again.
  ///
  /// In ar, this message translates to:
  /// **'لم يُرسل البلاغ، حاول مرة أخرى.'**
  String get captainReportFailed;

  /// Content changed the types meanwhile.
  ///
  /// In ar, this message translates to:
  /// **'تغيّرت أنواع البلاغات، اختر مرة أخرى.'**
  String get captainReportTypeChanged;

  /// The photo could not be uploaded.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر رفع الصورة، حاول مرة أخرى.'**
  String get captainReportPhotoFailed;

  /// The order is not the captain's any more (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم يعد الطلب طلبك.'**
  String get captainReportOrderGone;

  /// CA §13: the ticket opened, with its timer.
  ///
  /// In ar, this message translates to:
  /// **'استلمنا بلاغك T-{number}. سنرد عليك خلال {within}.'**
  String captainReportSent(String number, String within);

  /// A ticket in «بلاغاتي»: its number and type.
  ///
  /// In ar, this message translates to:
  /// **'T-{number} · {type}'**
  String captainReportTitle(String number, String type);

  /// A ticket's order in «بلاغاتي».
  ///
  /// In ar, this message translates to:
  /// **'الطلب #{number}'**
  String captainReportOrderLine(String number);

  /// The resolution message in «بلاغاتي».
  ///
  /// In ar, this message translates to:
  /// **'الرد: {message}'**
  String captainReportReply(String message);

  /// «بلاغاتي»: a ticket operations opened on the captain (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'من العمليات'**
  String get captainReportByOperations;

  /// CA §9.11: «مشكلة»'s report with a quick reason (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'إبلاغ العمليات بسبب سريع'**
  String get captainProblemQuickReason;

  /// CA §9.4 item 6: what the captain handed the restaurant.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة في مبلغ الاستلام'**
  String get captainPickupAmountTitle;

  /// CA §9.4 item 6 (owner decision 2026-11-17): the lines the captain actually paid.
  ///
  /// In ar, this message translates to:
  /// **'اكتب ما دفعته للمطعم فعلاً بكل عملة.'**
  String get captainPickupAmountHint;

  /// The lines recorded at the pickup.
  ///
  /// In ar, this message translates to:
  /// **'المسجّل عند الاستلام: {lines}'**
  String captainPickupAmountRecorded(String lines);

  /// A typed amount is not a positive number.
  ///
  /// In ar, this message translates to:
  /// **'اكتب ما دفعته بأرقام صحيحة.'**
  String get captainPickupAmountInvalid;

  /// 400 no_difference (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'ما كتبته يطابق المسجّل عند الاستلام.'**
  String get captainPickupAmountSame;

  /// 409 pickup_already_disputed (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'سبق الإبلاغ عن مبلغ استلام هذا الطلب.'**
  String get captainPickupAmountDisputed;

  /// 409 order_state_changed (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'لم يعد هذا البلاغ متاحاً لهذا الطلب.'**
  String get captainProblemClosed;

  /// The account screen and its link on home (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get customerMyAccountTitle;

  /// «حسابي»: the profile item and its edit screen's title (CU §13, §5.3; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'بياناتي'**
  String get customerAccountProfile;

  /// The read-only phone in the profile (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get customerAccountPhone;

  /// Under the read-only phone (CU §13, §5.4).
  ///
  /// In ar, this message translates to:
  /// **'لتغيير رقمك تواصل مع الدعم'**
  String get customerAccountPhoneHint;

  /// «حسابي»: the FAQ and support contacts (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'المساعدة'**
  String get customerAccountHelp;

  /// «حسابي»: joining as a captain or a restaurant (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'انضم إلينا'**
  String get customerJoinUs;

  /// Opens the captain app's store page (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'انضم ككابتن'**
  String get customerJoinAsCaptain;

  /// Opens WhatsApp to support (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'أضف مطعمك'**
  String get customerAddRestaurant;

  /// The WhatsApp message «أضف مطعمك» prefills (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'أريد إضافة مطعمي إلى FOX DROP'**
  String get customerAddRestaurantMessage;

  /// «حسابي»: the terms and privacy in force (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'الشروط والخصوصية'**
  String get customerTermsAndPrivacy;

  /// «حسابي»: the app's version (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'عن التطبيق'**
  String get customerAbout;

  /// The app's version under «عن التطبيق» (CU §13).
  ///
  /// In ar, this message translates to:
  /// **'الإصدار {version}'**
  String customerAppVersion(String version);

  /// Signs out every device of the account (CU §13, §5.4).
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج من كل الأجهزة'**
  String get customerSignOutEverywhere;

  /// The confirmation before signing out everywhere (CU §5.4; no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'سيُسجَّل خروجك من كل الأجهزة، ومنها هذا الجهاز. لا تتأثر طلباتك الجارية.'**
  String get customerSignOutEverywhereConfirm;

  /// The call failed (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تسجيل الخروج من كل الأجهزة. حاول مرة أخرى.'**
  String get customerSignOutEverywhereFailed;

  /// A restaurant in test mode, seen only by an admin test account (CU §8.2, AP §9.8).
  ///
  /// In ar, this message translates to:
  /// **'تجريبي'**
  String get customerTestMode;

  /// «حسابي» → «حذف الحساب» (CU §5.6, D19).
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get customerDeleteAccount;

  /// CU §5.6 item 2: the first point of the explanation (wording ours).
  ///
  /// In ar, this message translates to:
  /// **'لن تتمكن من تسجيل الدخول إلى هذا الحساب.'**
  String get customerDeleteAccountNoSignIn;

  /// CU §5.6 item 2: the second point (wording ours).
  ///
  /// In ar, this message translates to:
  /// **'ستفقد أكوادك ومفضلتك.'**
  String get customerDeleteAccountLoses;

  /// CU §5.6 item 2: the third point, AP §13 item 6 (wording ours).
  ///
  /// In ar, this message translates to:
  /// **'تُعامل بياناتك كما تنص سياسة الخصوصية.'**
  String get customerDeleteAccountPrivacy;

  /// CU §5.6 item 3 (Q20): a fresh code to the account's number (wording ours).
  ///
  /// In ar, this message translates to:
  /// **'إرسال رمز التحقق'**
  String get customerDeleteAccountSendCode;

  /// After the code was sent (wording ours).
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمزاً إلى رقمك على واتساب. أدخله لتأكيد حذف الحساب.'**
  String get customerDeleteAccountCodeSent;

  /// Closes the account with the code (wording ours).
  ///
  /// In ar, this message translates to:
  /// **'تأكيد حذف الحساب'**
  String get customerDeleteAccountConfirm;

  /// CU §5.6: refused with an active order.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن حذف الحساب أثناء وجود طلب جارٍ'**
  String get customerDeleteAccountActiveOrder;

  /// Any other failure (no wording in the spec).
  ///
  /// In ar, this message translates to:
  /// **'تعذّر حذف الحساب. حاول مرة أخرى.'**
  String get customerDeleteAccountFailed;
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
