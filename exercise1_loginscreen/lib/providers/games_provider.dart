import 'package:exercise1_loginscreen/helpers/games_database_helper.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamesNotifier extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() async {
    return await GamesDatabaseHelper.instance.getGames();
  }

  Future<void> addGame(Game newGame) async {
    state = await AsyncValue.guard(() async {
      await GamesDatabaseHelper.instance.insertGame(newGame);

      return await GamesDatabaseHelper.instance.getGames();
    });
  }

  Future updateGame(Game updatedGame) async {
    state = await AsyncValue.guard(() async {
      await GamesDatabaseHelper.instance.updateGame(updatedGame);

      return await GamesDatabaseHelper.instance.getGames();
    });
  }

  Future deleteGame(String id) async {
    state = await AsyncValue.guard(() async {
      await GamesDatabaseHelper.instance.deleteGame(id);
      return await GamesDatabaseHelper.instance.getGames();
    });
  }
}

final gamesProvider = AsyncNotifierProvider<GamesNotifier, List<Game>>(() {
  return GamesNotifier();
});
