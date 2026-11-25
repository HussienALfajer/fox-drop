// The parity gate (D.P2, architecture §9.5 R9, §9.8): every state the
// component registry lists is pumped from `parity_table.dart` and measured,
// and each value must equal its component token. ui-web's e2e/parity.spec.ts
// measures the same states in the browser against the same tokens, so the two
// platforms agree without comparing pixels.
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:core_ui/core_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'forms_harness.dart';
import 'parity_table.dart';

const _dimensions = {
  'height',
  'width',
  'paddingInline',
  'radius',
  'borderWidth',
  'gap',
};

/// The light theme's resolved tokens by dotted path, from the generated CSS
/// both platforms are built from (`--fd-button-height` is `button.height`).
Map<String, String> _lightTokens() {
  final css = File(
    '../design-tokens/generated/tokens.css',
  ).readAsStringSync().replaceAll('\r\n', '\n');
  final root = RegExp(r'^:root \{([^}]*)\}', multiLine: true).firstMatch(css);
  if (root == null) throw StateError('No :root block in tokens.css');
  return {
    for (final m in RegExp(
      r'--fd-([\w-]+):\s*([^;]+);',
    ).allMatches(root.group(1)!))
      m.group(1)!: m.group(2)!.trim(),
  };
}

final _tokens = _lightTokens();

Object _tokenValue(String metric, String name) {
  if (name == 'none') return 'none';
  final raw = _tokens[name.replaceAll('.', '-')];
  if (raw == null) throw StateError('No token $name in tokens.css');
  if (_dimensions.contains(metric)) {
    final px = RegExp(r'^(-?[\d.]+)px$').firstMatch(raw);
    if (px == null) throw StateError('$name is not in px: $raw');
    return double.parse(px.group(1)!);
  }
  return raw.toUpperCase();
}

double _round(double n) => (n * 100).roundToDouble() / 100;

String _hex(Color? colour) {
  if (colour == null || colour.a == 0) return 'none';
  final argb = colour.toARGB32();
  String two(int n) => n.toRadixString(16).padLeft(2, '0').toUpperCase();
  final rgb =
      '#${two(argb >> 16 & 0xFF)}${two(argb >> 8 & 0xFF)}${two(argb & 0xFF)}';
  final alpha = argb >> 24 & 0xFF;
  return alpha == 0xFF ? rgb : '$rgb${two(alpha)}';
}

/// Measures the component's box, its first [AnimatedContainer]: size, start
/// padding, corner, fill, outline, text colour and the gap from an icon to
/// its label.
Map<String, Object> _measure(WidgetTester tester, Finder component) {
  final box = find
      .descendant(of: component, matching: find.byType(AnimatedContainer))
      .first;
  final container = tester.widget<AnimatedContainer>(box);
  final size = tester.getSize(box);
  final direction = Directionality.of(tester.element(box));
  final decoration = container.decoration as BoxDecoration?;
  final over = container.foregroundDecoration as BoxDecoration?;

  final border = (over?.border ?? decoration?.border) as Border?;
  final side = border?.top;
  final outlined =
      side != null &&
      side.style != BorderStyle.none &&
      side.width > 0 &&
      side.color.a > 0 &&
      // An outline in the fill's own colour draws nothing.
      _hex(side.color) != _hex(decoration?.color);

  var radius = 0.0;
  if (decoration?.shape == BoxShape.circle) {
    radius = size.shortestSide / 2;
  } else if (decoration?.borderRadius != null) {
    radius = decoration!.borderRadius!.resolve(direction).topLeft.x;
  }

  var padding = container.padding?.resolve(direction);
  if (padding == null || padding.horizontal == 0) {
    // The outermost inner Padding that pads sideways (the framework adds
    // zero ones of its own).
    for (final element
        in find
            .descendant(of: box, matching: find.byType(Padding))
            .evaluate()) {
      final inner = (element.widget as Padding).padding.resolve(direction);
      if (inner.horizontal > 0) {
        padding = inner;
        break;
      }
    }
  }
  final start = padding == null
      ? 0.0
      : (direction == TextDirection.rtl ? padding.right : padding.left);

  Color? foreground;
  final editable = find.descendant(
    of: box,
    matching: find.byType(EditableText),
  );
  final text = find.descendant(of: box, matching: find.byType(RichText));
  if (editable.evaluate().isNotEmpty) {
    foreground = tester.widget<EditableText>(editable.first).style.color;
  } else if (text.evaluate().isNotEmpty) {
    foreground = tester.widget<RichText>(text.first).text.style?.color;
  }

  double? gap;
  final icon = find.descendant(of: box, matching: find.byType(FoxIcon));
  if (icon.evaluate().isNotEmpty && text.evaluate().isNotEmpty) {
    final a = tester.getRect(icon.first);
    final b = tester.getRect(text.first);
    gap = a.left >= b.right ? a.left - b.right : b.left - a.right;
  }

  return {
    'height': _round(size.height),
    'width': _round(size.width),
    'paddingInline': _round(start),
    'radius': _round(math.min(radius, size.shortestSide / 2)),
    'background': _hex(decoration?.color),
    'border': outlined ? _hex(side.color) : 'none',
    'borderWidth': outlined ? _round(side.width) : 0.0,
    'foreground': _hex(foreground),
    'gap': ?gap,
  };
}

