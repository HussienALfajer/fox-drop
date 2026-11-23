import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../field/fox_field.dart';
import '../field/pick_box.dart';
import '../internal/fox_material_localizations.dart';
import '../internal/material_scope.dart';
import '../theme/fox_theme.dart';

/// The states every date and time field use case and golden shows (R3).
/// Hover and focus are live.
const dateFieldStates = [
  'default',
  'hover',
  'focus',
  'filled',
  'disabled',
  'invalid',
];

/// The date field's states, the same as [dateFieldStates].
const timeFieldStates = dateFieldStates;

/// Wraps a picker's route in the app's theme and direction and in the
/// Material scope: the route sits above the field, so it does not inherit
/// them. Not exported.
Widget pickerHost(FoxThemeData theme, TextDirection direction, Widget? child) =>
    FoxTheme(
      data: theme,
      child: Directionality(
        textDirection: direction,
        child: MaterialScope(child: child ?? const SizedBox.shrink()),
      ),
    );

/// A date field (D.8): the pill shows the date as `dd/mm/yyyy` (digits
/// Western) or the [placeholder], with a calendar icon at the start; a tap
/// opens `material_ui`'s date picker, themed from the tokens, with the Syriac
/// month names (كانون الثاني…كانون الأول), the week from Saturday and the dates
/// typed `dd/mm/yyyy` (AP §4.7). A null [onChanged] disables it.
class FoxDateField extends StatelessWidget {
  const FoxDateField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.label,
    this.marker,
    this.hint,
    this.placeholder,
    this.error,
  });

  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? label;
  final String? marker;
  final String? hint;
  final String? placeholder;
  final String? error;

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _pick(BuildContext context) async {
    final theme = FoxTheme.of(context);
    final direction = Directionality.of(context);
    final first = _day(firstDate);
    final last = _day(lastDate);
    var initial = _day(value ?? DateTime.now());
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;
    final picked = await m.showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      initialEntryMode: m.DatePickerEntryMode.calendar,
      builder: (context, child) => pickerHost(theme, direction, child),
    );
    if (picked != null) onChanged?.call(_day(picked));
  }

  @override
  Widget build(BuildContext context) => FoxField(
    label: label,
    marker: marker,
    hint: hint,
    error: error,
    enabled: onChanged != null,
    namesControl: false,
    // The picker needs Material localizations at the context that opens it.
    child: MaterialScope(
      child: Builder(
        builder: (context) => PickBox(
          enabled: onChanged != null,
          invalid: error != null,
          shown: value == null ? null : FoxMaterialLocalizations.date(value!),
          placeholder: placeholder,
          label: label,
          description: error ?? hint,
          start: t.FoxIcons.calendar,
          ltrValue: value != null,
          onTap: () => _pick(context),
        ),
      ),
    ),
  );
}
