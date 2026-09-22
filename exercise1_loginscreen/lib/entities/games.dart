class Game {
  final String id;
  final String title;
  final String developer;
  final String releaseYear;
  final String plattform;
  final String description;
  final String? gameCover;
  final List<String> gameImages;

  Game({
    required this.id,
    required this.title,
    required this.developer,
    required this.releaseYear,
    required this.plattform,
    required this.description,
    required this.gameCover,
    required this.gameImages,
  });

  Game copyWith({
    String? id,
    String? title,
    String? developer,
    String? releaseYear,
    String? plattform,
    String? description,
    String? gameCover,
    List<String>? gameImages,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      developer: developer ?? this.developer,
      releaseYear: releaseYear ?? this.releaseYear,
      plattform: plattform ?? this.plattform,
      description: description ?? this.description,
      gameCover: gameCover ?? this.gameCover,
      gameImages: gameImages ?? this.gameImages,
    );
  }
}
