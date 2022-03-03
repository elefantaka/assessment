import 'package:flutter/material.dart';
import 'package:arabic_numbers/models/validation_error_model.dart';

import '../controllers/api_controller.dart';
import '../models/user_model.dart';

enum Operation { add, update }

class UserEditorView extends StatefulWidget {
  final ApiController apiController;
  final Function() updateUsers;
  final Function(dynamic) showErrorSnackBar;
  final User? user;

  const UserEditorView(
      this.apiController, this.updateUsers, this.showErrorSnackBar,
      {this.user, Key? key})
      : super(key: key);

  @override
  State<UserEditorView> createState() => _UserEditorViewState();
}

class _UserEditorViewState extends State<UserEditorView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _firstNameformKey = GlobalKey<FormState>();
  final _lastNameformKey = GlobalKey<FormState>();
  List<String> firstNameErrors = [];
  List<String> lastNameErrors = [];
  @override
  Widget build(BuildContext context) {
    firstNameController.text = widget.user?.firstName ?? '';
    lastNameController.text = widget.user?.lastName ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add user'), //TODO: change to Operation.name
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _buildTextField(
                firstNameController, _firstNameformKey, 'First name'),
            _buildTextField(lastNameController, _lastNameformKey, 'Last name'),
            _buildButton(
                widget.user != null ? Operation.update : Operation.add),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, Key key, String text) {
    return TextFormField(
      key: key,
      validator: (value) {
        if (key == _firstNameformKey) {
          return firstNameErrors.isEmpty ? null : firstNameErrors.join(',');
        }
        return lastNameErrors.isEmpty ? null : lastNameErrors.join(',');
      },
      autovalidateMode: AutovalidateMode.always,
      decoration: InputDecoration(
        counterStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        hintText: text,
      ),
      controller: controller,
    );
  }

  Widget _buildButton(Operation operation) {
    return ElevatedButton(
        onPressed: () {
          if (operation == Operation.add) {
            widget.apiController
                .createUser(firstNameController.text, lastNameController.text)
                .then((_) => widget.updateUsers())
                .catchError((e) => _validationHandler(e),
                    test: (e) => e is ValidationError)
                .catchError(widget.showErrorSnackBar);
            return;
          }
          if (widget.user == null) return;
          widget.apiController
              .updateUser(widget.user!.id, firstNameController.text,
                  lastNameController.text)
              .then((_) => widget.updateUsers())
              .catchError((e) => _validationHandler(e),
                  test: (e) => e is ValidationError)
              .catchError(widget.showErrorSnackBar);
        },
        child: Text(operation.name));
  }

  void _validationHandler(dynamic err) {
    ValidationError validationError = err as ValidationError;

    firstNameErrors = validationError.firstName;
    lastNameErrors = validationError.lastName;

    if (_firstNameformKey.currentState != null) {
      _firstNameformKey.currentState!.validate();
    }
    if (_lastNameformKey.currentState != null) {
      _lastNameformKey.currentState!.validate();
    }
  }
}
