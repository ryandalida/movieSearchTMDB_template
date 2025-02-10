import 'package:flutter/material.dart';
import 'package:moviesearch_tmdb_template/models/movie.dart';
import 'package:moviesearch_tmdb_template/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Release Date: ${movie.releaseDate}',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Genres: ${movie.genres.join(', ')}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => movieProvider.toggleFavorite(movie),
        child: Icon(
          movieProvider.favorites.any((fav) => fav.id == movie.id)
              ? Icons.favorite
              : Icons.favorite_border,
        ),
      ),
    );
  }
}