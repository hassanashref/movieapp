import '../../home/models/movie_model.dart';

abstract class BrowseState {}

class BrowseInitial extends BrowseState {}

class BrowseLoading extends BrowseState {}

class BrowseLoaded extends BrowseState {
  final Set<String> genres;
  final List<MovieModel> allMovies;

  BrowseLoaded({required this.genres, required this.allMovies});

  List<MovieModel> moviesByGenre(String genre) {
    return allMovies.where((m) => m.genres.contains(genre)).toList();
  }
}

class BrowseError extends BrowseState {
  final String message;
  BrowseError(this.message);
}