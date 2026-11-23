@Tags(['golden'])
library;

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sheet.dart';

void main() {
  setUpAll(loadFoxFonts);

  // Every icon at the three sizes. The sheet is RTL, so back, car and
  // motorcycle show mirrored; the last row shows them left to right.
  testWidgets('the icon set at three sizes, and mirrored', (tester) async {
    final mirrored = [
      for (final icon in FoxIcons.all.values)
        if (icon.mirror) icon,
    ];
    await pumpSheet(
      tester,
      FoxThemeData.phone(),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final size in FoxIconSize.values) ...[
            Wrap(
              spacing: FoxSpace.sm,
              runSpacing: FoxSpace.sm,
              children: [
                for (final icon in FoxIcons.all.values)
                  FoxIcon(icon, size: size),
              ],
            ),
            const SizedBox(height: FoxSpace.lg),
          ],
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final icon in mirrored) ...[
                  FoxIcon(icon, size: FoxIconSize.lg),
                  gap,
                ],
              ],
            ),
          ),
        ],
      ),
    );
    await expectLater(
      find.byKey(sheetKey),
      matchesGoldenFile('goldens/icons.png'),
    );
  });
}
