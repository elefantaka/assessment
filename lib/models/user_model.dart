import 'package:intl/intl.dart';
import '../controllers/api_controller.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final Status status;
  final String createdAt;
  final int createdTimestamp;
  final String updatedAt;

  User(this.id, this.firstName, this.lastName, this.status, this.createdAt,
      this.createdTimestamp, this.updatedAt);

  Map<String, dynamic> toJson({String? firstName, String? lastName}) {
    return {
      'first_name': firstName ?? this.firstName,
      'last_name': lastName ?? this.lastName,
      'status': status,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final DateTime time = DateTime.parse(json['created_at'].toString());
    final DateFormat formatter = DateFormat('dd/MM/yy HH:mm:ss');
    final Status status = statusFromString(json['status']);
    return User(
      json['id'] as int,
      json['first_name'] as String,
      json['last_name'] as String,
      status,
      formatter.format(time),
      time.millisecondsSinceEpoch,
      json['updated_at'] as String,
    );
  }
}
