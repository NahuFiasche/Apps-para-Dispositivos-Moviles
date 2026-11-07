import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

/// Servicio de búsqueda de juegos usando la API pública de Steam.
///
/// 1) Búsqueda:  https://store.steampowered.com/api/storesearch/?term=...&l=spanish&cc=AR
/// 2) Detalles:  https://store.steampowered.com/api/appdetails?appids=...&l=spanish&cc=AR
///    (se consulta al agregar un juego, para traer la portada, la
///    descripción y el año de lanzamiento).
class SteamGamesService {
  static final SteamGamesService instance = SteamGamesService._internal();
  SteamGamesService._internal();

  static const String _storeHost = 'store.steampowered.com';
  static const String _language = 'spanish';
  static const String _countryCode = 'AR';

  /// Busca juegos por nombre en la tienda de Steam.
  ///
  /// Devuelve una lista de maps con: id, name y tiny_image.
  Future<List<Map<String, dynamic>>> searchGames(String query) async {
    final searchTerm = query.trim();
    if (searchTerm.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.https(_storeHost, '/api/storesearch/', {
          'term': searchTerm,
          'l': _language,
          'cc': _countryCode,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Steam respondió HTTP ${response.statusCode}: ${response.body}',
        );
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Respuesta inválida de Steam.');
      }

      final items = decoded['items'];
      if (items is! List) return [];

      return items
          .whereType<Map>()
          .where((item) => item['type'] == 'app')
          .map(
            (item) => {
              'id': item['id']?.toString() ?? '',
              'name': item['name'] ?? 'Sin nombre',
              'tiny_image': item['tiny_image'] is String
                  ? item['tiny_image']
                  : '',
            },
          )
          .toList();
    } catch (error, stackTrace) {
      developer.log(
        'Error buscando juegos en Steam: $error',
        name: 'SteamGamesService',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Trae los detalles de un appid: portada, descripción, año y desarrollador.
  ///
  /// Devuelve el mismo map de entrada enriquecido con esas claves.
  Future<Map<String, dynamic>> getGameDetails(
    Map<String, dynamic> searchResult,
  ) async {
    final appId = searchResult['id']?.toString() ?? '';
    if (appId.isEmpty) return searchResult;

    try {
      final response = await http.get(
        Uri.https(_storeHost, '/api/appdetails', {
          'appids': appId,
          'l': _language,
          'cc': _countryCode,
        }),
      );

      if (response.statusCode != 200) {
        developer.log(
          'appdetails respondió HTTP ${response.statusCode} para appid $appId',
          name: 'SteamGamesService',
        );
        return searchResult;
      }

      final decoded = json.decode(response.body);
      final payload = decoded is Map ? decoded[appId] : null;
      final success = payload is Map ? payload['success'] == true : false;
      final data = payload is Map ? payload['data'] : null;
      if (!success || data is! Map) return searchResult;

      final releaseDate = data['release_date'];
      final releaseString = releaseDate is Map
          ? releaseDate['date']?.toString() ?? ''
          : '';

      // La fecha viene localizada (ej. "8 dic 2015"): extraemos el año
      // buscando el primer número de 4 dígitos.
      final yearMatch = RegExp(r'\d{4}').firstMatch(releaseString);

      // Carátula vertical estilo DVD de la biblioteca de Steam. No existe
      // para todos los juegos: la verificamos y si falla usamos el banner
      // horizontal como reserva.
      final headerImage = data['header_image'] is String
          ? data['header_image']
          : '';
      final libraryCover =
          'https://cdn.cloudflare.steamstatic.com/steam/apps/$appId/library_600x900_2x.jpg';
      final cover = await _urlExists(libraryCover) ? libraryCover : headerImage;

      return {
        ...searchResult,
        'gameCover': cover.isNotEmpty ? cover : searchResult['tiny_image'],
        'description': data['short_description']?.toString() ?? '',
        'releaseYear': yearMatch?.group(0) ?? '',
        'developer': data['developers'] is List &&
                (data['developers'] as List).isNotEmpty
            ? (data['developers'] as List).first.toString()
            : '',
      };
    } catch (error, stackTrace) {
      developer.log(
        'Error trayendo detalles de Steam para appid $appId: $error',
        name: 'SteamGamesService',
        error: error,
        stackTrace: stackTrace,
      );
      return searchResult;
    }
  }

  /// Devuelve true si la URL responde con un código 2xx.
  static Future<bool> _urlExists(String url) async {
    if (url.isEmpty) return false;
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}
