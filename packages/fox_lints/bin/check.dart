/// The fox_lints rules over `enforcedPackages`, without the analyzer plugin
/// (which re-resolves the whole workspace on each `dart analyze`):
/// `check [--sdk=<dart sdk>] [<workspace root>]`, exit 1 on a finding.
///
/// The check runs it through `dart packages/fox_lints/tool/check.dart`, which
/// compiles it to an executable once (4 s a run against 15 s for
/// `dart run fox_lints:check`).
library;

import 'dart:io';

import 'package:fox_lints/src/check.dart';

Future<void> main(List<String> args) async {
  String? sdk;
  String? root;
  for (final arg in args) {
    if (arg.startsWith('--sdk=')) {
      sdk = arg.substring('--sdk='.length);
    } else if (root == null && !arg.startsWith('-')) {
      root = arg;
    } else {
      stderr.writeln('usage: check [--sdk=<dart sdk>] [<workspace root>]');
      exit(64);
    }
  }
  root ??= workspaceRoot(Directory.current);
  if (root == null) {
    stderr.writeln('fox_lints: no pub workspace above ${Directory.current}');
    exit(66);
  }
  final findings = await check(root, sdkPath: sdk);
  for (final f in findings) {
    stdout.writeln(
      '   info - ${f.path}:${f.line}:${f.column} - ${f.message} - ${f.code}',
    );
  }
  final n = findings.length;
  stdout.writeln(
    n == 0
        ? 'fox_lints: no issues found.'
        : 'fox_lints: $n issue${n == 1 ? '' : 's'} found.',
  );
  // dart:io does not flush stdout on exit().
  await stdout.flush();
  exit(n == 0 ? 0 : 1);
}

/// The nearest folder at or above [from] whose pubspec.yaml declares a
/// `workspace:`.
String? workspaceRoot(Directory from) {
  for (var dir = from.absolute; ; dir = dir.parent) {
    final pubspec = File('${dir.path}${Platform.pathSeparator}pubspec.yaml');
    if (pubspec.existsSync() &&
        pubspec.readAsLinesSync().any((l) => l.startsWith('workspace:'))) {
      return dir.path;
    }
    if (dir.parent.path == dir.path) return null;
  }
}
