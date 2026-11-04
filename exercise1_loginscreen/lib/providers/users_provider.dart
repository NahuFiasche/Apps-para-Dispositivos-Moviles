import 'package:exercise1_loginscreen/database_helpers/users_database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersProvider {
  static final UsersProvider instance = UsersProvider._internal();

  UsersProvider._internal();

  Future<String?> signIn(String email, String password) async {
    try {
      await UsersDatabaseHelper.instance.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      return switch (e.code) {
        'invalid-email' => 'El mail ingresado no es válido',
        'user-not-found' => 'No existe una cuenta con ese mail',
        'wrong-password' ||
        'invalid-credential' => 'El usuario o la contraseña son incorrectos',
        'user-disabled' => 'Esta cuenta fue deshabilitada',
        'too-many-requests' =>
          'Demasiados intentos fallidos. Intentá de nuevo más tarde',
        'network-request-failed' => 'Error de conexión. Intentá de nuevo',
        _ => 'Error al iniciar sesión: ${e.message ?? e.code}',
      };
    } catch (e) {
      return 'Error al iniciar sesión: ${e.toString()}';
    }

    return null;
  }

  Future<String?> createUser({
    required String newMail,
    required String newPassword,
    String? newProfilePicture,
  }) async {
    //TODO: Implementar carga de Imagen de Perfil en Firebase Storage

    try {
      await UsersDatabaseHelper.instance.createAccount(newMail, newPassword);
    } on FirebaseAuthException catch (e) {
      return switch (e.code) {
        'email-already-in-use' => 'El mail ya está registrado',
        'invalid-email' => 'El mail ingresado no es válido',
        'weak-password' => 'La contraseña debe tener al menos 6 caracteres',
        'operation-not-allowed' =>
          'El registro con Email/Contraseña está deshabilitado en Firebase',
        'network-request-failed' => 'Error de conexión. Intentá de nuevo',
        _ => 'Error al crear el usuario: ${e.message ?? e.code}',
      };
    } catch (e) {
      return 'Error al crear el usuario: ${e.toString()}';
    }

    return null;
  }

  Future<String?> updatePassword({
    required String userMail,
    required String currentPassword,
    required String newPassword,
  }) async {
    final String? signInError = await signIn(userMail, currentPassword);

    if (signInError != null) {
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

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await UsersDatabaseHelper.instance.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      return switch (e.code) {
        'invalid-email' => 'El mail ingresado no es válido',
        'user-not-found' => 'No existe una cuenta con ese mail',
        'network-request-failed' => 'Error de conexión. Intentá de nuevo',
        _ => 'Error al enviar el mail: ${e.message ?? e.code}',
      };
    } catch (e) {
      return 'Error al enviar el mail: ${e.toString()}';
    }

    return null;
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
