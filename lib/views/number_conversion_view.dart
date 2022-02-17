import 'package:arabic_numbers/controllers/number_conversion_controller.dart';
import 'package:arabic_numbers/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberConversionView extends StatefulWidget {
  const NumberConversionView({Key? key}) : super(key: key);

  @override
  State<NumberConversionView> createState() => _NumberConversionViewState();
}

class _NumberConversionViewState extends State<NumberConversionView> {
  final TextEditingController _digitController = TextEditingController();
  final int _maxEnteredDigitLength = 27;
  String _phrase = ValueMapping.empty;
  bool _currentTheme = false;
  bool _icon = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            color: _currentTheme ? const Color(0xff512da8) : const Color(0xff9575cd),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildExpandedForTitle(context),
              _buildExpandedForDigitConverter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedForTitle(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTextTitle(context),
                const SizedBox(
                  height: 30.0,
                ),
                _buildIconButtonSelectTheme(context),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            _buildTextTitleDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextTitle(BuildContext context) {
    return const Text(
      ValueMapping.textConverter,
      style: TextStyle(color: Colors.white, fontSize: 46.0, fontWeight: FontWeight.w800),
    );
  }

  Widget _buildIconButtonSelectTheme(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _currentTheme = !_currentTheme;
          _icon = !_icon;
        });
      },
      icon: Icon(
        _currentTheme ? Icons.light_mode : Icons.dark_mode,
        color: _icon == false ? Colors.black : const Color(0xffffd54f),
      ),
      iconSize: 46.0,
    );
  }

  Widget _buildTextTitleDescription(BuildContext context) {
    return const Text(
      ValueMapping.textTitleDescription,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 19.0,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildExpandedForDigitConverter(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _currentTheme ? const Color(0xff546e7a) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextProgramDescription(context),
              _buildTextProgramDescriptionRange(context),
              const SizedBox(
                height: 40.0,
              ),
              _buildTextFieldEnterDigit(context),
              const SizedBox(
                height: 20.0,
              ),
              _buildTextPrintDigitPhrase(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextProgramDescription(BuildContext context) {
    return Text(
      ValueMapping.description,
      textAlign: TextAlign.left,
      style: TextStyle(color: _currentTheme ? Colors.white : Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextProgramDescriptionRange(BuildContext context) {
    return Text(
      ValueMapping.range,
      textAlign: TextAlign.left,
      style: TextStyle(color: _currentTheme ? Colors.white : Colors.black, fontSize: 20.0),
    );
  }

  Widget _buildTextFieldEnterDigit(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
      controller: _digitController,
      maxLength: _maxEnteredDigitLength,
      onChanged: (String? value) {
        if (_digitController.text.isEmpty) {
          setState(() {
            _phrase = ValueMapping.empty;
          });
          return;
        }
        setState(() {
          _phrase = NumberConversionController.convertNumberToPhrase(_digitController.text);
        });
        _buildTextPrintDigitPhrase(context);
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return ValueMapping.textErrorEmptyValue;
        }
        return null;
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        counterStyle: TextStyle(color: _currentTheme ? Colors.white : Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: _currentTheme ? Colors.white : const Color(0xffeeeeee),
        hintText: ValueMapping.textFieldMessage,
      ),
    );
  }

  Widget _buildTextPrintDigitPhrase(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
          _phrase,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: TextStyle(color: _currentTheme ? Colors.white : Colors.black, fontSize: 24.0),
        ),
      ),
    );
  }
}
