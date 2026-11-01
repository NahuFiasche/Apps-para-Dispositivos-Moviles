import 'package:exercise1_loginscreen/database_helpers/users_database_helper.dart';

class UsersProvider {
  static final UsersProvider instance = UsersProvider._internal();

  UsersProvider._internal();

  Future<void> signIn(String email, String password) async {
    await UsersDatabaseHelper.instance.signIn(email, password);
  }

  Future<String?> createUser({
    required String newMail,
    required String newPassword,
    String? newProfilePicture,
  }) async {
    //TODO: Implementar carga de Imagen de Perfil en Firebase Storage

    await UsersDatabaseHelper.instance.createAccount(newMail, newPassword);

    return null;
  }

  Future<String?> updatePassword({
    required String userMail,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await signIn(userMail, currentPassword);
    } catch (e) {
      return "La contraseña actual no es correcta";
    }

    if (currentPassword.trim() == newPassword.trim()) {
      return 'La nueva contraseña debe ser diferente a la actual';
    }

    await UsersDatabaseHelper.instance.updatePassword(newPassword);

    return null;
  }

  Future<String?> updateProfilePicture({
    required String username,
    required String newProfilePicture,
  }) async {
    //TODO: Manejo de Profile Picture
    /*
    final usersList = await future;

    final currentUser = usersList.firstWhereOrNull(
      (u) => u.username.trim() == username.trim(),
    );

    if (currentUser == null) {
      return 'Error. No se encontró el usuario a actualizar';
    }

    state = await AsyncValue.guard(() async {
      final UserData updatedUser = currentUser.copyWith(
        profilePicture: newProfilePicture,
      );

      await UsersDatabaseHelper.instance.updateUser(updatedUser);

      return await UsersDatabaseHelper.instance.getUsers();
    });*/

    return null;
  }

  Future<void> deleteUser() async {
    await UsersDatabaseHelper.instance.deleteAccount();
  }

  String? getProfilePicture(String username) {
    /*final currentUsers = state.value ?? [];
    final usernameToFind = username.trim();

    final userProfilePicture = currentUsers.firstWhereOrNull(
      (u) => u.username.trim() == usernameToFind,
    );

    return userProfilePicture?.profilePicture;*/
    //TODO: Implementar getProfilePicture
    return null;
  }
}
