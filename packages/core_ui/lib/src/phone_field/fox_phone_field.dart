import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../field/entry.dart';
import '../field/fox_field.dart';
import '../icon/fox_icon.dart';
import '../internal/anchored_menu.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every phone field use case and golden shows (R3). Hover and
/// focus are live; `open` shows the country menu.
const phoneFieldStates = [
  'default',
  'hover',
  'focus',
  'open',
  'filled',
  'disabled',
  'invalid',
];

/// The two countries a phone number may belong to (CU §5.2, decision U3).
enum FoxPhoneCountry {
  syria('+963', 9, '9'),
  turkey('+90', 10, '5');

  const FoxPhoneCountry(this.dialCode, this.digits, this.firstDigit);

  /// `+963` or `+90`.
  final String dialCode;

  /// The digits of a mobile after the dial code.
  final int digits;

  /// The digit every mobile starts with after the dial code.
  final String firstDigit;
}

String _dial(FoxPhoneCountry country) => country.dialCode.substring(1);

/// Western digits only: Arabic-Indic (٠-٩) and Persian (۰-۹) digits become
/// 0-9 (AP §4.7), everything else goes. The web's `digitsOf`.
String foxPhoneDigits(String text) {
  final out = StringBuffer();
  for (final rune in text.runes) {
    if (rune >= 0x30 && rune <= 0x39) {
      out.writeCharCode(rune);
    } else if (rune >= 0x0660 && rune <= 0x0669) {
      out.write(rune - 0x0660);
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      out.write(rune - 0x06F0);
    }
  }
  return out.toString();
}

bool _isComplete(FoxPhoneCountry country, String national) =>
    national.length == country.digits &&
    national.startsWith(country.firstDigit);

/// What [foxParsePhone] read.
class FoxParsedPhone {
  const FoxParsedPhone({
    required this.country,
    required this.display,
    required this.e164,
    required this.refused,
  });

  /// The picked country, or the one the number's own calling code names.
  final FoxPhoneCountry country;

  /// The digits as typed, or the national digits of a number given with its
  /// calling code.
  final String display;

  /// The E.164 number, or null while it is not a complete mobile number.
  final String? e164;

  /// The text cannot be a number of either country (too long, or a calling
  /// code with a wrong rest); it is shown, never reshaped.
  final bool refused;
}

FoxParsedPhone _international(FoxPhoneCountry country, String national) =>
    _isComplete(country, national)
    ? FoxParsedPhone(
        country: country,
        display: national,
        e164: '${country.dialCode}$national',
        refused: false,
      )
    : FoxParsedPhone(
        country: country,
        display: national,
        e164: null,
        refused: true,
      );

/// Reads what was typed or pasted under the [selected] country, as the web's
/// `parsePhone` (CU §5.2). A number with its own calling code (`+90…`,
/// `0090…`, or exactly that code and a full national number such as
/// `963912345678`) belongs to that country, whichever is selected, and must
/// be complete for it. Otherwise the leading 0 is dropped and nothing is cut:
/// more digits than the country has make the text refused.
FoxParsedPhone foxParsePhone(FoxPhoneCountry selected, String text) {
  final trimmed = text.trim();
  final digits = foxPhoneDigits(trimmed);
  final refused = FoxParsedPhone(
    country: selected,
    display: digits,
    e164: null,
    refused: true,
  );

  if (trimmed.startsWith('+') || digits.startsWith('00')) {
    final rest = trimmed.startsWith('+') ? digits : digits.substring(2);
    final code = FoxPhoneCountry.values
        .where((c) => rest.startsWith(_dial(c)))
        .firstOrNull;
    if (code == null) return refused;
    final result = _international(code, rest.substring(_dial(code).length));
    return result.refused ? refused : result;
  }

  final full = FoxPhoneCountry.values
      .where(
        (c) =>
            digits.length == _dial(c).length + c.digits &&
            digits.startsWith(_dial(c)),
      )
      .firstOrNull;
  if (full != null) {
    final result = _international(full, digits.substring(_dial(full).length));
    if (!result.refused) return result;
  }

  final national = digits.startsWith('0') ? digits.substring(1) : digits;
  if (national.length > selected.digits) return refused;
  return FoxParsedPhone(
    country: selected,
    display: digits,
    e164: _isComplete(selected, national)
        ? '${selected.dialCode}$national'
        : null,
    refused: false,
  );
}

