# apps/widgetbook

The `core_ui` catalogue (architecture §9.5 R3, §9.9) as a Windows app: every state of every component, RTL Arabic, the phone and captain themes, text scale 1 to 2. Empty since D.R1 (2026-11-27, T16): each twin's use cases return with it, and the coverage test accepts zero widgets.

## Rules

- **Run:** `pnpm fonts:fetch` once (CoFo in `.fonts/`; `main` calls `loadFoxFonts` and stops without it), then `flutter run -d windows` in this folder.
- **One use case per state:** `lib/catalogue.dart` names them `<variant> <state>` (or `<state>`) from the component's exported `*States` and `*Variants`. `test/coverage_test.dart` scans `packages/core_ui/lib/src` for `Fox*` widgets and fails when one has no entry in its `_states` map or a state has no use case, and builds every use case on both themes.
- Material is only widgetbook's own shell (`Widgetbook.material`); use cases show `core_ui` widgets only, and the `fox_lints` rules run here.
