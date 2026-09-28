import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatefulWidget {
  final dynamic movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final Dio _dio = Dio();

  Map<String, dynamic>? movieDetails;
  List<dynamic> suggestions = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    try {
      final int movieId = int.parse(widget.movie.id.toString());

      final detailsResponse = await _dio.get(
        'https://yts.mx/api/v2/movie_details.json',
        queryParameters: {'movie_id': movieId},
      );

      final data = detailsResponse.data;

      if (data is! Map || data['data'] == null) {
        throw Exception('Invalid movie details response');
      }

      final movie = data['data']['movie'];

      if (movie == null) {
        throw Exception('Movie details not found');
      }

      List<dynamic> suggestionMovies = [];

      try {
        final suggestionsResponse = await _dio.get(
          'https://yts.mx/api/v2/movie_suggestions.json',
          queryParameters: {'movie_id': movieId},
        );

        final suggestionsData = suggestionsResponse.data;

        if (suggestionsData is Map &&
            suggestionsData['data'] is Map &&
            suggestionsData['data']['movies'] is List) {
          suggestionMovies = suggestionsData['data']['movies'];
        }
      } catch (_) {
        // Suggestions are optional.
      }

      if (!mounted) return;

      setState(() {
        movieDetails = Map<String, dynamic>.from(movie);
        suggestions = suggestionMovies;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Could not load movie details.';
      });
    }
  }

  String _stringValue(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  String _posterUrl() {
    final detailsPoster = _stringValue(movieDetails?['large_cover_image']);

    if (detailsPoster.isNotEmpty) {
      return detailsPoster;
    }

    final largePoster = _stringValue(widget.movie.largeCoverImage);

    if (largePoster.isNotEmpty) {
      return largePoster;
    }

    return _stringValue(widget.movie.mediumCoverImage);
  }

  String _title() {
    final title = _stringValue(movieDetails?['title']);

    if (title.isNotEmpty) {
      return title;
    }

    return _stringValue(widget.movie.title);
  }

  double _rating() {
    final value = movieDetails?['rating'] ?? widget.movie.rating ?? 0;

    return double.tryParse(value.toString()) ?? 0;
  }

  String _year() {
    final value = movieDetails?['year'] ?? widget.movie.year ?? '';

    return value.toString();
  }

  String _summary() {
    final fullDescription = _stringValue(movieDetails?['description_full']);

    if (fullDescription.isNotEmpty) {
      return fullDescription;
    }

    final description = _stringValue(movieDetails?['description']);

    if (description.isNotEmpty) {
      return description;
    }

    return _stringValue(widget.movie.summary);
  }

  List<String> _genres() {
    final genres = movieDetails?['genres'];

    if (genres is List) {
      return genres
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return [];
  }

  List<String> _screenshots() {
    final result = <String>[];

    for (int i = 1; i <= 3; i++) {
      final url = _stringValue(movieDetails?['medium_screenshot_image$i']);

      if (url.isNotEmpty) {
        result.add(url);
      }
    }

    return result;
  }

  List<dynamic> _cast() {
    final cast = movieDetails?['cast'];

    if (cast is List) {
      return cast;
    }

    return [];
  }

  String _trailerUrl() {
    final code = _stringValue(movieDetails?['yt_trailer_code']);

    if (code.isEmpty) {
      return '';
    }

    return 'https://www.youtube.com/watch?v=$code';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b0b0b),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xffffcf00)),
              )
            : errorMessage != null
            ? _buildError()
            : _buildDetails(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white70, size: 60),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadMovieDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffffcf00),
                foregroundColor: Colors.black,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    final poster = _posterUrl();
    final title = _title();
    final rating = _rating();
    final year = _year();
    final summary = _summary();
    final genres = _genres();
    final screenshots = _screenshots();
    final cast = _cast();
    final trailer = _trailerUrl();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: 470,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  poster,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xff242626),
                      child: const Icon(
                        Icons.movie_creation_outlined,
                        color: Colors.white38,
                        size: 70,
                      ),
                    );
                  },
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.35),
                        Colors.black.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xffffcf00),
                            size: 22,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 18),
                          if (year.isNotEmpty)
                            Text(
                              year,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 15,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (genres.isNotEmpty) ...[
                  const Text(
                    'Genres',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: genres.map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff242626),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          genre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                ],

                const Text(
                  'Story',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  summary.isEmpty ? 'No story available.' : summary,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 28),

                if (trailer.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Trailer is available on YouTube.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        'Watch Trailer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffffcf00),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                if (cast.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'Cast',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: cast.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final person = cast[index];

                        final name = _stringValue(person['name']);

                        final character = _stringValue(person['character']);

                        final image = _stringValue(person['url_small_image']);

                        return SizedBox(
                          width: 115,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  image,
                                  width: 115,
                                  height: 135,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      width: 115,
                                      height: 135,
                                      color: const Color(0xff242626),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white38,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                character,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],

                if (screenshots.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'Screenshots',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: screenshots.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            screenshots[index],
                            width: 285,
                            height: 190,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],

                if (suggestions.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'You May Also Like',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 210,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];

                        final suggestionPoster = _stringValue(
                          suggestion['medium_cover_image'],
                        );

                        final suggestionTitle = _stringValue(
                          suggestion['title'],
                        );

                        return SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  suggestionPoster,
                                  width: 130,
                                  height: 175,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                suggestionTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
