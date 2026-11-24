@Tags(['golden'])
library;

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sheet.dart';

// The data display components of D.9 (R9), as the approved sheet «Data
// display — batch 3» draws them, on both themes and at 130% text.

const _column340 = 340.0;
const _lira = '₺';

/// A phone column of [children].
Widget _column(List<Widget> children) => SizedBox(
  width: _column340,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final child in children) ...[child, gap],
    ],
  ),
);

/// Columns side by side.
Widget _columns(List<Widget> columns) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    for (final column in columns) ...[column, gap],
  ],
);

Widget _chips() => Wrap(
  spacing: FoxSpace.xs,
  runSpacing: FoxSpace.xs,
  children: [
    for (final (status, label) in const [
      (FoxOrderStatus.placed, 'بانتظار المطعم'),
      (FoxOrderStatus.accepted, 'قيد التحضير'),
      (FoxOrderStatus.ready, 'جاهز'),
      (FoxOrderStatus.pickedUp, 'مع الكابتن'),
      (FoxOrderStatus.arrived, 'الكابتن وصل'),
      (FoxOrderStatus.delivered, 'تم التسليم'),
      (FoxOrderStatus.rejected, 'مرفوض'),
      (FoxOrderStatus.cancelled, 'ملغى'),
      (FoxOrderStatus.failed, 'فشل التسليم'),
    ])
      FoxStatusChip(status: status, label: label),
  ],
);

Widget _money() => const Wrap(
  spacing: FoxSpace.lg,
  runSpacing: FoxSpace.xs,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    FoxMoney(amount: '45000', symbol: _lira, role: FoxMoneyRole.secondary),
    FoxMoney(amount: '1050', symbol: r'$'),
    FoxMoney(amount: '330000000', symbol: 'ل.س'),
    FoxMoney(amount: '-2500', symbol: _lira, tone: FoxTone.success),
    FoxMoney(amount: '47000', symbol: _lira, role: FoxMoneyRole.number),
  ],
);

Widget _badges() => const Wrap(
  spacing: FoxSpace.xl,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    FoxCountBadge(semanticLabel: 'جديد', child: FoxIcon(FoxIcons.bell)),
    FoxCountBadge(count: 3, semanticLabel: '3', child: FoxIcon(FoxIcons.bell)),
    FoxCountBadge(
      count: 120,
      semanticLabel: '120',
      child: FoxIcon(FoxIcons.bell),
    ),
    FoxCountBadge(
      count: 12,
      tone: FoxBadgeTone.primary,
      semanticLabel: '12',
      child: FoxIcon(FoxIcons.cart),
    ),
    FoxCountBadge(count: 4, tone: FoxBadgeTone.accent, semanticLabel: '4'),
  ],
);

Widget _timers() => const Wrap(
  spacing: FoxSpace.xs,
  runSpacing: FoxSpace.xs,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    FoxTimer(seconds: 272, countsDown: true, minuteUnit: 'د'),
    FoxTimer(seconds: 48, countsDown: true, minuteUnit: 'د'),
    FoxTimer(seconds: 1080, countsDown: true, minuteUnit: 'د'),
    FoxTimer(
      seconds: 180,
      countsDown: false,
      late: true,
      prefix: 'متأخر',
      minuteUnit: 'د',
    ),
    FoxCountdownRing(seconds: 38, total: 45),
    FoxCountdownRing(seconds: 8, total: 45),
  ],
);

Widget _rows() => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    FoxListRow(
      title: 'المنزل',
      description: 'أعزاز — دوار الكفين',
      leading: FoxIcons.house,
      onPressed: () {},
    ),
    const FoxListRow(
      title: 'رصيد العهدة',
      leading: FoxIcons.wallet,
      end: FoxMoney(amount: '125000', symbol: _lira, bold: true),
    ),
    FoxListRow(
      title: 'حذف العنوان',
      leading: FoxIcons.delete,
      tone: FoxListRowTone.danger,
      onPressed: () {},
    ),
    FoxListRow(
      title: 'أكوادي',
      description: 'لا أكواد الآن',
      leading: FoxIcons.gift,
      enabled: false,
      onPressed: () {},
    ),
  ],
);

Widget _orderCards() => _column([
  FoxOrderCard(
    number: '10423',
    since: 'منذ 1 د',
    items: '3 أصناف · وجبة كريسبي، لفة شاورما…',
    captain: 'بانتظار كابتن',
    timer: const FoxTimer(seconds: 272, countsDown: true, minuteUnit: 'د'),
    action: FoxOrderAction('قبول', () {}),
  ),
  FoxOrderCard(
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
    badges: const [
      FoxStatusChip(
        tone: FoxTone.warning,
        icon: FoxIcons.warning,
        label: 'صنف نفد — بانتظار العمليات',
      ),
    ],
    late: true,
    lateLabel: 'متأخر',
    action: FoxOrderAction('الطلب جاهز', () {}),
  ),
  const FoxOrderRow(
    restaurant: 'برجر كبصو',
    date: 'اليوم · 9:45 م',
    status: FoxStatusChip(
      status: FoxOrderStatus.pickedUp,
      label: 'في الطريق إليك',
    ),
    total: FoxMoney(amount: '47000', symbol: _lira, bold: true),
  ),
]);

