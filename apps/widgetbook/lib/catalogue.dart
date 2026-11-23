import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

import 'data_catalogue.dart';

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
  WidgetbookComponent(
    name: 'FoxField',
    useCases: [
      for (final state in fieldStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_wrapper(state)),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxTextField',
    useCases: [
      for (final state in textFieldStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_textField(state)),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxTextArea',
    useCases: [
      for (final state in textAreaStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_textArea(state)),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxSearchField',
    useCases: [
      for (final state in searchFieldStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_search(state)),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxPhoneField',
    useCases: [
      for (final state in phoneFieldStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_phone(state), tall: state == 'open'),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxCodeField',
    useCases: [
      for (final state in codeFieldStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_code(state)),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxSelect',
    useCases: [
      for (final state in selectStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_select(state), tall: state == 'open'),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxCheckbox',
    useCases: [
      for (final value in checkboxValues)
        for (final state in checkboxStates)
          WidgetbookUseCase(
            name: '$value $state',
            builder: (context) => _form(_checkbox(value, state)),
          ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxRadio',
    useCases: [
      for (final value in radioValues)
        for (final state in radioStates)
          WidgetbookUseCase(
            name: '$value $state',
            builder: (context) => _form(_radio(value, state)),
          ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxRadioGroup',
    useCases: [
      for (final state in radioGroupStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_radioGroup(state)),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxSwitch',
    useCases: [
      for (final value in switchValues)
        for (final state in switchStates)
          WidgetbookUseCase(
            name: '$value $state',
            builder: (context) => _form(_switch(value, state)),
          ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxQuantityStepper',
    useCases: [
      for (final state in quantityStepperStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_stepper(state)),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxDateField',
    useCases: [
      for (final state in dateFieldStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_date(state)),
        ),
    ],
  ),
  WidgetbookComponent(
    name: 'FoxTimeField',
    useCases: [
      for (final state in timeFieldStates)
        WidgetbookUseCase(
          name: state,
          builder: (context) => _form(_time(state)),
        ),
    ],
  ),
  ...dataCatalogue,
];

const _countryNames = {
  FoxPhoneCountry.syria: 'سوريا',
  FoxPhoneCountry.turkey: 'تركيا',
};

/// What the field use cases type, show and say; review copy only.
const _name = 'محمد الأحمد';
const _nameError = 'اكتب الاسم كما في الهوية';

Widget _wrapper(String state) => FoxField(
  label: 'اسم الشارع',
  marker: state == 'optional' ? '(اختياري)' : null,
  hint: state == 'hint' ? 'مثال: شارع الكفين' : null,
  error: state == 'invalid' ? 'الاسم قصير جدًا' : null,
  enabled: state != 'disabled',
  child: const SizedBox(height: FoxSize.touchTarget),
);

Widget _textField(String state) => _Typed(
  text: state == 'filled' || state == 'invalid' ? _name : '',
  focus: state == 'focus',
  builder: (controller, node) => FoxTextField(
    controller: controller,
    focusNode: node,
    label: 'الاسم الكامل',
    hint: 'كما يظهر للمطعم والكابتن',
    placeholder: 'اكتب اسمك',
    error: state == 'invalid' ? _nameError : null,
    enabled: state != 'disabled',
  ),
);

Widget _textArea(String state) => _Typed(
  text: state == 'filled' || state == 'invalid'
      ? 'بدون بصل، والصلصة جانبًا'
      : '',
  focus: state == 'focus',
  builder: (controller, node) => FoxTextArea(
    controller: controller,
    focusNode: node,
    label: 'ملاحظات الطلب',
    marker: '(اختياري)',
    placeholder: 'مثلًا: بدون بصل، والصلصة جانبًا',
    maxLength: 200,
    error: state == 'invalid' ? 'النص أطول من الحد المسموح' : null,
    enabled: state != 'disabled',
  ),
);

Widget _search(String state) => _Typed(
  text: state == 'typed' || state == 'loading' ? 'شاورما' : '',
  focus: state == 'focus' || state == 'typed' || state == 'loading',
  builder: (controller, node) => FoxSearchField(
    controller: controller,
    focusNode: node,
    placeholder: 'ابحث عن طبق أو مطعم',
    clearLabel: 'مسح',
    loadingLabel: 'جارٍ البحث',
    loading: state == 'loading',
    enabled: state != 'disabled',
  ),
);

Widget _phone(String state) => _Typed(
  text: state == 'filled' || state == 'invalid' ? '0912345678' : '',
  focus: state == 'focus',
  builder: (controller, node) => _Live<FoxPhoneCountry>(
    FoxPhoneCountry.syria,
    (country, set) => FoxPhoneField(
      controller: controller,
      focusNode: node,
      country: country,
      onCountryChanged: set,
      onChanged: (_) {},
      countryNames: _countryNames,
      countryLabel: 'رمز الدولة',
      label: 'رقم الهاتف',
      hint: 'سنرسل لك رمز التحقق',
      placeholder: '9xx xxx xxx',
      error: state == 'invalid' ? 'رقم الهاتف غير صالح' : null,
      enabled: state != 'disabled',
      initiallyOpen: state == 'open',
    ),
  ),
);

Widget _code(String state) => _Typed(
  text: switch (state) {
    'typing' => '482',
    'invalid' => '482915',
    'done' => '482915',
    _ => '',
  },
  focus: state == 'focus' || state == 'typing',
  builder: (controller, node) => FoxCodeField(
    controller: controller,
    focusNode: node,
    label: 'رمز التحقق',
    hint: 'أرسلناه إلى هاتفك',
    error: state == 'invalid' ? 'الرمز غير صحيح' : null,
    done: state == 'done',
    onCompleted: (_) {},
  ),
);

Widget _select(String state) => _Live<int?>(
  state == 'filled' || state == 'invalid' ? 2 : null,
  (value, set) => FoxSelect<int>(
    label: 'الحي',
    placeholder: 'اختر الحي',
    hint: 'نوصل إلى أحياء اعزاز',
    error: state == 'invalid' ? 'اختر حيًّا' : null,
    value: value,
    initiallyOpen: state == 'open',
    onChanged: state == 'disabled' ? null : set,
    options: const [
      FoxSelectOption(value: 1, label: 'الكفين'),
      FoxSelectOption(value: 2, label: 'المركز'),
      FoxSelectOption(value: 3, label: 'الجامعة'),
    ],
  ),
);

Widget _checkbox(String value, String state) => _Live<bool?>(
  switch (value) {
    'checked' => true,
    'mixed' => null,
    _ => false,
  },
  (v, set) => FoxCheckbox(
    value: v,
    label: 'أوافق على الشروط',
    invalid: state == 'invalid',
    onChanged: state == 'disabled' ? null : set,
  ),
);

Widget _radio(String value, String state) => _Live<String>(
  value == 'selected' ? 'cash' : 'card',
  (group, set) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FoxRadio<String>(
        value: 'cash',
        groupValue: group,
        label: 'الدفع نقدًا',
        invalid: state == 'invalid',
        onChanged: state == 'disabled' ? null : set,
      ),
    ],
  ),
);

/// Three radios in a group: Tab to one, then the arrows move and select.
Widget _radioGroup(String state) => _Live<String?>(
  // Invalid is the one with nothing chosen yet.
  state == 'invalid' ? null : 'cash',
  (group, set) => FoxRadioGroup(
    label: 'طريقة الدفع',
    hint: 'اختر واحدة',
    error: state == 'invalid' ? 'اختر طريقة الدفع' : null,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (value, label) in const [
          ('cash', 'الدفع نقدًا'),
          ('card', 'بطاقة'),
          ('wallet', 'المحفظة'),
        ])
          FoxRadio<String>(
            value: value,
            groupValue: group,
            label: label,
            onChanged: state == 'disabled' ? null : set,
          ),
      ],
    ),
  ),
);

Widget _switch(String value, String state) => _Live<bool>(
  value == 'on',
  (on, set) => FoxSwitch(
    value: on,
    label: 'الإشعارات',
    onChanged: state == 'disabled' ? null : set,
  ),
);

Widget _stepper(String state) => _Live<int>(
  switch (state) {
    'min' => 1,
    'max' => 5,
    _ => 2,
  },
  (count, set) => FoxQuantityStepper(
    value: count,
    min: 1,
    max: 5,
    label: 'الكمية',
    increaseLabel: 'زيادة',
    decreaseLabel: 'إنقاص',
    deleteLabel: 'حذف',
    enabled: state != 'disabled',
    onChanged: set,
    onDelete: () {},
  ),
);

Widget _date(String state) => _Live<DateTime?>(
  state == 'filled' || state == 'invalid' ? DateTime(2026, 3, 5) : null,
  (value, set) => FoxDateField(
    value: value,
    firstDate: DateTime(2026),
    lastDate: DateTime(2027),
    label: 'تاريخ التوصيل',
    placeholder: 'اختر التاريخ',
    error: state == 'invalid' ? 'اختر يومًا قادمًا' : null,
    onChanged: state == 'disabled' ? null : set,
  ),
);

Widget _time(String state) => _Live<FoxTimeOfDay?>(
  state == 'filled' || state == 'invalid' ? const FoxTimeOfDay(15, 5) : null,
  (value, set) => FoxTimeField(
    value: value,
    label: 'وقت التوصيل',
    placeholder: 'اختر الوقت',
    error: state == 'invalid' ? 'اختر وقتًا بعد الآن' : null,
    onChanged: state == 'disabled' ? null : set,
  ),
);

const double _formWidth = 340;
const double _menuRoom = 320;

/// A form column 340 wide; [tall] leaves room for an open menu.
Widget _form(Widget child, {bool tall = false}) => Padding(
  padding: const EdgeInsets.all(FoxSpace.lg),
  child: Align(
    alignment: AlignmentDirectional.topCenter,
    child: SizedBox(
      width: _formWidth,
      height: tall ? _menuRoom : null,
      child: child,
    ),
  ),
);

/// Keeps the value a use case edits, so a control answers a tap.
class _Live<T> extends StatefulWidget {
  const _Live(this.initial, this.builder);

  final T initial;
  final Widget Function(T value, ValueChanged<T> set) builder;

  @override
  State<_Live<T>> createState() => _LiveState<T>();
}

class _LiveState<T> extends State<_Live<T>> {
  late T _value = widget.initial;

  @override
  Widget build(BuildContext context) =>
      widget.builder(_value, (v) => setState(() => _value = v));
}

/// Owns a controller holding [text] and a focus node, taken at once when
/// [focus] (a state that shows the focused field).
class _Typed extends StatefulWidget {
  const _Typed({this.text = '', this.focus = false, required this.builder});

  final String text;
  final bool focus;
  final Widget Function(TextEditingController controller, FocusNode node)
  builder;

  @override
  State<_Typed> createState() => _TypedState();
}

class _TypedState extends State<_Typed> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.text,
  );
  final FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.focus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _node.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(_controller, _node);
}

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
