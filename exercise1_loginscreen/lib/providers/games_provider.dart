import 'package:exercise1_loginscreen/database_helpers/games_database_helper.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamesNotifier extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() async {
    return await GamesDatabaseHelper.instance.getGames();
  }

  Future<void> addGame(Game newGame) async {
    state = await AsyncValue.guard(() async {
      final currentGamesList = state.value ?? [];

      int maxId = 0;
      for (final game in currentGamesList) {
        final parsedId = int.tryParse(game.id);
        if (parsedId != null && parsedId > maxId) {
          maxId = parsedId;
        }
      }
      final String newId = (maxId + 1).toString();

      newGame = newGame.copyWith(id: newId);

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
