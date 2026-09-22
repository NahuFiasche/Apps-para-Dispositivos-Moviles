import 'package:exercise1_loginscreen/database_helpers/users_database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exercise1_loginscreen/entities/user.dart';
import 'package:collection/collection.dart';

class UsersNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    return await UsersDatabaseHelper.instance.getUsers();
  }

  Future<String?> addUser({
    required String newUsername,
    required String newMail,
    required String newPassword,
  }) async {
    int maxId = 0;

    if (existsUsername(newUsername.trim()) == true) {
      return 'Error. El nombre de usuario ya está en uso';
    }

    if (existsMail(newMail.trim()) == true) {
      return 'Error. El mail ya está en uso';
    }

    state = await AsyncValue.guard(() async {
      final List<User> currentUsersList = state.value ?? [];

      for (final user in currentUsersList) {
        final parsedId = int.tryParse(user.id);
        if (parsedId != null && parsedId > maxId) {
          maxId = parsedId;
        }
      }

      final String newId = (maxId + 1).toString();

      final User newUser = User(
        id: newId,
        mail: newMail.trim(),
        username: newUsername.trim(),
        password: newPassword.trim(),
      );

      await UsersDatabaseHelper.instance.addUser(newUser);

      return await UsersDatabaseHelper.instance.getUsers();
    });

    return null;
  }

  Future<String?> updatePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await validateLogin(username, currentPassword) == false) {
      return 'Error. La contraseña actual no es correcta';
    }

    final usersList = state.value ?? [];
    final currentUser = usersList.firstWhereOrNull(
      (u) => u.username == username,
    );

    if (currentUser == null) {
      return 'Error. No se encontró el usuario a actualizar';
    }

    if (currentPassword.trim() == newPassword.trim()) {
      return 'La nueva contraseña debe ser diferente a la actual';
    }

    state = await AsyncValue.guard(() async {
      final User updatedUser = currentUser.copyWith(
        password: newPassword.trim(),
      );

      await UsersDatabaseHelper.instance.updateUser(updatedUser);

      return await UsersDatabaseHelper.instance.getUsers();
    });

    return null;
  }

  Future<void> deleteUser(String usernameToDelete) async {
    state = await AsyncValue.guard(() async {
      final currentUsers = state.value ?? [];

      final userToDelete = currentUsers.firstWhereOrNull(
        (u) => u.username == usernameToDelete,
      );

      if (userToDelete != null) {
        await UsersDatabaseHelper.instance.deleteUser(userToDelete.id);
      }

      return await UsersDatabaseHelper.instance.getUsers();
    });
  }

  String? getUserPassword({String? userMail, String? username}) {
    final currentUsers = state.value ?? [];

    if (userMail != null) {
      String mailToFind = userMail.trim();

      final user = currentUsers.firstWhereOrNull(
        (u) => u.mail.trim() == mailToFind,
      );
      return user?.password;
    }

    if (username != null) {
      final usernameToFind = username.trim();

      final user = currentUsers.firstWhereOrNull(
        (u) => u.username.trim() == usernameToFind,
      );
      return user?.password;
    }

    return null;
  }

  Future<String?> getUsername(String userMail) async{
    final currentUsers = await future;
    String mailToFind = userMail.trim();

    final user = currentUsers.firstWhereOrNull(
      (u) => u.mail.trim() == mailToFind,
    );
    return user?.username;
  }

  Future<String?> getMail(String username) async{
    final currentUsers = await future;
    final usernameToFind = username.trim();

    final user = currentUsers.firstWhereOrNull(
      (u) => u.username.trim() == usernameToFind,
    );
    return user?.mail;
  }

  Future<bool> validateLogin(String username, String password) async {
    final currentUsers = await future;

    return currentUsers.any(
      (user) => user.username == username && user.password == password,
    );
  }

  bool existsUsername(String username) {
    final currentUsers = state.value ?? [];
    final cleanUsername = username.trim().toLowerCase();

    return currentUsers.any(
      (user) => user.username.trim().toLowerCase() == cleanUsername,
    );
  }

  bool existsMail(String mail) {
    final currentUsers = state.value ?? [];
    final cleanMail = mail.trim().toLowerCase();

    return currentUsers.any(
      (user) => user.mail.trim().toLowerCase() == cleanMail,
    );
  }
}

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<User>>(() {
  return UsersNotifier();
});
