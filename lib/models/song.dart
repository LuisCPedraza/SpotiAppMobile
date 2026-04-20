import 'dart:convert';

class Song {
  Song({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String? releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  String get fullPosterImg {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return 'https://www.google.com.co/url?sa=i&url=https%3A%2F%2Fwww.legrand.com.kh%2Fen%2Fcatalog%2Fproducts%2Fcircuit-breaker-dmx-sp-4000-4-poles-draw-out-version-and-electronic-protection-unit-670277&psig=AOvVaw3sJitbva3qSYvicMpdkDQK&ust=1738352748424000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOi47eKanosDFQAAAAAdAAAAABAE';
  }

  String get fullBackdropPath {
    if (backdropPath != null) {
      return 'https://image.tmdb.org/t/p/w500$backdropPath';
    }
    return 'https://www.google.com.co/url?sa=i&url=https%3A%2F%2Fwww.legrand.com.kh%2Fen%2Fcatalog%2Fproducts%2Fcircuit-breaker-dmx-sp-4000-4-poles-draw-out-version-and-electronic-protection-unit-670277&psig=AOvVaw3sJitbva3qSYvicMpdkDQK&ust=1738352748424000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOi47eKanosDFQAAAAAdAAAAABAE';
  }

  factory Song.fromJson(String str) => Song.fromMap(json.decode(str));

  factory Song.fromMap(Map<String, dynamic> json) => Song(
    adult: json['adult'],
    backdropPath: json['backdrop_path'],
    genreIds: List<int>.from(json['genre_ids'].map((x) => x)),
    id: json['id'],
    originalLanguage: json['original_language'],
    originalTitle: json['original_title'],
    overview: json['overview'],
    popularity: json['popularity'].toDouble(),
    posterPath: json['poster_path'],
    releaseDate: json['release_date'],
    title: json['title'],
    video: json['video'],
    voteAverage: json['vote_average'].toDouble(),
    voteCount: json['vote_count'],
  );

  Map<String, dynamic> toMap() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'genre_ids': genreIds,
    'id': id,
    'original_language': originalLanguage,
    'original_title': originalTitle,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'release_date': releaseDate,
    'title': title,
    'video': video,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };
}
