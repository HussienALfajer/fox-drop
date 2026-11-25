import 'package:core_l10n/core_l10n.dart' show foxCountryNames;
import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

import 'catalogue.dart' show phoneStrings;

/// The components of D.11's screens (slice D.11b), a use case per state (R3),
/// drawn from the approved components sheet of the customer screens canvas.
final List<WidgetbookNode> frameCatalogue = [
  _component('FoxDropLoader', dropLoaderStates, _loader),
  _component('FoxCountrySheet', countrySheetStates, _countries),
];

// The sheet drawn inline, as a panel (D.10).
Widget _countries(String state) => SizedBox(
  height: FoxSize.dialog,
  child: FoxCountrySheet(
    countries: foxCountryNames,
    selected: 'SY',
    strings: phoneStrings.sheet,
    lastUsed: state == 'lastUsed' ? 'DE' : null,
    initialQuery: switch (state) {
      'search' => 'ألمان',
      'empty' => 'zzzz',
      _ => '',
    },
    onSelected: (_) {},
  ),
);

WidgetbookComponent _component(
  String name,
  List<String> states,
  Widget Function(String state) build,
) => WidgetbookComponent(
  name: name,
  useCases: [
    for (final state in states)
      WidgetbookUseCase(
        name: state,
        builder: (context) => Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(FoxSpace.lg),
            child: build(state),
          ),
        ),
      ),
  ],
);

Widget _loader(String state) => switch (state) {
  'onPrimary' => const _OnPrimary(child: FoxDropLoader(onPrimary: true)),
  'small' => const FoxDropLoader(size: FoxDropLoaderSize.sm),
  'large' => const FoxDropLoader(size: FoxDropLoaderSize.lg),
  'labelled' => const FoxDropLoader(
    size: FoxDropLoaderSize.lg,
    label: 'جارٍ التحميل',
  ),
  _ => const FoxDropLoader(),
};

/// The orange ground of the primary button, under the loader on orange.
class _OnPrimary extends StatelessWidget {
  const _OnPrimary({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: FoxTheme.of(context).colors.primary,
      borderRadius: BorderRadius.circular(FoxRadius.md),
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.all(FoxSpace.sm),
      child: child,
    ),
  );
}
