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

  @override
  String get customerUpdateRequired => 'حدّث التطبيق لتتمكن من الطلب';

  @override
  String get customerMaintenance => 'FOX DROP في صيانة الآن، حاول بعد قليل';

  @override
  String customerPlatformClosed(String time) {
    return 'FOX DROP يستقبل الطلبات من الساعة $time';
  }

  @override
  String get customerPlatformClosedNow => 'FOX DROP لا يستقبل الطلبات الآن';

  @override
  String customerBelowMinimum(String amount) {
    return 'أضف $amount لتصل إلى الحد الأدنى';
  }

  @override
  String get customerOneOrderAtATime =>
      'يمكنك طلب واحد في كل مرة حتى يكتمل طلبك الحالي';

  @override
  String get customerActiveOrderLimit => 'وصلت إلى الحد الأقصى للطلبات الجارية';

  @override
  String get customerNoCaptain => 'الضغط عالٍ الآن، جرّب بعد دقائق';

  @override
  String customerPriceChanged(String item, String oldPrice, String newPrice) {
    return 'تغيّر سعر $item من $oldPrice إلى $newPrice';
  }

  @override
  String customerItemGone(String item) {
    return '$item لم يعد متوفراً';
  }

  @override
  String get customerCannotPrice => 'لا يمكن الطلب من هذا المطعم الآن';

  @override
  String get customerAddItems => 'أضف أصنافاً';

  @override
  String get customerChangeAddress => 'تغيير العنوان';

  @override
  String get customerRetry => 'إعادة المحاولة';

  @override
  String get customerDeliveryAddress => 'عنوان التوصيل';

  @override
  String get customerLabelHome => 'البيت';

  @override
  String get customerLabelWork => 'العمل';

  @override
  String get customerLabelOther => 'آخر';

  @override
  String get customerCustomLabel => 'اسم العنوان';

  @override
  String get customerOutsideZoneNow => 'خارج منطقة التوصيل حالياً';

  @override
  String get customerDeliverToCurrentLocation => 'التوصيل إلى موقعي الحالي';

  @override
  String customerLowAccuracy(String distance) {
    return 'دقة موقعك $distance. حدّث موقعك إن لم يكن العنوان دقيقاً.';
  }

  @override
  String get customerUpdateLocation => 'تحديث الموقع';

  @override
  String get customerNeighbourhood => 'الحي';

  @override
  String get customerStreet => 'الشارع والبناء';

  @override
  String get customerFloor => 'الطابق والشقة';

  @override
  String get customerLandmark => 'بالقرب من';

  @override
  String get customerLandmarkHint => 'مثلاً: قرب جامع النور';

  @override
  String get customerContactPhone => 'رقم التواصل';

  @override
  String get customerContactPhoneHint => 'رقم حسابك إن تركته فارغاً';

  @override
  String get customerRecipientName => 'اسم المستلم';

  @override
  String get customerDirections => 'توجيهات للكابتن';

  @override
  String get customerDirectionsHint => 'مثلاً: الباب الأزرق بجانب الصيدلية';

  @override
  String get customerSaveAddress => 'احفظ هذا العنوان';

  @override
  String customerLengthBetween(int min, int max) {
    return 'اكتب من $min إلى $max حرفاً';
  }

  @override
  String customerLengthUpTo(int max) {
    return '$max حرفاً على الأكثر';
  }

  @override
  String get customerOrderNote => 'ملاحظة للمطعم والكابتن';

  @override
  String get customerPayIn => 'سأدفع بـ';

  @override
  String get customerPayInUnset => 'لم أحدد';

  @override
  String customerPayAbout(String amount) {
    return 'ستدفع حوالي $amount';
  }

  @override
  String get customerCashOnDelivery => 'نقداً عند الاستلام';

  @override
  String customerArrivesWithin(int from, int to) {
    return 'يصل خلال $from–$to د';
  }

  @override
  String get customerItemsValue => 'قيمة الأصناف';

  @override
  String get customerDeliveryFee => 'رسوم التوصيل';

  @override
  String get customerFree => 'مجاني';

  @override
  String get customerDiscount => 'الخصم';

  @override
  String get customerRounding => 'تقريب';

  @override
  String get customerTotal => 'المجموع';

  @override
  String customerOrEquivalents(String amounts) {
    return 'أو $amounts';
  }

  @override
  String get customerConfirm => 'تأكيد الطلب';

  @override
  String customerConfirmFor(String total) {
    return 'تأكيد الطلب — $total';
  }

  @override
  String get customerSending => 'جارٍ إرسال طلبك…';

  @override
  String get customerFarPinTitle => 'هل أنت متأكد من العنوان؟';

  @override
  String customerFarPinBody(String distance) {
    return 'النقطة تبعد $distance عن موقعك الحالي.';
  }

  @override
  String get customerFarPinSend => 'نعم، أرسل إلى هذا العنوان';

  @override
  String get customerQuoteChanged =>
      'تغيّر شيء في طلبك. راجع التفاصيل ثم أكّد مجدداً.';

  @override
  String get customerOrderBlocked =>
      'لم نتمكن من إرسال طلبك. راجع المشكلة أعلاه.';

  @override
  String get customerAddressOutside => 'العنوان خارج منطقة التوصيل';

  @override
  String get customerSaveAddressFailed => 'تعذّر حفظ العنوان، ولم يُرسل الطلب.';

  @override
  String get customerSendFailed => 'تعذّر إرسال طلبك، حاول مجدداً.';

  @override
  String customerOrderNumber(String number) {
    return '#$number';
  }

  @override
  String customerOrderSent(String restaurant) {
    return 'أرسلنا طلبك إلى $restaurant';
  }

  @override
  String get customerStatusPlaced => 'بانتظار تأكيد المطعم';

  @override
  String get customerStatusAccepted => 'المطعم يحضّر طلبك';

  @override
  String get customerStatusReady => 'طلبك جاهز';

  @override
  String get customerStatusPickedUp => 'في الطريق إليك';

  @override
  String get customerStatusArrived => 'الكابتن عند الباب';

  @override
  String get customerStatusDelivered => 'تم التسليم';

  @override
  String customerArrivesAbout(String time) {
    return 'يصل حوالي $time';
  }

  @override
  String get customerOrderInvalid =>
      'تحقق من بيانات العنوان والملاحظة ثم أكّد مجدداً.';

  @override
  String durationSeconds(int seconds) {
    return '$seconds ث';
  }

  @override
  String get vehicleWalking => 'سيراً على الأقدام';

  @override
  String get vehicleBicycle => 'دراجة';

  @override
  String get vehicleMotorbike => 'دراجة نارية';

  @override
  String get vehicleCar => 'سيارة';

  @override
  String get merchantColumnIncoming => 'جديدة';

  @override
  String get merchantColumnPreparing => 'قيد التحضير';

  @override
  String get merchantColumnReady => 'جاهزة';

  @override
  String get merchantColumnWithCaptain => 'مع الكابتن';

  @override
  String merchantColumnCount(String column, int count) {
    return '$column ($count)';
  }

  @override
  String merchantColumnLate(String column, int count, int late) {
    return '$column ($count) — متأخرة: $late';
  }

  @override
  String get merchantBoardEmpty => 'لا توجد طلبات الآن';

  @override
  String merchantSincePlaced(int minutes) {
    return 'منذ $minutes د';
  }

  @override
  String merchantItemCount(int count) {
    return 'الأصناف: $count';
  }

  @override
  String get merchantWaitingForCaptain => 'بانتظار كابتن';

  @override
  String merchantCaptainOnTheWay(String name) {
    return 'الكابتن $name في الطريق';
  }

  @override
  String merchantCaptainWaiting(int minutes) {
    return 'وصل الكابتن — ينتظر منذ $minutes د';
  }

  @override
  String get merchantCaptainAsksPickup => 'الكابتن يطلب تأكيد الاستلام';

  @override
  String merchantWithCaptain(String name) {
    return 'مع الكابتن $name';
  }

  @override
  String merchantAutoCancelIn(String time) {
    return 'يُلغى تلقائياً خلال $time';
  }

  @override
  String merchantPrepLeft(String time) {
    return 'متبقٍ $time';
  }

  @override
  String merchantPrepLate(int minutes) {
    return 'متأخر $minutes د';
  }

  @override
  String merchantPickedUpSince(int minutes) {
    return 'استُلم منذ $minutes د';
  }

  @override
  String merchantAccept(int minutes) {
    return 'قبول — $minutes د';
  }

  @override
  String get merchantReady => 'الطلب جاهز';

  @override
  String get merchantWhyReady => 'لماذا أضغط «الطلب جاهز»؟';

  @override
  String get merchantWhyReadyText =>
      'يُبلَّغ الكابتن فوراً، ويرى الزبون «طلبك جاهز». الضغط في الوقت يُبقي نسبة تأخر مطعمك منخفضة.';

  @override
  String get merchantNeedMoreTime => 'تحتاج وقتاً أطول؟ اتصل بالعمليات';

  @override
  String get merchantConfirmPickup => 'تأكيد الاستلام';

  @override
  String get merchantAmountIncorrect => 'المبلغ غير صحيح';

  @override
  String get merchantOrderIncomplete => 'الطلب غير مكتمل';

  @override
  String get merchantSending => 'جارٍ الإرسال…';

  @override
  String merchantNewOrder(String number) {
    return 'طلب جديد #$number';
  }

  @override
  String merchantItemsValueOnPickup(String amount) {
    return '$amount — يدفعها لك الكابتن عند الاستلام';
  }

  @override
  String merchantItemsValue(String amount) {
    return 'قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام: $amount';
  }

  @override
  String get merchantLateReply => 'تأخرتم في الرد — سيتصل بكم فريق العمليات';

  @override
  String merchantPromptCount(int index, int count) {
    return '$index من $count';
  }

  @override
  String merchantPickupPrompt(String name, String amount, String number) {
    return 'الكابتن $name يؤكد أنه دفع لك $amount واستلم الطلب #$number';
  }

  @override
  String merchantBaseEquivalent(String amount) {
    return 'يعادل $amount';
  }

  @override
  String merchantAutoConfirmIn(int seconds) {
    return 'يُؤكَّد تلقائياً خلال $seconds ث';
  }

  @override
  String get merchantOffline =>
      'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال';

  @override
  String merchantAutoCancelled(String number) {
    return 'أُلغي الطلب #$number لعدم الرد';
  }

  @override
  String merchantCancelled(String number) {
    return 'أُلغي الطلب #$number';
  }

  @override
  String merchantPrepLateChime(String number) {
    return 'تحضير متأخر #$number — اضغط «الطلب جاهز» فور الانتهاء';
  }

  @override
  String merchantCaptainArrived(String name, String number) {
    return 'وصل الكابتن $name لاستلام الطلب #$number';
  }

  @override
  String merchantCaptainKeptWaiting(String number, int minutes) {
    return 'الكابتن ينتظر الطلب #$number منذ $minutes دقائق';
  }

  @override
  String merchantPickupConfirmedBy(String name) {
    return 'أكّد $name الاستلام';
  }

  @override
  String merchantPickupDisputedBy(String name) {
    return 'أبلغ $name أن المبلغ غير صحيح';
  }

  @override
  String merchantPickupIncompleteBy(String name) {
    return 'أبلغ $name أن الطلب غير مكتمل';
  }

  @override
  String merchantPickupAutoConfirmed(String number) {
    return 'تأكيد تلقائي — الطلب #$number';
  }

  @override
  String merchantPickupByOperations(String number) {
    return 'أكّدت العمليات الاستلام — الطلب #$number';
  }

  @override
  String merchantPickupClosed(String number) {
    return 'أُغلق طلب الاستلام — الطلب #$number';
  }

  @override
  String merchantAcceptedOnDevice(String device) {
    return 'قُبل الطلب من جهاز $device';
  }

  @override
  String get merchantAcceptedElsewhere => 'قُبل الطلب من جهاز آخر';

  @override
  String get merchantCancelledFirst => 'أُلغي الطلب قبل وصول قبولك';

  @override
  String get merchantStateChanged => 'تغيّرت حالة الطلب قبل وصول طلبك';

  @override
  String get merchantLinesRefused =>
      'المبالغ لا تطابق قيمة الأصناف أو بعملة لا يقبلها المطعم';

  @override
  String get merchantAlreadyDisputed => 'سبق الإبلاغ عن مبلغ هذا الطلب';

  @override
  String get merchantCommandFailed => 'تعذّر الإرسال، حاول مجدداً';

  @override
  String merchantCustomer(String name, String neighbourhood) {
    return '$name — $neighbourhood';
  }

  @override
  String merchantCustomerNote(String note) {
    return 'ملاحظة الزبون: $note';
  }

  @override
  String get merchantReadyNotPressed => 'لم يُضغط جاهز';

  @override
  String get merchantPickedUp => 'تم الاستلام';

  @override
  String get merchantDelivered => 'تم التسليم';

  @override
  String get merchantDisputeTitle => 'ما المبلغ الذي استلمته فعلاً؟';

  @override
  String merchantDisputeAmount(String currency) {
    return 'المبلغ بـ $currency';
  }

  @override
  String get merchantSend => 'إرسال';

  @override
  String get merchantClose => 'إغلاق';

  @override
  String get customerStepConfirm => 'تأكيد المطعم';

  @override
  String get customerStepPreparing => 'التحضير';

  @override
  String get customerStepOnTheWay => 'في الطريق';

  @override
  String get customerStepAtDoor => 'عند الباب';

  @override
  String get customerStepDelivered => 'التسليم';

  @override
  String customerCaptainToRestaurant(String name) {
    return 'الكابتن $name في طريقه إلى المطعم';
  }

  @override
  String customerCaptainAtRestaurant(String name) {
    return 'الكابتن $name وصل إلى المطعم';
  }

  @override
  String get customerAwaitingCaptain => 'ينتظر الكابتن';

  @override
  String get customerCaptainCollecting => 'الكابتن يستلم طلبك الآن';

  @override
  String customerCaptainPickedUp(String name) {
    return 'الكابتن $name استلم طلبك';
  }

  @override
  String customerPrepareAmount(String amount) {
    return 'جهّز $amount';
  }

  @override
  String get customerEnjoy => 'بالعافية!';

  @override
  String get customerRejected => 'نعتذر، لم يقبل المطعم طلبك';

  @override
  String get customerNoRestaurantResponse => 'لم يرد المطعم على طلبك، نعتذر';

  @override
  String get customerCancelled => 'أُلغي طلبك';

  @override
  String get customerDeliveryFailed => 'تعذّر التسليم';

  @override
  String customerActiveOrder(String restaurant, String status) {
    return 'طلبك من $restaurant: $status';
  }

  @override
  String customerActiveOrders(int count) {
    return 'طلباتك النشطة: $count';
  }

  @override
  String get captainStateOffline => 'غير متصل';

  @override
  String get captainStateAvailable => 'متصل متاح';

  @override
  String get captainStateBusy => 'مشغول';

  @override
  String get captainStateNoOffers => 'لا تصلك عروض';

  @override
  String get captainStateSuspended => 'موقوف';

  @override
  String get captainOnlineSwitch => 'متصل';

  @override
  String captainOwes(String amount) {
    return 'عليك تسليم $amount';
  }

  @override
  String captainNoOffersCashLimit(String amount) {
    return 'بلغت حد العهدة ($amount). سلّم النقد في المكتب لتصلك العروض.';
  }

  @override
  String captainNoOffersClosedDue(String amount) {
    return 'لديك نقد غير مسلّم: $amount. سلّمه في المكتب لتصلك العروض.';
  }

  @override
  String get captainStopMockLocation =>
      'أوقف تطبيقات تغيير الموقع لتتمكن من الاتصال.';

  @override
  String captainBlockClosedDue(String date, String amount) {
    return 'لديك نقد غير مسلّم من يوم $date: $amount. سلّمه في المكتب لتتمكن من الاتصال.';
  }

  @override
  String captainBlockSuspendedUntil(String date, String reason) {
    return 'حسابك موقوف حتى $date: $reason';
  }

  @override
  String captainBlockSuspended(String reason) {
    return 'حسابك موقوف: $reason';
  }

  @override
  String captainBlockVersion(String version) {
    return 'حدّث التطبيق إلى الإصدار $version لتتمكن من الاتصال.';
  }

  @override
  String get captainTrackingNotice =>
      'أنت متصل — FOX DROP يتابع موقعك لتصلك العروض';

  @override
  String get captainLocationOff => 'شغّل الموقع في هاتفك لتتمكن من الاتصال.';

  @override
  String get captainLocationDenied =>
      'اسمح لتطبيق الكابتن بالوصول إلى موقعك لتتمكن من الاتصال.';

  @override
  String get captainLocationFailed => 'تعذّر تحديد موقعك، حاول مرة أخرى.';

  @override
  String get captainNoConnection =>
      'لا يوجد اتصال بالإنترنت — لن تصلك العروض حتى يعود الاتصال';

  @override
  String get captainOk => 'حسناً';

  @override
  String get captainSending => 'جارٍ الإرسال…';

  @override
  String get captainCommandFailed => 'تعذّر الإرسال، حاول مرة أخرى.';

  @override
  String get captainStateChanged => 'تغيّرت حالة الطلب قبل وصول طلبك.';

  @override
  String get captainNotOnline => 'أنت غير متصل.';

  @override
  String get captainStaleLocation => 'لم يتحدّد موقعك بعد، حاول بعد لحظات.';

  @override
  String get captainOfflineWithOrder => 'لا يمكنك قطع الاتصال أثناء طلب.';

  @override
  String get captainNewOffer => 'عرض جديد';

  @override
  String get captainOfferFromOperations => 'تعيين من العمليات';

  @override
  String captainOfferRestaurant(String restaurant, String distance) {
    return '$restaurant · $distance';
  }

  @override
  String captainOfferCustomer(String neighbourhood, String distance) {
    return '$neighbourhood · $distance';
  }

  @override
  String captainPayToRestaurant(String amount) {
    return 'تدفع للمطعم: $amount';
  }

  @override
  String captainCollectFromCustomer(String amount) {
    return 'تقبض من الزبون: $amount';
  }

  @override
  String captainOfferPreparing(int minutes) {
    return 'قيد التحضير — جاهز بعد $minutes د تقريباً';
  }

  @override
  String captainPreparing(int minutes) {
    return 'قيد التحضير — جاهز بعد $minutes د';
  }

  @override
  String get captainReady => 'جاهز';

  @override
  String get captainWaitingPayMayApply => 'قد يُضاف أجر انتظار';

  @override
  String get captainOfferNoPay => 'الأجر غير محدد';

  @override
  String get captainAccept => 'قبول';

  @override
  String get captainDecline => 'رفض';

  @override
  String get captainOfferExpired => 'انتهى العرض';

  @override
  String get captainOfferUnavailable => 'لم يعد العرض متاحاً';

  @override
  String captainOpsAssigned(String number) {
    return 'عيّنتك العمليات على طلب #$number';
  }

  @override
  String captainStep(int step, String name) {
    return 'الخطوة $step من 4: $name';
  }

  @override
  String get captainStepToRestaurant => 'إلى المطعم';

  @override
  String get captainStepAtRestaurant => 'عند المطعم';

  @override
  String get captainStepToCustomer => 'إلى الزبون';

  @override
  String get captainStepAtCustomer => 'عند الزبون';

  @override
  String captainOrderItems(String number, int count) {
    return 'الطلب #$number · الأصناف: $count';
  }

  @override
  String get captainStartNavigation => 'ابدأ الملاحة';

  @override
  String get captainCallRestaurant => 'اتصال بالمطعم';

  @override
  String get captainArrivedAtRestaurant => 'وصلت إلى المطعم';

  @override
  String get captainArrivedQuestion => 'هل وصلت إلى المطعم؟';

  @override
  String get captainGetCloser => 'اقترب من المطعم لتأكيد الوصول';

  @override
  String get captainWeakGps =>
      'إشارة الموقع ضعيفة — اتصل بالعمليات لتسجيل وصولك';

  @override
  String captainDistanceAway(String distance) {
    return 'على بعد $distance';
  }

  @override
  String captainWaitingSince(String duration) {
    return 'تنتظر منذ $duration';
  }

  @override
  String get captainOrderReadyNow => 'الطلب جاهز';

  @override
  String captainOrderReadyChime(String number) {
    return 'الطلب #$number جاهز';
  }

  @override
  String get captainItemsResponsibility =>
      'بعد تأكيد الأصناف يصبح أي نقص من مسؤوليتك';

  @override
  String captainLine(int quantity, String name) {
    return '$quantity × $name';
  }

  @override
  String captainPayRestaurant(String amount) {
    return 'ادفع للمطعم: $amount';
  }

  @override
  String get captainPaidAndPickedUp => 'دفعت للمطعم واستلمت الطلب';

  @override
  String get captainAwaitingRestaurant => 'بانتظار تأكيد المطعم';

  @override
  String get captainAmountMismatch => 'المبلغ لا يطابق المطلوب';

  @override
  String captainRestaurantReceived(String amount) {
    return 'المطعم يفيد بأنه استلم $amount. أكمل المبلغ ثم أعد التأكيد.';
  }

  @override
  String get captainRestaurantIncomplete =>
      'المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.';

  @override
  String get captainPickedUp => 'تم الاستلام — توجّه إلى الزبون';

  @override
  String get captainOpsConfirmedPickup => 'أكّدت العمليات الاستلام';

  @override
  String get captainPickupDisputed =>
      'فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات';

  @override
  String captainFloor(String floor) {
    return 'الطابق: $floor';
  }

  @override
  String captainNote(String note) {
    return 'ملاحظة: $note';
  }

  @override
  String captainPayIn(String currency) {
    return 'الزبون سيدفع بـ $currency';
  }

  @override
  String captainPromisedBefore(String time) {
    return 'التسليم المتوقع قبل $time';
  }

  @override
  String get captainCallCustomer => 'اتصال بالزبون';

  @override
  String get captainWhatsAppCustomer => 'واتساب الزبون';

  @override
  String get captainArrivedAtCustomer => 'وصلت';

  @override
  String get captainAwayTitle => 'أنت بعيد عن موقع الزبون. اختر السبب:';

  @override
  String get captainOtherHint => 'اكتب السبب';

  @override
  String get captainSend => 'إرسال';

  @override
  String get captainAmountDue => 'المبلغ المطلوب';

  @override
  String get captainAmountReceived => 'المبلغ المقبوض';

  @override
  String get captainChange => 'الباقي للزبون';

  @override
  String captainChangeDue(String amount) {
    return 'الباقي: $amount';
  }

  @override
  String captainShortBy(String amount) {
    return 'المبلغ المقبوض أقل من المطلوب بـ $amount';
  }

  @override
  String get captainOverpaid => 'سجّل الباقي الذي أعدته للزبون';

  @override
  String captainAmountDueChanged(String amount) {
    return 'تغيّر المبلغ المطلوب إلى $amount';
  }

  @override
  String get captainTip =>
      'إذا ترك لك الزبون الباقي إكرامية فهو لك، سجّله كأنك أعدته';

  @override
  String get captainInvalidAmount => 'أدخل مبلغاً صحيحاً';

  @override
  String get captainDelivered => 'تم التسليم';

  @override
  String captainEarned(String amount) {
    return 'ربحت من هذا الطلب: $amount';
  }

  @override
  String captainPayBase(String amount) {
    return 'الأجر الأساسي: $amount';
  }

  @override
  String captainPayDistance(String amount) {
    return 'أجر المسافة: $amount';
  }

  @override
  String captainPayTopUp(String amount) {
    return 'إكمال للحد الأدنى: $amount';
  }

  @override
  String captainPayWaiting(String amount) {
    return 'أجر الانتظار: $amount';
  }

  @override
  String captainCustodyChanged(String amount) {
    return 'تغيّرت عهدتك: $amount';
  }

  @override
  String captainHandInToday(String amount) {
    return 'عليك تسليم اليوم: $amount';
  }

  @override
  String get captainEndWork => 'إنهاء العمل';

  @override
  String get captainKeepWorking => 'متابعة العمل';

  @override
  String get captainChooseReason => 'اختر السبب';

  @override
  String get faqTitle => 'الأسئلة الشائعة';

  @override
  String get faqEmpty => 'لا توجد أسئلة بعد';

  @override
  String get contentFailed => 'تعذّر التحميل، اضغط لإعادة المحاولة';

  @override
  String get captainWorkRules => 'قواعد العمل';

  @override
  String get captainReasonChanged => 'تغيّرت قائمة الأسباب، اختر السبب من جديد';

  @override
  String get customerNotificationsAsk => 'اسمح بالإشعارات لتعرف متى يصل طلبك';

  @override
  String get customerNotificationsAllow => 'سماح';

  @override
  String get customerNotificationsNotNow => 'ليس الآن';

  @override
  String get customerNotificationsOff =>
      'الإشعارات متوقفة. فعّلها لتعرف متى يصل طلبك';

  @override
  String get customerNotificationsOpenSettings => 'الإعدادات';

  @override
  String get customerNotificationsTitle => 'الإشعارات';

  @override
  String get customerNotificationsEmpty => 'لا توجد إشعارات';

  @override
  String get platformUpdateRequiredTitle => 'يلزم تحديث التطبيق';

  @override
  String get platformUpdateRequiredMessage =>
      'هذا الإصدار لم يعد يعمل. حدّث التطبيق لتتابع.';

  @override
  String get platformUpdateSuggested => 'يتوفر إصدار أحدث من التطبيق.';

  @override
  String get platformUpdate => 'تحديث';

  @override
  String get platformLater => 'لاحقاً';

  @override
  String get platformMaintenanceTitle => 'التطبيق في صيانة';

  @override
  String get platformMaintenanceMessage =>
      'نعمل على تحسين الخدمة ونعود قريباً.';

  @override
  String get termsTitle => 'الشروط والخصوصية';

  @override
  String get termsNewVersion =>
      'نشرت FOX DROP نسخة جديدة من الشروط وسياسة الخصوصية. اقرأها ووافق عليها لتتابع.';

  @override
  String get termsAccept => 'أوافق على الشروط وسياسة الخصوصية';

  @override
  String get termsOutdated => 'نُشرت نسخة أحدث بينما كنت تقرأ. اقرأها ثم وافق.';

  @override
  String get termsFailed => 'تعذّر الاتصال بالخادم، حاول مرة أخرى';

  @override
  String get customerTermsPending => 'وافق على الشروط الجديدة لتتمكن من الطلب';

  @override
  String get customerTermsShow => 'عرض الشروط';

  @override
  String get captainTermsPendingBanner =>
      'وافق على الشروط الجديدة لتتمكن من الاتصال';

  @override
  String get merchantTermsPendingBanner =>
      'وافق على الشروط الجديدة لتستخدم شاشات المطعم الأخرى. الطلبات تصل كالمعتاد.';

  @override
  String get emergencyStopBanner =>
      'المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.';

  @override
  String get customerCannotOrderNow => 'لا يمكن استقبال الطلبات الآن';

  @override
  String get merchantStatusOpen => 'مفتوح';

  @override
  String merchantStatusBusyMode(int minutes) {
    return 'وضع الضغط +$minutes د';
  }

  @override
  String merchantStatusBusyExtra(int minutes) {
    return '+$minutes د';
  }

  @override
  String get merchantStatusBusy => 'مشغول';

  @override
  String get merchantStatusPaused => 'موقوف مؤقتاً';

  @override
  String get merchantStatusPausedByOperations => 'أوقفته العمليات';

  @override
  String get merchantStatusAutoPaused => 'أُوقف تلقائياً';

  @override
  String get merchantStatusClosed => 'مغلق';

  @override
  String merchantStatusHoliday(String date) {
    return 'إجازة حتى $date';
  }

  @override
  String get merchantStatusSuspended => 'معلّق';

  @override
  String get merchantStatusInactive => 'غير مفعّل';

  @override
  String merchantStatusPauseFirst(int minutes) {
    return 'إيقاف $minutes د';
  }

  @override
  String merchantStatusMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String get merchantStatusPauseUntilReopening => 'حتى أعيد الفتح';

  @override
  String get merchantStatusBusyModeOff => 'إلغاء وضع الضغط';

  @override
  String get merchantStatusResume => 'استئناف الاستقبال';

  @override
  String get merchantStatusLockedByOperations =>
      'أوقفت العمليات مطعمك — اتصل بهم لإعادة التشغيل';

  @override
  String get merchantStatusToday => 'اليوم';

  @override
  String merchantStatusClosesAt(String when) {
    return 'يغلق $when';
  }

  @override
  String merchantStatusOpensAt(String when) {
    return 'يفتح $when';
  }

  @override
  String merchantStatusPauseEnds(String when) {
    return 'ينتهي الإيقاف $when';
  }

  @override
  String merchantStatusLimitBanner(int count) {
    return 'وصلت إلى الحد الأقصى ($count طلبات جارية). لن تصلك طلبات جديدة حتى يُستلم أحدها.';
  }

  @override
  String merchantStatusBusyModeBanner(int minutes) {
    return 'وضع الضغط مفعّل: +$minutes د على وقت الطلبات الجديدة';
  }

  @override
  String get merchantStatusRefusedClosed => 'المطعم ليس مفتوحاً الآن';

  @override
  String get merchantStatusRefusedOther => 'تعذّر التنفيذ، حاول مرة أخرى';

  @override
  String merchantNoticeAutoPaused(int count) {
    return 'أُوقف مطعمك تلقائياً بعد $count طلبات دون رد. تواصل مع العمليات لإعادة التشغيل.';
  }

  @override
  String get merchantNoticePauseEnded =>
      'انتهى الإيقاف المؤقت — مطعمك يستقبل الطلبات';

  @override
  String merchantNoticeBusyReminder(int minutes) {
    return 'وضع الضغط ما زال مفعّلاً (+$minutes د)';
  }

  @override
  String merchantNoticePausedByOperations(String reason) {
    return 'أوقفت العمليات مطعمك مؤقتاً: $reason';
  }

  @override
  String get merchantNoticeResumedByOperations => 'أعادت العمليات تشغيل مطعمك';

  @override
  String get merchantNoticeBusyEndedByOperations => 'أنهت العمليات وضع الضغط';

  @override
  String get merchantStatusAndHours => 'الحالة والأوقات';

  @override
  String get merchantHoursSchedule => 'جدول الأسبوع';

  @override
  String get merchantHoursClosedAllDay => 'مغلق طوال اليوم';

  @override
  String get merchantHoursAddPeriod => 'إضافة فترة';

  @override
  String get merchantHoursTo => 'إلى';

  @override
  String get merchantHoursRemovePeriod => 'حذف الفترة';

  @override
  String get merchantHoursSaved => 'حُفظ التعديل';

  @override
  String get merchantHoursInvalidSchedule =>
      'الفترات متداخلة أو أقصر من 30 دقيقة';

  @override
  String get merchantHoursInvalidHoliday => 'اختر موعد انتهاء بعد موعد البداية';

  @override
  String get merchantHoursInvalidSettings => 'القيمة خارج الحدود المسموحة';

  @override
  String get merchantHoursHoliday => 'إغلاق لعدة أيام';

  @override
  String merchantHoursHolidayFromTo(String from, String to) {
    return 'مغلق من $from حتى $to';
  }

  @override
  String get merchantHoursEndHoliday => 'إنهاء الإغلاق';

  @override
  String get merchantHoursFromNow => 'من الآن';

  @override
  String merchantHoursFrom(String when) {
    return 'من $when';
  }

  @override
  String get merchantHoursUntilPick => 'حتى… اختر التاريخ والساعة';

  @override
  String merchantHoursUntil(String when) {
    return 'حتى $when';
  }

  @override
  String get merchantHoursHolidayMessage => 'رسالة للزبائن (اختياري)';

  @override
  String get merchantHoursCloseHoliday => 'إغلاق المطعم';

  @override
  String get merchantHoursDefaultPrep => 'وقت التحضير الافتراضي';

  @override
  String get merchantHoursMaxActiveOrders => 'الحد الأقصى للطلبات الجارية';

  @override
  String get merchantHoursNoLimit => 'بلا حد';

  @override
  String get merchantHoursSetByFoxDrop => 'تحددها FOX DROP';

  @override
  String get merchantHoursMinimumOrder => 'الحد الأدنى للطلب';

  @override
  String get merchantHoursCoverage => 'منطقة التوصيل';

  @override
  String merchantHoursCoverageRadius(String distance) {
    return 'حتى $distance من المطعم';
  }

  @override
  String merchantHoursCoverageZones(int count) {
    return '$count مناطق';
  }

  @override
  String get merchantHoursCommission => 'العمولة';

  @override
  String merchantHoursPercent(String value) {
    return '$value%';
  }

  @override
  String get merchantHoursSettlementDay => 'يوم التسوية';

  @override
  String get merchantReject => 'رفض';

  @override
  String merchantRejectTitle(String number) {
    return 'رفض الطلب #$number';
  }

  @override
  String get merchantRejectItemUnavailable => 'صنف غير متوفر';

  @override
  String get merchantRejectRestaurantClosed => 'المطعم مغلق';

  @override
  String get merchantRejectTooBusy => 'ضغط طلبات';

  @override
  String get merchantRejectPickItems => 'اختر الأصناف غير المتوفرة';

  @override
  String get merchantRejectUntilTomorrow => 'حتى الغد';

  @override
  String get merchantRejectUntilTurnedBackOn => 'حتى أعيده';

  @override
  String get merchantRejectClosedNote =>
      'سيتوقف مطعمك عن استقبال الطلبات حتى تعيد الفتح';

  @override
  String get merchantRejectNothingElse => 'الرفض فقط';

  @override
  String merchantRejectBusyMode(int minutes) {
    return 'تفعيل وضع الضغط +$minutes د';
  }

  @override
  String merchantRejectPause(int minutes) {
    return 'إيقاف $minutes د';
  }

  @override
  String get merchantRejectConfirm => 'تأكيد الرفض';

  @override
  String get merchantRejectRefused =>
      'تعذّر الرفض بهذه الاختيارات، راجعها ثم أعد المحاولة';

  @override
  String get merchantRejectedFirst => 'رُفض الطلب قبل وصول طلبك';

  @override
  String merchantAcceptedByOperations(String number, int minutes) {
    return 'قبلت العمليات الطلب #$number نيابة عنكم — وقت التحضير $minutes د';
  }

  @override
  String merchantRejectedByOperations(String number, String reason) {
    return 'رفضت العمليات الطلب #$number: $reason';
  }

  @override
  String get merchantBadgeByOperations => 'قبلته العمليات';
}
