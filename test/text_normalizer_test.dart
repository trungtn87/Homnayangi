import 'package:flutter_test/flutter_test.dart';
import 'package:hom_nay_an_gi/utils/text_normalizer.dart';

void main() {
  test('normalizes decomposed Vietnamese text to NFC', () {
    const decomposed = 'Ga\u0300 na\u0302\u0301m';
    expect(normalizeUserText(decomposed), 'Gà nấm');
  });

  test('trims and collapses whitespace in dish names', () {
    expect(normalizeUserText('  Cá   kho  '), 'Cá kho');
  });
}
