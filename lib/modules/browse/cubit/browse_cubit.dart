import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/repository/movie_repository.dart';
import 'browse_state.dart';

class BrowseCubit extends Cubit<BrowseState> {
  final MovieRepository movieRepository;

  BrowseCubit({required this.movieRepository}) : super(BrowseInitial());

  Future<void> loadGenres() async {
    emit(BrowseLoading());
    try {
      final movies = await movieRepository.getMovies(limit: 50);

      final Set<String> genres = {};
      for (var movie in movies) {
        genres.addAll(movie.genres);
      }

      emit(BrowseLoaded(genres: genres, allMovies: movies));
    } catch (e) {
      emit(BrowseError(e.toString()));
    }
  }
}