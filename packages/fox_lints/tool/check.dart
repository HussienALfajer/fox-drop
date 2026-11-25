/// `dart packages/fox_lints/tool/check.dart`: the fox_lints check
/// (bin/check.dart) as the check commands run it, next to
/// `dart analyze --no-plugins`. Exit 1 on a finding.
///
/// It compiles bin/check.dart to an executable in `.dart_tool/fox_lints`
/// once per change to fox_lints, the lockfile or the SDK (about 35 s), then
/// runs that: about 4 s warm, against 15 s for `dart run fox_lints:check`.
/// Only dart:io here, so this script itself starts in well under a second.
library;

import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final sep = Platform.pathSeparator;
  // <root>/packages/fox_lints/tool/check.dart
  final package = File.fromUri(Platform.script).parent.parent;
  final root = package.parent.parent.path;
  final dart = Platform.resolvedExecutable;
  final sdk = File(dart).parent.parent.path;

  final cache = Directory('$root$sep.dart_tool${sep}fox_lints')
    ..createSync(recursive: true);
  final key = _key([
    for (final folder in ['bin', 'lib'])
      Directory('${package.path}$sep$folder'),
  ], File('$root${sep}pubspec.lock'));
  final suffix = Platform.isWindows ? '.exe' : '';
  final exe = File('${cache.path}${sep}check-$key$suffix');

  if (!exe.existsSync()) {
    for (final old in cache.listSync().whereType<File>()) {
      final name = old.uri.pathSegments.last;
      if (name.startsWith('check-')) _tryDelete(old);
    }
    stderr.writeln(
      'fox_lints: compiling the check, once per change to fox_lints, '
      'pubspec.lock or the SDK...',
    );
    // A temporary name, so a check running at the same time never starts
    // a half-written executable.
    final temp = '${exe.path}.$pid$suffix';
    final compile = await Process.run(dart, [
      'compile',
      'exe',
      '--verbosity=error',
      '${package.path}${sep}bin${sep}check.dart',
      '-o',
      temp,
    ]);
    if (compile.exitCode != 0) {
      stderr
        ..write(compile.stdout)
        ..write(compile.stderr)
        ..writeln('fox_lints: the check did not compile.');
      exit(compile.exitCode);
    }
    try {
      File(temp).renameSync(exe.path);
    } on FileSystemException {
      // Another check compiled the same sources first.
      _tryDelete(File(temp));
    }
  }

  final run = await Process.start(exe.path, [
    '--sdk=$sdk',
    root,
  ], mode: ProcessStartMode.inheritStdio);
  exit(await run.exitCode);
}

/// A 64-bit FNV-1a hash of the Dart SDK's version, [lockfile] and the files
/// under [folders], in hex.
String _key(List<Directory> folders, File lockfile) {
  var hash = 0xcbf29ce484222325;
  void add(List<int> bytes) {
    for (final byte in bytes) {
      hash = (hash ^ byte) * 0x100000001b3;
    }
  }

  add(utf8.encode(Platform.version));
  add(lockfile.readAsBytesSync());
  final files = [
    for (final folder in folders)
      ...folder.listSync(recursive: true).whereType<File>(),
  ]..sort((a, b) => a.path.compareTo(b.path));
  for (final file in files) {
    add(utf8.encode(file.path.substring(folders.first.parent.path.length)));
    add(file.readAsBytesSync());
  }
  return hash.toUnsigned(64).toRadixString(16).padLeft(16, '0');
}

void _tryDelete(File file) {
  try {
    file.deleteSync();
  } on FileSystemException {
    // Still running on Windows; the next compile removes it.
  }
}
