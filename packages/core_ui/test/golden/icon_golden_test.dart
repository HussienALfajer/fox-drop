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

  // The six styles of set v4 Madar (§9.4) for a few icons, one row per
  // style: the phone's stroke 1.5, then the captain's 1.75.
  for (final (name, theme) in [
    ('phone', FoxThemeData.phone()),
    ('captain', FoxThemeData.captain()),
  ]) {
    testWidgets('the six styles at the $name stroke', (tester) async {
      const icons = [
        FoxIcons.home,
        FoxIcons.bell,
        FoxIcons.wallet,
        FoxIcons.car,
        FoxIcons.offline,
        FoxIcons.heart,
        FoxIcons.back,
      ];
      await pumpSheet(
        tester,
        theme,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final style in FoxIconStyle.values) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final icon in icons) ...[
                    FoxIcon(icon, size: FoxIconSize.lg, style: style),
                    gap,
                  ],
                ],
              ),
              const SizedBox(height: FoxSpace.sm),
            ],
          ],
        ),
      );
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/icon_styles_$name.png'),
      );
    });
  }
}
