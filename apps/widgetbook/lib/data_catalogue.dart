import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

/// The data display components of D.9, a use case per state (R3), with the
/// approved sheet's review copy. Hover, focus and pressed are live: point,
/// tab or press a card or a row.
final List<WidgetbookNode> dataCatalogue = [
  _component('FoxMoney', moneyStates, _money),
  _component('FoxStatusChip', statusChipStates, _chip),
  _component('FoxCountBadge', countBadgeStates, _badge),
  _component('FoxCard', cardStates, _card),
  _component('FoxListRow', listRowStates, _row),
  _component('FoxTimer', timerStates, _timer),
  _component(
    'FoxCountdownRing',
    countdownRingStates,
    (state) => FoxCountdownRing(seconds: state == 'last' ? 8 : 38, total: 45),
  ),
  _component('FoxOrderCard', orderCardStates, _orderCard),
  _component('FoxOrderRow', orderRowStates, _orderRow),
  _component('FoxLogo', logoStates, (_) => const FoxLogo(name: 'فطائر الريف')),
  _component('FoxAmountsSummary', amountsSummaryStates, _summary),
  _component('FoxRestaurantCard', restaurantCardStates, _restaurant),
  _component('FoxDishCard', dishCardStates, _dish),
  _component('FoxSkeleton', skeletonStates, _skeleton),
  _component(
    'FoxSkeletonBlock',
    skeletonBlockStates,
    (state) => state == 'circle'
        ? const FoxSkeletonBlock.circle(FoxSpace.xxl)
        : const FoxSkeletonBlock(height: FoxSpace.md),
  ),
  _component('FoxEmptyState', emptyStateStates, _empty),
];

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
        builder: (context) => _Column(child: build(state)),
      ),
  ],
);

const _lira = '₺';

Widget _money(String state) => switch (state) {
  'fraction' => const FoxMoney(amount: '1050', symbol: r'$'),
  'large' => const FoxMoney(amount: '330000000', symbol: 'ل.س'),
  'negative' => const FoxMoney(
    amount: '-2500',
    symbol: _lira,
    tone: FoxTone.success,
  ),
  'gain' => const FoxMoney(
    amount: '20000',
    symbol: _lira,
    signed: true,
    tone: FoxTone.success,
  ),
  'total' => const FoxMoney(
    amount: '47000',
    symbol: _lira,
    role: FoxMoneyRole.number,
  ),
  _ => const FoxMoney(amount: '45000', symbol: _lira),
};

const _panelLabels = {
  FoxOrderStatus.placed: 'بانتظار المطعم',
  FoxOrderStatus.accepted: 'قيد التحضير',
  FoxOrderStatus.ready: 'جاهز',
  FoxOrderStatus.pickedUp: 'مع الكابتن',
  FoxOrderStatus.arrived: 'الكابتن وصل',
  FoxOrderStatus.delivered: 'تم التسليم',
  FoxOrderStatus.rejected: 'مرفوض',
  FoxOrderStatus.cancelled: 'ملغى',
  FoxOrderStatus.failed: 'فشل التسليم',
};

Widget _chip(String state) {
  if (state == 'tone') {
    return const FoxStatusChip(
      tone: FoxTone.warning,
      icon: FoxIcons.clock,
      label: 'مشغول',
    );
  }
  if (state == 'compact') {
    return const FoxStatusChip(
      status: FoxOrderStatus.accepted,
      label: 'قيد التحضير',
      compact: true,
    );
  }
  final status = FoxOrderStatus.values.byName(state);
  return FoxStatusChip(status: status, label: _panelLabels[status]!);
}

Widget _badge(String state) => switch (state) {
  'dot' => const FoxCountBadge(
    semanticLabel: 'إشعارات جديدة',
    child: FoxIcon(FoxIcons.bell),
  ),
  'capped' => const FoxCountBadge(
    count: 120,
    semanticLabel: '120 إشعاراً',
    child: FoxIcon(FoxIcons.bell),
  ),
  'primary' => const FoxCountBadge(
    count: 12,
    tone: FoxBadgeTone.primary,
    semanticLabel: '12 صنفاً في السلة',
    child: FoxIcon(FoxIcons.cart),
  ),
  'inline' => const FoxCountBadge(
    count: 4,
    tone: FoxBadgeTone.accent,
    semanticLabel: '4 طلبات جديدة',
  ),
  _ => const FoxCountBadge(
    count: 3,
    semanticLabel: '3 إشعارات',
    child: FoxIcon(FoxIcons.bell),
  ),
};

Widget _card(String state) => FoxCard(
  elevation: state == 'offset'
      ? FoxCardElevation.offset
      : FoxCardElevation.outline,
  tone: state == 'danger' ? FoxCardTone.danger : FoxCardTone.normal,
  semanticLabel: 'برجر كبصو',
  onPressed: const {'hover', 'focus', 'pressed'}.contains(state) ? () {} : null,
  child: const Text('برجر كبصو · برجر، وجبات سريعة'),
);

