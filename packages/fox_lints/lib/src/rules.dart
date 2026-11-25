import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

/// The workspace packages the rules run in, as `<parent>/<folder>`. A plugin
/// can be declared only in the workspace root's analysis_options.yaml, and a
/// package's own `analyzer: errors:` does not know a plugin's codes, so a
/// package opts in here: each app joins in its own screen slice (D.7 owner
/// decision 3), when its screens move to core_ui.
const enforcedPackages = {'packages/core_ui', 'apps/widgetbook'};

/// The packages where Material may be imported: core_ui wraps `material_ui`
/// for its complex components (architecture §9.10).
const materialPackages = {'packages/core_ui'};

/// The rules, as the plugin (lib/main.dart) and the check (lib/src/check.dart)
/// run them.
List<AnalysisRule> foxRules() => [
  NoColorLiteral(),
  NoLiteralSpacing(),
  NoMaterialImport(),
  NoPhysicalDirection(),
  NoLiteralDimension(),
];

String? _packageOf(RuleContext context) {
  final root = context.package?.root;
  if (root == null) return null;
  return '${root.parent.shortName}/${root.shortName}';
}

/// A fox_lints rule: it runs only in [packages].
abstract class FoxRule extends AnalysisRule {
  FoxRule({
    required super.name,
    required super.description,
    this.packages = enforcedPackages,
  });

  final Set<String> packages;

  bool appliesTo(RuleContext context) => packages.contains(_packageOf(context));
}

/// Whether [element] is declared by Flutter (`package:flutter/…`) or the
/// engine (`dart:ui`), where `Color`, `EdgeInsets` and the rest live.
bool _isFlutter(Element? element) {
  final uri = element?.library?.uri;
  if (uri == null) return false;
  return (uri.scheme == 'package' &&
          uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first == 'flutter') ||
      (uri.scheme == 'dart' && uri.path == 'ui');
}

/// The Flutter class an instance creation builds, or null.
String? _flutterClass(InstanceCreationExpression node) {
  final element = node.constructorName.type.element;
  return _isFlutter(element) ? element!.name : null;
}

bool _isNonZeroNumber(Expression expression) {
  final e = expression.unParenthesized;
  if (e is PrefixExpression) return _isNonZeroNumber(e.operand);
  if (e is IntegerLiteral) return e.value != 0;
  if (e is DoubleLiteral) return e.value != 0;
  return false;
}

/// R2: no `Color(0x…)` or `Color.fromARGB(…)` with literal channels; a colour
/// comes from `FoxTheme.of(context).colors`.
class NoColorLiteral extends FoxRule {
  static const code = LintCode(
    'no_color_literal',
    'A colour literal: colours come from the tokens (R2).',
    correctionMessage: 'Use a colour of FoxTheme.of(context).colors.',
  );

  NoColorLiteral({super.packages})
    : super(name: 'no_color_literal', description: 'No colour literals.');

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    if (!appliesTo(context)) return;
    registry.addInstanceCreationExpression(this, _ColorVisitor(this));
  }
}

class _ColorVisitor extends SimpleAstVisitor<void> {
  _ColorVisitor(this.rule);

  final AnalysisRule rule;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (_flutterClass(node) != 'Color') return;
    final literal = node.argumentList.arguments.any((argument) {
      final e = argument.argumentExpression;
      return e.unParenthesized is IntegerLiteral ||
          e.unParenthesized is DoubleLiteral;
    });
    if (literal) rule.reportAtNode(node);
  }
}

/// R2: no number literal other than 0 in `EdgeInsets*`, `SizedBox` or
/// `TextStyle`; lengths and type come from `FoxSpace`, `FoxSize` and the
/// theme's text styles.
class NoLiteralSpacing extends FoxRule {
  static const code = LintCode(
    'no_literal_spacing',
    'A number literal in {0}: lengths and type come from the tokens (R2).',
    correctionMessage:
        'Use FoxSpace, FoxSize or a text style of FoxTheme.of(context).text.',
  );

  static const _classes = {
    'EdgeInsets',
    'EdgeInsetsDirectional',
    'SizedBox',
    'TextStyle',
  };

  NoLiteralSpacing({super.packages})
    : super(
        name: 'no_literal_spacing',
        description: 'No literal lengths in insets, gaps and text styles.',
      );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    if (!appliesTo(context)) return;
    registry.addInstanceCreationExpression(this, _SpacingVisitor(this));
  }
}

class _SpacingVisitor extends SimpleAstVisitor<void> {
  _SpacingVisitor(this.rule);

