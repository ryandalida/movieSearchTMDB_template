import 'package:flutter/material.dart';
import 'package:moviesearch_tmdb_template/providers/movie_provider.dart';
import 'package:moviesearch_tmdb_template/screens/movie_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        title: 'TheMovieDB.org Search',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MovieListScreen(),
      ),
    );
  }
}