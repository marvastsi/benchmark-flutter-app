class LoggedInUser {
  final String userId;
  final String displayName;

  const LoggedInUser({
    required this.userId,
    required this.displayName,
  });
}

class Credentials {
  final String username;
  final String password;

  const Credentials({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }

  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials(username: json['username'], password: json['password']);
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class Token {
  final String type;
  final String value;

  const Token({required this.value, this.type = 'Bearer'});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      type: json['type'],
      value: json['value'],
    );
  }

  @override
  String toString() => '$type $value';
}