  final AnalysisRule rule;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final name = _flutterClass(node);
    if (name == null || !NoLiteralSpacing._classes.contains(name)) return;
    for (final argument in node.argumentList.arguments) {
      final e = argument.argumentExpression;
      if (_isNonZeroNumber(e)) rule.reportAtNode(e, arguments: [name]);
    }
  }
}

/// R2 (slice D.W1): no number literal other than 0 in a component's radii,
/// borders, sizes, type, icon size, offsets, shadows or durations, anywhere in
/// the argument (`gap * 3` too): a dimension is a token. Halving (`x / 2`)
/// is geometry, not a design value. A painter draws in its own unit, so a
/// `CustomPainter` or `CustomClipper` subclass and its helpers (a function
/// that takes a `Canvas` or returns a `Path`) are out of scope. A direct
/// literal in `SizedBox` or `TextStyle` is [NoLiteralSpacing]'s.
class NoLiteralDimension extends FoxRule {
  static const code = LintCode(
    'no_literal_dimension',
    'A number literal in {0}: dimensions and durations come from the tokens '
        '(R2).',
    correctionMessage:
        'Use FoxSize, FoxRadius, FoxBorderWidth, FoxDuration or a component '
        'token of FoxTheme.of(context).',
  );

  /// The Flutter classes and the arguments it checks; null checks them all.
  static const _flutterArguments = <String, Set<String>?>{
    'Radius': null,
    'BorderRadius': null,
    'BorderSide': {'width'},
    'SizedBox': {'width', 'height'},
    'Container': {'width', 'height'},
    'BoxConstraints': null,
    'TextStyle': {'fontSize', 'height', 'letterSpacing'},
    'Offset': null,
    'BoxShadow': {'blurRadius', 'spreadRadius'},
  };

  NoLiteralDimension({super.packages = const {'packages/core_ui'}})
    : super(
        name: 'no_literal_dimension',
        description: 'No literal dimensions or durations in components.',
      );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    // Component code only: a test may pin a size or wait a set time.
    if (!appliesTo(context) || !context.isInLibDir) return;
    registry.addInstanceCreationExpression(this, _DimensionVisitor(this));
  }
}

class _DimensionVisitor extends SimpleAstVisitor<void> {
  _DimensionVisitor(this.rule);

  final AnalysisRule rule;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final (name, checked) = _checked(node);
    if (name == null || _inPainter(node)) return;
    for (final argument in node.argumentList.arguments) {
      final label = argument is NamedArgument ? argument.name.lexeme : null;
      if (checked != null && (label == null || !checked.contains(label))) {
        continue;
      }
      final e = argument.argumentExpression;
      // A direct literal here is no_literal_spacing's report.
      if (NoLiteralSpacing._classes.contains(name) && _isNonZeroNumber(e)) {
        continue;
      }
      final literals = _Literals();
      e.accept(literals);
      for (final literal in literals.found) {
        rule.reportAtNode(literal, arguments: [name]);
      }
    }
  }

  /// The class name and its checked arguments (null: all), or a null name.
  (String?, Set<String>?) _checked(InstanceCreationExpression node) {
    final element = node.constructorName.type.element;
    final name = element?.name;
    final uri = element?.library?.uri;
    if (_isFlutter(element) &&
        NoLiteralDimension._flutterArguments.containsKey(name)) {
      return (name, NoLiteralDimension._flutterArguments[name]);
    }
    if (name == 'Duration' && uri?.toString() == 'dart:core') {
      return (name, {'milliseconds'});
    }
    if (name == 'FoxIcon' &&
        uri?.scheme == 'package' &&
        uri!.pathSegments.first == 'core_ui') {
      return (name, {'size'});
    }
    return (null, null);
  }

  static bool _inPainter(AstNode node) {
    for (AstNode? at = node.parent; at != null; at = at.parent) {
      if (at is ClassDeclaration) {
        final element = at.declaredFragment?.element;
        final painter = element?.allSupertypes.any(
          (type) =>
              _isFlutter(type.element) &&
              (type.element.name == 'CustomPainter' ||
                  type.element.name == 'CustomClipper'),
        );
        if (painter ?? false) return true;
      }
      if (at is FunctionDeclaration &&
          _drawsOrBuildsPath(at.functionExpression.parameters, at.returnType)) {
        return true;
      }
      if (at is MethodDeclaration &&
          _drawsOrBuildsPath(at.parameters, at.returnType)) {
        return true;
      }
    }
    return false;
  }

  static bool _drawsOrBuildsPath(
    FormalParameterList? parameters,
    TypeAnnotation? returnType,
  ) {
    bool isFlutterType(DartType? type, String name) =>
        type != null && type.element?.name == name && _isFlutter(type.element);
    if (isFlutterType(returnType?.type, 'Path')) return true;
    return parameters?.parameters.any(
          (p) => isFlutterType(p.declaredFragment?.element.type, 'Canvas'),
        ) ??
        false;
  }
}