typedef _Spec = ({
  String component,
  String flutter,
  String state,
  String? act,
  Map<String, String> expect,
});

/// The registry's states that Flutter measures.
List<_Spec> _states() {
  final registry =
      jsonDecode(File('../design-tokens/components.json').readAsStringSync())
          as Map<String, dynamic>;
  final out = <_Spec>[];
  for (final c
      in (registry['components'] as List).cast<Map<String, dynamic>>()) {
    final metrics = c['metrics'] as Map<String, dynamic>?;
    if (metrics == null || c['flutter'] == null) continue;
    final shared = (metrics['expect'] as Map).cast<String, String>();
    for (final s in (metrics['states'] as List).cast<Map<String, dynamic>>()) {
      if (s['only'] == 'web') continue;
      out.add((
        component: c['name'] as String,
        flutter: c['flutter'] as String,
        state: s['state'] as String,
        act: s['act'] as String?,
        expect: {...shared, ...(s['expect'] as Map).cast<String, String>()},
      ));
    }
  }
  return out;
}

void main() {
  final states = _states();

  test('the table builds exactly the states the registry lists', () {
    expect(
      states.map((s) => '${s.component}/${s.state}').toList()..sort(),
      parityStates.keys.toList()..sort(),
    );
    for (final name in ['Button', 'TextField', 'Checkbox', 'Switch']) {
      expect(states.map((s) => s.component), contains(name));
    }
  });

  for (final spec in states) {
    final key = '${spec.component}/${spec.state}';
    testWidgets('$key equals its tokens (R9)', (tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final build = parityStates[key];
      expect(build, isNotNull, reason: 'parity_table.dart has no $key');
      await tester.pumpWidget(formApp(build!()));
      await tester.pumpAndSettle();

      final component = find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == spec.flutter,
      );
      expect(component, findsOneWidget);
      final box = find
          .descendant(of: component, matching: find.byType(AnimatedContainer))
          .first;
      TestGesture? held;
      switch (spec.act) {
        case 'hover':
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: Offset.zero);
          addTearDown(mouse.removePointer);
          await mouse.moveTo(tester.getCenter(box));
        case 'press':
          held = await tester.startGesture(tester.getCenter(box));
        case 'focus':
          await tester.tap(box);
      }
      await tester.pump();
      await tester.pumpAndSettle();

      final measured = _measure(tester, component);
      final off = <String, String>{};
      for (final MapEntry(key: metric, value: name) in spec.expect.entries) {
        var want = _tokenValue(metric, name);
        if (metric == 'radius') {
          final shortest = math.min(
            measured['height']! as double,
            measured['width']! as double,
          );
          want = _round(math.min(want as double, shortest / 2));
        }
        final got = measured[metric];
        if (got == null) {
          off[metric] = 'not measurable ($name)';
        } else if (got != want) {
          off[metric] = '$got ≠ $want ($name)';
        }
      }
      await held?.up();
      await tester.pumpAndSettle();
      expect(off, isEmpty);
    });
  }
}
