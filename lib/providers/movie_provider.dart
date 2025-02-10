import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moviesearch_tmdb_template/models/movie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _favorites = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  List<Movie> get favorites => _favorites;
  bool get isLoading => _isLoading;

  MovieProvider() {
    fetchMovies();
    loadFavorites();
  }

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    final url =
        'https://api.themoviedb.org/3/movie/popular?api_key=4116c3c9523359000dc3427162460a65';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _movies = (data['results'] as List)
          .map((movieData) => Movie.fromJson(movieData))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    notifyListeners();

    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=YOUR_API_KEY&query=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _movies = (data['results'] as List)
          .map((movieData) => Movie.fromJson(movieData))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }

    _isLoading = false;
    notifyListeners();
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
        genres: maps[i]['genres'].split(','),
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
          'genres': movie.genres.join(','),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _favorites.add(movie);
    }

    notifyListeners();
  }
}