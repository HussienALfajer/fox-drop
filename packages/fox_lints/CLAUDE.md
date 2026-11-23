# packages/fox_lints

The design system's machine rules (architecture §9.5 R2, R5) as an analyzer plugin (`analysis_server_plugin`), run by `dart analyze` and the IDE: `no_color_literal`, `no_literal_spacing`, `no_material_import`, `no_physical_direction`.

## Rules

- **Declared once, in the root `analysis_options.yaml`:** the analyzer accepts plugins only at the workspace root, and a package's `analyzer: errors:` does not know a plugin's codes. So the rules run only in `enforcedPackages` (`lib/src/rules.dart`, named `<parent>/<folder>`); `materialPackages` may import Material. An app joins `enforcedPackages` in its screen slice, when its screens move to `core_ui`, and fixes what the rules find; a test pins both lists.
- **Pinned to analyzer 13** (`analysis_server_plugin` 0.3.18, `analyzer_testing` 0.3.2): the workspace's `test` 1.31.1 needs analyzer below 14. Move all three together.
- **A rule matches Flutter's own classes** (a library under `package:flutter/` or `dart:ui`), never a class of the same name elsewhere.
- **Tests** (`test/rules_test.dart`, `dart test`) are `AnalysisRuleTest`s over a stub `flutter` package; each rule gets a case that reports and one that passes. The offsets in `lint(offset, length)` count from the start of the test source.
- After a rule change, the first root `dart analyze` recompiles the plugin (about a minute).
