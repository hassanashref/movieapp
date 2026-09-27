import '../../home/models/movie_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final List<MovieModel> watchlist;
  final List<MovieModel> history;

  ProfileLoaded({required this.watchlist, required this.history});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}