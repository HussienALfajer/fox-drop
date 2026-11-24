import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

/// The overlays and navigation of D.10, a use case per state (R3), with the
/// approved sheet's review copy («Overlays and navigation — batch 4»). The
/// dialogs and sheets show their panel in place; the toaster, the menu and
/// pull to refresh are live.
final List<WidgetbookNode> overlaysCatalogue = [
  _component('FoxDialog', dialogStates, _dialog),
  _component('FoxConfirmDialog', confirmDialogStates, _confirm),
  _component('FoxBottomSheet', bottomSheetStates, _sheet, wide: true),
  _component('FoxToast', toastStates, _toast),
  _component('FoxToaster', toasterStates, (_) => const _ToasterDemo()),
  _component('FoxBanner', bannerStates, _banner, wide: true),
  _component('FoxBannerStack', bannerStackStates, _stack, wide: true),
  _component('FoxMenu', menuStates, _menu),
  _component('FoxTabs', tabsStates, (state) => _TabsDemo(state: state)),
  _component('FoxTopBar', topBarStates, _topBar),
  _component(
    'FoxRestaurantBar',
    restaurantBarStates,
    (state) => _restaurantBar(connected: state == 'connected'),
    wide: true,
  ),
  _component(
    'FoxBottomNavigation',
    bottomNavigationStates,
    (state) => _BarDemo(state: state),
  ),
  _component(
    'FoxNavigationRail',
    navigationRailStates,
    (state) => _RailDemo(badge: state == 'badge'),
    wide: true,
  ),
  _component(
    'FoxPullToRefresh',
    pullToRefreshStates,
    (_) => const _RefreshDemo(),
  ),
  _component(
    'FoxRefreshDrop',
    refreshDropStates,
    (state) => FoxRefreshDrop(
      progress: switch (state) {
        'empty' => 0,
        'half' => 0.5,
        _ => 1,
      },
      refreshing: state == 'refreshing',
    ),
  ),
];

WidgetbookComponent _component(
  String name,
  List<String> states,
  Widget Function(String state) build, {
  bool wide = false,
}) => WidgetbookComponent(
  name: name,
  useCases: [
    for (final state in states)
      WidgetbookUseCase(
        name: state,
        builder: (context) => _Frame(wide: wide, child: build(state)),
      ),
  ],
);

Widget _dialog(String state) => FoxDialog(
  title: state == 'destructive' ? 'حذف هذا العنوان؟' : 'تغيير العنوان؟',
  body: state == 'destructive'
      ? '«البيت — حي الشهداء» يُحذف من عناوينك. طلباتك السابقة لا تتغيّر.'
      : 'سلتك من مطعم لا يوصل إلى العنوان الجديد.',
  closeLabel: 'إغلاق',
  onClose: () {},
  primary: FoxDialogAction(
    label: state == 'destructive' ? 'حذف' : 'تغيير',
    destructive: state == 'destructive',
    onPressed: () {},
  ),
  secondary: state == 'single'
      ? null
      : FoxDialogAction(label: 'إلغاء', onPressed: () {}),
);

Widget _confirm(String state) => FoxConfirmDialog(
  title: 'إلغاء الطلب #10423',
  closeLabel: 'إغلاق',
  reasonLabel: 'السبب',
  reasonMarker: '*',
  reasonPlaceholder: 'اكتب سبب الإلغاء',
  reasonError: 'السبب مطلوب',
  initialReason: state == 'filled' ? 'الزبون طلب الإلغاء عبر الدعم' : null,
  showError: state == 'error',
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
);

Widget _sheet(String state) => Align(
  alignment: Alignment.bottomCenter,
  child: FoxBottomSheet(
    title: state == 's-curve' ? 'شاورما عربي' : 'حالة المطعم',
    closeLabel: 'إغلاق',
    sCurve: state == 's-curve',
    onClose: () {},
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var n = 0; n < (state == 'long' ? 24 : 3); n++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: FoxSpace.xs),
            child: Text(
              state == 's-curve'
                  ? 'لحم، بطاطا، مخلل وثوم'
                  : 'إيقاف ${15 * (n + 1)} د',
            ),
          ),
      ],
    ),
  ),
);

Widget _toast(String state) => switch (state) {
  'success' => const FoxToast(
    tone: FoxToastTone.success,
    message: 'حُفظت التغييرات',
    closeLabel: 'إغلاق',
  ),
  'info' => const FoxToast(
    tone: FoxToastTone.info,
    message: 'نُسخ رقم الطلب',
    closeLabel: 'إغلاق',
  ),
  'warning' => const FoxToast(
    tone: FoxToastTone.warning,
    message: 'الصورة كبيرة، ضغطناها قبل الرفع',
    closeLabel: 'إغلاق',
  ),
  'danger' => const FoxToast(
    tone: FoxToastTone.danger,
    message: 'تعذّر الحفظ',
    closeLabel: 'إغلاق',
  ),
  _ => FoxToast(
    tone: FoxToastTone.success,
    message: 'أُضيف إلى السلة',
    closeLabel: 'إغلاق',
    actionLabel: 'عرض السلة',
    onAction: () {},
  ),
};

