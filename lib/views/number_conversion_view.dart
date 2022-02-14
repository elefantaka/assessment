import 'package:arabic_numbers/controllers/number_conversion_controller.dart';
import 'package:flutter/material.dart';

class NumberConversionView extends StatefulWidget {
  const NumberConversionView({Key? key}) : super(key: key);

  @override
  State<NumberConversionView> createState() => _NumberConversionViewState();
}

class _NumberConversionViewState extends State<NumberConversionView> {
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
              children: <Widget>[
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
        phrase = NumberConversionController.convertNumberToPhrase(digit);
        setState(() {});
      },
      child: const Text('Convert'),
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(phrase);
  }
}
