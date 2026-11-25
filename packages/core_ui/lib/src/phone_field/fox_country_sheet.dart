import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../bottom_sheet/fox_bottom_sheet.dart';
import '../radio/fox_radio.dart';
import '../text_field/fox_text_field.dart';
import '../theme/fox_theme.dart';
import 'phone_rules.dart';

/// The states every country sheet use case and golden shows (R3).
const countrySheetStates = ['default', 'lastUsed', 'search', 'empty'];

/// One region of the list: its ISO code, calling code (no plus) and names;
/// the shape of `core_l10n`'s `FoxCountryName`.
typedef FoxCountryOption = ({String iso, String code, String ar, String en});

/// The words of the country list (D.11 item 7).
final class FoxCountrySheetStrings {
  const FoxCountrySheetStrings({
    required this.title,
    required this.close,
    required this.search,
    required this.clearSearch,
    required this.pinned,
    required this.lastUsed,
    required this.all,
    required this.none,
  });

  /// «اختر الدولة».
  final String title;
  final String close;

  /// «ابحث باسم الدولة أو رمزها».
  final String search;
  final String clearSearch;

  /// «الأكثر استعمالاً», «آخر ما استعملته», «كل الدول».
  final String pinned;
  final String lastUsed;
  final String all;

  /// «لا دولة بهذا الاسم أو الرمز».
  final String none;
}

/// Pinned first in the list (owner, 2026-11-24).
const _pinned = ['SY', 'TR'];

/// Whether [country] matches the search [query]: its Arabic name, its English
/// name (any case) or its calling code (`+49`, `0049`, `49`, in any digits),
/// as ui-web's `country-list.ts`.
bool foxCountryMatches(FoxCountryOption country, String query) {
  final text = query.trim();
  if (text.isEmpty) return true;
  if (country.ar.contains(text)) return true;
  if (country.en.toLowerCase().contains(text.toLowerCase())) return true;
  if (!RegExp(r'^[+\s\d٠-٩۰-۹]+$').hasMatch(text)) return false;
  final digits = foxCleanPhone(
    text,
  ).replaceFirst('+', '').replaceFirst(RegExp('^00'), '');
  return digits.isNotEmpty && country.code.startsWith(digits);
}

/// The list's sections for [query]: Syria and Turkey, then the last used
/// country (when it is neither), then every other region in the order of
/// [countries] (Arabic order, from `core_l10n`).
({
  List<FoxCountryOption> pinned,
  List<FoxCountryOption> lastUsed,
  List<FoxCountryOption> all,
})
foxCountrySections(
  List<FoxCountryOption> countries,
  String query, {
  String? lastUsed,
}) {
  FoxCountryOption? find(String iso) {
    for (final country in countries) {
      if (country.iso == iso) return country;
    }
    return null;
  }

  final last = lastUsed != null && !_pinned.contains(lastUsed)
      ? find(lastUsed)
      : null;
  final shown = {..._pinned, ?last?.iso};
  bool keep(FoxCountryOption c) => foxCountryMatches(c, query);
  return (
    pinned: [for (final iso in _pinned) ?find(iso)].where(keep).toList(),
    lastUsed: [?last].where(keep).toList(),
    all: countries.where((c) => !shown.contains(c.iso)).where(keep).toList(),
  );
}

/// Opens the country list and returns the ISO code picked, or null.
Future<String?> showFoxCountrySheet(
  BuildContext context, {
  required List<FoxCountryOption> countries,
  required String selected,
  required FoxCountrySheetStrings strings,
  String? lastUsed,
}) => showFoxBottomSheet<String>(
  context,
  dismissLabel: strings.close,
  builder: (context) => FoxCountrySheet(
    countries: countries,
    selected: selected,
    lastUsed: lastUsed,
    strings: strings,
    onSelected: (iso) => Navigator.of(context).pop(iso),
  ),
);

/// The phone field's country list (D.11 item 7): a bottom sheet with a search
/// field (Arabic name, English name or calling code), then «الأكثر
/// استعمالاً» (Syria and Turkey), «آخر ما استعملته» and «كل الدول» in
/// Arabic order, each a radio group of rows 48 high; every row a name and
/// its calling code isolated left to right, no flags.
class FoxCountrySheet extends StatefulWidget {
  const FoxCountrySheet({
    super.key,
    required this.countries,
    required this.selected,
    required this.strings,
    required this.onSelected,
    this.lastUsed,
    this.initialQuery = '',
  });

  final List<FoxCountryOption> countries;
  final String selected;
  final FoxCountrySheetStrings strings;
  final ValueChanged<String> onSelected;
  final String? lastUsed;

  /// For widgetbook and the goldens: the search already typed.
  final String initialQuery;

  @override
  State<FoxCountrySheet> createState() => _FoxCountrySheetState();
}

class _FoxCountrySheetState extends State<FoxCountrySheet> {
  late final TextEditingController _query = TextEditingController(
    text: widget.initialQuery,
  );

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final s = widget.strings;
    return FoxBottomSheet(
      title: s.title,
      closeLabel: s.close,
      child: ListenableBuilder(
        listenable: _query,
        builder: (context, _) {
          final sections = foxCountrySections(
            widget.countries,
            _query.text,
            lastUsed: widget.lastUsed,
          );
          Widget section(String title, List<FoxCountryOption> list) =>
              list.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsetsDirectional.only(top: t.FoxSpace.sm),
                  child: FoxRadioGroup(
                    label: title,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final country in list)
                          _CountryRow(
                            country: country,
                            selected: widget.selected,
                            onSelected: widget.onSelected,
                          ),
                      ],
                    ),
                  ),
                );
          final nothing =
              sections.pinned.isEmpty &&
              sections.lastUsed.isEmpty &&
              sections.all.isEmpty;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FoxSearchField(
                placeholder: s.search,
                clearLabel: s.clearSearch,
                controller: _query,
              ),
              if (nothing)
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    vertical: t.FoxSpace.lg,
                  ),
                  child: Text(
                    s.none,
                    textAlign: TextAlign.center,
                    style: theme.text.secondary.copyWith(
                      color: theme.colors.onSurfaceMuted,
                    ),
                  ),
                ),
              section(s.pinned, sections.pinned),
              section(s.lastUsed, sections.lastUsed),
              section(s.all, sections.all),
            ],
          );
        },
      ),
    );
  }
}

/// A radio row: the name, then the calling code left to right.
class _CountryRow extends StatelessWidget {
  const _CountryRow({
    required this.country,
    required this.selected,
    required this.onSelected,
  });

  final FoxCountryOption country;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: FoxRadio<String>(
            value: country.iso,
            groupValue: selected,
            onChanged: onSelected,
            label: country.ar,
          ),
        ),
        ExcludeSemantics(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '+${country.code}',
              style: theme.text.body.copyWith(
                color: theme.colors.onSurfaceMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
