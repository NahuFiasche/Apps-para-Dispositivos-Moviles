import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class UsersStorageHelper {
  static final UsersStorageHelper instance = UsersStorageHelper._internal();
  UsersStorageHelper._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfilePicture(String uid, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$uid.jpg');

      await ref.putFile(imageFile);

      final downloadUrl = await ref.getDownloadURL();
      
      return downloadUrl;
      
    } catch (e) {
      throw Exception('Error al subir la imagen a Storage: ${e.toString()}');
    }
  }

  Future<String> uploadProfilePictureFromUrl(String uid, String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode != 200) {
      throw Exception('Error al descargar la imagen: HTTP ${response.statusCode}');
    }

    final Uint8List imageBytes = response.bodyBytes;
    final ref = _storage.ref().child('profile_pictures/$uid.jpg');

    await ref.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return ref.getDownloadURL();
  }

  Future<void> deleteProfilePicture(String uid) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$uid.jpg');
      await ref.delete();
    } catch (e) {
      // Si el usuario no tenía foto, ignoramos el error
    }
  }
}