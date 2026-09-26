import '../../data/models/movie_details_model.dart';
import '../../data/models/suggestion_model.dart';
abstract class MovieDetailsRepository {

  Future<MovieDetailsModel> getMovieDetails(
      String movieId
      );

  Future<List<SuggestionModel>> getSuggestions(
      String movieId
      );
}