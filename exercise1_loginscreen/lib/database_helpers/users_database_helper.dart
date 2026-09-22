import 'package:exercise1_loginscreen/data/users_datasource.dart';
import 'package:exercise1_loginscreen/entities/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UsersDatabaseHelper {
  UsersDatabaseHelper._init();

  static final UsersDatabaseHelper instance = UsersDatabaseHelper._init();

  static Database? _database;
  static const String _tableName = 'usersList';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase('users_database.db');
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
        mail TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        profilePicture TEXT
      )
    ''');

    for (final user in usersDatasource) {
      await database.insert(
        _tableName,
        _userToMap(user),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> addUser(User user) async {
    final database = await instance.database;
    await database.insert(
      _tableName,
      _userToMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsers() async {
    final database = await instance.database;
    final result = await database.query(_tableName);
    return result.map((map) => _mapToUser(map)).toList();
  }

  Future<void> updateUser(User user) async {
    final database = await instance.database;
    await database.update(
      _tableName,
      _userToMap(user),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(String id) async {
    final database = await instance.database;
    await database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _userToMap(User user) {
    return {
      'id': user.id,
      'mail': user.mail,
      'username': user.username,
      'password': user.password,
      //'profilePicture': user.profilePicture,
    };
  }

  User _mapToUser(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      mail: map['mail'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      //profilePicture: map['profilePicture'],
    );
  }
}
