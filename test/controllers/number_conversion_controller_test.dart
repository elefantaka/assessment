import 'package:arabic_numbers/controllers/number_conversion_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should convert 7 to string seven', () {
    final String phrase = NumberConversionController.convertNumberToPhrase('7');
    expect(phrase, 'seven');
  });

  test('Should convert 42 to string forty-two', () {
    final String phrase1 = NumberConversionController.convertNumberToPhrase('42');
    expect(phrase1, 'forty-two');
  });

  test('Should convert 1999 to string one thousand nine hundred and ninety-nine', () {
    final String phrase2 = NumberConversionController.convertNumberToPhrase('1999');
    expect(phrase2, 'one thousand nine hundred and ninety-nine');
  });

  test('Should convert 2001 to string two thousand and one', () {
    final String phrase3 = NumberConversionController.convertNumberToPhrase('2001');
    expect(phrase3, 'two thousand and one');
  });

  test('Should convert 17999 to string seventeen thousand nine hundred and ninety-nine', () {
    final String phrase3 = NumberConversionController.convertNumberToPhrase('17999');
    expect(phrase3, 'seventeen thousand nine hundred and ninety-nine');
  });

  test('Should convert 342251 to string three hundred and forty-two thousand two hundred and fifty-one', () {
    final String phrase3 = NumberConversionController.convertNumberToPhrase('342251');
    expect(phrase3, 'three hundred and forty-two thousand two hundred and fifty-one');
  });

  test('Should convert 1300420 to string one million three hundred thousand four hundred and twenty', () {
    final String phrase3 = NumberConversionController.convertNumberToPhrase('1300420');
    expect(phrase3, 'one million three hundred thousand four hundred and twenty');
  });
}
