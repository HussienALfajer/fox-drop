import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../field/entry.dart';
import '../field/fox_field.dart';
import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../drop_loader/fox_drop_loader.dart';
import '../theme/fox_theme.dart';

/// The states every text field use case and golden shows (R3), as the web's
/// `STATES`. Hover and focus are live: point at the field or tab to it.
const textFieldStates = [
  'default',
  'hover',
  'focus',
  'filled',
  'disabled',
  'invalid',
];

/// The states of the long text field.
const textAreaStates = textFieldStates;

/// The states of the search field.
const searchFieldStates = [
  'default',
  'hover',
  'focus',
  'typed',
  'loading',
  'disabled',
];

/// A single-line text field (D.8): a 50 high pill with an optional [label],
/// [marker] («(اختياري)»), [hint] and [error], and an optional start icon.
/// Text entry is `material_ui`'s `TextField` (selection, IME, paste) drawn
/// from the tokens: 1 border at rest, 2 `primary` on focus, 2 `danger` when
/// [error] is set, painted inset so nothing moves.
class FoxTextField extends StatelessWidget {
  const FoxTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.marker,
    this.hint,
    this.placeholder,
    this.error,
    this.enabled = true,
    this.startIcon,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
    this.obscureText = false,
    this.inputFormatters,
    this.textDirection,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? marker;
  final String? hint;
  final String? placeholder;
  final String? error;
  final bool enabled;
  final t.FoxIconData? startIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  /// For content that reads left to right (an email) inside an Arabic form.
  final TextDirection? textDirection;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final i = FoxTheme.of(context).input;
    return FoxField(
      label: label,
      marker: marker,
      hint: hint,
      error: error,
      enabled: enabled,
      namesControl: false,
      child: EntryHost(
        controller: controller,
        focusNode: focusNode,
        builder: (context, controller, node) => Entry(
          controller: controller,
          node: node,
          enabled: enabled,
          invalid: error != null,
          name: fieldName(label, marker),
          description: error ?? hint,
          placeholder: placeholder,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          autofillHints: autofillHints,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          textDirection: textDirection,
          autofocus: autofocus,
          start: startIcon == null
              ? null
              : FoxIcon(startIcon!, color: enabled ? i.text : i.onDisabled),
        ),
      ),
    );
  }
}

/// Long text (D.8): the area radius, three lines growing to six then
/// scrolling, and the counter «12/200» at the end under the field when
/// [maxLength] is set.
class FoxTextArea extends StatelessWidget {
  const FoxTextArea({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.marker,
    this.hint,
    this.placeholder,
    this.error,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.keyboardType = TextInputType.multiline,
  });

  /// The lines the field shows at rest and the most it grows to.
  static const minLines = 3;
  static const maxLines = 6;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? marker;
  final String? hint;
  final String? placeholder;
  final String? error;
  final bool enabled;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) => EntryHost(
    controller: controller,
    focusNode: focusNode,
    builder: (context, controller, node) => ListenableBuilder(
      listenable: controller,
      builder: (context, _) => FoxField(
        label: label,
        marker: marker,
        hint: hint,
        error: error,
        enabled: enabled,
        namesControl: false,
        counter: maxLength == null
            ? null
            : '${controller.text.characters.length}/$maxLength',
        child: Entry(
          controller: controller,
          node: node,
          enabled: enabled,
          invalid: error != null,
          name: fieldName(label, marker),
          description: error ?? hint,
          area: true,
          placeholder: placeholder,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

/// The search pill of the home screen (D.8): an orange lens at the start
/// (decoration: the [placeholder] names the field), a clear button at the end
/// once something is typed, and the drop loader in its place while [loading].
class FoxSearchField extends StatelessWidget {
  const FoxSearchField({
    super.key,
    required this.placeholder,
    required this.clearLabel,
    this.loadingLabel,
    this.controller,
    this.focusNode,
    this.loading = false,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  final String placeholder;

  /// The clear button's accessible name.
  final String clearLabel;

  /// What a screen reader says while [loading].
  final String? loadingLabel;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool loading;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final i = FoxTheme.of(context).input;
    return EntryHost(
      controller: controller,
      focusNode: focusNode,
      builder: (context, controller, node) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final Widget? end;
          if (loading) {
            end = FoxDropLoader(label: loadingLabel);
          } else if (controller.text.isNotEmpty && enabled) {
            end = _ClearButton(
              label: clearLabel,
              onTap: () {
                controller.clear();
                onChanged?.call('');
                node.requestFocus();
              },
            );
          } else {
            end = null;
          }
          return FoxField(
            namesControl: false,
            enabled: enabled,
            child: Entry(
              name: placeholder,
              controller: controller,
              node: node,
              enabled: enabled,
              placeholder: placeholder,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              start: FoxIcon(
                t.FoxIcons.search,
                color: enabled ? i.accent : i.onDisabled,
              ),
              end: end,
              trailingTarget: !loading && end != null,
            ),
          );
        },
      ),
    );
  }
}

/// The clear button: a 32 circle on `surface` inside a 48 target.
class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    return Interaction(
      label: label,
      isButton: true,
      onTap: onTap,
      builder: (context, state) => SizedBox.square(
        dimension: t.FoxSize.touchTarget,
        child: Center(
          child: CustomPaint(
            foregroundPainter: FocusRing.of(
              theme,
              on: state.focused,
              radius: t.FoxSize.step,
              circle: true,
            ),
            child: AnimatedContainer(
              duration: t.FoxDuration.base,
              curve: theme.easing,
              width: t.FoxSize.step,
              height: t.FoxSize.step,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state.pressed
                    ? c.surfacePressed
                    : (state.hovered ? c.surfaceHover : c.surface),
              ),
              child: Center(
                child: FoxIcon(
                  t.FoxIcons.close,
                  size: FoxIconSize.sm,
                  color: c.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
