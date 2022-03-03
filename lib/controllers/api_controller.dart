import 'dart:async';
import 'dart:convert';
import 'package:arabic_numbers/models/user_model.dart';
import 'package:arabic_numbers/models/validation_error_model.dart';
import 'package:http/http.dart';

import '../models/user_model.dart';

enum Status { active, locked }

/// if provided string will not match any status status locked will be returned by default
Status statusFromString(String s) {
  Status? status = <String, Status>{
    'locked': Status.locked,
    'active': Status.active,
  }[s];
  return status ?? Status.locked;
}

class ApiController {
  final Uri apiUri;
  final int timeout;
  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  ApiController(this.apiUri, this.timeout);

  Future<List<User>> fetchUsers() async {
    Response response = await get(apiUri, headers: defaultHeaders)
        .timeout(Duration(seconds: timeout), onTimeout: () {
      return Future.error('Timeout after: $timeout seconds');
    });

    if (response.statusCode ~/ 100 != 2) {
      return Future.error('Unexpected status code: ${response.statusCode}');
    }

    List<dynamic> responseJson = jsonDecode(response.body) as List<dynamic>;
    List<User> users =
        responseJson.map((dynamic item) => User.fromJson(item)).toList();
    users.sort(
        (User a, User b) => b.createdTimestamp.compareTo(a.createdTimestamp));
    return users;
  }

  Future<void> updateStatus(int id, Status status) async {
    final Response response = await patch(
      Uri.parse('$apiUri/$id'),
      headers: defaultHeaders,
      body: jsonEncode(
        <String, dynamic>{
          'status': status.name,
        },
      ),
    ).timeout(Duration(seconds: timeout), onTimeout: () {
      return Future.error('Timeout after: $timeout seconds');
    });
    if (response.statusCode ~/ 100 != 2) {
      return Future.error(
          'Failed to update user status, status code: ${response.statusCode}');
    }
  }

  Future<void> updateUser(int id, String firstName, String lastName) async {
    final Response response = await put(
      Uri.parse('$apiUri/$id'),
      headers: defaultHeaders,
      body: jsonEncode(
        <String, dynamic>{
          'first_name': firstName,
          'last_name': lastName,
        },
      ),
    );
    if (response.statusCode == 422) {
      return Future.error(
        ValidationError.fromJson(
          //FIXME: informowanie o błędach w widoku edycji danych użytkownika
          jsonDecode(response.body),
        ),
      );
    }
    if (response.statusCode ~/ 100 != 2) {
      return Future.error(
          'Failed to update user status status code: ${response.statusCode}');
    }
  }

  Future<void> createUser(String firstName, String lastName) async {
    Response response = await post(
      apiUri,
      headers: defaultHeaders,
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'status': Status.locked.name,
      }),
    ).timeout(Duration(seconds: timeout), onTimeout: () {
      return Future.error('Timeout after: $timeout seconds');
    });

    if (response.statusCode ~/ 100 != 2) {
      return Future.error(
          'Failed to create a new status code: ${response.statusCode} user');
    }
  }
}
