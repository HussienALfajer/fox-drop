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
  const TextStyle({double? fontSize, double? height, Color? color});
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
