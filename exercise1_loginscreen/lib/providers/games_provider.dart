import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exercise1_loginscreen/data/games_datasource.dart';

class GamesNotifier extends Notifier<List<Game>> {
  @override
  List<Game> build() {
    return gamesDatasource;
  }

  void addGame(Game newGame) {
    state = [...state, newGame];
  }

  void updateGame(Game updatedGame) {
    state = [
      for (final Game game in state)
        if (game.id == updatedGame.id) updatedGame else game,
    ];
  }

  void deleteGame(String id) {
    state = state.where((Game game) {
      return game.id != id;
    }).toList();
  }
}

final gamesProvider = NotifierProvider<GamesNotifier, List<Game>>(() {
  return GamesNotifier();
});
