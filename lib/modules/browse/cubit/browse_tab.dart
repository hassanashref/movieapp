import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/app_colors.dart';
import '../../home/repository/movie_repository.dart'; // تمت الإضافة
import 'browse_cubit.dart';
import 'browse_state.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BrowseCubit(movieRepository: MovieRepository())
        ..loadGenres(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text('Browse'),
          elevation: 0,
        ),
        body: BlocBuilder<BrowseCubit, BrowseState>(
          builder: (context, state) {
            if (state is BrowseLoading || state is BrowseInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is BrowseError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final loaded = state as BrowseLoaded;
            final genresList = loaded.genres.toList();

            if (genresList.isEmpty) {
              return const Center(
                child: Text(
                  'No genres found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            return DefaultTabController(
              length: genresList.length,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    tabs: genresList
                        .map((genre) => Tab(text: genre))
                        .toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: genresList.map((genre) {
                        final movies = loaded.moviesByGenre(genre);
                        return _GenreMoviesGrid(movies: movies);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GenreMoviesGrid extends StatelessWidget {
  final List movies;

  const _GenreMoviesGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(
        child: Text(
          'No movies in this genre',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.6,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: movie.mediumCoverImage,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: AppColors.surface),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surface,
              child: const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }
}