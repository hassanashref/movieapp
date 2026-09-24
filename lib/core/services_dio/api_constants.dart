class ApiConstants {
  // Base URLs
  static const String baseUrl = "https://yts.gg/api/v2/";
  static const String apiKey = "ce9f1b4da94b4ce7bf4cccd5f5d5c026";

  // Endpoints
  static const String listMovies = "list_movies.json";
  static const String movieDetails = "movie_details.json";
  static const String movieSuggestions = "movie_suggestions.json";
  static const String movieParentalGuides = "movie_parental_guides.json";

  // Query Parameter Keys
  static const String limitKey = "limit";
  static const String pageKey = "page";
  static const String qualityKey = "quality";
  static const String minimumRatingKey = "minimum_rating";
  static const String queryTermKey = "query_term";
  static const String genreKey = "genre";
  static const String sortByKey = "sort_by";
  static const String orderByKey = "order_by";
  static const String withRtRatingsKey = "with_rt_ratings";
  static const String movieIdKey = "movie_id";
  static const String withImagesKey = "with_images";
  static const String withCastKey = "with_cast";

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
