import 'package:flutter/material.dart';
import 'package:movieapp/presentation/api_manager/movie_respons.dart';
import 'package:movieapp/presentation/screens/movie_details_screen.dart';

class MovieWidget extends StatelessWidget {
  final Movies movie;
  final VoidCallback? onTap;

  const MovieWidget({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    final posterUrl = movie.largeCoverImage ?? movie.mediumCoverImage ?? '';

    final rating = (movie.rating ?? 0.0).toDouble();

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailsScreen(movie: movie),
              ),
            );
          },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xff242626),
                  child: const Center(
                    child: Icon(
                      Icons.movie_creation_outlined,
                      color: Colors.white38,
                      size: 40,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  color: const Color(0xff242626),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xffffcf00),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xff121312).withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xffffcf00),
                      size: 14,
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
}
