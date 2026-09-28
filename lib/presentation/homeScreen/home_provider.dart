import 'package:flutter/foundation.dart';
import 'package:movieapp/presentation/api_manager/api_manager.dart';
import 'package:movieapp/presentation/api_manager/movie_respons.dart';

class HomeProvider extends ChangeNotifier {
  List<Movies> topMovies = [];
  List<Movies> actionMovies = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> getHomeMovies() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        ApiManager.getTopMovies(),
        ApiManager.getActionMovies(),
      ]);

      topMovies = results[0];
      actionMovies = results[1];
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}