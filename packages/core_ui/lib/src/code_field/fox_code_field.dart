import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../field/entry.dart';
import '../field/fox_field.dart';
import '../internal/material_scope.dart';
import '../theme/fox_theme.dart';

/// The states every code field use case and golden shows (R3): `default`
/// (empty), `focus` (the next cell has the orange outline), `typing`,
/// `invalid` and `done` (the cells fill orange and fuse).
const codeFieldStates = ['default', 'focus', 'typing', 'invalid', 'done'];

/// The sign-in code (D.8, architecture §8.3.4): [length] circles of 48, always
/// left to right, over one hidden input that takes typing, paste and the
/// platform's one-time-code autofill. The cell waiting for the next digit has
/// the 2 orange outline; [error] draws every cell 2 `danger`; [done] fills
/// them orange and fuses them for `duration.moment`, even when the platform
/// asks for reduced motion (it is the success moment). [onCompleted] gets the
/// code when the last digit arrives.
class FoxCodeField extends StatelessWidget {
  const FoxCodeField({
    super.key,
    required this.onCompleted,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.label,
    this.marker,
    this.hint,
    this.error,
    this.done = false,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? marker;
  final String? hint;
  final String? error;
  final bool done;
  final bool enabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => EntryHost(
    controller: controller,
    focusNode: focusNode,
    builder: (context, controller, node) => FoxField(
      label: label,
      marker: marker,
      hint: hint,
      error: error,
      enabled: enabled,
      namesControl: false,
      child: _Cells(
        name: fieldName(label, marker),
        description: error ?? hint,
        length: length,
        controller: controller,
        node: node,
        error: error != null,
        done: done,
        enabled: enabled,
        autofocus: autofocus,
        onChanged: (text) {
          onChanged?.call(text);
          if (text.length == length) onCompleted(text);
        },
      ),
    ),
  );
}

/// Arabic-Indic (٠-٩) and Persian (۰-۹) digits, typed, pasted or autofilled,
/// become 0-9 before the digit filter, so the code reads the same (AP §4.7).
final TextInputFormatter _westernDigits = TextInputFormatter.withFunction((
  old,
  value,
) {
  final text = value.text.replaceAllMapped(RegExp('[٠-٩۰-۹]'), (m) {
    final unit = m[0]!.codeUnitAt(0);
    return String.fromCharCode(
      0x30 + (unit >= 0x06F0 ? unit - 0x06F0 : unit - 0x0660),
    );
  });
  return text == value.text ? value : value.copyWith(text: text);
});

/// When the code is already full and digits arrive (a paste, a keystroke, an
/// autofill), the new digits replace the old code instead of being dropped by
/// the length limit, so a wrong code is retyped without deleting it first.
class _ReplaceFullCode extends TextInputFormatter {
  const _ReplaceFullCode(this.length);

  final int length;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final old = oldValue.text;
    final text = newValue.text;
    if (old.length < length || text.length <= old.length) return newValue;
    // What was inserted: the text between the common start and end.
    var start = 0;
    while (start < old.length && old[start] == text[start]) {
      start++;
    }
    var end = 0;
    while (end < old.length - start &&
        old[old.length - 1 - end] == text[text.length - 1 - end]) {
      end++;
    }
    final inserted = text.substring(start, text.length - end);
    return TextEditingValue(
      text: inserted,
      selection: TextSelection.collapsed(
        offset: inserted.length > length ? length : inserted.length,
      ),
    );
  }
}

class _Cells extends StatelessWidget {
  const _Cells({
    required this.length,
    required this.name,
    required this.description,
    required this.controller,
    required this.node,
    required this.error,
    required this.done,
    required this.enabled,
    required this.autofocus,
    required this.onChanged,
  });

  final int length;
  final String? name;
  final String? description;
  final TextEditingController controller;
  final FocusNode node;
  final bool error;
  final bool done;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final none = i.background.withValues(alpha: 0);
    final hidden = theme.text.body.copyWith(color: none);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialScope(
        child: ListenableBuilder(
          listenable: Listenable.merge([controller, node]),
          builder: (context, _) {
            final digits = controller.text;
            final spacing = done ? 0.0 : t.FoxSpace.xs;
            final width = length * i.codeSize + (length - 1) * spacing;
            return Stack(
              alignment: Alignment.center,
              children: [
                // The cells; the input above them takes every touch.
                ExcludeSemantics(
                  child: IgnorePointer(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var n = 0; n < length; n++) ...[
                          if (n > 0)
                            AnimatedContainer(
                              duration: t.FoxDuration.moment,
                              curve: theme.easing,
                              width: spacing,
                            ),
                          _Cell(
                            digit: n < digits.length ? digits[n] : '',
                            current:
                                enabled &&
                                node.hasFocus &&
                                !done &&
                                n == digits.length,
                            error: error,
                            done: done,
                            enabled: enabled,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: MergeSemantics(
                    child: Semantics(
                      label: name,
                      hint: description,
                      child: m.TextField(
                        controller: controller,
                        focusNode: node,
                        enabled: enabled && !done,
                        autofocus: autofocus,
                        style: hidden,
                        cursorColor: none,
                        showCursor: false,
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        maxLength: length,
                        maxLines: 1,
                        onChanged: onChanged,
                        inputFormatters: [
                          _westernDigits,
                          FilteringTextInputFormatter.digitsOnly,
                          _ReplaceFullCode(length),
                          LengthLimitingTextInputFormatter(length),
                        ],
                        buildCounter:
                            (
                              context, {
                              required currentLength,
                              required isFocused,
                              required maxLength,
                            }) => null,
                        decoration: const m.InputDecoration(
                          isCollapsed: true,
                          border: m.InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                // Keeps the stack as wide as the cells.
                SizedBox(width: width, height: i.codeSize),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.digit,
    required this.current,
    required this.error,
    required this.done,
    required this.enabled,
  });

  final String digit;
  final bool current;
  final bool error;
  final bool done;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final Color fill;
    final Color? border;
    final double width;
    if (done) {
      fill = i.codeDone;
      border = null;
      width = 0;
    } else if (!enabled) {
      fill = i.disabled;
      border = null;
      width = 0;
    } else if (error) {
      fill = i.background;
      border = i.borderInvalid;
      width = i.focusWidth;
    } else if (current) {
      fill = i.background;
      border = i.borderFocus;
      width = i.focusWidth;
    } else {
      fill = i.background;
      border = i.border;
      width = i.borderWidth;
    }
    return AnimatedContainer(
      duration: done ? t.FoxDuration.moment : t.FoxDuration.base,
      curve: theme.easing,
      width: i.codeSize,
      height: i.codeSize,
      decoration: BoxDecoration(shape: BoxShape.circle, color: fill),
      foregroundDecoration: border == null
          ? null
          : BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: border, width: width),
            ),
      child: Center(
        child: digit.isEmpty
            ? (current
                  ? SizedBox(
                      width: i.focusWidth,
                      height: t.FoxSpace.lg,
                      child: ColoredBox(color: i.accent),
                    )
                  : null)
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  digit,
                  style: theme.text.title.copyWith(
                    color: done
                        ? i.codeOnDone
                        : (enabled ? i.text : i.onDisabled),
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
      ),
    );
  }
}
