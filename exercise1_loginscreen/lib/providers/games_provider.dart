import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exercise1_loginscreen/data/games_datasource.dart';

class GamesNotifier extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return gamesDatasource;
  }

  Future addGame(Game newGame) async {
    state = await AsyncValue.guard(() async {
      final currentList = state.value ?? [];
      return [...currentList, newGame];
    });
  }

  Future updateGame(Game updatedGame) async {
    state = await AsyncValue.guard(() async {
      final currentList = state.value ?? [];
      return [
        for (final game in currentList)
          if (game.id == updatedGame.id) updatedGame else game,
      ];
    });
  }

  Future deleteGame(String id) async {
    state = await AsyncValue.guard(() async {
      final currentList = state.value ?? [];
      return currentList.where((game) => game.id != id).toList();
    });
  }
}

final gamesProvider = AsyncNotifierProvider<GamesNotifier, List<Game>>(() {
  return GamesNotifier();
});
