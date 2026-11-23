/// The FOX DROP analyzer plugin (architecture §9.5, R2 and R5), run by
/// `dart analyze`; declared in the workspace root's analysis_options.yaml.
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
    // Each rule checks only `enforcedPackages`; `materialPackages` may
    // import Material (src/rules.dart).
    registry
      ..registerWarningRule(NoColorLiteral())
      ..registerWarningRule(NoLiteralSpacing())
      ..registerWarningRule(NoMaterialImport())
      ..registerWarningRule(NoPhysicalDirection());
  }
}
