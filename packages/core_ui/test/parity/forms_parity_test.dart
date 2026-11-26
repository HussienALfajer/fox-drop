import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';

import '../phone_harness.dart';
import 'parity.dart';

/// The forms and actions twins of their web stories (`pnpm parity Field
/// TextField …`, slice D.W3a). The `*-compact` and `*-comfortable` stories
/// have no case: the Flutter fields have one density. The phone field's
/// `open`, `invalid` and `switched` stories are typed or pressed by the web
/// story's play function; their Flutter look is the sheet and the error,
/// shown by `phonefield--invalid` with its message.
void main() {
  TextEditingController text(String value) =>
      TextEditingController(text: value);
  void noop<T>(T _) {}

  // Field: the wrapper around a plain input, as the web story draws it.
  const fieldLabel = 'الاسم';
  const fieldHint = 'كما يظهر في الهوية';
  const fieldPlaceholder = 'اكتب اسمك';
  for (final state in ['default', 'hover', 'focus']) {
    parityCase(
      'field--$state',
      () => const FoxTextField(
        label: fieldLabel,
        hint: fieldHint,
        placeholder: fieldPlaceholder,
      ),
    );
  }
  parityCase(
    'field--filled',
    () => FoxTextField(
      controller: text('محمد الأحمد'),
      label: fieldLabel,
      marker: '(اختياري)',
      hint: fieldHint,
      placeholder: fieldPlaceholder,
    ),
  );
  parityCase(
    'field--invalid',
    () => FoxTextField(
      controller: text('محمد'),
      label: fieldLabel,
      hint: fieldHint,
      error: 'اكتب الاسم كما في الهوية',
      placeholder: fieldPlaceholder,
    ),
  );
  parityCase(
    'field--disabled',
    () => const FoxTextField(
      label: fieldLabel,
      hint: fieldHint,
      placeholder: fieldPlaceholder,
      enabled: false,
    ),
  );

  // TextField.
  parityCase(
    'textfield--default',
    () => const FoxTextField(
      label: fieldLabel,
      hint: fieldHint,
      placeholder: fieldPlaceholder,
    ),
  );
  for (final state in ['hover', 'focus']) {
    parityCase(
      'textfield--$state',
      () =>
          const FoxTextField(label: fieldLabel, placeholder: fieldPlaceholder),
    );
  }
  parityCase(
    'textfield--filled',
    () => FoxTextField(
      controller: text('محمد الأحمد'),
      label: fieldLabel,
      placeholder: fieldPlaceholder,
    ),
  );
  parityCase(
    'textfield--invalid',
    () => FoxTextField(
      controller: text('محمد'),
      label: fieldLabel,
      error: 'اكتب الاسم كما في الهوية',
      placeholder: fieldPlaceholder,
    ),
  );
  parityCase(
    'textfield--disabled',
    () => const FoxTextField(
      label: fieldLabel,
      placeholder: fieldPlaceholder,
      enabled: false,
    ),
  );
  parityCase(
    'textfield--optional',
    () => const FoxTextField(
      label: 'الكنية',
      marker: '(اختياري)',
      placeholder: fieldPlaceholder,
    ),
  );

  // TextArea.
  const areaLabel = 'ملاحظات للمطعم';
  const areaPlaceholder = 'اكتب ملاحظتك';
  parityCase(
    'textarea--default',
    () => const FoxTextArea(
      label: areaLabel,
      hint: 'مثلاً: بدون بصل',
      placeholder: areaPlaceholder,
    ),
  );
  for (final state in ['hover', 'focus']) {
    parityCase(
      'textarea--$state',
      () => const FoxTextArea(label: areaLabel, placeholder: areaPlaceholder),
    );
  }
  parityCase(
    'textarea--filled',
    () => FoxTextArea(
      controller: text('من فضلكم بدون بصل، وزيادة صلصة الثوم.\nشكراً لكم.'),
      label: areaLabel,
      placeholder: areaPlaceholder,
    ),
  );
  parityCase(
    'textarea--invalid',
    () => FoxTextArea(
      controller: text('ملاحظة'),
      label: areaLabel,
      error: 'الملاحظة أقصر من اللازم',
      placeholder: areaPlaceholder,
    ),
  );
  parityCase(
    'textarea--disabled',
    () => const FoxTextArea(
      label: areaLabel,
      placeholder: areaPlaceholder,
      enabled: false,
    ),
  );
  parityCase(
    'textarea--counter',
    () => FoxTextArea(
      controller: text('من فضلكم بدون بصل'),
      label: areaLabel,
      marker: '(اختياري)',
      maxLength: 200,
      placeholder: areaPlaceholder,
    ),
  );
  parityCase(
    'textarea--growing',
    () => FoxTextArea(
      controller: text('سطر أول\nسطر ثانٍ\nسطر ثالث\nسطر رابع\nسطر خامس'),
      label: areaLabel,
      placeholder: areaPlaceholder,
    ),
  );

  // SearchField.
  const searchPlaceholder = 'ابحث عن مطعم أو وجبة';
  for (final state in ['default', 'hover', 'focus']) {
    parityCase(
      'searchfield--$state',
      () => const FoxSearchField(
        placeholder: searchPlaceholder,
        clearLabel: 'مسح',
      ),
    );
  }
  parityCase(
    'searchfield--filled',
    () => FoxSearchField(
      controller: text('شاورما'),
      placeholder: searchPlaceholder,
      clearLabel: 'مسح',
    ),
  );
  parityCase(
    'searchfield--loading',
    () => FoxSearchField(
      controller: text('شاورما'),
      placeholder: searchPlaceholder,
      clearLabel: 'مسح',
      loading: true,
    ),
  );
  parityCase(
    'searchfield--disabled',
    () => const FoxSearchField(
      placeholder: searchPlaceholder,
      clearLabel: 'مسح',
      enabled: false,
    ),
  );

  // PhoneField.
  Widget phone({
    String country = 'SY',
    String value = '',
    String? hint,
    String? error,
    bool busy = false,
    bool enabled = true,
  }) => FoxPhoneField(
    controller: text(value),
    country: country,
    countries: testCountries,
    strings: testPhoneStrings,
    onChanged: noop,
    onCountryChanged: noop,
    label: 'رقم الهاتف',
    placeholder: '9xx xxx xxx',
    hint: hint,
    error: error,
    busy: busy,
    enabled: enabled,
  );
  parityCase(
    'phonefield--default',
    () => phone(hint: 'سنرسل الرمز إلى واتساب'),
  );
  parityCase('phonefield--hover', phone);
  parityCase('phonefield--focus', phone);
  parityCase('phonefield--filled', () => phone(value: '944123456'));
  parityCase(
    'phonefield--valid',
    () => phone(country: 'TR', value: '5321234567'),
  );
  parityCase(
    'phonefield--invalid',
    () => phone(value: '094412345', error: 'ينقص رقم واحد.'),
  );
  parityCase('phonefield--busy', () => phone(value: '944123456', busy: true));
  parityCase('phonefield--disabled', () => phone(enabled: false));

  // CodeField.
  Widget code({String value = '', String? error, bool done = false}) =>
      FoxCodeField(
        controller: text(value),
        label: 'رمز التحقق',
        hint: 'أرسلنا الرمز إلى واتساب',
        error: error,
        done: done,
        onCompleted: noop,
      );
  parityCase('codefield--default', code);
  parityCase('codefield--focus', code);
  parityCase('codefield--typing', () => code(value: '482'));
  parityCase(
    'codefield--invalid',
    () => code(value: '482913', error: 'الرمز غير صحيح'),
  );
  parityCase('codefield--done', () => code(value: '482913', done: true));
  parityCase(
    'codefield--disabled',
    () => FoxCodeField(
      label: 'رمز التحقق',
      hint: 'أرسلنا الرمز إلى واتساب',
      enabled: false,
      onCompleted: noop,
    ),
  );

  // Select.
  const genders = [
    FoxSelectOption(value: 'male', label: 'ذكر'),
    FoxSelectOption(value: 'female', label: 'أنثى'),
  ];
  Widget select({
    String? value,
    String? hint,
    String? error,
    bool enabled = true,
    bool open = false,
  }) => FoxSelect<String>(
    options: genders,
    value: value,
    onChanged: enabled ? noop : null,
    label: 'الجنس',
    placeholder: 'اختر',
    hint: hint,
    error: error,
    initiallyOpen: open,
  );
  parityCase('select--default', () => select(hint: 'يظهر في ملفك الشخصي'));
  parityCase('select--hover', select);
  parityCase('select--focus', select);
  parityCase('select--open', () => select(open: true));
  parityCase('select--filled', () => select(value: 'female'));
  parityCase('select--invalid', () => select(error: 'اختر الجنس'));
  parityCase('select--disabled', () => select(enabled: false));

  // Checkbox.
  Widget checkbox({
    bool? value = false,
    String label = 'أوافق على الشروط',
    bool invalid = false,
    bool enabled = true,
  }) => FoxCheckbox(
    value: value,
    onChanged: enabled ? noop : null,
    label: label,
    invalid: invalid,
  );
  for (final state in ['default', 'hover', 'focus', 'pressed']) {
    parityCase('checkbox--$state', checkbox);
  }
  parityCase('checkbox--checked', () => checkbox(value: true));
  parityCase(
    'checkbox--mixed',
    () => checkbox(value: null, label: 'كل الإضافات'),
  );
  parityCase('checkbox--invalid', () => checkbox(invalid: true));
  parityCase('checkbox--disabled', () => checkbox(enabled: false));
  parityCase(
    'checkbox--disabled-checked',
    () => checkbox(value: true, enabled: false),
  );

  // RadioGroup.
  Widget radios({String? value, String? error, bool enabled = true}) =>
      FoxRadioGroup(
        label: 'طريقة الدفع',
        error: error,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (key, label) in [
              ('cash', 'نقداً عند الاستلام'),
              ('wallet', 'المحفظة'),
            ])
              FoxRadio<String>(
                value: key,
                groupValue: value,
                onChanged: enabled ? noop : null,
                label: label,
                invalid: error != null,
              ),
          ],
        ),
      );
  for (final state in ['default', 'hover', 'focus', 'pressed']) {
    parityCase('radiogroup--$state', radios);
  }
  parityCase('radiogroup--selected', () => radios(value: 'cash'));
  parityCase('radiogroup--invalid', () => radios(error: 'اختر طريقة الدفع'));
  parityCase(
    'radiogroup--disabled',
    () => radios(value: 'cash', enabled: false),
  );

  // Switch.
  Widget toggle({bool value = false, bool enabled = true}) => FoxSwitch(
    value: value,
    onChanged: enabled ? noop : null,
    label: 'إشعارات الطلبات',
  );
  for (final state in ['default', 'hover', 'focus', 'pressed']) {
    parityCase('switch--$state', toggle);
  }
  parityCase('switch--on', () => toggle(value: true));
  parityCase('switch--disabled', () => toggle(enabled: false));
  parityCase('switch--disabled-on', () => toggle(value: true, enabled: false));

  // QuantityStepper.
  Widget stepper({
    int value = 2,
    int? max,
    bool enabled = true,
    bool deletes = false,
  }) => FoxQuantityStepper(
    value: value,
    onChanged: noop,
    label: 'الكمية',
    increaseLabel: 'زيادة',
    decreaseLabel: 'تقليل',
    deleteLabel: 'حذف',
    onDelete: deletes ? () {} : null,
    max: max,
    enabled: enabled,
  );
  parityCase('quantitystepper--default', () => stepper(deletes: true));
  for (final state in ['hover', 'focus', 'pressed']) {
    parityCase('quantitystepper--$state', stepper);
  }
  parityCase(
    'quantitystepper--minimum',
    () => stepper(value: 1, deletes: true),
  );
  parityCase('quantitystepper--maximum', () => stepper(value: 5, max: 5));
  parityCase('quantitystepper--disabled', () => stepper(enabled: false));

  // TextLink.
  for (final state in ['default', 'hover', 'focus', 'pressed']) {
    parityCase(
      'textlink--$state',
      () => FoxTextLink(label: 'تعديل الرقم', onPressed: () {}),
    );
  }
}
