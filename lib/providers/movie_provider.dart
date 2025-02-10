import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moviesearch_tmdb_template/models/movie.dart';
import 'package:moviesearch_tmdb_template/models/genre.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _favorites = [];
  Map<int, String> _genres = {};
  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get movies => _movies;
  List<Movie> get favorites => _favorites;
  Map<int, String> get genres => _genres;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  MovieProvider() {
    fetchGenres();
    fetchMovies();
    loadFavorites();
  }

  Future<void> fetchMovies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _errorMessage = 'No internet connection';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final url =
        'https://api.themoviedb.org/3/movie/popular?api_key=4116c3c9523359000dc3427162460a65';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _movies = (data['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
        if (_movies.isEmpty) {
          _errorMessage = 'No movies found';
        }
      } else {
        _errorMessage = 'Failed to load movies';
      }
    } catch (e) {
      _errorMessage = 'Failed to load movies';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      fetchMovies();
      return;
    }
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _errorMessage = 'No internet connection';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=4116c3c9523359000dc3427162460a65&query=$query';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _movies = (data['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
        if (_movies.isEmpty) {
          _errorMessage = 'No movies found';
        }
      } else {
        _errorMessage = 'Failed to load movies';
      }
    } catch (e) {
      _errorMessage = 'Failed to load movies';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchGenres() async {
    final url =
        'https://api.themoviedb.org/3/genre/movie/list?api_key=4116c3c9523359000dc3427162460a65';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final genresList = (data['genres'] as List)
            .map((genreData) => Genre.fromJson(genreData))
            .toList();
        _genres = {for (var genre in genresList) genre.id: genre.name};
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      throw Exception('Failed to load genres');
    }
  }

  Future<void> loadFavorites() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'favorites.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE favorites (id INTEGER PRIMARY KEY, title TEXT, posterPath TEXT, overview TEXT, releaseDate TEXT, genres TEXT)',
        );
      },
    );

    final List<Map<String, dynamic>> maps = await database.query('favorites');
    _favorites = List.generate(maps.length, (i) {
      return Movie(
        id: maps[i]['id'],
        title: maps[i]['title'],
        posterPath: maps[i]['posterPath'],
        overview: maps[i]['overview'],
        releaseDate: maps[i]['releaseDate'],
        genreIds: maps[i]['genres'].split(',').map((e) => int.parse(e)).toList(),
      );
    });

    notifyListeners();
  }

  Future<void> toggleFavorite(Movie movie) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'favorites.db');

    final database = await openDatabase(path, version: 1);

    if (_favorites.any((fav) => fav.id == movie.id)) {
      await database.delete(
        'favorites',
        where: 'id = ?',
        whereArgs: [movie.id],
      );
      _favorites.removeWhere((fav) => fav.id == movie.id);
    } else {
      await database.insert(
        'favorites',
        {
          'id': movie.id,
          'title': movie.title,
          'posterPath': movie.posterPath,
          'overview': movie.overview,
          'releaseDate': movie.releaseDate,
          'genres': movie.genreIds.join(','),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _favorites.add(movie);
    }

    notifyListeners();
  }
}