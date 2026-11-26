import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';

import 'parity.dart';

/// The data display's twins of every web story they can show (`pnpm parity
/// Money StatusChip CountBadge Card ListRow AmountsSummary Skeleton
/// EmptyState DropLoader`), with the stories' own arguments. The densities
/// the Flutter twins do not have (Money's, ListRow's, AmountsSummary's and
/// EmptyState's `compact`) have no case: the sheet marks their rows.
void main() {
  _money();
  _statusChip();
  _countBadge();
  _card();
  _listRow();
  _amountsSummary();
  _skeleton();
  _emptyState();
  _dropLoader();
}

void _money() {
  parityCase(
    'money--default',
    () => const FoxMoney(amount: '45000', symbol: '₺'),
  );
  parityCase(
    'money--fraction',
    () => const FoxMoney(amount: '1050', symbol: r'$'),
  );
  parityCase(
    'money--large',
    () => const FoxMoney(amount: '330000000', symbol: 'ل.س'),
  );
  parityCase(
    'money--negative',
    () => const FoxMoney(amount: '-2500', symbol: '₺', tone: FoxTone.success),
  );
  parityCase(
    'money--gain',
    () => const FoxMoney(
      amount: '20000',
      symbol: '₺',
      signed: true,
      tone: FoxTone.success,
    ),
  );
  parityCase(
    'money--total',
    () =>
        const FoxMoney(amount: '47000', symbol: '₺', role: FoxMoneyRole.number),
  );
}

void _statusChip() {
  const labels = {
    FoxOrderStatus.placed: ('placed', 'بانتظار المطعم'),
    FoxOrderStatus.accepted: ('accepted', 'قيد التحضير'),
    FoxOrderStatus.ready: ('ready', 'جاهز'),
    FoxOrderStatus.pickedUp: ('picked-up', 'مع الكابتن'),
    FoxOrderStatus.arrived: ('arrived', 'الكابتن وصل'),
    FoxOrderStatus.delivered: ('delivered', 'تم التسليم'),
    FoxOrderStatus.rejected: ('rejected', 'مرفوض'),
    FoxOrderStatus.cancelled: ('cancelled', 'ملغى'),
    FoxOrderStatus.failed: ('failed', 'فشل التسليم'),
  };
  for (final MapEntry(key: status, value: (id, label)) in labels.entries) {
    parityCase(
      'statuschip--$id',
      () => FoxStatusChip(status: status, label: label),
    );
  }
  parityCase(
    'statuschip--tone',
    () => const FoxStatusChip(
      tone: FoxTone.warning,
      icon: FoxIcons.clock,
      label: 'مشغول',
    ),
  );
  parityCase(
    'statuschip--compact',
    () => const FoxStatusChip(
      status: FoxOrderStatus.accepted,
      label: 'قيد التحضير',
      compact: true,
    ),
  );
}

void _countBadge() {
  parityCase(
    'countbadge--default',
    () => const FoxCountBadge(
      count: 3,
      semanticLabel: '3 إشعارات',
      child: FoxIcon(FoxIcons.bell),
    ),
  );
  parityCase(
    'countbadge--dot',
    () => const FoxCountBadge(
      semanticLabel: 'إشعارات جديدة',
      child: FoxIcon(FoxIcons.bell),
    ),
  );
  parityCase(
    'countbadge--capped',
    () => const FoxCountBadge(
      count: 120,
      semanticLabel: '120 إشعاراً',
      child: FoxIcon(FoxIcons.bell),
    ),
  );
  parityCase(
    'countbadge--primary',
    () => const FoxCountBadge(
      count: 12,
      semanticLabel: '12 صنفاً في السلة',
      tone: FoxBadgeTone.primary,
      child: FoxIcon(FoxIcons.cart),
    ),
  );
  parityCase(
    'countbadge--inline',
    () => const FoxCountBadge(
      count: 4,
      semanticLabel: '4 طلبات جديدة',
      tone: FoxBadgeTone.accent,
    ),
  );
}

/// The card stories' content: a name and its cuisines.
Widget _cardContent() => Builder(
  builder: (context) {
    final theme = FoxTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'برجر كبصو',
          style: theme.text.subtitle.copyWith(
            color: theme.colors.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: FoxSpace.sm),
        Text(
          'برجر · وجبات سريعة',
          style: theme.text.secondary.copyWith(
            color: theme.colors.onSurfaceMuted,
          ),
        ),
      ],
    );
  },
);

void _card() {
  parityCase('card--default', () => FoxCard(child: _cardContent()));
  parityCase(
    'card--offset',
    () => FoxCard(elevation: FoxCardElevation.offset, child: _cardContent()),
  );
  for (final state in ['hover', 'focus', 'pressed']) {
    parityCase(
      'card--$state',
      () => FoxCard(
        onPressed: () {},
        semanticLabel: 'برجر كبصو',
        child: _cardContent(),
      ),
    );
  }
  parityCase(
    'card--danger',
    () => FoxCard(tone: FoxCardTone.danger, child: _cardContent()),
  );
}

