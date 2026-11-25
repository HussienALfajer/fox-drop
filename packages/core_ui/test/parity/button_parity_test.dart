import 'package:core_ui/core_ui.dart';

import 'parity.dart';

/// Button's twin of every web story it can show (`pnpm parity Button`).
/// The densities (`*-comfortable`, `*-compact`) and the press-counting
/// stories have no Flutter case: FoxButton has one density, and the counter
/// is a keyboard test, not a look; the sheet marks their rows.
void main() {
  const samples = {
    FoxButtonVariant.primary: 'اطلب الآن',
    FoxButtonVariant.secondary: 'عرض القائمة',
    FoxButtonVariant.danger: 'إلغاء الطلب',
    FoxButtonVariant.ghost: 'تخطي',
  };

  for (final variant in FoxButtonVariant.values) {
    for (final state in buttonStates) {
      parityCase(
        'button--${variant.name}-$state',
        () => FoxButton(
          label: samples[variant]!,
          variant: variant,
          loading: state == 'loading',
          onPressed: state == 'disabled' ? null : () {},
        ),
      );
    }
  }

  parityCase(
    'button--with-icon-start',
    () => FoxButton(
      label: 'أضف إلى السلة',
      icon: FoxIcons.cart,
      onPressed: () {},
    ),
  );
  parityCase(
    'button--with-icon-back',
    () => FoxButton(
      label: 'رجوع',
      variant: FoxButtonVariant.secondary,
      icon: FoxIcons.back,
      onPressed: () {},
    ),
  );
  parityCase(
    'button--with-icon-end',
    () => FoxButton(
      label: 'تأكيد الطلب',
      iconEnd: FoxIcons.confirm,
      onPressed: () {},
    ),
  );
  parityCase(
    'button--with-both-icons',
    () => FoxButton(
      label: 'اتصل بالمطعم',
      variant: FoxButtonVariant.secondary,
      icon: FoxIcons.phone,
      iconEnd: FoxIcons.confirm,
      onPressed: () {},
    ),
  );

  const iconOnly = {
    'button--icon-only': (FoxButtonVariant.primary, FoxIcons.add, 'إضافة'),
    'button--icon-only-secondary': (
      FoxButtonVariant.secondary,
      FoxIcons.close,
      'إغلاق',
    ),
    'button--icon-only-back': (
      FoxButtonVariant.secondary,
      FoxIcons.back,
      'رجوع',
    ),
    'button--icon-only-ghost': (
      FoxButtonVariant.ghost,
      FoxIcons.more,
      'المزيد',
    ),
    'button--icon-only-danger': (
      FoxButtonVariant.danger,
      FoxIcons.delete,
      'حذف',
    ),
  };
  for (final MapEntry(key: id, value: (variant, icon, label))
      in iconOnly.entries) {
    parityCase(
      id,
      () => FoxButton.icon(
        icon: icon,
        label: label,
        variant: variant,
        onPressed: () {},
      ),
    );
  }
}
