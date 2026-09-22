import 'package:exercise1_loginscreen/data/games_datasource.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GamesDatabaseHelper {
  GamesDatabaseHelper._init();

  static final GamesDatabaseHelper instance = GamesDatabaseHelper._init();

  static Database? _database;
  static const String _tableName = 'gamesList';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase('games_database.db');
      return _database!;
    }
  }

  Future<Database> _initDatabase(String fileName) async {
    final databaseFolderPath = await getDatabasesPath();
    final databasePath = join(databaseFolderPath, fileName);

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database database, int version) async {
    await database.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        developer TEXT NOT NULL,
        releaseYear TEXT NOT NULL,
        plattform TEXT NOT NULL,
        description TEXT NOT NULL,
        gameCover TEXT,
        gameImages TEXT NOT NULL
      )
    ''');
    
    for (final game in gamesDatasource) {
      await database.insert(
        'gamesList',
        _gameToMap(game),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> insertGame(Game game) async {
    final database = await instance.database;
    await database.insert(
      _tableName,
      _gameToMap(game),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Game>> getGames() async {
    final database = await instance.database;
    final result = await database.query(_tableName);
    return result.map((map) => _mapToGame(map)).toList();
  }

  Future<void> updateGame(Game game) async {
    final database = await instance.database;
    await database.update(
      _tableName,
      _gameToMap(game),
      where: 'id = ?',
      whereArgs: [game.id],
    );
  }

  Future<void> deleteGame(String id) async {
    final database = await instance.database;
    await database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _gameToMap(Game game) {
    return {
      'id': game.id,
      'title': game.title,
      'developer': game.developer,
      'releaseYear': game.releaseYear,
      'plattform': game.plattform,
      'description': game.description,
      'gameCover': game.gameCover,
      'gameImages': game.gameImages.join(','),
    };
  }

  Game _mapToGame(Map<String, dynamic> map) {
    return Game(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      developer: map['developer'] ?? '',
      releaseYear: map['releaseYear'] ?? '',
      plattform: map['plattform'] ?? '',
      description: map['description'] ?? '',
      gameCover: map['gameCover'],
      gameImages:
          (map['gameImages'] as String?)
              ?.split(',')
              .where((e) => e.isNotEmpty)
              .toList() ??
          [],
    );
  }
}
