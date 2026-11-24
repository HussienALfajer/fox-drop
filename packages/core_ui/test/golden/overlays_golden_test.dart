@Tags(['golden'])
library;

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sheet.dart';

// The overlays and navigation of D.10 (R9), as the approved sheet «Overlays
// and navigation — batch 4» draws them: phone (customer), captain, and the
// restaurant tablet.

const _column360 = 360.0;

Widget _column(List<Widget> children, {double width = _column360}) => SizedBox(
  width: width,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final child in children) ...[child, gap],
    ],
  ),
);

Widget _columns(List<Widget> columns) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    for (final column in columns) ...[column, gap],
  ],
);

Widget _dialogs() => _column([
  FoxDialog(
    title: 'حذف هذا العنوان؟',
    body: '«البيت — حي الشهداء» يُحذف من عناوينك. طلباتك السابقة لا تتغيّر.',
    closeLabel: 'إغلاق',
    onClose: () {},
    primary: FoxDialogAction(label: 'حذف', destructive: true, onPressed: () {}),
    secondary: FoxDialogAction(label: 'إلغاء', onPressed: () {}),
  ),
  FoxConfirmDialog(
    title: 'إلغاء الطلب #10423',
    closeLabel: 'إغلاق',
    reasonLabel: 'السبب',
    reasonMarker: '*',
    reasonPlaceholder: 'اكتب سبب الإلغاء',
    reasonError: 'السبب مطلوب',
    showError: true,
    effectTitle: 'أثره على الأرصدة',
    effect: const FoxAmountsSummary(
      lines: [
        FoxAmountLine('يُعاد للزبون', '47000', tone: FoxTone.success),
        FoxAmountLine('يُخصم من المطعم', '-42000'),
      ],
      total: FoxAmountLine('عمولة المنصة', '-5000'),
      symbol: '₺',
    ),
    notifiedTitle: 'سيُبلَّغ',
    notified: const ['الزبون', 'المطعم', 'الكابتن'],
    confirmLabel: 'تأكيد الإلغاء',
    cancelLabel: 'تراجع',
    onConfirm: (_) {},
    onCancel: () {},
  ),
]);

Widget _toasts() => _column([
  const FoxToast(
    tone: FoxToastTone.success,
    message: 'حُفظت التغييرات',
    closeLabel: 'إغلاق',
  ),
  const FoxToast(
    tone: FoxToastTone.info,
    message: 'نُسخ رقم الطلب',
    closeLabel: 'إغلاق',
  ),
  const FoxToast(
    tone: FoxToastTone.warning,
    message: 'الصورة كبيرة، ضغطناها قبل الرفع',
    closeLabel: 'إغلاق',
  ),
  FoxToast(
    tone: FoxToastTone.danger,
    message: 'تعذّر الحفظ',
    closeLabel: 'إغلاق',
    actionLabel: 'أعد المحاولة',
    onAction: () {},
  ),
]);

/// The sheets on the scrim, as they open over a screen.
Widget _sheets() => Builder(
  builder: (context) => ColoredBox(
    color: FoxTheme.of(context).colors.scrim,
    child: Padding(
      padding: const EdgeInsets.only(top: FoxSpace.lg),
      child: _sheetColumn(),
    ),
  ),
);

Widget _sheetColumn() => _column([
  FoxBottomSheet(
    title: 'شاورما عربي',
    closeLabel: 'إغلاق',
    sCurve: true,
    onClose: () {},
    child: const Text('لحم، بطاطا، مخلل وثوم'),
  ),
  FoxBottomSheet(
    title: 'حالة المطعم',
    closeLabel: 'إغلاق',
    onClose: () {},
    child: const Text('مفتوح · يغلق اليوم 11:30 م'),
  ),
]);

List<FoxBanner> _banners() => [
  const FoxBanner(
    tone: FoxBannerTone.danger,
    icon: FoxIcons.offline,
    message: 'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة',
  ),
  FoxBanner(
    tone: FoxBannerTone.caution,
    message: 'فشل فحص الجهاز: الإشعارات متوقفة',
    actionLabel: 'افتح الإعدادات',
    onAction: () {},
  ),
  FoxBanner(
    tone: FoxBannerTone.warning,
    message: 'وضع الضغط مفعّل: +10 د',
    actionLabel: 'إلغاء',
    onAction: () {},
  ),
  const FoxBanner(
    tone: FoxBannerTone.info,
    message: 'وضع التجربة: الطلبات لا تصل للزبائن',
  ),
  FoxBanner(
    tone: FoxBannerTone.neutral,
    message: 'يتوفر تحديث للتطبيق',
    actionLabel: 'تحديث',
    onAction: () {},
  ),
];

Widget _bannerColumn() => _column([
  ..._banners(),
  FoxBannerStack(
    banners: _banners(),
    moreLabel: (n) => '+$n تنبيهات أخرى',
    lessLabel: 'إخفاء',
  ),
]);

