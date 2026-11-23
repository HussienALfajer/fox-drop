@Tags(['golden'])
library;

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sheet.dart';

void main() {
  setUpAll(loadFoxFonts);
  tearDown(() {
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic;
  });

  final themes = {
    'phone': FoxThemeData.phone(),
    'captain': FoxThemeData.captain(),
  };

  for (final MapEntry(key: surface, value: theme) in themes.entries) {
    for (final variant in FoxButtonVariant.values) {
      testWidgets('$surface ${variant.name}: every state', (tester) async {
        // One row per state of buttonStates; the hover, pressed and focus
        // rows are driven by a mouse, a held touch and the keyboard.
        final keys = {for (final s in buttonStates) s: GlobalKey()};
        Widget row(String state, Widget button) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FoxButton(
              key: keys[state],
              label: 'اطلب الآن',
              variant: variant,
              loading: state == 'loading',
              onPressed: state == 'disabled' ? null : () {},
            ),
            gap,
            button,
            gap,
            FoxButton.icon(
              icon: FoxIcons.add,
              label: 'إضافة',
              variant: variant,
              loading: state == 'loading',
              onPressed: state == 'disabled' ? null : () {},
            ),
          ],
        );
        await pumpSheet(
          tester,
          theme,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final state in buttonStates)
                row(
                  state,
                  FoxButton(
                    label: 'التالي',
                    icon: FoxIcons.confirm,
                    iconEnd: FoxIcons.back,
                    variant: variant,
                    loading: state == 'loading',
                    onPressed: state == 'disabled' ? null : () {},
                  ),
                ),
            ],
          ),
        );

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        await mouse.moveTo(tester.getCenter(find.byKey(keys['hover']!)));
        await tester.startGesture(
          tester.getCenter(find.byKey(keys['pressed']!)),
        );
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        Focus.of(
          tester.element(
            find.descendant(
              of: find.byKey(keys['focus']!),
              matching: find.byType(GestureDetector),
            ),
          ),
        ).requestFocus();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 400));

        await expectLater(
          find.byKey(sheetKey),
          matchesGoldenFile('goldens/button_${surface}_${variant.name}.png'),
        );
        await mouse.removePointer();
      });
    }

    testWidgets('$surface: at 130% text', (tester) async {
      await pumpSheet(
        tester,
        theme,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final variant in FoxButtonVariant.values) ...[
              FoxButton(
                label: 'تأكيد الطلب',
                icon: FoxIcons.confirm,
                variant: variant,
                onPressed: () {},
              ),
              gap,
            ],
          ],
        ),
        textScale: 1.3,
      );
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/button_${surface}_text_130.png'),
      );
    });
  }
}
