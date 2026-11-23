import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../field/fox_field.dart';
import '../field/pick_box.dart';
import '../internal/fox_material_localizations.dart';
import '../internal/material_scope.dart';
import '../theme/fox_theme.dart';
import 'fox_date_field.dart';

/// A time of day, hour 0 to 23 and minute 0 to 59.
@immutable
final class FoxTimeOfDay {
  const FoxTimeOfDay(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  final int hour;
  final int minute;

  @override
  bool operator ==(Object other) =>
      other is FoxTimeOfDay && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => 'FoxTimeOfDay($hour:$minute)';
}

/// A time field (D.8): the pill shows the time as `3:05 م` (12-hour, «ص» and
/// «م», digits Western) or the [placeholder], with a clock icon at the start;
/// a tap opens `material_ui`'s time picker in its typed-in-boxes mode (AP
/// §4.7), themed from the tokens. A null [onChanged] disables it.
class FoxTimeField extends StatelessWidget {
  const FoxTimeField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.marker,
    this.hint,
    this.placeholder,
    this.error,
  });

  final FoxTimeOfDay? value;
  final ValueChanged<FoxTimeOfDay>? onChanged;
  final String? label;
  final String? marker;
  final String? hint;
  final String? placeholder;
  final String? error;

  Future<void> _pick(BuildContext context) async {
    final theme = FoxTheme.of(context);
    final direction = Directionality.of(context);
    final initial = value ?? const FoxTimeOfDay(12, 0);
    final picked = await m.showTimePicker(
      context: context,
      initialTime: m.TimeOfDay(hour: initial.hour, minute: initial.minute),
      initialEntryMode: m.TimePickerEntryMode.input,
      builder: (context, child) => pickerHost(theme, direction, child),
    );
    if (picked != null) {
      onChanged?.call(FoxTimeOfDay(picked.hour, picked.minute));
    }
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
          shown: value == null
              ? null
              : FoxMaterialLocalizations.time(value!.hour, value!.minute),
          placeholder: placeholder,
          label: label,
          description: error ?? hint,
          start: t.FoxIcons.clock,
          ltrValue: value != null,
          onTap: () => _pick(context),
        ),
      ),
    ),
  );
}
