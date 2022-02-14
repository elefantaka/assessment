import 'package:arabic_numbers/utils/strings.dart';

class NumberConversionController {
  static String convertNumberToPhrase(int userInput) {
    if (userInput == 0) {
      return Strings.zero;
    }

    String userInputString = userInput.toString().padLeft(9, '0');

    int millionsNumberPart = int.parse(userInputString.substring(0, 3));
    int hundredThousandsNumberPart = int.parse(userInputString.substring(3, 6));
    int thousandsNumberPart = int.parse(userInputString.substring(6, 9));

    String findMillions = _getMillions(millionsNumberPart);
    String phraseToPrint = findMillions;

    String findHundredThousand = _getThousands(hundredThousandsNumberPart);
    phraseToPrint += findHundredThousand;

    String findThousand = _convertLessThanOneThousand(thousandsNumberPart);
    phraseToPrint += findThousand;

    return phraseToPrint;
  }

  static String _getMillions(int millions) {
    String findMillions;
    if (millions == 0) {
      return Strings.emptyString;
    } else {
      findMillions = '${_convertLessThanOneThousand(millions)} ${Strings.million}';
      return findMillions;
    }
  }

  static String _getThousands(int thousands) {
    String findThousands;
    if (thousands == 0) {
      return Strings.emptyString;
    } else {
      findThousands = '${_convertLessThanOneThousand(thousands)} ${Strings.thousand}';
      return findThousands;
    }
  }

  static String _convertLessThanOneThousand(int x) {
    const List<String> singleAndTwoDigits = Strings.singleAndTwoDigits;
    const List<String> tensDigits = Strings.tensDigits;

    String currentPhrase;
    int currentX = x;

    if (currentX % 100 < 20) {
      currentPhrase = singleAndTwoDigits[currentX % 100];
      currentX = (currentX ~/ 100).toInt();
    } else {
      currentPhrase = singleAndTwoDigits[currentX % 10];
      currentX = (currentX ~/ 10).toInt();

      currentPhrase = tensDigits[currentX % 10] + currentPhrase;

      currentX = (currentX ~/ 10).toInt();
    }
    if (currentX == 0) {
      return currentPhrase;
    }
    return '${singleAndTwoDigits[currentX]} ${Strings.hundred} $currentPhrase';
  }
}
