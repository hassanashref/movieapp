import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../modules/home/models/movie_model.dart';

class ProfileLocalService {
  static const String _favoritesKey = 'watchlist';
  static const String _historyKey = 'history';

  // ---------- Watchlist ----------
  static Future<List<MovieModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_favoritesKey) ?? [];
    return data
        .map((e) => MovieModel.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<bool> isFavorite(int movieId) async {
    final favorites = await getFavorites();
    return favorites.any((m) => m.id == movieId);
  }

  static Future<void> toggleFavorite(MovieModel movie) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_favoritesKey) ?? [];

    final index = data.indexWhere((e) {
      final decoded = jsonDecode(e);
      return decoded['id'] == movie.id;
    });

    if (index != -1) {
      data.removeAt(index);
    } else {
      data.add(jsonEncode(movie.toJson()));
    }

    await prefs.setStringList(_favoritesKey, data);
  }

  // ---------- History ----------
  static Future<List<MovieModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_historyKey) ?? [];
    return data
        .map((e) => MovieModel.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<void> addToHistory(MovieModel movie) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_historyKey) ?? [];

    data.removeWhere((e) {
      final decoded = jsonDecode(e);
      return decoded['id'] == movie.id;
    });

    data.insert(0, jsonEncode(movie.toJson()));

    if (data.length > 50) {
      data.removeRange(50, data.length);
    }

    await prefs.setStringList(_historyKey, data);
  }
}