import 'cast_model.dart';
class MovieDetailsModel {
  final String id;
  final String title;
  final String poster;
  final String year;
  final double rating;
  final String overview;
  final List<String> screenshots;
  final List<CastModel> cast;
  final List<String> genres;

  MovieDetailsModel({
    required this.id,
    required this.title,
    required this.poster,
    required this.year,
    required this.rating,
    required this.overview,
    required this.screenshots,
    required this.cast,
    required this.genres,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      poster: json['poster'] ?? '',
      year: json['year'].toString(),
      rating: (json['rating'] ?? 0).toDouble(),
      overview: json['overview'] ?? '',
      screenshots: List<String>.from(json['screenshots'] ?? []),
      cast: (json['cast'] as List? ?? [])
          .map((e) => CastModel.fromJson(e))
          .toList(),
      genres: List<String>.from(json['genres'] ?? []),
    );
  }
}