/// The E.164 number (`+963912345678`) of what a person typed for [country],
/// or null while it is not a complete mobile number (CU §5.2): Syrian mobiles
/// are 9 digits starting with 9, typed `09xxxxxxxx` or `9xxxxxxxx`; Turkish
/// mobiles are 10 digits starting with 5, typed `05xxxxxxxxx` or
/// `5xxxxxxxxx`. Anything but digits is ignored; Arabic-Indic and Persian
/// digits count. A number with its own calling code gives that country's
/// number (see [foxParsePhone]).
String? foxPhoneE164(FoxPhoneCountry country, String input) =>
    foxParsePhone(country, input).e164;

/// The country and national digits of a stored E.164 number, or null when it
/// is neither country's complete mobile number.
({FoxPhoneCountry country, String national})? foxPhoneFromE164(String value) {
  for (final country in FoxPhoneCountry.values) {
    if (value.startsWith(country.dialCode)) {
      final national = value.substring(country.dialCode.length);
      if (_isComplete(country, national)) {
        return (country: country, national: national);
      }
    }
  }
  return null;
}

/// Keeps the box to digits, `+`, spaces and dashes, in Western digits, and
/// stops typing at the country's length: a single added character that makes
/// the text too long is dropped. A paste of more is kept whole (it shows, and
/// is refused by [foxParsePhone]), never cut.
class _PhoneFormatter extends TextInputFormatter {
  const _PhoneFormatter(this.country);

  final FoxPhoneCountry country;

  static String _clean(String text) {
    final out = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      if (char == '+' || char == ' ' || char == '-') {
        out.write(char);
      } else {
        out.write(foxPhoneDigits(char));
      }
    }
    return out.toString();
  }

  bool _tooLong(String text) {
    final trimmed = text.trim();
    final digits = foxPhoneDigits(trimmed);
    if (trimmed.startsWith('+') || digits.startsWith('00')) {
      final rest = trimmed.startsWith('+') ? digits : digits.substring(2);
      for (final c in FoxPhoneCountry.values) {
        if (rest.startsWith(_dial(c))) {
          return rest.length - _dial(c).length > c.digits;
        }
      }
      // The calling code is still being typed.
      return false;
    }
    final national = digits.startsWith('0') ? digits.substring(1) : digits;
    return national.length > country.digits;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = _clean(newValue.text);
    if (text.length == oldValue.text.length + 1 && _tooLong(text)) {
      return oldValue;
    }
    if (text == newValue.text) return newValue;
    final offset = newValue.selection.baseOffset.clamp(0, newValue.text.length);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: _clean(newValue.text.substring(0, offset)).length,
      ),
    );
  }
}

/// A mobile number field (D.8, CU §5.2): one pill holding a left-to-right
/// island, the country chip («+963» or «+90» with a chevron, opening a menu of
/// the two countries) then the digits, under a label, hint and error that
/// read right to left. [onChanged] gets the E.164 number, or null while it
/// is incomplete or refused. Text given with its own calling code (`+90…`,
/// `0090…`, `905321234567`) switches the chip to that country when the rest
/// is a complete number for it ([onCountryChanged] is called, the box shows
/// the national digits and [onChanged] gets the number with the new code); a
/// calling code with a wrong rest, or more digits than the country has, stays
/// as typed and gives null, never cut. The names are passed in.
class FoxPhoneField extends StatefulWidget {
  const FoxPhoneField({
    super.key,
    required this.country,
    required this.onCountryChanged,
    required this.onChanged,
    required this.countryNames,
    required this.countryLabel,
    this.controller,
    this.focusNode,
    this.label,
    this.marker,
    this.hint,
    this.placeholder,
    this.error,
    this.enabled = true,
    this.initiallyOpen = false,
  });

  final FoxPhoneCountry country;
  final ValueChanged<FoxPhoneCountry> onCountryChanged;
  final ValueChanged<String?> onChanged;

  /// «سوريا» and «تركيا»: the menu shows each name with its dial code.
  final Map<FoxPhoneCountry, String> countryNames;

