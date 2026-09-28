import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:movieapp/presentation/api_manager/api_manager.dart';
import 'package:movieapp/presentation/api_manager/movie_respons.dart';

class SearchProvider extends ChangeNotifier {
  List<Movies> searchResults = [];
  bool isLoading = false;
  String? errorMessage;
  String currentQuery = '';
  Timer? _debounce;

  void onSearchChanged(String query) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      _debounce?.cancel();
      searchResults = [];
      currentQuery = '';
      isLoading = false;
      errorMessage = null;
      notifyListeners();
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      searchMovies(trimmedQuery);
    });
  }

  Future<void> searchMovies(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    currentQuery = cleanQuery;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await ApiManager.searchMovies(query: cleanQuery);
      searchResults = results;
    } catch (e) {
      errorMessage = e.toString();
      searchResults = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _debounce?.cancel();
    searchResults.clear();
    currentQuery = '';
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
