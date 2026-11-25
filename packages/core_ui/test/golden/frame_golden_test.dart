@Tags(['golden'])
library;

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sheet.dart';

// The components of D.11's screens (slice D.11b, R9), as the approved
// components sheet of the customer screens canvas draws them.

/// The points of the loader's cycle the sheet shows.
const _phases = [0.0, 0.2, 0.45, 0.7, 0.85, 0.97];

Widget _loaders(bool onPrimary) => Builder(
  builder: (context) {
    final rows = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final size in FoxDropLoaderSize.values) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final phase in _phases) ...[
                FoxDropLoader(size: size, onPrimary: onPrimary, phase: phase),
                gap,
              ],
              // Reduced motion: still, half full.
              FoxDropLoader(size: size, onPrimary: onPrimary),
            ],
          ),
          gap,
        ],
      ],
    );
    if (!onPrimary) return rows;
    return ColoredBox(
      color: FoxTheme.of(context).colors.primary,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(FoxSpace.sm),
        child: rows,
      ),
    );
  },
);

void main() {
  setUpAll(loadFoxFonts);

  final themes = {
    'phone': FoxThemeData.phone(),
    'captain': FoxThemeData.captain(),
  };

  for (final MapEntry(key: surface, value: theme) in themes.entries) {
    testWidgets('$surface: the drop loader through its cycle', (tester) async {
      await pumpSheet(
        tester,
        theme,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _loaders(false),
            gap,
            _loaders(true),
            gap,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FoxButton(label: 'اطلب', loading: true, onPressed: () {}),
                gap,
                FoxButton(
                  label: 'أرسل الرمز',
                  loadingLabel: 'جارٍ إرسال الرمز…',
                  loading: true,
                  onPressed: () {},
                ),
                gap,
                FoxButton(
                  label: 'اطلب',
                  variant: FoxButtonVariant.secondary,
                  loading: true,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        size: const Size(640, 520),
      );
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/frame_${surface}_loader.png'),
      );
    });

    testWidgets('$surface: the parts of the sign-in and the frame', (
      tester,
    ) async {
      await pumpSheet(tester, theme, _parts(), size: const Size(640, 1100));
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/frame_${surface}_parts.png'),
      );
    });
  }

  // The hero in the height the sign-in screen leaves it (D.11 screen 2).
  for (final (w, h) in const [(360.0, 640.0), (412.0, 915.0)]) {
    for (final MapEntry(key: name, value: origin) in _origins.entries) {
      testWidgets('the hero from $name at ${w.toInt()} × ${h.toInt()}', (
        tester,
      ) async {
        await pumpSheet(
          tester,
          FoxThemeData.phone(),
          SizedBox(width: w, height: h * 0.5, child: _hero(origin)),
          size: Size(w, h * 0.5),
        );
        await expectLater(
          find.byKey(sheetKey),
          matchesGoldenFile(
            'goldens/frame_hero_${name}_${w.toInt()}x${h.toInt()}.png',
          ),
        );
      });
    }
  }

  testWidgets('the hero with the keyboard up', (tester) async {
    await pumpSheet(
      tester,
      FoxThemeData.phone(),
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(viewInsets: const EdgeInsets.only(bottom: 280)),
          child: SizedBox(
            width: 360,
            height: 120,
            child: _hero(_origins['orders']!),
          ),
        ),
      ),
      size: const Size(360, 120),
    );
    await expectLater(
      find.byKey(sheetKey),
      matchesGoldenFile('goldens/frame_hero_keyboard.png'),
    );
  });

  testWidgets('the blocking heads at 130% on 360 × 640', (tester) async {
    await pumpSheet(
      tester,
      FoxThemeData.phone(),
      const SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_ticket, gap, _sign, gap, _signBack],
        ),
      ),
      textScale: 1.3,
      size: const Size(360, 640),
    );
    await expectLater(
      find.byKey(sheetKey),
      matchesGoldenFile('goldens/frame_blocking_heads_130.png'),
    );
  });
}

const _steps = [
  FoxTrackingStep(icon: FoxIcons.receipt, label: 'استلام'),
  FoxTrackingStep(icon: FoxIcons.restaurant, label: 'تحضير'),
  FoxTrackingStep(icon: FoxIcons.motorcycle, label: 'في الطريق'),
  FoxTrackingStep(icon: FoxIcons.house, label: 'وصل'),
];

const _origins = <String, FoxSignInOrigin>{
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
    steps: _steps,
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

Widget _hero(FoxSignInOrigin origin) => FoxSignInHero(
  origin: origin,
  title: 'سجّل دخولك لتكمل طلبك',
  lead: 'أدخل رقمك لنرسل لك رمز الدخول على واتساب.',
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

const _signBack = FoxShopSign(
  title: 'نعود قريباً',
  subtitle: 'صيانة قصيرة',
  returnTime: 'نعود الساعة 3:00 م',
  semanticLabel: 'لافتة: نعود قريباً، الساعة 3:00 م',
);

Widget _parts() => SizedBox(
  width: 600,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          FoxTextLink(label: 'ليس الآن', onPressed: () {}),
          gap,
          FoxTextLink(label: 'تعديل الرقم', onPressed: () {}),
        ],
      ),
      gap,
      for (final current in const [0, 2, 4]) ...[
        FoxTrackingSteps(
          steps: _steps,
          current: current,
          doneLabel: 'تم',
          nowLabel: 'الآن',
        ),
        gap,
      ],
      const FoxCodePreview(
        sender: 'FOX DROP',
        message: 'رمز الدخول إلى FOX DROP:',
        time: 'الآن · واتساب',
        semanticLabel: 'يصلك الرمز في رسالة واتساب من FOX DROP',
      ),
      gap,
      FoxBanner(
        tone: FoxBannerTone.info,
        icon: FoxIcons.retry,
        message: 'يتوفر إصدار أحدث من التطبيق.',
        actionLabel: 'تحديث',
        onAction: () {},
        dismissLabel: 'إغلاق',
        onDismiss: () {},
      ),
      FoxBanner(
        tone: FoxBannerTone.danger,
        icon: FoxIcons.warning,
        message: 'حسابك موقوف حتى مراجعة فريق الدعم',
        actionLabel: 'اتصال',
        actionIcon: FoxIcons.phone,
        onAction: () {},
        secondaryActionLabel: 'واتساب',
        secondaryActionIcon: FoxIcons.chat,
        onSecondaryAction: () {},
      ),
      gap,
      const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_ticket, _sign],
      ),
    ],
  ),
);