  /// The chip's accessible name, for example «رمز الدولة».
  final String countryLabel;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? marker;
  final String? hint;
  final String? placeholder;
  final String? error;
  final bool enabled;
  final bool initiallyOpen;

  @override
  State<FoxPhoneField> createState() => _FoxPhoneFieldState();
}

class _FoxPhoneFieldState extends State<FoxPhoneField> {
  final OverlayPortalController _menu = OverlayPortalController();
  final FocusNode _chip = FocusNode(debugLabel: 'FoxPhoneChip');
  bool _open = false;

  @override
  void initState() {
    super.initState();
    if (widget.initiallyOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _show());
    }
  }

  @override
  void dispose() {
    _chip.dispose();
    super.dispose();
  }

  void _show() {
    if (!mounted || !widget.enabled) return;
    _menu.show();
    setState(() => _open = true);
  }

  void _close() {
    if (!_open) return;
    _menu.hide();
    setState(() => _open = false);
    _chip.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final i = FoxTheme.of(context).input;
    return FoxField(
      label: widget.label,
      marker: widget.marker,
      hint: widget.hint,
      error: widget.error,
      enabled: widget.enabled,
      namesControl: false,
      child: EntryHost(
        controller: widget.controller,
        focusNode: widget.focusNode,
        builder: (context, controller, node) => AnchoredMenu<FoxPhoneCountry>(
          controller: _menu,
          label: widget.countryLabel,
          selected: widget.country,
          items: [
            for (final c in FoxPhoneCountry.values)
              MenuItem(
                value: c,
                label: '${widget.countryNames[c] ?? ''} ${c.dialCode}',
              ),
          ],
          onSelected: (country) {
            _close();
            widget.onCountryChanged(country);
            widget.onChanged(foxParsePhone(country, controller.text).e164);
          },
          onClosed: _close,
          // The island: the digits and the chip always run left to right.
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Entry(
              controller: controller,
              node: node,
              enabled: widget.enabled,
              invalid: widget.error != null,
              name: fieldName(widget.label, widget.marker),
              description: widget.error ?? widget.hint,
              placeholder: widget.placeholder,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumberNational],
              inputFormatters: [_PhoneFormatter(widget.country)],
              onChanged: (text) {
                final parsed = foxParsePhone(widget.country, text);
                if (parsed.country != widget.country) {
                  widget.onCountryChanged(parsed.country);
                }
                // A number given with its calling code shows its national
                // digits under the chip that now names the country.
                if (parsed.e164 != null &&
                    parsed.display != foxPhoneDigits(text)) {
                  controller.value = TextEditingValue(
                    text: parsed.display,
                    selection: TextSelection.collapsed(
                      offset: parsed.display.length,
                    ),
                  );
                }
                widget.onChanged(parsed.e164);
              },
              start: _Chip(
                dialCode: widget.country.dialCode,
                label: widget.countryLabel,
                enabled: widget.enabled,
                open: _open,
                focusNode: _chip,
                gap: i.gap,
                onTap: () => _open ? _close() : _show(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// «+963 ⌄»: the country chip, with a hairline to its end.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.dialCode,
    required this.label,
    required this.enabled,
    required this.open,
    required this.focusNode,
    required this.gap,
    required this.onTap,
  });

  final String dialCode;
  final String label;
  final bool enabled;
  final bool open;
  final FocusNode focusNode;
  final double gap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final colour = enabled ? i.text : i.onDisabled;
    return Interaction(
      enabled: enabled,
      focusNode: focusNode,
      onTap: onTap,
      isButton: true,
      label: label,
      value: dialCode,
      expanded: open,
      builder: (context, state) => CustomPaint(
        foregroundPainter: FocusRing.of(
          theme,
          on: state.focused,
          radius: t.FoxRadius.sm,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: t.FoxSize.touchTarget),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dialCode,
                style: theme.text.body.copyWith(
                  color: colour,
                  fontWeight: FoxTextTheme.fontWeight(500),
                ),
              ),
              SizedBox(width: gap / 2),
              FoxIcon(
                t.FoxIcons.chevronDown,
                size: FoxIconSize.sm,
                color: colour,
              ),
              SizedBox(width: gap),
              Container(
                width: i.borderWidth,
                height: t.FoxSpace.lg,
                color: enabled ? i.border : i.onDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
