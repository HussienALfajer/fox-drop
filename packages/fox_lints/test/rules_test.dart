// test_reflective_loader finds a test by its `test_` prefix.
// ignore_for_file: non_constant_identifier_names

import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:fox_lints/src/rules.dart';
import 'package:test/test.dart' show expect;
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(NoColorLiteralTest);
    defineReflectiveTests(NoLiteralSpacingTest);
    defineReflectiveTests(NoMaterialImportTest);
    defineReflectiveTests(NoPhysicalDirectionTest);
    defineReflectiveTests(NoLiteralDimensionTest);
    defineReflectiveTests(OutsideEnforcedTest);
    defineReflectiveTests(MaterialAllowedTest);
  });
}

/// The test package, `<workspace>/test`, as the rules name packages.
const _here = {'home/test'};

/// A stand-in for the Flutter classes the rules look at: the rules match by
/// class name inside `package:flutter/`, so the shapes are enough.
const _flutter = r'''
class Color {
  const Color(int value);
  const Color.fromARGB(int a, int r, int g, int b);
}
class EdgeInsets {
  const EdgeInsets.all(double value);
  const EdgeInsets.only({double left = 0, double top = 0, double right = 0, double bottom = 0});
  const EdgeInsets.fromLTRB(double left, double top, double right, double bottom);
  static const zero = EdgeInsets.all(0);
}
class EdgeInsetsDirectional {
  const EdgeInsetsDirectional.only({double start = 0, double end = 0});
}
class SizedBox {
  const SizedBox({double? width, double? height});
}
class TextStyle {
  const TextStyle({double? fontSize, double? height, double? letterSpacing, Color? color});
}
class Positioned {
  const Positioned({double? left, double? right, double? top});
}
class Alignment {
  const Alignment(double x, double y);
  static const centerLeft = Alignment(-1, 0);
  static const center = Alignment(0, 0);
}
enum TextAlign { left, right, start, end, center }
class Radius {
  const Radius.circular(double radius);
}
class BorderRadius {
  const BorderRadius.circular(double radius);
  const BorderRadius.all(Radius radius);
}
class BorderSide {
  const BorderSide({Color? color, double width = 1});
}
class Container {
  const Container({double? width, double? height, Color? color});
}
class BoxConstraints {
  const BoxConstraints({double minWidth = 0, double maxWidth = 0, double minHeight = 0, double maxHeight = 0});
}
class Offset {
  const Offset(double dx, double dy);
}
class BoxShadow {
  const BoxShadow({Color? color, Offset? offset, double blurRadius = 0, double spreadRadius = 0});
}
class Size {
  double get width => 0;
}
class Canvas {}
class Path {}
abstract class CustomPainter {
  void paint(Canvas canvas, Size size);
}
''';

/// A stand-in for core_ui's icon, the one class of ours the dimension rule
/// looks at.
const _coreUi = r'''
class FoxIcon {
  const FoxIcon(Object icon, {double? size});
}
''';

abstract class _RuleTest extends AnalysisRuleTest {
  AbstractAnalysisRule get ruleUnderTest;

  @override
  void setUp() {
    rule = ruleUnderTest;
    // Registered before super.setUp, which writes the package config.
    newPackage('flutter')
      ..addFile('lib/widgets.dart', _flutter)
      ..addFile('lib/material.dart', "export 'widgets.dart';");
    newPackage('core_ui').addFile('lib/core_ui.dart', _coreUi);
    super.setUp();
  }
}

@reflectiveTest
class NoColorLiteralTest extends _RuleTest {
  @override
  AbstractAnalysisRule get ruleUnderTest => NoColorLiteral(packages: _here);

  Future<void> test_literal() async {
    await assertDiagnostics(
      r'''
import 'package:flutter/widgets.dart';
const a = Color(0xFF03428E);
const b = Color.fromARGB(255, 3, 66, 142);
''',
      [lint(49, 17), lint(78, 31)],
    );
  }

  Future<void> test_fromTokens() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
const token = 0xFF03428E;
const a = Color(token);
''');
  }
}

@reflectiveTest
class NoLiteralSpacingTest extends _RuleTest {
  @override
  AbstractAnalysisRule get ruleUnderTest => NoLiteralSpacing(packages: _here);

  Future<void> test_literals() async {
    await assertDiagnostics(
      r'''
import 'package:flutter/widgets.dart';
const a = EdgeInsets.all(8);
const b = SizedBox(height: 12.5);
const c = TextStyle(fontSize: -14);
const d = EdgeInsetsDirectional.only(start: 4);
''',
      [lint(64, 1), lint(95, 4), lint(132, 3), lint(182, 1)],
    );
  }

  Future<void> test_tokensAndZero() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
const space = 16.0;
const a = EdgeInsets.all(space);
const b = SizedBox(width: 0);
const c = EdgeInsets.zero;
''');
  }
}

@reflectiveTest
class NoMaterialImportTest extends _RuleTest {
  @override
  AbstractAnalysisRule get ruleUnderTest => NoMaterialImport(packages: _here);

