# packages/fox_lints

The design system's machine rules (architecture §9.5 R2, R5): `no_color_literal`, `no_literal_spacing`, `no_material_import`, `no_physical_direction`. The same rule classes (`foxRules()` in `lib/src/rules.dart`) run in two places:

- **The check:** `dart packages/fox_lints/tool/check.dart` from the workspace root, next to `dart analyze --fatal-infos --no-plugins`; exits 1 on a finding. It resolves only `enforcedPackages` (`lib/src/check.dart`, run by `bin/check.dart`), with the summaries of what they import cached in `<root>/.dart_tool/fox_lints/cache`. `tool/check.dart` compiles `bin/check.dart` to an executable there once per change to this package's `bin/` or `lib/`, `pubspec.lock` or the SDK (about 35 s), then runs it: about 2.5 s warm, 24 s with an empty cache. `dart run fox_lints:check` gives the same result in 15 s warm (JIT).
- **The editor:** the analyzer plugin (`lib/main.dart`, `analysis_server_plugin`), declared in the root `analysis_options.yaml`. The check skips it (`--no-plugins`): the plugin isolate resolves every file of the workspace again on every `dart analyze`, with no disk cache (`PluginServer` keeps a `NullByteStore`), whatever its rules do: 53 to 115 s against 20 s for the workspace, and 6 to 9 minutes when it recompiles.

## Rules

- **Declared once, in the root `analysis_options.yaml`:** the analyzer accepts plugins only at the workspace root, and a package's `analyzer: errors:` does not know a plugin's codes. So the rules run only in `enforcedPackages` (`lib/src/rules.dart`, named `<parent>/<folder>`); `materialPackages` may import Material. An app joins `enforcedPackages` in its screen slice, when its screens move to `core_ui`, and fixes what the rules find; a test pins both lists.
- **Pinned to analyzer 13** (`analysis_server_plugin` 0.3.18, `analyzer_testing` 0.3.2): the workspace's `test` 1.31.1 needs analyzer below 14. Move all three together. The check reaches analyzer internals (`src/`) the way `PluginServer` does, so it is checked again with every analyzer update.
- **A rule matches Flutter's own classes** (a library under `package:flutter/` or `dart:ui`), never a class of the same name elsewhere. So the check resolves the code; a syntax-only check could not tell.
- **Tests** (`dart test`): `test/rules_test.dart` holds `AnalysisRuleTest`s over a stub `flutter` package, each rule with a case that reports and one that passes (the offsets in `lint(offset, length)` count from the start of the test source); `test/check_test.dart` runs the check over a temporary workspace (every rule, a part file, an ignore comment, a package that is not enforced).
- After a rule change, the next root `dart analyze` with the plugin (the editor's) recompiles it, which took 6 to 9 minutes on 2026-11-25.