Widget _banner(String state) => switch (state) {
  'danger' => const FoxBanner(
    tone: FoxBannerTone.danger,
    icon: FoxIcons.offline,
    message:
        'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال',
  ),
  'caution' => const FoxBanner(
    tone: FoxBannerTone.caution,
    message: 'فشل فحص الجهاز: الإشعارات متوقفة',
  ),
  'warning' => const FoxBanner(
    tone: FoxBannerTone.warning,
    message: 'وضع الضغط مفعّل: +10 د على وقت التحضير',
  ),
  'info' => const FoxBanner(
    tone: FoxBannerTone.info,
    message: 'وضع التجربة: الطلبات لا تصل للزبائن',
  ),
  'neutral' => const FoxBanner(
    tone: FoxBannerTone.neutral,
    message: 'يتوفر تحديث للتطبيق',
  ),
  _ => FoxBanner(
    tone: FoxBannerTone.neutral,
    message: 'يتوفر تحديث للتطبيق',
    actionLabel: 'تحديث',
    onAction: () {},
  ),
};

List<FoxBanner> _banners() => [
  const FoxBanner(
    tone: FoxBannerTone.danger,
    icon: FoxIcons.offline,
    message: 'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة',
  ),
  const FoxBanner(
    tone: FoxBannerTone.danger,
    icon: FoxIcons.warning,
    message: 'المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة',
  ),
  FoxBanner(
    tone: FoxBannerTone.caution,
    message: 'فشل فحص الجهاز: الإشعارات متوقفة',
    actionLabel: 'افتح الإعدادات',
    onAction: () {},
  ),
  FoxBanner(
    tone: FoxBannerTone.warning,
    message: 'التسوية متأخرة 3 أيام',
    actionLabel: 'التفاصيل',
    onAction: () {},
  ),
  FoxBanner(
    tone: FoxBannerTone.neutral,
    message: 'يتوفر تحديث للتطبيق',
    actionLabel: 'تحديث',
    onAction: () {},
  ),
];

Widget _stack(String state) => FoxBannerStack(
  banners: _banners().take(switch (state) {
    'one' => 1,
    'two' => 2,
    _ => 5,
  }).toList(),
  moreLabel: (n) => '+$n تنبيهات أخرى',
  lessLabel: 'إخفاء',
  initiallyExpanded: state == 'expanded',
);

Widget _menu(String state) => Align(
  alignment: AlignmentDirectional.topStart,
  child: FoxMenu(
    label: 'قائمة المستخدم',
    initiallyOpen: state != 'closed',
    items: [
      FoxMenuItem(
        label: 'الملف الشخصي',
        icon: FoxIcons.account,
        onSelected: () {},
      ),
      FoxMenuItem(label: 'الجلسات', icon: FoxIcons.settings, onSelected: () {}),
      if (state == 'destructive') ...[
        const FoxMenuItem.separator(),
        FoxMenuItem(
          label: 'تسجيل الخروج',
          destructive: true,
          onSelected: () {},
        ),
      ],
    ],
    builder: (context, open) => FoxButton(
      label: 'سارة م.',
      variant: FoxButtonVariant.secondary,
      iconEnd: FoxIcons.chevronDown,
      onPressed: open,
    ),
  ),
);

class _TabsDemo extends StatefulWidget {
  const _TabsDemo({required this.state});

  final String state;

  @override
  State<_TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<_TabsDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = switch (widget.state) {
      'pill' => const [
        FoxTab(label: 'الكل'),
        FoxTab(label: 'برجر'),
        FoxTab(label: 'شاورما'),
        FoxTab(label: 'حلويات'),
      ],
      'count' => const [
        FoxTab(label: 'جديدة', count: 3, countLabel: '3 طلبات'),
        FoxTab(label: 'قيد التحضير', count: 5, countLabel: '5 طلبات'),
        FoxTab(label: 'جاهزة'),
        FoxTab(label: 'مع الكابتن'),
      ],
      'overflow' => [
        for (final name in const [
          'الأكثر طلباً',
          'العروض',
          'برجر',
          'شاورما',
          'بيتزا',
          'حلويات',
          'مشروبات',
          'إفطار',
        ])
          FoxTab(label: name),
      ],
      _ => const [
        FoxTab(label: 'التفاصيل'),
        FoxTab(label: 'المالية'),
        FoxTab(label: 'السجل'),
        FoxTab(label: 'الملاحظات', count: 2, countLabel: 'ملاحظتان'),
      ],
    };
    return FoxTabs(
      tabs: tabs,
      selected: _selected,
      style: widget.state == 'pill'
          ? FoxTabsStyle.pill
          : FoxTabsStyle.underline,
      onChanged: (n) => setState(() => _selected = n),
    );
  }
}

