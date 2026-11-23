import 'package:core_ui/core_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The width of a phone form's column, the test frame of every form widget.
const phoneColumn = 340.0;

/// A form in a 340 wide column under a Navigator (so an Overlay and routes
/// exist, as in an app), in Arabic right to left unless told otherwise.
Widget formApp(
  Widget child, {
  TextDirection direction = TextDirection.rtl,
  double textScale = 1,
  FoxThemeData? theme,
  bool disableAnimations = false,
}) => MediaQuery(
  data: MediaQueryData(
    size: const Size(360, 800),
    textScaler: TextScaler.linear(textScale),
    disableAnimations: disableAnimations,
  ),
  child: FoxTheme(
    data: theme ?? FoxThemeData.phone(),
    child: Directionality(
      textDirection: direction,
      // A new key per pump: a Navigator keeps the route it first built.
      child: Navigator(
        key: UniqueKey(),
        onGenerateRoute: (_) => PageRouteBuilder<void>(
          pageBuilder: (context, _, _) => Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: phoneColumn, child: child),
          ),
        ),
      ),
    ),
  ),
);

/// Pumps [build] in both directions, on both themes and at text scale 1,
/// 1.3 and 2.0, and fails on any exception (an overflow is one).
Future<void> expectNoOverflow(
  WidgetTester tester,
  Widget Function() build,
) async {
  // The test font draws every glyph as a full square, so a card of real copy
  // at 200% outgrows the default 600 high surface, which a phone would
  // scroll; only the width is under test here (D.9).
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  for (final theme in [FoxThemeData.phone(), FoxThemeData.captain()]) {
    for (final direction in TextDirection.values) {
      for (final scale in [1.0, 1.3, 2.0]) {
        await tester.pumpWidget(
          formApp(
            build(),
            direction: direction,
            textScale: scale,
            theme: theme,
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$direction at $scale');
      }
    }
  }
}

/// A mouse over [finder], to see the hover state.
Future<TestGesture> hover(WidgetTester tester, Finder finder) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  await mouse.moveTo(tester.getCenter(finder));
  await tester.pump(const Duration(milliseconds: 250));
  return mouse;
}
