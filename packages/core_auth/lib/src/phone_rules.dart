import 'package:phone_numbers_parser/metadata.dart' as m;
import 'package:phone_numbers_parser/phone_numbers_parser.dart' as p;

/// What keeps a phone number from being a complete mobile (D.11's
/// normalisation table, owner 2026-11-24).
enum FoxPhoneProblem {
  empty,
  missingDigits,
  tooLong,
  landline,
  notMobilePrefix,
  unknownCode,
}

/// The phone field's reading of what was typed or pasted (slice D.11b), the
/// moved here from core_ui in D.R1: it passes every row of
/// `packages/core_auth/test/phone-cases.json`, which the web's phone field
/// reads too once it is rebuilt.
final class FoxPhoneReading {
  const FoxPhoneReading({
    required this.country,
    required this.national,
    this.e164,
    this.problem,
    this.missing,
    this.prefix,
    this.switchedFrom,
  });

  /// The country the field ends on (ISO code, upper case).
  final String country;

  /// The national significant digits, without the national prefix.
  final String national;

  /// The E.164 number when [national] is a complete mobile of [country].
  final String? e164;
  final FoxPhoneProblem? problem;

  /// With [FoxPhoneProblem.missingDigits]: how many digits are missing.
  final int? missing;

  /// With [FoxPhoneProblem.notMobilePrefix]: the digit a mobile starts with.
  final String? prefix;

  /// The country that was picked, when the number named another one.
  final String? switchedFrom;

  /// The national digits in groups of three, the last up to four.
  String get grouped => foxGroupDigits(national);

  FoxPhoneReading _from(String picked) => FoxPhoneReading(
    country: country,
    national: national,
    e164: e164,
    problem: problem,
    missing: missing,
    prefix: prefix,
    switchedFrom: country == picked ? null : picked,
  );
}

/// [digits] in groups of three, the rest as one group once four or fewer
/// remain: `944 123 456`, `532 123 4567`.
String foxGroupDigits(String digits) {
  final groups = <String>[];
  var rest = digits;
  while (rest.length > 4) {
    groups.add(rest.substring(0, 3));
    rest = rest.substring(3);
  }
  if (rest.isNotEmpty) groups.add(rest);
  return groups.join(' ');
}

final _regions = {for (final code in p.IsoCode.values) code.name: code};

/// The calling code of [iso] without the plus, or null for an unknown region.
String? foxCallingCode(String iso) {
  final code = _regions[iso];
  return code == null ? null : m.metadataByIsoCode[code]?.countryCode;
}

const _arabicIndic = 0x0660;
const _persian = 0x06F0;

// Spaces, dashes, brackets and dots a number is written with, and the hidden
// marks a contact or a paste carries: LRM, RLM, the embeddings and overrides
// U+202A–U+202E, the isolates U+2066–U+2069, and no-break spaces.
// Built from code points: the marks never sit in the source.
String _hex(int point) => point.toRadixString(16).padLeft(4, '0');
String _range(int from, [int? to]) =>
    to == null ? r'\u' + _hex(from) : r'\u' + _hex(from) + r'-\u' + _hex(to);
final _separators = [
  r'\s\-().',
  _range(0x2010, 0x2015), // hyphens and dashes
  _range(0x2212), // minus
  _range(0x00A0), // no-break space
  _range(0x2007), // figure space
  _range(0x202F), // narrow no-break space
  _range(0x200E, 0x200F), // LRM, RLM
  _range(0x202A, 0x202E), // embeddings and overrides
  _range(0x2066, 0x2069), // isolates
].join();
final _separator = RegExp('[$_separators]');
final _numberish = RegExp('^[+\\d$_separators]*\$');
final _inText = RegExp('\\+?\\d[\\d$_separators]*');

/// Arabic-Indic and Persian digits made Western (AP §4.7).
String _western(String text) {
  final out = StringBuffer();
  for (final rune in text.runes) {
    if (rune >= _arabicIndic && rune <= _arabicIndic + 9) {
      out.writeCharCode(0x30 + rune - _arabicIndic);
    } else if (rune >= _persian && rune <= _persian + 9) {
      out.writeCharCode(0x30 + rune - _persian);
    } else {
      out.writeCharCode(rune);
    }
  }
  return out.toString();
}

/// The number in [input]: `+` and Western digits only. Text around a number
/// (a paste) is dropped: the first run that looks like a number is taken.
String foxCleanPhone(String input) {
  var text = _western(input);
  if (!_numberish.hasMatch(text)) text = _inText.firstMatch(text)?[0] ?? '';
  final bare = text.replaceAll(_separator, '');
  final digits = bare.replaceAll(RegExp(r'\D'), '');
  return bare.startsWith('+') ? '+$digits' : digits;
}

