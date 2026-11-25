/// The FOX DROP analyzer plugin (architecture §9.5, R2 and R5) for the editor;
/// declared in the workspace root's analysis_options.yaml. The check runs the
/// same rules with `dart run fox_lints:check` (bin/check.dart).
library;

import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/rules.dart';

final plugin = FoxLintsPlugin();

class FoxLintsPlugin extends Plugin {
  @override
  String get name => 'fox_lints';

  @override
  void register(PluginRegistry registry) {
    // The rules of `dart run fox_lints:check` too. Each checks only
    // `enforcedPackages`; `materialPackages` may import Material.
    foxRules().forEach(registry.registerWarningRule);
  }
}
