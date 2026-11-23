# packages/core_ui

The Flutter design system (architecture §9.5, §9.7, §9.10): the theme from `core_tokens` and the `Fox*` components. The three apps import this package only, never `core_tokens` or Material.

## Rules

- **Layout:** `lib/src/theme/fox_theme.dart` (`FoxThemeData.phone()` for customer and merchant, `.captain()`; `FoxTheme` and `FoxTheme.of`), `lib/src/<component>/fox_<component>.dart`, `lib/testing.dart` (`loadFoxFonts`). `lib/core_ui.dart` exports the components and re-exports the token types an app passes (`FoxIcons`, `FoxIconData`, `FoxSpace`, `FoxSize`, `FoxRadius`, `FoxDuration`).
- **Tokens come in with a prefix:** `import 'package:core_tokens/core_tokens.dart' as t;` since it also declares `FoxButton` and `FoxIcons`. A widget reads colours, sizes and type from `FoxTheme.of(context)`, never from `t.` directly, so the captain theme reaches it.
- **Widgets layer first** (§9.10): a simple component is built on `package:flutter/widgets.dart`; only a complex one (date picker, sheet) may wrap `material_ui` here. No Material `ThemeData`.
- **The lints** (`packages/fox_lints`) run here: no colour or length literals in `EdgeInsets*`, `SizedBox`, `TextStyle`, no `left`/`right`. Add a token instead of a literal.
- **A component exports its states:** `const <name>States = [...]` (and `<name>Variants` when it has variants) beside the widget. `apps/widgetbook/test/coverage_test.dart` fails until every state has a use case (R3), so add them in `apps/widgetbook/lib/catalogue.dart` in the same change.
- **States follow R10:** hover (a mouse) and pressed (touch) paint the component's own `-hover` and `-pressed` tokens; colours fade over `FoxDuration.base`, nothing moves; the focus ring shows for keyboard focus only. Disabled is `onPressed: null` and is not focusable; loading keeps the size and the name, stays focusable, ignores presses.
- **RTL and text scale:** directional insets and alignment only; a test pumps each component in RTL and at text scale 1.3 and 2.0 without overflow.
- **Goldens (R9)** live in `test/golden/`, tagged `golden`, skipped by plain `flutter test`; they run on Linux only: `pnpm test:golden` (Docker, `scripts/golden-docker.mjs`), `pnpm test:golden --update-goldens` after an intended change. They need the CoFo fonts in `.fonts/` (`pnpm fonts:fetch`); `loadFoxFonts` throws without them. Never update a baseline to make a failure pass without looking at `test/golden/failures/`. The run passes `--run-skipped`, which un-skips every test in the package, so never skip a test here with `skip:`.

## More

Behaviour, decisions and history: `docs/code/packages/core_ui.md`. Grep it for what you change; never read it whole.
