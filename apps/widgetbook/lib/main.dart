import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

import 'catalogue.dart';

/// The core_ui catalogue (architecture §9.7), run on Windows:
/// `flutter run -d windows` from apps/widgetbook. CoFo comes from the
/// repository's `.fonts/` (`pnpm fonts:fetch`), as in the goldens.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadFoxFonts();
  runApp(const FoxWidgetbook());
}

class FoxWidgetbook extends StatelessWidget {
  const FoxWidgetbook({super.key});

  @override
  Widget build(BuildContext context) => Widgetbook.material(
    directories: catalogue,
    addons: [
      ThemeAddon<FoxThemeData>(
        themes: [
          WidgetbookTheme(name: 'phone', data: FoxThemeData.phone()),
          WidgetbookTheme(name: 'captain', data: FoxThemeData.captain()),
        ],
        themeBuilder: (context, theme, child) => FoxTheme(
          data: theme,
          child: ColoredBox(
            color: theme.colors.surface,
            child: DefaultTextStyle(
              style: theme.text.body.copyWith(color: theme.colors.onSurface),
              // Arabic first (R5): every use case is right to left.
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: child,
              ),
            ),
          ),
        ),
      ),
      TextScaleAddon(min: 1, max: 2, divisions: 4),
    ],
  );
}