final class _Rules {
  _Rules(p.IsoCode code) {
    final patterns = m.metadataPatternsByIsoCode[code]!;
    final lengths = m.metadataLengthsByIsoCode[code]!;
    RegExp? whole(String pattern) =>
        pattern.isEmpty ? null : RegExp('^(?:$pattern)\$');
    // A region whose mobiles and landlines look the same (Canada) keeps one
    // pattern for both, its mobile one empty: a number of it is a mobile.
    final same = patterns.mobile.isEmpty;
    mobile = whole(same ? patterns.fixedLine : patterns.mobile);
    fixed = same ? null : whole(patterns.fixedLine);
    nationalPrefix = m.metadataByIsoCode[code]!.nationalPrefix;
    possible = [
      ...(lengths.mobile.isNotEmpty ? lengths.mobile : lengths.general),
    ]..sort();
    final example = m.metadataExamplesByIsoCode[code]!.mobile;
    prefix = example.isEmpty ? null : example.substring(0, 1);
  }

  late final RegExp? mobile;
  late final RegExp? fixed;
  late final String? nationalPrefix;
  late final List<int> possible;
  late final String? prefix;
}

final _cache = <String, _Rules>{};
_Rules _rules(String iso) =>
    _cache.putIfAbsent(iso, () => _Rules(_regions[iso]!));

/// Reads [input] under the [picked] country (ISO).
FoxPhoneReading foxReadPhone(String input, String picked) {
  final clean = foxCleanPhone(input);
  final digits = clean.replaceFirst('+', '');
  if (digits.isEmpty) {
    return FoxPhoneReading(
      country: picked,
      national: '',
      problem: FoxPhoneProblem.empty,
    );
  }
  if (clean.startsWith('+')) return _international(digits, picked);
  if (digits.startsWith('00')) {
    return _international(digits.substring(2), picked);
  }

  final national = _classify(picked, _nationalOf(picked, digits));
  if (national.e164 != null) return national;
  // A calling code without `+` or `00`, after a 0 or bare: the picked
  // country's, or another's whose mobile it then is.
  final code = foxCallingCode(picked);
  if (code != null && digits.startsWith('0$code')) {
    final read = _international(digits.substring(1), picked);
    if (read.e164 != null) return read;
  }
  final read = _international(digits, picked);
  if (read.e164 != null) return read;
  return national;
}

FoxPhoneReading _international(String digits, String picked) {
  for (var length = 1; length <= 3 && length <= digits.length; length++) {
    final regions =
        m.countryCodeToIsoCode[digits.substring(0, length)] ??
        const <p.IsoCode>[];
    if (regions.isEmpty) continue;
    final rest = digits.substring(length);
    // The picked country first, then the code's main region and the others.
    final ordered = [
      ...regions.where((r) => r.name == picked),
      ...regions.where((r) => r.name != picked),
    ].map((r) => r.name);
    for (final region in ordered) {
      final read = _classify(region, _nationalOf(region, rest));
      if (read.e164 != null) return read._from(picked);
    }
    final main = ordered.first;
    return _classify(main, _nationalOf(main, rest))._from(picked);
  }
  return FoxPhoneReading(
    country: picked,
    national: '',
    problem: FoxPhoneProblem.unknownCode,
  );
}

/// [digits] without the national prefix, unless the prefix is part of a
/// valid number.
String _nationalOf(String iso, String digits) {
  final rules = _rules(iso);
  final prefix = rules.nationalPrefix;
  if (prefix == null || prefix.isEmpty || !digits.startsWith(prefix)) {
    return digits;
  }
  if ((rules.mobile?.hasMatch(digits) ?? false) ||
      (rules.fixed?.hasMatch(digits) ?? false)) {
    return digits;
  }
  return digits.substring(prefix.length);
}

FoxPhoneReading _classify(String iso, String national) {
  final rules = _rules(iso);
  FoxPhoneReading problem(
    FoxPhoneProblem problem, {
    int? missing,
    String? prefix,
  }) => FoxPhoneReading(
    country: iso,
    national: national,
    problem: problem,
    missing: missing,
    prefix: prefix,
  );
  if (national.isEmpty) return problem(FoxPhoneProblem.empty);
  if (rules.mobile?.hasMatch(national) ?? false) {
    return FoxPhoneReading(
      country: iso,
      national: national,
      e164: '+${foxCallingCode(iso)}$national',
    );
  }
  if (rules.fixed?.hasMatch(national) ?? false) {
    return problem(FoxPhoneProblem.landline);
  }
  final possible = rules.possible;
  if (possible.isNotEmpty && national.length < possible.first) {
    return problem(
      FoxPhoneProblem.missingDigits,
      missing: possible.first - national.length,
    );
  }
  if (possible.isNotEmpty && national.length > possible.last) {
    return problem(FoxPhoneProblem.tooLong);
  }
  return problem(FoxPhoneProblem.notMobilePrefix, prefix: rules.prefix);
}