Widget _topBar(String state) => FoxTopBar(
  title: state == 'no-back' ? 'طلباتي' : 'سلة المشتريات',
  backLabel: state == 'no-back' ? null : 'رجوع',
  onBack: state == 'no-back' ? null : () {},
  end: state == 'end-action'
      ? FoxButton.icon(
          icon: FoxIcons.delete,
          label: 'إفراغ السلة',
          variant: FoxButtonVariant.secondary,
          onPressed: () {},
        )
      : null,
);

Widget _restaurantBar({required bool connected}) => FoxRestaurantBar(
  name: 'برجر كبصو',
  status: const FoxStatusChip(tone: FoxTone.success, label: 'مفتوح'),
  connected: connected,
  connectionLabel: connected ? 'متصل' : 'غير متصل',
  supportLabel: 'الدعم',
  onSupport: () {},
);

const _customerItems = [
  FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
  FoxNavItem(icon: FoxIcons.search, label: 'البحث'),
  FoxNavItem(icon: FoxIcons.orders, label: 'طلباتي'),
  FoxNavItem(icon: FoxIcons.account, label: 'حسابي'),
];

class _BarDemo extends StatefulWidget {
  const _BarDemo({required this.state});

  final String state;

  @override
  State<_BarDemo> createState() => _BarDemoState();
}

class _BarDemoState extends State<_BarDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final items = switch (widget.state) {
      'badge' => const [
        FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
        FoxNavItem(icon: FoxIcons.search, label: 'البحث'),
        FoxNavItem(
          icon: FoxIcons.orders,
          label: 'طلباتي',
          badgeCount: 1,
          badgeLabel: '1 جديد',
        ),
        FoxNavItem(icon: FoxIcons.account, label: 'حسابي'),
      ],
      'dot' => const [
        FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
        FoxNavItem(icon: FoxIcons.wallet, label: 'أرباحي'),
        FoxNavItem(
          icon: FoxIcons.cash,
          label: 'عهدتي',
          dot: true,
          badgeLabel: 'جديد',
        ),
        FoxNavItem(icon: FoxIcons.more, label: 'المزيد'),
      ],
      _ => _customerItems,
    };
    return FoxBottomNavigation(
      items: items,
      selected: _selected,
      onSelected: (n) => setState(() => _selected = n),
    );
  }
}

class _RailDemo extends StatefulWidget {
  const _RailDemo({required this.badge});

  final bool badge;

  @override
  State<_RailDemo> createState() => _RailDemoState();
}

class _RailDemoState extends State<_RailDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: FoxSpace.xxxl * 7,
    child: Row(
      children: [
        FoxNavigationRail(
          items: [
            FoxNavItem(
              icon: FoxIcons.orders,
              label: 'الطلبات',
              badgeCount: widget.badge ? 3 : null,
              badgeLabel: widget.badge ? '3 جديدة' : null,
            ),
            const FoxNavItem(icon: FoxIcons.clock, label: 'السجل'),
            const FoxNavItem(icon: FoxIcons.plate, label: 'القائمة'),
            const FoxNavItem(icon: FoxIcons.restaurant, label: 'الحالة'),
            const FoxNavItem(icon: FoxIcons.star, label: 'التقييمات'),
            const FoxNavItem(icon: FoxIcons.settings, label: 'الإعدادات'),
          ],
          selected: _selected,
          onSelected: (n) => setState(() => _selected = n),
        ),
        const Expanded(child: SizedBox.shrink()),
      ],
    ),
  );
}

class _ToasterDemo extends StatelessWidget {
  const _ToasterDemo();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: FoxSpace.xxxl * 6,
    child: FoxToaster(
      child: Builder(
        builder: (context) => Align(
          alignment: Alignment.topCenter,
          child: FoxButton(
            label: 'أضف إلى السلة',
            onPressed: () => FoxToaster.of(context).show(
              tone: FoxToastTone.success,
              message: 'أُضيف إلى السلة',
              closeLabel: 'إغلاق',
              actionLabel: 'عرض السلة',
              onAction: () {},
            ),
          ),
        ),
      ),
    ),
  );
}

class _RefreshDemo extends StatelessWidget {
  const _RefreshDemo();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: FoxSpace.xxxl * 6,
    child: FoxPullToRefresh(
      refreshLabel: 'تحديث',
      onRefresh: () => Future<void>.delayed(const Duration(seconds: 2)),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          for (var n = 0; n < 6; n++)
            Padding(
              padding: const EdgeInsets.all(FoxSpace.sm),
              child: Text('الطلب #1042$n'),
            ),
        ],
      ),
    ),
  );
}

class _Frame extends StatelessWidget {
  const _Frame({required this.child, this.wide = false});

  final Widget child;
  final bool wide;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: FoxTheme.of(context).colors.surface,
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(FoxSpace.lg),
        child: ConstrainedBox(
          // A phone's column, or a tablet's width for the bars.
          constraints: BoxConstraints(
            maxWidth: wide ? FoxSpace.xxxl * 11 : FoxSpace.xxxl * 6,
          ),
          child: child,
        ),
      ),
    ),
  );
}
