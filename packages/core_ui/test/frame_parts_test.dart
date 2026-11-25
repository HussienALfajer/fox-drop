import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'overlays_harness.dart';

// D.11b checkpoint C: the components of D.11's screens, from the approved
// customer screens canvas (owner, 2026-11-24) and the slice plan's step 4.

const _steps = [
  FoxTrackingStep(icon: FoxIcons.receipt, label: 'استلام'),
  FoxTrackingStep(icon: FoxIcons.restaurant, label: 'تحضير'),
  FoxTrackingStep(icon: FoxIcons.motorcycle, label: 'في الطريق'),
  FoxTrackingStep(icon: FoxIcons.house, label: 'وصل'),
];

Widget _tracking({int current = 2}) => FoxTrackingSteps(
  steps: _steps,
  current: current,
  doneLabel: 'تم',
  nowLabel: 'الآن',
);

final _checkout = FoxSignInOrigin.checkout(
  restaurant: 'مطعم الشام',
  details: '3 أصناف · إلى حي الجلاء',
  amount: '18500',
  symbol: '₺',
  savedLabel: 'سلّتك محفوظة كما هي',
);

final _orders = FoxSignInOrigin.orders(
  title: 'هكذا تتابع طلبك',
  statusLabel: 'في الطريق إليك',
  steps: _steps,
  current: 2,
  doneLabel: 'تم',
  nowLabel: 'الآن',
);

const _account = FoxSignInOrigin.account(
  perks: [
    FoxSignInPerk(icon: FoxIcons.dropPin, label: 'عناوينك'),
    FoxSignInPerk(icon: FoxIcons.discount, label: 'أكوادك'),
    FoxSignInPerk(icon: FoxIcons.heart, label: 'مفضّلتك'),
  ],
);

Widget _hero(FoxSignInOrigin origin) => FoxSignInHero(
  origin: origin,
  title: 'سجّل دخولك لتكمل طلبك',
  lead: 'سلّتك محفوظة. أدخل رقمك لنرسل لك رمز الدخول على واتساب.',
);

const _ticket = FoxVersionTicket(
  installedLabel: 'إصدارك',
  installed: '1.0.3',
  requiredLabel: 'الإصدار الجديد',
  required: '1.1.0',
  semanticLabel: 'إصدارك 1.0.3، والمطلوب 1.1.0 أو أحدث',
);

const _sign = FoxShopSign(
  title: 'نعود قريباً',
  subtitle: 'صيانة قصيرة',
  semanticLabel: 'لافتة: نعود قريباً',
);

const _preview = FoxCodePreview(
  sender: 'FOX DROP',
  message: 'رمز الدخول إلى FOX DROP:',
  time: 'الآن · واتساب',
  semanticLabel: 'يصلك الرمز في رسالة واتساب من FOX DROP',
);

const _navItems = [
  FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
  FoxNavItem(icon: FoxIcons.search, label: 'البحث'),
  FoxNavItem(icon: FoxIcons.orders, label: 'طلباتي'),
  FoxNavItem(icon: FoxIcons.account, label: 'حسابي'),
];