Widget _row(String state) => switch (state) {
  'value' => const FoxListRow(
    title: 'رصيد العهدة',
    leading: FoxIcons.wallet,
    end: FoxMoney(amount: '125000', symbol: _lira, bold: true),
  ),
  'danger' => FoxListRow(
    title: 'حذف العنوان',
    leading: FoxIcons.delete,
    tone: FoxListRowTone.danger,
    onPressed: () {},
  ),
  'disabled' => FoxListRow(
    title: 'أكوادي',
    description: 'لا أكواد الآن',
    leading: FoxIcons.gift,
    enabled: false,
    onPressed: () {},
  ),
  _ => FoxListRow(
    title: 'المنزل',
    description: 'أعزاز — دوار الكفين، بناء 4',
    leading: FoxIcons.house,
    onPressed: () {},
  ),
};

Widget _timer(String state) => switch (state) {
  'soon' => const FoxTimer(seconds: 48, countsDown: true, minuteUnit: 'د'),
  'minutes' => const FoxTimer(seconds: 1080, countsDown: true, minuteUnit: 'د'),
  'late' => const FoxTimer(
    seconds: 180,
    countsDown: false,
    late: true,
    prefix: 'متأخر',
    minuteUnit: 'د',
  ),
  'waiting' => const FoxTimer(
    seconds: 240,
    countsDown: false,
    tone: FoxTimerTone.soon,
    prefix: 'ينتظر منذ',
    icon: FoxIcons.motorcycle,
    minuteUnit: 'د',
  ),
  _ => const FoxTimer(seconds: 272, countsDown: true, minuteUnit: 'د'),
};

Widget _orderCard(String state) => switch (state) {
  'preparing' => FoxOrderCard(
    number: '10419',
    since: 'منذ 9 د',
    items: '2 أصناف · برجر كبصو، كوب عيران',
    captain: 'الكابتن أحمد في الطريق — يصل خلال 4 د',
    timer: const FoxTimer(seconds: 360, countsDown: true, minuteUnit: 'د'),
    badges: const [
      FoxStatusChip(
        tone: FoxTone.warning,
        icon: FoxIcons.warning,
        label: 'صنف نفد — بانتظار العمليات',
      ),
    ],
    action: FoxOrderAction('الطلب جاهز', () {}),
  ),
  'late' => FoxOrderCard(
    number: '10412',
    since: 'منذ 24 د',
    items: '5 أصناف · وجبة عائلية…',
    captain: 'وصل الكابتن — ينتظر منذ 3 د',
    timer: const FoxTimer(
      seconds: 240,
      countsDown: false,
      late: true,
      prefix: 'متأخر',
      minuteUnit: 'د',
    ),
    late: true,
    lateLabel: 'متأخر',
    action: FoxOrderAction('الطلب جاهز', () {}),
  ),
  _ => FoxOrderCard(
    number: '10423',
    since: 'منذ 1 د',
    items: '3 أصناف · وجبة كريسبي، لفة شاورما…',
    captain: 'بانتظار كابتن',
    timer: const FoxTimer(seconds: 272, countsDown: true, minuteUnit: 'د'),
    action: state == 'readOnly' ? null : FoxOrderAction('قبول', () {}),
  ),
};

Widget _orderRow(String state) => FoxOrderRow(
  restaurant: 'برجر كبصو',
  date: state == 'active' ? 'اليوم · 9:45 م' : '21/11/2026',
  status: switch (state) {
    'past' => const FoxStatusChip(
      status: FoxOrderStatus.delivered,
      label: 'تم التسليم',
    ),
    'cancelled' => const FoxStatusChip(
      status: FoxOrderStatus.cancelled,
      label: 'أُلغي الطلب',
    ),
    _ => const FoxStatusChip(
      status: FoxOrderStatus.pickedUp,
      label: 'في الطريق إليك',
    ),
  },
  total: const FoxMoney(amount: '47000', symbol: _lira, bold: true),
  trailing: state == 'past'
      ? FoxButton(
          label: 'اطلب مرة أخرى',
          variant: FoxButtonVariant.ghost,
          onPressed: () {},
        )
      : null,
  onPressed: () {},
);

const _lines = [
  FoxAmountLine('قيمة الأصناف', '45200'),
  FoxAmountLine('رسوم التوصيل', '4500'),
  FoxAmountLine('الخصم (FOX25)', '-2500', tone: FoxTone.success),
  FoxAmountLine('تقريب', '-200'),
];

