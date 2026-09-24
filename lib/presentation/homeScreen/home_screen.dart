import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movieapp/presentation/api_manager/movie_respons.dart';
import 'package:movieapp/presentation/homeScreen/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedNav = 0;
  int selectedMovieIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: selectedMovieIndex,
      viewportFraction: 0.55,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    if (provider.isLoading && provider.topMovies.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xff17191A),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xffffcf00),
          ),
        ),
      );
    }

    if (provider.errorMessage != null && provider.topMovies.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xff17191A),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  color: Color(0xffffcf00),
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => provider.getHomeMovies(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffcf00),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final topMovies = provider.topMovies;
    final actionMovies = provider.actionMovies;

    return Scaffold(
      backgroundColor: const Color(0xff17191A),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final s = w / 375;

            final currentSelectedMovie = (topMovies.isNotEmpty &&
                    selectedMovieIndex < topMovies.length)
                ? topMovies[selectedMovieIndex]
                : (topMovies.isNotEmpty ? topMovies[0] : null);

            final currentBgUrl = currentSelectedMovie?.largeCoverImage ??
                currentSelectedMovie?.backgroundImageOriginal ??
                currentSelectedMovie?.mediumCoverImage;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Top Carousel Section
                  SizedBox(
                    height: 470 * s,
                    width: w,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        // Dynamic Smooth Background Image
                        Positioned.fill(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: currentBgUrl != null &&
                                    currentBgUrl.isNotEmpty
                                ? Image.network(
                                    currentBgUrl,
                                    key: ValueKey<String>(currentBgUrl),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      'assets/images/movie6.png',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/movie6.png',
                                    key: const ValueKey<String>('default_bg'),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          ),
                        ),
                        // Dark Gradient Overlay for rich contrast
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.65),
                                  Colors.black.withValues(alpha: 0.85),
                                  Colors.black,
                                ],
                                stops: const [0.0, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                        // "Available Now" Logo
                        Positioned(
                          top: 10 * s,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Image.asset(
                              'assets/images/available_now.png',
                              width: 165 * s,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Horizontal Interactive PageView Carousel
                        if (topMovies.isNotEmpty)
                          Positioned(
                            top: 65 * s,
                            left: 0,
                            right: 0,
                            bottom: 10 * s,
                            child: PageView.builder(
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: topMovies.length,
                              onPageChanged: (index) {
                                setState(() {
                                  selectedMovieIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return AnimatedBuilder(
                                  animation: _pageController,
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (_pageController
                                        .position.haveDimensions) {
                                      final page = _pageController.page ??
                                          _pageController.initialPage
                                              .toDouble();
                                      value = (page - index);
                                      value = (1 - (value.abs() * 0.22))
                                          .clamp(0.78, 1.0);
                                    } else {
                                      value = (index == selectedMovieIndex)
                                          ? 1.0
                                          : 0.82;
                                    }

                                    final isSelected =
                                        index == selectedMovieIndex;

                                    return Center(
                                      child: SizedBox(
                                        height: Curves.easeOut.transform(value) *
                                            (310 * s),
                                        width: Curves.easeOut.transform(value) *
                                            (190 * s),
                                        child: AnimatedOpacity(
                                          duration: const Duration(
                                              milliseconds: 200),
                                          opacity: isSelected ? 1.0 : 0.65,
                                          child: child,
                                        ),
                                      ),
                                    );
                                  },
                                  child: _topPoster(
                                    movie: topMovies[index],
                                    radius: 18 * s,
                                    index: index,
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Action Movies & Watch Section
                  Container(
                    width: double.infinity,
                    color: Colors.black,
                    padding: EdgeInsets.fromLTRB(18 * s, 10 * s, 18 * s, 0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/watch_now.png',
                          width: 225 * s,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 14 * s),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Action',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15 * s,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('See More Movies'),
                                    duration: Duration(milliseconds: 700),
                                  ),
                                );
                              },
                              child: Text(
                                'See More >',
                                style: TextStyle(
                                  color: const Color(0xffffcf00),
                                  fontSize: 13 * s,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12 * s),
                        // Action Movies List (Horizontal)
                        SizedBox(
                          height: 160 * s,
                          child: actionMovies.isEmpty
                              ? Center(
                                  child: provider.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Color(0xffffcf00),
                                        )
                                      : const Text(
                                          'No action movies found',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                )
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: actionMovies.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 10 * s),
                                  itemBuilder: (context, index) {
                                    return _watchPoster(
                                      movie: actionMovies[index],
                                      width: 105 * s,
                                      height: 152 * s,
                                      radius: 10 * s,
                                      index: index,
                                    );
                                  },
                                ),
                        ),
                        SizedBox(height: 16 * s),
                        // Bottom Navigation Bar
                        Container(
                          height: 62 * s,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xff242626),
                            borderRadius: BorderRadius.circular(12 * s),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _navItem(
                                icon: Icons.home_rounded,
                                index: 0,
                                scale: s,
                              ),
                              _navItem(
                                icon: Icons.search_rounded,
                                index: 1,
                                scale: s,
                              ),
                              _navItem(
                                icon: Icons.movie_outlined,
                                index: 2,
                                scale: s,
                              ),
                              _navItem(
                                icon: Icons.person_outline_rounded,
                                index: 3,
                                scale: s,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20 * s),
                      ],
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

  Widget _topPoster({
    required Movies movie,
    required double radius,
    required int index,
  }) {
    final rating = movie.rating?.toStringAsFixed(1) ?? '0.0';
    final imageUrl = movie.largeCoverImage ?? movie.mediumCoverImage;

    return GestureDetector(
      onTap: () {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/movie6.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset('assets/images/movie6.png', fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rating,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Image.asset(
                    'assets/images/star.png',
                    width: 11,
                    height: 11,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.star,
                      color: Color(0xffffcf00),
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _watchPoster({
    required Movies movie,
    required double width,
    required double height,
    required double radius,
    required int index,
  }) {
    final rating = movie.rating?.toStringAsFixed(1) ?? '0.0';
    final imageUrl = movie.mediumCoverImage ?? movie.largeCoverImage;

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(movie.title ?? 'Movie selected'),
            duration: const Duration(milliseconds: 600),
          ),
        );
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/movie6.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset('assets/images/movie6.png', fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.60),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Image.asset(
                      'assets/images/star.png',
                      width: 9,
                      height: 9,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.star,
                        color: Color(0xffffcf00),
                        size: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required int index,
    required double scale,
  }) {
    final active = selectedNav == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedNav = index;
        });
      },
      borderRadius: BorderRadius.circular(30 * scale),
      child: SizedBox(
        width: 45 * scale,
        height: 45 * scale,
        child: Center(
          child: Icon(
            icon,
            size: 21 * scale,
            color: active ? const Color(0xffffd400) : Colors.white,
          ),
        ),
      ),
    );
  }
}