/// The user menu open over its own Overlay (the sheet has none).
Widget _menu() => SizedBox(
  width: _column360,
  height: FoxSpace.xxxl * 4,
  child: Overlay(
    initialEntries: [
      OverlayEntry(
        builder: (_) => Align(
          alignment: AlignmentDirectional.topStart,
          child: FoxMenu(
            label: 'قائمة المستخدم',
            initiallyOpen: true,
            items: [
              FoxMenuItem(
                label: 'الملف الشخصي',
                icon: FoxIcons.account,
                onSelected: () {},
              ),
              FoxMenuItem(
                label: 'الجلسات',
                icon: FoxIcons.settings,
                onSelected: () {},
              ),
              const FoxMenuItem.separator(),
              FoxMenuItem(
                label: 'تسجيل الخروج',
                destructive: true,
                onSelected: () {},
              ),
            ],
            builder: (context, open) => FoxButton(
              label: 'سارة م.',
              variant: FoxButtonVariant.secondary,
              onPressed: open,
            ),
          ),
        ),
      ),
    ],
  ),
);

const _customer = [
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

const _captain = [
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

const _restaurant = [
  FoxNavItem(
    icon: FoxIcons.orders,
    label: 'الطلبات',
    badgeCount: 3,
    badgeLabel: '3 جديدة',
  ),
  FoxNavItem(icon: FoxIcons.clock, label: 'السجل'),
  FoxNavItem(icon: FoxIcons.plate, label: 'القائمة'),
  FoxNavItem(icon: FoxIcons.restaurant, label: 'الحالة'),
  FoxNavItem(icon: FoxIcons.star, label: 'التقييمات'),
  FoxNavItem(icon: FoxIcons.settings, label: 'الإعدادات'),
];

Widget _navigation(List<FoxNavItem> items) => _column([
  FoxTopBar(
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
  FoxTabs(
    tabs: const [
      FoxTab(label: 'جديدة', count: 3, countLabel: '3 طلبات'),
      FoxTab(label: 'قيد التحضير', count: 5, countLabel: '5 طلبات'),
      FoxTab(label: 'جاهزة'),
    ],
    selected: 0,
    onChanged: (_) {},
  ),
  FoxTabs(
    style: FoxTabsStyle.pill,
    tabs: const [
      FoxTab(label: 'الكل'),
      FoxTab(label: 'برجر'),
      FoxTab(label: 'شاورما'),
    ],
    selected: 1,
    onChanged: (_) {},
  ),
  FoxBottomNavigation(items: items, selected: 0, onSelected: (_) {}),
  FoxBottomNavigation(items: items, selected: 2, onSelected: (_) {}),
  const Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      FoxRefreshDrop(progress: 0),
      FoxRefreshDrop(progress: 0.5),
      FoxRefreshDrop(progress: 1, refreshing: true),
    ],
  ),
]);

void main() {
  setUpAll(loadFoxFonts);

  final themes = {
    'phone': (FoxThemeData.phone(), _customer),
    'captain': (FoxThemeData.captain(), _captain),
  };

  for (final MapEntry(key: surface, value: (theme, items)) in themes.entries) {
    testWidgets('$surface: dialogs, toasts, sheets, banners and the menu', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        theme,
        _columns([
          _dialogs(),
          _column([_toasts(), _menu()]),
          _sheets(),
          _bannerColumn(),
        ]),
        size: const Size(1600, 1300),
      );
      await tester.pump();
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/overlays_$surface.png'),
      );
    });

    testWidgets('$surface: tabs, top bar, bottom navigation, refresh', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        theme,
        _navigation(items),
        size: const Size(460, 900),
      );
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/navigation_$surface.png'),
      );
    });
  }

  testWidgets('restaurant tablet: bar, banners, rail and board tabs', (
    tester,
  ) async {
    final theme = FoxThemeData.phone();
    await pumpSheet(
      tester,
      theme,
      SizedBox(
        width: FoxSpace.xxxl * 16,
        height: FoxSpace.xxxl * 9,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FoxNavigationRail(
              items: _restaurant,
              selected: 0,
              onSelected: (_) {},
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FoxRestaurantBar(
                    name: 'برجر كبصو',
                    status: const FoxStatusChip(
                      tone: FoxTone.success,
                      label: 'مفتوح',
                    ),
                    connected: false,
                    connectionLabel: 'غير متصل',
                    supportLabel: 'الدعم',
                    onSupport: () {},
                  ),
                  FoxBannerStack(
                    banners: _banners(),
                    moreLabel: (n) => '+$n تنبيهات أخرى',
                    lessLabel: 'إخفاء',
                  ),
                  FoxTabs(
                    tabs: const [
                      FoxTab(label: 'جديدة', count: 3, countLabel: '3'),
                      FoxTab(label: 'قيد التحضير', count: 5, countLabel: '5'),
                      FoxTab(label: 'جاهزة'),
                      FoxTab(label: 'مع الكابتن'),
                    ],
                    selected: 0,
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      size: const Size(1100, 700),
    );
    await expectLater(
      find.byKey(sheetKey),
      matchesGoldenFile('goldens/navigation_restaurant_tablet.png'),
    );
  });

  testWidgets('phone: dialogs and navigation at 130% text', (tester) async {
    await pumpSheet(
      tester,
      FoxThemeData.phone(),
      _columns([_dialogs(), _navigation(_customer)]),
      textScale: 1.3,
      size: const Size(900, 1400),
    );
    await expectLater(
      find.byKey(sheetKey),
      matchesGoldenFile('goldens/overlays_phone_text_130.png'),
    );
  });
}
