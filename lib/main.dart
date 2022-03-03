import 'package:flutter/material.dart';
import 'package:arabic_numbers/views/user_list_view.dart';
import 'package:arabic_numbers/controllers/api_controller.dart';

const apiURL = 'https://assessment-users-backend.herokuapp.com/users';
const timeout = 5;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: UserListView(
      ApiController(Uri.parse(apiURL), timeout),
    ));
  }
}
