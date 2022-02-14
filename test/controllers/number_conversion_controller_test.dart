import 'package:arabic_numbers/controllers/number_conversion_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should convert 1000000 to string one million', () {
    final String phrase = NumberConversionController.convertNumberToPhrase(1000000);
    expect(phrase, ' one million');
  });

  test('Should convert 0 to string zero', () {
    final String phrase1 = NumberConversionController.convertNumberToPhrase(0);
    expect(phrase1, 'zero');
  });

  test('Should convert 19 to string nineteen', () {
    final String phrase2 = NumberConversionController.convertNumberToPhrase(19);
    expect(phrase2, ' nineteen');
  });

  test('Should convert 3456 to string three thousand four hundred fifty six', () {
    final String phrase3 = NumberConversionController.convertNumberToPhrase(3456);
    expect(phrase3, ' three thousand four hundred  fifty six');
  });
}
