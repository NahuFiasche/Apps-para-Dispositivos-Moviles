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
}
