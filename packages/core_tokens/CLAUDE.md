# packages/core_tokens

The design tokens for Dart (architecture §9.2): plain Dart, no Flutter, tested with `dart test`. `core_ui` wraps them in Flutter types (D.7); apps never import this package directly.

## Rules

- **`lib/src/tokens.g.dart` and `lib/src/icons.g.dart` are generated** by `pnpm --filter @fox-drop/design-tokens generate` from `packages/design-tokens/tokens/` and `packages/design-tokens/icons/`. Never edit them: change the sources there and regenerate. The design-tokens test fails when it is stale.
- Colours are ARGB `int`s, lengths `double`s in logical pixels, durations `Duration`s. Themes: `FoxColors.light`, `.dark` (a copy of light until dark mode is designed), `.captainLight` and `.captainDark`; type scales `FoxType.phone`, `.panel` and `.captain`.
