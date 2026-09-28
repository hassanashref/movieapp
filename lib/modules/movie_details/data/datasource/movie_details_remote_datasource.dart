import '../models/movie_details_model.dart';
import '../models/suggestion_model.dart';


abstract class MovieDetailsRemoteDataSource {

  Future<MovieDetailsModel> getMovieDetails(
      String movieId
      );

  Future<List<SuggestionModel>> getSuggestions(
      String movieId
      );

}
