import 'package:core_tokens/core_tokens.dart';
import 'package:test/test.dart';

void main() {
  test('holds the 44 icons of the first set (brand expression §10)', () {
    expect(FoxIcons.all, hasLength(44));
  });

  test('gives every icon its path data', () {
    for (final MapEntry(:key, :value) in FoxIcons.all.entries) {
      expect(value.paths, isNotEmpty, reason: key);
      for (final d in value.paths) {
        expect(d, matches(RegExp('^[Mm]')), reason: key);
      }
    }
  });

  test('mirrors exactly back, motorcycle and car in RTL', () {
    final mirrored = [
      for (final MapEntry(:key, :value) in FoxIcons.all.entries)
        if (value.mirror) key,
    ];
    expect(mirrored, unorderedEquals(['back', 'motorcycle', 'car']));
  });
}
