class User {
  final String id;
  final String mail;
  final String username;
  final String password;

  User({
    required this.id,
    required this.mail,
    required this.username,
    required this.password,
  });

  User copyWith({
    String? id,
    String? mail,
    String? username,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      mail: mail ?? this.mail,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
