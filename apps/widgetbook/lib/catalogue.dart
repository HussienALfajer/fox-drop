import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

/// Every core_ui component with a use case per state (R3): the same names
/// as the web's stories and the goldens. Hover, focus and pressed are live
/// buttons: point, tab or press to see them, as on Storybook.
final List<WidgetbookNode> catalogue = [
  WidgetbookComponent(
    name: 'FoxButton',
    useCases: [
      for (final variant in FoxButtonVariant.values)
        for (final state in buttonStates)
          WidgetbookUseCase(
            name: '${variant.name} $state',
            builder: (context) => _Stage(
              child: FoxButton(
                label: 'اطلب الآن',
                variant: variant,
                loading: state == 'loading',
                onPressed: state == 'disabled' ? null : () {},
              ),
            ),
          ),
      for (final variant in FoxButtonVariant.values) ...[
        WidgetbookUseCase(
          name: '${variant.name} with icons',
          builder: (context) => _Stage(
            child: FoxButton(
              label: 'التالي',
              icon: FoxIcons.confirm,
              iconEnd: FoxIcons.back,
              variant: variant,
              onPressed: () {},
            ),
          ),
        ),
        WidgetbookUseCase(
          name: '${variant.name} icon only',
          builder: (context) => _Stage(
            child: FoxButton.icon(
              icon: FoxIcons.add,
              label: 'إضافة',
              variant: variant,
              onPressed: () {},
            ),
          ),
        ),
      ],
    ],
  ),
  WidgetbookComponent(
    name: 'FoxIcon',
    useCases: [
      for (final state in iconStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _Stage(child: _icons(state)),
        ),
    ],
  ),
];

Widget _icons(String state) {
  final size = switch (state) {
    'sm' => FoxIconSize.sm,
    'lg' => FoxIconSize.lg,
    _ => FoxIconSize.md,
  };
  final icons = state == 'mirrored'
      ? [
          for (final icon in FoxIcons.all.values)
            if (icon.mirror) icon,
        ]
      : FoxIcons.all.values;
  return Wrap(
    spacing: FoxSpace.sm,
    runSpacing: FoxSpace.sm,
    children: [
      for (final MapEntry(:key, :value) in FoxIcons.all.entries)
        if (icons.contains(value))
          FoxIcon(value, size: size, label: state == 'labelled' ? key : null),
    ],
  );
}

class _Stage extends StatelessWidget {
  const _Stage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(FoxSpace.lg),
    child: Center(child: child),
  );
}
