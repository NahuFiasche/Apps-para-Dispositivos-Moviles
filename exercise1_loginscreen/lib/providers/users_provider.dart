import 'dart:io';

import 'package:exercise1_loginscreen/helpers/users_database_helper.dart';
import 'package:exercise1_loginscreen/helpers/users_storage_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

Future<String?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;

      // serverClientId = Web client ID de OAuth (Firebase Console -> Authentication
      // -> Sign-in method -> Google). Es obligatorio en Android con google_sign_in v7.
      await googleSignIn.initialize(
        serverClientId: '589594551779-1eh07u3g3s3129i1g7ttknjnk6nfc2pj.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final idToken = googleUser.authentication.idToken;

      final credential = GoogleAuthProvider.credential(idToken: idToken);

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null && user.photoURL == null && googleUser.photoUrl != null) {
        final photoUrl = await UsersStorageHelper.instance.uploadProfilePictureFromUrl(
          user.uid,
          googleUser.photoUrl!,
        );
        await user.updatePhotoURL(photoUrl);
      }

      return null; 
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // El usuario canceló el login (cerró el popup)
        return 'Inicio de sesión cancelado';
      }
      return 'Error al iniciar sesión con Google: ${e.description ?? e.code}';
    } on FirebaseAuthException catch (e) {
      return switch (e.code) {
        'account-exists-with-different-credential' => 'Ya existe una cuenta con este correo pero con otro método de acceso.',
        'invalid-credential' => 'Las credenciales de Google no son válidas.',
        _ => 'Error de autenticación con Google: ${e.message ?? e.code}',
      };
    } catch (e) {
      return 'Error al iniciar sesión con Google: ${e.toString()}';
    }
  }

  Future<String?> signUp({
    required String newMail,
    required String newPassword,
    String? newProfilePicture,
  }) async {

    try {
      await UsersDatabaseHelper.instance.createAccount(newMail, newPassword);

      if (newProfilePicture != null && newProfilePicture.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        File imageFile = File(newProfilePicture);

        final downloadUrl = await UsersStorageHelper.instance.uploadProfilePicture(
          user.uid,
          imageFile,
        );

        await user.updatePhotoURL(downloadUrl);
        }
      }

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
      return 'Error al crear el usuario o subir la imagen: ${e.toString()}';    
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

  Future<void> deleteUser() async {
          final user = FirebaseAuth.instance.currentUser;
    await UsersStorageHelper.instance.deleteProfilePicture(user!.uid);

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

  Future<String?> updateProfilePicture({required String imagePath}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return 'No hay un usuario activo para actualizar la foto.';
      }

      File imageFile = File(imagePath);

      final downloadUrl = await UsersStorageHelper.instance.uploadProfilePicture(
        user.uid,
        imageFile,
      );

      await user.updatePhotoURL(downloadUrl);

      await user.reload();

      return null; 
    } catch (e) {
      return 'Error al subir la imagen de perfil: ${e.toString()}';
    }
  }

  String? getProfilePicture() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.photoURL;
  }
}
