import 'package:core_l10n/core_l10n.dart' show foxCountryNames;
import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

import 'catalogue.dart' show phoneStrings;

/// The components of D.11's screens (slice D.11b), a use case per state (R3),
/// drawn from the approved components sheet of the customer screens canvas.
final List<WidgetbookNode> frameCatalogue = [
  _component('FoxDropLoader', dropLoaderStates, _loader),
  _component('FoxCountrySheet', countrySheetStates, _countries),
  _component('FoxTextLink', textLinkStates, (_) => _link),
  _component('FoxTrackingSteps', trackingStepsStates, _tracking),
  _component('FoxSignInHero', signInHeroStates, _hero),
  _component('FoxCodePreview', codePreviewStates, _preview),
  _component('FoxVersionTicket', versionTicketStates, (_) => _ticket),
  _component('FoxShopSign', shopSignStates, _sign),
];

// Hover, pressed and focus are the plain link, driven by the mouse, a touch
// and the keyboard in widgetbook.
final _link = FoxTextLink(label: 'تعديل الرقم', onPressed: () {});

const _steps = [
  FoxTrackingStep(icon: FoxIcons.receipt, label: 'استلام'),
  FoxTrackingStep(icon: FoxIcons.restaurant, label: 'تحضير'),
  FoxTrackingStep(icon: FoxIcons.motorcycle, label: 'في الطريق'),
  FoxTrackingStep(icon: FoxIcons.house, label: 'وصل'),
];

Widget _tracking(String state) => SizedBox(
  width: FoxSize.dialog * 0.7,
  child: FoxTrackingSteps(
    steps: _steps,
    current: switch (state) {
      'first' => 0,
      'last' => 3,
      'done' => 4,
      _ => 2,
    },
    doneLabel: 'تم',
    nowLabel: 'الآن',
  ),
);

/// The hero's three origins, as the sign-in screen passes them.
const heroOrigins = {
  'checkout': FoxSignInOrigin.checkout(
    restaurant: 'مطعم الشام',
    details: '3 أصناف · إلى حي الجلاء',
    amount: '18500',
    symbol: '₺',
    savedLabel: 'سلّتك محفوظة كما هي',
  ),
  'orders': FoxSignInOrigin.orders(
    title: 'هكذا تتابع طلبك',
    statusLabel: 'في الطريق إليك',
    steps: _steps,
    current: 2,
    doneLabel: 'تم',
    nowLabel: 'الآن',
  ),
  'account': FoxSignInOrigin.account(
    perks: [
      FoxSignInPerk(icon: FoxIcons.dropPin, label: 'عناوينك'),
      FoxSignInPerk(icon: FoxIcons.discount, label: 'أكوادك'),
      FoxSignInPerk(icon: FoxIcons.heart, label: 'مفضّلتك'),
    ],
  ),
};

const _heroWords = {
  'checkout': (
    'سجّل دخولك لتكمل طلبك',
    'سلّتك محفوظة. أدخل رقمك لنرسل لك رمز الدخول على واتساب.',
  ),
  'orders': ('تابع طلبك لحظة بلحظة', 'أدخل رقمك لترى طلباتك الجارية والسابقة.'),
  'account': (
    'حسابك يحفظ لك كل شيء',
    'أدخل رقمك لتحفظ عناوينك وأكوادك ومفضّلتك.',
  ),
};

/// The hero in the height the sign-in screen gives it at 360 × 640; `short`
/// is the height left on a small phone, `keyboard` the keyboard up.
Widget _hero(String state) {
  final key = heroOrigins.containsKey(state) ? state : 'checkout';
  final (title, lead) = _heroWords[key]!;
  final hero = FoxSignInHero(
    origin: heroOrigins[key]!,
    title: title,
    lead: lead,
  );
  return Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        viewInsets: state == 'keyboard'
            ? EdgeInsets.only(bottom: FoxSize.dialog / 2)
            : EdgeInsets.zero,
      ),
      child: SizedBox(
        width: FoxSize.dialog * 0.8,
        height: state == 'short' ? FoxSize.dialog / 2 : FoxSize.dialog,
        child: hero,
      ),
    ),
  );
}

Widget _preview(String state) => SizedBox(
  width: FoxSize.dialog * 0.7,
  child: FoxCodePreview(
    sender: 'FOX DROP',
    message: 'رمز الدخول إلى FOX DROP:',
    time: 'الآن · واتساب',
    semanticLabel: 'يصلك الرمز في رسالة واتساب من FOX DROP',
    compact: state == 'compact',
  ),
);

const _ticket = FoxVersionTicket(
  installedLabel: 'إصدارك',
  installed: '1.0.3',
  requiredLabel: 'الإصدار الجديد',
  required: '1.1.0',
  semanticLabel: 'إصدارك 1.0.3، والمطلوب 1.1.0 أو أحدث',
);

Widget _sign(String state) => FoxShopSign(
  title: 'نعود قريباً',
  subtitle: 'صيانة قصيرة',
  returnTime: state == 'returnTime' ? 'نعود الساعة 3:00 م' : null,
  semanticLabel: state == 'returnTime'
      ? 'لافتة: نعود قريباً، الساعة 3:00 م'
      : 'لافتة: نعود قريباً',
);

// The sheet drawn inline, as a panel (D.10).
Widget _countries(String state) => SizedBox(
  height: FoxSize.dialog,
  child: FoxCountrySheet(
    countries: foxCountryNames,
    selected: 'SY',
    strings: phoneStrings.sheet,
    lastUsed: state == 'lastUsed' ? 'DE' : null,
    initialQuery: switch (state) {
      'search' => 'ألمان',
      'empty' => 'zzzz',
      _ => '',
    },
    onSelected: (_) {},
  ),
);

WidgetbookComponent _component(
  String name,
  List<String> states,
  Widget Function(String state) build,
) => WidgetbookComponent(
  name: name,
  useCases: [
    for (final state in states)
      WidgetbookUseCase(
        name: state,
        builder: (context) => Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(FoxSpace.lg),
            child: build(state),
          ),
        ),
      ),
  ],
);

Widget _loader(String state) => switch (state) {
  'onPrimary' => const _OnPrimary(child: FoxDropLoader(onPrimary: true)),
  'small' => const FoxDropLoader(size: FoxDropLoaderSize.sm),
  'large' => const FoxDropLoader(size: FoxDropLoaderSize.lg),
  'labelled' => const FoxDropLoader(
    size: FoxDropLoaderSize.lg,
    label: 'جارٍ التحميل',
  ),
  _ => const FoxDropLoader(),
};

/// The orange ground of the primary button, under the loader on orange.
class _OnPrimary extends StatelessWidget {
  const _OnPrimary({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: FoxTheme.of(context).colors.primary,
      borderRadius: BorderRadius.circular(FoxRadius.md),
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.all(FoxSpace.sm),
      child: child,
    ),
  );
}
