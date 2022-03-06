import 'dart:async';

import 'package:flutter/material.dart';
import 'package:arabic_numbers/models/validation_error_model.dart';

import '../controllers/api_controller.dart';
import '../models/user_model.dart';
import '../utils/strings.dart';

enum Operation { add, update }

class UserEditorView extends StatefulWidget {
  final ApiController apiController;
  final Function() updateUsers;
  final Function(Object) showErrorSnackBar;
  final User? user;

  const UserEditorView(this.apiController, this.updateUsers, this.showErrorSnackBar, {this.user, Key? key}) : super(key: key);

  @override
  State<UserEditorView> createState() => _UserEditorViewState();
}

class _UserEditorViewState extends State<UserEditorView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _editUserFormKey = GlobalKey<FormState>();

  List<String> _firstNameErrors = [];
  List<String> _lastNameErrors = [];

  @override
  Widget build(BuildContext context) {
    firstNameController.text = widget.user?.firstName ?? Strings.empty;
    lastNameController.text = widget.user?.lastName ?? Strings.empty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Hero(
          tag: 'editUser',
          child: Material(
            color: Colors.indigo[300],
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _editUserFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            cursorColor: Colors.indigo[500],
            validator: (value) {
              return _firstNameErrors.isNotEmpty ? _firstNameErrors.join(',') : null;
            },
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.indigo[100],
              counterStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              hintText: Strings.firstNameText,
            ),
            controller: firstNameController,
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            cursorColor: Colors.indigo[500],
            validator: (value) {
              return _lastNameErrors.isNotEmpty ? _lastNameErrors.join(',') : null;
            },
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.indigo[100],
              counterStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              hintText: Strings.lastNameText,
            ),
            controller: lastNameController,
          ),
          _buildButton(widget.user != null ? Operation.update : Operation.add),
        ],
      ),
    );
  }

  Widget _buildButton(Operation operation) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.indigo[500],
        ),
        onPressed: () {
          if (operation == Operation.add) {
            widget.apiController
                .createUser(firstNameController.text, lastNameController.text)
                .catchError((e) => _validationHandler(e), test: (err) => err is ValidationError)
                .then((_) => widget.updateUsers())
                .catchError((e) => widget.showErrorSnackBar(e));
            return;
          }
          if (widget.user == null) return;
          widget.apiController
              .updateUser(widget.user!.id, firstNameController.text, lastNameController.text)
              .catchError((e) => _validationHandler(e), test: (err) => err is ValidationError)
              .then((_) => widget.updateUsers())
              .catchError((e) => widget.showErrorSnackBar(e));
        },
        child: Text(operation.name));
  }

  void _validationHandler(Object err) async {
    ValidationError validationError = err as ValidationError;
    if (validationError.firstName.isNotEmpty) {
      validationError.firstName[0] = 'First name: ${validationError.firstName[0]}';
    }
    if (validationError.lastName.isNotEmpty) {
      validationError.lastName[0] = 'Last name: ${validationError.lastName[0]}';
    }
    _firstNameErrors = validationError.firstName;
    _lastNameErrors = validationError.lastName;
    _editUserFormKey.currentState?.validate();
  }
}