void main() {
  group('FoxTextLink', () {
    testWidgets('a link with a 48 target that calls back', (tester) async {
      var taps = 0;
      final handle = tester.ensureSemantics();
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Center(
            child: FoxTextLink(label: 'الشروط', onPressed: () => taps++),
          ),
        ),
      );
      final size = tester.getSize(find.byType(FoxTextLink));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(
        tester.getSemantics(find.bySemanticsLabel('الشروط')),
        matchesSemantics(
          label: 'الشروط',
          isLink: true,
          hasTapAction: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );
      await tester.tap(find.byType(FoxTextLink));
      expect(taps, 1);
      handle.dispose();
    });

    testWidgets('underlined primary ink, pressed paints its token', (
      tester,
    ) async {
      final theme = FoxThemeData.phone();
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Center(
            child: FoxTextLink(label: 'تعديل الرقم', onPressed: () {}),
          ),
          theme: theme,
        ),
      );
      Text text() => tester.widget<Text>(find.text('تعديل الرقم'));
      expect(text().style?.color, theme.colors.primary);
      expect(text().style?.decoration, TextDecoration.underline);
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(FoxTextLink)),
      );
      await tester.pumpAndSettle();
      expect(text().style?.color, theme.colors.primaryPressed);
      await gesture.up();
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => Center(
          child: FoxTextLink(label: 'سياسة الخصوصية', onPressed: () {}),
        ),
      );
    });
  });

  group('FoxTrackingSteps', () {
    testWidgets('done, now and later steps are told in words', (tester) async {
      final handle = tester.ensureSemantics();
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(Center(child: _tracking())));
      expect(find.bySemanticsLabel('استلام، تم'), findsOneWidget);
      expect(find.bySemanticsLabel('تحضير، تم'), findsOneWidget);
      expect(find.bySemanticsLabel('في الطريق، الآن'), findsOneWidget);
      expect(find.bySemanticsLabel('وصل'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('done steps in info, the current in primary', (tester) async {
      final theme = FoxThemeData.phone();
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(Center(child: _tracking()), theme: theme),
      );
      Color? fill(int n) {
        final box = tester.widget<DecoratedBox>(
          find.byKey(FoxTrackingSteps.stepKey(n)),
        );
        return (box.decoration as BoxDecoration).color;
      }

      expect(fill(0), theme.colors.info);
      expect(fill(1), theme.colors.info);
      expect(fill(2), theme.colors.primary);
      expect(fill(3), theme.colors.surfaceRaised);
      for (var n = 0; n < 4; n++) {
        final size = tester.getSize(find.byKey(FoxTrackingSteps.stepKey(n)));
        expect(size, const Size.square(48));
      }
    });

    testWidgets('the pulse stands still under reduced motion', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(Center(child: _tracking()), disableAnimations: true),
      );
      // No animation runs: after the app's own first frames, nothing more
      // is scheduled.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(find.byKey(FoxTrackingSteps.pulseKey), findsOneWidget);
    });

    testWidgets('the pulse moves otherwise, two rings', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(Center(child: _tracking())));
      expect(find.byKey(FoxTrackingSteps.pulseKey), findsNWidgets(2));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => Center(child: _tracking(current: 0)),
        size: const Size(360, 640),
      );
    });
  });

  group('FoxSignInHero', () {
    Future<void> pumpHero(
      WidgetTester tester,
      FoxSignInOrigin origin, {
      double height = 520,
      EdgeInsets keyboard = EdgeInsets.zero,
    }) async {
      phoneScreen(tester, size: const Size(360, 640));
      await tester.pumpWidget(
        overlayApp(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(viewInsets: keyboard),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(height: height, child: _hero(origin)),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('checkout: the saved cart with its total', (tester) async {
      await pumpHero(tester, _checkout);
      expect(find.text('مطعم الشام'), findsOneWidget);
      expect(find.text('سلّتك محفوظة كما هي'), findsOneWidget);
      expect(find.byType(FoxMoney), findsOneWidget);
      expect(find.byType(FoxCard), findsOneWidget);
    });

    testWidgets('orders: the tracking steps on a sample', (tester) async {
      await pumpHero(tester, _orders);
      expect(find.text('هكذا تتابع طلبك'), findsOneWidget);
      expect(find.byType(FoxTrackingSteps), findsOneWidget);
    });

    testWidgets('account: what an account keeps', (tester) async {
      await pumpHero(tester, _account);
      expect(find.text('عناوينك'), findsOneWidget);
      expect(find.byType(FoxCard), findsNWidgets(3));
    });

    testWidgets('the lead, then the illustration, give way by height', (
      tester,
    ) async {
      // A part that gives way is neither drawn, nor hit, nor read.
      final handle = tester.ensureSemantics();
      Finder lead() => find.textContaining('أدخل رقمك').hitTestable();
      Finder art() => find.byType(FoxCard).hitTestable();
      await pumpHero(tester, _checkout);
      expect(lead(), findsOneWidget);
      expect(art(), findsOneWidget);

      // Too short for all three: the lead goes first.
      // Heights measured with the test font: the card 255, the title 62,
      // the lead 78, the gaps and padding 44.
      await pumpHero(tester, _checkout, height: 400);
      expect(lead(), findsNothing);
      expect(find.bySemanticsLabel(RegExp('أدخل رقمك')), findsNothing);
      expect(art(), findsOneWidget);

      // Shorter still: the illustration goes too; the title stays.
      await pumpHero(tester, _checkout, height: 200);
      expect(art(), findsNothing);
      expect(find.text('سجّل دخولك لتكمل طلبك').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
      handle.dispose();
    });

    testWidgets('while the keyboard is up, the title alone', (tester) async {
      await pumpHero(
        tester,
        _orders,
        keyboard: const EdgeInsets.only(bottom: 280),
      );
      expect(find.text('سجّل دخولك لتكمل طلبك'), findsOneWidget);
      expect(find.byType(FoxTrackingSteps), findsNothing);
      expect(find.textContaining('أدخل رقمك'), findsNothing);
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      for (final origin in [_checkout, _orders, _account]) {
        await expectNoOverflowInApp(
          tester,
          () => SizedBox(height: 420, child: _hero(origin)),
          size: const Size(360, 640),
        );
      }
    });
  });

  group('FoxCodePreview', () {
    testWidgets('the code masked; read once as one sentence', (tester) async {
      final handle = tester.ensureSemantics();
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(const Center(child: _preview)));
      expect(find.textContaining('••••••', findRichText: true), findsOneWidget);
      expect(
        find.bySemanticsLabel('يصلك الرمز في رسالة واتساب من FOX DROP'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel(RegExp('الآن · واتساب')), findsNothing);
      handle.dispose();
    });

    testWidgets('compact drops the sender line', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          const Center(
            child: FoxCodePreview(
              sender: 'FOX DROP',
              message: 'رمز الدخول إلى FOX DROP:',
              time: 'الآن · واتساب',
              semanticLabel: 'يصلك الرمز',
              compact: true,
            ),
          ),
        ),
      );
      expect(find.text('FOX DROP'), findsNothing);
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => const Center(child: _preview),
        size: const Size(360, 640),
      );
    });
  });

  group('FoxBottomNavigation in the Figma shape (owner, 2026-11-25)', () {
    Future<void> pumpBar(WidgetTester tester, {FoxThemeData? theme}) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Align(
            alignment: Alignment.bottomCenter,
            child: FoxBottomNavigation(
              items: _navItems,
              selected: 1,
              onSelected: (_) {},
            ),
          ),
          theme: theme,
        ),
      );
    }

    testWidgets('every tab Linear and large, the selected one included', (
      tester,
    ) async {
      await pumpBar(tester);
      final icons = tester.widgetList<FoxIcon>(find.byType(FoxIcon));
      expect(icons, hasLength(4));
      for (final icon in icons) {
        expect(icon.style, FoxIconStyle.linear);
        expect(icon.size, FoxIconSize.lg);
      }
    });

    testWidgets('the current tab is a larger circle', (tester) async {
      await pumpBar(tester);
      final circles = find.byKey(FoxBottomNavigation.itemKey);
      final sizes = [
        for (final e in circles.evaluate()) (e.renderObject! as RenderBox).size,
      ];
      expect(sizes[1].width, greaterThan(sizes[0].width));
      expect(sizes[0], const Size.square(48));
    });

    testWidgets('the outline carries the halo colour', (tester) async {
      final theme = FoxThemeData.phone();
      await pumpBar(tester, theme: theme);
      final paint = tester.widget<CustomPaint>(
        find.byKey(FoxBottomNavigation.outlineKey),
      );
      final painter = paint.painter! as FoxNavOutlinePainter;
      expect(painter.halo, theme.colors.navHalo);
      expect(painter.fill, theme.colors.accent);
      expect(painter.count, 4);
    });
  });

  group('FoxBanner: close and second action', () {
    testWidgets('the close control is named and calls back', (tester) async {
      var closed = 0;
      final handle = tester.ensureSemantics();
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          FoxBanner(
            tone: FoxBannerTone.info,
            icon: FoxIcons.retry,
            message: 'يتوفر إصدار أحدث من التطبيق.',
            actionLabel: 'تحديث',
            onAction: () {},
            dismissLabel: 'إغلاق',
            onDismiss: () => closed++,
          ),
        ),
      );
      final close = find.bySemanticsLabel('إغلاق');
      expect(close, findsOneWidget);
      final size = tester.getSize(find.byKey(FoxBanner.dismissKey));
      expect(size.width, greaterThanOrEqualTo(48));
      await tester.tap(find.byKey(FoxBanner.dismissKey));
      expect(closed, 1);
      handle.dispose();
    });

    testWidgets('two actions, each with its icon, under the words', (
      tester,
    ) async {
      var second = 0;
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          FoxBanner(
            tone: FoxBannerTone.danger,
            message: 'حسابك موقوف حتى مراجعة فريق الدعم',
            actionLabel: 'اتصال',
            actionIcon: FoxIcons.phone,
            onAction: () {},
            secondaryActionLabel: 'واتساب',
            secondaryActionIcon: FoxIcons.chat,
            onSecondaryAction: () => second++,
          ),
        ),
      );
      expect(find.text('اتصال'), findsOneWidget);
      // The banner's own icon and one per action.
      expect(find.byType(FoxIcon), findsNWidgets(3));
      final words = tester.getRect(
        find.text('حسابك موقوف حتى مراجعة فريق الدعم'),
      );
      expect(
        tester.getRect(find.text('واتساب')).top,
        greaterThan(words.bottom),
      );
      await tester.tap(find.text('واتساب'));
      expect(second, 1);
    });

    testWidgets('the stack passes both through in order', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          FoxBannerStack(
            banners: [
              FoxBanner(
                tone: FoxBannerTone.info,
                message: 'أول',
                dismissLabel: 'إغلاق',
                onDismiss: () {},
              ),
              FoxBanner(
                tone: FoxBannerTone.danger,
                message: 'ثانٍ',
                actionLabel: 'اتصال',
                onAction: () {},
                secondaryActionLabel: 'واتساب',
                onSecondaryAction: () {},
              ),
            ],
            moreLabel: (n) => '+$n',
            lessLabel: 'إخفاء',
          ),
        ),
      );
      expect(find.byKey(FoxBanner.dismissKey), findsOneWidget);
      expect(find.text('واتساب'), findsOneWidget);
      expect(
        tester.getRect(find.text('أول')).top,
        lessThan(tester.getRect(find.text('ثانٍ')).top),
      );
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => FoxBanner(
          tone: FoxBannerTone.danger,
          message: 'حسابك موقوف حتى مراجعة فريق الدعم',
          actionLabel: 'اتصال',
          actionIcon: FoxIcons.phone,
          onAction: () {},
          secondaryActionLabel: 'واتساب',
          secondaryActionIcon: FoxIcons.chat,
          onSecondaryAction: () {},
          dismissLabel: 'إغلاق',
          onDismiss: () {},
        ),
      );
    });
  });

  group('The blocking heads', () {
    testWidgets('the ticket strikes the installed version', (tester) async {
      final handle = tester.ensureSemantics();
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(const Center(child: _ticket)));
      final old = tester.widget<Text>(find.text('1.0.3'));
      expect(old.style?.decoration, TextDecoration.lineThrough);
      final next = tester.widget<Text>(find.text('1.1.0'));
      expect(next.style?.decoration, isNot(TextDecoration.lineThrough));
      expect(
        find.bySemanticsLabel('إصدارك 1.0.3، والمطلوب 1.1.0 أو أحدث'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('the shop sign, with and without the return time', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(const Center(child: _sign)));
      expect(find.text('نعود قريباً'), findsOneWidget);
      expect(find.textContaining('الساعة'), findsNothing);
      await tester.pumpWidget(
        overlayApp(
          const Center(
            child: FoxShopSign(
              title: 'نعود قريباً',
              subtitle: 'صيانة قصيرة',
              returnTime: 'نعود الساعة 3:00 م',
              semanticLabel: 'لافتة: نعود قريباً، الساعة 3:00 م',
            ),
          ),
        ),
      );
      expect(find.text('نعود الساعة 3:00 م'), findsOneWidget);
    });

    testWidgets('both fit at 130% on 360 × 640', (tester) async {
      for (final head in [_ticket, _sign]) {
        await expectNoOverflowInApp(
          tester,
          () => Center(child: head),
          size: const Size(360, 640),
        );
      }
    });
  });
}
