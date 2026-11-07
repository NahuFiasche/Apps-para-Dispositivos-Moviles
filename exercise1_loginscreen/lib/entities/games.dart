class Game {
  final String id;
  final String title;
  final String releaseYear;
  final String developer;
  final String description;
  final String gameCover;

  Game({
    required this.id,
    required this.title,
    required this.releaseYear,
    required this.developer,
    required this.description,
    required this.gameCover,
  });

  Game copyWith({
    String? id,
    String? title,
    String? releaseYear,
    String? developer,
    String? description,
    String? gameCover,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      releaseYear: releaseYear ?? this.releaseYear,
      developer: developer ?? this.developer,
      description: description ?? this.description,
      gameCover: gameCover ?? this.gameCover,
    );
  }
}
