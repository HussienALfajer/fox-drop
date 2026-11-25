import 'package:core_ui/core_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' as m;

import 'overlays_harness.dart';

// D.11b checkpoint C, after review: the cases the first tests missed.

const _account = FoxSignInOrigin.account(
  perks: [
    FoxSignInPerk(icon: FoxIcons.dropPin, label: 'عناوينك'),
    FoxSignInPerk(icon: FoxIcons.discount, label: 'أكوادك'),
    FoxSignInPerk(icon: FoxIcons.heart, label: 'مفضّلتك'),
  ],
);

const _hero = FoxSignInHero(
  origin: _account,
  title: 'حسابك يحفظ لك كل شيء',
  lead: 'أدخل رقمك لتحفظ عناوينك وأكوادك ومفضّلتك.',
);

/// The heights the hero is given: room for all, then for the title alone.
const _tall = 600.0;
const _short = 120.0;

/// A keyboard's height in physical pixels at a device ratio of 1.
const _keyboard = 280.0;

/// The hero in a height that a parent changes without rebuilding the hero.
class _Resizable extends StatefulWidget {
  const _Resizable();

  @override
  State<_Resizable> createState() => _ResizableState();
}

class _ResizableState extends State<_Resizable> {
  double height = _tall;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: SizedBox(height: height, child: _hero),
  );
}

void main() {
  testWidgets('a lead that gives way on the same tree is no longer read', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    phoneScreen(tester, size: const Size(360, 640));
    await tester.pumpWidget(overlayApp(const _Resizable()));
    expect(find.semantics.byLabel(RegExp('أدخل رقمك')), findsOne);
    tester.state<_ResizableState>(find.byType(_Resizable)).setState(() {
      tester.state<_ResizableState>(find.byType(_Resizable)).height = _short;
    });
    await tester.pump();
    expect(find.textContaining('أدخل رقمك').hitTestable(), findsNothing);
    expect(find.semantics.byLabel(RegExp('أدخل رقمك')), findsNothing);
    handle.dispose();
  });

  testWidgets('the keyboard is seen inside a resizing Scaffold body', (
    tester,
  ) async {
    phoneScreen(tester, size: const Size(360, 640));
    tester.view.viewInsets = const FakeViewPadding(bottom: _keyboard);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(overlayApp(const m.Scaffold(body: _hero)));
    expect(find.text('حسابك يحفظ لك كل شيء'), findsOneWidget);
    expect(find.byType(FoxCard), findsNothing, reason: 'the title alone');
  });

  group('FoxTextLink states', () {
    testWidgets('a mouse over it paints primary-hover', (tester) async {
      final theme = FoxThemeData.phone();
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Center(
            child: FoxTextLink(label: 'الشروط', onPressed: () {}),
          ),
          theme: theme,
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.byType(FoxTextLink)));
      await tester.pumpAndSettle();
      final text = tester.widget<Text>(find.text('الشروط'));
      expect(text.style?.color, theme.colors.primaryHover);
    });

    testWidgets('the focus ring shows for the keyboard, not for a tap', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Center(
            child: FoxTextLink(label: 'الشروط', onPressed: () {}),
          ),
        ),
      );
      bool ringed() {
        final box = tester.widget<DecoratedBox>(
          find.descendant(
            of: find.byType(FoxTextLink),
            matching: find.byType(DecoratedBox),
          ),
        );
        return (box.decoration as BoxDecoration).border != null;
      }

      await tester.tap(find.byType(FoxTextLink));
      await tester.pumpAndSettle();
      expect(ringed(), isFalse);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(ringed(), isTrue);
    });
  });
}
