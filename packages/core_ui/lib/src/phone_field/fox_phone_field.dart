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

/// The E.164 number (`+963912345678`) of what a person typed for [country],
/// or null while it is not a complete mobile number (CU §5.2): Syrian mobiles
/// are 9 digits starting with 9, typed `09xxxxxxxx` or `9xxxxxxxx`; Turkish
/// mobiles are 10 digits starting with 5, typed `05xxxxxxxxx` or
/// `5xxxxxxxxx`. Spaces, dashes and Arabic-Indic digits are tolerated.
String? foxPhoneE164(FoxPhoneCountry country, String input) {
  final buffer = StringBuffer();
  for (final unit in input.runes) {
    if (unit >= 0x30 && unit <= 0x39) {
      buffer.writeCharCode(unit);
    } else if (unit >= 0x0660 && unit <= 0x0669) {
      buffer.write(unit - 0x0660);
    } else if (unit != 0x20 && unit != 0x2D && unit != 0xA0) {
      return null;
    }
  }
  var digits = buffer.toString();
  if (digits.startsWith('0')) digits = digits.substring(1);
  if (digits.length != country.digits ||
      !digits.startsWith(country.firstDigit)) {
    return null;
  }
  return '${country.dialCode}$digits';
}

/// A mobile number field (D.8, CU §5.2): one pill holding a left-to-right
/// island, the country chip («+963» or «+90» with a chevron, opening a menu of
/// the two countries) then the digits, under a label, hint and error that
/// read right to left. [onChanged] gets the E.164 number, or null while it
/// is incomplete. The names are passed in.
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
            widget.onChanged(foxPhoneE164(country, controller.text));
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩ \-]')),
                LengthLimitingTextInputFormatter(16),
              ],
              onChanged: (text) =>
                  widget.onChanged(foxPhoneE164(widget.country, text)),
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
