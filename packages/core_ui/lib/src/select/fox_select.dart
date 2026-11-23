import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../field/fox_field.dart';
import '../field/pick_box.dart';
import '../internal/anchored_menu.dart';

/// The states every select use case and golden shows (R3). `open` shows the
/// menu under the field; hover and focus are live.
const selectStates = [
  'default',
  'hover',
  'focus',
  'open',
  'filled',
  'disabled',
  'invalid',
];

/// One choice of a [FoxSelect].
@immutable
final class FoxSelectOption<T> {
  const FoxSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// A select (D.8): the pill shows the chosen label (or the [placeholder])
/// and a chevron; a tap, Enter or Space opens a menu under it
/// with the options, the chosen one marked. The arrow keys move, Enter picks,
/// Escape closes and returns focus to the field. D.10 may open a bottom sheet
/// instead, behind this API. A null [onChanged] disables it.
class FoxSelect<T> extends StatefulWidget {
  const FoxSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.label,
    this.marker,
    this.hint,
    this.placeholder,
    this.error,
    this.initiallyOpen = false,
  });

  final List<FoxSelectOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? label;
  final String? marker;
  final String? hint;
  final String? placeholder;
  final String? error;

  /// Opens the menu as it appears (for the catalogue and the goldens).
  final bool initiallyOpen;

  @override
  State<FoxSelect<T>> createState() => _FoxSelectState<T>();
}

class _FoxSelectState<T> extends State<FoxSelect<T>> {
  final OverlayPortalController _menu = OverlayPortalController();
  final FocusNode _node = FocusNode(debugLabel: 'FoxSelect');
  bool _open = false;

  bool get _enabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    if (widget.initiallyOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _show());
    }
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  void _show() {
    if (!mounted || !_enabled) return;
    _menu.show();
    setState(() => _open = true);
  }

  void _close() {
    if (!_open) return;
    _menu.hide();
    setState(() => _open = false);
    _node.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final chosen = widget.options
        .where((o) => o.value == widget.value)
        .firstOrNull;
    return FoxField(
      label: widget.label,
      marker: widget.marker,
      hint: widget.hint,
      error: widget.error,
      enabled: _enabled,
      namesControl: false,
      child: AnchoredMenu<T>(
        controller: _menu,
        items: [
          for (final o in widget.options)
            MenuItem(value: o.value, label: o.label),
        ],
        selected: widget.value,
        label: widget.label,
        onSelected: (value) {
          _close();
          widget.onChanged?.call(value);
        },
        onClosed: _close,
        child: PickBox(
          focusNode: _node,
          enabled: _enabled,
          invalid: widget.error != null,
          expanded: _open,
          shown: chosen?.label,
          placeholder: widget.placeholder,
          label: widget.label,
          description: widget.error ?? widget.hint,
          end: t.FoxIcons.chevronDown,
          onTap: () => _open ? _close() : _show(),
        ),
      ),
    );
  }
}
