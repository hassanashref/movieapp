import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/presentation/Widgets/movie_widget.dart';
import 'package:movieapp/presentation/search/search_provider.dart';
import 'package:movieapp/presentation/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121312),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Search Bar
              Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff282A28),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: provider.currentQuery.isNotEmpty
                            ? const Color(0xff0088FF)
                            : Colors.white24,
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      cursorColor: const Color(0xffffcf00),
                      onChanged: (query) => provider.onSearchChanged(query),
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        suffixIcon: provider.currentQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  provider.clearSearch();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Results Section
              Expanded(
                child: Consumer<SearchProvider>(
                  builder: (context, provider, child) {
                    // 1. Initial State: search box is empty
                    if (provider.currentQuery.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie_filter_outlined,
                              size: 80,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Type to search for any movie",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // 2. Loading State
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    // 3. Error State
                    if (provider.errorMessage != null &&
                        provider.searchResults.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.redAccent,
                                size: 50,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                provider.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () => provider.searchMovies(
                                  _searchController.text,
                                ),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // 4. No Results Found
                    if (provider.searchResults.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 70,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No movies found for "${provider.currentQuery}"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // 5. Grid View of Movies
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.searchResults.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final movie = provider.searchResults[index];
                        return MovieWidget(
                          movie: movie,
                          onTap: () {
                            print('Movie tapped: ${movie.id}');
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
