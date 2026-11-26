import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';

import 'parity.dart';

/// The overlays, tabs and icon twins of their web stories (`pnpm parity
/// Dialog ConfirmDialog Toaster Banner BannerStack Menu Tabs Icon`, slice
/// D.W3c). An open dialog or toast is its panel in the frame, as the web
/// side shoots the open panel alone; an open menu opens over an Overlay of
/// its own under its trigger. The `*-compact` stories have no case: the
/// Flutter overlays and tabs have one density.
void main() {
  void noop() {}

  // Dialog: the trigger closed, then the panel open.
  parityCase(
    'dialog--default',
    () => FoxButton(
      label: 'حذف العنوان',
      variant: FoxButtonVariant.secondary,
      onPressed: noop,
    ),
  );
  for (final state in ['open', 'danger']) {
    parityCase(
      'dialog--$state',
      () => FoxDialog(
        title: 'حذف هذا العنوان؟',
        body:
            '«البيت — حي الشهداء» يُحذف من عناوينك. طلباتك السابقة لا تتغيّر.',
        closeLabel: 'إغلاق',
        onClose: noop,
        primary: FoxDialogAction(
          label: 'حذف',
          destructive: true,
          onPressed: noop,
        ),
        secondary: FoxDialogAction(label: 'إلغاء', onPressed: noop),
      ),
    );
  }
  parityCase(
    'dialog--primary',
    () => FoxDialog(
      title: 'تأكيد الطلب؟',
      body: 'سيصل طلبك خلال 35 دقيقة تقريباً.',
      closeLabel: 'إغلاق',
      onClose: noop,
      primary: FoxDialogAction(label: 'تأكيد', onPressed: noop),
      secondary: FoxDialogAction(label: 'رجوع', onPressed: noop),
    ),
  );

  // ConfirmDialog (AP §7.4): the panel's cancel of an order.
  Widget confirm({String? reason, bool error = false}) => FoxConfirmDialog(
    title: 'إلغاء الطلب #10423',
    closeLabel: 'إغلاق',
    reasonLabel: 'السبب',
    reasonMarker: '*',
    reasonPlaceholder: 'اكتب سبب الإلغاء',
    reasonError: 'السبب مطلوب',
    initialReason: reason,
    showError: error,
    effectTitle: 'أثره على الأرصدة',
    effect: const FoxAmountsSummary(
      lines: [
        FoxAmountLine('يُعاد للزبون', '47000', tone: FoxTone.success),
        FoxAmountLine('يُخصم من المطعم', '-42000', tone: FoxTone.danger),
        FoxAmountLine('عمولة المنصة', '-5000', tone: FoxTone.danger),
      ],
      total: FoxAmountLine('صافي الأثر', '0'),
      symbol: '₺',
    ),
    notifiedTitle: 'سيُبلَّغ',
    notified: const ['الزبون', 'المطعم', 'الكابتن'],
    confirmLabel: 'تأكيد الإلغاء',
    cancelLabel: 'تراجع',
    onConfirm: (_) {},
    onCancel: noop,
  );
  parityCase(
    'confirmdialog--default',
    () => FoxButton(
      label: 'إلغاء الطلب',
      variant: FoxButtonVariant.danger,
      onPressed: noop,
    ),
  );
  parityCase('confirmdialog--empty', confirm);
  parityCase('confirmdialog--invalid', () => confirm(error: true));
  parityCase(
    'confirmdialog--filled',
    () => confirm(reason: 'الزبون طلب الإلغاء عبر الدعم'),
  );

  // Toaster: the trigger, then the toast it shows. Flutter shows one toast
  // at a time, so «stacked» is the last one shown.
  parityCase(
    'toaster--default',
    () => FoxButton(
      label: 'أظهر الإشعار',
      variant: FoxButtonVariant.secondary,
      onPressed: noop,
    ),
  );
  Widget toast(FoxToastTone tone, String message, [String? action]) => FoxToast(
    tone: tone,
    message: message,
    closeLabel: 'إغلاق',
    onClose: noop,
    actionLabel: action,
    onAction: action == null ? null : noop,
  );
  parityCase('toaster--info', () => toast(FoxToastTone.info, 'نُسخ رقم الطلب'));
  parityCase(
    'toaster--warning',
    () => toast(FoxToastTone.warning, 'الصورة كبيرة، ضغطناها قبل الرفع'),
  );
  parityCase(
    'toaster--danger',
    () => toast(FoxToastTone.danger, 'تعذّر الحفظ', 'أعد المحاولة'),
  );
  parityCase(
    'toaster--action',
    () => toast(FoxToastTone.success, 'أُضيف إلى السلة', 'عرض السلة'),
  );
  parityCase(
    'toaster--stacked',
    () => toast(FoxToastTone.danger, 'تعذّر الحفظ'),
  );

  // Banner: the texts of RA §6.3 and RA §4.7.
  const offline =
      'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال';
  parityCase(
    'banner--danger',
    () => const FoxBanner(
      tone: FoxBannerTone.danger,
      icon: FoxIcons.offline,
      message: offline,
    ),
  );
  parityCase(
    'banner--caution',
    () => FoxBanner(
      tone: FoxBannerTone.caution,
      message: 'فشل فحص الجهاز: الإشعارات متوقفة',
      actionLabel: 'افتح الإعدادات',
      onAction: noop,
    ),
  );
  parityCase(
    'banner--warning',
    () => const FoxBanner(
      tone: FoxBannerTone.warning,
      message: 'وضع الضغط مفعّل: +10 د على وقت التحضير',
    ),
  );
  parityCase(
    'banner--info',
    () => const FoxBanner(
      tone: FoxBannerTone.info,
      message: 'وضع التجربة: الطلبات لا تصل للزبائن',
    ),
  );
  parityCase(
    'banner--neutral',
    () => const FoxBanner(
      tone: FoxBannerTone.neutral,
      message: 'يتوفر تحديث للتطبيق',
    ),
  );
  parityCase(
    'banner--action',
    () => FoxBanner(
      tone: FoxBannerTone.neutral,
      message: 'يتوفر تحديث للتطبيق',
      actionLabel: 'تحديث',
      onAction: noop,
    ),
  );
  parityCase(
    'banner--dismissible',
    () => FoxBanner(
      tone: FoxBannerTone.info,
      icon: FoxIcons.retry,
      message: 'يتوفر إصدار أحدث من التطبيق.',
      actionLabel: 'تحديث',
      onAction: noop,
      dismissLabel: 'إغلاق',
      onDismiss: noop,
    ),
  );
  parityCase(
    'banner--paired',
    () => FoxBanner(
      tone: FoxBannerTone.danger,
      icon: FoxIcons.warning,
      message: 'حسابك موقوف حتى مراجعة فريق الدعم',
      actionLabel: 'اتصال',
      actionIcon: FoxIcons.phone,
      onAction: noop,
      secondaryActionLabel: 'واتساب',
      secondaryActionIcon: FoxIcons.chat,
      onSecondaryAction: noop,
    ),
  );

  // BannerStack: RA §6.3 in its priority order.
  List<FoxBanner> all() => [
    const FoxBanner(
      tone: FoxBannerTone.danger,
      icon: FoxIcons.offline,
      message: offline,
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
      onAction: noop,
    ),
    const FoxBanner(
      tone: FoxBannerTone.warning,
      message: 'التسوية متأخرة 3 أيام',
    ),
    const FoxBanner(
      tone: FoxBannerTone.neutral,
      message: 'يتوفر تحديث للتطبيق',
    ),
  ];
  Widget stack(List<FoxBanner> banners, {bool open = false}) => FoxBannerStack(
    banners: banners,
    moreLabel: (n) => '+$n تنبيهات أخرى',
    lessLabel: 'إخفاء',
    initiallyExpanded: open,
  );
  parityCase('bannerstack--one', () => stack(all().sublist(3, 4)));
  parityCase('bannerstack--two', () => stack(all().sublist(0, 2)));
  parityCase('bannerstack--folded', () => stack(all()));
  parityCase('bannerstack--opened', () => stack(all(), open: true));

  // Menu (AP §7.2): the user menu, open over an Overlay of its own.
  Widget menu(List<FoxMenuItem> items, {bool open = true, bool icon = false}) =>
      SizedBox(
        height: open ? FoxSpace.xxxl * 5 : FoxSize.touchTarget,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (_) => Align(
                alignment: AlignmentDirectional.topStart,
                child: FoxMenu(
                  label: 'قائمة المستخدم',
                  initiallyOpen: open,
                  items: items,
                  builder: (context, show) => icon
                      ? FoxButton.icon(
                          icon: FoxIcons.more,
                          label: 'المزيد',
                          variant: FoxButtonVariant.ghost,
                          onPressed: show,
                        )
                      : FoxButton(
                          label: 'سارة م.',
                          variant: FoxButtonVariant.secondary,
                          iconEnd: FoxIcons.chevronDown,
                          onPressed: show,
                        ),
                ),
              ),
            ),
          ],
        ),
      );
  final user = [
    FoxMenuItem(
      label: 'الملف الشخصي',
      icon: FoxIcons.account,
      onSelected: noop,
    ),
    FoxMenuItem(label: 'الجلسات', icon: FoxIcons.settings, onSelected: noop),
    const FoxMenuItem.separator(),
    FoxMenuItem(label: 'تسجيل الخروج', destructive: true, onSelected: noop),
  ];
  parityCase('menu--default', () => menu(user, open: false));
  parityCase('menu--open', () => menu(user));
  parityCase('menu--comfortable', () => menu(user));
  parityCase(
    'menu--destructive',
    () => menu([
      FoxMenuItem(label: 'تعديل', icon: FoxIcons.edit, onSelected: noop),
      FoxMenuItem(label: 'مشاركة', icon: FoxIcons.share, onSelected: noop),
      const FoxMenuItem.separator(),
      FoxMenuItem(
        label: 'حذف من السلة',
        icon: FoxIcons.delete,
        destructive: true,
        onSelected: noop,
      ),
    ], icon: true),
  );

  // Tabs (AP §7.4, RA §8, CU §9).
  void pick(int _) {}
  const details = [
    FoxTab(label: 'التفاصيل'),
    FoxTab(label: 'المالية'),
    FoxTab(label: 'السجل'),
    FoxTab(label: 'الملاحظات', count: 2, countLabel: 'ملاحظتان'),
  ];
  parityCase(
    'tabs--default',
    () => FoxTabs(tabs: details, selected: 0, onChanged: pick),
  );
  parityCase(
    'tabs--count',
    () => FoxTabs(
      tabs: const [
        FoxTab(label: 'جديدة', count: 3, countLabel: '3 طلبات'),
        FoxTab(label: 'قيد التحضير', count: 5, countLabel: '5 طلبات'),
        FoxTab(label: 'جاهزة'),
        FoxTab(label: 'مع الكابتن'),
      ],
      selected: 0,
      onChanged: pick,
    ),
  );
  parityCase(
    'tabs--overflow',
    () => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: FoxSize.dialog),
      child: FoxTabs(
        tabs: [
          for (final label in [
            'الكل',
            'برجر',
            'شاورما',
            'بيتزا',
            'مشاوي',
            'سلطات',
            'مشروبات',
            'حلويات',
          ])
            FoxTab(label: label),
        ],
        selected: 7,
        onChanged: pick,
      ),
    ),
  );
  parityCase(
    'tabs--pill',
    () => FoxTabs(
      tabs: const [
        FoxTab(label: 'الكل'),
        FoxTab(label: 'برجر'),
        FoxTab(label: 'شاورما'),
        FoxTab(label: 'حلويات'),
      ],
      selected: 1,
      onChanged: pick,
      style: FoxTabsStyle.pill,
    ),
  );

  // Icon: the sizes and the six styles.
  parityCase('icon--default', () => const FoxIcon(FoxIcons.cart));
  parityCase(
    'icon--sm',
    () => const FoxIcon(FoxIcons.cart, size: FoxIconSize.sm),
  );
  parityCase('icon--md', () => const FoxIcon(FoxIcons.cart));
  parityCase(
    'icon--lg',
    () => const FoxIcon(FoxIcons.cart, size: FoxIconSize.lg),
  );
  parityCase(
    'icon--labelled',
    () => const FoxIcon(FoxIcons.cart, label: 'السلة'),
  );
  parityCase(
    'icon--mirrored',
    () => const FoxIcon(FoxIcons.back, label: 'رجوع'),
  );
  for (final (id, icon, style) in [
    ('duotone', FoxIcons.bell, FoxIconStyle.duotone),
    ('brand-duo', FoxIcons.bell, FoxIconStyle.brandDuo),
    ('broken', FoxIcons.bell, FoxIconStyle.broken),
    ('bold', FoxIcons.bell, FoxIconStyle.bold),
    ('bold-duo', FoxIcons.wallet, FoxIconStyle.boldDuo),
  ]) {
    parityCase(
      'icon--$id',
      () => FoxIcon(icon, size: FoxIconSize.lg, style: style),
    );
  }
}
