import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';

import 'parity.dart';

/// The twins of the restaurant and dish cards, bottom sheet and pull to
/// refresh web stories (`pnpm parity RestaurantCard DishCard BottomSheet
/// PullToRefresh`, slice D.W4c), with the stories' own arguments. The web
/// stories have no photos (Storybook serves none), so neither do these. The
/// open sheets are inline, as the web stories keep theirs in the frame; the
/// pulling and refreshing states show the drop over the list, as a pull
/// leaves it (the web stories drive the pull with touch events).
void main() {
  _restaurant();
  _dish();
  _sheet();
  _pull();
}

const _lira = '₺';

void _restaurant() {
  Widget card({
    String name = 'كنافة أعزاز',
    String categories = 'حلويات · مشروبات',
    String? rating = '4.8',
    String? newLabel,
    String eta = '20–30 د',
    Widget fee = const FoxMoney(
      amount: '1000',
      symbol: _lira,
      role: FoxMoneyRole.secondary,
    ),
    Widget? state,
    bool closed = false,
    bool favourite = false,
  }) => FoxRestaurantCard(
    name: name,
    categories: categories,
    rating: rating,
    newLabel: newLabel,
    eta: eta,
    fee: fee,
    state: state,
    closed: closed,
    favourite: favourite,
    favouriteLabel: 'المفضلة',
    onFavourite: () {},
    onPressed: () {},
  );

  for (final state in ['default', 'hover', 'focus', 'pressed']) {
    parityCase('restaurantcard--$state', card);
  }
  parityCase(
    'restaurantcard--busy',
    () => card(
      state: const FoxStatusChip(tone: FoxTone.warning, label: 'مشغول'),
    ),
  );
  parityCase(
    'restaurantcard--closed',
    () => card(
      closed: true,
      favourite: true,
      state: const FoxStatusChip(
        tone: FoxTone.neutral,
        label: 'مغلق — يفتح السبت 10:00 ص',
      ),
    ),
  );
  parityCase(
    'restaurantcard--far',
    () => card(
      eta: '50–60 د',
      fee: const FoxMoney(
        amount: '4500',
        symbol: _lira,
        role: FoxMoneyRole.secondary,
      ),
    ),
  );
  parityCase(
    'restaurantcard--no-cover',
    () => card(
      name: 'برجر كبصو',
      categories: 'برجر',
      rating: null,
      newLabel: 'جديد',
      fee: const Text('توصيل مجاني'),
    ),
  );
  parityCase('restaurantcard--favourite', () => card(favourite: true));
}

void _dish() {
  Widget dish({
    String name = 'وجبة كريسبي',
    String? description = 'قطعتان مع بطاطس ومشروب',
    String amount = '12000',
    String? fromLabel,
    int count = 0,
    String? unavailableLabel,
  }) => FoxDishCard(
    name: name,
    description: description,
    price: FoxMoney(amount: amount, symbol: _lira, bold: true),
    fromLabel: fromLabel,
    count: count,
    unavailableLabel: unavailableLabel,
    addLabel: 'أضف $name',
    onAdd: () {},
    onPressed: () {},
  );

  for (final state in ['default', 'hover', 'focus', 'pressed']) {
    parityCase('dishcard--$state', dish);
  }
  parityCase('dishcard--from', () => dish(fromLabel: 'من'));
  parityCase('dishcard--in-cart', () => dish(fromLabel: 'من', count: 2));
  parityCase(
    'dishcard--no-photo',
    () => dish(name: 'كوب عيران', description: 'مقاس كبير', amount: '2500'),
  );
  parityCase(
    'dishcard--unavailable',
    () => dish(
      name: 'فطور شامي',
      description: null,
      amount: '9000',
      unavailableLabel: 'يتوفر غداً',
    ),
  );
}

void _sheet() {
  const trigger = FoxButton(
    label: 'اختر الإضافات',
    onPressed: _noop,
    variant: FoxButtonVariant.secondary,
  );
  final options = Builder(
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'قطعتان مع بطاطس ومشروب',
          style: FoxTheme.of(context).text.body.copyWith(
            color: FoxTheme.of(context).colors.onSurfaceMuted,
          ),
        ),
        const SizedBox(height: FoxSpace.sm),
        const FoxButton(label: 'أضف إلى السلة', onPressed: _noop),
      ],
    ),
  );
  // The web stories show the trigger above the open sheet.
  Widget open(Widget sheet) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [trigger, sheet],
  );

  parityCase('bottomsheet--default', () => trigger);
  parityCase(
    'bottomsheet--open',
    () => open(
      FoxBottomSheet(title: 'وجبة كريسبي', closeLabel: 'إغلاق', child: options),
    ),
  );
  parityCase(
    'bottomsheet--s-curve',
    () => open(
      FoxBottomSheet(
        title: 'وجبة كريسبي',
        closeLabel: 'إغلاق',
        sCurve: true,
        child: options,
      ),
    ),
  );
  parityCase(
    'bottomsheet--long',
    () => open(
      FoxBottomSheet(
        title: 'اختر المدينة',
        closeLabel: 'إغلاق',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, city) in const [
              'أعزاز',
              'مارع',
              'الراعي',
              'جرابلس',
              'الباب',
              'عفرين',
              'إدلب',
              'حلب',
            ].indexed) ...[
              if (i > 0) const SizedBox(height: FoxSpace.sm),
              Text(city),
            ],
          ],
        ),
      ),
    ),
  );
}

void _noop() {}

void _pull() {
  const names = ['كنافة أعزاز', 'برجر كبصو', 'فطائر الشام', 'مشاوي حلب'];
  Widget list() => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    children: [
      for (final name in names)
        Padding(padding: const EdgeInsets.all(FoxSpace.md), child: Text(name)),
    ],
  );
  Widget frame(Widget child) => SizedBox(
    width: FoxSize.toast,
    height: FoxSize.menuMaxHeight,
    child: child,
  );
  Widget dropOver(FoxRefreshDrop drop) => frame(
    Builder(
      builder: (context) => Stack(
        children: [
          list(),
          PositionedDirectional(
            top: FoxTheme.of(context).components.pullToRefresh.inset,
            start: 0,
            end: 0,
            child: Center(child: drop),
          ),
        ],
      ),
    ),
  );

  parityCase(
    'pulltorefresh--default',
    () => frame(
      FoxPullToRefresh(
        refreshLabel: 'تحديث',
        onRefresh: () async {},
        child: list(),
      ),
    ),
  );
  parityCase(
    'pulltorefresh--pulling',
    () => dropOver(const FoxRefreshDrop(progress: 0.5)),
  );
  parityCase(
    'pulltorefresh--refreshing',
    () => dropOver(const FoxRefreshDrop(progress: 1, refreshing: true)),
  );
}
