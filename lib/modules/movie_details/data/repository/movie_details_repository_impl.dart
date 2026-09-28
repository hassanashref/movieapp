import '../datasource/movie_details_remote_datasource.dart';
import '../models/movie_details_model.dart';
import '../models/suggestion_model.dart';
import '../../domain/repository/movie_details_repository.dart';
class MovieDetailsRepositoryImpl
    implements MovieDetailsRepository {

  final MovieDetailsRemoteDataSource remote;

  MovieDetailsRepositoryImpl(this.remote);


  @override
  Future<MovieDetailsModel> getMovieDetails(
      String movieId) async {

    return await remote.getMovieDetails(movieId);
  }


  @override
  Future<List<SuggestionModel>> getSuggestions(
      String movieId) async {

    return await remote.getSuggestions(movieId);
  }
}