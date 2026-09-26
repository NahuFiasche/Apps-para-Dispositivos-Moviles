class User {
  final String id;
  final String mail;
  final String username;
  final String password;
  final String? profilePicture;

  User({
    required this.id,
    required this.mail,
    required this.username,
    required this.password,
    this.profilePicture
  });

  User copyWith({
    String? id,
    String? mail,
    String? username,
    String? password,
    String? profilePicture,
  }) {
    return User(
      id: id ?? this.id,
      mail: mail ?? this.mail,
      username: username ?? this.username,
      password: password ?? this.password,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
