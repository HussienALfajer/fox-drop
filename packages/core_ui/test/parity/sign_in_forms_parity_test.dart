import 'package:core_ui/core_ui.dart';

import '../phone_harness.dart';
import 'parity.dart';

/// The twins of the date, time, country list and code preview web stories
/// (`pnpm parity DateField TimeField CountrySheet CodePreview`, slice D.W4a).
/// `datefield--open` has no case: the Flutter calendar is a dialog route,
/// which lands outside the frame. The web country list shows every region;
/// the Flutter case shows the test regions (Iceland, Germany, Turkey, Syria).
void main() {
  void noop<T>(T _) {}
  final first = DateTime(2027);
  final last = DateTime(2027, 12, 31);

  // DateField.
  const dateLabel = 'تاريخ الميلاد';
  const datePlaceholder = 'اختر التاريخ';
  for (final state in ['default', 'hover', 'focus']) {
    parityCase(
      'datefield--$state',
      () => FoxDateField(
        value: null,
        onChanged: noop,
        firstDate: first,
        lastDate: last,
        label: dateLabel,
        placeholder: datePlaceholder,
        hint: state == 'default' ? 'لن يظهر لغيرك' : null,
      ),
    );
  }
  parityCase(
    'datefield--filled',
    () => FoxDateField(
      value: DateTime(2027, 3, 5),
      onChanged: noop,
      firstDate: first,
      lastDate: last,
      label: dateLabel,
    ),
  );
  parityCase(
    'datefield--invalid',
    () => FoxDateField(
      value: null,
      onChanged: noop,
      firstDate: first,
      lastDate: last,
      label: dateLabel,
      placeholder: datePlaceholder,
      error: 'اختر تاريخاً صحيحاً',
    ),
  );
  parityCase(
    'datefield--disabled',
    () => FoxDateField(
      value: DateTime(2027, 3, 5),
      onChanged: null,
      firstDate: first,
      lastDate: last,
      label: dateLabel,
    ),
  );

  // TimeField.
  const timeLabel = 'وقت الاستلام';
  for (final state in ['default', 'hover', 'focus']) {
    parityCase(
      'timefield--$state',
      () => FoxTimeField(
        value: null,
        onChanged: noop,
        label: timeLabel,
        hint: state == 'default' ? 'بين 9 ص و11 م' : null,
      ),
    );
  }
  parityCase(
    'timefield--filled',
    () => FoxTimeField(
      value: const FoxTimeOfDay(15, 5),
      onChanged: noop,
      label: timeLabel,
    ),
  );
  parityCase(
    'timefield--invalid',
    () => FoxTimeField(
      value: const FoxTimeOfDay(3, 0),
      onChanged: noop,
      label: timeLabel,
      error: 'المطعم مغلق في هذا الوقت',
    ),
  );
  parityCase(
    'timefield--disabled',
    () => const FoxTimeField(
      value: FoxTimeOfDay(15, 5),
      onChanged: null,
      label: timeLabel,
    ),
  );

  // CountrySheet.
  FoxCountrySheet sheet({String? lastUsed, String query = ''}) =>
      FoxCountrySheet(
        countries: testCountries,
        selected: 'SY',
        strings: testPhoneStrings.sheet,
        lastUsed: lastUsed,
        initialQuery: query,
        onSelected: noop,
      );
  parityCase('countrysheet--default', sheet);
  parityCase('countrysheet--last-used', () => sheet(lastUsed: 'DE'));
  parityCase('countrysheet--search', () => sheet(query: 'ألمان'));
  parityCase('countrysheet--empty', () => sheet(query: 'zzzz'));

  // CodePreview.
  FoxCodePreview preview({bool compact = false}) => FoxCodePreview(
    sender: 'FOX DROP',
    message: 'رمز الدخول إلى FOX DROP:',
    time: 'الآن · واتساب',
    semanticLabel: 'ستصلك رسالة على واتساب من FOX DROP فيها رمز الدخول',
    compact: compact,
  );
  parityCase('codepreview--full', preview);
  parityCase('codepreview--compact', () => preview(compact: true));
}
