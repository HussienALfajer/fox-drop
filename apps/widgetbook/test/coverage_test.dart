import 'dart:io';

import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fox_widgetbook/catalogue.dart';
import 'package:widgetbook/widgetbook.dart';

/// The states of each core_ui widget, from core_ui itself. A widget added to
/// core_ui without an entry here fails the first test. None since D.R1
/// (2026-11-27): each returns with the approved screen that needs it.
final _states = <String, (List<String>, List<String>)>{};

void main() {
  // R3 (architecture §9.5): every public widget of core_ui appears in the
  // catalogue with a use case for each of its states, and for each variant.
  test('every core_ui widget has its states listed here', () {
    final source = Directory('../../packages/core_ui/lib/src');
    final widgets = <String>{
      for (final file in source.listSync(recursive: true).whereType<File>())
        if (file.path.endsWith('.dart'))
          for (final match in RegExp(
            r'^class (Fox\w+)(?:<[^>]*>)? extends (StatelessWidget|StatefulWidget)',
            multiLine: true,
          ).allMatches(file.readAsStringSync()))
            match[1]!,
    };
    // The scan reads the folder: it must exist, even with no widget in it.
    expect(source.existsSync(), isTrue);
    expect(_states.keys.toSet(), widgets);
  });

  testWidgets('every use case builds on both themes', (tester) async {
    for (final theme in [FoxThemeData.phone(), FoxThemeData.captain()]) {
      for (final component in catalogue.whereType<WidgetbookComponent>()) {
        for (final useCase in component.useCases) {
          // Widgetbook gives each use case an Overlay and a MediaQuery, as an
          // app does; the menus open on the Overlay.
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(size: Size(800, 600)),
              child: FoxTheme(
                data: theme,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Overlay(
                    initialEntries: [OverlayEntry(builder: useCase.builder)],
                  ),
                ),
              ),
            ),
          );
          await tester.pump();
          expect(tester.takeException(), isNull, reason: useCase.name);
        }
      }
    }
  });

  test('every state of every widget has a use case', () {
    for (final MapEntry(key: widget, value: (variants, states))
        in _states.entries) {
      final component = catalogue
          .whereType<WidgetbookComponent>()
          .where((c) => c.name == widget)
          .singleOrNull;
      expect(component, isNotNull, reason: '$widget is not in the catalogue');
      final names = {for (final u in component!.useCases) u.name};
      for (final variant in variants) {
        for (final state in states) {
          final name = variant.isEmpty ? state : '$variant $state';
          expect(names, contains(name), reason: widget);
        }
      }
    }
  });
}
