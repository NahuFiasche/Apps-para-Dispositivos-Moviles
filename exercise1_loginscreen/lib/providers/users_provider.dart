import 'package:exercise1_loginscreen/data/users_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exercise1_loginscreen/entities/user.dart';

class UsersNotifier extends Notifier<List<User>> {
  @override
  List<User> build() {
    return usersDatasource;
  }

  String? addUser({required String newUsername, required String newMail, required String newPassword}) {
    int maxId = 0;

    if(existsUsername(newUsername) == true)
    {
      return 'Error. El nombre de usuario ya está en uso';
    }

    for (final user in state) {
      final parsedId = int.tryParse(user.id);

      if (parsedId != null) {
        if (parsedId > maxId) {
          maxId = parsedId;
        }
      }
    }

    final String newId = (maxId + 1).toString();

    final User newUser = User(
      id: newId,
      mail: newMail,
      username: newUsername,
      password: newPassword,
    );

    state = [...state, newUser];

    return null;
  }

  void updateUser(User updatedUser) {
    state = [
      for (final user in state)
        if (user.id == updatedUser.id) updatedUser else user,
    ];
  }

  void deleteUser(String id) {
    state = state.where((user) => user.id != id).toList();
  }

  bool existsUsername(String username) {
    final cleanUsername = username.trim().toLowerCase();

    for (final user in state) {
      if (user.username.trim().toLowerCase() == cleanUsername) {
        return true;
      }
    }

    return false;
  }

  bool validateLogin(String username, String password) {
    return state.any(
      (user) => user.username == username && user.password == password,
    );
  }
}

final usersProvider = NotifierProvider<UsersNotifier, List<User>>(() {
  return UsersNotifier();
});
