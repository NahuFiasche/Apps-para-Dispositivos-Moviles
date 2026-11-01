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
    } catch (e) {
      throw Exception('Error al crear usuario: ${e.toString()}');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No hay un usuario conectado.');

      await user.delete();

      //TODO: Si también subiste su foto a Storage, podés aprovechar este momento para borrarla de la carpeta usando su UID antes o después de esto.
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
    } catch (e) {
      throw Exception(
        'Error al solicitar cambio de contraseña: ${e.toString()}',
      );
    }
  }
}
