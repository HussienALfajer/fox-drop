/// The FOX DROP analyzer plugin (architecture §9.5, R2 and R5), run by
/// `dart analyze` for every package that lists it under `plugins:`.
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
    // Warning rules are on wherever the plugin is listed; a package turns
    // one off under `diagnostics:` (core_ui turns off no_material_import).
    registry
      ..registerWarningRule(NoColorLiteral())
      ..registerWarningRule(NoLiteralSpacing())
      ..registerWarningRule(NoMaterialImport())
      ..registerWarningRule(NoPhysicalDirection());
  }
}
