@Tags(['golden'])
library;

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sheet.dart';

// The components of D.11's screens (slice D.11b, R9), as the approved
// components sheet of the customer screens canvas draws them.

/// The points of the loader's cycle the sheet shows.
const _phases = [0.0, 0.2, 0.45, 0.7, 0.85, 0.97];

Widget _loaders(bool onPrimary) => Builder(
  builder: (context) {
    final rows = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final size in FoxDropLoaderSize.values) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final phase in _phases) ...[
                FoxDropLoader(size: size, onPrimary: onPrimary, phase: phase),
                gap,
              ],
              // Reduced motion: still, half full.
              FoxDropLoader(size: size, onPrimary: onPrimary),
            ],
          ),
          gap,
        ],
      ],
    );
    if (!onPrimary) return rows;
    return ColoredBox(
      color: FoxTheme.of(context).colors.primary,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(FoxSpace.sm),
        child: rows,
      ),
    );
  },
);

void main() {
  setUpAll(loadFoxFonts);

  final themes = {
    'phone': FoxThemeData.phone(),
    'captain': FoxThemeData.captain(),
  };

  for (final MapEntry(key: surface, value: theme) in themes.entries) {
    testWidgets('$surface: the drop loader through its cycle', (tester) async {
      await pumpSheet(
        tester,
        theme,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _loaders(false),
            gap,
            _loaders(true),
            gap,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FoxButton(label: 'اطلب', loading: true, onPressed: () {}),
                gap,
                FoxButton(
                  label: 'أرسل الرمز',
                  loadingLabel: 'جارٍ إرسال الرمز…',
                  loading: true,
                  onPressed: () {},
                ),
                gap,
                FoxButton(
                  label: 'اطلب',
                  variant: FoxButtonVariant.secondary,
                  loading: true,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        size: const Size(640, 520),
      );
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/frame_${surface}_loader.png'),
      );
    });
  }
}
