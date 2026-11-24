import 'package:core_tokens/core_tokens.dart';
import 'package:test/test.dart';

/// The glyphs drawn without a body: Broken leaves them whole.
const _bodiless = [
  'back',
  'close',
  'chevron-down',
  'menu',
  'add',
  'remove',
  'confirm',
  'retry',
];

void main() {
  test(
    'holds the 44 icons of the first set, the forms pair (D.8) and menu (D.10)',
    () {
      expect(FoxIcons.all, hasLength(47));
    },
  );

  test('gives every icon its elements, one of them the accent', () {
    for (final MapEntry(:key, :value) in FoxIcons.all.entries) {
      expect(value.elements, isNotEmpty, reason: key);
      for (final element in value.elements) {
        expect(element.d, matches(RegExp('^M')), reason: key);
      }
      expect(value.elements.where((e) => e.accent), isNotEmpty, reason: key);
    }
  });

  test('bakes Bold and Bold Duo at 1.5 and 1.75 (set v4 Madar)', () {
    for (final MapEntry(:key, :value) in FoxIcons.all.entries) {
      for (final weight in FoxIconWeight.values) {
        final bold = value.bold(weight);
        final duo = value.boldDuo(weight);
        expect(bold, hasLength(1), reason: '$key $weight');
        expect(bold.single.faded, isFalse, reason: key);
        expect(duo.where((layer) => !layer.faded), isNotEmpty, reason: key);
        for (final layer in [...bold, ...duo]) {
          expect(layer.d, matches(RegExp('^M')), reason: '$key $weight');
        }
      }
      expect(
        value.bold(FoxIconWeight.phone).single.d,
        isNot(value.bold(FoxIconWeight.captain).single.d),
        reason: key,
      );
    }
    expect(FoxIconWeight.phone.stroke, 1.5);
    expect(FoxIconWeight.captain.stroke, 1.75);
  });

  test('bites the body in Broken, and leaves the bare glyphs whole', () {
    for (final MapEntry(:key, :value) in FoxIcons.all.entries) {
      final lines = [for (final e in value.elements) e.d];
      expect(value.broken, hasLength(lines.length), reason: key);
      if (_bodiless.contains(key)) {
        expect(value.broken, lines, reason: key);
      } else {
        expect(value.broken, isNot(lines), reason: key);
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
