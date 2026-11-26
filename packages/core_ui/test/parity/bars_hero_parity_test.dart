import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';

import 'parity.dart';

/// The twins of the restaurant bar, bottom navigation, sign-in hero, blocking
/// heads, top bar and sidebar web stories (`pnpm parity RestaurantBar
/// BottomNavigation SignInHero BlockingHeads TopBar Sidebar`, slice D.W4d).
/// The web TopBar is the panel's bar and the Flutter one the phone apps', so
/// `topbar--default` and `--phone` show the phone bar with an end action and
/// with its back button; `topbar--emergency` has no twin. The web Sidebar's
/// twin is the restaurant's rail (`sidebar--default`, `--collapsed` with a
/// count); the portal list and the drawer have none.
void main() {
  void noop<T>(T _) {}

  // RestaurantBar.
  for (final connected in [true, false]) {
    parityCase(
      'restaurantbar--${connected ? 'connected' : 'offline'}',
      () => FoxRestaurantBar(
        name: 'برجر كبصو',
        status: const FoxStatusChip(tone: FoxTone.success, label: 'مفتوح'),
        connected: connected,
        connectionLabel: connected ? 'متصل' : 'غير متصل',
        supportLabel: 'الدعم',
        onSupport: () {},
      ),
    );
  }

  // BottomNavigation.
  const customer = [
    FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
    FoxNavItem(icon: FoxIcons.search, label: 'البحث'),
    FoxNavItem(icon: FoxIcons.orders, label: 'طلباتي'),
    FoxNavItem(icon: FoxIcons.account, label: 'حسابي'),
  ];
  const badge = [
    FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
    FoxNavItem(icon: FoxIcons.search, label: 'البحث'),
    FoxNavItem(
      icon: FoxIcons.orders,
      label: 'طلباتي',
      badgeCount: 1,
      badgeLabel: '1 جديد',
    ),
    FoxNavItem(icon: FoxIcons.account, label: 'حسابي'),
  ];
  const dot = [
    FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
    FoxNavItem(icon: FoxIcons.wallet, label: 'أرباحي'),
    FoxNavItem(
      icon: FoxIcons.cash,
      label: 'عهدتي',
      dot: true,
      badgeLabel: 'جديد',
    ),
    FoxNavItem(icon: FoxIcons.more, label: 'المزيد'),
  ];
  // Hover and focus drive the first tab, with the second current, as the
  // web stories do.
  for (final (state, items, selected) in [
    ('default', customer, 0),
    ('badge', badge, 0),
    ('dot', dot, 0),
    ('hover', customer, 1),
    ('focus', customer, 1),
  ]) {
    parityCase(
      'bottomnavigation--$state',
      () => FoxBottomNavigation(
        items: items,
        selected: selected,
        onSelected: noop<int>,
      ),
    );
  }

  // SignInHero, in the story's frame: the dialog's height, or the tooltip's
  // on a small phone and with the keyboard up.
  const steps = [
    FoxTrackingStep(icon: FoxIcons.receipt, label: 'استلام'),
    FoxTrackingStep(icon: FoxIcons.restaurant, label: 'تحضير'),
    FoxTrackingStep(icon: FoxIcons.motorcycle, label: 'في الطريق'),
    FoxTrackingStep(icon: FoxIcons.house, label: 'وصل'),
  ];
  const origins = {
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
      steps: steps,
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
  const words = {
    'checkout': (
      'سجّل دخولك لتكمل طلبك',
      'سلّتك محفوظة. أدخل رقمك لنرسل لك رمز الدخول على واتساب.',
    ),
    'orders': (
      'تابع طلبك لحظة بلحظة',
      'أدخل رقمك لترى طلباتك الجارية والسابقة.',
    ),
    'account': (
      'حسابك يحفظ لك كل شيء',
      'أدخل رقمك لتحفظ عناوينك وأكوادك ومفضّلتك.',
    ),
  };
  for (final state in ['checkout', 'orders', 'account', 'short', 'keyboard']) {
    final origin = origins.containsKey(state) ? state : 'checkout';
    final (title, lead) = words[origin]!;
    final small = state == 'short' || state == 'keyboard';
    parityCase(
      'signinhero--$state',
      () => Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            viewInsets: state == 'keyboard'
                ? const EdgeInsets.only(bottom: FoxSize.tooltip)
                : EdgeInsets.zero,
          ),
          child: SizedBox(
            width: double.infinity,
            height: small ? FoxSize.tooltip : FoxSize.dialog,
            child: FoxSignInHero(
              origin: origins[origin]!,
              title: title,
              lead: lead,
            ),
          ),
        ),
      ),
    );
  }

  // BlockingHeads.
  parityCase(
    'blockingheads--version-ticket',
    () => const FoxVersionTicket(
      installedLabel: 'إصدارك',
      installed: '1.0.3',
      requiredLabel: 'الإصدار الجديد',
      required: '1.1.0',
      semanticLabel: 'إصدارك 1.0.3، والمطلوب 1.1.0 أو أحدث',
    ),
  );
  parityCase(
    'blockingheads--shop-sign',
    () => const FoxShopSign(
      title: 'نعود قريباً',
      subtitle: 'صيانة قصيرة',
      semanticLabel: 'لافتة: نعود قريباً',
    ),
  );
  parityCase(
    'blockingheads--shop-sign-return-time',
    () => const FoxShopSign(
      title: 'نعود قريباً',
      subtitle: 'صيانة قصيرة',
      returnTime: 'نعود الساعة 3:00 م',
      semanticLabel: 'لافتة: نعود قريباً، الساعة 3:00 م',
    ),
  );

  // TopBar: the phone bar.
  parityCase(
    'topbar--default',
    () => FoxTopBar(
      title: 'سلة المشتريات',
      backLabel: 'رجوع',
      onBack: () {},
      end: FoxButton.icon(
        icon: FoxIcons.delete,
        label: 'إفراغ السلة',
        variant: FoxButtonVariant.secondary,
        onPressed: () {},
      ),
    ),
  );
  parityCase(
    'topbar--phone',
    () => FoxTopBar(title: 'سلة المشتريات', backLabel: 'رجوع', onBack: () {}),
  );

  // Sidebar: the restaurant's rail.
  for (final (state, count) in [('default', null), ('collapsed', 3)]) {
    parityCase(
      'sidebar--$state',
      () => SizedBox(
        height: FoxSize.dialog,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FoxNavigationRail(
              items: [
                FoxNavItem(
                  icon: FoxIcons.orders,
                  label: 'الطلبات',
                  badgeCount: count,
                  badgeLabel: count == null ? null : '$count جديدة',
                ),
                const FoxNavItem(icon: FoxIcons.clock, label: 'السجل'),
                const FoxNavItem(icon: FoxIcons.plate, label: 'القائمة'),
                const FoxNavItem(icon: FoxIcons.restaurant, label: 'الحالة'),
                const FoxNavItem(icon: FoxIcons.star, label: 'التقييمات'),
                const FoxNavItem(icon: FoxIcons.settings, label: 'الإعدادات'),
              ],
              selected: 0,
              onSelected: noop<int>,
            ),
          ],
        ),
      ),
    );
  }
}
