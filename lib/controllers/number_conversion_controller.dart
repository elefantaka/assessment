import 'package:arabic_numbers/utils/strings.dart';

class NumberConversionController {
  static String convertNumberToPhrase(String userInput) {
    if (userInput == '0') {
      return ValueMapping.zero;
    }

    String input = userInput;

    List<int> segments = <int>[];

    int modulo = userInput.length % 3;

    if (modulo != 0) {
      int value = int.parse(input.substring(0, modulo));
      segments.add(value);
      input = input.substring(modulo, input.length);
    }
    for (; input.isNotEmpty; input = input.substring(3, input.length)) {
      int value = int.parse(input.substring(0, 3));
      segments.add(value);
    }

    List<String> output = <String>[];

    segments.asMap().forEach((int index, int value) {
      int suffixIndex = segments.length - index - 1;
      String suffix = ValueMapping.suffixes[suffixIndex].toString();
      for (String string in _translateSegment(value, suffix)) {
        if (string.isEmpty) {
          continue;
        }
        output.add(string);
      }
      bool isLastSegment = index != segments.length - 1;
      if (isLastSegment && segments[index + 1] < 100 && segments[index + 1] != 0) {
        output.add(ValueMapping.and);
      }
    });

    return output.join(' ');
  }

  static List<String> _translateSegment(int inputValue, String suffix) {
    int value = inputValue;
    List<String> output = <String>[];
    if (value >= 100) {
      output.addAll(<String>[ValueMapping.smallValues[value ~/ 100].toString(), ValueMapping.hundred]);
      value = value % 100;
      if (value > 0) {
        output.add(ValueMapping.and);
      }
    }
    if (value >= 20) {
      String string = ValueMapping.tens[value ~/ 10].toString();
      value = value % 10;
      if (value > 0) {
        string = '$string-${ValueMapping.smallValues[value].toString()}';
        value = 0;
      }
      output.add(string);
    }
    output.addAll(<String>[ValueMapping.smallValues[value].toString(), suffix]);

    return output;
  }
}
