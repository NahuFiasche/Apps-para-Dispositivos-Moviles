import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise1_loginscreen/data/games_datasource.dart';
import 'package:exercise1_loginscreen/entities/games.dart';

class GamesDatabaseHelper {
  GamesDatabaseHelper._init();

  static final GamesDatabaseHelper instance = GamesDatabaseHelper._init();

  final CollectionReference _gamesCollection = FirebaseFirestore.instance
      .collection('games');

  Future<List<Game>> getGames() async {
    final snapshot = await _gamesCollection.get();

    if (snapshot.docs.isEmpty) {
      await _initializeDefaultGames();
      final freshSnapshot = await _gamesCollection.get();
      return freshSnapshot.docs.map((doc) => _docToGame(doc)).toList();
    }

    return snapshot.docs.map((doc) => _docToGame(doc)).toList();
  }

  Future<void> _initializeDefaultGames() async {
    for (final game in gamesDatasource) {
      await _gamesCollection.add(_gameToMap(game));
    }
  }

  Future<void> insertGame(Game game) async {
    await _gamesCollection.add(_gameToMap(game));
  }

  Future<void> updateGame(Game game) async {
    await _gamesCollection.doc(game.id).update(_gameToMap(game));
  }

  Future<void> deleteGame(String id) async {
    await _gamesCollection.doc(id).delete();
  }

  Map<String, dynamic> _gameToMap(Game game) {
    return {
      'title': game.title,
      'releaseYear': game.releaseYear,
      'developer': game.developer,
      'description': game.description,
      'gameCover': game.gameCover,
    };
  }

  Game _docToGame(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Game(
      id: doc.id,
      title: data['title'] ?? '',
      releaseYear: data['releaseYear'] ?? '',
      developer: data['developer'] ?? '',
      description: data['description'] ?? '',
      gameCover: data['gameCover'] ?? '',
    );
  }
}
