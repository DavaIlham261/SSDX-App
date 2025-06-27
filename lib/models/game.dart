class Game {
  final String name;
  final String genre;
  final String developer;
  final String releaseYear;
  final String description;
  final String size;
  final String exePath;
  final String folderPath;

  Game({
    required this.name,
    required this.genre,
    required this.developer,
    required this.releaseYear,
    required this.description,
    required this.size,
    required this.exePath,
    required this.folderPath,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'],
      genre: json['genre'],
      developer: json['developer'],
      releaseYear: json['release_year'],
      description: json['description'],
      size: json['size'],
      exePath: json['exe_path'],
      folderPath: json['folder_path'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'genre': genre,
      'developer': developer,
      'release_year': releaseYear,
      'description': description,
      'size': size,
      'exe_path': exePath,
      'folder_path': folderPath,
    };
  }
}
