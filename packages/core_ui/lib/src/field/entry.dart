import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../internal/material_scope.dart';
import '../theme/fox_theme.dart';
import 'fox_field.dart';

/// Owns the controller and focus node a field was not given, and hands both
/// to [builder]. Not exported.
class EntryHost extends StatefulWidget {
  const EntryHost({
    super.key,
    required this.builder,
    this.controller,
    this.focusNode,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget Function(
    BuildContext context,
    TextEditingController controller,
    FocusNode node,
  )
  builder;

  @override
  State<EntryHost> createState() => _EntryHostState();
}

class _EntryHostState extends State<EntryHost> {
  TextEditingController? _controller;
  FocusNode? _node;

  @override
  void dispose() {
    _controller?.dispose();
    _node?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
    context,
    widget.controller ?? (_controller ??= TextEditingController()),
    widget.focusNode ?? (_node ??= FocusNode(debugLabel: 'FoxField')),
  );
}

/// The text entry of every field: `material_ui`'s `TextField` (selection,
/// IME, paste, autofill) inside a [FieldBox], themed wholly from the tokens,
/// with no decoration, no ripple and no counter of its own. Not exported.
class Entry extends StatelessWidget {
  const Entry({
    super.key,
    required this.controller,
    required this.node,
    this.enabled = true,
    this.invalid = false,
    this.area = false,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
    this.obscureText = false,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.textDirection,
    this.start,
    this.end,
    this.trailingTarget = false,
    this.autofocus = false,
    this.name,
    this.description,
  });

  /// The control's accessible name and description (the field's label with
  /// its marker, and its error or hint): merged into the text field's own
  /// semantics, not left beside it.
  final String? name;
  final String? description;

  final TextEditingController controller;
  final FocusNode node;
  final bool enabled;
  final bool invalid;
  final bool area;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final Widget? start;
  final Widget? end;
  final bool trailingTarget;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final style = theme.text.body.copyWith(
      color: enabled ? i.text : i.onDisabled,
    );
    return MaterialScope(
      child: ListenableBuilder(
        listenable: node,
        builder: (context, _) => FieldBox(
          focused: node.hasFocus,
          invalid: invalid,
          enabled: enabled,
          area: area,
          trailingTarget: trailingTarget,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: enabled ? node.requestFocus : null,
            child: Row(
              crossAxisAlignment: area
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                if (start != null) ...[start!, SizedBox(width: i.gap)],
                Expanded(
                  child: MergeSemantics(
                    child: Semantics(
                      label: name,
                      hint: description,
                      child: m.TextField(
                        controller: controller,
                        focusNode: node,
                        enabled: enabled,
                        autofocus: autofocus,
                        style: style,
                        cursorColor: i.accent,
                        textAlign: TextAlign.start,
                        textDirection: textDirection,
                        keyboardType: keyboardType,
                        textInputAction: textInputAction,
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                        autofillHints: autofillHints,
                        obscureText: obscureText,
                        minLines: minLines,
                        maxLines: obscureText ? 1 : maxLines,
                        maxLength: maxLength,
                        inputFormatters: inputFormatters,
                        buildCounter:
                            (
                              context, {
                              required currentLength,
                              required isFocused,
                              required maxLength,
                            }) => null,
                        decoration: m.InputDecoration(
                          isCollapsed: true,
                          border: m.InputBorder.none,
                          hintText: placeholder,
                          hintStyle: style.copyWith(
                            color: enabled ? i.placeholder : i.onDisabled,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (end != null) ...[SizedBox(width: i.gap), end!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
