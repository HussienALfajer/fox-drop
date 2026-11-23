/// Test helpers of `core_ui`: import from tests and widgetbook only.
library;

import 'dart:io';

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';

/// The CoFo files of the weights the tokens use, as `scripts/font-metrics.mjs`
/// names them.
const _files = {
  t.FoxFont.regular: 'CoFoSansProArabic-Regular.ttf',
  t.FoxFont.medium: 'CoFoSansProArabic-Medium.ttf',
  t.FoxFont.bold: 'CoFoSansProArabic-Bold.ttf',
};

/// Registers CoFo 400, 500 and 700 from the repository's `.fonts/` (fetched
/// by `pnpm fonts:fetch`, never committed) under `FoxFont.family`. Throws
/// when the fonts are missing: a golden in a fallback font would be wrong,
/// so it never skips.
Future<void> loadFoxFonts() async {
  final folder = _fontFolder();
  final loader = FontLoader(t.FoxFont.family);
  for (final name in _files.values) {
    final file = File('${folder.path}/$name');
    if (!file.existsSync()) {
      throw StateError('${file.path} is missing: run `pnpm fonts:fetch`.');
    }
    loader.addFont(
      file.readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
    );
  }
  await loader.load();
}

Directory _fontFolder() {
  var dir = Directory.current.absolute;
  while (true) {
    final fonts = Directory('${dir.path}/.fonts/cofo-sans-pro-arabic');
    if (fonts.existsSync()) return fonts;
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError(
        'No .fonts/cofo-sans-pro-arabic above ${Directory.current.path}: '
        'run `pnpm fonts:fetch` in the repository.',
      );
    }
    dir = parent;
  }
}
