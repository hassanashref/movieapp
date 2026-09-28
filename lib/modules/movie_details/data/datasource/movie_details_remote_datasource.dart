import 'package:movieapp/core/services_dio/api_constants.dart';
import 'package:movieapp/core/services_dio/network_service.dart';

import '../models/movie_details_model.dart';
import '../models/suggestion_model.dart';

abstract class MovieDetailsRemoteDataSource {
  Future<MovieDetailsModel> getMovieDetails(String movieId);

  Future<List<SuggestionModel>> getSuggestions(String movieId);
}

class MovieDetailsRemoteDataSourceImpl
    implements MovieDetailsRemoteDataSource {
  @override
  Future<MovieDetailsModel> getMovieDetails(String movieId) async {
    final response = await NetworkService.get(
      endPoint: ApiConstants.movieDetails,
      queryParameters: {
        ApiConstants.movieIdKey: movieId,
        ApiConstants.withImagesKey: true,
        ApiConstants.withCastKey: true,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        response.data?['status_message'] ??
            'Failed to fetch movie details',
      );
    }

    final data = response.data;

    if (data is! Map<String, dynamic> ||
        data['data'] == null ||
        data['data']['movie'] == null) {
      throw Exception('Invalid movie details response');
    }

    final movieJson = Map<String, dynamic>.from(
      data['data']['movie'],
    );

    // Convert YTS API fields to the fields expected by MovieDetailsModel.
    final castJson = movieJson['cast'];

    if (castJson is List) {
      movieJson['cast'] = castJson.map((cast) {
        final castMap = Map<String, dynamic>.from(cast);

        return {
          'name': castMap['name'] ?? '',
          'character': castMap['character_name'] ?? '',
          'image': castMap['url_small_image'] ?? '',
        };
      }).toList();
    } else {
      movieJson['cast'] = [];
    }

    // Build screenshots from the YTS screenshot fields.
    movieJson['screenshots'] = [
      if (movieJson['medium_screenshot_image1'] != null)
        movieJson['medium_screenshot_image1'],
      if (movieJson['medium_screenshot_image2'] != null)
        movieJson['medium_screenshot_image2'],
      if (movieJson['medium_screenshot_image3'] != null)
        movieJson['medium_screenshot_image3'],
    ];

    // MovieDetailsModel uses "poster".
    movieJson['poster'] =
        movieJson['large_cover_image'] ??
            movieJson['medium_cover_image'] ??
            '';

    // MovieDetailsModel uses "overview".
    movieJson['overview'] =
        movieJson['description_full'] ??
            movieJson['summary'] ??
            '';

    return MovieDetailsModel.fromJson(movieJson);
  }

  @override
  Future<List<SuggestionModel>> getSuggestions(String movieId) async {
    final response = await NetworkService.get(
      endPoint: ApiConstants.movieSuggestions,
      queryParameters: {
        ApiConstants.movieIdKey: movieId,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        response.data?['status_message'] ??
            'Failed to fetch movie suggestions',
      );
    }

    final data = response.data;

    if (data is! Map<String, dynamic> ||
        data['data'] == null ||
        data['data']['movies'] == null) {
      return [];
    }

    final movies = data['data']['movies'];

    if (movies is! List) {
      return [];
    }

    return movies
        .map(
          (movie) => SuggestionModel.fromJson(
        Map<String, dynamic>.from(movie),
      ),
    )
        .toList();
  }
}