/// The non-zero number literals of an expression, halving divisors left out.
class _Literals extends RecursiveAstVisitor<void> {
  final found = <Literal>[];

  @override
  void visitBinaryExpression(BinaryExpression node) {
    node.leftOperand.accept(this);
    final right = node.rightOperand.unParenthesized;
    final halving =
        node.operator.lexeme == '/' &&
        right is IntegerLiteral &&
        right.value == 2;
    if (!halving) node.rightOperand.accept(this);
  }

  @override
  void visitIntegerLiteral(IntegerLiteral node) {
    if (node.value != 0) found.add(node);
  }

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    if (node.value != 0) found.add(node);
  }
}

/// R2: apps never import Material or Cupertino; only [materialPackages] may.
class NoMaterialImport extends FoxRule {
  static const code = LintCode(
    'no_material_import',
    'Material and Cupertino are imported only inside core_ui (R2).',
    correctionMessage: 'Use a core_ui widget.',
  );

  NoMaterialImport({super.packages, this.allowed = materialPackages})
    : super(
        name: 'no_material_import',
        description: 'No Material or Cupertino outside core_ui.',
      );

  final Set<String> allowed;

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    if (!appliesTo(context) || allowed.contains(_packageOf(context))) return;
    registry.addImportDirective(this, _ImportVisitor(this));
  }
}

class _ImportVisitor extends SimpleAstVisitor<void> {
  _ImportVisitor(this.rule);

  final AnalysisRule rule;

  static const _banned = [
    'package:flutter/material.dart',
    'package:flutter/cupertino.dart',
    'package:material_ui/',
    'package:cupertino_ui/',
  ];

  @override
  void visitImportDirective(ImportDirective node) {
    final uri = node.uri.stringValue;
    if (uri != null && _banned.any(uri.startsWith)) {
      rule.reportAtNode(node.uri);
    }
  }
}

/// R5: start and end, never left and right: no `EdgeInsets.only(left: …)`,
/// `EdgeInsets.fromLTRB`, `Positioned(left: …)`, `Alignment.centerLeft` or
/// `TextAlign.right`.
class NoPhysicalDirection extends FoxRule {
  static const code = LintCode(
    'no_physical_direction',
    'A physical direction ({0}): layouts use start and end (R5).',
    correctionMessage:
        'Use EdgeInsetsDirectional, PositionedDirectional, '
        'AlignmentDirectional or TextAlign.start and end.',
  );

  NoPhysicalDirection({super.packages})
    : super(
        name: 'no_physical_direction',
        description: 'No left or right in insets, positions and alignment.',
      );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    if (!appliesTo(context)) return;
    final visitor = _DirectionVisitor(this);
    registry.addInstanceCreationExpression(this, visitor);
    registry.addPrefixedIdentifier(this, visitor);
    registry.addPropertyAccess(this, visitor);
  }
}

class _DirectionVisitor extends SimpleAstVisitor<void> {
  _DirectionVisitor(this.rule);

  final AnalysisRule rule;

  static const _withSides = {'EdgeInsets', 'Positioned'};
  static const _physicalConstants = {
    'Alignment': {
      'topLeft',
      'centerLeft',
      'bottomLeft',
      'topRight',
      'centerRight',
      'bottomRight',
    },
    'TextAlign': {'left', 'right'},
  };

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final name = _flutterClass(node);
    if (name == null || !_withSides.contains(name)) return;
    final constructor = node.constructorName.name?.name;
    if (constructor == 'fromLTRB') {
      rule.reportAtNode(node, arguments: ['$name.fromLTRB']);
      return;
    }
    for (final argument in node.argumentList.arguments) {
      if (argument is NamedArgument &&
          (argument.name.lexeme == 'left' || argument.name.lexeme == 'right')) {
        rule.reportAtNode(argument, arguments: [argument.name.lexeme]);
      }
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) =>
      _constant(node, node.prefix.element, node.identifier.name);

  @override
  void visitPropertyAccess(PropertyAccess node) {
    final target = node.target;
    if (target is Identifier) {
      _constant(node, target.element, node.propertyName.name);
    }
  }

  void _constant(AstNode node, Element? type, String member) {
    if (!_isFlutter(type)) return;
    final names = _physicalConstants[type!.name];
    if (names != null && names.contains(member)) {
      rule.reportAtNode(node, arguments: ['${type.name}.$member']);
    }
  }
}
