import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../field/entry.dart';
import '../field/fox_field.dart';
import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';
import 'fox_country_sheet.dart';
import 'phone_rules.dart';

/// The states every phone field use case and golden shows (R3). Hover and
/// focus are live.
const phoneFieldStates = [
  'default',
  'hover',
  'focus',
  'filled',
  'valid',
  'invalid',
  'switched',
  'busy',
  'disabled',
];

/// The words of the phone field and its country list, from the app's strings
/// (`core_l10n`; D.11 items 5 to 7 and 11). `core_auth`'s
/// `phoneFieldStrings` builds them.
final class FoxPhoneStrings {
  const FoxPhoneStrings({
    required this.chip,
    required this.valid,
    required this.clear,
    required this.empty,
    required this.missingDigits,
    required this.tooLong,
    required this.landline,
    required this.notMobilePrefix,
    required this.unknownCode,
    required this.switched,
    required this.sheet,
  });

  /// «الدولة: {الاسم}، {الرمز}. اضغط لتغييرها».
  final String Function(String name, String code) chip;

  /// The check mark: «الرقم صحيح».
  final String valid;

  /// The clear button: «مسح الرقم».
  final String clear;
  final String empty;
  final String Function(int count) missingDigits;
  final String tooLong;
  final String landline;
  final String Function(String prefix) notMobilePrefix;
  final String unknownCode;

  /// «عرفنا الدولة من رمزها: {الدولة}.»
  final String Function(String country) switched;
  final FoxCountrySheetStrings sheet;

  /// The words of [reading]'s problem, or null when it has none.
  String? problem(FoxPhoneReading reading) => switch (reading.problem) {
    null => null,
    FoxPhoneProblem.empty => empty,
    FoxPhoneProblem.missingDigits => missingDigits(reading.missing ?? 1),
    FoxPhoneProblem.tooLong => tooLong,
    FoxPhoneProblem.landline => landline,
    FoxPhoneProblem.notMobilePrefix => notMobilePrefix(reading.prefix ?? ''),
    FoxPhoneProblem.unknownCode => unknownCode,
  };
}

/// The phone number of every app (D.11 item 6), as ui-web's `PhoneField`:
/// one pill whose island runs left to right, the country chip (ISO letters
/// and calling code) that opens [FoxCountrySheet] with every region, the
/// digits, a check mark once the number is a complete mobile and a clear
/// button. What is typed or pasted is read by the shared rules
/// ([foxReadPhone]): a number of another country switches the chip by itself
/// ([onCountryChanged]) and says so. A problem shows on leaving the field or
/// on the keyboard's send key, then live until fixed; [error] is the screen's
/// own (the server's answer). [busy] locks it while the number is sent (R14).
class FoxPhoneField extends StatefulWidget {
  const FoxPhoneField({
    super.key,
    required this.country,
    required this.onCountryChanged,
    required this.onChanged,
    required this.countries,
    required this.strings,
    this.onSubmitted,
    this.lastUsedCountry,
    this.controller,
    this.focusNode,
    this.label,
    this.marker,
    this.hint,
    this.placeholder,
    this.error,
    this.enabled = true,
    this.busy = false,
  });

  /// The picked country (ISO).
  final String country;
  final ValueChanged<String> onCountryChanged;

  /// Every change, with its reading; `e164` is set for a complete mobile.
  final ValueChanged<FoxPhoneReading> onChanged;

  /// The send key with a complete mobile; otherwise the problem shows.
  final ValueChanged<String>? onSubmitted;

  /// Every region with its names (`core_l10n`'s `foxCountryNames`).
  final List<FoxCountryOption> countries;
  final FoxPhoneStrings strings;

  /// Listed after Syria and Turkey (the app stores it).
  final String? lastUsedCountry;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? marker;
  final String? hint;
  final String? placeholder;
  final String? error;
  final bool enabled;
  final bool busy;

  @override
  State<FoxPhoneField> createState() => _FoxPhoneFieldState();
}

class _FoxPhoneFieldState extends State<FoxPhoneField> {
  final FocusNode _chip = FocusNode(debugLabel: 'FoxPhoneChip');
  bool _judged = false;
  String? _switchedFrom;

  @override
  void dispose() {
    _chip.dispose();
    super.dispose();
  }

  bool get _locked => !widget.enabled || widget.busy;

  String _name(String iso) {
    for (final country in widget.countries) {
      if (country.iso == iso) return country.ar;
    }
    return iso;
  }

  Future<void> _pickCountry(TextEditingController controller) async {
    final picked = await showFoxCountrySheet(
      context,
      countries: widget.countries,
      selected: widget.country,
      lastUsed: widget.lastUsedCountry,
      strings: widget.strings.sheet,
    );
    if (!mounted) return;
    _chip.requestFocus();
    if (picked == null || picked == widget.country) return;
    setState(() => _switchedFrom = null);
    widget.onCountryChanged(picked);
    widget.onChanged(foxReadPhone(controller.text, picked));
  }

