// The checker runs the plugin's rules the way analysis_server_plugin's
// PluginServer does (`_computeDiagnosticsFromPlugin`), through the same
// analyzer internals; analyzer is pinned to one version (pubspec.yaml).
// ignore_for_file: implementation_imports

import 'dart:io';
import 'dart:typed_data';

import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/analysis_rule/rule_context.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/src/dart/analysis/byte_store.dart';
import 'package:analyzer/src/dart/analysis/file_byte_store.dart';
import 'package:analyzer/src/dart/element/type_system.dart';
import 'package:analyzer/src/ignore_comments/ignore_info.dart';
import 'package:analyzer/src/lint/linter_visitor.dart';

import 'rules.dart';

/// One diagnostic of a rule, with its file relative to the workspace root.
typedef Finding = ({
  String path,
  int line,
  int column,
  String message,
  String code,
});

/// Runs [rules] over the Dart files of [packages] (`<parent>/<folder>` under
/// [root]) with their libraries resolved, and returns what they report, minus
/// what an `// ignore: fox_lints/<code>` comment suppresses.
///
/// Only these packages are resolved, against the summaries of what they
/// import, which are kept in `<root>/.dart_tool/fox_lints` between runs.
/// [sdkPath] is the Dart SDK; by default the one running this code, which a
/// compiled executable does not have.
Future<List<Finding>> check(
  String root, {
  String? sdkPath,
  Set<String> packages = enforcedPackages,
  List<AnalysisRule>? rules,
}) async {
  rules ??= foxRules();
  final resources = PhysicalResourceProvider.INSTANCE;
  final paths = resources.pathContext;
  root = paths.normalize(paths.absolute(root));
  final included = [
    for (final package in packages)
      paths.joinAll([root, ...package.split('/')]),
  ];
  final collection = AnalysisContextCollectionImpl(
    resourceProvider: resources,
    sdkPath: sdkPath,
    includedPaths: included,
    byteStore: MemoryCachingByteStore(
      _SyncFileByteStore(paths.join(root, '.dart_tool', 'fox_lints', 'cache')),
      256 * 1024 * 1024,
    ),
    // The rules need resolved code only, not the analyzer's own warnings
    // and lints, which `dart analyze` reports.
    updateAnalysisOptions4: ({required analysisOptions}) => analysisOptions
      ..warning = false
      ..lint = false,
  );
  final findings = <Finding>[];
  try {
    for (final analysisContext in collection.contexts) {
      final contextRoot = analysisContext.contextRoot;
      final files =
          contextRoot.analyzedFiles().where((p) => p.endsWith('.dart')).toList()
            ..sort();
      for (final path in files) {
        final library = await analysisContext.currentSession.getResolvedLibrary(
          path,
        );
        // A part is checked with its library.
        if (library is! ResolvedLibraryResult) continue;
        final listeners = <ResolvedUnitResult, RecordingDiagnosticListener>{};
        final units = <RuleContextUnit>[];
        RuleContextUnit? definingUnit;
        for (final unit in library.units) {
          final listener = listeners[unit] = RecordingDiagnosticListener();
          final contextUnit = RuleContextUnit(
            file: unit.file,
            content: unit.content,
            diagnosticReporter: DiagnosticReporter(
              listener,
              unit.libraryElement.firstFragment.source,
            ),
            unit: unit.unit,
          );
          units.add(contextUnit);
          if (unit.path == path) definingUnit = contextUnit;
        }
        final context = RuleContextWithResolvedResults(
          units,
          definingUnit ?? units.first,
          library.element.typeProvider,
          library.element.typeSystem as TypeSystemImpl,
          contextRoot.workspace.findPackageFor(path),
        );
        final registry = RuleVisitorRegistryImpl(enableTiming: false);
        for (final rule in rules) {
          rule.registerNodeProcessors(registry, context);
        }
        for (final unit in units) {
          if (!contextRoot.isAnalyzed(unit.file.path)) continue;
          for (final rule in rules) {
            rule.reporter = unit.diagnosticReporter;
          }
          context.currentUnit = unit;
          unit.unit.accept(
            AnalysisRuleVisitor(registry, shouldPropagateExceptions: true),
          );
        }
        AnalysisRuleVisitor(registry).afterLibrary();
        for (final MapEntry(key: unit, value: listener) in listeners.entries) {
          final ignores = IgnoreInfo.forDart(unit.unit, unit.content);
          for (final diagnostic in listener.diagnostics) {
            if (ignores.ignored(diagnostic, pluginName: 'fox_lints')) continue;
            findings.add(_finding(root, unit, diagnostic));
          }
        }
      }
    }
  } finally {
    await collection.dispose();
  }
  // In the order `dart analyze` prints them.
  return findings..sort(
    (a, b) => a.path != b.path
        ? a.path.compareTo(b.path)
        : a.line != b.line
        ? a.line - b.line
        : a.column - b.column,
  );
}

/// The analyzer's [FileByteStore] with its writes done before `putGet`
/// returns: FileByteStore writes in the background with no way to wait, so a
/// process that exits after a cold run would keep only part of its cache.
/// Each entry goes to a temporary file first, so a killed run or a second
/// check at the same time never leaves a half-written one.
class _SyncFileByteStore implements ByteStore {
  _SyncFileByteStore(this.path) {
    Directory(path).createSync(recursive: true);
  }

  final String path;
  final _validator = FileByteStoreValidator();

  File _file(String key) => File('$path${Platform.pathSeparator}$key');

  @override
  Uint8List? get(String key) {
    try {
      return _validator.getData(_file(key).readAsBytesSync());
    } on FileSystemException {
      return null;
    }
  }

  @override
  Uint8List putGet(String key, Uint8List bytes) {
    final file = _file(key);
    final temp = File('${file.path}.$pid.tmp');
    try {
      temp.writeAsBytesSync(_validator.wrapData(bytes));
      temp.renameSync(file.path);
    } on FileSystemException {
      // Not cached this time; the check still runs.
      if (temp.existsSync()) temp.deleteSync();
    }
    return bytes;
  }

  @override
  void release(Iterable<String> keys) {}
}

Finding _finding(String root, ResolvedUnitResult unit, Diagnostic diagnostic) {
  final location = unit.lineInfo.getLocation(diagnostic.offset);
  final paths = PhysicalResourceProvider.INSTANCE.pathContext;
  return (
    path: paths.split(paths.relative(unit.path, from: root)).join('/'),
    line: location.lineNumber,
    column: location.columnNumber,
    message: [diagnostic.message, ?diagnostic.correctionMessage].join(' '),
    code: diagnostic.diagnosticCode.lowerCaseName,
  );
}
