class SuggestionModel {
  final String id;
  final String title;
  final String poster;
  final double rating;

  SuggestionModel({
    required this.id,
    required this.title,
    required this.poster,
    required this.rating,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      poster: json['large_cover_image'] ??
          json['medium_cover_image'] ??
          '',
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}