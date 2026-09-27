import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/modules/profile/cubit/profile_cubit.dart';
import 'package:movieapp/modules/profile/cubit/profile_state.dart';
import '../../../core/app_colors.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadProfile(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: const Text('Profile'),
            elevation: 0,
            bottom: const TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                Tab(text: 'Watchlist'),
                Tab(text: 'History'),
              ],
            ),
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is ProfileError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              final loaded = state as ProfileLoaded;

              return TabBarView(
                children: [
                  _MovieListView(
                    movies: loaded.watchlist,
                    emptyMessage: 'No movies in your watchlist yet',
                  ),
                  _MovieListView(
                    movies: loaded.history,
                    emptyMessage: 'No watch history yet',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MovieListView extends StatelessWidget {
  final List movies;
  final String emptyMessage;

  const _MovieListView({
    required this.movies,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: AppColors.textSecondary),
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