void _listRow() {
  FoxListRow address() => FoxListRow(
    title: 'المنزل',
    description: 'أعزاز — دوار الكفين، بناء 4',
    leading: FoxIcons.house,
    onPressed: () {},
  );
  parityCase('listrow--default', address);
  parityCase(
    'listrow--value',
    () => const FoxListRow(
      title: 'رصيد العهدة',
      leading: FoxIcons.wallet,
      end: FoxMoney(amount: '125000', symbol: '₺', bold: true),
    ),
  );
  for (final state in ['hover', 'focus', 'pressed']) {
    parityCase('listrow--$state', address);
  }
  parityCase(
    'listrow--danger',
    () => FoxListRow(
      title: 'حذف العنوان',
      leading: FoxIcons.delete,
      tone: FoxListRowTone.danger,
      onPressed: () {},
    ),
  );
  parityCase(
    'listrow--disabled',
    () => FoxListRow(
      title: 'أكوادي',
      description: 'لا أكواد الآن',
      leading: FoxIcons.gift,
      enabled: false,
      onPressed: () {},
    ),
  );
}

void _amountsSummary() {
  const lines = [
    FoxAmountLine('قيمة الأصناف', '45200'),
    FoxAmountLine('رسوم التوصيل', '4500'),
    FoxAmountLine('الخصم (FOX25)', '-2500', tone: FoxTone.success),
    FoxAmountLine('تقريب', '-200'),
  ];
  const total = FoxAmountLine('المجموع', '47000');
  const equivalents = r'أو 11.50 $ · 3,300,000 ل.س';
  parityCase(
    'amountssummary--default',
    () => const FoxAmountsSummary(
      lines: lines,
      total: total,
      symbol: '₺',
      equivalents: equivalents,
    ),
  );
  parityCase(
    'amountssummary--prominent',
    () => const FoxAmountsSummary(
      lines: lines,
      total: total,
      symbol: '₺',
      equivalents: equivalents,
      variant: FoxAmountsVariant.prominent,
    ),
  );
  parityCase(
    'amountssummary--free',
    () => const FoxAmountsSummary(
      lines: [
        FoxAmountLine('قيمة الأصناف', '45000'),
        FoxAmountLine('رسوم التوصيل', '0', text: 'مجاني'),
      ],
      total: FoxAmountLine('المجموع', '45000'),
      symbol: '₺',
      equivalents: equivalents,
    ),
  );
}

void _skeleton() {
  Widget lines(Widget lead) => Row(
    children: [
      lead,
      const SizedBox(width: FoxSpace.sm),
      const Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FoxSkeletonBlock(height: FoxSpace.md),
            SizedBox(height: FoxSpace.xs),
            FoxSkeletonBlock(),
          ],
        ),
      ),
    ],
  );
  const gap = SizedBox(height: FoxSpace.sm);
  parityCase(
    'skeleton--default',
    () => FoxSkeleton(
      label: 'جارٍ التحميل',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AspectRatio(
            aspectRatio: 16 / 9,
            child: FoxSkeletonBlock(height: double.infinity),
          ),
          gap,
          lines(const FoxSkeletonBlock.circle(FoxSpace.xxl)),
        ],
      ),
    ),
  );
  parityCase(
    'skeleton--list-rows',
    () => FoxSkeleton(
      label: 'جارٍ التحميل',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) gap,
            lines(const FoxSkeletonBlock.circle(FoxSpace.xl)),
          ],
        ],
      ),
    ),
  );
  parityCase(
    'skeleton--order-card',
    () => const FoxSkeleton(
      label: 'جارٍ التحميل',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FoxSkeletonBlock(height: FoxSpace.md),
          gap,
          FoxSkeletonBlock(),
          gap,
          FoxSkeletonBlock(),
          gap,
          FoxSkeletonBlock(height: FoxSize.control),
        ],
      ),
    ),
  );
}

void _emptyState() {
  parityCase(
    'emptystate--default',
    () => const FoxEmptyState(
      icon: FoxIcons.orders,
      title: 'لا طلبات بهذه الفلاتر',
      description: 'غيّر الفترة أو الحالة',
    ),
  );
  parityCase(
    'emptystate--action',
    () => FoxEmptyState(
      icon: FoxIcons.orders,
      title: 'لا طلبات بهذه الفلاتر',
      description: 'غيّر الفترة أو الحالة',
      action: FoxEmptyAction('مسح الفلاتر', () {}),
    ),
  );
  parityCase(
    'emptystate--error',
    () => FoxEmptyState(
      icon: FoxIcons.error,
      title: 'حدث خطأ',
      description: 'لم نتمكن من تحميل الطلبات',
      tone: FoxEmptyTone.error,
      action: FoxEmptyAction('أعد المحاولة', () {}),
    ),
  );
}

void _dropLoader() {
  parityCase('droploader--default', () => const FoxDropLoader());
  parityCase(
    'droploader--on-primary',
    () => Builder(
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: FoxTheme.of(context).colors.primary,
          borderRadius: BorderRadius.circular(FoxRadius.md),
        ),
        child: const Padding(
          padding: EdgeInsetsDirectional.all(FoxSpace.sm),
          child: FoxDropLoader(onPrimary: true),
        ),
      ),
    ),
  );
  parityCase(
    'droploader--small',
    () => const FoxDropLoader(size: FoxDropLoaderSize.sm),
  );
  parityCase(
    'droploader--large',
    () => const FoxDropLoader(size: FoxDropLoaderSize.lg),
  );
  parityCase(
    'droploader--labelled',
    () =>
        const FoxDropLoader(size: FoxDropLoaderSize.lg, label: 'جارٍ التحميل'),
  );
}