  void _show(TextEditingController controller, String text) {
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final input = FoxTheme.of(context).components.input;
    final s = widget.strings;
    return EntryHost(
      controller: widget.controller,
      focusNode: widget.focusNode,
      builder: (context, controller, node) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final reading = foxReadPhone(controller.text, widget.country);
          final problem = _judged ? s.problem(reading) : null;
          final shown = widget.error ?? problem;
          final code = '+${foxCallingCode(widget.country) ?? ''}';
          final switchedNote = _switchedFrom != null && shown == null
              ? s.switched(_name(widget.country))
              : null;
          return FoxField(
            label: widget.label,
            marker: widget.marker,
            hint: switchedNote ?? widget.hint,
            error: shown,
            enabled: !_locked,
            namesControl: false,
            child: Focus(
              skipTraversal: true,
              canRequestFocus: false,
              onFocusChange: (focused) {
                if (focused || !mounted) return;
                if (controller.text.isNotEmpty) setState(() => _judged = true);
                if (reading.e164 != null) _show(controller, reading.grouped);
              },
              // The island: the chip and the digits always run left to right.
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Entry(
                  controller: controller,
                  node: node,
                  enabled: !_locked,
                  invalid: shown != null,
                  name: fieldName(widget.label, widget.marker),
                  description: shown ?? switchedNote ?? widget.hint,
                  placeholder: widget.placeholder,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.send,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  onSubmitted: (text) {
                    setState(() => _judged = true);
                    final e164 = foxReadPhone(text, widget.country).e164;
                    if (e164 != null) widget.onSubmitted?.call(e164);
                  },
                  onChanged: (text) {
                    final read = foxReadPhone(text, widget.country);
                    if (read.country != widget.country) {
                      // The number named another country: the chip takes
                      // it, the box its national digits.
                      setState(() => _switchedFrom = widget.country);
                      widget.onCountryChanged(read.country);
                      _show(controller, read.grouped);
                    } else if (read.e164 != null &&
                        RegExp(r'[^\d\s]').hasMatch(text)) {
                      // A paste with its code or marks: shown grouped.
                      _show(controller, read.grouped);
                    }
                    widget.onChanged(read);
                  },
                  start: _Chip(
                    iso: widget.country,
                    dialCode: code,
                    label: s.chip(_name(widget.country), code),
                    enabled: !_locked,
                    focusNode: _chip,
                    gap: input.gap,
                    onTap: () => _pickCountry(controller),
                  ),
                  end: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (reading.e164 != null)
                        Semantics(
                          image: true,
                          label: s.valid,
                          // Not a control: as wide as its icon, so a
                          // narrow field keeps room for the digits.
                          child: Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: input.gap / 2,
                            ),
                            child: FoxIcon(
                              t.FoxIcons.success,
                              style: FoxIconStyle.bold,
                              color: FoxTheme.of(context).colors.success,
                            ),
                          ),
                        ),
                      if (controller.text.isNotEmpty && !_locked)
                        _Clear(
                          label: s.clear,
                          onTap: () {
                            controller.clear();
                            setState(() => _switchedFrom = null);
                            widget.onChanged(foxReadPhone('', widget.country));
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// «SY +963 ⌄»: the country chip. No hairline to its end: the web and the
/// D.8 sheet draw none (parity, D.W3a).
class _Chip extends StatelessWidget {
  const _Chip({
    required this.iso,
    required this.dialCode,
    required this.label,
    required this.enabled,
    required this.focusNode,
    required this.gap,
    required this.onTap,
  });

  final String iso;
  final String dialCode;
  final String label;
  final bool enabled;
  final FocusNode focusNode;
  final double gap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final input = theme.components.input;
    final colour = Color(enabled ? input.colorText : input.colorOnDisabled);
    return Interaction(
      enabled: enabled,
      focusNode: focusNode,
      onTap: onTap,
      isButton: true,
      label: label,
      builder: (context, state) => CustomPaint(
        foregroundPainter: FocusRing.of(
          theme,
          on: state.focused,
          radius: t.FoxRadius.sm,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: t.FoxSize.touchTarget),
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  iso,
                  style: theme.text.secondary.copyWith(
                    color: colour,
                    fontWeight: FoxTextTheme.fontWeight(700),
                  ),
                ),
                SizedBox(width: gap / 2),
                Text(dialCode, style: theme.text.body.copyWith(color: colour)),
                SizedBox(width: gap / 2),
                FoxIcon(
                  t.FoxIcons.chevronDown,
                  size: FoxIconSize.sm,
                  color: colour,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The × that empties the field.
class _Clear extends StatelessWidget {
  const _Clear({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final input = theme.components.input;
    return Interaction(
      label: label,
      isButton: true,
      onTap: onTap,
      builder: (context, state) => SizedBox.square(
        dimension: input.clearTarget,
        child: Center(
          child: CustomPaint(
            foregroundPainter: FocusRing.of(
              theme,
              on: state.focused,
              radius: input.clearSize,
              circle: true,
            ),
            child: AnimatedContainer(
              duration: t.FoxDuration.base,
              curve: theme.easing,
              width: input.clearSize,
              height: input.clearSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(
                  state.pressed
                      ? input.clearColorBackgroundPressed
                      : (state.hovered
                            ? input.clearColorBackgroundHover
                            : input.clearColorBackground),
                ),
              ),
              child: Center(
                child: FoxIcon(
                  t.FoxIcons.close,
                  size: FoxIconSize.sm,
                  color: Color(input.colorHint),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
