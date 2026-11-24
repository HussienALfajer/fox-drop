import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// An app around [home], as the apps have one: a WidgetsApp gives the
/// Navigator, the Escape shortcut and the system back button (D.10). Arabic
/// right to left unless told otherwise.
Widget overlayApp(
  Widget home, {
  TextDirection direction = TextDirection.rtl,
  double textScale = 1,
  FoxThemeData? theme,
  bool disableAnimations = false,
  EdgeInsets viewPadding = EdgeInsets.zero,
}) {
  final data = theme ?? FoxThemeData.phone();
  return WidgetsApp(
    color: data.colors.primary,
    // A new key per pump: an app keeps the route it first built.
    key: UniqueKey(),
    home: home,
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        disableAnimations: disableAnimations,
        viewPadding: viewPadding,
        padding: viewPadding,
      ),
      child: FoxTheme(
        data: data,
        child: Directionality(
          textDirection: direction,
          child: DefaultTextStyle(
            style: data.text.body.copyWith(color: data.colors.onSurface),
            child: child!,
          ),
        ),
      ),
    ),
  );
}

/// A phone screen of 390 × 844 for [tester], reset after the test.
void phoneScreen(WidgetTester tester, {Size size = const Size(390, 844)}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Pumps [build] in both directions, on both themes and at text scale 1,
/// 1.3 and 2.0 inside [overlayApp], and fails on any exception.
Future<void> expectNoOverflowInApp(
  WidgetTester tester,
  Widget Function() build, {
  Size size = const Size(390, 844),
}) async {
  phoneScreen(tester, size: size);
  for (final theme in [FoxThemeData.phone(), FoxThemeData.captain()]) {
    for (final direction in TextDirection.values) {
      for (final scale in [1.0, 1.3, 2.0]) {
        await tester.pumpWidget(
          overlayApp(
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

/// The node of the focused widget, if any.
FocusNode? get focused => FocusManager.instance.primaryFocus;