Widget _summary(String state) => switch (state) {
  'free' => const FoxAmountsSummary(
    lines: [
      FoxAmountLine('قيمة الأصناف', '45000'),
      FoxAmountLine('رسوم التوصيل', '0', text: 'مجاني'),
    ],
    total: FoxAmountLine('المجموع', '45000'),
    symbol: _lira,
  ),
  _ => FoxAmountsSummary(
    lines: _lines,
    total: const FoxAmountLine('المجموع', '47000'),
    symbol: _lira,
    equivalents: r'أو 11.50 $ · 3,300,000 ل.س',
    variant: state == 'prominent'
        ? FoxAmountsVariant.prominent
        : FoxAmountsVariant.plain,
  ),
};

Widget _restaurant(String state) => FoxRestaurantCard(
  name: state == 'closed' ? 'كنافة أعزاز' : 'برجر كبصو',
  categories: state == 'closed' ? 'حلويات' : 'برجر · وجبات سريعة',
  rating: state == 'busy' ? null : '4.5',
  newLabel: 'جديد',
  eta: '20–30 د',
  fee: state == 'busy'
      ? const Text('توصيل مجاني')
      : const FoxMoney(
          amount: '1500',
          symbol: _lira,
          role: FoxMoneyRole.secondary,
        ),
  state: switch (state) {
    'busy' => const FoxStatusChip(tone: FoxTone.warning, label: 'مشغول'),
    'closed' => const FoxStatusChip(
      tone: FoxTone.neutral,
      label: 'مغلق — يفتح السبت 10:00 ص',
    ),
    _ => null,
  },
  closed: state == 'closed',
  favourite: state == 'default',
  favouriteLabel: 'المفضلة',
  onFavourite: () {},
  onPressed: () {},
);

Widget _dish(String state) => FoxDishCard(
  name: switch (state) {
    'from' || 'inCart' => 'وجبة كريسبي',
    'noPhoto' => 'كوب عيران',
    'unavailable' => 'فطور شامي',
    _ => 'برجر كبصو',
  },
  description: state == 'noPhoto'
      ? 'مقاس كبير'
      : 'لحم بقري مشوي، جبن شيدر، خس، طماطم',
  price: const FoxMoney(amount: '18000', symbol: _lira, bold: true),
  fromLabel: state == 'from' ? 'من' : null,
  count: state == 'inCart' ? 2 : 0,
  unavailableLabel: state == 'unavailable' ? 'يتوفر غداً' : null,
  addLabel: 'أضف',
  onAdd: () {},
  onPressed: () {},
);

Widget _skeleton(String state) => FoxSkeleton(
  label: 'جارٍ التحميل',
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: switch (state) {
      'listRows' => [
        for (var i = 0; i < 3; i++)
          const Padding(
            padding: EdgeInsetsDirectional.only(bottom: FoxSpace.sm),
            child: Row(
              children: [
                FoxSkeletonBlock.circle(FoxSpace.xl),
                SizedBox(width: FoxSpace.sm),
                Expanded(child: FoxSkeletonBlock()),
              ],
            ),
          ),
      ],
      'orderCard' => const [
        FoxSkeletonBlock(height: FoxSpace.md),
        SizedBox(height: FoxSpace.xs),
        FoxSkeletonBlock(),
        SizedBox(height: FoxSpace.xs),
        FoxSkeletonBlock(height: FoxSize.control),
      ],
      _ => const [
        FoxSkeletonBlock(height: FoxSpace.xxxl * 2),
        SizedBox(height: FoxSpace.sm),
        FoxSkeletonBlock(height: FoxSpace.md),
        SizedBox(height: FoxSpace.xs),
        FoxSkeletonBlock(),
      ],
    },
  ),
);

Widget _empty(String state) => switch (state) {
  'action' => FoxEmptyState(
    icon: FoxIcons.cart,
    title: 'سلتك فارغة',
    description: 'أضف أطباقك المفضلة وستجدها هنا',
    action: FoxEmptyAction('تصفّح المطاعم', () {}),
  ),
  'error' => FoxEmptyState(
    icon: FoxIcons.error,
    title: 'حدث خطأ',
    description: 'لم نتمكن من تحميل الطلبات',
    tone: FoxEmptyTone.error,
    action: FoxEmptyAction('أعد المحاولة', () {}),
  ),
  _ => const FoxEmptyState(
    icon: FoxIcons.search,
    title: 'لم نجد نتائج',
    description: 'جرّب كلمة أخرى',
  ),
};

/// A phone column on the screen ground, as the data components sit in an app.
class _Column extends StatelessWidget {
  const _Column({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: FoxTheme.of(context).colors.surface,
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(FoxSpace.lg),
        // The width of a phone's content column (360 less the gutters).
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: FoxSpace.xxxl * 6),
          child: child,
        ),
      ),
    ),
  );
}
