class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;
  final List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      genreIds: (json['genre_ids'] as List).map((e) => e as int).toList(),
    );
  }
}