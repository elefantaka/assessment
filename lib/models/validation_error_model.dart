class ValidationError {
  final List<String> firstName;
  final List<String> lastName;

  ///Status field was omitted due to the fact that following the instructions user cannot set it while creating/adding a new account

  ValidationError(this.firstName, this.lastName);

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      json['first_name'].cast<String>(),
      json['last_name'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
