import 'dart:convert';
import 'dart:io';

import 'package:fox_lints/src/check.dart';
import 'package:test/test.dart';

/// The Flutter shapes the rules look at (as in rules_test.dart).
const _flutter = r'''
class Color {
  const Color(int value);
}
class EdgeInsets {
  const EdgeInsets.all(double value);
}
class Alignment {
  const Alignment(double x, double y);
  static const centerLeft = Alignment(-1, 0);
}
''';

/// One violation of each rule, and one suppressed by an ignore comment.
const _violations = '''
import 'package:flutter/material.dart';
part 'part.dart';
const a = Color(0xFF03428E);
const b = EdgeInsets.all(8);
const c = Alignment.centerLeft;
// ignore: fox_lints/no_color_literal
const d = Color(0xFF000000);
''';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('fox_lints_check_');
    void write(String path, String content) => File('${root.path}/$path')
      ..createSync(recursive: true)
      ..writeAsStringSync(content);

    write('flutter/pubspec.yaml', 'name: flutter\n');
    write('flutter/lib/widgets.dart', _flutter);
    write('flutter/lib/material.dart', "export 'widgets.dart';\n");
    final packages = ['packages/core_ui', 'apps/widgetbook', 'apps/customer'];
    for (final package in packages) {
      write('$package/pubspec.yaml', 'name: ${package.split('/').last}\n');
      write('$package/lib/main.dart', _violations);
      write(
        '$package/lib/part.dart',
        "part of 'main.dart';\n"
            'const e = EdgeInsets.all(4);\n',
      );
    }
    write(
      '.dart_tool/package_config.json',
      jsonEncode({
        'configVersion': 2,
        'packages': [
          for (final package in ['flutter', ...packages])
            {
              'name': package.split('/').last,
              'rootUri': '../$package',
              'packageUri': 'lib/',
            },
        ],
      }),
    );
  });

  tearDown(() => root.deleteSync(recursive: true));

  test('reports each rule in the enforced packages only', () async {
    final findings = await check(root.path);
    expect(
      [for (final f in findings) '${f.path}:${f.line}:${f.column} ${f.code}'],
      // Sorted by file, line and column, as `dart analyze` prints them.
      [
        'apps/widgetbook/lib/main.dart:1:8 no_material_import',
        'apps/widgetbook/lib/main.dart:3:11 no_color_literal',
        'apps/widgetbook/lib/main.dart:4:26 no_literal_spacing',
        'apps/widgetbook/lib/main.dart:5:11 no_physical_direction',
        'apps/widgetbook/lib/part.dart:2:26 no_literal_spacing',
        // core_ui may import Material.
        'packages/core_ui/lib/main.dart:3:11 no_color_literal',
        'packages/core_ui/lib/main.dart:4:26 no_literal_spacing',
        'packages/core_ui/lib/main.dart:5:11 no_physical_direction',
        'packages/core_ui/lib/part.dart:2:26 no_literal_spacing',
      ],
    );
    expect(
      findings.firstWhere((f) => f.code == 'no_color_literal').message,
      'A colour literal: colours come from the tokens (R2). '
      'Use a colour of FoxTheme.of(context).colors.',
    );
  });

  test('reports nothing in a package that is not enforced', () async {
    expect(await check(root.path, packages: {'apps/customer'}), isEmpty);
  });
}
