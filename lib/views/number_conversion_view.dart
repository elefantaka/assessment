import 'package:flutter/material.dart';
import 'package:arabic_numbers/utils/strings.dart';

class NumberConversionView extends StatefulWidget {
  const NumberConversionView({Key? key}) : super(key: key);

  @override
  State<NumberConversionView> createState() => _NumberConversionViewState();
}

class _NumberConversionViewState extends State<NumberConversionView> {
  final String million = 'million';
  final String thousand = 'thousand';
  final String hundred = 'hundred';
  final String zero = 'zero';

  String phrase = '';

  final TextEditingController _digitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Number to phrase'),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                _buildTextField(context),
                _buildElevatedButton(context),
                _buildText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      controller: _digitController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter digit',
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        int digit = int.parse(_digitController.text);
        phrase = _convertNumberToPhrase(digit);
        setState(() {});
      },
      child: const Text('Convert'),
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(phrase);
  }

  //0 - 999 999 999

  String _convertNumberToPhrase(int x) {
    if (x == 0) {
      return zero;
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

  String _getMillions(int millions) {
    String findMillions;
    switch (millions) {
      case 0:
        findMillions = '';
        break;
      case 1:
        findMillions = _convertLessThanOneThousand(millions) + ' ' + million;
        break;
      default:
        findMillions = _convertLessThanOneThousand(millions) + ' ' + million;
    }
    return findMillions;
  }

  String _getThousands(int thousands) {
    String findThousands;
    switch (thousands) {
      case 0:
        findThousands = '';
        break;
      case 1:
        findThousands = _convertLessThanOneThousand(thousands) + ' ' + thousand;
        break;
      default:
        findThousands = _convertLessThanOneThousand(thousands) + ' ' + thousand;
    }

    return findThousands;
  }

  //1-999
  String _convertLessThanOneThousand(int x) {
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
    return singleAndTwoDigits[x] + ' ' + hundred + currentPhrase;
  }
}
