class MovieModel {
  final int id;
  final String title;
  final int year;
  final double rating;
  final List<String> genres;
  final String mediumCoverImage;
  final String largeCoverImage;
  final String summary;

  MovieModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.genres,
    required this.mediumCoverImage,
    required this.largeCoverImage,
    required this.summary,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      genres: json['genres'] != null
          ? List<String>.from(json['genres'])
          : [],
      mediumCoverImage: json['medium_cover_image'] ?? '',
      largeCoverImage: json['large_cover_image'] ?? '',
      summary: json['summary'] ?? 'No summary available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'rating': rating,
      'genres': genres,
      'medium_cover_image': mediumCoverImage,
      'large_cover_image': largeCoverImage,
      'summary': summary,
    };
  }
}