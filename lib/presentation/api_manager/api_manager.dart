import 'package:movieapp/core/services_dio/api_constants.dart';
import 'package:movieapp/core/services_dio/network_service.dart';
import 'package:movieapp/presentation/api_manager/movie_respons.dart';

class ApiManager {
  /// Get movies for Available Now / Top Movies
  static Future<List<Movies>> getTopMovies({
    int limit = 20,
    int page = 1,
  }) async {
    try {
      final response = await NetworkService.get(
        endPoint: ApiConstants.listMovies,
        queryParameters: {
          ApiConstants.limitKey: limit,
          ApiConstants.pageKey: page,
          ApiConstants.sortByKey: "rating",
          ApiConstants.orderByKey: "desc",
        },
      );

      if (response.statusCode == 200) {
        final movieResponse = MovieRespons.fromJson(response.data);
        return movieResponse.data?.movies ?? [];
      }

      throw response.data?["status_message"] ?? "Failed to fetch top movies";
    } catch (e) {
      rethrow;
    }
  }

  /// Get Action movies
  static Future<List<Movies>> getActionMovies({
    int limit = 20,
    int page = 1,
  }) async {
    return getMoviesByGenre(
      genre: "action",
      limit: limit,
      page: page,
    );
  }

  /// Get movies filtered by genre
  static Future<List<Movies>> getMoviesByGenre({
    required String genre,
    int limit = 20,
    int page = 1,
    String sortBy = "rating",
    String orderBy = "desc",
  }) async {
    try {
      final response = await NetworkService.get(
        endPoint: ApiConstants.listMovies,
        queryParameters: {
          ApiConstants.limitKey: limit,
          ApiConstants.pageKey: page,
          ApiConstants.genreKey: genre,
          ApiConstants.sortByKey: sortBy,
          ApiConstants.orderByKey: orderBy,
        },
      );

      if (response.statusCode == 200) {
        final movieResponse = MovieRespons.fromJson(response.data);
        return movieResponse.data?.movies ?? [];
      }

      throw response.data?["status_message"] ??
          "Failed to fetch movies for genre: $genre";
    } catch (e) {
      rethrow;
    }
  }

   static Future<List<Movies>> searchMovies({
    required String query,
    int limit = 20,
    int page = 1,
    String? genre,
    String? sortBy,
    String? orderBy,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        ApiConstants.queryTermKey: query,
        ApiConstants.limitKey: limit,
        ApiConstants.pageKey: page,
      };

      if (genre != null && genre.isNotEmpty) {
        queryParams[ApiConstants.genreKey] = genre;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams[ApiConstants.sortByKey] = sortBy;
      }
      if (orderBy != null && orderBy.isNotEmpty) {
        queryParams[ApiConstants.orderByKey] = orderBy;
      }

      final response = await NetworkService.get(
        endPoint: ApiConstants.listMovies,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final movieResponse = MovieRespons.fromJson(response.data);
        return movieResponse.data?.movies ?? [];
      }

      throw response.data?["status_message"] ??
          "Failed to search movies for query: $query";
    } catch (e) {
      rethrow;
    }
  }

  /// Get movie details by ID
  static Future<Movies?> getMovieDetails(int movieId) async {
    try {
      final response = await NetworkService.get(
        endPoint: ApiConstants.movieDetails,
        queryParameters: {
          ApiConstants.movieIdKey: movieId,
          ApiConstants.withImagesKey: true,
          ApiConstants.withCastKey: true,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] != null) {
          final movieData = data['data']['movie'];
          if (movieData != null) {
            return Movies.fromJson(movieData);
          }
          final moviesList = data['data']['movies'];
          if (moviesList is List && moviesList.isNotEmpty) {
            return Movies.fromJson(moviesList.first);
          }
        }
        return null;
      }

      throw response.data?["status_message"] ??
          "Failed to fetch movie details for ID: $movieId";
    } catch (e) {
      rethrow;
    }
  }

  /// Get movie suggestions / related movies by movie ID
  static Future<List<Movies>> getMovieSuggestions(int movieId) async {
    try {
      final response = await NetworkService.get(
        endPoint: ApiConstants.movieSuggestions,
        queryParameters: {
          ApiConstants.movieIdKey: movieId,
        },
      );

      if (response.statusCode == 200) {
        final movieResponse = MovieRespons.fromJson(response.data);
        return movieResponse.data?.movies ?? [];
      }

      throw response.data?["status_message"] ??
          "Failed to fetch movie suggestions for ID: $movieId";
    } catch (e) {
      rethrow;
    }
  }

  /// Get recent / latest movies
  static Future<List<Movies>> getRecentMovies({
    int limit = 20,
    int page = 1,
  }) async {
    try {
      final response = await NetworkService.get(
        endPoint: ApiConstants.listMovies,
        queryParameters: {
          ApiConstants.limitKey: limit,
          ApiConstants.pageKey: page,
          ApiConstants.sortByKey: "year",
          ApiConstants.orderByKey: "desc",
        },
      );

      if (response.statusCode == 200) {
        final movieResponse = MovieRespons.fromJson(response.data);
        return movieResponse.data?.movies ?? [];
      }

      throw response.data?["status_message"] ?? "Failed to fetch recent movies";
    } catch (e) {
      rethrow;
    }
  }
}