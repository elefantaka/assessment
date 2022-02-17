class ValueMapping {
  static const String empty = '';
  static const String and = 'and';
  static const String hundred = 'hundred';
  static const String zero = 'zero';

  static const String description = 'Please enter a number in range';
  static const String range = '[0, 999 999 999 999 999 999 999 999 999]';
  static const String textConverter = 'Converter';
  static const String textTitleDescription = 'Arabic number conversion tool';
  static const String textErrorEmptyValue = 'Please enter some text';
  static const String textFieldMessage = 'Enter digit';

  static const List<String> suffixes = <String>[
    '',
    'thousand',
    'million',
    'billion',
    'trillion',
    'quadrillion',
    'quintillion',
    'sextillion',
    'septillion',
  ];

  static const Map<int, String> tens = <int, String>{
    2: 'twenty',
    3: 'thirty',
    4: 'forty',
    5: 'fifty',
    6: 'sixty',
    7: 'seventy',
    8: 'eighty',
    9: 'ninety',
  };

  static const Map<int, String> smallValues = <int, String>{
    0: '',
    1: 'one',
    2: 'two',
    3: 'three',
    4: 'four',
    5: 'five',
    6: 'six',
    7: 'seven',
    8: 'eight',
    9: 'nine',
    10: 'ten',
    11: 'eleven',
    12: 'twelve',
    13: 'thirteen',
    14: 'fourteen',
    15: 'fifteen',
    16: 'sixteen',
    17: 'seventeen',
    18: 'eighteen',
    19: 'nineteen',
  };
}
