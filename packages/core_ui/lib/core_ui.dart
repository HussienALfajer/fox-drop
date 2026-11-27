/// The FOX DROP Flutter components (architecture §9.7). Apps import this
/// library only, never `core_tokens` or Material. No component since D.R1
/// (2026-11-27): each returns, after its web twin, with the approved screen
/// that needs it (§9.9).
library;

export 'package:core_tokens/core_tokens.dart'
    show
        FoxDuration,
        FoxIconData,
        FoxMotion,
        FoxIcons,
        FoxRadius,
        FoxSize,
        FoxSpace;

export 'src/theme/fox_theme.dart';
