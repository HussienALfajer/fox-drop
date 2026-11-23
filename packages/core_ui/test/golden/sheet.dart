import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The key of the sheet to compare.
const sheetKey = ValueKey('sheet');

/// The space between the items of a sheet.
const gap = SizedBox.square(dimension: FoxSpace.sm);

/// Pumps [child] as a golden sheet: Arabic RTL on the theme's surface,
/// animations off (a still spinner), sized to its content.
Future<void> pumpSheet(
  WidgetTester tester,
  FoxThemeData theme,
  Widget child, {
  double textScale = 1,
  Size size = const Size(800, 1200),
}) async {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = size * 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: size,
        devicePixelRatio: 2,
        disableAnimations: true,
        textScaler: TextScaler.linear(textScale),
      ),
      child: FoxTheme(
        data: theme,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: RepaintBoundary(
              key: sheetKey,
              child: ColoredBox(
                color: theme.colors.surface,
                child: Padding(
                  padding: const EdgeInsets.all(FoxSpace.lg),
                  child: DefaultTextStyle(
                    style: theme.text.body.copyWith(
                      color: theme.colors.onSurface,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
