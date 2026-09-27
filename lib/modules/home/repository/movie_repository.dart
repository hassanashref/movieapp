import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class MovieRepository {
  final Dio _dio = Dio();

  Future<List<MovieModel>> getMovies({int? limit, int? page}) async {
    try {
      final response = await _dio.get(
        'https://yts.gg/api/v2/list_movies.json',
        queryParameters: {
          'limit': limit ?? 20,
          'page': page ?? 1,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null && data['movies'] != null) {
          final List<dynamic> moviesJson = data['movies'];
          return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }
}