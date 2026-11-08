class Game {
  final String id;
  final String title;
  final String releaseYear;
  final String releaseDate;
  final String developer;
  final String description;
  final String gameCover;
  final bool isPlayed;

  Game({
    required this.id,
    required this.title,
    required this.releaseYear,
    this.releaseDate = '',
    required this.developer,
    required this.description,
    required this.gameCover,
    this.isPlayed = false,
  });

  Game copyWith({
    String? id,
    String? title,
    String? releaseYear,
    String? releaseDate,
    String? developer,
    String? description,
    String? gameCover,
    bool? isPlayed,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      releaseYear: releaseYear ?? this.releaseYear,
      releaseDate: releaseDate ?? this.releaseDate,
      developer: developer ?? this.developer,
      description: description ?? this.description,
      gameCover: gameCover ?? this.gameCover,
      isPlayed: isPlayed ?? this.isPlayed,
    );
  }
}
