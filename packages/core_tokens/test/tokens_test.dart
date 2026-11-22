import 'dart:convert';
import 'dart:io';

import 'package:core_tokens/core_tokens.dart';
import 'package:test/test.dart';

// A few values against the DTCG sources, so the Dart output is seen to follow
// them (the TypeScript test compares the whole file with a fresh render).
void main() {
  Map<String, dynamic> source(String file) =>
      jsonDecode(File('../design-tokens/tokens/$file').readAsStringSync())
          as Map<String, dynamic>;

  int argb(String hex) => int.parse('FF${hex.substring(1)}', radix: 16);

  test('the Figma ground and the brand orange', () {
    final color =
        (source('primitive/color.json')['primitive']
                as Map<String, dynamic>)['color']
            as Map<String, dynamic>;
    String value(String scale, String step) =>
        ((color[scale] as Map<String, dynamic>)[step]
                as Map<String, dynamic>)['\$value']
            as String;
    expect(FoxColors.light.surface, argb(value('neutral', '75')));
    expect(FoxColors.light.primary, argb(value('orange', '400')));
  });

  test('the dark slot copies light until dark mode is designed', () {
    expect(FoxColors.dark.primary, FoxColors.light.primary);
  });

  test('the captain override darkens the muted text', () {
    expect(
      FoxColors.captainLight.onSurfaceMuted,
      isNot(FoxColors.light.onSurfaceMuted),
    );
  });

  test('motion and type follow brand expression §3 and §7', () {
    expect(FoxDuration.base, const Duration(milliseconds: 200));
    expect(FoxType.captain.body.size, 18);
    expect(FoxType.phone.number.lineHeight, 1.2);
    expect(FoxSize.touchTarget, 48);
  });
}
