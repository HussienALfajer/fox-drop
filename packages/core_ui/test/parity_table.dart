import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';

/// The widget of each state the component registry measures, keyed
/// `<component>/<state>` as `packages/design-tokens/components.json` names it
/// (D.P2). `parity_test.dart` pumps each, performs its `act` (hover, press,
/// focus) and measures it; a state the web alone has is not here.
final Map<String, Widget Function()> parityStates = {
  for (final variant in FoxButtonVariant.values) ...{
    for (final state in ['default', 'hover', 'pressed'])
      'Button/${variant.name}-$state': () =>
          FoxButton(label: 'اطلب الآن', variant: variant, onPressed: () {}),
    'Button/${variant.name}-disabled': () =>
        FoxButton(label: 'اطلب الآن', variant: variant, onPressed: null),
  },
  'Button/with-icon-start': () =>
      FoxButton(label: 'أضف إلى السلة', icon: FoxIcons.cart, onPressed: () {}),

  for (final state in ['default', 'hover', 'focus'])
    'TextField/$state': () =>
        const FoxTextField(label: 'الاسم', placeholder: 'اكتب اسمك'),
  'TextField/invalid': () =>
      const FoxTextField(label: 'الاسم', error: 'اكتب الاسم كما في الهوية'),
  'TextField/disabled': () => const FoxTextField(
    label: 'الاسم',
    placeholder: 'اكتب اسمك',
    enabled: false,
  ),

  for (final state in ['default', 'hover', 'focus'])
    'TextArea/$state': () =>
        const FoxTextArea(label: 'ملاحظات للمطعم', placeholder: 'اكتب ملاحظتك'),
  'TextArea/invalid': () => const FoxTextArea(
    label: 'ملاحظات للمطعم',
    error: 'الملاحظة أقصر من اللازم',
  ),
  'TextArea/disabled': () => const FoxTextArea(
    label: 'ملاحظات للمطعم',
    placeholder: 'اكتب ملاحظتك',
    enabled: false,
  ),

  for (final state in ['default', 'hover', 'focus'])
    'SearchField/$state': () => const FoxSearchField(
      placeholder: 'ابحث عن مطعم أو وجبة',
      clearLabel: 'مسح',
    ),
  'SearchField/disabled': () => const FoxSearchField(
    placeholder: 'ابحث عن مطعم أو وجبة',
    clearLabel: 'مسح',
    enabled: false,
  ),

  for (final state in ['default', 'hover', 'pressed'])
    'Checkbox/$state': () =>
        FoxCheckbox(value: false, label: 'أوافق على الشروط', onChanged: (_) {}),
  'Checkbox/checked': () =>
      FoxCheckbox(value: true, label: 'أوافق على الشروط', onChanged: (_) {}),
  'Checkbox/invalid': () => FoxCheckbox(
    value: false,
    label: 'أوافق على الشروط',
    invalid: true,
    onChanged: (_) {},
  ),

  for (final state in ['default', 'hover', 'pressed'])
    'Switch/$state': () =>
        FoxSwitch(value: false, label: 'إشعارات الطلبات', onChanged: (_) {}),
  'Switch/on': () =>
      FoxSwitch(value: true, label: 'إشعارات الطلبات', onChanged: (_) {}),
  'Switch/disabled-on': () =>
      const FoxSwitch(value: true, label: 'إشعارات الطلبات', onChanged: null),
  'Checkbox/disabled': () => const FoxCheckbox(
    value: false,
    label: 'أوافق على الشروط',
    onChanged: null,
  ),
  'Checkbox/disabled-checked': () => const FoxCheckbox(
    value: true,
    label: 'أوافق على الشروط',
    onChanged: null,
  ),
  'Switch/disabled': () =>
      const FoxSwitch(value: false, label: 'إشعارات الطلبات', onChanged: null),
};
