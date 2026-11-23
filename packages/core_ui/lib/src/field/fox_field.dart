import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../theme/fox_theme.dart';

/// The states of the field wrapper's use cases and goldens (R3), as the
/// web's.
const fieldStates = ['default', 'optional', 'hint', 'invalid', 'disabled'];

/// The wrapper of every field (D.8): the label above (with its marker, such
/// as «(اختياري)», passed in: optional fields are marked, there is no
/// required star), the [child] control, then the hint, or the error with its
/// icon (never colour alone) and, for long text, the [counter] at the end.
///
/// The label names the control and the error describes it for a screen
/// reader (the hint's semantics); the visible texts are not read twice.
class FoxField extends StatelessWidget {
  const FoxField({
    super.key,
    required this.child,
    this.label,
    this.marker,
    this.hint,
    this.error,
    this.counter,
    this.enabled = true,
    this.namesControl = true,
  });

  final Widget child;
  final String? label;

  /// False when the control names and describes itself (a select, a date
  /// field: its own semantics carry the label and the error), so the label
  /// and the error are not also announced as a separate node.
  final bool namesControl;

  /// «(اختياري)»: the caller's translated text.
  final String? marker;
  final String? hint;
  final String? error;

  /// For example `12/200`, shown at the end under the control.
  final String? counter;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final below = error ?? hint;
    final name = label == null
        ? null
        : (marker == null ? label : '$label $marker');
    final control = namesControl
        ? Semantics(label: name, hint: below, child: child)
        : child;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          ExcludeSemantics(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: label),
                  if (marker != null)
                    TextSpan(
                      text: ' $marker',
                      style: TextStyle(
                        fontWeight: FoxTextTheme.fontWeight(400),
                        color: i.hint,
                      ),
                    ),
                ],
              ),
              style: theme.text.secondary.copyWith(
                fontWeight: FoxTextTheme.fontWeight(500),
                color: enabled ? i.label : i.onDisabled,
              ),
            ),
          ),
          const SizedBox(height: t.FoxSpace.xxs),
        ],
        control,
        if (below != null || counter != null) ...[
          const SizedBox(height: t.FoxSpace.xxs),
          ExcludeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: error != null
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                top: 0,
                                end: t.FoxSpace.xxs,
                              ),
                              child: FoxIcon(
                                t.FoxIcons.error,
                                size: FoxIconSize.sm,
                                color: i.error,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                error!,
                                style: theme.text.caption.copyWith(
                                  color: i.error,
                                ),
                              ),
                            ),
                          ],
                        )
                      : (hint == null
                            ? const SizedBox.shrink()
                            : Text(
                                hint!,
                                style: theme.text.caption.copyWith(
                                  color: i.hint,
                                ),
                              )),
                ),
                if (counter != null) ...[
                  const SizedBox(width: t.FoxSpace.xs),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      counter!,
                      style: theme.text.caption.copyWith(
                        color: i.hint,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// The pill (or the box of long text) every field draws (D.8): 50 high,
/// `surface-raised`, 1 `border-strong` at rest, `border-hover` on hover, 2
/// `primary` on focus, 2 `danger` when invalid. The outline is painted over
/// the fill, inset, so a thicker one never moves the text. Not exported.
class FieldBox extends StatefulWidget {
  const FieldBox({
    super.key,
    required this.child,
    this.focused = false,
    this.invalid = false,
    this.enabled = true,
    this.area = false,
    this.trailingTarget = false,
  });

  final Widget child;
  final bool focused;
  final bool invalid;
  final bool enabled;

  /// The end holds a 48 target (the clear button): less padding at the end.
  final bool trailingTarget;

  /// Long text: the area radius, the content on top.
  final bool area;

  @override
  State<FieldBox> createState() => _FieldBoxState();
}

class _FieldBoxState extends State<FieldBox> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final BoxBorder? border;
    if (!widget.enabled) {
      border = null;
    } else if (widget.invalid) {
      border = Border.all(color: i.borderInvalid, width: i.focusWidth);
    } else if (widget.focused) {
      border = Border.all(color: i.borderFocus, width: i.focusWidth);
    } else if (_hovered) {
      border = Border.all(color: i.borderHover, width: i.borderWidth);
    } else {
      border = Border.all(color: i.border, width: i.borderWidth);
    }
    final radius = BorderRadius.circular(widget.area ? i.areaRadius : i.radius);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: t.FoxDuration.base,
        curve: theme.easing,
        constraints: BoxConstraints(minHeight: i.height),
        alignment: widget.area
            ? AlignmentDirectional.topStart
            : AlignmentDirectional.center,
        padding: EdgeInsetsDirectional.only(
          start: i.paddingInline,
          end: widget.trailingTarget ? i.gap : i.paddingInline,
          top: widget.area ? t.FoxSpace.sm : 0,
          bottom: widget.area ? t.FoxSpace.sm : 0,
        ),
        decoration: BoxDecoration(
          color: widget.enabled ? i.background : i.disabled,
          borderRadius: radius,
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: radius,
          border: border,
        ),
        child: widget.child,
      ),
    );
  }
}

/// A field's accessible name: the label and its marker. Not exported.
String? fieldName(String? label, String? marker) =>
    label == null ? null : (marker == null ? label : '$label $marker');
