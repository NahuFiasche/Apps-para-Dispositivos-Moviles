import 'package:firebase_auth/firebase_auth.dart';

class UsersDatabaseHelper {
  UsersDatabaseHelper._init();

  static final UsersDatabaseHelper instance = UsersDatabaseHelper._init();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<dynamic> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException {
      rethrow; // Deja pasar el código de error original para poder mapearlo
    } catch (e) {
      throw Exception('Error al iniciar sesión: ${e.toString()}');
    }
  }

  Future<User?> createAccount(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException {
      rethrow; // Deja pasar el código de error original para poder mapearlo
    } catch (e) {
      throw Exception('Error al crear usuario: ${e.toString()}');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No hay un usuario conectado.');

      await user.delete();

    } catch (e) {
      throw Exception('Error al eliminar la cuenta: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      throw Exception('Error al actualizar la contraseña: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow; // Deja pasar el código de error original para poder mapearlo
    } catch (e) {
      throw Exception(
        'Error al solicitar cambio de contraseña: ${e.toString()}',
      );
    }
  }
}
