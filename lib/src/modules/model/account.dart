

class Account {
  final String? id;
  final String firstName;
  final String? lastName;
  final String email;
  final String phoneNumber;
  final String phoneCountryCode;
  final bool active;
  final bool notification;
  final String username;
  final String password;

  Account(
    this.id, {
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.phoneCountryCode,
    required this.active,
    required this.notification,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_ame': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'phone_country_code': phoneCountryCode,
      'active': active,
      'notification': notification,
      'username': username,
      'password': password
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      phoneCountryCode: json['phone_country_code'],
      active: json['id'],
      notification: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class AccountCreated {
  final String? id;

  AccountCreated(this.id);

  factory AccountCreated.fromJson(Map<String, dynamic> json) {
    return AccountCreated(
      json['accountId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'account_id': id};
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
