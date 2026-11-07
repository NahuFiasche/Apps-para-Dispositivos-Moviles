import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

/// Servicio de búsqueda de juegos usando la API pública de Steam.
///
/// 1) Búsqueda:  https://store.steampowered.com/api/storesearch/?term=...&l=spanish&cc=AR
/// 2) Detalles:  https://store.steampowered.com/api/appdetails?appids=...&l=spanish&cc=AR
///    (se consulta al agregar un juego, para traer descripción, developers,
///    géneros, fecha de lanzamiento y screenshots).
class SteamGamesService {
  static final SteamGamesService instance = SteamGamesService._internal();
  SteamGamesService._internal();

  static const String _storeHost = 'store.steampowered.com';

  /// Idioma y país para las consultas.
  static const String _language = 'spanish';
  static const String _countryCode = 'AR';

  /// Busca juegos por nombre en la tienda de Steam.
  ///
  /// Devuelve una lista de maps con: id (appid), name, tiny_image,
  /// metascore, platforms y price.
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
          .map((item) => Map<String, dynamic>.from(item))
          .map(_mapSearchResult)
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

  /// Trae los detalles completos de un appid (descripción, developers,
  /// publishers, géneros, fecha, plataformas, precio y screenshots).
  ///
  /// Devuelve el mismo formato que [searchGames] pero enriquecido, listo
  /// para convertirlo en un objeto [Game].
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

      return _mergeDetails(searchResult, data);
    } catch (error, stackTrace) {
      developer.log(
        'Error trayendo detalles de Steam para appid $appId: $error',
        name: 'SteamGamesService',
        error: error,
        stackTrace: stackTrace,
      );
      // Ante un fallo de detalles devolvemos al menos el resultado básico.
      return searchResult;
    }
  }

  Map<String, dynamic> _mapSearchResult(Map item) {
    final platforms = item['platforms'];
    final price = item['price'];

    return {
      'id': item['id']?.toString() ?? '',
      'name': item['name'] ?? 'Sin nombre',
      // Imagen chica de la cápsula (para el listado de resultados).
      'background_image': item['tiny_image'] is String
          ? item['tiny_image']
          : '',
      'images': <String>[],
      'overview': '',
      'developers': '',
      'publishers': '',
      'genres': '',
      'platform': _platformsToString(platforms),
      'metascore': item['metascore']?.toString() ?? '',
      'price': price is Map
          ? '${(price['final'] as num? ?? 0) / 100} ${price['currency'] ?? ''}'
          : '',
      'released': 'Desconocido',
    };
  }

  Map<String, dynamic> _mergeDetails(Map<String, dynamic> base, Map data) {
    final releaseDate = data['release_date'];
    final releaseString = releaseDate is Map
        ? releaseDate['date']?.toString() ?? ''
        : '';

    // Carátula (header_image) + hasta 2 screenshots en tamaño grande.
    final images = <String>[];
    final header = data['header_image'];
    if (header is String && header.isNotEmpty) images.add(header);
    final screenshots = data['screenshots'];
    if (screenshots is List) {
      for (final shot in screenshots.whereType<Map>().take(2)) {
        final full = shot['path_full'];
        if (full is String && full.isNotEmpty) images.add(full);
      }
    }

    return {
      ...base,
      'name': data['name'] ?? base['name'],
      'background_image': images.isNotEmpty ? images.first : base['background_image'],
      'images': images.take(3).toList(),
      'overview': data['short_description']?.toString() ?? '',
      'developers': _joinStrings(data['developers']),
      'publishers': _joinStrings(data['publishers']),
      'genres': _joinGenres(data['genres']),
      'released': releaseString.isNotEmpty ? releaseString : base['released'],
      'platform': _platformsToString(data['platforms']) ?? base['platform'],
      'rating': double.tryParse(base['metascore']?.toString() ?? '') ?? 0.0,
      'steam_url': base['id'] != null
          ? 'https://store.steampowered.com/app/${base['id']}'
          : '',
    };
  }

  String? _platformsToString(Object? platforms) {
    if (platforms is! Map) return null;
    final names = <String>[
      if (platforms['windows'] == true) 'Windows',
      if (platforms['mac'] == true) 'macOS',
      if (platforms['linux'] == true) 'Linux',
    ];
    return names.isEmpty ? null : names.join(', ');
  }

  String _joinStrings(Object? list) {
    if (list is! List) return '';
    return list
        .map((item) => item?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .join(', ');
  }

  String _joinGenres(Object? list) {
    if (list is! List) return '';
    return list
        .whereType<Map>()
        .map((item) => item['description']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .join(', ');
  }
}