const _lines = [
  FoxAmountLine('قيمة الأصناف', '45200'),
  FoxAmountLine('رسوم التوصيل', '0', text: 'مجاني'),
  FoxAmountLine('الخصم (FOX25)', '-2500', tone: FoxTone.success),
  FoxAmountLine('تقريب', '-200'),
];

Widget _summaries() => _column(const [
  FoxAmountsSummary(
    variant: FoxAmountsVariant.prominent,
    lines: _lines,
    total: FoxAmountLine('المجموع', '42500'),
    symbol: _lira,
    equivalents: r'أو 11.50 $ · 3,300,000 ل.س',
  ),
  FoxAmountsSummary(
    lines: _lines,
    total: FoxAmountLine('المجموع', '42500'),
    symbol: _lira,
  ),
]);

Widget _cards() => _column([
  FoxRestaurantCard(
    name: 'كنافة أعزاز',
    categories: 'حلويات',
    rating: '4.8',
    eta: '30–40 د',
    fee: const FoxMoney(
      amount: '1000',
      symbol: _lira,
      role: FoxMoneyRole.secondary,
    ),
    state: const FoxStatusChip(
      tone: FoxTone.neutral,
      label: 'مغلق — يفتح السبت 10:00 ص',
    ),
    closed: true,
    favourite: true,
    favouriteLabel: 'المفضلة',
    onFavourite: () {},
  ),
  FoxDishCard(
    name: 'وجبة كريسبي',
    description: 'قطعتان مع بطاطس ومشروب',
    price: const FoxMoney(amount: '12000', symbol: _lira, bold: true),
    fromLabel: 'من',
    count: 2,
    addLabel: 'أضف',
    onAdd: () {},
  ),
  FoxDishCard(
    name: 'كوب عيران',
    description: 'مقاس كبير',
    price: const FoxMoney(amount: '2500', symbol: _lira, bold: true),
    addLabel: 'أضف',
    onAdd: () {},
  ),
  FoxDishCard(
    name: 'فطور شامي',
    price: const FoxMoney(amount: '9000', symbol: _lira, bold: true),
    unavailableLabel: 'يتوفر غداً',
    addLabel: 'أضف',
    onAdd: () {},
  ),
]);

Widget _states() => _column([
  const FoxSkeleton(
    label: 'جارٍ التحميل',
    child: Column(
      children: [
        FoxSkeletonBlock(height: FoxSpace.xxxl),
        gap,
        Row(
          children: [
            FoxSkeletonBlock.circle(FoxSpace.xl),
            gap,
            Expanded(child: FoxSkeletonBlock()),
          ],
        ),
      ],
    ),
  ),
  FoxEmptyState(
    icon: FoxIcons.error,
    title: 'حدث خطأ',
    description: 'لم نتمكن من تحميل الطلبات',
    tone: FoxEmptyTone.error,
    action: FoxEmptyAction('أعد المحاولة', () {}),
  ),
  const FoxCard(
    elevation: FoxCardElevation.offset,
    child: Text('الظل المُزاح'),
  ),
]);

void main() {
  setUpAll(loadFoxFonts);

  final themes = {
    'phone': FoxThemeData.phone(),
    'captain': FoxThemeData.captain(),
  };

  for (final MapEntry(key: surface, value: theme) in themes.entries) {
    testWidgets('$surface: money, chips, badges, timers and rows', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        theme,
        _column([_money(), _chips(), _badges(), _timers(), _rows()]),
        size: const Size(420, 1100),
      );
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/data_${surface}_basics.png'),
      );
    });

    testWidgets('$surface: the cards and the states', (tester) async {
      await pumpSheet(
        tester,
        theme,
        _columns([_orderCards(), _summaries(), _cards(), _states()]),
        size: const Size(1500, 1300),
      );
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/data_${surface}_cards.png'),
      );
    });
  }

  testWidgets('phone: the cards at 130% text', (tester) async {
    await pumpSheet(
      tester,
      FoxThemeData.phone(),
      _columns([_orderCards(), _summaries()]),
      textScale: 1.3,
      size: const Size(800, 1300),
    );
    await expectLater(
      find.byKey(sheetKey),
      matchesGoldenFile('goldens/data_phone_text_130.png'),
    );
  });
}