  Future<void> test_material() async {
    await assertDiagnostics(
      r'''
// ignore: unused_import
import 'package:flutter/material.dart';
''',
      [lint(32, 31)],
    );
  }

  Future<void> test_widgets() async {
    await assertNoDiagnostics(r'''
// ignore: unused_import
import 'package:flutter/widgets.dart';
''');
  }
}

@reflectiveTest
class NoPhysicalDirectionTest extends _RuleTest {
  @override
  AbstractAnalysisRule get ruleUnderTest =>
      NoPhysicalDirection(packages: _here);

  Future<void> test_physical() async {
    await assertDiagnostics(
      r'''
import 'package:flutter/widgets.dart';
const space = 8.0;
const a = EdgeInsets.only(left: space);
const b = EdgeInsets.fromLTRB(space, 0, 0, 0);
const c = Positioned(right: space);
const d = Alignment.centerLeft;
const e = TextAlign.right;
''',
      [
        lint(84, 11),
        lint(108, 35),
        lint(166, 12),
        lint(191, 20),
        lint(223, 15),
      ],
    );
  }

  Future<void> test_enforcedPackages() async {
    // The opt-in list of the workspace: an app joins in its screen slice.
    expect(enforcedPackages, {'packages/core_ui', 'apps/widgetbook'});
    expect(materialPackages, {'packages/core_ui'});
  }

  Future<void> test_logical() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
const a = EdgeInsetsDirectional.only(start: 8);
const b = Positioned(top: 8);
const c = Alignment.center;
const d = TextAlign.start;
''');
  }
}

@reflectiveTest
class NoLiteralDimensionTest extends _RuleTest {
  @override
  AbstractAnalysisRule get ruleUnderTest => NoLiteralDimension(packages: _here);

  Future<void> test_literals() async {
    const code = r'''
import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
const space = 8.0;
const a = Radius.circular(12);
const b = BorderRadius.circular(-6);
const c = BorderSide(width: 1.5);
const d = Container(width: 40);
const e = BoxConstraints(maxWidth: 360);
const f = Offset(0, 3);
const g = BoxShadow(blurRadius: 9, spreadRadius: 0);
const h = Duration(milliseconds: 150);
const i = FoxIcon(Object(), size: 20);
const j = TextStyle(letterSpacing: space / 40);
const k = SizedBox(width: space * 3);
''';
    // Each literal is reported where it stands, inside the expression too.
    int at(String line, String literal) =>
        code.indexOf(line) + line.indexOf(literal);
    await assertDiagnostics(code, [
      lint(at('Radius.circular(12)', '12'), 2),
      lint(at('circular(-6)', '6'), 1),
      lint(at('width: 1.5', '1.5'), 3),
      lint(at('width: 40', '40'), 2),
      lint(at('maxWidth: 360', '360'), 3),
      lint(at('Offset(0, 3)', '3'), 1),
      lint(at('blurRadius: 9', '9'), 1),
      lint(at('milliseconds: 150', '150'), 3),
      lint(at('size: 20', '20'), 2),
      lint(at('space / 40', '40'), 2),
      lint(at('space * 3', '3'), 1),
    ]);
  }

  Future<void> test_tokensZeroHalvesAndPainters() async {
    await assertNoDiagnostics(r'''
import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
const space = 8.0;
const a = Radius.circular(space);
const b = BorderSide(width: 0);
const c = Offset(0, 0);
const d = Radius.circular(space / 2);
const e = Duration(seconds: 4);
const f = FoxIcon(Object(), size: space);
// A direct literal in SizedBox or TextStyle is no_literal_spacing's.
const g = SizedBox(width: 5);

/// A painter draws in its own unit: its geometry is not a design value.
class Drop extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) =>
      print([Radius.circular(size.width / 24 * 9), Offset(3, 8.5)]);
}

/// A painter's helper takes the canvas or builds a path.
void tick(Canvas canvas) => print(Offset(1, 2));
Path pin(Size size) {
  print(Radius.circular(9));
  return Path();
}
''');
  }

  /// A checked class inside another is reported once (review of D.W1).
  Future<void> test_nestedOnce() async {
    const code = r'''
import 'package:flutter/widgets.dart';
const a = BorderRadius.all(Radius.circular(12));
''';
    await assertDiagnostics(code, [lint(code.indexOf('12'), 2)]);
  }

  Future<void> test_coreUiOnly() async {
    expect(NoLiteralDimension().packages, {'packages/core_ui'});
  }
}

/// A package not on the list is not checked.
@reflectiveTest
class OutsideEnforcedTest extends _RuleTest {
  @override
  AbstractAnalysisRule get ruleUnderTest =>
      NoLiteralSpacing(packages: {'apps/customer'});

  Future<void> test_notChecked() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
const a = EdgeInsets.all(8);
''');
  }
}

/// core_ui may import Material.
@reflectiveTest
class MaterialAllowedTest extends _RuleTest {
  @override
  AbstractAnalysisRule get ruleUnderTest =>
      NoMaterialImport(packages: _here, allowed: _here);

  Future<void> test_allowed() async {
    await assertNoDiagnostics(r'''
// ignore: unused_import
import 'package:flutter/material.dart';
''');
  }
}
