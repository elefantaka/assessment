import 'package:arabic_numbers/utils/strings.dart';

class NumberConversionController {
  static const String _million = 'million';
  static const String _thousand = 'thousand';
  static const String _hundred = 'hundred';
  static const String _zero = 'zero';

  static String convertNumberToPhrase(int x) {
    if (x == 0) {
      return _zero;
    }

    String xToString = x.toString().padLeft(9, '0');

    int millions = int.parse(xToString.substring(0, 3));
    int hundredThousands = int.parse(xToString.substring(3, 6));
    int thousands = int.parse(xToString.substring(6, 9));

    String findMillions = _getMillions(millions);
    String currentPhrase = findMillions;

    String findHundredThousand = _getThousands(hundredThousands);
    currentPhrase = currentPhrase + findHundredThousand;

    String findThousand = _convertLessThanOneThousand(thousands);
    currentPhrase = currentPhrase + findThousand;

    return currentPhrase;
  }

  static String _getMillions(int millions) {
    String findMillions;
    switch (millions) {
      case 0:
        findMillions = '';
        break;
      case 1:
        findMillions = _convertLessThanOneThousand(millions) + ' ' + _million;
        break;
      default:
        findMillions = _convertLessThanOneThousand(millions) + ' ' + _million;
    }
    return findMillions;
  }

  static String _getThousands(int thousands) {
    String findThousands;
    switch (thousands) {
      case 0:
        findThousands = '';
        break;
      case 1:
        findThousands = _convertLessThanOneThousand(thousands) + ' ' + _thousand;
        break;
      default:
        findThousands = _convertLessThanOneThousand(thousands) + ' ' + _thousand;
    }

    return findThousands;
  }

  //1-999
  static String _convertLessThanOneThousand(int x) {
    final List<String> singleAndTwoDigits = getSingleAndTwoDigits();
    final List<String> tensDigits = getTensDigits();

    String currentPhrase;

    if (x % 100 < 20) {
      currentPhrase = singleAndTwoDigits[x % 100];
      x = (x ~/ 100).toInt();
    } else {
      currentPhrase = singleAndTwoDigits[x % 10];
      x = (x ~/ 10).toInt();

      currentPhrase = tensDigits[x % 10] + currentPhrase;
      x = (x ~/ 10).toInt();
    }
    if (x == 0) {
      return currentPhrase;
    }
    return singleAndTwoDigits[x] + ' ' + _hundred + currentPhrase;
  }
}
